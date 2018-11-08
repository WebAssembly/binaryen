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
#include "ir/branch-utils.h"

namespace wasm {

// shared constants

Name WASM("wasm"),
     RETURN_FLOW("*return:)*");

namespace BinaryConsts {
namespace UserSections {
const char* Name = "name";
const char* SourceMapUrl = "sourceMappingURL";

const char* Dylink = "dylink";
}
}

Name GROW_WASM_MEMORY("__growWasmMemory"),
     MEMORY_BASE("__memory_base"),
     TABLE_BASE("__table_base"),
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
    case Expression::Id::AtomicCmpxchgId: return "atomic_cmpxchg";
    case Expression::Id::AtomicRMWId: return "atomic_rmw";
    case Expression::Id::AtomicWaitId: return "atomic_wait";
    case Expression::Id::AtomicWakeId: return "atomic_wake";
    default: WASM_UNREACHABLE();
  }
}

// core AST type checking

struct TypeSeeker : public PostWalker<TypeSeeker> {
  Expression* target; // look for this one
  Name targetName;
  std::vector<Type> types;


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

static Type mergeTypes(std::vector<Type>& types) {
  Type type = unreachable;
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
static void handleUnreachable(Block* block, bool breakabilityKnown=false, bool hasBreak=false) {
  if (block->type == unreachable) return; // nothing to do
  if (block->list.size() == 0) return; // nothing to do
  // if we are concrete, stop - even an unreachable child
  // won't change that (since we have a break with a value,
  // or the final child flows out a value)
  if (isConcreteType(block->type)) return;
  // look for an unreachable child
  for (auto* child : block->list) {
    if (child->type == unreachable) {
      // there is an unreachable child, so we are unreachable, unless we have a break
      if (!breakabilityKnown) {
        hasBreak = BranchUtils::BranchSeeker::hasNamed(block, block->name);
      }
      if (!hasBreak) {
        block->type = unreachable;
      }
      return;
    }
  }
}

void Block::finalize() {
  if (!name.is()) {
    if (list.size() > 0) {
      // nothing branches here, so this is easy
      // normally the type is the type of the final child
      type = list.back()->type;
      // and even if we have an unreachable child somewhere,
      // we still mark ourselves as having that type,
      // (block (result i32)
      //  (return)
      //  (i32.const 10)
      // )
      if (isConcreteType(type)) return;
      // if we are unreachable, we are done
      if (type == unreachable) return;
      // we may still be unreachable if we have an unreachable
      // child
      for (auto* child : list) {
        if (child->type == unreachable) {
          type = unreachable;
          return;
        }
      }
    } else {
      type = none;
    }
    return;
  }

  TypeSeeker seeker(this, this->name);
  type = mergeTypes(seeker.types);
  handleUnreachable(this);
}

void Block::finalize(Type type_) {
  type = type_;
  if (type == none && list.size() > 0) {
    handleUnreachable(this);
  }
}

void Block::finalize(Type type_, bool hasBreak) {
  type = type_;
  if (type == none && list.size() > 0) {
    handleUnreachable(this, true, hasBreak);
  }
}

void If::finalize(Type type_) {
  type = type_;
  if (type == none && (condition->type == unreachable || (ifFalse && ifTrue->type == unreachable && ifFalse->type == unreachable))) {
    type = unreachable;
  }
}

void If::finalize() {
  if (ifFalse) {
    if (ifTrue->type == ifFalse->type) {
      type = ifTrue->type;
    } else if (isConcreteType(ifTrue->type) && ifFalse->type == unreachable) {
      type = ifTrue->type;
    } else if (isConcreteType(ifFalse->type) && ifTrue->type == unreachable) {
      type = ifFalse->type;
    } else {
      type = none;
    }
  } else {
    type = none; // if without else
  }
  // if the arms return a value, leave it even if the condition
  // is unreachable, we still mark ourselves as having that type, e.g.
  // (if (result i32)
  //  (unreachable)
  //  (i32.const 10)
  //  (i32.const 20
  // )
  // otherwise, if the condition is unreachable, so is the if
  if (type == none && condition->type == unreachable) {
    type = unreachable;
  }
}

void Loop::finalize(Type type_) {
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
  finalize(); // type may need to be unreachable
}

void SetLocal::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  } else if (isTee()) {
    type = value->type;
  } else {
    type = none;
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

void AtomicRMW::finalize() {
  if (ptr->type == unreachable || value->type == unreachable) {
    type = unreachable;
  }
}

void AtomicCmpxchg::finalize() {
  if (ptr->type == unreachable || expected->type == unreachable || replacement->type == unreachable) {
    type = unreachable;
  }
}

void AtomicWait::finalize() {
  type = i32;
  if (ptr->type == unreachable || expected->type == unreachable || timeout->type == unreachable) {
    type = unreachable;
  }
}

void AtomicWake::finalize() {
  type = i32;
  if (ptr->type == unreachable || wakeCount->type == unreachable) {
    type = unreachable;
  }
}

Const* Const::set(Literal value_) {
  value = value_;
  type = value.type;
  return this;
}

void Const::finalize() {
  type = value.type;
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
    case ExtendS8Int32: case ExtendS16Int32: type = i32; break;
    case ExtendSInt32: case ExtendUInt32: case ExtendS8Int64: case ExtendS16Int64: case ExtendS32Int64: type = i64; break;
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
    case CurrentMemory: {
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
  return localNames.find(index) != localNames.end();
}

Name Function::getLocalName(Index index) {
  return localNames.at(index);
}

Name Function::getLocalNameOrDefault(Index index) {
  auto nameIt = localNames.find(index);
  if (nameIt != localNames.end()) {
    return nameIt->second;
  }
  // this is an unnamed local
  return Name();
}

Name Function::getLocalNameOrGeneric(Index index) {
  auto nameIt = localNames.find(index);
  if (nameIt != localNames.end()) {
    return nameIt->second;
  }
  return Name::fromInt(index);
}

Index Function::getLocalIndex(Name name) {
  auto iter = localIndices.find(name);
  if (iter == localIndices.end()) {
    Fatal() << "Function::getLocalIndex: " << name << " does not exist";
  }
  return iter->second;
}

Index Function::getVarIndexBase() {
  return params.size();
}

Type Function::getLocalType(Index index) {
  if (isParam(index)) {
    return params[index];
  } else if (isVar(index)) {
    return vars[index - getVarIndexBase()];
  } else {
    WASM_UNREACHABLE();
  }
}

FunctionType* Module::getFunctionType(Name name) {
  auto iter = functionTypesMap.find(name);
  if (iter == functionTypesMap.end()) {
    Fatal() << "Module::getFunctionType: " << name << " does not exist";
  }
  return iter->second;
}

Export* Module::getExport(Name name) {
  auto iter = exportsMap.find(name);
  if (iter == exportsMap.end()) {
    Fatal() << "Module::getExport: " << name << " does not exist";
  }
  return iter->second;
}

Function* Module::getFunction(Name name) {
  auto iter = functionsMap.find(name);
  if (iter == functionsMap.end()) {
    Fatal() << "Module::getFunction: " << name << " does not exist";
  }
  return iter->second;
}

Global* Module::getGlobal(Name name) {
  auto iter = globalsMap.find(name);
  if (iter == globalsMap.end()) {
    Fatal() << "Module::getGlobal: " << name << " does not exist";
  }
  return iter->second;
}

FunctionType* Module::getFunctionTypeOrNull(Name name) {
  auto iter = functionTypesMap.find(name);
  if (iter == functionTypesMap.end()) {
    return nullptr;
  }
  return iter->second;
}

Export* Module::getExportOrNull(Name name) {
  auto iter = exportsMap.find(name);
  if (iter == exportsMap.end()) {
    return nullptr;
  }
  return iter->second;
}

Function* Module::getFunctionOrNull(Name name) {
  auto iter = functionsMap.find(name);
  if (iter == functionsMap.end()) {
    return nullptr;
  }
  return iter->second;
}

Global* Module::getGlobalOrNull(Name name) {
  auto iter = globalsMap.find(name);
  if (iter == globalsMap.end()) {
    return nullptr;
  }
  return iter->second;
}

void Module::addFunctionType(FunctionType* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addFunctionType: empty name";
  }
  if (getFunctionTypeOrNull(curr->name)) {
    Fatal() << "Module::addFunctionType: " << curr->name << " already exists";
  }
  functionTypes.push_back(std::unique_ptr<FunctionType>(curr));
  functionTypesMap[curr->name] = curr;
}

void Module::addExport(Export* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addExport: empty name";
  }
  if (getExportOrNull(curr->name)) {
    Fatal() << "Module::addExport: " << curr->name << " already exists";
  }
  exports.push_back(std::unique_ptr<Export>(curr));
  exportsMap[curr->name] = curr;
}

void Module::addFunction(Function* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addFunction: empty name";
  }
  if (getFunctionOrNull(curr->name)) {
    Fatal() << "Module::addFunction: " << curr->name << " already exists";
  }
  functions.push_back(std::unique_ptr<Function>(curr));
  functionsMap[curr->name] = curr;
}

void Module::addGlobal(Global* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addGlobal: empty name";
  }
  if (getGlobalOrNull(curr->name)) {
    Fatal() << "Module::addGlobal: " << curr->name << " already exists";
  }
  globals.push_back(std::unique_ptr<Global>(curr));
  globalsMap[curr->name] = curr;
}

void Module::addStart(const Name& s) {
  start = s;
}

void Module::removeFunctionType(Name name) {
  for (size_t i = 0; i < functionTypes.size(); i++) {
    if (functionTypes[i]->name == name) {
      functionTypes.erase(functionTypes.begin() + i);
      break;
    }
  }
  functionTypesMap.erase(name);
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

void Module::removeFunction(Name name) {
  for (size_t i = 0; i < functions.size(); i++) {
    if (functions[i]->name == name) {
      functions.erase(functions.begin() + i);
      break;
    }
  }
  functionsMap.erase(name);
}

void Module::removeGlobal(Name name) {
  for (size_t i = 0; i < globals.size(); i++) {
    if (globals[i]->name == name) {
      globals.erase(globals.begin() + i);
      break;
    }
  }
  globalsMap.erase(name);
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
