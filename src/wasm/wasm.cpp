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
const char* SourceMapUrl = "sourceMappingURL";
}
}

Name GROW_WASM_MEMORY("__growWasmMemory"),
     MEMORY_BASE("memoryBase"),
     TABLE_BASE("tableBase"),
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

// Expressions

const char* getExpressionName(Expression* curr) {
  switch (curr->_id) {
    case Expression::Id::InvalidId: WASM_UNREACHABLE();
    case Expression::Id::BlockId: return "block";
    case Expression::Id::IfId: return "if";
    case Expression::Id::LoopId: return "loop";
    case Expression::Id::BreakId: return "break";
    case Expression::Id::SwitchId: return "switch";
    case Expression::Id::CallId: return "call";
    case Expression::Id::CallImportId: return "call_import";
    case Expression::Id::CallIndirectId: return "call_indirect";
    case Expression::Id::GetLocalId: return "get_local";
    case Expression::Id::SetLocalId: return "set_local";
    case Expression::Id::GetGlobalId: return "get_global";
    case Expression::Id::SetGlobalId: return "set_global";
    case Expression::Id::LoadId: return "load";
    case Expression::Id::StoreId: return "store";
    case Expression::Id::ConstId: return "const";
    case Expression::Id::UnaryId: return "unary";
    case Expression::Id::BinaryId: return "binary";
    case Expression::Id::SelectId: return "select";
    case Expression::Id::DropId: return "drop";
    case Expression::Id::ReturnId: return "return";
    case Expression::Id::HostId: return "host";
    case Expression::Id::NopId: return "nop";
    case Expression::Id::UnreachableId: return "unreachable";
    default: WASM_UNREACHABLE();
  }
}

// core AST type checking

struct TypeSeeker : public PostWalker<TypeSeeker> {
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

// a block is unreachable if one of its elements is unreachable,
// and there are no branches to it
static void handleUnreachable(Block* block) {
  if (block->type == unreachable) return; // nothing to do
  for (auto* child : block->list) {
    if (child->type == unreachable) {
      // there is an unreachable child, so we are unreachable, unless we have a break
      BreakSeeker seeker(block->name);
      Expression* expr = block;
      seeker.walk(expr);
      if (!seeker.found) {
        block->type = unreachable;
      } else {
        block->type = seeker.valueType;
      }
      return;
    }
  }
}

void Block::finalize(WasmType type_) {
  type = type_;
  if (type == none && list.size() > 0) {
    handleUnreachable(this);
  }
}

void Block::finalize() {
  if (!name.is()) {
    // nothing branches here, so this is easy
    if (list.size() > 0) {
      // if we have an unreachable child, we are unreachable
      // (we don't need to recurse into children, they can't
      // break to us)
      for (auto* child : list) {
        if (child->type == unreachable) {
          type = unreachable;
          return;
        }
      }
      // children are reachable, so last element determines type
      type = list.back()->type;
    } else {
      type = none;
    }
    return;
  }

  TypeSeeker seeker(this, this->name);
  type = mergeTypes(seeker.types);
  handleUnreachable(this);
}

void If::finalize(WasmType type_) {
  type = type_;
  if (type == none && (condition->type == unreachable || (ifFalse && ifTrue->type == unreachable && ifFalse->type == unreachable))) {
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

void Break::finalize() {
  if (condition) {
    if (condition->type == unreachable) {
      type = unreachable;
    } else if (value) {
      type = value->type;
    } else {
      type = none;
    }
  } else {
    type = unreachable;
  }
}

void Switch::finalize() {
  type = unreachable;
}

template<typename T>
void handleUnreachableOperands(T* curr) {
  for (auto* child : curr->operands) {
    if (child->type == unreachable) {
      curr->type = unreachable;
      break;
    }
  }
}

void Call::finalize() {
  handleUnreachableOperands(this);
}

void CallImport::finalize() {
  handleUnreachableOperands(this);
}

void CallIndirect::finalize() {
  handleUnreachableOperands(this);
  if (target->type == unreachable) {
    type = unreachable;
  }
}

bool FunctionType::structuralComparison(FunctionType& b) {
  if (result != b.result) return false;
  if (params.size() != b.params.size()) return false;
  for (size_t i = 0; i < params.size(); i++) {
    if (params[i] != b.params[i]) return false;
  }
  return true;
}

bool FunctionType::operator==(FunctionType& b) {
  if (name != b.name) return false;
  return structuralComparison(b);
}
bool FunctionType::operator!=(FunctionType& b) {
  return !(*this == b);
}

bool SetLocal::isTee() {
  return type != none;
}

void SetLocal::setTee(bool is) {
  if (is) type = value->type;
  else type = none;
}

void SetLocal::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  }
}

void SetGlobal::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  }
}

void Load::finalize() {
  if (ptr->type == unreachable) {
    type = unreachable;
  }
}

void Store::finalize() {
  assert(valueType != none); // must be set
  if (ptr->type == unreachable || value->type == unreachable) {
    type = unreachable;
  } else {
    type = none;
  }
}

Const* Const::set(Literal value_) {
  value = value_;
  type = value.type;
  return this;
}

bool Unary::isRelational() {
  return op == EqZInt32 || op == EqZInt64;
}

void Unary::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
    return;
  }
  switch (op) {
    case ClzInt32:
    case CtzInt32:
    case PopcntInt32:
    case NegFloat32:
    case AbsFloat32:
    case CeilFloat32:
    case FloorFloat32:
    case TruncFloat32:
    case NearestFloat32:
    case SqrtFloat32:
    case ClzInt64:
    case CtzInt64:
    case PopcntInt64:
    case NegFloat64:
    case AbsFloat64:
    case CeilFloat64:
    case FloorFloat64:
    case TruncFloat64:
    case NearestFloat64:
    case SqrtFloat64: type = value->type; break;
    case EqZInt32:
    case EqZInt64: type = i32; break;
    case ExtendSInt32: case ExtendUInt32: type = i64; break;
    case WrapInt64: type = i32; break;
    case PromoteFloat32: type = f64; break;
    case DemoteFloat64: type = f32; break;
    case TruncSFloat32ToInt32:
    case TruncUFloat32ToInt32:
    case TruncSFloat64ToInt32:
    case TruncUFloat64ToInt32:
    case ReinterpretFloat32: type = i32; break;
    case TruncSFloat32ToInt64:
    case TruncUFloat32ToInt64:
    case TruncSFloat64ToInt64:
    case TruncUFloat64ToInt64:
    case ReinterpretFloat64: type = i64; break;
    case ReinterpretInt32:
    case ConvertSInt32ToFloat32:
    case ConvertUInt32ToFloat32:
    case ConvertSInt64ToFloat32:
    case ConvertUInt64ToFloat32: type = f32; break;
    case ReinterpretInt64:
    case ConvertSInt32ToFloat64:
    case ConvertUInt32ToFloat64:
    case ConvertSInt64ToFloat64:
    case ConvertUInt64ToFloat64: type = f64; break;
    default: std::cerr << "waka " << op << '\n'; WASM_UNREACHABLE();
  }
}

bool Binary::isRelational() {
  switch (op) {
    case EqFloat64:
    case NeFloat64:
    case LtFloat64:
    case LeFloat64:
    case GtFloat64:
    case GeFloat64:
    case EqInt32:
    case NeInt32:
    case LtSInt32:
    case LtUInt32:
    case LeSInt32:
    case LeUInt32:
    case GtSInt32:
    case GtUInt32:
    case GeSInt32:
    case GeUInt32:
    case EqInt64:
    case NeInt64:
    case LtSInt64:
    case LtUInt64:
    case LeSInt64:
    case LeUInt64:
    case GtSInt64:
    case GtUInt64:
    case GeSInt64:
    case GeUInt64:
    case EqFloat32:
    case NeFloat32:
    case LtFloat32:
    case LeFloat32:
    case GtFloat32:
    case GeFloat32: return true;
    default: return false;
  }
}

void Binary::finalize() {
  assert(left && right);
  if (left->type == unreachable || right->type == unreachable) {
    type = unreachable;
  } else if (isRelational()) {
    type = i32;
  } else {
    type = left->type;
  }
}

void Select::finalize() {
  assert(ifTrue && ifFalse);
  if (ifTrue->type == unreachable || ifFalse->type == unreachable || condition->type == unreachable) {
    type = unreachable;
  } else {
    type = ifTrue->type;
  }
}

void Drop::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  } else {
    type = none;
  }
}

void Host::finalize() {
  switch (op) {
    case PageSize: case CurrentMemory: case HasFeature: {
      type = i32;
      break;
    }
    case GrowMemory: {
      // if the single operand is not reachable, so are we
      if (operands[0]->type == unreachable) {
        type = unreachable;
      } else {
        type = i32;
      }
      break;
    }
    default: WASM_UNREACHABLE();
  }
}

size_t Function::getNumParams() {
  return params.size();
}

size_t Function::getNumVars() {
  return vars.size();
}

size_t Function::getNumLocals() {
  return params.size() + vars.size();
}

bool Function::isParam(Index index) {
  return index < params.size();
}

bool Function::isVar(Index index) {
  return index >= params.size();
}

bool Function::hasLocalName(Index index) const {
  return index < localNames.size() && localNames[index].is();
}

Name Function::getLocalName(Index index) {
  assert(hasLocalName(index));
  return localNames[index];
}

Name Function::getLocalNameOrDefault(Index index) {
  if (hasLocalName(index)) {
    return localNames[index];
  }
  // this is an unnamed local
  return Name();
}

Index Function::getLocalIndex(Name name) {
  assert(localIndices.count(name) > 0);
  return localIndices[name];
}

Index Function::getVarIndexBase() {
  return params.size();
}

WasmType Function::getLocalType(Index index) {
  if (isParam(index)) {
    return params[index];
  } else if (isVar(index)) {
    return vars[index - getVarIndexBase()];
  } else {
    WASM_UNREACHABLE();
  }
}

FunctionType* Module::getFunctionType(Name name) {
  assert(functionTypesMap.count(name));
  return functionTypesMap[name];
}

Import* Module::getImport(Name name) {
  assert(importsMap.count(name));
  return importsMap[name];
}

Export* Module::getExport(Name name) {
  assert(exportsMap.count(name));
  return exportsMap[name];
}

Function* Module::getFunction(Name name) {
  assert(functionsMap.count(name));
  return functionsMap[name];
}

Global* Module::getGlobal(Name name) {
  assert(globalsMap.count(name));
  return globalsMap[name];
}

FunctionType* Module::getFunctionTypeOrNull(Name name) {
  if (!functionTypesMap.count(name))
    return nullptr;
  return functionTypesMap[name];
}

Import* Module::getImportOrNull(Name name) {
  if (!importsMap.count(name))
    return nullptr;
  return importsMap[name];
}

Export* Module::getExportOrNull(Name name) {
  if (!exportsMap.count(name))
    return nullptr;
  return exportsMap[name];
}

Function* Module::getFunctionOrNull(Name name) {
  if (!functionsMap.count(name))
    return nullptr;
  return functionsMap[name];
}

Global* Module::getGlobalOrNull(Name name) {
  if (!globalsMap.count(name))
    return nullptr;
  return globalsMap[name];
}

void Module::addFunctionType(FunctionType* curr) {
  assert(curr->name.is());
  functionTypes.push_back(std::unique_ptr<FunctionType>(curr));
  assert(functionTypesMap.find(curr->name) == functionTypesMap.end());
  functionTypesMap[curr->name] = curr;
}

void Module::addImport(Import* curr) {
  assert(curr->name.is());
  imports.push_back(std::unique_ptr<Import>(curr));
  assert(importsMap.find(curr->name) == importsMap.end());
  importsMap[curr->name] = curr;
}

void Module::addExport(Export* curr) {
  assert(curr->name.is());
  exports.push_back(std::unique_ptr<Export>(curr));
  assert(exportsMap.find(curr->name) == exportsMap.end());
  exportsMap[curr->name] = curr;
}

void Module::addFunction(Function* curr) {
  assert(curr->name.is());
  functions.push_back(std::unique_ptr<Function>(curr));
  assert(functionsMap.find(curr->name) == functionsMap.end());
  functionsMap[curr->name] = curr;
}

void Module::addGlobal(Global* curr) {
  assert(curr->name.is());
  globals.push_back(std::unique_ptr<Global>(curr));
  assert(globalsMap.find(curr->name) == globalsMap.end());
  globalsMap[curr->name] = curr;
}

void Module::addStart(const Name& s) {
  start = s;
}

void Module::removeImport(Name name) {
  for (size_t i = 0; i < imports.size(); i++) {
    if (imports[i]->name == name) {
      imports.erase(imports.begin() + i);
      break;
    }
  }
  importsMap.erase(name);
}

void Module::removeExport(Name name) {
  for (size_t i = 0; i < exports.size(); i++) {
    if (exports[i]->name == name) {
      exports.erase(exports.begin() + i);
      break;
    }
  }
  exportsMap.erase(name);
}

  // TODO: remove* for other elements

void Module::updateMaps() {
  functionsMap.clear();
  for (auto& curr : functions) {
    functionsMap[curr->name] = curr.get();
  }
  functionTypesMap.clear();
  for (auto& curr : functionTypes) {
    functionTypesMap[curr->name] = curr.get();
  }
  importsMap.clear();
  for (auto& curr : imports) {
    importsMap[curr->name] = curr.get();
  }
  exportsMap.clear();
  for (auto& curr : exports) {
    exportsMap[curr->name] = curr.get();
  }
  globalsMap.clear();
  for (auto& curr : globals) {
    globalsMap[curr->name] = curr.get();
  }
}

} // namespace wasm
