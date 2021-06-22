/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Lowers Wasm GC to linear memory.
//
// Layouts:
//   Struct:
//     ptr rtt
//     fields...
//
//   Array:
//     ptr rtt
//     u32 size
//     elements...
//
//   Func:
//     ptr rtt
//     u32 index in the table
//
//   Rtts:
//     u32/RttKind what (func, data, i31, extern)
//     ptr         decl (this is a pointer to new type the rtt.sub declares
//                           on top of the fiven rtt. to represent that type,
//                           we point to the the rtt.canon for it. or, if this
//                           is an rtt.canon and not .sub, this still contains
//                           the "new" type that is defined in the rtt.canon,
//                           that is, it points to itself)
//     ptr         parent (or null if this is from rtt.canon)
//
//     - That is, an rtt.canon contains a "what" and then two nulls. There is a
//       single rtt.canon for each type, and that address is the unique ID for
//       it, basically. An rtt.sub has two pointers, the first saying the type
//       it is for. That is represented as a pointer to the rtt.canon for that
//       type. The second pointer is the RTT it is a sub of. For example,
//         (rtt.canon $foo)     => [kind, FOO, 0] at address FOO
//         (rtt.sub $bar
//          (rtt.canon $foo))   => [kind, BAR, FOO] at address SUB1
//         (rtt.sub $quux
//          (rtt.sub $bar
//           (rtt.canon $foo))) => [kind, QUUX, SUB1]
//       Note that we keep rtt.canon addresses unique, but we do not currently
//       make an effort to do the same for rtt.sub (which would require a hash
//       map). To implement the "structural" comparison semantics of rtt.sub,
//       we compare the chain of parents, using the fact that the pointes to
//       rtt.canons in the second field are unique.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/table-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

class PointerBuilder : public Builder {
public:
  PointerBuilder(Module& wasm) : Builder(wasm) {}

  Expression* makePointerConst(Address addr) {
    if (wasm.memory.is64()) {
      return makeConst(int64_t(addr));
    }
    return makeConst(int32_t(addr));
  }

  Expression* makePointerLoad(Expression* ptr, Address offset = 0) {
    return makeSimpleUnsignedLoad(ptr, wasm.memory.indexType, offset);
  }

  Expression*
  makePointerStore(Expression* ptr, Expression* value, Address offset = 0) {
    return makeSimpleStore(ptr, value, wasm.memory.indexType, offset);
  }

  Expression* makePointerEq(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(EqInt64, a, b);
    }
    return makeBinary(EqInt32, a, b);
  }

  Expression* makePointerAdd(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(AddInt64, a, b);
    }
    return makeBinary(AddInt32, a, b);
  }

  Expression* makePointerMul(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(MulInt64, a, b);
    }
    return makeBinary(MulInt32, a, b);
  }

  Expression* makePointerNullCheck(Expression* a) {
    if (wasm.memory.is64()) {
      return makeUnary(EqZInt64, a);
    }
    return makeUnary(EqZInt32, a);
  }

  Expression* makeTrapOnNullParam(Index param,
                                  Expression* otherwise = nullptr) {
    return makeIf(makePointerNullCheck(makeLocalGet(0, wasm.memory.indexType)),
                  makeUnreachable(),
                  otherwise);
  }
};

const char* getName(RefAsOp op) {
  switch (op) {
    case RefAsNonNull:
      return "RefAsNonNull";
    case RefAsFunc:
      return "RefAsFunc";
    case RefAsData:
      return "RefAsData";
    case RefAsI31:
      return "RefAsI31";
    default:
      WASM_UNREACHABLE("unimplemented ref.as_*");
  }
}

const char* getName(RefIsOp op) {
  switch (op) {
    case RefIsNull:
      return "RefIsNull";
    case RefIsFunc:
      return "RefIsFunc";
    case RefIsData:
      return "RefIsData";
    case RefIsI31:
      return "RefIsI31";
    default:
      WASM_UNREACHABLE("unimplemented ref.is_*");
  }
}

enum RttKind {
  RttFunc = 0,
  RttData = 1,
  RttI31 = 2,
  RttExtern = 3,
};

Type getLoweredType(Type type, Memory& memory) {
  // References and Rtts are pointers.
  if (type.isRef() || type.isRtt()) {
    return memory.indexType;
  }
  return type;
}

// The layout of a struct in linear memory.
struct Layout {
  // The total size of the struct.
  Address size;
  // The offsets of fields. Note that the first field's offset may not be 0,
  // as we need room for the rtt.
  SmallVector<Address, 4> fieldOffsets;
};

using Layouts = std::unordered_map<HeapType, Layout>;

struct LoweringInfo {
  Layouts layouts;

  Name malloc;
  // Start allocating at address 8, so that lower numbers can have special
  // meanings (like 0 meaning "null").
  Address mallocStart = 8;

  Address pointerSize;
  Type pointerType;

  // The addresses of rtt.canons. Each rtt.canon will be turned into a constant
  // containing the address for that type.
  std::unordered_map<HeapType, Address> rttCanonAddrs;

  // The addresses of ref.funcs. A singleton such instance is created for each
  // function.
  std::unordered_map<Name, Address> refFuncAddrs;

  Address compileTimeMalloc(Address size) {
    assert(size % 4 == 0);
    auto ret = mallocStart;
    mallocStart = mallocStart + size;
    return ret;
  }
};

// Lower GC instructions. Most turn into function calls, and we rely on inlining
// and other optimizations to improve the code.
struct LowerGCCode
  : public WalkerPass<
      PostWalker<LowerGCCode, UnifiedExpressionVisitor<LowerGCCode>>> {
  bool isFunctionParallel() override { return true; }

  LoweringInfo* loweringInfo;

  using Parent =
    WalkerPass<PostWalker<LowerGCCode, UnifiedExpressionVisitor<LowerGCCode>>>;

  LowerGCCode* create() override { return new LowerGCCode(loweringInfo); }

  LowerGCCode(LoweringInfo* loweringInfo) : loweringInfo(loweringInfo) {}

  // visitExpression() performs generic fixups that are needed in all classes.
  // When a specific visitor is defined, they must also call this one, and
  // before doing any changes (so that we can record the original type, which
  // may then be needed by the parent expression, etc.).
  void visitExpression(Expression* curr) {
    auto type = curr->type;
    if (type.isRef() || type.isRtt()) {
      originalTypes[getCurrentPointer()] = type.getHeapType();
    }
    // Update the type. This avoids us needing to write out stubs for things
    // like local.get, control flow structures, etc.
    curr->type = lower(type);
  }

  void visitCallIndirect(CallIndirect* curr) {
    visitExpression(curr);
    curr->sig = lower(curr->sig);
  }

  void visitRefNull(RefNull* curr) {
    visitExpression(curr);
    replaceCurrent(LiteralUtils::makeZero(lower(curr->type), *getModule()));
  }

  void visitRefAs(RefAs* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      getName(curr->op), {curr->value}, loweringInfo->pointerType));
  }

  void visitRefIs(RefIs* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      getName(curr->op), {curr->value}, loweringInfo->pointerType));
  }

  void visitRefCast(RefCast* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      "RefCast", {curr->ref, curr->rtt}, loweringInfo->pointerType));
  }

  void visitRefTest(RefTest* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(
      builder.makeCall("RefTest", {curr->ref, curr->rtt}, Type::i32));
  }

  void visitCallRef(CallRef* curr) {
    visitExpression(curr);
    auto type = originalTypes[&curr->target];
    curr->operands.push_back(curr->target);
    Builder builder(*getModule());
    std::string name = "CallRef$";
    name += getModule()->typeNames[type].name.str;
    replaceCurrent(builder.makeCall(name, curr->operands, curr->type));
  }

  void visitBrOn(BrOn* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    // Store the ref to a local, as we may need to access it twice.
    auto ref = builder.addVar(getFunction(), Type::i32);
    auto* set = builder.makeLocalSet(ref, curr->ref);
    auto makeGetRef = [&]() { return builder.makeLocalGet(ref, Type::i32); };
    auto makeCheck = [&](const char* name) {
      return builder.makeCall(name, {makeGetRef()}, Type::i32);
    };
    auto makeReversedCheck = [&](const char* name) {
      return builder.makeUnary(EqZInt32, makeCheck(name));
    };
    auto makeCastCheck = [&]() {
      return builder.makeCall("RefTest", {makeGetRef(), curr->rtt}, Type::i32);
    };
    auto makeReversedCastCheck = [&]() {
      return builder.makeUnary(EqZInt32, makeCastCheck());
    };
    // The condition must be set in each case of the switch.
    Expression* condition;
    switch (curr->op) {
      case BrOnFunc:
        condition = makeCheck("RefIsFunc");
        break;
      case BrOnNonFunc:
        condition = makeReversedCheck("RefIsFunc");
        break;
      case BrOnData:
        condition = makeCheck("RefIsData");
        break;
      case BrOnNonData:
        condition = makeReversedCheck("RefIsData");
        break;
      case BrOnI31:
        condition = makeCheck("RefIsI31");
        break;
      case BrOnNonI31:
        condition = makeReversedCheck("RefIsI31");
        break;
      case BrOnCast:
        condition = makeCastCheck();
        break;
      case BrOnCastFail:
        condition = makeReversedCastCheck();
        break;

      // The null operations are special in that they do not send or flow out
      // a value in all cases, unlike the previous.
      case BrOnNull:
        // br_on_null branches on null, and flows out the non-null value
        // otherwise. It does not send a value on the branch.
        replaceCurrent(builder.makeBlock(
          {set,
           builder.makeBreak(curr->name, nullptr, makeCheck("RefIsNull")),
           makeGetRef()}));
        return;
      case BrOnNonNull:
        // br_on_non_null branches on non-null with the value, and does not flow
        // anything out.
        replaceCurrent(builder.makeSequence(
          set,
          builder.makeDrop(builder.makeBreak(
            curr->name, makeGetRef(), makeReversedCheck("RefIsNull")))));
        return;

      default:
        WASM_UNREACHABLE("unimplemented br_as_*");
    }

    // The default behavior is to break on the condition, and both send the
    // reference and flow it out.
    replaceCurrent(builder.makeSequence(
      set, builder.makeBreak(curr->name, makeGetRef(), condition)));
  }

  void visitStructNew(StructNew* curr) {
    visitExpression(curr);
    auto type = originalTypes[&curr->rtt];
    std::vector<Expression*> operands;
    std::string name = getExpressionName(curr);
    if (curr->isWithDefault()) {
      name += "WithDefault";
    } else {
      for (auto* operand : curr->operands) {
        operands.push_back(operand);
      }
    }
    operands.push_back(curr->rtt);
    name += std::string("$") + getModule()->typeNames[type].name.str;
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(name, operands, loweringInfo->pointerType));
  }

  void visitStructSet(StructSet* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name = std::string("StructSet$") +
                getModule()->typeNames[type].name.str + '$' +
                std::to_string(curr->index);
    replaceCurrent(
      builder.makeCall(name, {curr->ref, curr->value}, Type::none));
  }

  void visitStructGet(StructGet* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name = std::string("StructGet$") +
                getModule()->typeNames[type].name.str + '$' +
                std::to_string(curr->index);
    replaceCurrent(builder.makeCall(
      name, {curr->ref}, getLoweredType(curr->type, getModule()->memory)));
  }

  void visitArrayNew(ArrayNew* curr) {
    visitExpression(curr);
    auto type = originalTypes[&curr->rtt];
    std::vector<Expression*> operands;
    std::string name = getExpressionName(curr);
    if (curr->isWithDefault()) {
      name += "WithDefault";
    } else {
      operands.push_back(curr->init);
    }
    operands.push_back(curr->size);
    operands.push_back(curr->rtt);
    name += std::string("$") + getModule()->typeNames[type].name.str;
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(name, operands, loweringInfo->pointerType));
  }

  void visitArraySet(ArraySet* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name =
      std::string("ArraySet$") + getModule()->typeNames[type].name.str;
    replaceCurrent(builder.makeCall(
      name, {curr->ref, curr->index, curr->value}, Type::none));
  }

  void visitArrayGet(ArrayGet* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name =
      std::string("ArrayGet$") + getModule()->typeNames[type].name.str;
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, getModule()->memory);
    replaceCurrent(
      builder.makeCall(name, {curr->ref, curr->index}, loweredType));
  }

  void visitArrayLen(ArrayLen* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name =
      std::string("ArrayLen$") + getModule()->typeNames[type].name.str;
    replaceCurrent(builder.makeCall(name, {curr->ref}, Type::i32));
  }

  void visitArrayCopy(ArrayCopy* curr) { WASM_UNREACHABLE("TODO: ArrayCopy"); }

  void visitRefFunc(RefFunc* curr) {
    visitExpression(curr);
    replaceCurrent(
      LiteralUtils::makeFromInt32(loweringInfo->refFuncAddrs[curr->func],
                                  loweringInfo->pointerType,
                                  *getModule()));
  }

  void visitRttCanon(RttCanon* curr) {
    auto type = curr->type.getHeapType();
    visitExpression(curr);
    replaceCurrent(
      LiteralUtils::makeFromInt32(loweringInfo->rttCanonAddrs[type],
                                  loweringInfo->pointerType,
                                  *getModule()));
  }

  void visitRttSub(RttSub* curr) {
    auto type = curr->type.getHeapType();
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      "RttSub",
      {LiteralUtils::makeFromInt32(loweringInfo->rttCanonAddrs[type],
                                   loweringInfo->pointerType,
                                   *getModule()),
       curr->parent},
      loweringInfo->pointerType));
  }

  void doWalkFunction(Function* func) {
    func->sig = lower(func->sig);

    for (auto& t : func->vars) {
      t = lower(t);
    }

    // Lower all the code.
    Parent::doWalkFunction(func);

    // Ensure unique names for the loops that we created.
    UniqueNameMapper::uniquify(func->body);
  }

private:
  // We note the original heap types of expressions as we go, because when we
  // change say an RTT into an integer, we need to know the type that RTT had if
  // it is used in something like StructGet.
  //
  // Note that we map the location of the pointer, and not the pointer itself,
  // as we may replace expressions. In the example above, an RttCanon may be
  // replaced by a Const. But we know that the pointer to the expression exists
  // at the time we use it (in the StructSet, before we possibly replace that as
  // well).
  //
  // (If an expression has no heap type, we do not note anything for it here.)
  std::unordered_map<Expression**, HeapType> originalTypes;

  Type lower(Type type) { return getLoweredType(type, getModule()->memory); }

  Signature lower(Signature sig) {
    std::vector<Type> params;
    for (auto t : sig.params) {
      params.push_back(lower(t));
    }
    std::vector<Type> results;
    for (auto t : sig.results) {
      results.push_back(lower(t));
    }
    return Signature(Type(params), Type(results));
  }
};

} // anonymous namespace

struct LowerGC : public Pass {
  void run(PassRunner* runner, Module* module_) override {
    // First, ensure types have names, as we use the names when creating the
    // runtime code.
    {
      PassRunner subRunner(runner);
      subRunner.add("name-types");
      subRunner.add("dce");
      subRunner.setIsNested(true);
      subRunner.run();
    }
    module = module_;
    pickNames();
    addMemory();
    addTable();
    addStart();
    addGCRuntime();
    // After adding the GC runtime, which may allocate memory, we can create our
    // malloc runtime and initialize it.
    addMalloc();
    processGlobals();
    lowerCode(runner);
  }

private:
  Module* module;

  LoweringInfo loweringInfo;

  Block* startBlock;
  Table* table;
  ElementSegment* segment;

  void pickNames() { loweringInfo.malloc = "malloc"; }

  void addMemory() {
    module->memory.exists = true;

    // 16MB, arbitrarily for now.
    module->memory.initial = module->memory.max = 256;

    assert(!module->memory.is64());
    loweringInfo.pointerSize = 4;
    loweringInfo.pointerType = module->memory.indexType;
  }

  const char* TableName = "lowergc-table";

  void addTable() {
    Builder builder(*module);
    // Add a new table just for us.
    // Start the table at size 0, and increase it as needed as we go.
    table = module->addTable(builder.makeTable(
      Names::getValidTableName(*module, TableName), Type::funcref, 0, 0));
    // Add an element segment to append to.
    segment = module->addElementSegment(builder.makeElementSegment(
      "lowergc-segment", table->name, builder.makeConst(int32_t(0))));
  }

  void addStart() {
    Builder builder(*module);
    startBlock = builder.makeBlock();
    if (module->start.is()) {
      // There is already a start function. Add our block before it.
      auto* func = module->getFunction(module->start);
      func->body = builder.makeSequence(startBlock, func->body);
      return;
    }
    // Add a new start function.
    module->start = "LowerGC$start";
    module->addFunction(builder.makeFunction(
      module->start, {Type::none, Type::none}, {}, startBlock));
  }

  void addMalloc() {
    Builder builder(*module);
    auto* nextMalloc = module->addGlobal(
      builder.makeGlobal("nextMalloc",
                         Type::i32,
                         builder.makeConst(int32_t(loweringInfo.mallocStart)),
                         Builder::Mutable));
    // TODO: more than a simple bump allocator that never frees or collects.
    auto* alloc = 
        builder.makeGlobalSet(
          nextMalloc->name,
          builder.makeBinary(AddInt32,
                             builder.makeGlobalGet(nextMalloc->name, Type::i32),
                             builder.makeLocalGet(0, Type::i32)));
    auto* check =
      builder.makeIf(
        builder.makeBinary(
          GeUInt32,
          builder.makeGlobalGet(nextMalloc->name, Type::i32),
          builder.makeBinary(
            MulInt32,
            builder.makeMemorySize(),
            builder.makeConst(uint32_t(Memory::kPageSize))
          )
        ),
        builder.makeUnreachable()
      );
    auto* ret = builder.makeBinary(SubInt32,
                           builder.makeGlobalGet(nextMalloc->name, Type::i32),
                           builder.makeLocalGet(0, Type::i32));
    module->addFunction(builder.makeFunction(
      loweringInfo.malloc,
      {Type::i32, Type::i32},
      {},
      builder.makeBlock({
        alloc,
        check,
        ret
      })));
  }

  void addGCRuntime() {
    // Collect all the heap types in order to analyze them and decide on their
    // layout in linear memory.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);

    // Emit support code for specific types.
    //
    // Note that some of this support code will end up identical, e.g., the
    // getting the length of an array does not depend on the type. Those can be
    // de-duplicated by other passes later.
    for (auto type : types) {
      if (type.isStruct()) {
        computeLayout(type, loweringInfo.layouts[type]);
        makeStructNew(type);
        makeStructSet(type);
        makeStructGet(type);
      } else if (type.isArray()) {
        makeArrayNew(type);
        makeArraySet(type);
        makeArrayGet(type);
        makeArrayLen(type);
      } else if (type.isFunction()) {
        makeCallRef(type);
      }
    }
    makeRefAs();
    makeRefIs();
    makeRefTest();
    makeRefCast();

    addTypeSupport(types);
  }

  void computeLayout(HeapType type, Layout& layout) {
    // A pointer to the RTT takes up the first bytes in the struct, so fields
    // start afterwards.
    Address nextField = loweringInfo.pointerSize;
    auto& fields = type.getStruct().fields;
    for (auto& field : fields) {
      layout.fieldOffsets.push_back(nextField);
      // TODO: packed types? for now, always use i32 for them
      nextField =
        nextField + getLoweredType(field.type, module->memory).getByteSize();
    }
    layout.size = nextField;
  }

  void makeStructNew(HeapType type) {
    auto typeName = module->typeNames[type].name.str;
    auto& fields = type.getStruct().fields;
    Builder builder(*module);
    for (bool withDefault : {true, false}) {
      std::vector<Type> params;
      // Store the values, by performing StructSet operations.
      for (Index i = 0; i < fields.size(); i++) {
        if (!withDefault) {
          params.push_back(fields[i].type);
        }
      }
      // Add the RTT parameter.
      auto rttParam = params.size();
      params.push_back(loweringInfo.pointerType);
      // We need one local to store the allocated value.
      auto alloc = params.size();
      std::vector<Expression*> list;
      // Malloc space for our struct.
      list.push_back(builder.makeLocalSet(
        alloc,
        builder.makeCall(
          loweringInfo.malloc,
          {builder.makeConst(int32_t(loweringInfo.layouts[type].size))},
          loweringInfo.pointerType)));
      // Store the rtt.
      list.push_back(builder.makeStore(
        loweringInfo.pointerSize,
        0,
        loweringInfo.pointerSize,
        builder.makeLocalGet(alloc, loweringInfo.pointerType),
        builder.makeLocalGet(rttParam, loweringInfo.pointerType),
        loweringInfo.pointerType));
      // Store the values, by performing StructSet operations.
      for (Index i = 0; i < fields.size(); i++) {
        Expression* value;
        if (withDefault) {
          value = LiteralUtils::makeZero(fields[i].type, *module);
        } else {
          auto paramType = fields[i].type;
          value = builder.makeLocalGet(i, paramType);
        }
        list.push_back(builder.makeCall(
          std::string("StructSet$") + typeName + '$' + std::to_string(i),
          {builder.makeLocalGet(alloc, loweringInfo.pointerType), value},
          Type::none));
      }
      // Return the pointer.
      list.push_back(builder.makeLocalGet(alloc, loweringInfo.pointerType));
      std::string name = "StructNew";
      if (withDefault) {
        name += "WithDefault";
      }
      module->addFunction(builder.makeFunction(name + '$' + typeName,
                                               {Type(params), Type::i32},
                                               {loweringInfo.pointerType},
                                               builder.makeBlock(list)));
    }
  }

  void makeStructSet(HeapType type) {
    auto& fields = type.getStruct().fields;
    PointerBuilder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = getLoweredType(field.type, module->memory);
      module->addFunction(builder.makeFunction(
        std::string("StructSet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        {{loweringInfo.pointerType, loweredType}, Type::none},
        {},
        builder.makeTrapOnNullParam(
          0,
          builder.makeStore(loweredType.getByteSize(),
                            loweringInfo.layouts[type].fieldOffsets[i],
                            loweredType.getByteSize(),
                            builder.makeLocalGet(0, loweringInfo.pointerType),
                            builder.makeLocalGet(1, loweredType),
                            loweredType))));
    }
  }

  void makeStructGet(HeapType type) {
    auto& fields = type.getStruct().fields;
    PointerBuilder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = getLoweredType(field.type, module->memory);
      module->addFunction(builder.makeFunction(
        std::string("StructGet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        {loweringInfo.pointerType, loweredType},
        {},
        builder.makeTrapOnNullParam(
          0,
          builder.makeLoad(loweredType.getByteSize(),
                           false, // TODO: signedness
                           loweringInfo.layouts[type].fieldOffsets[i],
                           loweredType.getByteSize(),
                           builder.makeLocalGet(0, loweringInfo.pointerType),
                           loweredType))));
    }
  }

  void makeArrayNew(HeapType type) {
    auto typeName = module->typeNames[type].name.str; // waka
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, module->memory);
    PointerBuilder builder(*module);
    for (bool withDefault : {true, false}) {
      std::vector<Type> params;
      Index initParam = -1;
      if (!withDefault) {
        initParam = 0;
        params.push_back(loweredType);
      }
      // Add the size parameter.
      auto sizeParam = params.size();
      params.push_back(loweringInfo.pointerType);
      // Add the RTT parameter.
      auto rttParam = params.size();
      params.push_back(loweringInfo.pointerType);
      // Add a local to store the allocated value.
      auto alloc = params.size();
      std::vector<Expression*> list;
      // Malloc space for our Array.
      list.push_back(builder.makeLocalSet(
        alloc,
        builder.makeCall(
          loweringInfo.malloc,
          {builder.makePointerAdd(
            builder.makePointerConst(4 + loweringInfo.pointerSize),
            builder.makePointerMul(
              builder.makePointerConst(loweredType.getByteSize()),
              builder.makeLocalGet(sizeParam, loweringInfo.pointerType)))},
          loweringInfo.pointerType)));
      // Store the size.
      list.push_back(builder.makeStore(
        loweringInfo.pointerSize,
        4,
        loweringInfo.pointerSize,
        builder.makeLocalGet(alloc, loweringInfo.pointerType),
        builder.makeLocalGet(sizeParam, loweringInfo.pointerType),
        loweringInfo.pointerType));
      // Store the rtt.
      list.push_back(builder.makeStore(
        loweringInfo.pointerSize,
        0,
        loweringInfo.pointerSize,
        builder.makeLocalGet(alloc, loweringInfo.pointerType),
        builder.makeLocalGet(rttParam, loweringInfo.pointerType),
        loweringInfo.pointerType));
      // Store the values, by performing ArraySet operations.
      Name loopName("loop");
      Name blockName("block");
      Expression* initialization;
      if (withDefault) {
        initialization = LiteralUtils::makeZero(loweredType, *module);
      } else {
        initialization = builder.makeLocalGet(initParam, loweredType);
      }
      initialization = builder.makeCall(
        std::string("ArraySet$") + typeName,
        {builder.makeLocalGet(alloc, loweringInfo.pointerType),
         builder.makeBinary(SubInt32,
                            builder.makeLocalGet(sizeParam, Type::i32),
                            builder.makeConst(int32_t(1))),
         initialization},
        Type::none);
      list.push_back(builder.makeLoop(
        loopName,
        builder.makeBlock(
          blockName,
          {builder.makeBreak(
             blockName,
             nullptr,
             builder.makeUnary(EqZInt32,
                               builder.makeLocalGet(sizeParam, Type::i32))),
           initialization,
           builder.makeLocalSet(
             sizeParam,
             builder.makeBinary(SubInt32,
                                builder.makeLocalGet(sizeParam, Type::i32),
                                builder.makeConst(int32_t(1)))),
           builder.makeBreak(loopName)})));
      // Return the pointer.
      list.push_back(builder.makeLocalGet(alloc, loweringInfo.pointerType));
      std::string name = "ArrayNew";
      if (withDefault) {
        name += "WithDefault";
      }
      module->addFunction(
        builder.makeFunction(name + '$' + typeName,
                             {Type(params), loweringInfo.pointerType},
                             {loweringInfo.pointerType},
                             builder.makeBlock(list)));
    }
  }

  Expression* makeArrayOffset(Type loweredType) {
    Builder builder(*module);
    return builder.makeBinary(
      AddInt32,
      builder.makeBinary(AddInt32,
                         builder.makeLocalGet(0, loweringInfo.pointerType),
                         builder.makeConst(int32_t(8))),
      builder.makeBinary(MulInt32,
                         builder.makeConst(int32_t(loweredType.getByteSize())),
                         builder.makeLocalGet(1, loweringInfo.pointerType)));
  }

  void makeArraySet(HeapType type) {
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, module->memory);
    PointerBuilder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArraySet$") + module->typeNames[type].name.str,
      {{loweringInfo.pointerType, loweringInfo.pointerType, loweredType},
       Type::none},
      {},
      builder.makeTrapOnNullParam(
        0,
        builder.makeStore(loweredType.getByteSize(),
                          0,
                          loweredType.getByteSize(),
                          makeArrayOffset(loweredType),
                          builder.makeLocalGet(2, loweredType),
                          loweredType))));
  }

  void makeArrayGet(HeapType type) {
    auto element = type.getArray().element;
    auto loweredType =
      getLoweredType(element.type, module->memory); // TODO: lower()
    PointerBuilder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArrayGet$") + module->typeNames[type].name.str,
      {{loweringInfo.pointerType, loweringInfo.pointerType}, loweredType},
      {},
      builder.makeTrapOnNullParam(0,
                                  builder.makeLoad(loweredType.getByteSize(),
                                                   false, // TODO: signedness
                                                   0,
                                                   loweredType.getByteSize(),
                                                   makeArrayOffset(loweredType),
                                                   loweredType))));
  }

  void makeArrayLen(HeapType type) {
    PointerBuilder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArrayLen$") + module->typeNames[type].name.str,
      {{loweringInfo.pointerType}, Type::i32},
      {},
      builder.makeTrapOnNullParam(
        0,
        builder.makeSimpleUnsignedLoad(
          builder.makeLocalGet(0, loweringInfo.pointerType), Type::i32, 4))));
  }

  void makeCallRef(HeapType type) {
    auto sig = type.getSignature();
    std::vector<Type> loweredParams, loweredResults;
    for (auto param : sig.params) {
      loweredParams.push_back(lower(param));
    }
    for (auto result : sig.results) {
      loweredResults.push_back(lower(result));
    }
    // The reference is passed after the parameters.
    auto refParam = sig.params.size();
    // The new runtime function receives the lowered params, and then the
    // function pointer.
    auto runtimeFunctionParams = loweredParams;
    runtimeFunctionParams.push_back(Type::i32);

    PointerBuilder builder(*module);
    std::vector<Expression*> args;
    for (Index i = 0; i < sig.params.size(); i++) {
      args.push_back(builder.makeLocalGet(i, loweredParams[i]));
    }
    module->addFunction(builder.makeFunction(
      std::string("CallRef$") + module->typeNames[type].name.str,
      Signature(Type(runtimeFunctionParams), Type(loweredResults)),
      {},
      builder.makeTrapOnNullParam(
        refParam,
        builder.makeCallIndirect(
          TableName,
          // Load the function pointer from the reference
          builder.makeSimpleUnsignedLoad(
            builder.makeLocalGet(refParam, Type::i32), Type::i32, 4),
          args,
          Signature(Type(loweredParams), Type(loweredResults))))));
  }

  void makeRefAs() {
    Builder builder(*module);
    for (RefAsOp op : {RefAsNonNull, RefAsFunc, RefAsData, RefAsI31}) {
      std::vector<Expression*> list;
      // Check for null.
      list.push_back(builder.makeIf(
        builder.makeUnary(EqZInt32,
                          builder.makeLocalGet(0, loweringInfo.pointerType)),
        builder.makeUnreachable()));
      // Check for a kind, if we need to.
      auto compareRttTo = [&](RttKind kind) {
        list.push_back(builder.makeIf(
          builder.makeBinary(NeInt32,
                             getRttKind(getRtt(builder.makeLocalGet(
                               0, loweringInfo.pointerType))),
                             builder.makeConst(int32_t(kind))),
          builder.makeUnreachable()));
      };
      switch (op) {
        case RefAsNonNull:
          break;
        case RefAsFunc:
          compareRttTo(RttFunc);
          break;
        case RefAsData:
          compareRttTo(RttData);
          break;
        case RefAsI31:
          compareRttTo(RttI31);
          break;
        default:
          WASM_UNREACHABLE("unimplemented ref.as_*");
      }
      // If we passed all the checks, we can return the pointer.
      list.push_back(builder.makeLocalGet(0, loweringInfo.pointerType));
      module->addFunction(builder.makeFunction(
        getName(op),
        {loweringInfo.pointerType, loweringInfo.pointerType},
        {},
        builder.makeBlock(list)));
    }
  }

  void makeRefIs() {
    Builder builder(*module);
    for (RefIsOp op : {RefIsNull, RefIsFunc, RefIsData, RefIsI31}) {
      std::vector<Expression*> list;
      // Check for null.
      list.push_back(builder.makeIf(
        builder.makeUnary(EqZInt32,
                          builder.makeLocalGet(0, loweringInfo.pointerType)),
        builder.makeReturn(builder.makeConst(int32_t(0)))));
      // Check for a kind, if we need to.
      auto compareRttTo = [&](RttKind kind) {
        list.push_back(builder.makeIf(
          builder.makeBinary(NeInt32,
                             getRttKind(getRtt(builder.makeLocalGet(
                               0, loweringInfo.pointerType))),
                             builder.makeConst(int32_t(kind))),
          builder.makeReturn(builder.makeConst(int32_t(0)))));
      };
      switch (op) {
        case RefIsNull:
          break;
        case RefIsFunc:
          compareRttTo(RttFunc);
          break;
        case RefIsData:
          compareRttTo(RttData);
          break;
        case RefIsI31:
          compareRttTo(RttI31);
          break;
        default:
          WASM_UNREACHABLE("unimplemented ref.as_*");
      }
      // If we passed all the checks, we can return the pointer.
      list.push_back(builder.makeConst(int32_t(1)));
      module->addFunction(
        builder.makeFunction(getName(op),
                             {loweringInfo.pointerType, Type::i32},
                             {},
                             builder.makeBlock(list)));
    }
  }

  void makeRefTest() {
    // RefTest(a : ref, b : rtt). Returns 1 if the ref's rtt is a sub-rtt of
    // the rtt param.
    const Index refParam = 0;
    const Index rttParam = 1;
    // Store the ref's rtt in a local
    const Index refRttLocal = 2;
    PointerBuilder builder(*module);
    std::vector<Expression*> list;
    // Check for null.
    list.push_back(builder.makeIf(
      builder.makeUnary(
        EqZInt32, builder.makeLocalGet(refParam, loweringInfo.pointerType)),
      builder.makeReturn(builder.makeConst(int32_t(0)))));
    // Get the ref's rtt.
    list.push_back(builder.makeLocalSet(
      refRttLocal,
      getRtt(builder.makeLocalGet(refParam, loweringInfo.pointerType))));
    // Check for different kinds.
    list.push_back(builder.makeIf(
      builder.makeBinary(
        NeInt32,
        getRttKind(builder.makeLocalGet(rttParam, loweringInfo.pointerType)),
        getRttKind(
          builder.makeLocalGet(refRttLocal, loweringInfo.pointerType))),
      builder.makeReturn(builder.makeConst(int32_t(0)))));
    // Check if the chain of sub-rtts match. That is, we are looking for
    // something like this:
    //
    //  ref's rtt ----> A -> B -> C -> D (where D is an rtt.canon)
    //  rtt param --------------> C -> D
    //
    // Start with a loop to find rttParam in the ref's RTT chain (in the example
    // above, find C in the first line).
    Name loop1("loop1");
    Name block1("block1");
    list.push_back(builder.makeLoop(
      loop1,
      builder.makeBlock(
        block1,
        {// If we found what we want, exit the loop.
         builder.makeBreak(
           block1,
           nullptr,
           builder.makePointerEq(getRttDecl(builder.makeLocalGet(
                                   refRttLocal, loweringInfo.pointerType)),
                                 getRttDecl(builder.makeLocalGet(
                                   rttParam, loweringInfo.pointerType)))),
         // If we reached the end of the ref's rtt's chain, it is not a sub-
         // rtt.
         builder.makeIf(
           builder.makePointerEq(getRttParent(builder.makeLocalGet(
                                   refRttLocal, loweringInfo.pointerType)),
                                 builder.makeConst(Literal::makeFromInt32(
                                   0, loweringInfo.pointerType))),
           builder.makeReturn(builder.makeConst(int32_t(0)))),
         // We can look forward down the chain.
         builder.makeLocalSet(refRttLocal,
                              getRttParent(builder.makeLocalGet(
                                refRttLocal, loweringInfo.pointerType))),
         builder.makeBreak(loop1)})));
    // We found the place where the two chains coincide. From here, they must
    // be identical.
    Name loop2("loop2");
    Name block2("block2");
    list.push_back(builder.makeLoop(
      loop2,
      builder.makeBlock(
        block2,
        {// If they differ, the chains are not equal.
         builder.makeIf(
           builder.makeUnary(
             EqZInt32,
             builder.makePointerEq(getRttParent(builder.makeLocalGet(
                                     refRttLocal, loweringInfo.pointerType)),
                                   getRttParent(builder.makeLocalGet(
                                     rttParam, loweringInfo.pointerType)))),
           builder.makeReturn(builder.makeConst(int32_t(0)))),
         // They are equal here. Looking onward, if just one chain stops, then
         // they are not equal.
         builder.makeIf(
           builder.makeBinary(XorInt32,
                              builder.makePointerNullCheck(builder.makeLocalGet(
                                refRttLocal, loweringInfo.pointerType)),
                              builder.makePointerNullCheck(builder.makeLocalGet(
                                rttParam, loweringInfo.pointerType))),
           builder.makeReturn(builder.makeConst(int32_t(0)))),
         // If both stop, then they are equal.
         builder.makeIf(builder.makePointerNullCheck(builder.makeLocalGet(
                          refRttLocal, loweringInfo.pointerType)),
                        builder.makeReturn(builder.makeConst(int32_t(1)))),
         // We can look forward down the chain.
         builder.makeLocalSet(refRttLocal,
                              getRttParent(builder.makeLocalGet(
                                refRttLocal, loweringInfo.pointerType))),
         builder.makeLocalSet(rttParam,
                              getRttParent(builder.makeLocalGet(
                                rttParam, loweringInfo.pointerType))),
         builder.makeBreak(loop2)})));

    module->addFunction(builder.makeFunction(
      "RefTest",
      {{loweringInfo.pointerType, loweringInfo.pointerType}, Type::i32},
      {loweringInfo.pointerType},
      builder.makeBlock(list)));
  }

  void makeRefCast() {
    // RefTest(a : ref, b : rtt).
    const Index refParam = 0;
    const Index rttParam = 1;
    Builder builder(*module);
    std::vector<Expression*> list;
    // Check for null, and return it if so.
    list.push_back(builder.makeIf(
      builder.makeUnary(
        EqZInt32, builder.makeLocalGet(refParam, loweringInfo.pointerType)),
      builder.makeReturn(builder.makeConst(int32_t(0)))));
    // Trap if the cast fails.
    list.push_back(builder.makeIf(
      builder.makeUnary(
        EqZInt32,
        builder.makeCall(
          "RefTest",
          {builder.makeLocalGet(refParam, loweringInfo.pointerType),
           builder.makeLocalGet(rttParam, loweringInfo.pointerType)},
          Type::i32)),
      builder.makeUnreachable()));
    // Success.
    list.push_back(builder.makeReturn(
      builder.makeLocalGet(refParam, loweringInfo.pointerType)));
    module->addFunction(builder.makeFunction(
      "RefCast",
      {{loweringInfo.pointerType, loweringInfo.pointerType}, Type::i32},
      {loweringInfo.pointerType},
      builder.makeBlock(list)));
  }

  // Given a pointer, load the RTT for it.
  Expression* getRtt(Expression* ptr) {
    // The RTT is the very first field in all GC objects.
    return Builder(*module).makeLoad(loweringInfo.pointerSize,
                                     false,
                                     0,
                                     loweringInfo.pointerSize,
                                     ptr,
                                     loweringInfo.pointerType);
  }

  // Given a pointer to an RTT, load its kind.
  Expression* getRttKind(Expression* ptr) {
    // The RTT kind is the very first field in an RTT
    return Builder(*module).makeLoad(4, false, 0, 4, ptr, Type::i32);
  }

  // Given a pointer to an RTT, load its declared type.
  Expression* getRttDecl(Expression* ptr) {
    // The RTT declared new type is the second field, after the kind (i32).
    return Builder(*module).makeSimpleUnsignedLoad(ptr, Type::i32, 4);
  }

  // Given a pointer to an RTT, load its parent.
  Expression* getRttParent(Expression* ptr) {
    // The RTT parent is the third field, after the kind (i32) and the decl
    // (pointer).
    return Builder(*module).makeSimpleUnsignedLoad(
      ptr, Type::i32, 4 + loweringInfo.pointerSize);
  }

  void addTypeSupport(const std::vector<HeapType>& types) {
    // Analyze the code for heap type usage.
    struct UsageInfo {
      // Types used in rtt.canon instructions.
      std::unordered_map<HeapType, std::atomic<bool>> rttCanons;

      std::map<Name, std::atomic<bool>> refFuncs;
    } usageInfo;
    // Initialize the data so it is safe to operate on in parallel.
    for (auto type : types) {
      usageInfo.rttCanons[type] = false;
    }
    for (auto& func : module->functions) {
      usageInfo.refFuncs[func->name] = false;
    }
    {
      struct Analysis : public WalkerPass<PostWalker<Analysis>> {
        UsageInfo* usageInfo;

        Analysis(UsageInfo* usageInfo) : usageInfo(usageInfo) {}

        void visitRefFunc(RefFunc* curr) {
          usageInfo->refFuncs[curr->func] = true;
          // ref.funcs use an rtt.canon internally. Mark the appropriate
          // rtt.canon here as well, so that it will exist when the ref.func
          // needs it later down.
          usageInfo->rttCanons[curr->type.getHeapType()] = true;
        }
        void visitRttCanon(RttCanon* curr) {
          usageInfo->rttCanons[curr->type.getHeapType()] = true;
        }
      };
      PassRunner runner(module);
      Analysis analysis(&usageInfo);
      analysis.run(&runner, module);
      // fill in global uses
      analysis.walkModuleCode(module);
    }
    for (auto& kv : usageInfo.rttCanons) {
      HeapType type = kv.first;
      bool used = kv.second;
      if (used) {
        makeRttCanon(type);
      }
    }
    for (auto& kv : usageInfo.refFuncs) {
      Name name = kv.first;
      bool used = kv.second;
      if (used) {
        makeRefFunc(name);
      }
    }
    makeRttSub();
  }

  void makeRttCanon(HeapType type) {
    // Allocate this rtt at the next free location.
    auto addr =
      loweringInfo.compileTimeMalloc(4 + 2 * loweringInfo.pointerSize);
    loweringInfo.rttCanonAddrs[type] = addr;
    int32_t rttValue;
    if (type.isFunction()) {
      rttValue = RttFunc;
    } else if (type.isData()) {
      rttValue = RttData;
    } else {
      WASM_UNREACHABLE("bad rtt");
    }
    PointerBuilder builder(*module);
    // Write the rtt kind.
    startBlock->list.push_back(
      builder.makeSimpleStore(builder.makeConst(int32_t(addr)),
                              builder.makeConst(int32_t(rttValue)),
                              Type::i32));
    // Write the type field, which points to ourself.
    startBlock->list.push_back(
      builder.makePointerStore(builder.makeConst(int32_t(addr + 4)),
                               builder.makeConst(Literal::makeFromInt32(
                                 addr, loweringInfo.pointerType))));
    // Write a null pointer for the parent.
    startBlock->list.push_back(builder.makeStore(
      loweringInfo.pointerSize,
      0,
      loweringInfo.pointerSize,
      builder.makeConst(int32_t(addr + 4 + loweringInfo.pointerSize)),
      builder.makeConst(Literal::makeFromInt32(0, loweringInfo.pointerType)),
      loweringInfo.pointerType));
  }

  void makeRttSub() {
    Builder builder(*module);
    // We need one local to store the allocated value. It has index 2, after
    // the parameters, which are the new type, and the old rtt we are subbing.
    auto alloc = 2;
    std::vector<Expression*> list;
    // Malloc space for our struct.
    list.push_back(builder.makeLocalSet(
      alloc,
      builder.makeCall(
        loweringInfo.malloc,
        {builder.makeConst(int32_t(4 + 2 * loweringInfo.pointerSize))},
        loweringInfo.pointerType)));
    // Copy the kind from the input rtt
    list.push_back(builder.makeStore(
      4,
      0,
      4,
      builder.makeLocalGet(alloc, loweringInfo.pointerType),
      builder.makeLoad(4,
                       false,
                       0,
                       4,
                       builder.makeLocalGet(0, loweringInfo.pointerType),
                       Type::i32),
      loweringInfo.pointerType));
    // Store a pointer to the new heap type.
    list.push_back(
      builder.makeStore(loweringInfo.pointerSize,
                        4,
                        loweringInfo.pointerSize,
                        builder.makeLocalGet(alloc, loweringInfo.pointerType),
                        builder.makeLocalGet(0, loweringInfo.pointerType),
                        loweringInfo.pointerType));
    // Store a pointer to the parent rtt.
    list.push_back(
      builder.makeStore(loweringInfo.pointerSize,
                        4,
                        loweringInfo.pointerSize,
                        builder.makeLocalGet(alloc, loweringInfo.pointerType),
                        builder.makeLocalGet(1, loweringInfo.pointerType),
                        loweringInfo.pointerType));
    // Return the pointer.
    list.push_back(builder.makeLocalGet(alloc, loweringInfo.pointerType));
    module->addFunction(builder.makeFunction(
      "RttSub",
      {{loweringInfo.pointerType, loweringInfo.pointerType},
       loweringInfo.pointerType},
      {loweringInfo.pointerType},
      builder.makeBlock(list)));
  }

  Index addToTable(Name name) {
    Builder builder(*module);
    auto index = segment->data.size();
    segment->data.push_back(
      builder.makeRefFunc(name, HeapType(module->getFunction(name)->sig)));
    table->initial++;
    table->max++;
    return index;
  }

  void makeRefFunc(Name name) {
    auto* func = module->getFunction(name);
    // Add the function to the table.
    auto tableIndex = addToTable(name);
    // Allocate this ref.func at the next free location.
    auto addr = loweringInfo.compileTimeMalloc(4 + loweringInfo.pointerSize);
    loweringInfo.refFuncAddrs[name] = addr;
    PointerBuilder builder(*module);
    // Write the rtt.
    auto type = HeapType(func->sig);
    startBlock->list.push_back(builder.makePointerStore(
      builder.makePointerConst(addr),
      builder.makePointerConst(loweringInfo.rttCanonAddrs[type])));
    // Write the table index
    startBlock->list.push_back(
      builder.makeSimpleStore(builder.makePointerConst(addr + 4),
                              builder.makeConst(int32_t(tableIndex)),
                              Type::i32));
  }

  // Some global initializers need to be lowered into non-globals. Specifically,
  // rtt.sub operations are turned into calls, which are not allowed in global
  // inits, so we add them to the start.
  void processGlobals() {
    Builder builder(*module);
    for (auto& global : module->globals) {
      if (global->init) {
        if (auto* rttSub = global->init->dynCast<RttSub>()) {
          startBlock->list.push_back(builder.makeGlobalSet(
            global->name,
            builder.makeCall(
              "RttSub",
              {LiteralUtils::makeFromInt32(
                 loweringInfo.rttCanonAddrs[rttSub->type.getHeapType()],
                 loweringInfo.pointerType,
                 *module),
               rttSub->parent},
              Type::i32)));
          // Set a 0 as a placeholder for the global.
          global->init = builder.makeConst(int32_t(0));
          // Unfortunately, we must make the global mutable so we can write to
          // it after initialization.
          global->mutable_ = true;
        }
      }
      global->type = lower(global->type);
    }
  }

  void lowerCode(PassRunner* runner) {
    PassRunner subRunner(runner);
    subRunner.add(
      std::unique_ptr<LowerGCCode>(LowerGCCode(&loweringInfo).create()));
    subRunner.setIsNested(true);
    subRunner.run();

    LowerGCCode lower(&loweringInfo);
    lower.setModule(module);
    // Walk module-level code. We must avoid walkModuleCode() because we must
    // *not* process the table. The table can contain RefFunc items, and we do
    // not need to lower those.
    for (auto& curr : module->globals) {
      if (!curr->imported()) {
        lower.walk(curr->init);
      }
    }
    for (auto& curr : module->elementSegments) {
      if (curr->offset) {
        lower.walk(curr->offset);
      }
    }
  }

  Type lower(Type type) { return getLoweredType(type, module->memory); }
};

Pass* createLowerGCPass() { return new LowerGC(); }

} // namespace wasm
