/*
 * Copyright 2017 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Instruments all indirect calls so that they work even if a function
// pointer was cast incorrectly. For example, if you cast an int (int, float)
// to an int (int, float, int) and call it natively, on most archs it will
// happen to work, ignoring the extra param, whereas in wasm it will trap.
// When porting code that relies on such casts working (like e.g. Python),
// this pass may be useful. It sets a new "ABI" for indirect calls, in which
// they all return an i64 and they have a fixed number of i64 params, and
// the pass converts everything to go through that.
//
// This should work even with dynamic linking, however, the number of
// params must be identical, i.e., the "ABI" must match.

#include <wasm.h>
#include <wasm-builder.h>
#include <asm_v_wasm.h>
#include <pass.h>
#include <wasm-emscripten.h>
#include <ir/literal-utils.h>

namespace wasm {

// This should be enough for everybody. (As described above, we need this
// to match when dynamically linking, and also dynamic linking is why we
// can't just detect this automatically in the module we see.)
static const int NUM_PARAMS = 15;

// Converts a value to the ABI type of i64.
static Expression* toABI(Expression* value, Module* module) {
  Builder builder(*module);
  switch (value->type) {
    case i32: {
      value = builder.makeUnary(ExtendUInt32, value);
      break;
    }
    case i64: {
      // already good
      break;
    }
    case f32: {
      value = builder.makeUnary(
        ExtendUInt32,
        builder.makeUnary(ReinterpretFloat32, value)
      );
      break;
    }
    case f64: {
      value = builder.makeUnary(ReinterpretFloat64, value);
      break;
    }
    case none: {
      // the value is none, but we need a value here
      value = builder.makeSequence(
        value,
        LiteralUtils::makeZero(i64, *module)
      );
      break;
    }
    case unreachable: {
      // can leave it, the call isn't taken anyhow
      break;
    }
    default: {
      // SIMD may be interesting some day
      WASM_UNREACHABLE();
    }
  }
  return value;
}

// Converts a value from the ABI type of i64 to the expected type
static Expression* fromABI(Expression* value, Type type, Module* module) {
  Builder builder(*module);
  switch (type) {
    case i32: {
      value = builder.makeUnary(WrapInt64, value);
      break;
    }
    case i64: {
      // already good
      break;
    }
    case f32: {
      value = builder.makeUnary(
        ReinterpretInt32,
        builder.makeUnary(WrapInt64, value)
      );
      break;
    }
    case f64: {
      value = builder.makeUnary(ReinterpretInt64, value);
      break;
    }
    case none: {
      value = builder.makeDrop(value);
    }
    case unreachable: {
      // can leave it, the call isn't taken anyhow
      break;
    }
    default: {
      // SIMD may be interesting some day
      WASM_UNREACHABLE();
    }
  }
  return value;
}

struct ParallelFuncCastEmulation : public WalkerPass<PostWalker<ParallelFuncCastEmulation>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ParallelFuncCastEmulation(ABIType); }

  ParallelFuncCastEmulation(Name ABIType) : ABIType(ABIType) {}

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->operands.size() > NUM_PARAMS) {
      Fatal() << "FuncCastEmulation::NUM_PARAMS needs to be at least " <<
                 curr->operands.size();
    }
    for (Expression*& operand : curr->operands) {
      operand = toABI(operand, getModule());
    }
    // Add extra operands as needed.
    while (curr->operands.size() < NUM_PARAMS) {
      curr->operands.push_back(LiteralUtils::makeZero(i64, *getModule()));
    }
    // Set the new types
    curr->fullType = ABIType;
    auto oldType = curr->type;
    curr->type = i64;
    curr->finalize(); // may be unreachable
    // Fix up return value
    replaceCurrent(fromABI(curr, oldType, getModule()));
  }

private:
  // the name of a type for a call with the right params and return
  Name ABIType;
};

struct FuncCastEmulation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // we just need the one ABI function type for all indirect calls
    std::string sig = "j";
    for (Index i = 0; i < NUM_PARAMS; i++) {
      sig += 'j';
    }
    ABIType = ensureFunctionType(sig, module)->name;
    // Add a way for JS to call into the table (as our i64 ABI means an i64
    // is returned when there is a return value, which JS engines will fail on),
    // using dynCalls
    EmscriptenGlueGenerator generator(*module);
    generator.generateDynCallThunks();
    // Add a thunk for each function in the table, and do the call through it.
    std::unordered_map<Name, Name> funcThunks;
    for (auto& segment : module->table.segments) {
      for (auto& name : segment.data) {
        auto iter = funcThunks.find(name);
        if (iter == funcThunks.end()) {
          auto thunk = makeThunk(name, module);
          funcThunks[name] = thunk;
          name = thunk;
        } else {
          name = iter->second;
        }
      }
    }
    // update call_indirects
    PassRunner subRunner(module, runner->options);
    subRunner.setIsNested(true);
    subRunner.add<ParallelFuncCastEmulation>(ABIType);
    subRunner.run();
  }

private:
  // the name of a type for a call with the right params and return
  Name ABIType;

  // Creates a thunk for a function, casting args and return value as needed.
  Name makeThunk(Name name, Module* module) {
    Name thunk = std::string("byn$fpcast-emu$") + name.str;
    if (module->getFunctionOrNull(thunk)) {
      Fatal() << "FuncCastEmulation::makeThunk seems a thunk name already in use. Was the pass already run on this code?";
    }
    // The item in the table may be a function or a function import.
    auto* func = module->getFunction(name);
    std::vector<Type>& params = func->params;
    Type type = func->result;
    Builder builder(*module);
    std::vector<Expression*> callOperands;
    for (Index i = 0; i < params.size(); i++) {
      callOperands.push_back(fromABI(builder.makeGetLocal(i, i64), params[i], module));
    }
    auto* call = builder.makeCall(name, callOperands, type);
    std::vector<Type> thunkParams;
    for (Index i = 0; i < NUM_PARAMS; i++) {
      thunkParams.push_back(i64);
    }
    auto* thunkFunc = builder.makeFunction(
      thunk,
      std::move(thunkParams),
      i64,
      {}, // no vars
      toABI(call, module)
    );
    thunkFunc->type = ABIType;
    module->addFunction(thunkFunc);
    return thunk;
  }
};

Pass* createFuncCastEmulationPass() {
  return new FuncCastEmulation();
}

} // namespace wasm
