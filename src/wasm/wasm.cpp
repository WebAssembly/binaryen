/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include "wasm.h"
#include "wasm-traversal.h"
#include "ast_utils.h"

namespace wasm {

// shared constants

Name WASM("wasm"),
     RETURN_FLOW("*return:)*");

namespace BinaryConsts {
namespace UserSections {
const char* Name = "name";
}
}

Name GROW_WASM_MEMORY("__growWasmMemory"),
     NEW_SIZE("newSize"),
     MODULE("module"),
     START("start"),
     FUNC("func"),
     PARAM("param"),
     RESULT("result"),
     MEMORY("memory"),
     DATA("data"),
     SEGMENT("segment"),
     EXPORT("export"),
     IMPORT("import"),
     TABLE("table"),
     ELEM("elem"),
     LOCAL("local"),
     TYPE("type"),
     CALL("call"),
     CALL_IMPORT("call_import"),
     CALL_INDIRECT("call_indirect"),
     BLOCK("block"),
     BR_IF("br_if"),
     THEN("then"),
     ELSE("else"),
     _NAN("NaN"),
     _INFINITY("Infinity"),
     NEG_INFINITY("-infinity"),
     NEG_NAN("-nan"),
     CASE("case"),
     BR("br"),
     ANYFUNC("anyfunc"),
     FAKE_RETURN("fake_return_waka123"),
     MUT("mut"),
     SPECTEST("spectest"),
     PRINT("print"),
     EXIT("exit");

// core AST type checking

struct TypeSeeker : public PostWalker<TypeSeeker, Visitor<TypeSeeker>> {
  Expression* target; // look for this one
  Name targetName;
  std::vector<WasmType> types;

  TypeSeeker(Expression* target, Name targetName) : target(target), targetName(targetName) {
    Expression* temp = target;
    walk(temp);
  }

  void visitBreak(Break* curr) {
    if (curr->name == targetName) {
      types.push_back(curr->value ? curr->value->type : none);
    }
  }

  void visitSwitch(Switch* curr) {
    for (auto name : curr->targets) {
      if (name == targetName) types.push_back(curr->value ? curr->value->type : none);
    }
    if (curr->default_ == targetName) types.push_back(curr->value ? curr->value->type : none);
  }

  void visitBlock(Block* curr) {
    if (curr == target) {
      if (curr->list.size() > 0) {
        types.push_back(curr->list.back()->type);
      } else {
        types.push_back(none);
      }
    } else if (curr->name == targetName) {
      types.clear(); // ignore all breaks til now, they were captured by someone with the same name
    }
  }

  void visitLoop(Loop* curr) {
    if (curr == target) {
      types.push_back(curr->body->type);
    } else if (curr->name == targetName) {
      types.clear(); // ignore all breaks til now, they were captured by someone with the same name
    }
  }
};

static WasmType mergeTypes(std::vector<WasmType>& types) {
  WasmType type = unreachable;
  for (auto other : types) {
    // once none, stop. it then indicates a poison value, that must not be consumed
    // and ignore unreachable
    if (type != none) {
      if (other == none) {
        type = none;
      } else if (other != unreachable) {
        if (type == unreachable) {
          type = other;
        } else if (type != other) {
          type = none; // poison value, we saw multiple types; this should not be consumed
        }
      }
    }
  }
  return type;
}

void Block::finalize(WasmType type_) {
  type = type_;
  if (type == none && list.size() > 0) {
    if (list.back()->type == unreachable) {
      if (!BreakSeeker::has(this, name)) {
        type = unreachable; // the last element is unreachable, and this block truly cannot be exited, so it is unreachable itself
      }
    }
  }
}

void Block::finalize() {
  if (!name.is()) {
    // nothing branches here, so this is easy
    if (list.size() > 0) {
      type = list.back()->type;
    } else {
      type = unreachable;
    }
    return;
  }

  TypeSeeker seeker(this, this->name);
  type = mergeTypes(seeker.types);
}

void If::finalize(WasmType type_) {
  type = type_;
  if (type == none && (condition->type == unreachable || (ifTrue->type == unreachable && (!ifFalse || ifFalse->type == unreachable)))) {
    type = unreachable;
  }
}

void If::finalize() {
  if (condition->type == unreachable) {
    type = unreachable;
  } else if (ifFalse) {
    if (ifTrue->type == ifFalse->type) {
      type = ifTrue->type;
    } else if (isConcreteWasmType(ifTrue->type) && ifFalse->type == unreachable) {
      type = ifTrue->type;
    } else if (isConcreteWasmType(ifFalse->type) && ifTrue->type == unreachable) {
      type = ifFalse->type;
    } else {
      type = none;
    }
  } else {
    type = none; // if without else
  }
}

void Loop::finalize(WasmType type_) {
  type = type_;
  if (type == none && body->type == unreachable) {
    type = unreachable;
  }
}

void Loop::finalize() {
  type = body->type;
}

} // namespace wasm
