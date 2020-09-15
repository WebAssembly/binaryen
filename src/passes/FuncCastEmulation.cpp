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
//

#include <asm_v_wasm.h>
#include <ir/literal-utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// This should be enough for everybody. (As described above, we need this
// to match when dynamically linking, and also dynamic linking is why we
// can't just detect this automatically in the module we see.)
static const int NUM_PARAMS = 16;

// Converts a value to the ABI type of i64.
static Expression* toABI(Expression* value, Module* module) {
  Builder builder(*module);
  switch (value->type.getBasic()) {
    case Type::i32: {
      value = builder.makeUnary(ExtendUInt32, value);
      break;
    }
    case Type::i64: {
      // already good
      break;
    }
    case Type::f32: {
      value = builder.makeUnary(ExtendUInt32,
                                builder.makeUnary(ReinterpretFloat32, value));
      break;
    }
    case Type::f64: {
      value = builder.makeUnary(ReinterpretFloat64, value);
      break;
    }
    case Type::v128: {
      WASM_UNREACHABLE("v128 not implemented yet");
    }
    case Type::funcref:
    case Type::externref:
    case Type::exnref:
    case Type::anyref: {
      WASM_UNREACHABLE("reference types cannot be converted to i64");
    }
    case Type::none: {
      // the value is none, but we need a value here
      value =
        builder.makeSequence(value, LiteralUtils::makeZero(Type::i64, *module));
      break;
    }
    case Type::unreachable: {
      // can leave it, the call isn't taken anyhow
      break;
    }
  }
  return value;
}

// Converts a value from the ABI type of i64 to the expected type
static Expression* fromABI(Expression* value, Type type, Module* module) {
  Builder builder(*module);
  switch (type.getBasic()) {
    case Type::i32: {
      value = builder.makeUnary(WrapInt64, value);
      break;
    }
    case Type::i64: {
      // already good
      break;
    }
    case Type::f32: {
      value = builder.makeUnary(ReinterpretInt32,
                                builder.makeUnary(WrapInt64, value));
      break;
    }
    case Type::f64: {
      value = builder.makeUnary(ReinterpretInt64, value);
      break;
    }
    case Type::v128: {
      WASM_UNREACHABLE("v128 not implemented yet");
    }
    case Type::funcref:
    case Type::externref:
    case Type::exnref:
    case Type::anyref: {
      WASM_UNREACHABLE("reference types cannot be converted from i64");
    }
    case Type::none: {
      value = builder.makeDrop(value);
    }
    case Type::unreachable: {
      // can leave it, the call isn't taken anyhow
      break;
    }
  }
  return value;
}

struct ParallelFuncCastEmulation
  : public WalkerPass<PostWalker<ParallelFuncCastEmulation>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ParallelFuncCastEmulation(ABIType); }

  ParallelFuncCastEmulation(Signature ABIType) : ABIType(ABIType) {}

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->operands.size() > NUM_PARAMS) {
      Fatal() << "FuncCastEmulation::NUM_PARAMS needs to be at least "
              << curr->operands.size();
    }
    for (Expression*& operand : curr->operands) {
      operand = toABI(operand, getModule());
    }
    // Add extra operands as needed.
    while (curr->operands.size() < NUM_PARAMS) {
      curr->operands.push_back(LiteralUtils::makeZero(Type::i64, *getModule()));
    }
    // Set the new types
    curr->sig = ABIType;
    auto oldType = curr->type;
    curr->type = Type::i64;
    curr->finalize(); // may be unreachable
    // Fix up return value
    replaceCurrent(fromABI(curr, oldType, getModule()));
  }

private:
  // The signature of a call with the right params and return
  Signature ABIType;
};

struct FuncCastEmulation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // we just need the one ABI function type for all indirect calls
    Signature ABIType(Type(std::vector<Type>(NUM_PARAMS, Type::i64)),
                      Type::i64);
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
    ParallelFuncCastEmulation(ABIType).run(runner, module);
  }

private:
  // Creates a thunk for a function, casting args and return value as needed.
  Name makeThunk(Name name, Module* module) {
    Name thunk = std::string("byn$fpcast-emu$") + name.str;
    if (module->getFunctionOrNull(thunk)) {
      Fatal() << "FuncCastEmulation::makeThunk seems a thunk name already in "
                 "use. Was the pass already run on this code?";
    }
    // The item in the table may be a function or a function import.
    auto* func = module->getFunction(name);
    Type type = func->sig.results;
    Builder builder(*module);
    std::vector<Expression*> callOperands;
    Index i = 0;
    for (const auto& param : func->sig.params) {
      callOperands.push_back(
        fromABI(builder.makeLocalGet(i++, Type::i64), param, module));
    }
    auto* call = builder.makeCall(name, callOperands, type);
    std::vector<Type> thunkParams;
    for (Index i = 0; i < NUM_PARAMS; i++) {
      thunkParams.push_back(Type::i64);
    }
    auto* thunkFunc =
      builder.makeFunction(thunk,
                           Signature(Type(thunkParams), Type::i64),
                           {}, // no vars
                           toABI(call, module));
    module->addFunction(thunkFunc);
    return thunk;
  }
};

Pass* createFuncCastEmulationPass() { return new FuncCastEmulation(); }

} // namespace wasm
