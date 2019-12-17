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
#include "ir/branch-utils.h"
#include "wasm-traversal.h"

namespace wasm {

// shared constants

Name WASM("wasm");
Name RETURN_FLOW("*return:)*");

namespace BinaryConsts {
namespace UserSections {
const char* Name = "name";
const char* SourceMapUrl = "sourceMappingURL";
const char* Dylink = "dylink";
const char* Linking = "linking";
const char* Producers = "producers";
const char* TargetFeatures = "target_features";
const char* AtomicsFeature = "atomics";
const char* BulkMemoryFeature = "bulk-memory";
const char* ExceptionHandlingFeature = "exception-handling";
const char* MutableGlobalsFeature = "mutable-globals";
const char* TruncSatFeature = "nontrapping-fptoint";
const char* SignExtFeature = "sign-ext";
const char* SIMD128Feature = "simd128";
const char* TailCallFeature = "tail-call";
const char* ReferenceTypesFeature = "reference-types";
} // namespace UserSections
} // namespace BinaryConsts

Name GROW_WASM_MEMORY("__growWasmMemory");
Name WASM_CALL_CTORS("__wasm_call_ctors");
Name MEMORY_BASE("__memory_base");
Name TABLE_BASE("__table_base");
Name STACK_POINTER("__stack_pointer");
Name GET_TEMP_RET0("getTempRet0");
Name SET_TEMP_RET0("setTempRet0");
Name NEW_SIZE("newSize");
Name MODULE("module");
Name START("start");
Name FUNC("func");
Name PARAM("param");
Name RESULT("result");
Name MEMORY("memory");
Name DATA("data");
Name PASSIVE("passive");
Name EXPORT("export");
Name IMPORT("import");
Name TABLE("table");
Name ELEM("elem");
Name LOCAL("local");
Name TYPE("type");
Name CALL("call");
Name CALL_INDIRECT("call_indirect");
Name BLOCK("block");
Name BR_IF("br_if");
Name THEN("then");
Name ELSE("else");
Name _NAN("NaN");
Name _INFINITY("Infinity");
Name NEG_INFINITY("-infinity");
Name NEG_NAN("-nan");
Name CASE("case");
Name BR("br");
Name FUNCREF("funcref");
Name FAKE_RETURN("fake_return_waka123");
Name MUT("mut");
Name SPECTEST("spectest");
Name PRINT("print");
Name EXIT("exit");
Name SHARED("shared");
Name EVENT("event");
Name ATTR("attr");

// Expressions

const char* getExpressionName(Expression* curr) {
  switch (curr->_id) {
    case Expression::Id::InvalidId:
      WASM_UNREACHABLE("invalid expr id");
    case Expression::Id::BlockId:
      return "block";
    case Expression::Id::IfId:
      return "if";
    case Expression::Id::LoopId:
      return "loop";
    case Expression::Id::BreakId:
      return "break";
    case Expression::Id::SwitchId:
      return "switch";
    case Expression::Id::CallId:
      return "call";
    case Expression::Id::CallIndirectId:
      return "call_indirect";
    case Expression::Id::LocalGetId:
      return "local.get";
    case Expression::Id::LocalSetId:
      return "local.set";
    case Expression::Id::GlobalGetId:
      return "global.get";
    case Expression::Id::GlobalSetId:
      return "global.set";
    case Expression::Id::LoadId:
      return "load";
    case Expression::Id::StoreId:
      return "store";
    case Expression::Id::ConstId:
      return "const";
    case Expression::Id::UnaryId:
      return "unary";
    case Expression::Id::BinaryId:
      return "binary";
    case Expression::Id::SelectId:
      return "select";
    case Expression::Id::DropId:
      return "drop";
    case Expression::Id::ReturnId:
      return "return";
    case Expression::Id::HostId:
      return "host";
    case Expression::Id::NopId:
      return "nop";
    case Expression::Id::UnreachableId:
      return "unreachable";
    case Expression::Id::AtomicCmpxchgId:
      return "atomic_cmpxchg";
    case Expression::Id::AtomicRMWId:
      return "atomic_rmw";
    case Expression::Id::AtomicWaitId:
      return "atomic_wait";
    case Expression::Id::AtomicNotifyId:
      return "atomic_notify";
    case Expression::Id::AtomicFenceId:
      return "atomic_fence";
    case Expression::Id::SIMDExtractId:
      return "simd_extract";
    case Expression::Id::SIMDReplaceId:
      return "simd_replace";
    case Expression::Id::SIMDShuffleId:
      return "simd_shuffle";
    case Expression::Id::SIMDTernaryId:
      return "simd_ternary";
    case Expression::Id::SIMDShiftId:
      return "simd_shift";
    case Expression::Id::SIMDLoadId:
      return "simd_load";
    case Expression::Id::MemoryInitId:
      return "memory_init";
    case Expression::Id::DataDropId:
      return "data_drop";
    case Expression::Id::MemoryCopyId:
      return "memory_copy";
    case Expression::Id::MemoryFillId:
      return "memory_fill";
    case Expression::Id::PushId:
      return "push";
    case Expression::Id::PopId:
      return "pop";
    case Expression::TryId:
      return "try";
    case Expression::ThrowId:
      return "throw";
    case Expression::RethrowId:
      return "rethrow";
    case Expression::BrOnExnId:
      return "br_on_exn";
    case Expression::Id::NumExpressionIds:
      WASM_UNREACHABLE("invalid expr id");
  }
  WASM_UNREACHABLE("invalid expr id");
}

// core AST type checking

struct TypeSeeker : public PostWalker<TypeSeeker> {
  Expression* target; // look for this one
  Name targetName;
  std::vector<Type> types;

  TypeSeeker(Expression* target, Name targetName)
    : target(target), targetName(targetName) {
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
      if (name == targetName) {
        types.push_back(curr->value ? curr->value->type : none);
      }
    }
    if (curr->default_ == targetName) {
      types.push_back(curr->value ? curr->value->type : none);
    }
  }

  void visitBrOnExn(BrOnExn* curr) {
    if (curr->name == targetName) {
      types.push_back(curr->sent);
    }
  }

  void visitBlock(Block* curr) {
    if (curr == target) {
      if (curr->list.size() > 0) {
        types.push_back(curr->list.back()->type);
      } else {
        types.push_back(none);
      }
    } else if (curr->name == targetName) {
      // ignore all breaks til now, they were captured by someone with the same
      // name
      types.clear();
    }
  }

  void visitLoop(Loop* curr) {
    if (curr == target) {
      types.push_back(curr->body->type);
    } else if (curr->name == targetName) {
      // ignore all breaks til now, they were captured by someone with the same
      // name
      types.clear();
    }
  }
};

static Type mergeTypes(std::vector<Type>& types) {
  Type type = unreachable;
  for (auto other : types) {
    // once none, stop. it then indicates a poison value, that must not be
    // consumed and ignore unreachable
    if (type != none) {
      if (other == none) {
        type = none;
      } else if (other != unreachable) {
        if (type == unreachable) {
          type = other;
        } else if (type != other) {
          // poison value, we saw multiple types; this should not be consumed
          type = none;
        }
      }
    }
  }
  return type;
}

// a block is unreachable if one of its elements is unreachable,
// and there are no branches to it
static void handleUnreachable(Block* block,
                              bool breakabilityKnown = false,
                              bool hasBreak = false) {
  if (block->type == unreachable) {
    return; // nothing to do
  }
  if (block->list.size() == 0) {
    return; // nothing to do
  }
  // if we are concrete, stop - even an unreachable child
  // won't change that (since we have a break with a value,
  // or the final child flows out a value)
  if (block->type.isConcrete()) {
    return;
  }
  // look for an unreachable child
  for (auto* child : block->list) {
    if (child->type == unreachable) {
      // there is an unreachable child, so we are unreachable, unless we have a
      // break
      if (!breakabilityKnown) {
        hasBreak = BranchUtils::BranchSeeker::has(block, block->name);
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
      if (type.isConcrete()) {
        return;
      }
      // if we are unreachable, we are done
      if (type == unreachable) {
        return;
      }
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
  if (type == none && (condition->type == unreachable ||
                       (ifFalse && ifTrue->type == unreachable &&
                        ifFalse->type == unreachable))) {
    type = unreachable;
  }
}

void If::finalize() {
  if (ifFalse) {
    if (ifTrue->type == ifFalse->type) {
      type = ifTrue->type;
    } else if (ifTrue->type.isConcrete() && ifFalse->type == unreachable) {
      type = ifTrue->type;
    } else if (ifFalse->type.isConcrete() && ifTrue->type == unreachable) {
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

void Loop::finalize() { type = body->type; }

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

void Switch::finalize() { type = unreachable; }

template<typename T> void handleUnreachableOperands(T* curr) {
  for (auto* child : curr->operands) {
    if (child->type == unreachable) {
      curr->type = unreachable;
      break;
    }
  }
}

void Call::finalize() {
  handleUnreachableOperands(this);
  if (isReturn) {
    type = unreachable;
  }
}

void CallIndirect::finalize() {
  type = sig.results;
  handleUnreachableOperands(this);
  if (isReturn) {
    type = unreachable;
  }
  if (target->type == unreachable) {
    type = unreachable;
  }
}

bool LocalSet::isTee() const { return type != none; }

// Changes to local.tee. The type of the local should be given.
void LocalSet::makeTee(Type type_) {
  type = type_;
  finalize(); // type may need to be unreachable
}

// Changes to local.set.
void LocalSet::makeSet() {
  type = none;
  finalize(); // type may need to be unreachable
}

void LocalSet::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  }
}

void GlobalSet::finalize() {
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
  if (ptr->type == unreachable || expected->type == unreachable ||
      replacement->type == unreachable) {
    type = unreachable;
  }
}

void AtomicWait::finalize() {
  type = i32;
  if (ptr->type == unreachable || expected->type == unreachable ||
      timeout->type == unreachable) {
    type = unreachable;
  }
}

void AtomicNotify::finalize() {
  type = i32;
  if (ptr->type == unreachable || notifyCount->type == unreachable) {
    type = unreachable;
  }
}

void SIMDExtract::finalize() {
  assert(vec);
  switch (op) {
    case ExtractLaneSVecI8x16:
    case ExtractLaneUVecI8x16:
    case ExtractLaneSVecI16x8:
    case ExtractLaneUVecI16x8:
    case ExtractLaneVecI32x4:
      type = i32;
      break;
    case ExtractLaneVecI64x2:
      type = i64;
      break;
    case ExtractLaneVecF32x4:
      type = f32;
      break;
    case ExtractLaneVecF64x2:
      type = f64;
      break;
    default:
      WASM_UNREACHABLE("unexpected op");
  }
  if (vec->type == unreachable) {
    type = unreachable;
  }
}

void SIMDReplace::finalize() {
  assert(vec && value);
  type = v128;
  if (vec->type == unreachable || value->type == unreachable) {
    type = unreachable;
  }
}

void SIMDShuffle::finalize() {
  assert(left && right);
  type = v128;
  if (left->type == unreachable || right->type == unreachable) {
    type = unreachable;
  }
}

void SIMDTernary::finalize() {
  assert(a && b && c);
  type = v128;
  if (a->type == unreachable || b->type == unreachable ||
      c->type == unreachable) {
    type = unreachable;
  }
}

void MemoryInit::finalize() {
  assert(dest && offset && size);
  type = none;
  if (dest->type == unreachable || offset->type == unreachable ||
      size->type == unreachable) {
    type = unreachable;
  }
}

void DataDrop::finalize() { type = none; }

void MemoryCopy::finalize() {
  assert(dest && source && size);
  type = none;
  if (dest->type == unreachable || source->type == unreachable ||
      size->type == unreachable) {
    type = unreachable;
  }
}

void MemoryFill::finalize() {
  assert(dest && value && size);
  type = none;
  if (dest->type == unreachable || value->type == unreachable ||
      size->type == unreachable) {
    type = unreachable;
  }
}

void SIMDShift::finalize() {
  assert(vec && shift);
  type = v128;
  if (vec->type == unreachable || shift->type == unreachable) {
    type = unreachable;
  }
}

void SIMDLoad::finalize() {
  assert(ptr);
  type = v128;
  if (ptr->type == unreachable) {
    type = unreachable;
  }
}

Index SIMDLoad::getMemBytes() {
  switch (op) {
    case LoadSplatVec8x16:
      return 1;
    case LoadSplatVec16x8:
      return 2;
    case LoadSplatVec32x4:
      return 4;
    case LoadSplatVec64x2:
    case LoadExtSVec8x8ToVecI16x8:
    case LoadExtUVec8x8ToVecI16x8:
    case LoadExtSVec16x4ToVecI32x4:
    case LoadExtUVec16x4ToVecI32x4:
    case LoadExtSVec32x2ToVecI64x2:
    case LoadExtUVec32x2ToVecI64x2:
      return 8;
  }
  WASM_UNREACHABLE("unexpected op");
}

Const* Const::set(Literal value_) {
  value = value_;
  type = value.type;
  return this;
}

void Const::finalize() { type = value.type; }

bool Unary::isRelational() { return op == EqZInt32 || op == EqZInt64; }

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
    case SqrtFloat64:
      type = value->type;
      break;
    case EqZInt32:
    case EqZInt64:
      type = i32;
      break;
    case ExtendS8Int32:
    case ExtendS16Int32:
      type = i32;
      break;
    case ExtendSInt32:
    case ExtendUInt32:
    case ExtendS8Int64:
    case ExtendS16Int64:
    case ExtendS32Int64:
      type = i64;
      break;
    case WrapInt64:
      type = i32;
      break;
    case PromoteFloat32:
      type = f64;
      break;
    case DemoteFloat64:
      type = f32;
      break;
    case TruncSFloat32ToInt32:
    case TruncUFloat32ToInt32:
    case TruncSFloat64ToInt32:
    case TruncUFloat64ToInt32:
    case TruncSatSFloat32ToInt32:
    case TruncSatUFloat32ToInt32:
    case TruncSatSFloat64ToInt32:
    case TruncSatUFloat64ToInt32:
    case ReinterpretFloat32:
      type = i32;
      break;
    case TruncSFloat32ToInt64:
    case TruncUFloat32ToInt64:
    case TruncSFloat64ToInt64:
    case TruncUFloat64ToInt64:
    case TruncSatSFloat32ToInt64:
    case TruncSatUFloat32ToInt64:
    case TruncSatSFloat64ToInt64:
    case TruncSatUFloat64ToInt64:
    case ReinterpretFloat64:
      type = i64;
      break;
    case ReinterpretInt32:
    case ConvertSInt32ToFloat32:
    case ConvertUInt32ToFloat32:
    case ConvertSInt64ToFloat32:
    case ConvertUInt64ToFloat32:
      type = f32;
      break;
    case ReinterpretInt64:
    case ConvertSInt32ToFloat64:
    case ConvertUInt32ToFloat64:
    case ConvertSInt64ToFloat64:
    case ConvertUInt64ToFloat64:
      type = f64;
      break;
    case SplatVecI8x16:
    case SplatVecI16x8:
    case SplatVecI32x4:
    case SplatVecI64x2:
    case SplatVecF32x4:
    case SplatVecF64x2:
    case NotVec128:
    case NegVecI8x16:
    case NegVecI16x8:
    case NegVecI32x4:
    case NegVecI64x2:
    case AbsVecF32x4:
    case NegVecF32x4:
    case SqrtVecF32x4:
    case AbsVecF64x2:
    case NegVecF64x2:
    case SqrtVecF64x2:
    case TruncSatSVecF32x4ToVecI32x4:
    case TruncSatUVecF32x4ToVecI32x4:
    case TruncSatSVecF64x2ToVecI64x2:
    case TruncSatUVecF64x2ToVecI64x2:
    case ConvertSVecI32x4ToVecF32x4:
    case ConvertUVecI32x4ToVecF32x4:
    case ConvertSVecI64x2ToVecF64x2:
    case ConvertUVecI64x2ToVecF64x2:
    case WidenLowSVecI8x16ToVecI16x8:
    case WidenHighSVecI8x16ToVecI16x8:
    case WidenLowUVecI8x16ToVecI16x8:
    case WidenHighUVecI8x16ToVecI16x8:
    case WidenLowSVecI16x8ToVecI32x4:
    case WidenHighSVecI16x8ToVecI32x4:
    case WidenLowUVecI16x8ToVecI32x4:
    case WidenHighUVecI16x8ToVecI32x4:
      type = v128;
      break;
    case AnyTrueVecI8x16:
    case AllTrueVecI8x16:
    case AnyTrueVecI16x8:
    case AllTrueVecI16x8:
    case AnyTrueVecI32x4:
    case AllTrueVecI32x4:
    case AnyTrueVecI64x2:
    case AllTrueVecI64x2:
      type = i32;
      break;

    case InvalidUnary:
      WASM_UNREACHABLE("invalid unary op");
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
    case GeFloat32:
      return true;
    default:
      return false;
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
  if (ifTrue->type == unreachable || ifFalse->type == unreachable ||
      condition->type == unreachable) {
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
    case MemorySize: {
      type = i32;
      break;
    }
    case MemoryGrow: {
      // if the single operand is not reachable, so are we
      if (operands[0]->type == unreachable) {
        type = unreachable;
      } else {
        type = i32;
      }
      break;
    }
  }
}

void Try::finalize() {
  if (body->type == catchBody->type) {
    type = body->type;
  } else if (body->type.isConcrete() && catchBody->type == unreachable) {
    type = body->type;
  } else if (catchBody->type.isConcrete() && body->type == unreachable) {
    type = catchBody->type;
  } else {
    type = none;
  }
}

void Try::finalize(Type type_) {
  type = type_;
  if (type == none && body->type == unreachable &&
      catchBody->type == unreachable) {
    type = unreachable;
  }
}

void Throw::finalize() { type = unreachable; }

void Rethrow::finalize() { type = unreachable; }

void BrOnExn::finalize() {
  if (exnref->type == unreachable) {
    type = unreachable;
  } else {
    type = Type::exnref;
  }
}

void Push::finalize() {
  if (value->type == unreachable) {
    type = unreachable;
  } else {
    type = none;
  }
}

size_t Function::getNumParams() { return sig.params.size(); }

size_t Function::getNumVars() { return vars.size(); }

size_t Function::getNumLocals() { return sig.params.size() + vars.size(); }

bool Function::isParam(Index index) {
  size_t size = sig.params.size();
  assert(index < size + vars.size());
  return index < size;
}

bool Function::isVar(Index index) {
  auto base = getVarIndexBase();
  assert(index < base + vars.size());
  return index >= base;
}

bool Function::hasLocalName(Index index) const {
  return localNames.find(index) != localNames.end();
}

Name Function::getLocalName(Index index) { return localNames.at(index); }

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

Index Function::getVarIndexBase() { return sig.params.size(); }

Type Function::getLocalType(Index index) {
  const std::vector<Type>& params = sig.params.expand();
  if (index < params.size()) {
    return params[index];
  } else if (isVar(index)) {
    return vars[index - params.size()];
  } else {
    WASM_UNREACHABLE("invalid local index");
  }
}

void Function::clearNames() { localNames.clear(); }

void Function::clearDebugInfo() {
  localIndices.clear();
  debugLocations.clear();
  prologLocation.clear();
  epilogLocation.clear();
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
    assert(false);
    Fatal() << "Module::getGlobal: " << name << " does not exist";
  }
  return iter->second;
}

Event* Module::getEvent(Name name) {
  auto iter = eventsMap.find(name);
  if (iter == eventsMap.end()) {
    Fatal() << "Module::getEvent: " << name << " does not exist";
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

Event* Module::getEventOrNull(Name name) {
  auto iter = eventsMap.find(name);
  if (iter == eventsMap.end()) {
    return nullptr;
  }
  return iter->second;
}

Export* Module::addExport(Export* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addExport: empty name";
  }
  if (getExportOrNull(curr->name)) {
    Fatal() << "Module::addExport: " << curr->name << " already exists";
  }
  exports.push_back(std::unique_ptr<Export>(curr));
  exportsMap[curr->name] = curr;
  return curr;
}

// TODO(@warchant): refactor all usages to use variant with unique_ptr
Function* Module::addFunction(Function* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addFunction: empty name";
  }
  if (getFunctionOrNull(curr->name)) {
    Fatal() << "Module::addFunction: " << curr->name << " already exists";
  }
  functions.push_back(std::unique_ptr<Function>(curr));
  functionsMap[curr->name] = curr;
  return curr;
}

Function* Module::addFunction(std::unique_ptr<Function> curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addFunction: empty name";
  }
  if (getFunctionOrNull(curr->name)) {
    Fatal() << "Module::addFunction: " << curr->name << " already exists";
  }
  auto* ret = functionsMap[curr->name] = curr.get();
  functions.push_back(std::move(curr));
  return ret;
}

Global* Module::addGlobal(Global* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addGlobal: empty name";
  }
  if (getGlobalOrNull(curr->name)) {
    Fatal() << "Module::addGlobal: " << curr->name << " already exists";
  }

  globals.emplace_back(curr);

  globalsMap[curr->name] = curr;
  return curr;
}

Event* Module::addEvent(Event* curr) {
  if (!curr->name.is()) {
    Fatal() << "Module::addEvent: empty name";
  }
  if (getEventOrNull(curr->name)) {
    Fatal() << "Module::addEvent: " << curr->name << " already exists";
  }

  events.emplace_back(curr);

  eventsMap[curr->name] = curr;
  return curr;
}

void Module::addStart(const Name& s) { start = s; }

template<typename Vector, typename Map>
void removeModuleElement(Vector& v, Map& m, Name name) {
  m.erase(name);
  for (size_t i = 0; i < v.size(); i++) {
    if (v[i]->name == name) {
      v.erase(v.begin() + i);
      break;
    }
  }
}

void Module::removeExport(Name name) {
  removeModuleElement(exports, exportsMap, name);
}
void Module::removeFunction(Name name) {
  removeModuleElement(functions, functionsMap, name);
}
void Module::removeGlobal(Name name) {
  removeModuleElement(globals, globalsMap, name);
}
void Module::removeEvent(Name name) {
  removeModuleElement(events, eventsMap, name);
}

template<typename Vector, typename Map, typename Elem>
void removeModuleElements(Vector& v,
                          Map& m,
                          std::function<bool(Elem* elem)> pred) {
  for (auto it = m.begin(); it != m.end();) {
    if (pred(it->second)) {
      it = m.erase(it);
    } else {
      it++;
    }
  }
  v.erase(
    std::remove_if(v.begin(), v.end(), [&](auto& e) { return pred(e.get()); }),
    v.end());
}

void Module::removeExports(std::function<bool(Export*)> pred) {
  removeModuleElements(exports, exportsMap, pred);
}
void Module::removeFunctions(std::function<bool(Function*)> pred) {
  removeModuleElements(functions, functionsMap, pred);
}
void Module::removeGlobals(std::function<bool(Global*)> pred) {
  removeModuleElements(globals, globalsMap, pred);
}
void Module::removeEvents(std::function<bool(Event*)> pred) {
  removeModuleElements(events, eventsMap, pred);
}

void Module::updateMaps() {
  functionsMap.clear();
  for (auto& curr : functions) {
    functionsMap[curr->name] = curr.get();
  }
  exportsMap.clear();
  for (auto& curr : exports) {
    exportsMap[curr->name] = curr.get();
  }
  globalsMap.clear();
  for (auto& curr : globals) {
    globalsMap[curr->name] = curr.get();
  }
  eventsMap.clear();
  for (auto& curr : events) {
    eventsMap[curr->name] = curr.get();
  }
}

void Module::clearDebugInfo() { debugInfoFileNames.clear(); }

} // namespace wasm
