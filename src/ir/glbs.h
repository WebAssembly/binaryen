/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_ir_glbs_h
#define wasm_ir_glbs_h

#include "ir/module-utils.h"
#include "wasm.h"

namespace wasm {

//
// Similar to LUBFinder, but for GLBs.
//
struct GLBFinder {
  GLBFinder() {}

  GLBFinder(Type initialType) { note(initialType); }

  // Note another type to take into account in the GLB.
  void note(Type type) {
    // We only compute GLBs of concrete types in our IR.
    assert(type != Type::none);

    if (type != Type::unreachable) {
      if (glb == Type::unreachable) {
        // This is the first thing we see.
        glb = type;
      } else {
        glb = Type::getGreatestLowerBound(glb, type);
        // If the result is unreachable, when neither of the inputs was, then we
        // have combined things from different hierarchies, which we do not
        // allow here: We focus on computing GLBs for concrete places in our IR.
        assert(glb != Type::unreachable);
      }
    }
  }

  // Returns whether we noted any (reachable) value.
  bool noted() { return glb != Type::unreachable; }

  // Returns the GLB.
  Type getGLB() { return glb; }

  // Combines the information in another GLBFinder into this one, and returns
  // whether we changed anything.
  bool combine(const GLBFinder& other) {
    // Check if the GLB was changed.
    auto old = glb;
    note(other.glb);
    return old != glb;
  }

private:
  // The greatest lower bound. As we go this always contains the latest value
  // based on everything we've seen so far.
  Type glb = Type::unreachable;
};

} // namespace wasm

#endif // wasm_ir_glbs_h
