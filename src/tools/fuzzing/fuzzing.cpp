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
  // - funcref cannot be logged because referenced functions can be inlined or
  // removed during optimization
  // - there's no point in logging externref or anyref because these are opaque
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
  }
  finalizeTable();
}

void TranslateToFuzzReader::setupMemory() {
  // Add memory itself
  MemoryUtils::ensureExists(wasm.memory);
  if (wasm.features.hasBulkMemory()) {
    size_t memCovered = 0;
    // need at least one segment for memory.inits
    size_t numSegments = upTo(8) + 1;
    for (size_t i = 0; i < numSegments; i++) {
      Memory::Segment segment;
      segment.isPassive = bool(upTo(2));
      size_t segSize = upTo(USABLE_MEMORY * 2);
      segment.data.resize(segSize);
      for (size_t j = 0; j < segSize; j++) {
        segment.data[j] = upTo(512);
      }
      if (!segment.isPassive) {
        segment.offset = builder.makeConst(int32_t(memCovered));
        memCovered += segSize;
      }
      wasm.memory.segments.push_back(segment);
    }
  } else {
    // init some data
    wasm.memory.segments.emplace_back(builder.makeConst(int32_t(0)));
    auto num = upTo(USABLE_MEMORY * 2);
    for (size_t i = 0; i < num; i++) {
      auto value = upTo(512);
      wasm.memory.segments[0].data.push_back(value >= 256 ? 0 : (value & 0xff));
    }
  }
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
  auto zero = Literal::makeFromInt32(0, wasm.memory.indexType);
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
        builder.makeLoad(1, false, i, 1, builder.makeConst(zero), Type::i32))));
  }
  contents.push_back(builder.makeLocalGet(0, Type::i32));
  auto* body = builder.makeBlock(contents);
  auto* hasher = wasm.addFunction(builder.makeFunction(
    "hashMemory", Signature(Type::none, Type::i32), {Type::i32}, body));
  wasm.addExport(
    builder.makeExport(hasher->name, hasher->name, ExternalKind::Function));
  // Export memory so JS fuzzing can use it
  if (!wasm.getExportOrNull("memory")) {
    wasm.addExport(builder.makeExport("memory", "0", ExternalKind::Memory));
  }
}

// TODO(reference-types): allow the fuzzer to create multiple tables
void TranslateToFuzzReader::setupTables() {
  // Ensure a funcref element segment and table exist. Segments with more
  // specific function types may have a smaller chance of getting functions.
  Table* table = nullptr;
  auto iter =
    std::find_if(wasm.tables.begin(), wasm.tables.end(), [&](auto& table) {
      return table->type == Type::funcref;
    });
  if (iter != wasm.tables.end()) {
    table = iter->get();
  } else {
    auto tablePtr = builder.makeTable(
      Names::getValidTableName(wasm, "fuzzing_table"), Type::funcref, 0, 0);
    tablePtr->hasExplicitName = true;
    table = wasm.addTable(std::move(tablePtr));
  }
  funcrefTableName = table->name;
  bool hasFuncrefElemSegment =
    std::any_of(wasm.elementSegments.begin(),
                wasm.elementSegments.end(),
                [&](auto& segment) {
                  return segment->table.is() && segment->type == Type::funcref;
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
      // If the initialization referred to an imported global, it no longer
      // can point to the same global after we make it a non-imported global
      // (as wasm doesn't allow that - you can only use an imported one).
      if (global->init->is<GlobalGet>()) {
        global->init = makeConst(global->type);
      }
    }
  }
  for (size_t index = upTo(MAX_GLOBALS); index > 0; --index) {
    auto type = getConcreteType();
    auto global = builder.makeGlobal(Names::getValidGlobalName(wasm, "global$"),
                                     type,
                                     makeConst(type),
                                     Builder::Mutable);
    globalsByType[type].push_back(global->name);
    wasm.addGlobal(std::move(global));
  }
}

void TranslateToFuzzReader::setupTags() {
  Index num = upTo(3);
  for (size_t i = 0; i < num; i++) {
    auto tag = builder.makeTag(Names::getValidTagName(wasm, "tag$"),
                               Signature(getControlFlowType(), Type::none));
    wasm.addTag(std::move(tag));
  }
}

void TranslateToFuzzReader::finalizeMemory() {
  for (auto& segment : wasm.memory.segments) {
    Address maxOffset = segment.data.size();
    if (!segment.isPassive) {
      if (auto* offset = segment.offset->dynCast<GlobalGet>()) {
        // Using a non-imported global in a segment offset is not valid in
        // wasm. This can occur due to us making what used to be an imported
        // global, in initial contents, be not imported any more. To fix that,
        // replace such invalid things with a constant.
        // Note that it is still possible in theory to have imported globals
        // here, as we only do the above for initial contents. While the
        // fuzzer doesn't do so as of the time of this comment, do a check
        // for full generality, so that this code essentially does "if this
        // is invalid wasm, fix it up."
        if (!wasm.getGlobal(offset->name)->imported()) {
          // TODO: It would be better to avoid segment overlap so that
          //       MemoryPacking can run.
          segment.offset =
            builder.makeConst(Literal::makeFromInt32(0, Type::i32));
        }
      }
      if (auto* offset = segment.offset->dynCast<Const>()) {
        maxOffset = maxOffset + offset->value.getInteger();
      }
    }
    wasm.memory.initial = std::max(
      wasm.memory.initial,
      Address((maxOffset + Memory::kPageSize - 1) / Memory::kPageSize));
  }
  wasm.memory.initial = std::max(wasm.memory.initial, USABLE_MEMORY);
  // Avoid an unlimited memory size, which would make fuzzing very difficult
  // as different VMs will run out of system memory in different ways.
  if (wasm.memory.max == Memory::kUnlimitedSize) {
    wasm.memory.max = wasm.memory.initial;
  }
  if (wasm.memory.max <= wasm.memory.initial) {
    // To allow growth to work (which a testcase may assume), try to make the
    // maximum larger than the initial.
    // TODO: scan the wasm for grow instructions?
    wasm.memory.max =
      std::min(Address(wasm.memory.initial + 1), Address(Memory::kMaxSize32));
  }
  // Avoid an imported memory (which the fuzz harness would need to handle).
  wasm.memory.module = wasm.memory.base = Name();
}

void TranslateToFuzzReader::finalizeTable() {
  for (auto& table : wasm.tables) {
    ModuleUtils::iterTableSegments(
      wasm, table->name, [&](ElementSegment* segment) {
        // If the offset is a global that was imported (which is ok) but no
        // longer is (not ok) we need to change that.
        if (auto* offset = segment->offset->dynCast<GlobalGet>()) {
          if (!wasm.getGlobal(offset->name)->imported()) {
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

  Name exportName = "hangLimitInitializer";
  auto funcName = Names::getValidFunctionName(wasm, exportName);
  auto* func = new Function;
  func->name = funcName;
  func->type = Signature(Type::none, Type::none);
  func->body = builder.makeGlobalSet(HANG_LIMIT_GLOBAL,
                                     builder.makeConst(int32_t(HANG_LIMIT)));
  wasm.addFunction(func);

  if (wasm.getExportOrNull(exportName)) {
    // We must export our actual hang limit function - remove anything
    // previously existing.
    wasm.removeExport(exportName);
  }
  auto* export_ = new Export;
  export_->name = exportName;
  export_->value = func->name;
  export_->kind = ExternalKind::Function;
  wasm.addExport(export_);
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

TranslateToFuzzReader::FunctionCreationContext::~FunctionCreationContext() {
  if (HANG_LIMIT > 0) {
    parent.addHangLimitChecks(func);
  }
  assert(breakableStack.empty());
  assert(hangStack.empty());
  parent.funcContext = nullptr;
}

Expression* TranslateToFuzzReader::makeHangLimitCheck() {
  return builder.makeSequence(
    builder.makeIf(
      builder.makeUnary(UnaryOp::EqZInt32,
                        builder.makeGlobalGet(HANG_LIMIT_GLOBAL, Type::i32)),
      makeTrivial(Type::unreachable)),
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
  func->type = Signature(paramType, getControlFlowType());
  Index numVars = upToSquared(MAX_VARS);
  for (Index i = 0; i < numVars; i++) {
    auto type = getConcreteType();
    if (!type.isDefaultable()) {
      // We can't use a nondefaultable type as a var, as those must be
      // initialized to some default value.
      continue;
    }
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
    fixLabels(func);
  }
  // Add hang limit checks after all other operations on the function body.
  wasm.addFunction(func);
  // Export some functions, but not all (to allow inlining etc.). Try to export
  // at least one, though, to keep each testcase interesting. Only functions
  // with defaultable params can be exported because the trap fuzzer depends on
  // that (TODO: fix this).
  bool defaultableParams =
    std::all_of(paramType.begin(), paramType.end(), [](Type t) {
      return t.isDefaultable();
    });
  if (defaultableParams && (numAddedFunctions == 0 || oneIn(2)) &&
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
  FindAll<Loop> loops(func->body);
  for (auto* loop : loops.list) {
    loop->body =
      builder.makeSequence(makeHangLimitCheck(), loop->body, loop->type);
  }
  // recursion limit
  func->body =
    builder.makeSequence(makeHangLimitCheck(), func->body, func->getResults());
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
        exprsByType[curr->type].push_back(curr);
      }
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
  // the same type. (This is not always valid due to nesting of labels, but
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
        replaceCurrent(
          ExpressionManipulator::copy(parent.pick(candidates), wasm));
      }
    }
  };
  Modder modder(wasm, scanner, *this);
  modder.walk(func->body);
}

void TranslateToFuzzReader::mutate(Function* func) {
  // Don't always do this.
  if (oneIn(2)) {
    return;
  }
  struct Modder : public PostWalker<Modder, UnifiedExpressionVisitor<Modder>> {
    Module& wasm;
    TranslateToFuzzReader& parent;

    Modder(Module& wasm, TranslateToFuzzReader& parent)
      : wasm(wasm), parent(parent) {}

    void visitExpression(Expression* curr) {
      if (parent.oneIn(10) && parent.canBeArbitrarilyReplaced(curr)) {
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
        // nesting of labels, but we'll fix that up later.)
        replaceCurrent(parent.make(curr->type));
      }
    }
  };
  Modder modder(wasm, *this);
  modder.walk(func->body);
}

void TranslateToFuzzReader::fixLabels(Function* func) {
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

    bool replaceIfInvalid(Name target) {
      if (!hasBreakTarget(target)) {
        // There is no valid parent, replace with something trivially safe.
        replace();
        return true;
      }
      return false;
    }

    void replace() { replaceCurrent(parent.makeTrivial(getCurrent()->type)); }

    bool hasBreakTarget(Name name) {
      if (controlFlowStack.empty()) {
        return false;
      }
      Index i = controlFlowStack.size() - 1;
      while (1) {
        auto* curr = controlFlowStack[i];
        if (auto* block = curr->dynCast<Block>()) {
          if (name == block->name) {
            return true;
          }
        } else if (auto* loop = curr->dynCast<Loop>()) {
          if (name == loop->name) {
            return true;
          }
        } else {
          // an if or a try, ignorable
          assert(curr->is<If>() || curr->is<Try>());
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
      fixLabels(func);
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
  Name name = func->name.str + std::string("_invoker");
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
  auto subtype = getSubType(type);
  // When we should stop, emit something small (but not necessarily trivial).
  if (random.finished() || nesting >= 5 * NESTING_LIMIT || // hard limit
      (nesting >= NESTING_LIMIT && !oneIn(3))) {
    if (type.isConcrete()) {
      if (oneIn(2)) {
        return makeConst(subtype);
      } else {
        return makeLocalGet(subtype);
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
    ret = _makeConcrete(subtype);
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
      .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
           &Self::makeCallRef);
  }
  if (type.isSingle()) {
    options
      .add(FeatureSet::MVP,
           WeightedOption{&Self::makeUnary, Important},
           WeightedOption{&Self::makeBinary, Important},
           &Self::makeSelect)
      .add(FeatureSet::Multivalue, &Self::makeTupleExtract);
  }
  if (type.isSingle() && !type.isRef() && !type.isRtt()) {
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
                &Self::makeI31Get);
  }
  if (type.isTuple()) {
    options.add(FeatureSet::Multivalue, &Self::makeTupleMake);
  }
  if (type == Type::i31ref) {
    options.add(FeatureSet::ReferenceTypes | FeatureSet::GC, &Self::makeI31New);
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
    .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
         &Self::makeCallRef);
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
    .add(FeatureSet::TypedFunctionReferences | FeatureSet::ReferenceTypes,
         &Self::makeCallRef);
  return (this->*pick(options))(Type::unreachable);
}

Expression* TranslateToFuzzReader::makeTrivial(Type type) {
  if (type.isConcrete()) {
    if (oneIn(2)) {
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
  auto* ret =
    buildIf({condition, makeMaybeBlock(type), makeMaybeBlock(type)}, type);
  funcContext->hangStack.pop_back();
  return ret;
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
  if (locals.empty()) {
    return makeConst(type);
  }
  return builder.makeLocalGet(pick(locals), type);
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

bool TranslateToFuzzReader::isValidGlobal(Name name) {
  return name != HANG_LIMIT_GLOBAL;
}

Expression* TranslateToFuzzReader::makeGlobalGet(Type type) {
  auto it = globalsByType.find(type);
  if (it == globalsByType.end() || it->second.empty()) {
    return makeConst(type);
  }
  auto name = pick(it->second);
  if (isValidGlobal(name)) {
    return builder.makeGlobalGet(name, type);
  } else {
    return makeTrivial(type);
  }
}

Expression* TranslateToFuzzReader::makeGlobalSet(Type type) {
  assert(type == Type::none);
  type = getConcreteType();
  auto it = globalsByType.find(type);
  if (it == globalsByType.end() || it->second.empty()) {
    return makeTrivial(Type::none);
  }
  auto name = pick(it->second);
  if (isValidGlobal(name)) {
    return builder.makeGlobalSet(name, make(type));
  } else {
    return makeTrivial(Type::none);
  }
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
  auto* ret = make(wasm.memory.indexType);
  // with high probability, mask the pointer so it's in a reasonable
  // range. otherwise, most pointers are going to be out of range and
  // most memory ops will just trap
  if (!allowOOB || !oneIn(10)) {
    if (wasm.memory.is64()) {
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
          return builder.makeLoad(1, signed_, offset, 1, ptr, type);
        case 1:
          return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
        case 2:
          return builder.makeLoad(4, signed_, offset, pick(1, 2, 4), ptr, type);
      }
      WASM_UNREACHABLE("unexpected value");
    }
    case Type::i64: {
      bool signed_ = get() & 1;
      switch (upTo(4)) {
        case 0:
          return builder.makeLoad(1, signed_, offset, 1, ptr, type);
        case 1:
          return builder.makeLoad(2, signed_, offset, pick(1, 2), ptr, type);
        case 2:
          return builder.makeLoad(4, signed_, offset, pick(1, 2, 4), ptr, type);
        case 3:
          return builder.makeLoad(
            8, signed_, offset, pick(1, 2, 4, 8), ptr, type);
      }
      WASM_UNREACHABLE("unexpected value");
    }
    case Type::f32: {
      return builder.makeLoad(4, false, offset, pick(1, 2, 4), ptr, type);
    }
    case Type::f64: {
      return builder.makeLoad(8, false, offset, pick(1, 2, 4, 8), ptr, type);
    }
    case Type::v128: {
      if (!wasm.features.hasSIMD()) {
        return makeTrivial(type);
      }
      return builder.makeLoad(
        16, false, offset, pick(1, 2, 4, 8, 16), ptr, type);
    }
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  wasm.memory.shared = true;
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
          return builder.makeStore(1, offset, 1, ptr, value, type);
        case 1:
          return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
        case 2:
          return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::i64: {
      switch (upTo(4)) {
        case 0:
          return builder.makeStore(1, offset, 1, ptr, value, type);
        case 1:
          return builder.makeStore(2, offset, pick(1, 2), ptr, value, type);
        case 2:
          return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
        case 3:
          return builder.makeStore(
            8, offset, pick(1, 2, 4, 8), ptr, value, type);
      }
      WASM_UNREACHABLE("invalid value");
    }
    case Type::f32: {
      return builder.makeStore(4, offset, pick(1, 2, 4), ptr, value, type);
    }
    case Type::f64: {
      return builder.makeStore(8, offset, pick(1, 2, 4, 8), ptr, value, type);
    }
    case Type::v128: {
      if (!wasm.features.hasSIMD()) {
        return makeTrivial(type);
      }
      return builder.makeStore(
        16, offset, pick(1, 2, 4, 8, 16), ptr, value, type);
    }
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  wasm.memory.shared = true;
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
        case Type::funcref:
        case Type::externref:
        case Type::anyref:
        case Type::eqref:
        case Type::i31ref:
        case Type::dataref:
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
        case Type::funcref:
        case Type::externref:
        case Type::anyref:
        case Type::eqref:
        case Type::i31ref:
        case Type::dataref:
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
        case Type::funcref:
        case Type::externref:
        case Type::anyref:
        case Type::eqref:
        case Type::i31ref:
        case Type::dataref:
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
        case Type::funcref:
        case Type::externref:
        case Type::anyref:
        case Type::eqref:
        case Type::i31ref:
        case Type::dataref:
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
  // ref.as_non_null is allowed in globals and we don't yet support func.ref in
  // globals because we create globals before we create functions. As a result,
  // we can only create non-nullable function references if we are in a function
  // context for now.
  // TODO: Generate trivial functions to support ref.func in globals.
  assert(type.isNullable() || funcContext);
  if (!funcContext || (type.isNullable() && oneIn(8))) {
    return builder.makeRefNull(type);
  }

  auto heapType = type.getHeapType();
  if (heapType == HeapType::func) {
    // First set to target to the last created function, and try to select
    // among other existing function if possible.
    Function* target = funcContext->func;
    if (!wasm.functions.empty() && !oneIn(wasm.functions.size())) {
      target = pick(wasm.functions).get();
    }
    return builder.makeRefFunc(target->name, target->type);
  } else {
    // TODO: randomize the order
    for (auto& func : wasm.functions) {
      if (Type::isSubType(type, Type(func->type, NonNullable))) {
        return builder.makeRefFunc(func->name, func->type);
      }
    }
    // We don't have a matching function, so create a null with high probability
    // if the type is nullable or otherwise create and cast a null with low
    // probability.
    if ((type.isNullable() && !oneIn(8)) || oneIn(8)) {
      Expression* ret = builder.makeRefNull(Type(heapType, Nullable));
      if (!type.isNullable()) {
        ret = builder.makeRefAs(RefAsNonNull, ret);
      }
      return ret;
    }
    // As a final option, create a new function with the correct signature.
    auto* func = wasm.addFunction(
      builder.makeFunction(Names::getValidFunctionName(wasm, "ref_func_target"),
                           heapType,
                           {},
                           builder.makeUnreachable()));
    return builder.makeRefFunc(func->name, heapType);
  }
}

Expression* TranslateToFuzzReader::makeConst(Type type) {
  if (type.isRef()) {
    assert(wasm.features.hasReferenceTypes());
    if (type.isNullable() && oneIn(8)) {
      return builder.makeRefNull(type);
    }
    auto heapType = type.getHeapType();
    if (heapType.isBasic()) {
      switch (heapType.getBasic()) {
        case HeapType::func:
          return makeRefFuncConst(type);
        case HeapType::ext:
          // No trivial way to create an externref.
          break;
        case HeapType::any: {
          // Choose a subtype we can materialize a constant for. We cannot
          // materialize non-nullable refs to func or i31 in global contexts.
          Nullability nullability = getSubType(type.getNullability());
          HeapType subtype;
          if (funcContext || nullability == Nullable) {
            subtype = pick(HeapType::func, HeapType::i31, HeapType::data);
          } else {
            subtype = HeapType::data;
          }
          return makeConst(Type(subtype, nullability));
        }
        case HeapType::eq: {
          auto nullability = getSubType(type.getNullability());
          // i31.new is not allowed in initializer expressions.
          HeapType subtype;
          if (funcContext) {
            subtype = pick(HeapType::i31, HeapType::data);
          } else {
            subtype = HeapType::data;
          }
          return makeConst(Type(subtype, nullability));
        }
        case HeapType::i31:
          // i31.new is not allowed in initializer expressions.
          if (funcContext) {
            return builder.makeI31New(makeConst(Type::i32));
          } else {
            assert(type.isNullable());
            return builder.makeRefNull(type);
          }
        case HeapType::data:
          // TODO: Construct nontrivial types. For now just create a hard coded
          // struct or array.
          if (oneIn(2)) {
            // Use a local static to avoid creating a fresh nominal types in
            // --nominal mode.
            static HeapType trivialStruct = HeapType(Struct());
            return builder.makeStructNew(trivialStruct,
                                         std::vector<Expression*>{});
          } else {
            // Use a local static to avoid creating a fresh nominal types in
            // --nominal mode.
            static HeapType trivialArray =
              HeapType(Array(Field(Field::PackedType::i8, Immutable)));
            return builder.makeArrayInit(trivialArray, {});
          }
      }
    } else if (heapType.isSignature()) {
      return makeRefFuncConst(type);
    } else {
      // TODO: Handle nontrivial array and struct types.
    }
    // We weren't able to directly materialize a non-null constant. Try again to
    // create a null.
    if (type.isNullable()) {
      return builder.makeRefNull(type);
    }
    // We have to produce a non-null value. Possibly create a null and cast it
    // to non-null even though that will trap at runtime. We must have a
    // function context because the cast is not allowed in globals.
    if (!funcContext) {
      std::cerr << type << "\n";
    }
    assert(funcContext);
    return builder.makeRefAs(RefAsNonNull,
                             builder.makeRefNull(Type(heapType, Nullable)));
  } else if (type.isRtt()) {
    return builder.makeRtt(type);
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
  // There are no unary ops for reference or RTT types.
  if (type.isRef() || type.isRtt()) {
    return makeTrivial(type);
  }
  switch (type.getBasic()) {
    case Type::i32: {
      auto singleConcreteType = getSingleConcreteType();
      if (singleConcreteType.isRef() || singleConcreteType.isRtt()) {
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
        case Type::funcref:
        case Type::externref:
        case Type::anyref:
        case Type::eqref:
        case Type::i31ref:
        case Type::dataref:
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
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  // There are no binary ops for reference or RTT types.
  if (type.isRef() || type.isRtt()) {
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
                               SwizzleVec8x16),
                          make(Type::v128),
                          make(Type::v128)});
    }
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  wasm.memory.shared = true;
  if (type == Type::none) {
    return builder.makeAtomicFence();
  }
  if (type == Type::i32 && oneIn(2)) {
    if (ATOMIC_WAITS && oneIn(2)) {
      auto* ptr = makePointer();
      auto expectedType = pick(Type::i32, Type::i64);
      auto* expected = make(expectedType);
      auto* timeout = make(Type::i64);
      return builder.makeAtomicWait(
        ptr, expected, timeout, expectedType, logify(get()));
    } else {
      auto* ptr = makePointer();
      auto* count = make(Type::i32);
      return builder.makeAtomicNotify(ptr, count, logify(get()));
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
      type);
  } else {
    auto* expected = make(type);
    auto* replacement = make(type);
    return builder.makeAtomicCmpxchg(
      bytes, offset, ptr, expected, replacement, type);
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
    case Type::funcref:
    case Type::externref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  return builder.makeSIMDLoad(op, offset, align, ptr);
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

// TODO: support other RefIs variants, and rename this
Expression* TranslateToFuzzReader::makeRefIsNull(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes());
  return builder.makeRefIs(RefIsNull, make(getReferenceType()));
}

Expression* TranslateToFuzzReader::makeRefEq(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  auto* left = make(getEqReferenceType());
  auto* right = make(getEqReferenceType());
  return builder.makeRefEq(left, right);
}

Expression* TranslateToFuzzReader::makeI31New(Type type) {
  assert(type == Type::i31ref);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  auto* value = make(Type::i32);
  return builder.makeI31New(value);
}

Expression* TranslateToFuzzReader::makeI31Get(Type type) {
  assert(type == Type::i32);
  assert(wasm.features.hasReferenceTypes() && wasm.features.hasGC());
  auto* i31 = make(Type::i31ref);
  return builder.makeI31Get(i31, bool(oneIn(2)));
}

Expression* TranslateToFuzzReader::makeMemoryInit() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  uint32_t segment = upTo(wasm.memory.segments.size());
  size_t totalSize = wasm.memory.segments[segment].data.size();
  size_t offsetVal = upTo(totalSize);
  size_t sizeVal = upTo(totalSize - offsetVal);
  Expression* dest = makePointer();
  Expression* offset = builder.makeConst(int32_t(offsetVal));
  Expression* size = builder.makeConst(int32_t(sizeVal));
  return builder.makeMemoryInit(segment, dest, offset, size);
}

Expression* TranslateToFuzzReader::makeDataDrop() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  return builder.makeDataDrop(upTo(wasm.memory.segments.size()));
}

Expression* TranslateToFuzzReader::makeMemoryCopy() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Expression* dest = makePointer();
  Expression* source = makePointer();
  Expression* size = make(wasm.memory.indexType);
  return builder.makeMemoryCopy(dest, source, size);
}

Expression* TranslateToFuzzReader::makeMemoryFill() {
  if (!allowMemory) {
    return makeTrivial(Type::none);
  }
  Expression* dest = makePointer();
  Expression* value = make(Type::i32);
  Expression* size = make(wasm.memory.indexType);
  return builder.makeMemoryFill(dest, value, size);
}

Type TranslateToFuzzReader::getSingleConcreteType() {
  // TODO: Nontrivial reference types.
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
                .add(FeatureSet::ReferenceTypes, Type::funcref, Type::externref)
                .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                     // Type(HeapType::func, NonNullable),
                     // Type(HeapType::ext, NonNullable),
                     Type(HeapType::any, Nullable),
                     Type(HeapType::any, NonNullable),
                     Type(HeapType::eq, Nullable),
                     Type(HeapType::eq, NonNullable),
                     Type(HeapType::i31, Nullable),
                     // Type(HeapType::i31, NonNullable),
                     Type(HeapType::data, Nullable),
                     Type(HeapType::data, NonNullable)));
}

Type TranslateToFuzzReader::getReferenceType() {
  return pick(FeatureOptions<Type>()
                .add(FeatureSet::ReferenceTypes, Type::funcref, Type::externref)
                .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                     Type(HeapType::func, NonNullable),
                     Type(HeapType::ext, NonNullable),
                     Type(HeapType::any, Nullable),
                     Type(HeapType::any, NonNullable),
                     Type(HeapType::eq, Nullable),
                     Type(HeapType::eq, NonNullable),
                     Type(HeapType::i31, Nullable),
                     Type(HeapType::i31, NonNullable),
                     Type(HeapType::data, Nullable),
                     Type(HeapType::data, NonNullable)));
}

Type TranslateToFuzzReader::getEqReferenceType() {
  return pick(
    FeatureOptions<Type>().add(FeatureSet::ReferenceTypes | FeatureSet::GC,
                               Type(HeapType::eq, Nullable),
                               Type(HeapType::eq, NonNullable),
                               Type(HeapType::i31, Nullable),
                               Type(HeapType::i31, NonNullable),
                               Type(HeapType::data, Nullable),
                               Type(HeapType::data, NonNullable)));
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

Nullability TranslateToFuzzReader::getSubType(Nullability nullability) {
  return nullability == NonNullable ? NonNullable
                                    : oneIn(2) ? Nullable : NonNullable;
}

HeapType TranslateToFuzzReader::getSubType(HeapType type) {
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case HeapType::func:
        // TODO: Typed function references.
        return HeapType::func;
      case HeapType::ext:
        return HeapType::ext;
      case HeapType::any:
        // TODO: nontrivial types as well.
        return pick(HeapType::func,
                    HeapType::ext,
                    HeapType::any,
                    HeapType::eq,
                    HeapType::i31,
                    HeapType::data);
      case HeapType::eq:
        // TODO: nontrivial types as well.
        return pick(HeapType::eq, HeapType::i31, HeapType::data);
      case HeapType::i31:
        return HeapType::i31;
      case HeapType::data:
        // TODO: nontrivial types as well.
        return HeapType::data;
    }
  }
  // TODO: nontrivial types as well.
  return type;
}

Rtt TranslateToFuzzReader::getSubType(Rtt rtt) {
  uint32_t depth = rtt.depth != Rtt::NoDepth
                     ? rtt.depth
                     : oneIn(2) ? Rtt::NoDepth : upTo(MAX_RTT_DEPTH + 1);
  return Rtt(depth, rtt.heapType);
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
    return Type(heapType, nullability);
  } else if (type.isRtt()) {
    return Type(getSubType(type.getRtt()));
  } else {
    // This is an MVP type without subtypes.
    assert(type.isBasic());
    return type;
  }
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
