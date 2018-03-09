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
#include <pass.h>
#include <ir/literal-utils.h>

namespace wasm {

// This should be enough for everybody. (As described above, we need this
// to match when dynamically linking, and also dynamic linking is why we
// can't just detect this automatically in the module we see.)
static const int NUM_PARAMS = 10;

struct FuncCastEmulation : public WalkerPass<PostWalker<FuncCastEmulation>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FuncCastEmulation(); }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->operands.size() > NUM_PARAMS) {
      Fatal() << "FuncCastEmulation::NUM_PARAMS needs to be at least " <<
                 curr->operands.size();
    }
    for (Expression*& operand : curr->operands) {
      operand = toABI(operand);
    }
    // Add extra operands as needed.
    while (curr->operands.size() < NUM_PARAMS) {
      curr->operands.push_back(LiteralUtils::makeZero(i64, *getModule()));
    }
    // Fix up return value
    replaceCurrent(fromABI(curr));
  }

  void visitTable(Table* curr) {
    // Add a thunk for each function in the table, and do the call through it.
    std::unordered_map<Name, Name> funcThunks;
    for (auto& segment : curr->segments) {
      for (auto& name : segment->data) {
        auto iter = funcThunks.find(name);
        if (iter == funcThunks.end()) {
          auto thunk = makeThunk(name);
          funcThunks[name] = thunk;
          name = thunk;
        } else {
          name = iter.second;
        }
      }
    }
  }

private:
  // Creates a thunk for a function, casting args and return value as needed.
  Name makeThunk(Name name) {
    Name thunk = std::string("byn$fpcast-emu$") + name;
    if (getModule()->getFuncOrNull(thunk)) {
      Fatal() << "FuncCastEmulation::makeThunk seems a thunk name already in use. Was the pass already run on this code?";
    }
    Builder builder(*getModule());
    std::vector<Type> thunkParams;
    std::vector<Expression*> callOperands;
    for (Index i = 0; i < NUM_PARAMS; i++) {
      thunkParams.push_back(i64);
      callOperands.push_back(fromABI(builder.makeGetLocal(i)));
    }
    auto* call = builder.makeCall(name, callOperands, getModule()->getFunction(name)->result);
    getModule()->addFunction(builder.makeFunction(
      thunk,
      thunkParams,
      i64,
      {}, // no vars
      toABI(call)
    ));
    return thunk;
  }

  // Converts a value to the ABI type of i64.
  Expression* toABI(Expression* value) {
    Builder builder(*getModule());
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

  // Converts a value from the ABI type of i64.
  Expression* fromABI(Expression* value) {
    Builder builder(*getModule());
    switch (value->type) {
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
};

Pass* createFuncCastEmulationPass() {
  return new FuncCastEmulation();
}

} // namespace wasm
