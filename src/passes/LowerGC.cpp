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
//     u32 rtt
//     fields...
//   Array:
//     u32 rtt
//     u32 size
//     elements...
//   Rtts:
//     u32     what (func, data, i31, extern)
//     pointer parent (or null if this is from rtt.canon)
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

const char* getName(RefAsOp op) {
  switch (op) {
    case RefAsNonNull:
      return "RefAsNonNull";
      break;
    case RefAsFunc:
      return "RefAsFunc";
      break;
    case RefAsData:
      return "RefAsData";
      break;
    case RefAsI31:
      return "RefAsI31";
      break;
    default:
      WASM_UNREACHABLE("unimplemented ref.as_*");
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

  void visitRefNull(RefNull* curr) {
    visitExpression(curr);
    replaceCurrent(LiteralUtils::makeZero(lower(curr->type), *getModule()));
  }

  void visitRefAs(RefAs* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(getName(curr->op), {curr->value}, loweringInfo->pointerType));
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
    auto name = std::string("ArraySet$") +
                getModule()->typeNames[type].name.str;
    replaceCurrent(
      builder.makeCall(name, {curr->ref, curr->index, curr->value}, Type::none));
  }

  void visitArrayGet(ArrayGet* curr) {
    visitExpression(curr);
    Builder builder(*getModule());
    auto type = originalTypes[&curr->ref];
    auto name = std::string("ArrayGet$") +
                getModule()->typeNames[type].name.str;
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, getModule()->memory);
    replaceCurrent(builder.makeCall(
      name, {curr->ref, curr->index}, loweredType));
  }

  void visitRttCanon(RttCanon* curr) {
    auto type = curr->type.getHeapType();
    visitExpression(curr);
    // FIXME actual rtt allocations and values
    replaceCurrent(LiteralUtils::makeFromInt32(loweringInfo->rttCanonAddrs[type], loweringInfo->pointerType, *getModule()));
  }

  void doWalkFunction(Function* func) {
    // Lower the types on the function itself.
    std::vector<Type> params;
    for (auto t : func->sig.params) {
      params.push_back(lower(t));
    }
    std::vector<Type> results;
    for (auto t : func->sig.results) {
      results.push_back(lower(t));
    }
    func->sig = Signature(Type(params), Type(results));
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
    std::cout << "add mem\n";
    pickNames();
    addMemory();
    addStart();
    std::cout << "comp layouts\n";
    addGCRuntime();
    std::cout << "add run\n";
    // After adding the GC runtime, which may allocate memory, we can create our
    // malloc runtime and initialize it.
    addMalloc();
    std::cout << "lower code\n";
    lowerCode(runner);
  }

private:
  Module* module;

  LoweringInfo loweringInfo;

  Block* startBlock;

  void pickNames() {
    loweringInfo.malloc = "malloc";
  }

  void addMemory() {
    module->memory.exists = true;

    // 16MB, arbitrarily for now.
    module->memory.initial = module->memory.max = 256;

    assert(!module->memory.is64());
    loweringInfo.pointerSize = 4;
    loweringInfo.pointerType = module->memory.indexType;
  }

  void addStart() {
    Builder builder(*module);
    startBlock = builder.makeBlock();
    if (module->start.is()) {
      // There is already a start function. Add our block before it.
      auto* func = module->getFunction(module->start);
      func->body = builder.makeSequence(
        startBlock,
        func->body
      );
      return;
    }
    // Add a new start function.
    module->start = "LowerGC$start";
    module->addFunction(builder.makeFunction(
      module->start,
      {Type::none, Type::none},
      {},
      startBlock
    ));
  }

  void addMalloc() {
    Builder builder(*module);
    auto* nextMalloc =
      module->addGlobal(builder.makeGlobal("nextMalloc",
                                           Type::i32,
                                           builder.makeConst(int32_t(loweringInfo.mallocStart)),
                                           Builder::Mutable));
    // TODO: more than a simple bump allocator that never frees or collects.
    module->addFunction(builder.makeFunction(
      loweringInfo.malloc,
      {Type::i32, Type::i32},
      {},
      builder.makeSequence(
        builder.makeGlobalSet(
          nextMalloc->name,
          builder.makeBinary(AddInt32,
                             builder.makeGlobalGet(nextMalloc->name, Type::i32),
                             builder.makeLocalGet(0, Type::i32))),
        builder.makeBinary(SubInt32,
                           builder.makeGlobalGet(nextMalloc->name, Type::i32),
                           builder.makeLocalGet(0, Type::i32)))));
  }

  void addGCRuntime() {
    // Collect all the heap types in order to analyze them and decide on their
    // layout in linear memory.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);

    // Emit support code.
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
      }
    }
    makeRefAs();

    addRttSupport(types);
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
    Builder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = getLoweredType(field.type, module->memory);
      module->addFunction(builder.makeFunction(
        std::string("StructSet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        {{loweringInfo.pointerType, loweredType}, Type::none},
        {},
        builder.makeStore(loweredType.getByteSize(),
                          loweringInfo.layouts[type].fieldOffsets[i],
                          loweredType.getByteSize(),
                          builder.makeLocalGet(0, loweringInfo.pointerType),
                          builder.makeLocalGet(1, loweredType),
                          loweredType)));
    }
  }

  void makeStructGet(HeapType type) {
    auto& fields = type.getStruct().fields;
    Builder builder(*module);
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      auto loweredType = getLoweredType(field.type, module->memory);
      module->addFunction(builder.makeFunction(
        std::string("StructGet$") + module->typeNames[type].name.str + '$' +
          std::to_string(i),
        {loweringInfo.pointerType, loweredType},
        {},
        builder.makeLoad(loweredType.getByteSize(),
                         false, // TODO: signedness
                         loweringInfo.layouts[type].fieldOffsets[i],
                         loweredType.getByteSize(),
                         builder.makeLocalGet(0, loweringInfo.pointerType),
                         loweredType)));
    }
  }

  void makeArrayNew(HeapType type) {
    auto typeName = module->typeNames[type].name.str; // waka
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, module->memory);
    Builder builder(*module);
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
      // Add a local for the initialization loop.
      auto counter = alloc + 1;
      std::vector<Expression*> list;
      // Malloc space for our Array.
      list.push_back(builder.makeLocalSet(
        alloc,
        builder.makeCall(
          loweringInfo.malloc,
          {builder.makeConst(int32_t(loweringInfo.layouts[type].size))},
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
          {
           builder.makeLocalGet(alloc, loweringInfo.pointerType),
           builder.makeLocalGet(counter, loweringInfo.pointerType),
           initialization
          },
          Type::none);
      list.push_back(builder.makeLoop(
        loopName,
        builder.makeBlock(
          blockName,
          {builder.makeBreak(
             loopName,
             nullptr,
             builder.makeUnary(EqZInt32,
                               builder.makeLocalGet(counter, Type::i32))),
           initialization,
           builder.makeLocalSet(
             counter,
             builder.makeBinary(SubInt32,
                                builder.makeLocalGet(counter, Type::i32),
                                builder.makeConst(int32_t(1)))),
           builder.makeBreak(loopName)})));
      // Return the pointer.
      list.push_back(builder.makeLocalGet(alloc, loweringInfo.pointerType));
      std::string name = "ArrayNew";
      if (withDefault) {
        name += "WithDefault";
      }
      module->addFunction(builder.makeFunction(name + '$' + typeName,
                                               {Type(params), Type::i32},
                                               {loweringInfo.pointerType, loweringInfo.pointerType},
                                               builder.makeBlock(list)));
    }
  }

  Expression*
  makeArrayOffset(Type loweredType) {
    Builder builder(*module);
    return builder.makeBinary(
      AddInt32,
      builder.makeBinary(AddInt32, builder.makeLocalGet(0, loweringInfo.pointerType), builder.makeConst(int32_t(8))),
      builder.makeBinary(MulInt32,
                         builder.makeConst(int32_t(loweredType.getByteSize())),
                         builder.makeLocalGet(1, loweringInfo.pointerType)));
  }

  void makeArraySet(HeapType type) {
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, module->memory);
    Builder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArraySet$") + module->typeNames[type].name.str,
      {{loweringInfo.pointerType, loweringInfo.pointerType, loweredType}, Type::none},
      {},
      builder.makeStore(loweredType.getByteSize(),
                        0,
                        loweredType.getByteSize(),
                        makeArrayOffset(loweredType),
                        builder.makeLocalGet(2, loweredType),
                        loweredType)));
  }

  void makeArrayGet(HeapType type) {
    // TODO: null checks everywhere
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, module->memory);
    Builder builder(*module);
    module->addFunction(builder.makeFunction(
      std::string("ArrayGet$") + module->typeNames[type].name.str,
      {{loweringInfo.pointerType, loweringInfo.pointerType}, loweredType},
      {},
      builder.makeLoad(loweredType.getByteSize(),
                       false, // TODO: signedness
                       0,
                       loweredType.getByteSize(),
                       makeArrayOffset(loweredType),
                       loweredType)));
  }

  void makeRefAs() {
    Builder builder(*module);
    for (RefAsOp op : { RefAsNonNull, RefAsFunc, RefAsData, RefAsI31 }) {
      std::vector<Expression*> list;
      // Check for null.
      list.push_back(builder.makeIf(
        builder.makeUnary(
          EqZInt32,
          builder.makeLocalGet(0, loweringInfo.pointerType)
        ),
        builder.makeUnreachable()
      ));
      // Check for a kind, if we need to.
      auto compareRttTo = [&](RttKind kind) {
        list.push_back(builder.makeIf(
          builder.makeBinary(
            NeInt32,
            getRttKind(builder.makeLocalGet(0, loweringInfo.pointerType)),
            builder.makeConst(int32_t(kind))
          ),
          builder.makeUnreachable()
        ));
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
        builder.makeBlock(list)
      ));
    }
  }

  // Given a pointer, load the RTT for it.
  Expression* getRttKind(Expression* ptr) {
    // The RTT is the very first field in all GC objects.
    return Builder(*module).makeLoad(4,
                            false,
                            0,
                            4,
                            ptr,
                            Type::i32);
  }

  void addRttSupport(const std::vector<HeapType>& types) {
    // Analyze the code for heap type usage.
    struct UsageInfo {
      // Types used in rtt.canon instructions.
      std::unordered_map<HeapType, std::atomic<bool>> rttCanons;
    } usageInfo;
    // Initialize the data so it is safe to operate on in parallel.
    for (auto type : types) {
      usageInfo.rttCanons[type] = false;
    }
    {
      struct Analysis : public WalkerPass<PostWalker<Analysis>> {
        UsageInfo* usageInfo;

        Analysis(UsageInfo* usageInfo) : usageInfo(usageInfo) {}

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
  }

  void makeRttCanon(HeapType type) {
    // Allocate this rtt at the next free location.
    auto addr = loweringInfo.mallocStart;
    loweringInfo.rttCanonAddrs[type] = addr;
    int32_t rttValue;
    if (type.isFunction()) {
      rttValue = RttFunc;
    } else if (type.isData()) {
      rttValue = RttData;
    } else {
      WASM_UNREACHABLE("bad rtt");
    }
    Builder builder(*module);
    // Write the rtt kind.
    startBlock->list.push_back(builder.makeStore(
      4,
      0,
      4,
      builder.makeConst(int32_t(addr)),
      builder.makeConst(int32_t(rttValue)),
      Type::i32
    ));
    // Write the null pointer that indicates this is an rtt canon (and not a
    // sub).
    startBlock->list.push_back(builder.makeStore(
      loweringInfo.pointerSize,
      0,
      loweringInfo.pointerSize,
      builder.makeConst(int32_t(addr + 4)),
      builder.makeConst(Literal::makeFromInt32(0, loweringInfo.pointerType)),
      loweringInfo.pointerType
    ));
    loweringInfo.mallocStart = loweringInfo.mallocStart + 4 + loweringInfo.pointerSize;
  }

  void lowerCode(PassRunner* runner) {
    PassRunner subRunner(runner);
    subRunner.add(
      std::unique_ptr<LowerGCCode>(LowerGCCode(&loweringInfo).create()));
    subRunner.setIsNested(true);
    subRunner.run();

    LowerGCCode(&loweringInfo).walkModuleCode(module);
  }
};

Pass* createLowerGCPass() { return new LowerGC(); }

} // namespace wasm
