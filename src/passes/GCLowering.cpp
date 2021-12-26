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
// Lowers Wasm GC to linear memory. This implements GC structs and arrays in
// linear memory, and should be precise except for the actual collection of
// garbage, which is left as a TODO
//
// Layouts:
//
//   Struct:
//   +-----------------------+
//   | (type)    | (purpose) |
//   +-----------------------+
//   | ptr       | rtt       |
//   | types...  | data...   |
//   +-----------------------+
//
//   Array:
//   +-----------------+
//   | ptr      | rtt  |
//   | u32      | size |
//   | type...  | data |
//   +-----------------+
//
//   Func:
//   +-------------------------------+
//   | ptr      | rtt                |
//   | u32      | Index in the table |
//   +-------------------------------+
//
//   Rtts:
//   +-----------------------------------------------------------------------+
//   | u32    | What (RttKind) - func, data, i31, extern                     |
//   | u32    | Size of the list of types. This is the same as the           |
//   |        |   list RttSupers in literal.h, except that it contains all   |
//   |        |   the types, including the last (RttSupers stores the last   |
//   |        |   on the "type" field of the Literal, to avoid duplication). |
//   | ptr*   | List of types. Each is a pointer to the rtt.canon for the    |
//   |        |   type. In an rtt.canon, this points to the object itself,   |
//   |        |   that is, we will have ptr => [kind, 1, ptr]. An rtt.sub    |
//   |        |   copies the list of the parent, and appends the new type at |
//   |        |   the end, much like RttSupers as mentioned earlier.         |
//   +-----------------------------------------------------------------------+
//
//  Note that we allocate unique rtt.canon addresses at compile time, but we do
//  not currently make an effort to do the same for rtt.sub, which would require
//  a hash map to be used at runtime.
//

#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/table-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// A Builder with additional helper functions for doing things with pointers.
class PointerBuilder : public Builder {
public:
  PointerBuilder(Module& wasm) : Builder(wasm) {}

  // Makes a simple load that is aligned and of the full size.
  Expression*
  makeSimpleLoad(Expression* ptr, Type type, Address offset = 0) {
    auto size = type.getByteSize();
    // The sign does not matter as the load is of the full size; set false for
    // unsigned.
    return makeLoad(size, false, offset, size, ptr, type);
  }

  // Makes a simple store that is aligned and of the full size.
  Expression* makeSimpleStore(Expression* ptr,
                              Expression* value,
                              Type type,
                              Address offset = 0) {
    auto size = type.getByteSize();
    return makeStore(size, offset, size, ptr, value, type);
  }

  // Make a constant for a pointer value. This handles wasm32/64 differences.
  Expression* makePointerConst(Address addr) {
    if (wasm.memory.is64()) {
      return makeConst(int64_t(addr));
    }
    return makeConst(int32_t(addr));
  }

  // Get a pointer from a local.
  Expression* makePointerGet(Index index) {
    return makeLocalGet(index, wasm.memory.indexType);
  }

  // Load a pointer from memory.
  Expression* makePointerLoad(Expression* ptr, Address offset = 0) {
    return makeSimpleLoad(ptr, wasm.memory.indexType, offset);
  }

  // Store a pointer to memory.
  Expression*
  makePointerStore(Expression* ptr, Expression* value, Address offset = 0) {
    return makeSimpleStore(ptr, value, wasm.memory.indexType, offset);
  }

  // Store a pointer to memory, where the pointer is a constant.
  Expression*
  makePointerStore(Expression* ptr, Address addr, Address offset = 0) {
    return makeSimpleStore(
      ptr, makePointerConst(addr), wasm.memory.indexType, offset);
  }

  // Compare pointers.
  Expression* makePointerEq(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(EqInt64, a, b);
    }
    return makeBinary(EqInt32, a, b);
  }

  // Check pointers are not equal.
  Expression* makePointerNe(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(NeInt64, a, b);
    }
    return makeBinary(NeInt32, a, b);
  }

  // Add pointers.
  Expression* makePointerAdd(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(AddInt64, a, b);
    }
    return makeBinary(AddInt32, a, b);
  }

  // Add a pointers to a constant
  Expression* makePointerAdd(Expression* a, Address b) {
    auto* bExpression = makePointerConst(b);
    if (wasm.memory.is64()) {
      return makeBinary(AddInt64, a, bExpression);
    }
    return makeBinary(AddInt32, a, bExpression);
  }

  // Multiply pointers.
  Expression* makePointerMul(Expression* a, Expression* b) {
    if (wasm.memory.is64()) {
      return makeBinary(MulInt64, a, b);
    }
    return makeBinary(MulInt32, a, b);
  }

  // Null-check a pointer.
  Expression* makePointerIsNull(Expression* a) {
    if (wasm.memory.is64()) {
      return makeUnary(EqZInt64, a);
    }
    return makeUnary(EqZInt32, a);
  }

  // Make a null check of a parameter to a function, that is, code that traps
  // if the parameter is null.
  Expression* makeTrapOnNullParam(Index param,
                                  Expression* otherwise = nullptr) {
    return makeIf(
      makePointerIsNull(makeLocalGet(param, wasm.memory.indexType)),
      makeUnreachable(),
      otherwise);
  }
};

// Return a string name for RefAs etc. ops, which we need to emit function names
// for them.

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

// The kind of an rtt, as stored in memory in an rtt instance.
enum RttKind {
  RttFunc = 0,
  RttData = 1,
  RttI31 = 2,
  RttExtern = 3,
};

// Core lowering operation. Turns references and rtts into pointers in linear
// memory.
static Type lowerType(Type type, Memory& memory) {
  if (type.isRef() || type.isRtt()) {
    return memory.indexType;
  }
  return type;
}

static Type lowerType(Type type, Module& wasm) {
  return lowerType(type, wasm.memory);
}

Signature lowerSig(Signature sig, Module& wasm) {
  std::vector<Type> params;
  for (auto t : sig.params) {
    params.push_back(lowerType(t, wasm));
  }
  std::vector<Type> results;
  for (auto t : sig.results) {
    results.push_back(lowerType(t, wasm));
  }
  return Signature(Type(params), Type(results));
}

// The layout of a struct in linear memory.
struct StructLayout {
  // The total size of the struct.
  Address size;
  // The offsets of fields. Note that the first field's offset will not be 0
  // because we need room for the rtt.
  SmallVector<Address, 4> fieldOffsets;
};

using StructLayouts = std::unordered_map<HeapType, StructLayout>;

// Information we need as we lower an entire module.
struct LoweringInfo {
  StructLayouts layouts;

  // The name of the malloc function, and where it should start allocating at.
  Name malloc;
  Address mallocStart = 0;

  Address pointerSize;
  Type pointerType;

  // The addresses of rtt.canons. Each rtt.canon is statically allocated a
  // singleton position in memory, and will point there.
  std::unordered_map<HeapType, Address> rttCanonAddrs;

  // As with rtt.canon, we allocate a singleton ref.func for each func that
  // needs one.
  std::unordered_map<Name, Address> refFuncAddrs;

  // The table we use for ref.func values and in call_ref.
  Name tableName;

  // Allocate memory at compile time.
  Address compileTimeMalloc(Address size) {
    // We can only run after we have decided where to begin allocating.
    assert(mallocStart > 0);
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

  LoweringInfo* const loweringInfo;

  using Parent =
    WalkerPass<PostWalker<LowerGCCode, UnifiedExpressionVisitor<LowerGCCode>>>;

  LowerGCCode* create() override { return new LowerGCCode(loweringInfo); }

  LowerGCCode(LoweringInfo* loweringInfo) : loweringInfo(loweringInfo) {}

  // visitExpression() performs generic fixups that are needed in all classes.
  // When a specific visitor is defined, they must also call this one
  // before doing any changes.
  void visitExpression(Expression* curr) {
    auto type = curr->type;

    // Record the original types of things, which may be needed later.
    if (type.isRef() || type.isRtt()) {
      originalTypes[getCurrentPointer()] = type.getHeapType();
    }

    // Update the type.
    curr->type = lower(type);
  }

  // Specific visitors. Many of these call a runtime method that replaces an
  // instruction. (We rely on inlining to make this fast.)

  void visitCallIndirect(CallIndirect* curr) {
    visitExpression(curr);

    curr->sig = lower(curr->sig);
  }

  void visitRefNull(RefNull* curr) {
    visitExpression(curr);

    // A null is simply a zero.
    replaceCurrent(LiteralUtils::makeZero(curr->type, *getModule()));
  }

  void visitRefEq(RefEq* curr) {
    visitExpression(curr);

    replaceCurrent(
      PointerBuilder(*getModule()).makePointerEq(curr->left, curr->right));
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

    // Emit a call to a runtime method that handles the original type.
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
    replaceCurrent(
      builder.makeCall(name,
                       {curr->ref, builder.makeConst(int32_t(curr->signed_))},
                       lower(curr->type)));
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
    auto loweredType = lower(element.type);
    replaceCurrent(builder.makeCall(
      name,
      {curr->ref, curr->index, builder.makeConst(int32_t(curr->signed_))},
      loweredType));
  }

  void visitArrayLen(ArrayLen* curr) {
    visitExpression(curr);

    Builder builder(*getModule());
    replaceCurrent(builder.makeCall("ArrayLen", {curr->ref}, Type::i32));
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
    // Use the original type to find the address of the singleton instance for
    // this rtt.canon.
    auto type = curr->type.getHeapType();
    visitExpression(curr);
    replaceCurrent(
      LiteralUtils::makeFromInt32(loweringInfo->rttCanonAddrs[type],
                                  loweringInfo->pointerType,
                                  *getModule()));
  }

  void visitRttSub(RttSub* curr) {
    // Use the original type to find the address of the singleton instance for
    // the type we are subtyping here.
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
    // Parameters and return values are already lowered on all functions
    // (imported and not). Lower the variables.
    for (auto& t : func->vars) {
      t = lower(t);
    }

    // Lower all the code.
    Parent::doWalkFunction(func);
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
  // well), so the pointer is a valid key to use in this lookup.
  //
  // (If an expression has no heap type, we do not note anything for it here.)
  std::unordered_map<Expression**, HeapType> originalTypes;

  Type lower(Type type) { return lowerType(type, *getModule()); }
  Signature lower(Signature sig) { return lowerSig(sig, *getModule()); }
};

} // anonymous namespace

struct LowerGC : public Pass {
  void run(PassRunner* runner, Module* module_) override {
    module = module_;

    // Collect all the heap types in order to analyze them and decide on their
    // layout in linear memory.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);

    // Ensure types have names, as we use the names when creating the
    // runtime code.
    // Also remove unreachable code so that we do not need to handle that in
    // any of the runtime.
    {
      PassRunner subRunner(runner);
      subRunner.add("name-types");
      subRunner.add("dce");
      subRunner.setIsNested(true);
      subRunner.run();
    }

    pickNames();
    addMemory();
    addTable();
    addStart();
    addGCRuntime(types);
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
    // 1GB, arbitrarily for now.
    const Address MemoryPages = 16384;
    if (!module->memory.exists) {
      // Add a memory and use all of it.
      module->memory.exists = true;
      module->memory.initial = module->memory.max = MemoryPages;

      // Start allocating at address 8, so that lower numbers can have special
      // meanings (like 0 meaning "null").
      loweringInfo.mallocStart = 8;
    } else {
      // Append to an existing (non-growing) memory.
      if (module->memory.initial != module->memory.max) {
        Fatal() << "LowerGC disallows memory growth";
      }
      loweringInfo.mallocStart = module->memory.initial * Memory::kPageSize;
      module->memory.initial = module->memory.max =
        module->memory.initial + MemoryPages;
    }

    loweringInfo.pointerType = module->memory.indexType;
    loweringInfo.pointerSize = loweringInfo.pointerType.getByteSize();
  }

  void addTable() {
    Builder builder(*module);

    // Add a new table just for us.
    loweringInfo.tableName = Names::getValidTableName(*module, "lowergc-table");

    // Start the table at size 0, and increase it as needed as we go.
    table = module->addTable(
      builder.makeTable(loweringInfo.tableName, Type::funcref, 0, 0));

    // Add an element segment to append to.
    segment = module->addElementSegment(builder.makeElementSegment(
      "lowergc-segment", table->name, builder.makeConst(int32_t(0))));
  }

  // Ensure a block of code in a start function that we can append to. If
  // there is already a start, our code goes before it.
  void addStart() {
    Builder builder(*module);
    auto oldStart = module->start;
    module->start = Names::getValidFunctionName(*module, "lowergc-start");
    startBlock = builder.makeBlock();
    Expression* body;
    if (oldStart.is()) {
      body = builder.makeSequence(startBlock,
                                  builder.makeCall(oldStart, {}, Type::none));
    } else {
      body = startBlock;
    }
    module->addFunction(builder.makeFunction(
      module->start, Signature({Type::none, Type::none}), {}, body));
  }

  void addMalloc() {
    Builder builder(*module);
    auto* nextMalloc = module->addGlobal(builder.makeGlobal(
      Names::getValidGlobalName(*module, "lowergc-next-malloc"),
      Type::i32,
      builder.makeConst(int32_t(loweringInfo.mallocStart)),
      Builder::Mutable));

    // Disallow further allocation at compile time, by setting an invalid value
    // for the start.
    loweringInfo.mallocStart = 0;

    // Allocate by bumping nextMalloc and returning the previous value.
    auto* alloc = builder.makeGlobalSet(
      nextMalloc->name,
      builder.makeBinary(AddInt32,
                         builder.makeGlobalGet(nextMalloc->name, Type::i32),
                         builder.makeLocalGet(0, Type::i32)));

    // Check for an OOM.
    // TODO: integer overflow checks as well
    auto* check = builder.makeIf(
      builder.makeBinary(
        GeUInt32,
        builder.makeGlobalGet(nextMalloc->name, Type::i32),
        builder.makeBinary(MulInt32,
                           builder.makeMemorySize(),
                           builder.makeConst(uint32_t(Memory::kPageSize)))),
      builder.makeUnreachable());
    auto* ret =
      builder.makeBinary(SubInt32,
                         builder.makeGlobalGet(nextMalloc->name, Type::i32),
                         builder.makeLocalGet(0, Type::i32));
    module->addFunction(
      builder.makeFunction(loweringInfo.malloc,
                           Signature({Type::i32, Type::i32}),
                           {},
                           builder.makeBlock({alloc, check, ret})));
    // TODO: more than a simple bump allocator that never frees or collects.
  }

  void addGCRuntime(const std::vector<HeapType>& types) {
    // Emit support code for specific types.
    //
    // Note that some of this support code may end up identical; those can be
    // de-duplicated by other passes later. We also emit all the code here, and
    // rely on other passes to remove unneeded things.
    for (auto type : types) {
      makeRttCanon(type);
      if (type.isStruct()) {
        computeLayout(type);
        makeStructNew(type);
        makeStructSet(type);
        makeStructGet(type);
      } else if (type.isArray()) {
        makeArrayNew(type);
        makeArraySet(type);
        makeArrayGet(type);
      } else if (type.isFunction()) {
        makeCallRef(type);
      }
    }

    // Emit general support code that does not depend on the type.
    makeRefAs();
    makeRefIs();
    makeRefTest();
    makeRefCast();
    makeRttSub();
    makeArrayLen();

    // Add runtime support based on actual usage of types.
    addUsageBasedGCRuntime(types);
  }

  // Compute the layout of a specific heap type.
  void computeLayout(HeapType type) {
    StructLayout& layout = loweringInfo.layouts[type];

    // A pointer to the RTT takes up the first bytes in the struct, so fields
    // start afterwards.
    Address nextField = loweringInfo.pointerSize;
    auto& fields = type.getStruct().fields;
    for (auto& field : fields) {
      layout.fieldOffsets.push_back(nextField);
      auto bytes = getBytes(field);
      nextField = nextField + bytes;
    }
    layout.size = nextField;
  }

  void makeStructNew(HeapType type) {
    // StructNew$heap-type ([value1, .., valueN,] ref rtt) -> allocated pointer

    auto typeName = module->typeNames[type].name.str;
    auto& fields = type.getStruct().fields;
    PointerBuilder builder(*module);
    for (bool withDefault : {true, false}) {
      if (withDefault) {
        bool isDefaultable = true;
        for (auto& field : fields) {
          if (!field.type.isDefaultable()) {
            isDefaultable = false;
            break;
          }
        }

        // We do not need a defaultable variant for a non-defaultable struct.
        if (!isDefaultable) {
          continue;
        }
      }

      // If this is not withDefault, add the params.
      std::vector<Type> params;
      if (!withDefault) {
        for (Index i = 0; i < fields.size(); i++) {
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
      list.push_back(builder.makePointerStore(
        builder.makeLocalGet(alloc, loweringInfo.pointerType),
        builder.makeLocalGet(rttParam, loweringInfo.pointerType)));

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

      // Return the allocated pointer.
      list.push_back(builder.makePointerGet(alloc));
      std::string name = "StructNew";
      if (withDefault) {
        name += "WithDefault";
      }
      module->addFunction(
        builder.makeFunction(name + '$' + typeName,
                             Signature({Type(params), Type::i32}),
                             {loweringInfo.pointerType},
                             builder.makeBlock(list)));
    }
  }

  void makeStructSet(HeapType type) {
    // StructSet$heap-type (ref ptr, type value)

    auto& fields = type.getStruct().fields;
    PointerBuilder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = lower(field.type);
      auto bytes = getBytes(field);
      module->addFunction(builder.makeFunction(
        std::string("StructSet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        Signature({{loweringInfo.pointerType, loweredType}, Type::none}),
        {},
        builder.makeTrapOnNullParam(
          0,
          builder.makeStore(bytes,
                            loweringInfo.layouts[type].fieldOffsets[i],
                            bytes,
                            builder.makePointerGet(0),
                            builder.makeLocalGet(1, loweredType),
                            loweredType))));
    }
  }

  void makeStructGet(HeapType type) {
    // StructGet$heap-type (ref ptr, bool signed) -> loaded value

    auto& fields = type.getStruct().fields;
    PointerBuilder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = lower(field.type);
      auto bytes = getBytes(field);
      auto makeLoad = [&](bool signed_) {
        return builder.makeLoad(bytes,
                                signed_,
                                loweringInfo.layouts[type].fieldOffsets[i],
                                bytes,
                                builder.makePointerGet(0),
                                loweredType);
      };
      Expression* body;
      if (field.isPacked()) {
        body = builder.makeIf(
          builder.makeUnary(EqZInt32, builder.makeLocalGet(1, Type::i32)),
          makeLoad(false),
          makeLoad(true));
      } else {
        body = makeLoad(false);
      }
      module->addFunction(builder.makeFunction(
        std::string("StructGet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        Signature({{loweringInfo.pointerType, Type::i32}, loweredType}),
        {},
        builder.makeTrapOnNullParam(0, body)));
    }
  }

  void makeArrayNew(HeapType type) {
    // ArrayNew$heap-type ([type value,]
    //                      u32 size,
    //                      rtt rtt) -> allocated pointer

    auto typeName = module->typeNames[type].name.str; // waka
    auto element = type.getArray().element;
    auto loweredType = lower(element.type);
    auto bytes = getBytes(element);
    PointerBuilder builder(*module);
    for (bool withDefault : {true, false}) {
      if (withDefault && !element.type.isDefaultable()) {
        // We do not need a defaultable variant for a non-defaultable array.
        continue;
      }
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
            builder.makePointerMul(builder.makePointerConst(bytes),
                                   builder.makePointerGet(sizeParam)))},
          loweringInfo.pointerType)));

      // Store the size.
      list.push_back(builder.makePointerStore(
        builder.makePointerGet(alloc), builder.makePointerGet(sizeParam), 4));

      // Store the rtt.
      list.push_back(builder.makePointerStore(
        builder.makePointerGet(alloc), builder.makePointerGet(rttParam)));

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
        {builder.makePointerGet(alloc),
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
      list.push_back(builder.makePointerGet(alloc));

      std::string name = "ArrayNew";
      if (withDefault) {
        name += "WithDefault";
      }
      module->addFunction(builder.makeFunction(
        name + '$' + typeName,
        Signature({Type(params), loweringInfo.pointerType}),
        {loweringInfo.pointerType},
        builder.makeBlock(list)));
    }
  }

  // Emit an expression to compute the offset in an array, assuming the pointer
  // is in local #0 and the index in local #1. Basically this returns
  // $0 + (fieldSize * $1)
  Expression* makeArrayOffset(const Field& field) {
    PointerBuilder builder(*module);
    return builder.makeBinary(
      AddInt32,
      builder.makeBinary(
        AddInt32, builder.makePointerGet(0), builder.makeConst(int32_t(8))),
      builder.makeBinary(MulInt32,
                         builder.makeConst(int32_t(getBytes(field))),
                         builder.makePointerGet(1)));
  }

  void makeArraySet(HeapType type) {
    // ArraySet$heap-type (ref ptr, u32 index, type value)

    auto element = type.getArray().element;
    auto loweredType = lower(element.type);
    auto bytes = getBytes(element);
    PointerBuilder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArraySet$") + module->typeNames[type].name.str,
      Signature(
        {{loweringInfo.pointerType, loweringInfo.pointerType, loweredType},
         Type::none}),
      {},
      builder.makeTrapOnNullParam(
        0,
        builder.makeStore(bytes,
                          0,
                          bytes,
                          makeArrayOffset(element),
                          builder.makeLocalGet(2, loweredType),
                          loweredType))));
  }

  void makeArrayGet(HeapType type) {
    // ArrayGet$heap-type (ref ptr, u32 index, bool signed) -> value

    auto element = type.getArray().element;
    auto bytes = getBytes(element);
    auto loweredType = lower(element.type);
    PointerBuilder builder(*module);
    auto makeLoad = [&](bool signed_) {
      return builder.makeLoad(
        bytes, signed_, 0, bytes, makeArrayOffset(element), loweredType);
    };
    Expression* body;
    if (element.isPacked()) {
      body = builder.makeIf(
        builder.makeUnary(EqZInt32, builder.makeLocalGet(2, Type::i32)),
        makeLoad(false),
        makeLoad(true));
    } else {
      body = makeLoad(false);
    }

    module->addFunction(builder.makeFunction(
      std::string("ArrayGet$") + module->typeNames[type].name.str,
      Signature(
        {{loweringInfo.pointerType, loweringInfo.pointerType, Type::i32},
         loweredType}),
      {},
      builder.makeTrapOnNullParam(0, body)));
  }

  void makeArrayLen() {
    // ArrayLen$heap-type (ref ptr) -> u32

    PointerBuilder builder(*module);
    module->addFunction(builder.makeFunction(
      "ArrayLen",
      Signature({{loweringInfo.pointerType}, Type::i32}),
      {},
      builder.makeTrapOnNullParam(0,
                                  builder.makeSimpleLoad(
                                    builder.makePointerGet(0), Type::i32, 4))));
  }

  void makeCallRef(HeapType type) {
    // CallRef$heap-type (param1, .., paramN, u32 index) -> results

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
          loweringInfo.tableName,
          // Load the function pointer from the reference
          builder.makeSimpleLoad(
            builder.makeLocalGet(refParam, Type::i32), Type::i32, 4),
          args,
          Signature(Type(loweredParams), Type(loweredResults))))));
  }

  void makeRefAs() {
    // RefAs (ref ptr) -> ref

    PointerBuilder builder(*module);
    for (RefAsOp op : {RefAsNonNull, RefAsFunc, RefAsData, RefAsI31}) {
      std::vector<Expression*> list;

      // Check for a kind, if we need to.
      auto compareRttTo = [&](RttKind kind) {
        list.push_back(builder.makeIf(
          builder.makeBinary(NeInt32,
                             getRttKind(getRtt(builder.makePointerGet(0))),
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
      list.push_back(builder.makePointerGet(0));
      module->addFunction(builder.makeFunction(
        getName(op),
        Signature({loweringInfo.pointerType, loweringInfo.pointerType}),
        {},
        builder.makeTrapOnNullParam(0, builder.makeBlock(list))));
    }
  }

  void makeRefIs() {
    // RefIs (ref ptr) -> i32

    PointerBuilder builder(*module);
    for (RefIsOp op : {RefIsNull, RefIsFunc, RefIsData, RefIsI31}) {
      std::vector<Expression*> list;

      // Check for null.
      list.push_back(builder.makeIf(
        builder.makeUnary(EqZInt32, builder.makePointerGet(0)),
        builder.makeReturn(builder.makeConst(int32_t(op == RefIsNull)))));

      // Check for a kind, if we need to.
      auto compareRttTo = [&](RttKind kind) {
        list.push_back(builder.makeIf(
          builder.makeBinary(NeInt32,
                             getRttKind(getRtt(builder.makePointerGet(0))),
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
      list.push_back(builder.makeConst(int32_t(op != RefIsNull)));
      module->addFunction(
        builder.makeFunction(getName(op),
                             Signature({loweringInfo.pointerType, Type::i32}),
                             {},
                             builder.makeBlock(list)));
    }
  }

  void makeRefTest() {
    // RefTest (ref a, rtt b) -> u32 (1 if the ref's rtt is a sub-rtt of
    // the rtt param)

    const Index refParam = 0;
    const Index rttParam = 1;

    // We will store the ref's rtt in a local
    const Index refRttLocal = 2;

    // We will store the size in a local as we loop.
    const Index sizeLocal = 3;

    PointerBuilder builder(*module);
    std::vector<Expression*> list;

    // Check for null.
    list.push_back(builder.makeIf(
      builder.makeUnary(EqZInt32, builder.makePointerGet(refParam)),
      builder.makeReturn(builder.makeConst(int32_t(0)))));

    // Get the ref's rtt.
    list.push_back(builder.makeLocalSet(
      refRttLocal, getRtt(builder.makePointerGet(refParam))));

    // Check for different kinds.
    list.push_back(builder.makeIf(
      builder.makeBinary(NeInt32,
                         getRttKind(builder.makePointerGet(rttParam)),
                         getRttKind(builder.makePointerGet(refRttLocal))),
      builder.makeReturn(builder.makeConst(int32_t(0)))));

    // Check if the chain of sub-rtts match. That is, we are looking for
    // the ref's rtt to be a super-rtt of the other, which means it is identical
    // to it, or adds further things to the list of types at the end. First,
    // check the size makes sense.
    list.push_back(builder.makeIf(
      builder.makeBinary(GtUInt32,
                         getRttSize(builder.makePointerGet(rttParam)),
                         getRttSize(builder.makePointerGet(refRttLocal))),
      builder.makeReturn(builder.makeConst(int32_t(0)))));

    // The sizes are potentially compatible. Scan the list of types.
    list.push_back(builder.makeLocalSet(
      sizeLocal, getRttSize(builder.makePointerGet(rttParam))));
    Name loop("loop");
    list.push_back(builder.makeLoop(
      loop,
      builder.makeBlock(std::vector<Expression*>{
        // Compare one value.
        builder.makeIf(
          builder.makePointerNe(
            builder.makePointerLoad(
              builder.makePointerGet(rttParam),
              // Constantly pass offsets of 8 here, to skip the first two fields
              // in each rtt data structure. We could also first do an
              // increment, at the cost of code size.
              8),
            builder.makePointerLoad(builder.makePointerGet(refRttLocal), 8)),
          builder.makeReturn(builder.makeConst(int32_t(0)))),

        // Increment both pointers
        builder.makeLocalSet(
          rttParam,
          builder.makePointerAdd(builder.makePointerGet(rttParam),
                                 loweringInfo.pointerSize)),
        builder.makeLocalSet(
          refRttLocal,
          builder.makePointerAdd(builder.makePointerGet(refRttLocal),
                                 loweringInfo.pointerSize)),

        // Loop while there is more.
        builder.makeLocalSet(
          sizeLocal,
          builder.makeBinary(SubInt32,
                             builder.makeLocalGet(sizeLocal, Type::i32),
                             builder.makeConst(int32_t(1)))),
        builder.makeBreak(
          loop, nullptr, builder.makeLocalGet(sizeLocal, Type::i32)),
        builder.makeReturn(builder.makeConst(int32_t(1)))})));
    module->addFunction(builder.makeFunction(
      "RefTest",
      Signature(
        {{loweringInfo.pointerType, loweringInfo.pointerType}, Type::i32}),
      {loweringInfo.pointerType, Type::i32},
      builder.makeBlock(list)));
  }

  void makeRefCast() {
    // RefCast(ref a, rtt b) -> ref

    const Index refParam = 0;
    const Index rttParam = 1;
    PointerBuilder builder(*module);
    std::vector<Expression*> list;

    // Check for null, and return it if so.
    list.push_back(builder.makeIf(
      builder.makeUnary(EqZInt32, builder.makePointerGet(refParam)),
      builder.makeReturn(builder.makeConst(int32_t(0)))));

    // Trap if the cast fails.
    list.push_back(builder.makeIf(
      builder.makeUnary(EqZInt32,
                        builder.makeCall("RefTest",
                                         {builder.makePointerGet(refParam),
                                          builder.makePointerGet(rttParam)},
                                         Type::i32)),
      builder.makeUnreachable()));

    // Success.
    list.push_back(builder.makeReturn(builder.makePointerGet(refParam)));
    module->addFunction(builder.makeFunction(
      "RefCast",
      Signature(
        {{loweringInfo.pointerType, loweringInfo.pointerType}, Type::i32}),
      {loweringInfo.pointerType},
      builder.makeBlock(list)));
  }

  // Given a pointer, load the RTT for it.
  Expression* getRtt(Expression* ptr) {
    // The RTT is the very first field in all GC objects.
    return PointerBuilder(*module).makePointerLoad(ptr);
  }

  // Given a pointer to an RTT, load its kind.
  Expression* getRttKind(Expression* ptr) {
    // The RTT kind is the very first field in an RTT
    return PointerBuilder(*module).makeSimpleLoad(ptr, Type::i32);
  }

  Expression* getRttSize(Expression* ptr) {
    // The RTT size is the second field in an RTT, after the kind.
    return PointerBuilder(*module).makeSimpleLoad(ptr, Type::i32, 4);
  }

  // Certain things require us to scan the actual usage of heap types in order
  // to emit reasonable code. For example, we don't want to emit a ref.func for
  // every single function.
  void addUsageBasedGCRuntime(const std::vector<HeapType>& types) {
    struct UsageInfo {
      std::map<Name, std::atomic<bool>> refFuncs;
    } usageInfo;

    // Initialize the data so it is safe to operate on in parallel.
    for (auto& func : module->functions) {
      usageInfo.refFuncs[func->name] = false;
    }

    // Scan the module.
    {
      struct Analysis : public WalkerPass<PostWalker<Analysis>> {
        UsageInfo* usageInfo;

        Analysis(UsageInfo* usageInfo) : usageInfo(usageInfo) {}

        void visitRefFunc(RefFunc* curr) {
          usageInfo->refFuncs[curr->func] = true;
        }
      };
      PassRunner runner(module);
      Analysis analysis(&usageInfo);
      analysis.run(&runner, module);
      analysis.walkModuleCode(module);
    }

    for (auto& kv : usageInfo.refFuncs) {
      Name name = kv.first;
      bool used = kv.second;
      if (used) {
        makeRefFunc(name);
      }
    }
  }

  // Allocate an rtt.canon at compile time for the specified type.
  void makeRttCanon(HeapType type) {
    PointerBuilder builder(*module);

    // Allocate this rtt at the next free location.
    auto addr = loweringInfo.compileTimeMalloc(8 + loweringInfo.pointerSize);
    loweringInfo.rttCanonAddrs[type] = addr;

    // Write the rtt kind.
    int32_t rttKind;
    if (type.isFunction()) {
      rttKind = RttFunc;
    } else if (type.isData()) {
      rttKind = RttData;
    } else {
      WASM_UNREACHABLE("bad rtt");
    }
    startBlock->list.push_back(
      builder.makeSimpleStore(builder.makeConst(int32_t(addr)),
                              builder.makeConst(int32_t(rttKind)),
                              Type::i32));

    // Write the size of the list of types, which for an rtt.canon is 1.
    startBlock->list.push_back(
      builder.makeSimpleStore(builder.makeConst(int32_t(addr + 4)),
                              builder.makeConst(int32_t(1)),
                              Type::i32));

    // Write the list, which is just a pointer to ourselves.
    startBlock->list.push_back(
      builder.makePointerStore(builder.makeConst(int32_t(addr + 8)), addr));
  }

  void makeRttSub() {
    // RttSub(rtt newType, rtt parent) -> rtt

    PointerBuilder builder(*module);
    std::vector<Expression*> list;

    // We receive two params, the new type and the old parent rtt.
    auto newTypeParam = 0;
    auto parentRttParam = 1;

    // We need a local to store the allocated value.
    auto allocLocal = 2;

    // We also need a local for the size of the list of types in the old rtt.
    auto sizeLocal = 3;

    // Finally, we need a temp pointer for the copy loop.
    auto tempLocal = 4;

    // Get the size of the old rtt.
    list.push_back(builder.makeLocalSet(
      sizeLocal, getRttSize(builder.makePointerGet(parentRttParam))));

    // Malloc space for our struct.
    list.push_back(builder.makeLocalSet(
      allocLocal,
      builder.makeCall(
        loweringInfo.malloc,
        {builder.makeBinary(
          AddInt32,
          // The size of the list of types in the parent (to which we will be
          // adding one, see below).
          builder.makeBinary(
            MulInt32,
            builder.makeLocalGet(sizeLocal, Type::i32),
            builder.makeConst(int32_t(loweringInfo.pointerSize))),
          // +8 for the first two fields (kind and size), +a pointer size as
          // the list of types is one larger.
          builder.makeConst(int32_t(8 + loweringInfo.pointerSize)))},
        loweringInfo.pointerType)));

    // Copy the kind.
    list.push_back(
      builder.makeSimpleStore(builder.makePointerGet(allocLocal),
                              getRttKind(builder.makePointerGet(0)),
                              Type::i32));

    // Store the new size, which is one larger.
    list.push_back(builder.makeSimpleStore(
      builder.makePointerGet(allocLocal),
      builder.makeBinary(AddInt32,
                         builder.makeLocalGet(sizeLocal, Type::i32),
                         builder.makeConst(int32_t(1))),
      Type::i32,
      4));

    // Copy the old types, using *temp++ = *parent++;
    list.push_back(
      builder.makeLocalSet(tempLocal, builder.makePointerGet(allocLocal)));
    Name loop("loop");
    list.push_back(builder.makeLoop(
      loop,
      builder.makeBlock(std::vector<Expression*>{
        // Copy one value.
        builder.makePointerStore(
          builder.makePointerGet(tempLocal),
          builder.makePointerLoad(
            builder.makePointerGet(parentRttParam),
            // Constantly pass offsets of 8 here, to skip the first two fields
            // in each rtt data structure. We could also first do an increment,
            // at the cost of code size.
            8),
          8),

        // Increment both pointers
        builder.makeLocalSet(
          tempLocal,
          builder.makePointerAdd(builder.makePointerGet(tempLocal),
                                 builder.makePointerConst(4))),
        builder.makeLocalSet(
          parentRttParam,
          builder.makePointerAdd(builder.makePointerGet(parentRttParam),
                                 builder.makePointerConst(4))),

        // Loop while there is more.
        builder.makeLocalSet(
          sizeLocal,
          builder.makeBinary(SubInt32,
                             builder.makeLocalGet(sizeLocal, Type::i32),
                             builder.makeConst(int32_t(1)))),
        builder.makeBreak(
          loop, nullptr, builder.makeLocalGet(sizeLocal, Type::i32))})));

    // Store a pointer to the new heap type at the end of the new list.
    list.push_back(
      builder.makePointerStore(builder.makePointerGet(tempLocal),
                               builder.makePointerGet(newTypeParam),
                               8));

    // Return the pointer.
    list.push_back(builder.makePointerGet(allocLocal));
    module->addFunction(builder.makeFunction(
      "RttSub",
      Signature({loweringInfo.pointerType, loweringInfo.pointerType},
                loweringInfo.pointerType),
      {loweringInfo.pointerType, Type::i32, loweringInfo.pointerType},
      builder.makeBlock(list)));
  }

  // Add a function to the table and return its index there.
  Index addToTable(Name name) {
    Builder builder(*module);
    auto index = segment->data.size();
    segment->data.push_back(
      builder.makeRefFunc(name, HeapType(module->getFunction(name)->getSig())));
    table->initial++;
    table->max++;
    return index;
  }

  // Create a ref.func instance. We allocate it at compile time, and write the
  // fields of the instance during startup. (We could also in principle write
  // to linear memory at compile time as well.)
  void makeRefFunc(Name name) {
    auto* func = module->getFunction(name);

    // Add the function to the table.
    auto tableIndex = addToTable(name);

    // Allocate this ref.func at the next free location.
    auto addr = loweringInfo.compileTimeMalloc(4 + loweringInfo.pointerSize);
    loweringInfo.refFuncAddrs[name] = addr;
    PointerBuilder builder(*module);

    // Write the rtt.
    auto type = HeapType(func->getSig());
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
  // inits, so we add them to the code that runs during startup.
  void processGlobals() {
    Builder builder(*module);
    for (auto& global : module->globals) {
      if (global->init) {
        if (auto* rttSub = global->init->dynCast<RttSub>()) {
          // Set a 0 as a placeholder for the global in the wasm binary, which
          // will be updated during startup.
          global->init = builder.makeConst(int32_t(0));

          // Add code in the start block to call rtt.sub.
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

          // Unfortunately, we must make the global mutable so we can write to
          // it after initialization.
          global->mutable_ = true;
        }
      }
      global->type = lower(global->type);
    }
  }

  // Given a field in a struct or an array, return how many bytes it uses.
  unsigned getBytes(const Field& field) {
    auto loweredType = lower(field.type);

    // For packed fields, return the proper packed size.
    if (field.type == Type::i32) {
      return field.getByteSize();
    }

    // For everything else, the lowered size is what matters (e.g. a reference
    // would become an i32 on wasm32 => 4 bytes).
    return loweredType.getByteSize();
  }

  void lowerCode(PassRunner* runner) {
    PassRunner subRunner(runner);
    subRunner.add(
      std::unique_ptr<LowerGCCode>(LowerGCCode(&loweringInfo).create()));
    subRunner.setIsNested(true);
    subRunner.run();

    // Lower the signatures of imported and defined functions.
    for (auto& func : module->functions) {
      func->type = Signature(lower(func->getSig()));
    }

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

  Type lower(Type type) { return lowerType(type, *module); }
  Signature lower(Signature sig) { return lowerSig(sig, *module); }
};

Pass* createGCLoweringPass() { return new LowerGC(); }

} // namespace wasm
