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
// Hoists repeated constants to a local. A local.get takes 2 bytes
// in most cases, and if a const is larger than that, it may be
// better to store it to a local, then get it from that local.
//
// WARNING: this often shrinks code size, but can *increase* gzip
//          size. apparently having the constants in their proper
//          places lets them be compressed better, across
//          functions, etc. TODO investigate
// TODO: hoisting a zero does not even require an initial set!
// TODO: hoisting a float or double zero is especially beneficial as there
//       is no LEB compression for them, and no need for the set, so
//       each f32.const is 5 bytes and f64.const is 9 bytes, while it is
//       <= 1 byte to declare the local and 2-3 to use it!
//

#include <map>

#include <pass.h>
#include <wasm-binary.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// with fewer uses than this, it is never beneficial to hoist
static const Index MIN_USES = 2;

struct ConstHoisting : public WalkerPass<PostWalker<ConstHoisting>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ConstHoisting; }

  std::map<Literal, std::vector<Expression**>> uses;

  void visitConst(Const* curr) {
    uses[curr->value].push_back(getCurrentPointer());
  }

  void visitFunction(Function* curr) {
    std::vector<Expression*> prelude;
    for (auto& pair : uses) {
      auto value = pair.first;
      auto& vec = pair.second;
      auto num = vec.size();
      if (worthHoisting(value, num)) {
        prelude.push_back(hoist(vec));
      }
    }
    if (!prelude.empty()) {
      Builder builder(*getModule());
      // merge-blocks can optimize this into a single block later in most cases
      curr->body = builder.makeSequence(builder.makeBlock(prelude), curr->body);
    }
  }

private:
  bool worthHoisting(Literal value, Index num) {
    if (num < MIN_USES) {
      return false;
    }
    // measure the size of the constant
    Index size = 0;
    TODO_SINGLE_COMPOUND(value.type);
    switch (value.type.getBasic()) {
      case Type::i32: {
        size = getWrittenSize(S32LEB(value.geti32()));
        break;
      }
      case Type::i64: {
        size = getWrittenSize(S64LEB(value.geti64()));
        break;
      }
      case Type::f32:
      case Type::f64: {
        size = value.type.getByteSize();
        break;
      }
        // not implemented yet
      case Type::v128:
      case Type::funcref:
      case Type::externref:
      case Type::exnref:
      case Type::anyref: {
        return false;
      }
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    // compute the benefit, of replacing the uses with
    // one use + a set and then a get for each use
    // doing the algebra, the criterion here is when
    //   size > 2(1+num)/(num-1)
    // or
    //   num > (size+2)/(size-2)
    auto before = num * size;
    auto after = size + 2 /* local.set */ + (2 /* local.get */ * num);
    return after < before;
  }

  template<typename T> Index getWrittenSize(const T& thing) {
    BufferWithRandomAccess buffer;
    buffer << thing;
    return buffer.size();
  }

  // replace all the uses with gets, for a local set at the top. returns
  // the set.
  Expression* hoist(std::vector<Expression**>& vec) {
    auto type = (*(vec[0]))->type;
    Builder builder(*getModule());
    auto temp = builder.addVar(getFunction(), type);
    auto* ret = builder.makeLocalSet(temp, *(vec[0]));
    for (auto item : vec) {
      *item = builder.makeLocalGet(temp, type);
    }
    return ret;
  }
};

Pass* createConstHoistingPass() { return new ConstHoisting(); }

} // namespace wasm
