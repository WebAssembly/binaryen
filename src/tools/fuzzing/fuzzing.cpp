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

#include "tools/fuzzing.h"
#include "ir/gc-type-utils.h"
#include "ir/local-structural-dominance.h"
#include "ir/module-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "tools/fuzzing/heap-types.h"
#include "tools/fuzzing/parameters.h"

namespace wasm {

namespace {

// Weighting for the core make* methods. Some nodes are important enough that
// we should do them quite often.

} // anonymous namespace

TranslateToFuzzReader::TranslateToFuzzReader(Module& wasm,
                                             std::vector<char>&& input)
  : wasm(wasm), builder(wasm), random(std::move(input), wasm.features) {

  // Half the time add no unreachable code so that we'll execute the most code
  // as possible with no early exits.
  allowAddingUnreachableCode = oneIn(2);

  // - funcref cannot be logged because referenced functions can be inlined or
  // removed during optimization
  // - there's no point in logging anyref because it is opaque
  // - don't bother logging tuples
  loggableTypes = {Type::i32, Type::i64, Type::f32, Type::f64};
  if (wasm.features.hasSIMD()) {
    loggableTypes.push_back(Type::v128);
  }
}

TranslateToFuzzReader::TranslateToFuzzReader(Module& wasm,
                                             std::string& filename)
  : TranslateToFuzzReader(
      wasm, read_file<std::vector<char>>(filename, Flags::Binary)) {}

void TranslateToFuzzReader::pickPasses(OptimizationOptions& options) {
  while (options.passes.size() < 20 && !random.finished() && !oneIn(3)) {
    switch (upTo(32)) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4: {
        options.passes.push_back("O");
        options.passOptions.optimizeLevel = upTo(4);
        options.passOptions.shrinkLevel = upTo(4);
        break;
      }
      case 5:
        options.passes.push_back("coalesce-locals");
        break;
      case 6:
        options.passes.push_back("code-pushing");
        break;
      case 7:
        options.passes.push_back("code-folding");
        break;
      case 8:
        options.passes.push_back("dce");
        break;
      case 9:
        options.passes.push_back("duplicate-function-elimination");
        break;
      case 10:
        options.passes.push_back("flatten");
        break;
      case 11:
        options.passes.push_back("inlining");
        break;
      case 12:
        options.passes.push_back("inlining-optimizing");
        break;
      case 13:
        options.passes.push_back("local-cse");
        break;
      case 14:
        options.passes.push_back("memory-packing");
        break;
      case 15:
        options.passes.push_back("merge-blocks");
        break;
      case 16:
        options.passes.push_back("optimize-instructions");
        break;
      case 17:
        options.passes.push_back("pick-load-signs");
        break;
      case 18:
        options.passes.push_back("precompute");
        break;
      case 19:
        options.passes.push_back("precompute-propagate");
        break;
      case 20:
        options.passes.push_back("remove-unused-brs");
        break;
      case 21:
        options.passes.push_back("remove-unused-module-elements");
        break;
      case 22:
        options.passes.push_back("remove-unused-names");
        break;
      case 23:
        options.passes.push_back("reorder-functions");
        break;
      case 24:
        options.passes.push_back("reorder-locals");
        break;
      case 25: {
        options.passes.push_back("flatten");
        options.passes.push_back("rereloop");
        break;
      }
      case 26:
        options.passes.push_back("simplify-locals");
        break;
      case 27:
        options.passes.push_back("simplify-locals-notee");
        break;
      case 28:
        options.passes.push_back("simplify-locals-nostructure");
        break;
      case 29:
        options.passes.push_back("simplify-locals-notee-nostructure");
        break;
      case 30:
        options.passes.push_back("ssa");
        break;
      case 31:
        options.passes.push_back("vacuum");
        break;
      default:
        WASM_UNREACHABLE("unexpected value");
    }
  }
  if (oneIn(2)) {
    options.passOptions.optimizeLevel = upTo(4);
  }
  if (oneIn(2)) {
    options.passOptions.shrinkLevel = upTo(4);
  }
  std::cout << "opt level: " << options.passOptions.optimizeLevel << '\n';
  std::cout << "shrink level: " << options.passOptions.shrinkLevel << '\n';
}

void TranslateToFuzzReader::build() {
  if (HANG_LIMIT > 0) {
    prepareHangLimitSupport();
  }
  if (allowMemory) {
    setupMemory();
  }
  setupHeapTypes();
  setupTables();
  setupGlobals();
  if (wasm.features.hasExceptionHandling()) {
    setupTags();
  }
  modifyInitialFunctions();
  addImportLoggingSupport();
  // keep adding functions until we run out of input
  while (!random.finished()) {
    auto* func = addFunction();
    addInvocations(func);
  }
  if (HANG_LIMIT > 0) {
    addHangLimitSupport();
  }
  if (allowMemory) {
    finalizeMemory();
    addHashMemorySupport();
  }
  finalizeTable();
}

void TranslateToFuzzReader::setupMemory() {
  // Add memory itself
  MemoryUtils::ensureExists(&wasm);
  auto& memory = wasm.memories[0];
  if (wasm.features.hasBulkMemory()) {
    size_t memCovered = 0;
    // need at least one segment for memory.inits
    size_t numSegments = upTo(8) + 1;
    for (size_t i = 0; i < numSegments; i++) {
      auto segment = builder.makeDataSegment();
      segment->setName(Names::getValidDataSegmentName(wasm, Name::fromInt(i)),
                       false);
      segment->isPassive = bool(upTo(2));
      size_t segSize = upTo(USABLE_MEMORY * 2);
      segment->data.resize(segSize);
      for (size_t j = 0; j < segSize; j++) {
        segment->data[j] = upTo(512);
      }
      if (!segment->isPassive) {
        segment->offset = builder.makeConst(int32_t(memCovered));
        memCovered += segSize;
        segment->memory = memory->name;
      }
      wasm.addDataSegment(std::move(segment));
    }
  } else {
    // init some data
    auto segment = builder.makeDataSegment();
    segment->memory = memory->name;
    segment->offset = builder.makeConst(int32_t(0));
    segment->setName(Name::fromInt(0), false);
    wasm.dataSegments.push_back(std::move(segment));
    auto num = upTo(USABLE_MEMORY * 2);
    for (size_t i = 0; i < num; i++) {
      auto value = upTo(512);
      wasm.dataSegments[0]->data.push_back(value >= 256 ? 0 : (value & 0xff));
    }
  }
}

void TranslateToFuzzReader::setupHeapTypes() {
  // Start with any existing heap types in the module, which may exist in any
  // initial content we began with.
  auto possibleHeapTypes = ModuleUtils::collectHeapTypes(wasm);

  // Filter away uninhabitable heap types, that is, heap types that we cannot
  // construct, like a type with a non-nullable reference to itself.
  interestingHeapTypes = HeapTypeGenerator::getInhabitable(possibleHeapTypes);

  // For GC, also generate random types.
  if (wasm.features.hasGC()) {
    auto generator =
      HeapTypeGenerator::create(random, wasm.features, upTo(MAX_NEW_GC_TYPES));
    auto result = generator.builder.build();
    if (auto* err = result.getError()) {
      Fatal() << "Failed to build heap types: " << err->reason << " at index "
              << err->index;
    }

    // Make the new types inhabitable. This process modifies existing types, so
    // it leaves more available compared to HeapTypeGenerator::getInhabitable.
    // We run that before on existing content, which may have instructions that
    // use the types, as editing them is not trivial, and for new types here we
    // are free to modify them so we keep as many as we can.
    auto inhabitable = HeapTypeGenerator::makeInhabitable(*result);
    for (auto type : inhabitable) {
      // Trivial types are already handled specifically in e.g.
      // getSingleConcreteType(), and we avoid adding them here as then we'd
      // need to add code to avoid uninhabitable combinations of them (like a
      // non-nullable bottom heap type).
      if (!type.isBottom() && !type.isBasic()) {
        interestingHeapTypes.push_back(type);
        if (oneIn(2)) {
          // Add a name for this type.
          wasm.typeNames[type].name =
            "generated_type$" + std::to_string(interestingHeapTypes.size());
        }
      }
    }
  }

  // Compute subtypes ahead of time. It is more efficient to do this all at once
  // now, rather than lazily later.
  SubTypes subTypes(interestingHeapTypes);
  for (auto type : interestingHeapTypes) {
    for (auto subType : subTypes.getImmediateSubTypes(type)) {
      interestingHeapSubTypes[type].push_back(subType);
    }
    // Basic types must be handled directly, since subTypes doesn't look at
    // those.
    if (type.isStruct()) {
      interestingHeapSubTypes[HeapType::struct_].push_back(type);
      interestingHeapSubTypes[HeapType::eq].push_back(type);
      interestingHeapSubTypes[HeapType::any].push_back(type);

      // Note the mutable fields.
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        if (fields[i].mutable_) {
          mutableStructFields.push_back(StructField{type, i});
        }
      }
    } else if (type.isArray()) {
      interestingHeapSubTypes[HeapType::array].push_back(type);
      interestingHeapSubTypes[HeapType::eq].push_back(type);
      interestingHeapSubTypes[HeapType::any].push_back(type);

      if (type.getArray().element.mutable_) {
        mutableArrays.push_back(type);
      }
    } else if (type.isSignature()) {
      interestingHeapSubTypes[HeapType::func].push_back(type);
    }
  }

  // Compute struct and array fields.
  for (auto type : interestingHeapTypes) {
    if (type.isStruct()) {
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        typeStructFields[fields[i].type].push_back(StructField{type, i});
      }
    } else if (type.isArray()) {
      typeArrays[type.getArray().element.type].push_back(type);
    }
  }
}

// TODO(reference-types): allow the fuzzer to create multiple tables
void TranslateToFuzzReader::setupTables() {
  // Ensure a funcref element segment and table exist. Segments with more
  // specific function types may have a smaller chance of getting functions.
  Table* table = nullptr;
  Type funcref = Type(HeapType::func, Nullable);
  auto iter = std::find_if(wasm.tables.begin(),
                           wasm.tables.end(),
                           [&](auto& table) { return table->type == funcref; });
  if (iter != wasm.tables.end()) {
    table = iter->get();
  } else {
    auto tablePtr = builder.makeTable(
      Names::getValidTableName(wasm, "fuzzing_table"), funcref, 0, 0);
    tablePtr->hasExplicitName = true;
    table = wasm.addTable(std::move(tablePtr));
  }
  funcrefTableName = table->name;
  bool hasFuncrefElemSegment =
    std::any_of(wasm.elementSegments.begin(),
                wasm.elementSegments.end(),
                [&](auto& segment) {
                  return segment->table.is() && segment->type == funcref;
                });
  if (!hasFuncrefElemSegment) {
    // TODO: use a random table
    auto segment = std::make_unique<ElementSegment>(
      table->name, builder.makeConst(int32_t(0)));
    segment->setName(Names::getValidElementSegmentName(wasm, "elem$"), false);
    wasm.addElementSegment(std::move(segment));
  }
}

void TranslateToFuzzReader::setupGlobals() {
  // If there were initial wasm contents, there may be imported globals. That
  // would be a problem in the fuzzer harness as we'd error if we do not
  // provide them (and provide the proper type, etc.).
  // Avoid that, so that all the standard fuzzing infrastructure can always
  // run the wasm.
  for (auto& global : wasm.globals) {
    if (global->imported()) {
      // Remove import info from imported globals, and give them a simple
      // initializer.
      global->module = global->base = Name();
      global->init = makeConst(global->type);
    } else {
      // If the initialization referred to an imported global, it no longer can
      // point to the same global after we make it a non-imported global unless
      // GC is enabled, since before GC, Wasm only made imported globals
      // available in constant expressions.
      if (!wasm.features.hasGC() &&
          !FindAll<GlobalGet>(global->init).list.empty()) {
        global->init = makeConst(global->type);
      }
    }
  }

  // Randomly assign some globals from initial content to be ignored for the
  // fuzzer to use. Such globals will only be used from initial content. This is
  // important to preserve some real-world patterns, like the "once" pattern in
  // which a global is used in one function only. (If we randomly emitted gets
  // and sets of such globals, we'd with very high probability end up breaking
  // that pattern, and not fuzzing it at all.)
  //
  // Pick a percentage of initial globals to ignore later down when we decide
  // which to allow uses from.
  auto numInitialGlobals = wasm.globals.size();
  unsigned percentIgnoredInitialGlobals = 0;
  if (numInitialGlobals) {
    // Only generate this random number if it will be used.
    percentIgnoredInitialGlobals = upTo(100);
  }

  // Create new random globals.
  for (size_t index = upTo(MAX_GLOBALS); index > 0; --index) {
    auto type = getConcreteType();
    auto* init = makeConst(type);
    if (!FindAll<RefAs>(init).list.empty()) {
      // When creating this initial value we ended up emitting a RefAs, which
      // means we had to stop in the middle of an overly-nested struct or array,
      // which we can break out of using ref.as_non_null of a nullable ref. That
      // traps in normal code, which is bad enough, but it does not even
      // validate in a global. Switch to something safe instead.
      type = getMVPType();
      init = makeConst(type);
    }
    auto mutability = oneIn(2) ? Builder::Mutable : Builder::Immutable;
    auto global = builder.makeGlobal(
      Names::getValidGlobalName(wasm, "global$"), type, init, mutability);
    wasm.addGlobal(std::move(global));
  }

  // Set up data structures for picking globals later for get/set operations.
  for (Index i = 0; i < wasm.globals.size(); i++) {
    auto& global = wasm.globals[i];

    // Apply the chance for initial globals to be ignored, see above.
    if (i < numInitialGlobals && upTo(100) < percentIgnoredInitialGlobals) {
      continue;
    }

    // This is a global we can use later, note it.
    globalsByType[global->type].push_back(global->name);
    if (global->mutable_) {
      mutableGlobalsByType[global->type].push_back(global->name);
    }
  }
}

void TranslateToFuzzReader::setupTags() {
  // As in modifyInitialFunctions(), we can't allow tag imports as it would trap
  // when the fuzzing infrastructure doesn't know what to provide.
  for (auto& tag : wasm.tags) {
    if (tag->imported()) {
      tag->module = tag->base = Name();
    }
  }

  // Add some random tags.
  Index num = upTo(3);
  for (size_t i = 0; i < num; i++) {
    addTag();
  }
}

void TranslateToFuzzReader::addTag() {
  auto tag = builder.makeTag(Names::getValidTagName(wasm, "tag$"),
                             Signature(getControlFlowType(), Type::none));
  wasm.addTag(std::move(tag));
}

void TranslateToFuzzReader::finalizeMemory() {
  auto& memory = wasm.memories[0];
  for (auto& segment : wasm.dataSegments) {
    Address maxOffset = segment->data.size();
    if (!segment->isPassive) {
      if (!wasm.features.hasGC()) {
        // Using a non-imported global in a segment offset is not valid in wasm
        // unless GC is enabled. This can occur due to us adding a local
        // definition to what used to be an imported global in initial contents.
        // To fix that, replace such invalid offsets with a constant.
        for ([[maybe_unused]] auto* get :
             FindAll<GlobalGet>(segment->offset).list) {
          // No imported globals should remain.
          assert(!wasm.getGlobal(get->name)->imported());
          // TODO: It would be better to avoid segment overlap so that
          //       MemoryPacking can run.
          segment->offset =
            builder.makeConst(Literal::makeFromInt32(0, Type::i32));
        }
      }
      if (auto* offset = segment->offset->dynCast<Const>()) {
        maxOffset = maxOffset + offset->value.getInteger();
      }
    }
    memory->initial = std::max(
      memory->initial,
      Address((maxOffset + Memory::kPageSize - 1) / Memory::kPageSize));
  }
  memory->initial = std::max(memory->initial, USABLE_MEMORY);
  // Avoid an unlimited memory size, which would make fuzzing very difficult
  // as different VMs will run out of system memory in different ways.
  if (memory->max == Memory::kUnlimitedSize) {
    memory->max = memory->initial;
  }
  if (memory->max <= memory->initial) {
    // To allow growth to work (which a testcase may assume), try to make the
    // maximum larger than the initial.
    // TODO: scan the wasm for grow instructions?
    memory->max =
      std::min(Address(memory->initial + 1), Address(Memory::kMaxSize32));
  }
  // Avoid an imported memory (which the fuzz harness would need to handle).
  for (auto& memory : wasm.memories) {
    memory->module = memory->base = Name();
  }
}

void TranslateToFuzzReader::finalizeTable() {
  for (auto& table : wasm.tables) {
    ModuleUtils::iterTableSegments(
      wasm, table->name, [&](ElementSegment* segment) {
        // If the offset contains a global that was imported (which is ok) but
        // no longer is (not ok unless GC is enabled), we may need to change
        // that.
        if (!wasm.features.hasGC()) {
          for ([[maybe_unused]] auto* get :
               FindAll<GlobalGet>(segment->offset).list) {
            // No imported globals should remain.
            assert(!wasm.getGlobal(get->name)->imported());
            // TODO: the segments must not overlap...
            segment->offset =
              builder.makeConst(Literal::makeFromInt32(0, Type::i32));
          }
        }
        Address maxOffset = segment->data.size();
        if (auto* offset = segment->offset->dynCast<Const>()) {
          maxOffset = maxOffset + offset->value.getInteger();
        }
        table->initial = std::max(table->initial, maxOffset);
      });

    // The code above raises table->initial to a size large enough to accomodate
    // all of its segments, with the intention of avoiding a trap during
    // startup. However a single segment of (say) size 4GB would have a table of
    // that size, which will use a lot of memory and execute very slowly, so we
    // prefer in the fuzzer to trap on such a thing. To achieve that, set a
    // reasonable limit for the maximum table size.
    //
    // This also avoids an issue that arises from table->initial being an
    // Address (64 bits) but Table::kMaxSize being an Index (32 bits), as a
    // result of which we need to clamp to Table::kMaxSize as well in order for
    // the module to validate (but since we are clamping to a smaller value,
    // there is no need).
    const Address ReasonableMaxTableSize = 10000;
    table->initial = std::min(table->initial, ReasonableMaxTableSize);
    assert(ReasonableMaxTableSize <= Table::kMaxSize);

    table->max = oneIn(2) ? Address(Table::kUnlimitedSize) : table->initial;
    // Avoid an imported table (which the fuzz harness would need to handle).
    table->module = table->base = Name();
  }
}

void TranslateToFuzzReader::prepareHangLimitSupport() {
  HANG_LIMIT_GLOBAL = Names::getValidGlobalName(wasm, "hangLimit");
}

void TranslateToFuzzReader::addHangLimitSupport() {
  auto glob = builder.makeGlobal(HANG_LIMIT_GLOBAL,
                                 Type::i32,
                                 builder.makeConst(int32_t(HANG_LIMIT)),
                                 Builder::Mutable);
  wasm.addGlobal(std::move(glob));
}

void TranslateToFuzzReader::addImportLoggingSupport() {
  for (auto type : loggableTypes) {
    auto* func = new Function;
    Name name = std::string("log-") + type.toString();
    func->name = name;
    func->module = "fuzzing-support";
    func->base = name;
    func->type = Signature(type, Type::none);
    wasm.addFunction(func);
  }
}

void TranslateToFuzzReader::addHashMemorySupport() {
  // Add memory hasher helper (for the hash, see hash.h). The function looks
  // like:
  // function hashMemory() {
  //   hash = 5381;
  //   hash = ((hash << 5) + hash) ^ mem[0];
  //   hash = ((hash << 5) + hash) ^ mem[1];
  //   ..
  //   return hash;
  // }
  std::vector<Expression*> contents;
  contents.push_back(
    builder.makeLocalSet(0, builder.makeConst(uint32_t(5381))));
  auto zero = Literal::makeFromInt32(0, wasm.memories[0]->indexType);
  for (Index i = 0; i < USABLE_MEMORY; i++) {
    contents.push_back(builder.makeLocalSet(
      0,
      builder.makeBinary(
        XorInt32,
        builder.makeBinary(
          AddInt32,
          builder.makeBinary(ShlInt32,
                             builder.makeLocalGet(0, Type::i32),
                             builder.makeConst(uint32_t(5))),
          builder.makeLocalGet(0, Type::i32)),
        builder.makeLoad(1,
                         false,
                         i,
                         1,
                         builder.makeConst(zero),
                         Type::i32,
                         wasm.memories[0]->name))));
  }
  contents.push_back(builder.makeLocalGet(0, Type::i32));
  auto* body = builder.makeBlock(contents);
  auto* hasher = wasm.addFunction(builder.makeFunction(
    "hashMemory", Signature(Type::none, Type::i32), {Type::i32}, body));
  wasm.addExport(
    builder.makeExport(hasher->name, hasher->name, ExternalKind::Function));
  // Export memory so JS fuzzing can use it
  if (!wasm.getExportOrNull("memory")) {
    wasm.addExport(builder.makeExport(
      "memory", wasm.memories[0]->name, ExternalKind::Memory));
  }
}

TranslateToFuzzReader::FunctionCreationContext::~FunctionCreationContext() {
  // We must ensure non-nullable locals validate. Later down we'll run
  // TypeUpdating::handleNonDefaultableLocals which will make them validate by
  // turning them nullable + add ref.as_non_null to fix up types. That has the
  // downside of making them trap at runtime, however, and also we lose the non-
  // nullability in the type, so we prefer to do a manual fixup that avoids a
  // trap, which we do by writing a non-nullable value into the local at the
  // function entry.
  // TODO: We could be more precise and use a LocalGraph here, at the cost of
  //       doing more work.
  LocalStructuralDominance info(
    func, parent.wasm, LocalStructuralDominance::NonNullableOnly);
  for (auto index : info.nonDominatingIndices) {
    // Do not always do this, but with high probability, to reduce the amount of
    // traps.
    if (!parent.oneIn(5)) {
      auto* value = parent.makeTrivial(func->getLocalType(index));
      func->body = parent.builder.makeSequence(
        parent.builder.makeLocalSet(index, value), func->body);
    }
  }

  // Then, to handle remaining cases we did not just fix up, do the general
  // fixup to ensure we validate.
  TypeUpdating::handleNonDefaultableLocals(func, parent.wasm);

  if (HANG_LIMIT > 0) {
    parent.addHangLimitChecks(func);
  }
  assert(breakableStack.empty());
  assert(hangStack.empty());
  parent.funcContext = nullptr;
}

Expression* TranslateToFuzzReader::makeHangLimitCheck() {
  // If the hang limit global reaches 0 then we trap and reset it. That allows
  // calls to other exports to proceed, with hang checking, after the trap halts
  // the currently called export.
  return builder.makeSequence(
    builder.makeIf(
      builder.makeUnary(UnaryOp::EqZInt32,
                        builder.makeGlobalGet(HANG_LIMIT_GLOBAL, Type::i32)),
      builder.makeSequence(
        builder.makeGlobalSet(HANG_LIMIT_GLOBAL,
                              builder.makeConst(int32_t(HANG_LIMIT))),
        builder.makeUnreachable())),
    builder.makeGlobalSet(
      HANG_LIMIT_GLOBAL,
      builder.makeBinary(BinaryOp::SubInt32,
                         builder.makeGlobalGet(HANG_LIMIT_GLOBAL, Type::i32),
                         builder.makeConst(int32_t(1)))));
}

Expression* TranslateToFuzzReader::makeLogging() {
  auto type = getLoggableType();
  return builder.makeCall(
    std::string("log-") + type.toString(), {make(type)}, Type::none);
}

Expression* TranslateToFuzzReader::makeMemoryHashLogging() {
  auto* hash = builder.makeCall(std::string("hashMemory"), {}, Type::i32);
  return builder.makeCall(std::string("log-i32"), {hash}, Type::none);
}

// TODO: return std::unique_ptr<Function>
Function* TranslateToFuzzReader::addFunction() {
  LOGGING_PERCENT = upToSquared(100);
  auto* func = new Function;
  func->name = Names::getValidFunctionName(wasm, "func");
  FunctionCreationContext context(*this, func);
  assert(funcContext->typeLocals.empty());
  Index numParams = upToSquared(MAX_PARAMS);
  std::vector<Type> params;
  params.reserve(numParams);
  for (Index i = 0; i < numParams; i++) {
    auto type = getSingleConcreteType();
    funcContext->typeLocals[type].push_back(params.size());
    params.push_back(type);
  }
  auto paramType = Type(params);
  auto resultType = getControlFlowType();
  func->type = Signature(paramType, resultType);
  Index numVars = upToSquared(MAX_VARS);
  for (Index i = 0; i < numVars; i++) {
    auto type = getConcreteType();
    funcContext->typeLocals[type].push_back(params.size() + func->vars.size());
    func->vars.push_back(type);
  }
  // with small chance, make the body unreachable
  auto bodyType = func->getResults();
  if (oneIn(10)) {
    bodyType = Type::unreachable;
  }
  // with reasonable chance make the body a block
  if (oneIn(2)) {
    func->body = makeBlock(bodyType);
  } else {
    func->body = make(bodyType);
  }
  // Our OOB checks are already in the code, and if we recombine/mutate we
  // may end up breaking them. TODO: do them after the fact, like with the
  // hang limit checks.
  if (allowOOB) {
    // Recombinations create duplicate code patterns.
    recombine(func);
    // Mutations add random small changes, which can subtly break duplicate
    // code patterns.
    mutate(func);
    // TODO: liveness operations on gets, with some prob alter a get to one
    // with more possible sets.
    // Recombination, mutation, etc. can break validation; fix things up
    // after.
    fixAfterChanges(func);
  }
  // Add hang limit checks after all other operations on the function body.
  wasm.addFunction(func);
  // Export some functions, but not all (to allow inlining etc.). Try to export
  // at least one, though, to keep each testcase interesting. Only functions
  // with valid params and returns can be exported because the trap fuzzer
  // depends on that (TODO: fix this).
  auto validExportType = [](Type t) {
    if (!t.isRef()) {
      return true;
    }
    auto heapType = t.getHeapType();
    return heapType == HeapType::ext || heapType == HeapType::func ||
           heapType == HeapType::string;
  };
  bool validExportParams =
    std::all_of(paramType.begin(), paramType.end(), [&](Type t) {
      return validExportType(t) && t.isDefaultable();
    });
  // Note: spec discussions around JS API integration are still ongoing, and it
  // is not clear if we should allow nondefaultable types in exports or not
  // (in imports, we cannot allow them in the fuzzer anyhow, since it can't
  // construct such values in JS to send over to the wasm from the fuzzer
  // harness).
  bool validExportResults =
    std::all_of(resultType.begin(), resultType.end(), validExportType);
  if (validExportParams && validExportResults &&
      (numAddedFunctions == 0 || oneIn(2)) &&
      !wasm.getExportOrNull(func->name)) {
    auto* export_ = new Export;
    export_->name = func->name;
    export_->value = func->name;
    export_->kind = ExternalKind::Function;
    wasm.addExport(export_);
  }
  // add some to an elem segment
  while (oneIn(3) && !random.finished()) {
    auto type = Type(func->type, NonNullable);
    std::vector<ElementSegment*> compatibleSegments;
    ModuleUtils::iterActiveElementSegments(wasm, [&](ElementSegment* segment) {
      if (Type::isSubType(type, segment->type)) {
        compatibleSegments.push_back(segment);
      }
    });
    auto& randomElem = compatibleSegments[upTo(compatibleSegments.size())];
    randomElem->data.push_back(builder.makeRefFunc(func->name, func->type));
  }
  numAddedFunctions++;
  return func;
}

void TranslateToFuzzReader::addHangLimitChecks(Function* func) {
  // loop limit
  for (auto* loop : FindAll<Loop>(func->body).list) {
    loop->body =
      builder.makeSequence(makeHangLimitCheck(), loop->body, loop->type);
  }
  // recursion limit
  func->body =
    builder.makeSequence(makeHangLimitCheck(), func->body, func->getResults());
  // ArrayNew can hang the fuzzer if the array size is massive. This doesn't
  // cause an OOM (which the fuzzer knows how to ignore) but it just works for
  // many seconds on building the array. To avoid that, limit the size with high
  // probability.
  for (auto* arrayNew : FindAll<ArrayNew>(func->body).list) {
    if (!oneIn(100)) {
      arrayNew->size = builder.makeBinary(
        AndInt32, arrayNew->size, builder.makeConst(int32_t(1024 - 1)));
    }
  }
}

void TranslateToFuzzReader::recombine(Function* func) {
  // Don't always do this.
  if (oneIn(2)) {
    return;
  }
  // First, scan and group all expressions by type.
  struct Scanner
    : public PostWalker<Scanner, UnifiedExpressionVisitor<Scanner>> {
    TranslateToFuzzReader& parent;
    // A map of all expressions, categorized by type.
    InsertOrderedMap<Type, std::vector<Expression*>> exprsByType;
    Scanner(TranslateToFuzzReader& parent) : parent(parent) {}

    void visitExpression(Expression* curr) {
      if (parent.canBeArbitrarilyReplaced(curr)) {
        for (auto type : getRelevantTypes(curr->type)) {
          exprsByType[type].push_back(curr);
        }
      }
    }

    std::vector<Type> getRelevantTypes(Type type) {
      // Given an expression of a type, we can replace not only other
      // expressions with the same type, but also supertypes - since then we'd
      // be replacing with a subtype, which is valid.
      if (!type.isRef()) {
        return {type};
      }

      std::vector<Type> ret;
      auto heapType = type.getHeapType();
      auto nullability = type.getNullability();

      if (nullability == NonNullable) {
        ret = getRelevantTypes(Type(heapType, Nullable));
      }

      while (1) {
        ret.push_back(Type(heapType, nullability));
        auto super = heapType.getSuperType();
        if (!super) {
          break;
        }
        heapType = *super;
      }

      return ret;
    }
  };
  Scanner scanner(*this);
  scanner.walk(func->body);
  // Potentially trim the list of possible picks, so replacements are more
  // likely to collide.
  for (auto& pair : scanner.exprsByType) {
    if (oneIn(2)) {
      continue;
    }
    auto& list = pair.second;
    std::vector<Expression*> trimmed;
    size_t num = upToSquared(list.size());
    for (size_t i = 0; i < num; i++) {
      trimmed.push_back(pick(list));
    }
    if (trimmed.empty()) {
      trimmed.push_back(pick(list));
    }
    list.swap(trimmed);
  }
  // Replace them with copies, to avoid a copy into one altering another copy
  for (auto& pair : scanner.exprsByType) {
    for (auto*& item : pair.second) {
      item = ExpressionManipulator::copy(item, wasm);
    }
  }
  // Second, with some probability replace an item with another item having
  // a proper type. (This is not always valid due to nesting of labels, but
  // we'll fix that up later.)
  struct Modder : public PostWalker<Modder, UnifiedExpressionVisitor<Modder>> {
    Module& wasm;
    Scanner& scanner;
    TranslateToFuzzReader& parent;

    Modder(Module& wasm, Scanner& scanner, TranslateToFuzzReader& parent)
      : wasm(wasm), scanner(scanner), parent(parent) {}

    void visitExpression(Expression* curr) {
      if (parent.oneIn(10) && parent.canBeArbitrarilyReplaced(curr)) {
        // Replace it!
        auto& candidates = scanner.exprsByType[curr->type];
        assert(!candidates.empty()); // this expression itself must be there
        auto* rep = parent.pick(candidates);
        replaceCurrent(ExpressionManipulator::copy(rep, wasm));
      }
    }
  };
  Modder modder(wasm, scanner, *this);
  modder.walk(func->body);
}

void TranslateToFuzzReader::mutate(Function* func) {
  // We want a 50% chance to not do this at all, and otherwise, we want to pick
  // a different frequency to do it in each function. That gives us more
  // diversity between fuzzings of the same initial content (once we might
  // mutate with 5%, and only change one or two places, while another time we
  // might mutate with 50% and change quite a lot; without this type of
  // mechanism, in a large function the amount of mutations will generally be
  // very close to the mean due to the central limit theorem).
  auto r = upTo(200);
  if (r > 100) {
    return;
  }

  // Prefer lower numbers: We want something like a 10% chance to mutate on
  // average. To achieve that, we raise r/100, which is in the range [0, 1], to
  // the 9th power, giving us a number also in the range [0, 1] with a mean of
  //   \integral_0^1 t^9 dx = 0.1 * t^10 |_0^1 = 0.1
  // As a result, we get a value in the range of 0-100%. (Note that 100% is ok
  // since we can't replace everything anyhow, see below.)
  double t = r;
  t = t / 100;
  t = pow(t, 9);
  Index percentChance = t * 100;
  // Adjust almost-zero frequencies to at least a few %, just so we have some
  // reasonable chance of making some changes.
  percentChance = std::max(percentChance, Index(3));

  struct Modder : public PostWalker<Modder, UnifiedExpressionVisitor<Modder>> {
    Module& wasm;
    TranslateToFuzzReader& parent;
    Index percentChance;

    // Whether to replace with unreachable. This can lead to less code getting
    // executed, so we don't want to do it all the time even in a big function.
    bool allowUnreachable;

    Modder(Module& wasm, TranslateToFuzzReader& parent, Index percentChance)
      : wasm(wasm), parent(parent), percentChance(percentChance) {
      // If the parent allows it then sometimes replace with an unreachable, and
      // sometimes not. Even if we allow it, only do it in certain functions
      // (half the time) and only do it rarely (see below).
      allowUnreachable = parent.allowAddingUnreachableCode && parent.oneIn(2);
    }

    void visitExpression(Expression* curr) {
      if (parent.upTo(100) < percentChance &&
          parent.canBeArbitrarilyReplaced(curr)) {
        if (allowUnreachable && parent.oneIn(20)) {
          replaceCurrent(parent.make(Type::unreachable));
          return;
        }
        // For constants, perform only a small tweaking in some cases.
        if (auto* c = curr->dynCast<Const>()) {
          if (parent.oneIn(2)) {
            c->value = parent.tweak(c->value);
            return;
          }
        }
        // TODO: more minor tweaks to immediates, like making a load atomic or
        // not, changing an offset, etc.
        // Perform a general replacement. (This is not always valid due to
        // nesting of labels, but we'll fix that up later.) Note that make()
        // picks a subtype, so this has a chance to replace us with anything
        // that is valid to put here.
        replaceCurrent(parent.make(curr->type));
      }
    }
  };
  Modder modder(wasm, *this, percentChance);
  modder.walk(func->body);
}

void TranslateToFuzzReader::fixAfterChanges(Function* func) {
  struct Fixer
    : public ControlFlowWalker<Fixer, UnifiedExpressionVisitor<Fixer>> {
    Module& wasm;
    TranslateToFuzzReader& parent;

    Fixer(Module& wasm, TranslateToFuzzReader& parent)
      : wasm(wasm), parent(parent) {}

    // Track seen names to find duplication, which is invalid.
    std::set<Name> seen;

    void visitExpression(Expression* curr) {
      // Note all scope names, and fix up all uses.
      BranchUtils::operateOnScopeNameDefs(curr, [&](Name& name) {
        if (name.is()) {
          if (seen.count(name)) {
            replace();
          } else {
            seen.insert(name);
          }
        }
      });
      BranchUtils::operateOnScopeNameUses(curr, [&](Name& name) {
        if (name.is()) {
          replaceIfInvalid(name);
        }
      });
    }

    void replaceIfInvalid(Name target) {
      if (!hasBreakTarget(target)) {
        // There is no valid parent, replace with something trivially safe.
        replace();
      }
    }

    void replace() { replaceCurrent(parent.makeTrivial(getCurrent()->type)); }

    bool hasBreakTarget(Name name) {
      if (controlFlowStack.empty()) {
        return false;
      }
      Index i = controlFlowStack.size() - 1;
      while (1) {
        auto* curr = controlFlowStack[i];
        bool has = false;
        BranchUtils::operateOnScopeNameDefs(curr, [&](Name& def) {
          if (def == name) {
            has = true;
          }
        });
        if (has) {
          return true;
        }
        if (i == 0) {
          return false;
        }
        i--;
      }
    }
  };
  Fixer fixer(wasm, *this);
  fixer.walk(func->body);

  // Refinalize at the end, after labels are all fixed up.
  ReFinalize().walkFunctionInModule(func, &wasm);
}

void TranslateToFuzzReader::modifyInitialFunctions() {
  if (wasm.functions.empty()) {
    return;
  }
  // Pick a chance to fuzz the contents of a function.
  const int RESOLUTION = 10;
  auto chance = upTo(RESOLUTION + 1);
  // Do not iterate directly on wasm.functions itself (that is, avoid
  //   for (x : wasm.functions)
  // ) as we may add to it as we go through the functions - make() can add new
  // functions to implement a RefFunc. Instead, use an index. This avoids an
  // iterator invalidation, and also we will process those new functions at
  // the end (currently that is not needed atm, but it might in the future).
  for (Index i = 0; i < wasm.functions.size(); i++) {
    auto* func = wasm.functions[i].get();
    FunctionCreationContext context(*this, func);
    if (func->imported()) {
      // We can't allow extra imports, as the fuzzing infrastructure wouldn't
      // know what to provide.
      func->module = func->base = Name();
      func->body = make(func->getResults());
    }
    // Optionally, fuzz the function contents.
    if (upTo(RESOLUTION) >= chance) {
      dropToLog(func);
      // TODO add some locals? and the rest of addFunction's operations?
      // TODO: interposition, replace initial a(b) with a(RANDOM_THING(b))
      // TODO: if we add OOB checks after creation, then we can do it on
      //       initial contents too, and it may be nice to *not* run these
      //       passes, like we don't run them on new functions. But, we may
      //       still want to run them some of the time, at least, so that we
      //       check variations on initial testcases even at the risk of OOB.
      recombine(func);
      mutate(func);
      fixAfterChanges(func);
    }
  }
  // Remove a start function - the fuzzing harness expects code to run only
  // from exports.
  wasm.start = Name();
}

void TranslateToFuzzReader::dropToLog(Function* func) {
  // Don't always do this.
  if (oneIn(2)) {
    return;
  }
  struct Modder : public PostWalker<Modder> {
    Module& wasm;
    TranslateToFuzzReader& parent;

    Modder(Module& wasm, TranslateToFuzzReader& parent)
      : wasm(wasm), parent(parent) {}

    void visitDrop(Drop* curr) {
      if (parent.isLoggableType(curr->value->type) && parent.oneIn(2)) {
        replaceCurrent(parent.builder.makeCall(std::string("log-") +
                                                 curr->value->type.toString(),
                                               {curr->value},
                                               Type::none));
      }
    }
  };
  Modder modder(wasm, *this);
  modder.walk(func->body);
}

void TranslateToFuzzReader::addInvocations(Function* func) {
  Name name = func->name.toString() + std::string("_invoker");
  if (wasm.getFunctionOrNull(name) || wasm.getExportOrNull(name)) {
    return;
  }
  auto invoker = builder.makeFunction(name, Signature(), {});
  Block* body = builder.makeBlock();
  invoker->body = body;
  FunctionCreationContext context(*this, invoker.get());
  std::vector<Expression*> invocations;
  while (oneIn(2) && !random.finished()) {
    std::vector<Expression*> args;
    for (const auto& type : func->getParams()) {
      args.push_back(makeConst(type));
    }
    Expression* invoke = builder.makeCall(func->name, args, func->getResults());
    if (func->getResults().isConcrete()) {
      invoke = builder.makeDrop(invoke);
    }
    invocations.push_back(invoke);
    // log out memory in some cases
    if (oneIn(2)) {
      invocations.push_back(makeMemoryHashLogging());
    }
  }
  if (invocations.empty()) {
    return;
  }
  body->list.set(invocations);
  wasm.addFunction(std::move(invoker));
  wasm.addExport(builder.makeExport(name, name, ExternalKind::Function));
}

Expression* TranslateToFuzzReader::make(Type type) {
  type = getSubType(type);
  if (trivialNesting) {
    // We are nested under a makeTrivial call, so only emit something trivial.
    return makeTrivial(type);
  }
  // When we should stop, emit something small (but not necessarily trivial).
  if (random.finished() || nesting >= 5 * NESTING_LIMIT || // hard limit
      (nesting >= NESTING_LIMIT && !oneIn(3))) {
    if (type.isConcrete()) {
      if (oneIn(2)) {
        return makeConst(type);
      } else {
        return makeLocalGet(type);
      }
    } else if (type == Type::none) {
      if (oneIn(2)) {
        return makeNop(type);
      } else {
        return makeLocalSet(type);
      }
    }
    assert(type == Type::unreachable);
    return makeTrivial(type);
  }
  nesting++;
  Expression* ret = nullptr;
  if (type.isConcrete()) {
    ret = _makeConcrete(type);
  } else if (type == Type::none) {
    ret = _makenone();
  } else {
    assert(type == Type::unreachable);
    ret = _makeunreachable();
  }
  // We should create the right type of thing.
  assert(Type::isSubType(ret->type, type));
  nesting--;
  return ret;
}

Expression* TranslateToFuzzReader::_makeConcrete(Type type) {
  bool canMakeControlFlow = !type.isTuple() || wasm.features.hasMultivalue();
  using Self = TranslateToFuzzReader;
  FeatureOptions<Expression* (Self::*)(Type)> options;
  using WeightedOption = decltype(options)::WeightedOption;
  options.add(FeatureSet::MVP,
              WeightedOption{&Self::makeLocalGet, VeryImportant},
              WeightedOption{&Self::makeLocalSet, VeryImportant},
              WeightedOption{&Self::makeGlobalGet, Important},
              WeightedOption{&Self::makeConst, Important});
  if (canMakeControlFlow) {
    options
      .add(FeatureSet::MVP,
           WeightedOption{&Self::makeBlock, Important},
           WeightedOption{&Self::makeIf, Important},
           WeightedOption{&Self::makeLoop, Important},
           WeightedOption{&Self::makeBreak, Important},
           &Self::makeCall,
           &Self::makeCallIndirect)
      .add(FeatureSet::ExceptionHandling, &Self::makeTry)
      .add(FeatureSet::GC | FeatureSet::ReferenceTypes, &Self::makeCallRef);
  }
  if (type.isSingle()) {
    options
      .add(FeatureSet::MVP,
           WeightedOption{&Self::makeUnary, Important},
           WeightedOption{&Self::makeBinary, Important},
           &Self::makeSelect)
      .add(FeatureSet::Multivalue, &Self::makeTupleExtract);
  }
  if (type.isSingle() && !type.isRef()) {
    options.add(FeatureSet::MVP, {&Self::makeLoad, Important});
    options.add(FeatureSet::SIMD, &Self::makeSIMD);
  }
  if (type.isInteger()) {
    options.add(FeatureSet::Atomics, &Self::makeAtomic);
  }
  if (type == Type::i32) {
    options.add(FeatureSet::ReferenceTypes, &Self::makeRefIsNull);
    options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                &Self::makeRefEq,
                &Self::makeRefTest,
                &Self::makeI31Get);
  }
  if (type.isTuple()) {
    options.add(FeatureSet::Multivalue, &Self::makeTupleMake);
  }
  if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (heapType.isBasic()) {
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeBasicRef);
    } else {
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeCompoundRef);
    }
    options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                &Self::makeRefCast);
  }
  if (wasm.features.hasGC()) {
    if (typeStructFields.find(type) != typeStructFields.end()) {
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeStructGet);
    }
    if (typeArrays.find(type) != typeArrays.end()) {
      options.add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                  &Self::makeArrayGet);
    }
  }
  // TODO: struct.get and other GC things
  return (this->*pick(options))(type);
}

Expression* TranslateToFuzzReader::_makenone() {
  auto choice = upTo(100);
  if (choice < LOGGING_PERCENT) {
    if (choice < LOGGING_PERCENT / 2) {
      return makeLogging();
    } else {
      return makeMemoryHashLogging();
    }
  }
  using Self = TranslateToFuzzReader;
  auto options = FeatureOptions<Expression* (Self::*)(Type)>();
  using WeightedOption = decltype(options)::WeightedOption;
  options
    .add(FeatureSet::MVP,
         WeightedOption{&Self::makeLocalSet, VeryImportant},
         WeightedOption{&Self::makeBlock, Important},
         WeightedOption{&Self::makeIf, Important},
         WeightedOption{&Self::makeLoop, Important},
         WeightedOption{&Self::makeBreak, Important},
         WeightedOption{&Self::makeStore, Important},
         &Self::makeCall,
         &Self::makeCallIndirect,
         &Self::makeDrop,
         &Self::makeNop,
         &Self::makeGlobalSet)
    .add(FeatureSet::BulkMemory, &Self::makeBulkMemory)
    .add(FeatureSet::Atomics, &Self::makeAtomic)
    .add(FeatureSet::GC | FeatureSet::ReferenceTypes, &Self::makeCallRef)
    .add(FeatureSet::GC | FeatureSet::ReferenceTypes, &Self::makeStructSet)
    .add(FeatureSet::GC | FeatureSet::ReferenceTypes, &Self::makeArraySet)
    .add(FeatureSet::GC | FeatureSet::ReferenceTypes,
         &Self::makeArrayBulkMemoryOp);
  return (this->*pick(options))(Type::none);
}

Expression* TranslateToFuzzReader::_makeunreachable() {
  using Self = TranslateToFuzzReader;
  auto options = FeatureOptions<Expression* (Self::*)(Type)>();
  using WeightedOption = decltype(options)::WeightedOption;
  options
    .add(FeatureSet::MVP,
         WeightedOption{&Self::makeLocalSet, VeryImportant},
         WeightedOption{&Self::makeBlock, Important},
         WeightedOption{&Self::makeIf, Important},
         WeightedOption{&Self::makeLoop, Important},
         WeightedOption{&Self::makeBreak, Important},
         WeightedOption{&Self::makeStore, Important},
         WeightedOption{&Self::makeUnary, Important},
         WeightedOption{&Self::makeBinary, Important},
         WeightedOption{&Self::makeUnreachable, Important},
         &Self::makeCall,
         &Self::makeCallIndirect,
         &Self::makeSelect,
         &Self::makeSwitch,
         &Self::makeDrop,
         &Self::makeReturn)
    .add(FeatureSet::ExceptionHandling, &Self::makeThrow)
    .add(FeatureSet::GC | FeatureSet::ReferenceTypes, &Self::makeCallRef);
  return (this->*pick(options))(Type::unreachable);
}

Expression* TranslateToFuzzReader::makeTrivial(Type type) {
  struct TrivialNester {
    TranslateToFuzzReader& parent;
    TrivialNester(TranslateToFuzzReader& parent) : parent(parent) {
      parent.trivialNesting++;
    }
    ~TrivialNester() { parent.trivialNesting--; }
  } nester(*this);

  if (type.isConcrete()) {
    // If we have a function context, use a local half the time. Use a local
    // less often if the local is non-nullable, however, as then we might be
    // using it before it was set, which would trap.
    if (funcContext && oneIn(type.isNonNullable() ? 10 : 2)) {
      return makeLocalGet(type);
    } else {
      return makeConst(type);
    }
  } else if (type == Type::none) {
    return makeNop(type);
  }
  assert(type == Type::unreachable);
  Expression* ret = nullptr;
  if (funcContext->func->getResults().isConcrete()) {
    ret = makeTrivial(funcContext->func->getResults());
  }
  return builder.makeReturn(ret);
}

Expression* TranslateToFuzzReader::makeBlock(Type type) {
  auto* ret = builder.makeBlock();
  ret->type = type; // so we have it during child creation
  ret->name = makeLabel();
  funcContext->breakableStack.push_back(ret);
  Index num = upToSquared(BLOCK_FACTOR - 1); // we add another later
  if (nesting >= NESTING_LIMIT / 2) {
    // smaller blocks past the limit
    num /= 2;
    if (nesting >= NESTING_LIMIT && oneIn(2)) {
      // smaller blocks past the limit
      num /= 2;
    }
  }
  // not likely to have a block of size 1
  if (num == 0 && !oneIn(10)) {
    num++;
  }
  while (num > 0 && !random.finished()) {
    ret->list.push_back(make(Type::none));
    num--;
  }
  // give a chance to make the final element an unreachable break, instead
  // of concrete - a common pattern (branch to the top of a loop etc.)
  if (!random.finished() && type.isConcrete() && oneIn(2)) {
    ret->list.push_back(makeBreak(Type::unreachable));
  } else {
    ret->list.push_back(make(type));
  }
  funcContext->breakableStack.pop_back();
  if (type.isConcrete()) {
    ret->finalize(type);
  } else {
    ret->finalize();
  }
  if (ret->type != type) {
    // e.g. we might want an unreachable block, but a child breaks to it
    assert(type == Type::unreachable && ret->type == Type::none);
    return builder.makeSequence(ret, make(Type::unreachable));
  }
  return ret;
}

Expression* TranslateToFuzzReader::makeLoop(Type type) {
  auto* ret = wasm.allocator.alloc<Loop>();
  ret->type = type; // So we have it during child creation
  ret->name = makeLabel();
  funcContext->breakableStack.push_back(ret);
  funcContext->hangStack.push_back(ret);
  // Either create random content, or do something more targeted
  if (oneIn(2)) {
    ret->body = makeMaybeBlock(type);
  } else {
    // Ensure a branch back. Also optionally create some loop vars.
    std::vector<Expression*> list;
    list.push_back(makeMaybeBlock(Type::none)); // Primary contents
    // Possible branch back
    list.push_back(builder.makeBreak(ret->name, nullptr, makeCondition()));
    list.push_back(make(type)); // Final element, so we have the right type
    ret->body = builder.makeBlock(list, type);
  }
  funcContext->breakableStack.pop_back();
  funcContext->hangStack.pop_back();
  ret->finalize(type);
  return ret;
}

Expression* TranslateToFuzzReader::makeCondition() {
  // We want a 50-50 chance for the condition to be taken, for interesting
  // execution paths. by itself, there is bias (e.g. most consts are "yes") so
  // even that out with noise
  auto* ret = make(Type::i32);
  if (oneIn(2)) {
    ret = builder.makeUnary(UnaryOp::EqZInt32, ret);
  }
  return ret;
}

Expression* TranslateToFuzzReader::makeMaybeBlock(Type type) {
  // if past the limit, prefer not to emit blocks
  if (nesting >= NESTING_LIMIT || oneIn(3)) {
    return make(type);
  } else {
    return makeBlock(type);
  }
}

Expression* TranslateToFuzzReader::buildIf(const struct ThreeArgs& args,
                                           Type type) {
  return builder.makeIf(args.a, args.b, args.c, type);
}

Expression* TranslateToFuzzReader::makeIf(Type type) {
  auto* condition = makeCondition();
  funcContext->hangStack.push_back(nullptr);

  Expression* ret;
  if (type == Type::none && oneIn(2)) {
    // Just an ifTrue arm.
    ret = buildIf({condition, makeMaybeBlock(type), nullptr}, type);
  } else {
    // Also an ifFalse arm.

    // Some of the time make one arm unreachable (but not both, as then the if
    // as a whole would be unreachable).
    auto trueType = type;
    auto falseType = type;
    switch (upTo(20)) {
      case 0:
        trueType = Type::unreachable;
        break;
      case 1:
        falseType = Type::unreachable;
        break;
    }
    ret = buildIf(
      {condition, makeMaybeBlock(trueType), makeMaybeBlock(falseType)}, type);
  }

  funcContext->hangStack.pop_back();
  return ret;
}

Expression* TranslateToFuzzReader::makeTry(Type type) {
  auto* body = make(type);
  std::vector<Name> catchTags;
  std::vector<Expression*> catchBodies;
  auto numTags = upTo(MAX_TRY_CATCHES);
  std::unordered_set<Tag*> usedTags;
  for (Index i = 0; i < numTags; i++) {
    if (wasm.tags.empty()) {
      addTag();
    }
    auto* tag = pick(wasm.tags).get();
    if (usedTags.count(tag)) {
      continue;
    }
    usedTags.insert(tag);
    catchTags.push_back(tag->name);
  }
  // The number of tags in practice may be fewer than we planned.
  numTags = catchTags.size();
  auto numCatches = numTags;
  if (numTags == 0 || oneIn(2)) {
    // Add a catch-all.
    numCatches++;
  }
  for (Index i = 0; i < numCatches; i++) {
    // Catch bodies (aside from a catch-all) begin with a pop.
    Expression* prefix = nullptr;
    if (i < numTags) {
      auto tagType = wasm.getTag(catchTags[i])->sig.params;
      if (tagType != Type::none) {
        auto* pop = builder.makePop(tagType);
        // Capture the pop in a local, so that it can be used later.
        // TODO: add a good chance for using this particular local in this catch
        // TODO: reuse an existing var if there is one
        auto index = builder.addVar(funcContext->func, tagType);
        prefix = builder.makeLocalSet(index, pop);
      }
    }
    auto* catchBody = make(type);
    if (prefix) {
      catchBody = builder.makeSequence(prefix, catchBody);
    }
    catchBodies.push_back(catchBody);
  }
  // TODO: delegate stuff
  return builder.makeTry(body, catchTags, catchBodies);
}

Expression* TranslateToFuzzReader::makeBreak(Type type) {
  if (funcContext->breakableStack.empty()) {
    return makeTrivial(type);
  }
  Expression* condition = nullptr;
  if (type != Type::unreachable) {
    funcContext->hangStack.push_back(nullptr);
    condition = makeCondition();
  }
  // we need to find a proper target to break to; try a few times
  int tries = TRIES;
  while (tries-- > 0) {
    auto* target = pick(funcContext->breakableStack);
    auto name = getTargetName(target);
    auto valueType = getTargetType(target);
    if (type.isConcrete()) {
      // we are flowing out a value
      if (valueType != type) {
        // we need to break to a proper place
        continue;
      }
      auto* ret = builder.makeBreak(name, make(type), condition);
      funcContext->hangStack.pop_back();
      return ret;
    } else if (type == Type::none) {
      if (valueType != Type::none) {
        // we need to break to a proper place
        continue;
      }
      auto* ret = builder.makeBreak(name, nullptr, condition);
      funcContext->hangStack.pop_back();
      return ret;
    } else {
      assert(type == Type::unreachable);
      if (valueType != Type::none) {
        // we need to break to a proper place
        continue;
      }
      // we are about to make an *un*conditional break. if it is
      // to a loop, we prefer there to be a condition along the
      // way, to reduce the chance of infinite looping
      size_t conditions = 0;
      int i = funcContext->hangStack.size();
      while (--i >= 0) {
        auto* item = funcContext->hangStack[i];
        if (item == nullptr) {
          conditions++;
        } else if (auto* loop = item->cast<Loop>()) {
          if (loop->name == name) {
            // we found the target, no more conditions matter
            break;
          }
        }
      }
      switch (conditions) {
        case 0: {
          if (!oneIn(4)) {
            continue;
          }
          break;
        }
        case 1: {
          if (!oneIn(2)) {
            continue;
          }
          break;
        }
        default: {
          if (oneIn(conditions + 1)) {
            continue;
          }
        }
      }
      return builder.makeBreak(name);
    }
  }
  // we failed to find something
  if (type != Type::unreachable) {
    funcContext->hangStack.pop_back();
  }
  return makeTrivial(type);
}

Expression* TranslateToFuzzReader::makeCall(Type type) {
  int tries = TRIES;
  bool isReturn;
  while (tries-- > 0) {
    Function* target = funcContext->func;
    if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
      target = pick(wasm.functions).get();
    }
    isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
               funcContext->func->getResults() == target->getResults();
    if (target->getResults() != type && !isReturn) {
      continue;
    }
    // we found one!
    std::vector<Expression*> args;
    for (const auto& argType : target->getParams()) {
      args.push_back(make(argType));
    }
    return builder.makeCall(target->name, args, type, isReturn);
  }
  // we failed to find something
  return makeTrivial(type);
}

Expression* TranslateToFuzzReader::makeCallIndirect(Type type) {
  auto& randomElem = wasm.elementSegments[upTo(wasm.elementSegments.size())];
  auto& data = randomElem->data;
  if (data.empty()) {
    return make(type);
  }
  // look for a call target with the right type
  Index start = upTo(data.size());
  Index i = start;
  Function* targetFn;
  bool isReturn;
  while (1) {
    // TODO: handle unreachable
    if (auto* get = data[i]->dynCast<RefFunc>()) {
      targetFn = wasm.getFunction(get->func);
      isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
                 funcContext->func->getResults() == targetFn->getResults();
      if (targetFn->getResults() == type || isReturn) {
        break;
      }
    }
    i++;
    if (i == data.size()) {
      i = 0;
    }
    if (i == start) {
      return makeTrivial(type);
    }
  }
  // with high probability, make sure the type is valid  otherwise, most are
  // going to trap
  Expression* target;
  if (!allowOOB || !oneIn(10)) {
    target = builder.makeConst(int32_t(i));
  } else {
    target = make(Type::i32);
  }
  std::vector<Expression*> args;
  for (const auto& type : targetFn->getParams()) {
    args.push_back(make(type));
  }
  // TODO: use a random table
  return builder.makeCallIndirect(
    funcrefTableName, target, args, targetFn->type, isReturn);
}

Expression* TranslateToFuzzReader::makeCallRef(Type type) {
  // look for a call target with the right type
  Function* target;
  bool isReturn;
  size_t i = 0;
  while (1) {
    if (i == TRIES || wasm.functions.empty()) {
      // We can't find a proper target, give up.
      return makeTrivial(type);
    }
    // TODO: handle unreachable
    target = wasm.functions[upTo(wasm.functions.size())].get();
    isReturn = type == Type::unreachable && wasm.features.hasTailCall() &&
               funcContext->func->getResults() == target->getResults();
    if (target->getResults() == type || isReturn) {
      break;
    }
    i++;
  }
  std::vector<Expression*> args;
  for (const auto& type : target->getParams()) {
    args.push_back(make(type));
  }
  // TODO: half the time make a completely random item with that type.
  return builder.makeCallRef(
    builder.makeRefFunc(target->name, target->type), args, type, isReturn);
}

Expression* TranslateToFuzzReader::makeLocalGet(Type type) {
  auto& locals = funcContext->typeLocals[type];
  if (!locals.empty()) {
    return builder.makeLocalGet(pick(locals), type);
  }
  // No existing local. When we want something trivial, just give up and emit a
  // constant.
  if (trivialNesting) {
    return makeConst(type);
  }

  // Otherwise, we have 3 cases: a const, as above (we do this randomly some of
  // the time), or emit a local.get of a new local, or emit a local.tee of a new
  // local.
  auto choice = upTo(3);
  if (choice == 0) {
    return makeConst(type);
  }
  // Otherwise, add a new local. If the type is not non-nullable then we may
  // just emit a get for it (which, as this is a brand-new local, will read the
  // default value, unless we are in a loop; for that reason for a non-
  // nullable local we prefer a tee later down.).
  auto index = builder.addVar(funcContext->func, type);
  LocalSet* tee = nullptr;
  if (choice == 1 || type.isNonNullable()) {
    // Create the tee here before adding the local to typeLocals (or else we
    // might end up using it prematurely inside the make() call).
    tee = builder.makeLocalTee(index, make(type), type);
  }
  funcContext->typeLocals[type].push_back(index);
  if (tee) {
    return tee;
  }
  return builder.makeLocalGet(index, type);
}

Expression* TranslateToFuzzReader::makeLocalSet(Type type) {
  bool tee = type != Type::none;
  Type valueType;
  if (tee) {
    valueType = type;
  } else {
    valueType = getConcreteType();
  }
  auto& locals = funcContext->typeLocals[valueType];
  if (locals.empty()) {
    return makeTrivial(type);
  }
  auto* value = make(valueType);
  if (tee) {
    return builder.makeLocalTee(pick(locals), value, valueType);
  } else {
    return builder.makeLocalSet(pick(locals), value);
  }
}

Expression* TranslateToFuzzReader::makeGlobalGet(Type type) {
  auto it = globalsByType.find(type);
  if (it == globalsByType.end() || it->second.empty()) {
    return makeTrivial(type);
  }

  auto name = pick(it->second);
  // We don't want random fuzz code to use the hang limit global.
  assert(name != HANG_LIMIT_GLOBAL);
  return builder.makeGlobalGet(name, type);
}

Expression* TranslateToFuzzReader::makeGlobalSet(Type type) {
  assert(type == Type::none);
  type = getConcreteType();
  auto it = mutableGlobalsByType.find(type);
  if (it == mutableGlobalsByType.end() || it->second.empty()) {
    return makeTrivial(Type::none);
  }

  auto name = pick(it->second);
  // We don't want random fuzz code to use the hang limit global.
  assert(name != HANG_LIMIT_GLOBAL);
  return builder.makeGlobalSet(name, make(type));
}

Expression* TranslateToFuzzReader::makeTupleMake(Type type) {
  assert(wasm.features.hasMultivalue());
  assert(type.isTuple());
  std::vector<Expression*> elements;
  for (const auto& t : type) {
    elements.push_back(make(t));
  }
  return builder.makeTupleMake(std::move(elements));
}

Expression* TranslateToFuzzReader::makeTupleExtract(Type type) {
  // Tuples can require locals in binary format conversions.
  if (!type.isDefaultable()) {
    return makeTrivial(type);
  }
  assert(wasm.features.hasMultivalue());
  assert(type.isSingle() && type.isConcrete());
  Type tupleType = getTupleType();

  // Find indices from which we can extract `type`
  std::vector<size_t> extractIndices;
  size_t i = 0;
  for (const auto& t : tupleType) {
    if (t == type) {
      extractIndices.push_back(i);
    }
    ++i;
  }

  // If there are none, inject one
  if (extractIndices.size() == 0) {
    std::vector<Type> newElements(tupleType.begin(), tupleType.end());
    size_t injected = upTo(newElements.size());
    newElements[injected] = type;
    tupleType = Type(newElements);
    extractIndices.push_back(injected);
  }

  Index index = pick(extractIndices);
  Expression* child = make(tupleType);
  return builder.makeTupleExtract(child, index);
}

Expression* TranslateToFuzzReader::makePointer() {
  auto* ret = make(wasm.memories[0]->indexType);
  // with high probability, mask the pointer so it's in a reasonable
  // range. otherwise, most pointers are going to be out of range and
  // most memory ops will just trap
  if (!allowOOB || !oneIn(10)) {
    if (wasm.memories[0]->is64()) {
      ret = builder.makeBinary(
        AndInt64, ret, builder.makeConst(int64_t(USABLE_MEMORY - 1)));
    } else {
      ret = builder.makeBinary(
        AndInt32, ret, builder.makeConst(int32_t(USABLE_MEMORY - 1)));
    }
  }
  return ret;
}

Expression* TranslateToFuzzReader::makeNonAtomicLoad(Type type) {
  auto offset = logify(get());
  auto ptr = makePointer();
  switch (type.getBasic()) {
    case Type::i32: {
      bool signed_ = get() & 1;
      switch (upTo(3)) {
        case 0:
          return builder.makeLoad(
            1, signed_, offset, 1, ptr, type, wasm.memories[0]->name);
        case 1:
          return builder.makeLoad(
            2, signed_, offset, pick(1, 2), ptr, type, wasm.memories[0]->name);
        case 2:
          return builder.makeLoad(4,
                                  signed_,
                                  offset,
                                  pick(1, 2, 4),
                                  ptr,
                                  type,
                                  wasm.memories[0]->name);
      }
      WASM_UNREACHABLE("unexpected value");
    }
    case Type::i64: {
      bool signed_ = get() & 1;
      switch (upTo(4)) {
        case 0:
          return builder.makeLoad(
            1, signed_, offset, 1, ptr, type, wasm.memories[0]->name);
        case 1:
          return builder.makeLoad(
            2, signed_, offset, pick(1, 2), ptr, type, wasm.memories[0]->name);
        case 2:
          return builder.makeLoad(4,
                                  signed_,
                                  offset,
                                  pick(1, 2, 4),
                                  ptr,
                                  type,
                                  wasm.memories[0]->name);
        case 3:
          return builder.makeLoad(8,
                                  signed_,
                                  offset,
                                  pick(1, 2, 4, 8),
                                  ptr,
                                  type,
                                  wasm.memories[0]->name);
      }
      WASM_UNREACHABLE("unexpected value");
    }
    case Type::f32: {
      return builder.makeLoad(
        4, false, offset, pick(1, 2, 4), ptr, type, wasm.memories[0]->name);
    }
    case Type::f64: {
      return builder.makeLoad(
        8, false, offset, pick(1, 2, 4, 8), ptr, type, wasm.memories[0]->name);
    }
    case Type::v128: {
      if (!wasm.features.hasSIMD()) {
        return makeTrivial(type);
      }
      return builder.makeLoad(16,
                              false,
                              offset,
                              pick(1, 2, 4, 8, 16),
                              ptr,
                              type,
                              wasm.memories[0]->name);
    }
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

Expression* TranslateToFuzzReader::makeLoad(Type type) {
  // reference types cannot be stored in memory
  if (!allowMemory || type.isRef()) {
    return makeTrivial(type);
  }
  auto* ret = makeNonAtomicLoad(type);
  if (type != Type::i32 && type != Type::i64) {
    return ret;
  }
  if (!wasm.features.hasAtomics() || oneIn(2)) {
    return ret;
  }
  // make it atomic
  auto* load = ret->cast<Load>();
  wasm.memories[0]->shared = true;
  load->isAtomic = true;
  load->signed_ = false;
  load->align = load->bytes;
  return load;
}

Expression* TranslateToFuzzReader::makeNonAtomicStore(Type type) {
  if (type == Type::unreachable) {
    // make a normal store, then make it unreachable
    auto* ret = makeNonAtomicStore(getStorableType());
    auto* store = ret->dynCast<Store>();
    if (!store) {
      return ret;
    }
    switch (upTo(3)) {
      case 0:
        store->ptr = make(Type::unreachable);
        break;
      case 1:
        store->value = make(Type::unreachable);
        break;
      case 2:
        store->ptr = make(Type::unreachable);
        store->value = make(Type::unreachable);
        break;
    }
    store->memory = wasm.memories[0]->name;
    store->finalize();
    return store;
  }
  // the type is none or unreachable. we also need to pick the value
  // type.
  if (type == Type::none) {
    type = getStorableType();
  }
  auto offset = logify(get());
  auto ptr = makePointer();
  auto value = make(type);
  switch (type.getBasic()) {
    case Type::i32: {
      switch (upTo(3)) {
        case 0:
          return builder.makeStore(
            1, offset, 1, ptr, value, type, wasm.memories[0]->name);
        case 1:
          return builder.makeStore(
            2, offset, pick(1, 2), ptr, value, type, wasm.memories[0]->name);
        case 2:
          return builder.makeStore(
            4, offset, pick(1, 2, 4), ptr, value, type, wasm.memories[0]->name);
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::i64: {
      switch (upTo(4)) {
        case 0:
          return builder.makeStore(
            1, offset, 1, ptr, value, type, wasm.memories[0]->name);
        case 1:
          return builder.makeStore(
            2, offset, pick(1, 2), ptr, value, type, wasm.memories[0]->name);
        case 2:
          return builder.makeStore(
            4, offset, pick(1, 2, 4), ptr, value, type, wasm.memories[0]->name);
        case 3:
          return builder.makeStore(8,
                                   offset,
                                   pick(1, 2, 4, 8),
                                   ptr,
                                   value,
                                   type,
                                   wasm.memories[0]->name);
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::f32: {
      return builder.makeStore(
        4, offset, pick(1, 2, 4), ptr, value, type, wasm.memories[0]->name);
    }
    case Type::f64: {
      return builder.makeStore(
        8, offset, pick(1, 2, 4, 8), ptr, value, type, wasm.memories[0]->name);
    }
    case Type::v128: {
      if (!wasm.features.hasSIMD()) {
        return makeTrivial(type);
      }
      return builder.makeStore(16,
                               offset,
                               pick(1, 2, 4, 8, 16),
                               ptr,
                               value,
                               type,
                               wasm.memories[0]->name);
    }
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

Expression* TranslateToFuzzReader::makeStore(Type type) {
  if (!allowMemory || type.isRef()) {
    return makeTrivial(type);
  }
  auto* ret = makeNonAtomicStore(type);
  auto* store = ret->dynCast<Store>();
  if (!store) {
    return ret;
  }
  if (store->value->type != Type::i32 && store->value->type != Type::i64) {
    return store;
  }
  if (!wasm.features.hasAtomics() || oneIn(2)) {
    return store;
  }
  // make it atomic
  wasm.memories[0]->shared = true;
  store->isAtomic = true;
  store->align = store->bytes;
  return store;
}

// Makes a small change to a constant value.
Literal TranslateToFuzzReader::tweak(Literal value) {
  auto type = value.type;
  if (type.isVector()) {
    // TODO: tweak each lane?
    return value;
  }
  // +- 1
  switch (upTo(5)) {
    case 0:
      value = value.add(Literal::makeNegOne(type));
      break;
    case 1:
      value = value.add(Literal::makeOne(type));
      break;
    default: {
    }
  }
  // For floats, optionally add a non-integer adjustment in +- [-1, 1]
  if (type.isFloat() && oneIn(2)) {
    const int RANGE = 1000;
    auto RANGE_LITERAL = Literal::makeFromInt32(RANGE, type);
    // adjustment -> [0, 2 * RANGE]
    auto adjustment = Literal::makeFromInt32(upTo(2 * RANGE + 1), type);
    // adjustment -> [-RANGE, RANGE]
    adjustment = adjustment.sub(RANGE_LITERAL);
    // adjustment -> [-1, 1]
    adjustment = adjustment.div(RANGE_LITERAL);
    value = value.add(adjustment);
  }
  // Flip sign.
  if (oneIn(2)) {
    value = value.mul(Literal::makeNegOne(type));
  }
  return value;
}

Literal TranslateToFuzzReader::makeLiteral(Type type) {
  if (type == Type::v128) {
    // generate each lane individually for random lane interpretation
    switch (upTo(6)) {
      case 0:
        return Literal(std::array<Literal, 16>{{makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32),
                                                makeLiteral(Type::i32)}});
      case 1:
        return Literal(std::array<Literal, 8>{{makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32)}});
      case 2:
        return Literal(std::array<Literal, 4>{{makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32),
                                               makeLiteral(Type::i32)}});
      case 3:
        return Literal(std::array<Literal, 2>{
          {makeLiteral(Type::i64), makeLiteral(Type::i64)}});
      case 4:
        return Literal(std::array<Literal, 4>{{makeLiteral(Type::f32),
                                               makeLiteral(Type::f32),
                                               makeLiteral(Type::f32),
                                               makeLiteral(Type::f32)}});
      case 5:
        return Literal(std::array<Literal, 2>{
          {makeLiteral(Type::f64), makeLiteral(Type::f64)}});
      default:
        WASM_UNREACHABLE("unexpected value");
    }
  }

  switch (upTo(4)) {
    case 0: {
      // totally random, entire range
      switch (type.getBasic()) {
        case Type::i32:
          return Literal(get32());
        case Type::i64:
          return Literal(get64());
        case Type::f32:
          return Literal(getFloat());
        case Type::f64:
          return Literal(getDouble());
        case Type::v128:
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("invalid type");
      }
      break;
    }
    case 1: {
      // small range
      int64_t small;
      switch (upTo(6)) {
        case 0:
          small = int8_t(get());
          break;
        case 1:
          small = uint8_t(get());
          break;
        case 2:
          small = int16_t(get16());
          break;
        case 3:
          small = uint16_t(get16());
          break;
        case 4:
          small = int32_t(get32());
          break;
        case 5:
          small = uint32_t(get32());
          break;
        default:
          WASM_UNREACHABLE("invalid value");
      }
      switch (type.getBasic()) {
        case Type::i32:
          return Literal(int32_t(small));
        case Type::i64:
          return Literal(int64_t(small));
        case Type::f32:
          return Literal(float(small));
        case Type::f64:
          return Literal(double(small));
        case Type::v128:
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      break;
    }
    case 2: {
      // special values
      Literal value;
      switch (type.getBasic()) {
        case Type::i32:
          value = Literal(pick<int32_t>(0,
                                        std::numeric_limits<int8_t>::min(),
                                        std::numeric_limits<int8_t>::max(),
                                        std::numeric_limits<int16_t>::min(),
                                        std::numeric_limits<int16_t>::max(),
                                        std::numeric_limits<int32_t>::min(),
                                        std::numeric_limits<int32_t>::max(),
                                        std::numeric_limits<uint8_t>::max(),
                                        std::numeric_limits<uint16_t>::max(),
                                        std::numeric_limits<uint32_t>::max()));
          break;
        case Type::i64:
          value = Literal(pick<int64_t>(0,
                                        std::numeric_limits<int8_t>::min(),
                                        std::numeric_limits<int8_t>::max(),
                                        std::numeric_limits<int16_t>::min(),
                                        std::numeric_limits<int16_t>::max(),
                                        std::numeric_limits<int32_t>::min(),
                                        std::numeric_limits<int32_t>::max(),
                                        std::numeric_limits<int64_t>::min(),
                                        std::numeric_limits<int64_t>::max(),
                                        std::numeric_limits<uint8_t>::max(),
                                        std::numeric_limits<uint16_t>::max(),
                                        std::numeric_limits<uint32_t>::max(),
                                        std::numeric_limits<uint64_t>::max()));
          break;
        case Type::f32:
          value = Literal(pick<float>(0.0f,
                                      -0.0f,
                                      std::numeric_limits<float>::min(),
                                      std::numeric_limits<float>::max(),
                                      std::numeric_limits<int32_t>::min(),
                                      std::numeric_limits<int32_t>::max(),
                                      std::numeric_limits<int64_t>::min(),
                                      std::numeric_limits<int64_t>::max(),
                                      std::numeric_limits<uint32_t>::max(),
                                      std::numeric_limits<uint64_t>::max()));
          break;
        case Type::f64:
          value = Literal(pick<double>(0.0,
                                       -0.0,
                                       std::numeric_limits<float>::min(),
                                       std::numeric_limits<float>::max(),
                                       std::numeric_limits<double>::min(),
                                       std::numeric_limits<double>::max(),
                                       std::numeric_limits<int32_t>::min(),
                                       std::numeric_limits<int32_t>::max(),
                                       std::numeric_limits<int64_t>::min(),
                                       std::numeric_limits<int64_t>::max(),
                                       std::numeric_limits<uint32_t>::max(),
                                       std::numeric_limits<uint64_t>::max()));
          break;
        case Type::v128:
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      return tweak(value);
    }
    case 3: {
      // powers of 2
      Literal value;
      switch (type.getBasic()) {
        case Type::i32:
          value = Literal(int32_t(1) << upTo(32));
          break;
        case Type::i64:
          value = Literal(int64_t(1) << upTo(64));
          break;
        case Type::f32:
          value = Literal(float(int64_t(1) << upTo(64)));
          break;
        case Type::f64:
          value = Literal(double(int64_t(1) << upTo(64)));
          break;
        case Type::v128:
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      return tweak(value);
    }
  }
  WASM_UNREACHABLE("invalid value");
}

Expression* TranslateToFuzzReader::makeRefFuncConst(Type type) {
  auto heapType = type.getHeapType();
  if (heapType == HeapType::func) {
    // First set to target to the last created function, and try to select
    // among other existing function if possible.
    Function* target = funcContext ? funcContext->func : nullptr;
    // If there is no last function, and we have others, pick between them. Also
    // pick between them with some random probability even if there is a last
    // function.
    if (!wasm.functions.empty() && (!target || !oneIn(wasm.functions.size()))) {
      target = pick(wasm.functions).get();
    }
    if (target) {
      return builder.makeRefFunc(target->name, target->type);
    }
  }
  if (heapType == HeapType::func) {
    // From here on we need a specific signature type, as we want to create a
    // RefFunc or even a Function out of it. Pick an arbitrary one if we only
    // had generic 'func' here.
    heapType = Signature(Type::none, Type::none);
  }
  // TODO: randomize the order
  for (auto& func : wasm.functions) {
    if (Type::isSubType(Type(func->type, NonNullable), type)) {
      return builder.makeRefFunc(func->name, func->type);
    }
  }
  // We don't have a matching function. Create a null some of the time here,
  // but only rarely if the type is non-nullable (because in that case we'd need
  // to add a ref.as_non_null to validate, and the code will trap when we get
  // here).
  if ((type.isNullable() && oneIn(2)) ||
      (type.isNonNullable() && oneIn(16) && funcContext)) {
    Expression* ret = builder.makeRefNull(HeapType::nofunc);
    if (!type.isNullable()) {
      assert(funcContext);
      ret = builder.makeRefAs(RefAsNonNull, ret);
    }
    return ret;
  }
  // As a final option, create a new function with the correct signature. If it
  // returns a value, write a trap as we do not want to create any more code
  // here (we might end up recursing). Note that a trap in the function lets us
  // execute more code then the ref.as_non_null path just before us, which traps
  // even if we never call the function.
  auto* body = heapType.getSignature().results == Type::none
                 ? (Expression*)builder.makeNop()
                 : (Expression*)builder.makeUnreachable();
  auto* func = wasm.addFunction(builder.makeFunction(
    Names::getValidFunctionName(wasm, "ref_func_target"), heapType, {}, body));
  return builder.makeRefFunc(func->name, heapType);
}

Expression* TranslateToFuzzReader::makeConst(Type type) {
  if (type.isRef()) {
    assert(wasm.features.hasReferenceTypes());
    // With a low chance, just emit a null if that is valid.
    if (type.isNullable() && oneIn(8)) {
      return builder.makeRefNull(type.getHeapType());
    }
    if (type.getHeapType().isBasic()) {
      return makeBasicRef(type);
    } else {
      return makeCompoundRef(type);
    }
  } else if (type.isTuple()) {
    std::vector<Expression*> operands;
    for (const auto& t : type) {
      operands.push_back(makeConst(t));
    }
    return builder.makeTupleMake(std::move(operands));
  } else {
    assert(type.isBasic());
    return builder.makeConst(makeLiteral(type));
  }
}

Expression* TranslateToFuzzReader::makeBasicRef(Type type) {
  assert(type.isRef());
  auto heapType = type.getHeapType();
  assert(heapType.isBasic());
  assert(wasm.features.hasReferenceTypes());
  switch (heapType.getBasic()) {
    case HeapType::ext: {
      auto null = builder.makeRefNull(HeapType::ext);
      // TODO: support actual non-nullable externrefs via imported globals or
      // similar.
      if (!type.isNullable()) {
        assert(funcContext);
        return builder.makeRefAs(RefAsNonNull, null);
      }
      return null;
    }
    case HeapType::func: {
      return makeRefFuncConst(type);
    }
    case HeapType::any: {
      // Choose a subtype we can materialize a constant for. We cannot
      // materialize non-nullable refs to func or i31 in global contexts.
      Nullability nullability = getSubType(type.getNullability());
      HeapType subtype;
      switch (upTo(3)) {
        case 0:
          subtype = HeapType::i31;
          break;
        case 1:
          subtype = HeapType::struct_;
          break;
        case 2:
          subtype = HeapType::array;
          break;
      }
      return makeConst(Type(subtype, nullability));
    }
    case HeapType::eq: {
      if (!wasm.features.hasGC()) {
        // Without wasm GC all we have is an "abstract" eqref type, which is
        // a subtype of anyref, but we cannot create constants of it, except
        // for null.
        assert(type.isNullable());
        return builder.makeRefNull(HeapType::none);
      }
      auto nullability = getSubType(type.getNullability());
      // ref.i31 is not allowed in initializer expressions.
      HeapType subtype;
      switch (upTo(3)) {
        case 0:
          subtype = HeapType::i31;
          break;
        case 1:
          subtype = HeapType::struct_;
          break;
        case 2:
          subtype = HeapType::array;
          break;
      }
      return makeConst(Type(subtype, nullability));
    }
    case HeapType::i31: {
      assert(wasm.features.hasGC());
      if (type.isNullable() && oneIn(4)) {
        return builder.makeRefNull(HeapType::none);
      }
      return builder.makeRefI31(makeConst(Type::i32));
    }
    case HeapType::struct_: {
      assert(wasm.features.hasGC());
      // TODO: Construct nontrivial types. For now just create a hard coded
      // struct.
      // Use a local static to avoid the expense of canonicalizing a new type
      // every time.
      static HeapType trivialStruct = HeapType(Struct());
      return builder.makeStructNew(trivialStruct, std::vector<Expression*>{});
    }
    case HeapType::array: {
      static HeapType trivialArray =
        HeapType(Array(Field(Field::PackedType::i8, Immutable)));
      return builder.makeArrayNewFixed(trivialArray, {});
    }
    case HeapType::exn: {
      auto null = builder.makeRefNull(HeapType::exn);
      if (!type.isNullable()) {
        assert(funcContext);
        return builder.makeRefAs(RefAsNonNull, null);
      }
      return null;
    }
    case HeapType::string:
      return builder.makeStringConst(std::to_string(upTo(1024)));
    case HeapType::stringview_wtf8:
    case HeapType::stringview_wtf16:
    case HeapType::stringview_iter:
      WASM_UNREACHABLE("TODO: strings");
    case HeapType::none:
    case HeapType::noext:
    case HeapType::nofunc:
    case HeapType::noexn: {
      auto null = builder.makeRefNull(heapType);
      if (!type.isNullable()) {
        assert(funcContext);
        return builder.makeRefAs(RefAsNonNull, null);
      }
      return null;
    }
  }
  WASM_UNREACHABLE("invalid basic ref type");
}

Expression* TranslateToFuzzReader::makeCompoundRef(Type type) {
  assert(type.isRef());
  auto heapType = type.getHeapType();
  assert(!heapType.isBasic());
  assert(wasm.features.hasReferenceTypes());

  // Prefer not to emit a null, in general, as we can trap from them. If it is
  // nullable, give a small chance to do so; if we hit the nesting limit then we
  // really have no choice and must emit a null (or else we could infinitely
  // recurse). For the nesting limit, use a bound that is higher than the normal
  // one, so that the normal mechanisms should prevent us from getting here;
  // this limit is really a last resort we want to never reach. Also, increase
  // the chance to emit a null as |nesting| rises, to avoid deep recursive
  // structures.
  //
  // Note that we might have cycles of types where some are non-nullable. We
  // will only stop here when we exceed the nesting and reach a nullable one.
  // (This assumes there is a nullable one, that is, that the types are
  // inhabitable.)
  const auto LIMIT = NESTING_LIMIT + 1;
  AutoNester nester(*this);
  if (type.isNullable() &&
      (random.finished() || nesting >= LIMIT || oneIn(LIMIT - nesting + 1))) {
    return builder.makeRefNull(heapType);
  }

  // If the type is non-nullable, but we've run out of input, then we need to do
  // something here to avoid infinite recursion. In the worse case we'll emit a
  // cast to non-null of a null, which validates, but it will trap at runtime
  // which is not ideal.
  if (type.isNonNullable() && (random.finished() || nesting >= LIMIT)) {
    // If we have a function context then we can at least emit a local.get,
    // perhaps, which is less bad. Note that we need to check typeLocals
    // manually here to avoid infinite recursion (as makeLocalGet will fall back
    // to us, if there is no local).
    // TODO: we could also look for locals containing subtypes
    if (funcContext && !funcContext->typeLocals[type].empty()) {
      return makeLocalGet(type);
    }
    return builder.makeRefAs(RefAsNonNull, builder.makeRefNull(heapType));
  }

  // When we make children, they must be trivial if we are not in a function
  // context.
  auto makeChild = [&](Type type) {
    return funcContext ? make(type) : makeTrivial(type);
  };

  if (heapType.isSignature()) {
    return makeRefFuncConst(type);
  } else if (type.isStruct()) {
    auto& fields = heapType.getStruct().fields;
    std::vector<Expression*> values;
    // If there is a nondefaultable field, we must provide the value and not
    // depend on defaults. Also do that randomly half the time.
    if (std::any_of(
          fields.begin(),
          fields.end(),
          [&](const Field& field) { return !field.type.isDefaultable(); }) ||
        oneIn(2)) {
      for (auto& field : fields) {
        values.push_back(makeChild(field.type));
      }
      // Add more nesting manually, as we can easily get exponential blowup
      // here. This nesting makes it much less likely for a recursive data
      // structure to end up as a massive tree of struct.news, since the nesting
      // limitation code at the top of this function will kick in.
      if (!values.empty()) {
        // Subtract 1 since if there is a single value there cannot be
        // exponential blowup.
        nester.add(values.size() - 1);
      }
    }
    return builder.makeStructNew(heapType, values);
  } else if (type.isArray()) {
    auto element = heapType.getArray().element;
    Expression* init = nullptr;
    if (!element.type.isDefaultable() || oneIn(2)) {
      init = makeChild(element.type);
    }
    auto* count = builder.makeConst(int32_t(upTo(MAX_ARRAY_SIZE)));
    return builder.makeArrayNew(type.getHeapType(), count, init);
  } else {
    WASM_UNREACHABLE("bad user-defined ref type");
  }
}

Expression* TranslateToFuzzReader::makeTrappingRefUse(HeapType type) {
  auto percent = upTo(100);
  // Only give a low probability to emit a nullable reference.
  if (percent < 5) {
    return make(Type(type, Nullable));
  }
  // Otherwise, usually emit a non-nullable one.
  auto nonNull = Type(type, NonNullable);
  if (percent < 70 || !funcContext) {
    return make(nonNull);
  }
  // With significant probability, try to use an existing value, that is, to
  // get a value using local.get, as it is better to have patterns like this:
  //
  //  (local.set $ref (struct.new $..
  //  (struct.get (local.get $ref))
  //
  // Rather than constantly operating on new data each time:
  //
  //  (local.set $ref (struct.new $..
  //  (struct.get (struct.new $..
  //
  // By using local values more, we get more coverage of interesting sequences
  // of reads and writes to the same objects.
  //
  // Note that makeLocalGet will add a local if necessary, and even tee that
  // value so it is usable later as well.
  return makeLocalGet(nonNull);
}

Expression* TranslateToFuzzReader::buildUnary(const UnaryArgs& args) {
  return builder.makeUnary(args.a, args.b);
}

Expression* TranslateToFuzzReader::makeUnary(Type type) {
  assert(!type.isTuple());
  if (type == Type::unreachable) {
    if (auto* unary = makeUnary(getSingleConcreteType())->dynCast<Unary>()) {
      return builder.makeUnary(unary->op, make(Type::unreachable));
    }
    // give up
    return makeTrivial(type);
  }
  // There are no unary ops for reference types.
  // TODO: not quite true if you count struct.new and array.new.
  if (type.isRef()) {
    return makeTrivial(type);
  }
  switch (type.getBasic()) {
    case Type::i32: {
      auto singleConcreteType = getSingleConcreteType();
      if (singleConcreteType.isRef()) {
        // TODO: Do something more interesting here.
        return makeTrivial(type);
      }
      switch (singleConcreteType.getBasic()) {
        case Type::i32: {
          auto op = pick(
            FeatureOptions<UnaryOp>()
              .add(FeatureSet::MVP, EqZInt32, ClzInt32, CtzInt32, PopcntInt32)
              .add(FeatureSet::SignExt, ExtendS8Int32, ExtendS16Int32));
          return buildUnary({op, make(Type::i32)});
        }
        case Type::i64:
          return buildUnary({pick(EqZInt64, WrapInt64), make(Type::i64)});
        case Type::f32: {
          auto op = pick(FeatureOptions<UnaryOp>()
                           .add(FeatureSet::MVP,
                                TruncSFloat32ToInt32,
                                TruncUFloat32ToInt32,
                                ReinterpretFloat32)
                           .add(FeatureSet::TruncSat,
                                TruncSatSFloat32ToInt32,
                                TruncSatUFloat32ToInt32));
          return buildUnary({op, make(Type::f32)});
        }
        case Type::f64: {
          auto op = pick(
            FeatureOptions<UnaryOp>()
              .add(FeatureSet::MVP, TruncSFloat64ToInt32, TruncUFloat64ToInt32)
              .add(FeatureSet::TruncSat,
                   TruncSatSFloat64ToInt32,
                   TruncSatUFloat64ToInt32));
          return buildUnary({op, make(Type::f64)});
        }
        case Type::v128: {
          assert(wasm.features.hasSIMD());
          // TODO: Add the other SIMD unary ops
          return buildUnary({pick(AnyTrueVec128,
                                  AllTrueVecI8x16,
                                  AllTrueVecI16x8,
                                  AllTrueVecI32x4),
                             make(Type::v128)});
        }
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      WASM_UNREACHABLE("invalid type");
    }
    case Type::i64: {
      switch (upTo(4)) {
        case 0: {
          auto op =
            pick(FeatureOptions<UnaryOp>()
                   .add(FeatureSet::MVP, ClzInt64, CtzInt64, PopcntInt64)
                   .add(FeatureSet::SignExt,
                        ExtendS8Int64,
                        ExtendS16Int64,
                        ExtendS32Int64));
          return buildUnary({op, make(Type::i64)});
        }
        case 1:
          return buildUnary(
            {pick(ExtendSInt32, ExtendUInt32), make(Type::i32)});
        case 2: {
          auto op = pick(
            FeatureOptions<UnaryOp>()
              .add(FeatureSet::MVP, TruncSFloat32ToInt64, TruncUFloat32ToInt64)
              .add(FeatureSet::TruncSat,
                   TruncSatSFloat32ToInt64,
                   TruncSatUFloat32ToInt64));
          return buildUnary({op, make(Type::f32)});
        }
        case 3: {
          auto op = pick(FeatureOptions<UnaryOp>()
                           .add(FeatureSet::MVP,
                                TruncSFloat64ToInt64,
                                TruncUFloat64ToInt64,
                                ReinterpretFloat64)
                           .add(FeatureSet::TruncSat,
                                TruncSatSFloat64ToInt64,
                                TruncSatUFloat64ToInt64));
          return buildUnary({op, make(Type::f64)});
        }
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::f32: {
      switch (upTo(4)) {
        case 0:
          return buildUnary({pick(NegFloat32,
                                  AbsFloat32,
                                  CeilFloat32,
                                  FloorFloat32,
                                  TruncFloat32,
                                  NearestFloat32,
                                  SqrtFloat32),
                             make(Type::f32)});
        case 1:
          return buildUnary({pick(ConvertUInt32ToFloat32,
                                  ConvertSInt32ToFloat32,
                                  ReinterpretInt32),
                             make(Type::i32)});
        case 2:
          return buildUnary(
            {pick(ConvertUInt64ToFloat32, ConvertSInt64ToFloat32),
             make(Type::i64)});
        case 3:
          return buildUnary({DemoteFloat64, make(Type::f64)});
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::f64: {
      switch (upTo(4)) {
        case 0:
          return buildUnary({pick(NegFloat64,
                                  AbsFloat64,
                                  CeilFloat64,
                                  FloorFloat64,
                                  TruncFloat64,
                                  NearestFloat64,
                                  SqrtFloat64),
                             make(Type::f64)});
        case 1:
          return buildUnary(
            {pick(ConvertUInt32ToFloat64, ConvertSInt32ToFloat64),
             make(Type::i32)});
        case 2:
          return buildUnary({pick(ConvertUInt64ToFloat64,
                                  ConvertSInt64ToFloat64,
                                  ReinterpretInt64),
                             make(Type::i64)});
        case 3:
          return buildUnary({PromoteFloat32, make(Type::f32)});
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::v128: {
      assert(wasm.features.hasSIMD());
      switch (upTo(5)) {
        case 0:
          return buildUnary({pick(SplatVecI8x16, SplatVecI16x8, SplatVecI32x4),
                             make(Type::i32)});
        case 1:
          return buildUnary({SplatVecI64x2, make(Type::i64)});
        case 2:
          return buildUnary({SplatVecF32x4, make(Type::f32)});
        case 3:
          return buildUnary({SplatVecF64x2, make(Type::f64)});
        case 4:
          return buildUnary({pick(NotVec128,
                                  // TODO: add additional SIMD instructions
                                  NegVecI8x16,
                                  NegVecI16x8,
                                  NegVecI32x4,
                                  NegVecI64x2,
                                  AbsVecF32x4,
                                  NegVecF32x4,
                                  SqrtVecF32x4,
                                  AbsVecF64x2,
                                  NegVecF64x2,
                                  SqrtVecF64x2,
                                  TruncSatSVecF32x4ToVecI32x4,
                                  TruncSatUVecF32x4ToVecI32x4,
                                  ConvertSVecI32x4ToVecF32x4,
                                  ConvertUVecI32x4ToVecF32x4,
                                  ExtendLowSVecI8x16ToVecI16x8,
                                  ExtendHighSVecI8x16ToVecI16x8,
                                  ExtendLowUVecI8x16ToVecI16x8,
                                  ExtendHighUVecI8x16ToVecI16x8,
                                  ExtendLowSVecI16x8ToVecI32x4,
                                  ExtendHighSVecI16x8ToVecI32x4,
                                  ExtendLowUVecI16x8ToVecI32x4,
                                  ExtendHighUVecI16x8ToVecI32x4),
                             make(Type::v128)});
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("invalid type");
}

Expression* TranslateToFuzzReader::buildBinary(const BinaryArgs& args) {
  return builder.makeBinary(args.a, args.b, args.c);
}

Expression* TranslateToFuzzReader::makeBinary(Type type) {
  assert(!type.isTuple());
  if (type == Type::unreachable) {
    if (auto* binary = makeBinary(getSingleConcreteType())->dynCast<Binary>()) {
      return buildBinary(
        {binary->op, make(Type::unreachable), make(Type::unreachable)});
    }
    // give up
    return makeTrivial(type);
  }
  // There are no binary ops for reference types.
  // TODO: Use struct.new
  if (type.isRef()) {
    return makeTrivial(type);
  }
  switch (type.getBasic()) {
    case Type::i32: {
      switch (upTo(4)) {
        case 0:
          return buildBinary({pick(AddInt32,
                                   SubInt32,
                                   MulInt32,
                                   DivSInt32,
                                   DivUInt32,
                                   RemSInt32,
                                   RemUInt32,
                                   AndInt32,
                                   OrInt32,
                                   XorInt32,
                                   ShlInt32,
                                   ShrUInt32,
                                   ShrSInt32,
                                   RotLInt32,
                                   RotRInt32,
                                   EqInt32,
                                   NeInt32,
                                   LtSInt32,
                                   LtUInt32,
                                   LeSInt32,
                                   LeUInt32,
                                   GtSInt32,
                                   GtUInt32,
                                   GeSInt32,
                                   GeUInt32),
                              make(Type::i32),
                              make(Type::i32)});
        case 1:
          return buildBinary({pick(EqInt64,
                                   NeInt64,
                                   LtSInt64,
                                   LtUInt64,
                                   LeSInt64,
                                   LeUInt64,
                                   GtSInt64,
                                   GtUInt64,
                                   GeSInt64,
                                   GeUInt64),
                              make(Type::i64),
                              make(Type::i64)});
        case 2:
          return buildBinary({pick(EqFloat32,
                                   NeFloat32,
                                   LtFloat32,
                                   LeFloat32,
                                   GtFloat32,
                                   GeFloat32),
                              make(Type::f32),
                              make(Type::f32)});
        case 3:
          return buildBinary({pick(EqFloat64,
                                   NeFloat64,
                                   LtFloat64,
                                   LeFloat64,
                                   GtFloat64,
                                   GeFloat64),
                              make(Type::f64),
                              make(Type::f64)});
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::i64: {
      return buildBinary({pick(AddInt64,
                               SubInt64,
                               MulInt64,
                               DivSInt64,
                               DivUInt64,
                               RemSInt64,
                               RemUInt64,
                               AndInt64,
                               OrInt64,
                               XorInt64,
                               ShlInt64,
                               ShrUInt64,
                               ShrSInt64,
                               RotLInt64,
                               RotRInt64),
                          make(Type::i64),
                          make(Type::i64)});
    }
    case Type::f32: {
      return buildBinary({pick(AddFloat32,
                               SubFloat32,
                               MulFloat32,
                               DivFloat32,
                               CopySignFloat32,
                               MinFloat32,
                               MaxFloat32),
                          make(Type::f32),
                          make(Type::f32)});
    }
    case Type::f64: {
      return buildBinary({pick(AddFloat64,
                               SubFloat64,
                               MulFloat64,
                               DivFloat64,
                               CopySignFloat64,
                               MinFloat64,
                               MaxFloat64),
                          make(Type::f64),
                          make(Type::f64)});
    }
    case Type::v128: {
      assert(wasm.features.hasSIMD());
      return buildBinary({pick(EqVecI8x16,
                               NeVecI8x16,
                               LtSVecI8x16,
                               LtUVecI8x16,
                               GtSVecI8x16,
                               GtUVecI8x16,
                               LeSVecI8x16,
                               LeUVecI8x16,
                               GeSVecI8x16,
                               GeUVecI8x16,
                               EqVecI16x8,
                               NeVecI16x8,
                               LtSVecI16x8,
                               LtUVecI16x8,
                               GtSVecI16x8,
                               GtUVecI16x8,
                               LeSVecI16x8,
                               LeUVecI16x8,
                               GeSVecI16x8,
                               GeUVecI16x8,
                               EqVecI32x4,
                               NeVecI32x4,
                               LtSVecI32x4,
                               LtUVecI32x4,
                               GtSVecI32x4,
                               GtUVecI32x4,
                               LeSVecI32x4,
                               LeUVecI32x4,
                               GeSVecI32x4,
                               GeUVecI32x4,
                               EqVecF32x4,
                               NeVecF32x4,
                               LtVecF32x4,
                               GtVecF32x4,
                               LeVecF32x4,
                               GeVecF32x4,
                               EqVecF64x2,
                               NeVecF64x2,
                               LtVecF64x2,
                               GtVecF64x2,
                               LeVecF64x2,
                               GeVecF64x2,
                               AndVec128,
                               OrVec128,
                               XorVec128,
                               AndNotVec128,
                               AddVecI8x16,
                               AddSatSVecI8x16,
                               AddSatUVecI8x16,
                               SubVecI8x16,
                               SubSatSVecI8x16,
                               SubSatUVecI8x16,
                               MinSVecI8x16,
                               MinUVecI8x16,
                               MaxSVecI8x16,
                               MaxUVecI8x16,
                               // TODO: avgr_u
                               // TODO: q15mulr_sat_s
                               // TODO: extmul
                               AddVecI16x8,
                               AddSatSVecI16x8,
                               AddSatUVecI16x8,
                               SubVecI16x8,
                               SubSatSVecI16x8,
                               SubSatUVecI16x8,
                               MulVecI16x8,
                               MinSVecI16x8,
                               MinUVecI16x8,
                               MaxSVecI16x8,
                               MaxUVecI16x8,
                               AddVecI32x4,
                               SubVecI32x4,
                               MulVecI32x4,
                               MinSVecI32x4,
                               MinUVecI32x4,
                               MaxSVecI32x4,
                               MaxUVecI32x4,
                               DotSVecI16x8ToVecI32x4,
                               AddVecI64x2,
                               SubVecI64x2,
                               AddVecF32x4,
                               SubVecF32x4,
                               MulVecF32x4,
                               DivVecF32x4,
                               MinVecF32x4,
                               MaxVecF32x4,
                               AddVecF64x2,
                               SubVecF64x2,
                               MulVecF64x2,
                               DivVecF64x2,
                               MinVecF64x2,
                               MaxVecF64x2,
                               NarrowSVecI16x8ToVecI8x16,
                               NarrowUVecI16x8ToVecI8x16,
                               NarrowSVecI32x4ToVecI16x8,
                               NarrowUVecI32x4ToVecI16x8,
                               SwizzleVecI8x16),
                          make(Type::v128),
                          make(Type::v128)});
    }
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("invalid type");
}

Expression* TranslateToFuzzReader::buildSelect(const ThreeArgs& args,
                                               Type type) {
  return builder.makeSelect(args.a, args.b, args.c, type);
}

Expression* TranslateToFuzzReader::makeSelect(Type type) {
  Type subType1 = getSubType(type);
  Type subType2 = getSubType(type);
  return buildSelect({make(Type::i32), make(subType1), make(subType2)}, type);
}

Expression* TranslateToFuzzReader::makeSwitch(Type type) {
  assert(type == Type::unreachable);
  if (funcContext->breakableStack.empty()) {
    return make(type);
  }
  // we need to find proper targets to break to; try a bunch
  int tries = TRIES;
  std::vector<Name> names;
  Type valueType = Type::unreachable;
  while (tries-- > 0) {
    auto* target = pick(funcContext->breakableStack);
    auto name = getTargetName(target);
    auto currValueType = getTargetType(target);
    if (names.empty()) {
      valueType = currValueType;
    } else {
      if (valueType != currValueType) {
        continue; // all values must be the same
      }
    }
    names.push_back(name);
  }
  if (names.size() < 2) {
    // we failed to find enough
    return make(type);
  }
  auto default_ = names.back();
  names.pop_back();
  auto temp1 = make(Type::i32),
       temp2 = valueType.isConcrete() ? make(valueType) : nullptr;
  return builder.makeSwitch(names, default_, temp1, temp2);
}

Expression* TranslateToFuzzReader::makeDrop(Type type) {
  return builder.makeDrop(
    make(type == Type::unreachable ? type : getConcreteType()));
}

Expression* TranslateToFuzzReader::makeReturn(Type type) {
  return builder.makeReturn(funcContext->func->getResults().isConcrete()
                              ? make(funcContext->func->getResults())
                              : nullptr);
}

Expression* TranslateToFuzzReader::makeNop(Type type) {
  assert(type == Type::none);
  return builder.makeNop();
}

Expression* TranslateToFuzzReader::makeUnreachable(Type type) {
  assert(type == Type::unreachable);
  return builder.makeUnreachable();
}

Expression* TranslateToFuzzReader::makeAtomic(Type type) {
  assert(wasm.features.hasAtomics());
  if (!allowMemory) {
    return makeTrivial(type);
  }
  wasm.memories[0]->shared = true;
  if (type == Type::none) {
    return builder.makeAtomicFence();
  }
  if (type == Type::i32 && oneIn(2)) {
    if (ATOMIC_WAITS && oneIn(2)) {
      auto* ptr = makePointer();
      auto expectedType = pick(Type::i32, Type::i64);
      auto* expected = make(expectedType);
      auto* timeout = make(Type::i64);
      return builder.makeAtomicWait(ptr,
                                    expected,
                                    timeout,
                                    expectedType,
                                    logify(get()),
                                    wasm.memories[0]->name);
    } else {
      auto* ptr = makePointer();
      auto* count = make(Type::i32);
      return builder.makeAtomicNotify(
        ptr, count, logify(get()), wasm.memories[0]->name);
    }
  }
  Index bytes;
  switch (type.getBasic()) {
    case Type::i32: {
      switch (upTo(3)) {
        case 0:
          bytes = 1;
          break;
        case 1:
          bytes = pick(1, 2);
          break;
        case 2:
          bytes = pick(1, 2, 4);
          break;
        default:
          WASM_UNREACHABLE("invalide value");
      }
      break;
    }
    case Type::i64: {
      switch (upTo(4)) {
        case 0:
          bytes = 1;
          break;
        case 1:
          bytes = pick(1, 2);
          break;
        case 2:
          bytes = pick(1, 2, 4);
          break;
        case 3:
          bytes = pick(1, 2, 4, 8);
          break;
        default:
          WASM_UNREACHABLE("invalide value");
      }
      break;
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
  auto offset = logify(get());
  auto* ptr = makePointer();
  if (oneIn(2)) {
    auto* value = make(type);
    return builder.makeAtomicRMW(
      pick(RMWAdd, RMWSub, RMWAnd, RMWOr, RMWXor, RMWXchg),
      bytes,
      offset,
      ptr,
      value,
      type,
      wasm.memories[0]->name);
  } else {
    auto* expected = make(type);
    auto* replacement = make(type);
    return builder.makeAtomicCmpxchg(
      bytes, offset, ptr, expected, replacement, type, wasm.memories[0]->name);
  }
}

Expression* TranslateToFuzzReader::makeSIMD(Type type) {
  assert(wasm.features.hasSIMD());
  if (type.isRef()) {
    return makeTrivial(type);
  }
  if (type != Type::v128) {
    return makeSIMDExtract(type);
  }
  // TODO: Add SIMDLoadStoreLane once it is generally available
  switch (upTo(7)) {
    case 0:
      return makeUnary(Type::v128);
    case 1:
      return makeBinary(Type::v128);
    case 2:
      return makeSIMDReplace();
    case 3:
      return makeSIMDShuffle();
    case 4:
      return makeSIMDTernary();
    case 5:
      return makeSIMDShift();
    case 6:
      return makeSIMDLoad();
  }
  WASM_UNREACHABLE("invalid value");
}

Expression* TranslateToFuzzReader::makeSIMDExtract(Type type) {
  auto op = static_cast<SIMDExtractOp>(0);
  switch (type.getBasic()) {
    case Type::i32:
      op = pick(ExtractLaneSVecI8x16,
                ExtractLaneUVecI8x16,
                ExtractLaneSVecI16x8,
                ExtractLaneUVecI16x8,
                ExtractLaneVecI32x4);
      break;
    case Type::i64:
      op = ExtractLaneVecI64x2;
      break;
    case Type::f32:
      op = ExtractLaneVecF32x4;
      break;
    case Type::f64:
      op = ExtractLaneVecF64x2;
      break;
    case Type::v128:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  Expression* vec = make(Type::v128);
  uint8_t index = 0;
  switch (op) {
    case ExtractLaneSVecI8x16:
    case ExtractLaneUVecI8x16:
      index = upTo(16);
      break;
    case ExtractLaneSVecI16x8:
    case ExtractLaneUVecI16x8:
      index = upTo(8);
      break;
    case ExtractLaneVecI32x4:
    case ExtractLaneVecF32x4:
      index = upTo(4);
      break;
    case ExtractLaneVecI64x2:
    case ExtractLaneVecF64x2:
      index = upTo(2);
      break;
  }
  return builder.makeSIMDExtract(op, vec, index);
}

Expression* TranslateToFuzzReader::makeSIMDReplace() {
  SIMDReplaceOp op = pick(ReplaceLaneVecI8x16,
                          ReplaceLaneVecI16x8,
                          ReplaceLaneVecI32x4,
                          ReplaceLaneVecI64x2,
                          ReplaceLaneVecF32x4,
                          ReplaceLaneVecF64x2);
  Expression* vec = make(Type::v128);
  uint8_t index;
  Type lane_t;
  switch (op) {
    case ReplaceLaneVecI8x16:
      index = upTo(16);
      lane_t = Type::i32;
      break;
    case ReplaceLaneVecI16x8:
      index = upTo(8);
      lane_t = Type::i32;
      break;
    case ReplaceLaneVecI32x4:
      index = upTo(4);
      lane_t = Type::i32;
      break;
    case ReplaceLaneVecI64x2:
      index = upTo(2);
      lane_t = Type::i64;
      break;
    case ReplaceLaneVecF32x4:
      index = upTo(4);
      lane_t = Type::f32;
      break;
    case ReplaceLaneVecF64x2:
      index = upTo(2);
      lane_t = Type::f64;
      break;
    default:
      WASM_UNREACHABLE("unexpected op");
  }
  Expression* value = make(lane_t);
  return builder.makeSIMDReplace(op, vec, index, value);
}

Expression* TranslateToFuzzReader::makeSIMDShuffle() {
  Expression* left = make(Type::v128);
  Expression* right = make(Type::v128);
  std::array<uint8_t, 16> mask;
  for (size_t i = 0; i < 16; ++i) {
    mask[i] = upTo(32);
  }
  return builder.makeSIMDShuffle(left, right, mask);
}

Expression* TranslateToFuzzReader::makeSIMDTernary() {
  // TODO: Enable qfma/qfms once it is implemented in V8 and the interpreter
  // SIMDTernaryOp op = pick(Bitselect,
  //                         QFMAF32x4,
  //                         QFMSF32x4,
  //                         QFMAF64x2,
  //                         QFMSF64x2);
  SIMDTernaryOp op = Bitselect;
  Expression* a = make(Type::v128);
  Expression* b = make(Type::v128);
  Expression* c = make(Type::v128);
  return builder.makeSIMDTernary(op, a, b, c);
}

Expression* TranslateToFuzzReader::makeSIMDShift() {
  SIMDShiftOp op = pick(ShlVecI8x16,
                        ShrSVecI8x16,
                        ShrUVecI8x16,
                        ShlVecI16x8,
                        ShrSVecI16x8,
                        ShrUVecI16x8,
                        ShlVecI32x4,
                        ShrSVecI32x4,
                        ShrUVecI32x4,
                        ShlVecI64x2,
                        ShrSVecI64x2,
                        ShrUVecI64x2);
  Expression* vec = make(Type::v128);
  Expression* shift = make(Type::i32);
  return builder.makeSIMDShift(op, vec, shift);
}

Expression* TranslateToFuzzReader::makeSIMDLoad() {
  // TODO: add Load{32,64}Zero if merged to proposal
  SIMDLoadOp op = pick(Load8SplatVec128,
                       Load16SplatVec128,
                       Load32SplatVec128,
                       Load64SplatVec128,
                       Load8x8SVec128,
                       Load8x8UVec128,
                       Load16x4SVec128,
                       Load16x4UVec128,
                       Load32x2SVec128,
                       Load32x2UVec128);
  Address offset = logify(get());
  Address align;
  switch (op) {
    case Load8SplatVec128:
      align = 1;
      break;
    case Load16SplatVec128:
      align = pick(1, 2);
      break;
    case Load32SplatVec128:
      align = pick(1, 2, 4);
      break;
    case Load64SplatVec128:
    case Load8x8SVec128:
    case Load8x8UVec128:
    case Load16x4SVec128:
    case Load16x4UVec128:
    case Load32x2SVec128:
    case Load32x2UVec128:
      align = pick(1, 2, 4, 8);
      break;
    case Load32ZeroVec128:
    case Load64ZeroVec128:
      WASM_UNREACHABLE("Unexpected SIMD loads");
  }
  Expression* ptr = makePointer();
  return builder.makeSIMDLoad(op, offset, align, ptr, wasm.memories[0]->name);
}

Expression* TranslateToFuzzReader::makeBulkMemory(Type type) {
  if (!allowMemory) {
    return makeTrivial(type);
  }
  assert(wasm.features.hasBulkMemory());
  assert(type == Type::none);
  switch (upTo(4)) {
    case 0:
      return makeMemoryInit();
    case 1:
      return makeDataDrop();
    case 2:
      return makeMemoryCopy();
    case 3:
      return makeMemoryFill();
  }
  WASM_UNREACHABLE("invalid value");
}

Expression* TranslateToFuzzReader::makeRefIsNull(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes());
  return builder.makeRefIsNull(make(getReferenceType()));
}

Expression* TranslateToFuzzReader::makeRefEq(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  auto* left = make(getEqReferenceType());
  auto* right = make(getEqReferenceType());
  return builder.makeRefEq(left, right);
}

Expression* TranslateToFuzzReader::makeRefTest(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  // The case of the reference and the cast type having a connection is useful,
  // so give a decent chance for one to be a subtype of the other.
  Type refType, castType;
  switch (upTo(3)) {
    case 0:
      // Totally random.
      refType = getReferenceType();
      castType = getReferenceType();
      // They must share a bottom type in order to validate.
      if (refType.getHeapType().getBottom() ==
          castType.getHeapType().getBottom()) {
        break;
      }
      // Otherwise, fall through and generate things in a way that is
      // guaranteed to validate.
      [[fallthrough]];
    case 1:
      // Cast is a subtype of ref.
      refType = getReferenceType();
      castType = getSubType(refType);
      break;
    case 2:
      // Ref is a subtype of cast.
      castType = getReferenceType();
      refType = getSubType(castType);
      break;
    default:
      // This unreachable avoids a warning on refType being possibly undefined.
      WASM_UNREACHABLE("bad case");
  }
  return builder.makeRefTest(make(refType), castType);
}

Expression* TranslateToFuzzReader::makeRefCast(Type type) {
  assert(type.isRef());
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  // As with RefTest, use possibly related types. Unlike there, we are given the
  // output type, which is the cast type, so just generate the ref's type.
  Type refType;
  switch (upTo(3)) {
    case 0:
      // Totally random.
      refType = getReferenceType();
      // They must share a bottom type in order to validate.
      if (refType.getHeapType().getBottom() == type.getHeapType().getBottom()) {
        break;
      }
      // Otherwise, fall through and generate things in a way that is
      // guaranteed to validate.
      [[fallthrough]];
    case 1: {
      // Cast is a subtype of ref. We can't modify |type|, so find a supertype
      // for the ref.
      refType = getSuperType(type);
      break;
    }
    case 2:
      // Ref is a subtype of cast.
      refType = getSubType(type);
      break;
    default:
      // This unreachable avoids a warning on refType being possibly undefined.
      WASM_UNREACHABLE("bad case");
  }
  return builder.makeRefCast(make(refType), type);
}

Expression* TranslateToFuzzReader::makeStructGet(Type type) {
  auto& structFields = typeStructFields[type];
  assert(!structFields.empty());
  auto [structType, fieldIndex] = pick(structFields);
  auto* ref = makeTrappingRefUse(structType);
  // TODO: fuzz signed and unsigned
  return builder.makeStructGet(fieldIndex, ref, type);
}

Expression* TranslateToFuzzReader::makeStructSet(Type type) {
  assert(type == Type::none);
  if (mutableStructFields.empty()) {
    return makeTrivial(type);
  }
  auto [structType, fieldIndex] = pick(mutableStructFields);
  auto fieldType = structType.getStruct().fields[fieldIndex].type;
  auto* ref = makeTrappingRefUse(structType);
  auto* value = make(fieldType);
  return builder.makeStructSet(fieldIndex, ref, value);
}

// Make a bounds check for an array operation, given a ref + index. An optional
// additional length parameter can be provided, which is added to the index if
// so (that is useful for something like array.fill, which operations on not a
// single item like array.set, but a range).
static auto makeArrayBoundsCheck(Expression* ref,
                                 Expression* index,
                                 Function* func,
                                 Builder& builder,
                                 Expression* length = nullptr) {
  auto tempRef = builder.addVar(func, ref->type);
  auto tempIndex = builder.addVar(func, index->type);
  auto* teeRef = builder.makeLocalTee(tempRef, ref, ref->type);
  auto* teeIndex = builder.makeLocalTee(tempIndex, index, index->type);
  auto* getSize = builder.makeArrayLen(teeRef);

  Expression* effectiveIndex = teeIndex;

  Expression* getLength = nullptr;
  if (length) {
    // Store the length so we can reuse it.
    auto tempLength = builder.addVar(func, length->type);
    auto* teeLength = builder.makeLocalTee(tempLength, length, length->type);
    // The effective index will now include the length.
    effectiveIndex = builder.makeBinary(AddInt32, effectiveIndex, teeLength);
    getLength = builder.makeLocalGet(tempLength, length->type);
  }

  struct BoundsCheck {
    // A condition that checks if the index is in bounds.
    Expression* condition;
    // An additional use of the reference (we stored the reference in a local,
    // so this reads from that local).
    Expression* getRef;
    // An addition use of the index (as with the ref, it reads from a local).
    Expression* getIndex;
    // An addition use of the length, if it was provided.
    Expression* getLength = nullptr;
  } result = {builder.makeBinary(LtUInt32, effectiveIndex, getSize),
              builder.makeLocalGet(tempRef, ref->type),
              builder.makeLocalGet(tempIndex, index->type),
              getLength};
  return result;
}

Expression* TranslateToFuzzReader::makeArrayGet(Type type) {
  auto& arrays = typeArrays[type];
  assert(!arrays.empty());
  auto arrayType = pick(arrays);
  auto* ref = makeTrappingRefUse(arrayType);
  auto* index = make(Type::i32);
  // Only rarely emit a plain get which might trap. See related logic in
  // ::makePointer().
  if (allowOOB && oneIn(10)) {
    // TODO: fuzz signed and unsigned, and also below
    return builder.makeArrayGet(ref, index, type);
  }
  // To avoid a trap, check the length dynamically using this pattern:
  //
  //   index < array.len ? array[index] : ..some fallback value..
  //
  auto check = makeArrayBoundsCheck(ref, index, funcContext->func, builder);
  auto* get = builder.makeArrayGet(check.getRef, check.getIndex, type);
  auto* fallback = makeTrivial(type);
  return builder.makeIf(check.condition, get, fallback);
}

Expression* TranslateToFuzzReader::makeArraySet(Type type) {
  assert(type == Type::none);
  if (mutableArrays.empty()) {
    return makeTrivial(type);
  }
  auto arrayType = pick(mutableArrays);
  auto elementType = arrayType.getArray().element.type;
  auto* index = make(Type::i32);
  auto* ref = makeTrappingRefUse(arrayType);
  auto* value = make(elementType);
  // Only rarely emit a plain get which might trap. See related logic in
  // ::makePointer().
  if (allowOOB && oneIn(10)) {
    // TODO: fuzz signed and unsigned, and also below
    return builder.makeArraySet(ref, index, value);
  }
  // To avoid a trap, check the length dynamically using this pattern:
  //
  //   if (index < array.len) array[index] = value;
  //
  auto check = makeArrayBoundsCheck(ref, index, funcContext->func, builder);
  auto* set = builder.makeArraySet(check.getRef, check.getIndex, value);
  return builder.makeIf(check.condition, set);
}

Expression* TranslateToFuzzReader::makeArrayBulkMemoryOp(Type type) {
  assert(type == Type::none);
  if (mutableArrays.empty()) {
    return makeTrivial(type);
  }
  auto arrayType = pick(mutableArrays);
  auto element = arrayType.getArray().element;
  auto* index = make(Type::i32);
  auto* ref = makeTrappingRefUse(arrayType);
  if (oneIn(2)) {
    // ArrayFill
    auto* value = make(element.type);
    auto* length = make(Type::i32);
    // Only rarely emit a plain get which might trap. See related logic in
    // ::makePointer().
    if (allowOOB && oneIn(10)) {
      // TODO: fuzz signed and unsigned, and also below
      return builder.makeArrayFill(ref, index, value, length);
    }
    auto check =
      makeArrayBoundsCheck(ref, index, funcContext->func, builder, length);
    auto* fill = builder.makeArrayFill(
      check.getRef, check.getIndex, value, check.getLength);
    return builder.makeIf(check.condition, fill);
  } else {
    // ArrayCopy. Here we must pick a source array whose element type is a
    // subtype of the destination.
    auto srcArrayType = pick(mutableArrays);
    auto srcElement = srcArrayType.getArray().element;
    if (!Type::isSubType(srcElement.type, element.type) ||
        element.packedType != srcElement.packedType) {
      // TODO: A matrix of which arrays are subtypes of others. For now, if we
      // didn't get what we want randomly, just copy from the same type to
      // itself.
      srcArrayType = arrayType;
      srcElement = element;
    }
    auto* srcIndex = make(Type::i32);
    auto* srcRef = makeTrappingRefUse(srcArrayType);
    auto* length = make(Type::i32);
    if (allowOOB && oneIn(10)) {
      // TODO: fuzz signed and unsigned, and also below
      return builder.makeArrayCopy(ref, index, srcRef, srcIndex, length);
    }
    auto check =
      makeArrayBoundsCheck(ref, index, funcContext->func, builder, length);
    auto srcCheck = makeArrayBoundsCheck(
      srcRef, srcIndex, funcContext->func, builder, check.getLength);
    auto* copy = builder.makeArrayCopy(check.getRef,
                                       check.getIndex,
                                       srcCheck.getRef,
                                       srcCheck.getIndex,
                                       srcCheck.getLength);
    return builder.makeIf(check.condition,
                          builder.makeIf(srcCheck.condition, copy));
  }
}

Expression* TranslateToFuzzReader::makeI31Get(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  auto* i31 = makeTrappingRefUse(HeapType::i31);
  return builder.makeI31Get(i31, bool(oneIn(2)));
}

Expression* TranslateToFuzzReader::makeThrow(Type type) {
  assert(type == Type::unreachable);
  if (wasm.tags.empty()) {
    addTag();
  }
  auto* tag = pick(wasm.tags).get();
  auto tagType = tag->sig.params;
  std::vector<Expression*> operands;
  for (auto t : tagType) {
    operands.push_back(make(t));
  }
  return builder.makeThrow(tag, operands);
}

Expression* TranslateToFuzzReader::makeMemoryInit() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Index segIdx = upTo(wasm.dataSegments.size());
  Name segment = wasm.dataSegments[segIdx]->name;
  size_t totalSize = wasm.dataSegments[segIdx]->data.size();
  size_t offsetVal = upTo(totalSize);
  size_t sizeVal = upTo(totalSize - offsetVal);
  Expression* dest = makePointer();
  Expression* offset = builder.makeConst(int32_t(offsetVal));
  Expression* size = builder.makeConst(int32_t(sizeVal));
  return builder.makeMemoryInit(
    segment, dest, offset, size, wasm.memories[0]->name);
}

Expression* TranslateToFuzzReader::makeDataDrop() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Index segIdx = upTo(wasm.dataSegments.size());
  Name segment = wasm.dataSegments[segIdx]->name;
  return builder.makeDataDrop(segment);
}

Expression* TranslateToFuzzReader::makeMemoryCopy() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Expression* dest = makePointer();
  Expression* source = makePointer();
  Expression* size = make(wasm.memories[0]->indexType);
  return builder.makeMemoryCopy(
    dest, source, size, wasm.memories[0]->name, wasm.memories[0]->name);
}

Expression* TranslateToFuzzReader::makeMemoryFill() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Expression* dest = makePointer();
  Expression* value = make(Type::i32);
  Expression* size = make(wasm.memories[0]->indexType);
  return builder.makeMemoryFill(dest, value, size, wasm.memories[0]->name);
}

Type TranslateToFuzzReader::getSingleConcreteType() {
  if (wasm.features.hasReferenceTypes() && !interestingHeapTypes.empty() &&
      oneIn(3)) {
    auto heapType = pick(interestingHeapTypes);
    auto nullability = getNullability();
    return Type(heapType, nullability);
  }
  // Skip (ref func), (ref extern), and (ref i31) for now
  // because there is no way to create them in globals. TODO.
  using WeightedOption = FeatureOptions<Type>::WeightedOption;
  return pick(FeatureOptions<Type>()
                .add(FeatureSet::MVP,
                     WeightedOption{Type::i32, VeryImportant},
                     WeightedOption{Type::i64, VeryImportant},
                     WeightedOption{Type::f32, VeryImportant},
                     WeightedOption{Type::f64, VeryImportant})
                .add(FeatureSet::SIMD, WeightedOption{Type::v128, Important})
                .add(FeatureSet::ReferenceTypes,
                     Type(HeapType::func, Nullable),
                     Type(HeapType::ext, Nullable))
                .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                     // Type(HeapType::func, NonNullable),
                     // Type(HeapType::ext, NonNullable),
                     Type(HeapType::any, Nullable),
                     // Type(HeapType::any, NonNullable),
                     Type(HeapType::eq, Nullable),
                     Type(HeapType::eq, NonNullable),
                     Type(HeapType::i31, Nullable),
                     // Type(HeapType::i31, NonNullable),
                     Type(HeapType::struct_, Nullable),
                     Type(HeapType::struct_, NonNullable),
                     Type(HeapType::array, Nullable),
                     Type(HeapType::array, NonNullable)));
}

Type TranslateToFuzzReader::getReferenceType() {
  if (wasm.features.hasReferenceTypes() && !interestingHeapTypes.empty() &&
      oneIn(2)) {
    auto heapType = pick(interestingHeapTypes);
    auto nullability = getNullability();
    return Type(heapType, nullability);
  }
  return pick(FeatureOptions<Type>()
                // TODO: Add externref here.
                .add(FeatureSet::ReferenceTypes, Type(HeapType::func, Nullable))
                .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                     Type(HeapType::func, NonNullable),
                     Type(HeapType::any, NonNullable),
                     Type(HeapType::eq, Nullable),
                     Type(HeapType::eq, NonNullable),
                     Type(HeapType::i31, Nullable),
                     Type(HeapType::i31, NonNullable),
                     Type(HeapType::struct_, Nullable),
                     Type(HeapType::struct_, NonNullable),
                     Type(HeapType::array, Nullable),
                     Type(HeapType::array, NonNullable)));
}

Type TranslateToFuzzReader::getEqReferenceType() {
  if (oneIn(2) && !interestingHeapTypes.empty()) {
    // Try to find an interesting eq-compatible type.
    auto heapType = pick(interestingHeapTypes);
    if (HeapType::isSubType(heapType, HeapType::eq)) {
      auto nullability = getNullability();
      return Type(heapType, nullability);
    }
    // Otherwise continue below.
  }
  return pick(
    FeatureOptions<Type>().add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                               Type(HeapType::eq, Nullable),
                               Type(HeapType::eq, NonNullable),
                               Type(HeapType::i31, Nullable),
                               Type(HeapType::i31, NonNullable),
                               Type(HeapType::struct_, Nullable),
                               Type(HeapType::struct_, NonNullable),
                               Type(HeapType::array, Nullable),
                               Type(HeapType::array, NonNullable)));
}

Type TranslateToFuzzReader::getMVPType() {
  return pick(Type::i32, Type::i64, Type::f32, Type::f64);
}

Type TranslateToFuzzReader::getTupleType() {
  std::vector<Type> elements;
  size_t maxElements = 2 + upTo(MAX_TUPLE_SIZE - 1);
  for (size_t i = 0; i < maxElements; ++i) {
    auto type = getSingleConcreteType();
    // Don't add a non-defaultable type into a tuple, as currently we can't
    // spill them into locals (that would require a "let").
    if (type.isDefaultable()) {
      elements.push_back(type);
    }
  }
  while (elements.size() < 2) {
    elements.push_back(getMVPType());
  }
  return Type(elements);
}

Type TranslateToFuzzReader::getConcreteType() {
  if (wasm.features.hasMultivalue() && oneIn(5)) {
    return getTupleType();
  } else {
    return getSingleConcreteType();
  }
}

Type TranslateToFuzzReader::getControlFlowType() {
  if (oneIn(10)) {
    return Type::none;
  } else {
    return getConcreteType();
  }
}

Type TranslateToFuzzReader::getStorableType() {
  return pick(
    FeatureOptions<Type>()
      .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
      .add(FeatureSet::SIMD, Type::v128));
}

Type TranslateToFuzzReader::getLoggableType() { return pick(loggableTypes); }

bool TranslateToFuzzReader::isLoggableType(Type type) {
  return std::find(loggableTypes.begin(), loggableTypes.end(), type) !=
         loggableTypes.end();
}

Nullability TranslateToFuzzReader::getNullability() {
  // Without wasm GC, avoid non-nullable types as we cannot create any values
  // of such types. For example, reference types adds eqref, but there is no
  // way to create such a value, only to receive it from the outside, while GC
  // adds i31/struct/array creation. Without GC, we will likely need to create a
  // null of this type (unless we are lucky enough to have a non-null value
  // arriving from an import), so avoid a non-null type if possible.
  if (wasm.features.hasGC() && oneIn(2)) {
    return NonNullable;
  }
  return Nullable;
}

Nullability TranslateToFuzzReader::getSubType(Nullability nullability) {
  if (nullability == NonNullable) {
    return NonNullable;
  }
  return getNullability();
}

HeapType TranslateToFuzzReader::getSubType(HeapType type) {
  if (oneIn(3)) {
    return type;
  }
  if (type.isBasic() && oneIn(2)) {
    switch (type.getBasic()) {
      case HeapType::func:
        // TODO: Typed function references.
        return pick(FeatureOptions<HeapType>()
                      .add(FeatureSet::ReferenceTypes, HeapType::func)
                      .add(FeatureSet::GC, HeapType::nofunc));
      case HeapType::ext:
        return pick(FeatureOptions<HeapType>()
                      .add(FeatureSet::ReferenceTypes, HeapType::ext)
                      .add(FeatureSet::GC, HeapType::noext));
      case HeapType::any:
        assert(wasm.features.hasReferenceTypes());
        assert(wasm.features.hasGC());
        return pick(HeapType::any,
                    HeapType::eq,
                    HeapType::i31,
                    HeapType::struct_,
                    HeapType::array,
                    HeapType::none);
      case HeapType::eq:
        assert(wasm.features.hasReferenceTypes());
        assert(wasm.features.hasGC());
        return pick(HeapType::eq,
                    HeapType::i31,
                    HeapType::struct_,
                    HeapType::array,
                    HeapType::none);
      case HeapType::i31:
        return pick(HeapType::i31, HeapType::none);
      case HeapType::struct_:
        return pick(HeapType::struct_, HeapType::none);
      case HeapType::array:
        return pick(HeapType::array, HeapType::none);
      case HeapType::exn:
        return HeapType::exn;
      case HeapType::string:
        return HeapType::string;
      case HeapType::stringview_wtf8:
      case HeapType::stringview_wtf16:
      case HeapType::stringview_iter:
        WASM_UNREACHABLE("TODO: fuzz strings");
      case HeapType::none:
      case HeapType::noext:
      case HeapType::nofunc:
      case HeapType::noexn:
        break;
    }
  }
  // Look for an interesting subtype.
  auto iter = interestingHeapSubTypes.find(type);
  if (iter != interestingHeapSubTypes.end()) {
    auto& subTypes = iter->second;
    if (!subTypes.empty()) {
      return pick(subTypes);
    }
  }
  // Failure to do anything interesting, return the type.
  return type;
}

Type TranslateToFuzzReader::getSubType(Type type) {
  if (type.isTuple()) {
    std::vector<Type> types;
    for (const auto& t : type) {
      types.push_back(getSubType(t));
    }
    return Type(types);
  } else if (type.isRef()) {
    auto heapType = getSubType(type.getHeapType());
    auto nullability = getSubType(type.getNullability());
    auto subType = Type(heapType, nullability);
    // We don't want to emit lots of uninhabitable types like (ref none), so
    // avoid them with high probability. Specifically, if the original type was
    // inhabitable then return that; avoid adding more uninhabitability.
    if (GCTypeUtils::isUninhabitable(subType) &&
        !GCTypeUtils::isUninhabitable(type) && !oneIn(20)) {
      return type;
    }
    return subType;
  } else {
    // This is an MVP type without subtypes.
    assert(type.isBasic());
    return type;
  }
}

Nullability TranslateToFuzzReader::getSuperType(Nullability nullability) {
  if (nullability == Nullable) {
    return Nullable;
  }
  return getNullability();
}

HeapType TranslateToFuzzReader::getSuperType(HeapType type) {
  // TODO cache these?
  std::vector<HeapType> supers;
  while (1) {
    supers.push_back(type);
    if (auto super = type.getDeclaredSuperType()) {
      type = *super;
    } else {
      break;
    }
  }
  return pick(supers);
}

Type TranslateToFuzzReader::getSuperType(Type type) {
  auto heapType = getSuperType(type.getHeapType());
  auto nullability = getSuperType(type.getNullability());
  auto superType = Type(heapType, nullability);
  // As with getSubType, we want to avoid returning an uninhabitable type where
  // possible. Here all we can do is flip the super's nullability to nullable.
  if (GCTypeUtils::isUninhabitable(superType)) {
    superType = Type(heapType, Nullable);
  }
  return superType;
}

Name TranslateToFuzzReader::getTargetName(Expression* target) {
  if (auto* block = target->dynCast<Block>()) {
    return block->name;
  } else if (auto* loop = target->dynCast<Loop>()) {
    return loop->name;
  }
  WASM_UNREACHABLE("unexpected expr type");
}

Type TranslateToFuzzReader::getTargetType(Expression* target) {
  if (auto* block = target->dynCast<Block>()) {
    return block->type;
  } else if (target->is<Loop>()) {
    return Type::none;
  }
  WASM_UNREACHABLE("unexpected expr type");
}

} // namespace wasm
