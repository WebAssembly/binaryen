//#define POSSIBLE_CONTENTS_DEBUG 2
/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include <optional>
#include <variant>

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/possible-contents.h"
#include "wasm.h"

namespace wasm {

namespace {

#ifndef NDEBUG
void disallowDuplicates(std::vector<Location>& targets) {
#ifdef POSSIBLE_CONTENTS_DEBUG
  std::unordered_set<Location> uniqueTargets;
  for (const auto& target : targets) {
    uniqueTargets.insert(target);
  }
  assert(uniqueTargets.size() == targets.size());
#endif
}
#endif

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
void dump(Location location) {
  if (auto* loc = std::get_if<ExpressionLocation>(&location)) {
    std::cout << "  exprloc \n" << *loc->expr << '\n';
  } else if (auto* loc = std::get_if<StructLocation>(&location)) {
    std::cout << "  structloc " << loc->type << " : " << loc->index << '\n';
  } else if (auto* loc = std::get_if<TagLocation>(&location)) {
    std::cout << "  tagloc " << loc->tag << '\n';
  } else if (auto* loc = std::get_if<LocalLocation>(&location)) {
    std::cout << "  localloc " << loc->func->name << " : " << loc->index
              << " tupleIndex " << loc->tupleIndex << '\n';
  } else if (auto* loc = std::get_if<ResultLocation>(&location)) {
    std::cout << "  resultloc " << loc->func->name << " : " << loc->index
              << '\n';
  } else if (auto* loc = std::get_if<GlobalLocation>(&location)) {
    std::cout << "  globalloc " << loc->name << '\n';
  } else if (auto* loc = std::get_if<BranchLocation>(&location)) {
    std::cout << "  branchloc " << loc->func->name << " : " << loc->target
              << " tupleIndex " << loc->tupleIndex << '\n';
  } else if (auto* loc = std::get_if<SignatureParamLocation>(&location)) {
    WASM_UNUSED(loc);
    std::cout << "  sigparamloc " << '\n';
  } else if (auto* loc = std::get_if<SignatureResultLocation>(&location)) {
    WASM_UNUSED(loc);
    std::cout << "  sigresultloc " << '\n';
  } else if (auto* loc = std::get_if<ArrayLocation>(&location)) {
    WASM_UNUSED(loc);
    std::cout << "  Arrayloc " << loc->type << '\n';
  } else if (auto* loc = std::get_if<NullLocation>(&location)) {
    std::cout << "  Nullloc " << loc->type << '\n';
  } else {
    std::cout << "  (other)\n";
  }
}
#endif

// The data we gather from each function, as we process them in parallel. Later
// this will be merged into a single big graph.
struct FuncInfo {
  // All the links we found in this function. Rarely are there duplicates
  // in this list (say when writing to the same global location from another
  // global location), and we do not try to deduplicate here, just store them in
  // a plain array for now, which is faster (later, when we merge all the info
  // from the functions, we need to deduplicate anyhow).
  std::vector<Link> links;

  // All the roots of the graph, that is, places that begin containing some
  // partcular content. That includes *.const, ref.func, struct.new, etc. All
  // possible contents in the rest of the graph flow from such places.
  // The map here is of the root to the value beginning in it.
  std::unordered_map<Location, PossibleContents> roots;

  // See ContentOracle::childParents.
  std::unordered_map<Expression*, Expression*> childParents;
};

struct LinkFinder
  : public PostWalker<LinkFinder, OverriddenVisitor<LinkFinder>> {
  FuncInfo& info;

  LinkFinder(FuncInfo& info) : info(info) {}

  bool isRelevant(Type type) {
    if (type == Type::unreachable || type == Type::none) {
      return false;
    }
    if (type.isTuple()) {
      for (auto t : type) {
        if (isRelevant(t)) {
          return true;
        }
      }
    }
    if (type.isRef() && getTypeSystem() != TypeSystem::Nominal) {
      // If nominal typing is enabled then we cannot handle refs, as we need
      // to do a subtyping analysis there (which SubTyping only supports in
      // nominal mode).
      return false;
    }
    return true;
  }

  bool isRelevant(Signature sig) {
    return isRelevant(sig.params) || isRelevant(sig.results);
  }

  bool isRelevant(Expression* curr) { return curr && isRelevant(curr->type); }

  template<typename T> bool isRelevant(const T& vec) {
    return true;
    for (auto* expr : vec) {
      if (isRelevant(expr->type)) {
        return true;
      }
    }
    return false;
  }

  // Each visit*() call is responsible for connecting the children of a
  // node to that node. Responsibility for connecting the node's output to
  // anywhere else (another expression or the function itself, if we are at
  // the top level) is the responsibility of the outside.

  // Handles the value sent in a break instruction. Does not handle anything
  // else like the condition etc.
  void handleBreakValue(Expression* curr) {
    // Breaks send values to their destinations. Handle that here using
    // existing utility code which is shorter than implementing multiple
    // visit*() methods (however, it may be slower TODO)
    BranchUtils::operateOnScopeNameUsesAndSentValues(
      curr, [&](Name target, Expression* value) {
        if (value) {
          for (Index i = 0; i < value->type.size(); i++) {
            info.links.push_back(
              {ExpressionLocation{value, i},
               BranchLocation{getFunction(), target, i}});
          }
        }
      });
  }

  // Handles receiving values from breaks at the target (block/loop).
  void handleBreakTarget(Expression* curr) {
    // Break targets receive the things sent to them and flow them out.
    if (isRelevant(curr->type)) {
      BranchUtils::operateOnScopeNameDefs(curr, [&](Name target) {
        for (Index i = 0; i < curr->type.size(); i++) {
          info.links.push_back({BranchLocation{getFunction(), target, i},
                                      ExpressionLocation{curr, i}});
        }
      });
    }
  }

  // Connect a child's value to the parent, that is, all things possible in the
  // child may flow to the parent.
  void receiveChildValue(Expression* child, Expression* parent) {
    if (isRelevant(parent) && isRelevant(child)) {
      // The tuple sizes must match (or, if not a tuple, the size should be 1 in
      // both cases.
      assert(child->type.size() == parent->type.size());
      for (Index i = 0; i < child->type.size(); i++) {
        info.links.push_back(
          {ExpressionLocation{child, i}, ExpressionLocation{parent, i}});
      }
    }
  }

  // Add links to make it possible to reach an expression's parent, which
  // we need during the flow in special cases. See the comment on |childParents|
  // on ContentOracle for details.
  void addSpecialChildParentLink(Expression* child, Expression* parent) {
    info.childParents[child] = parent;
  }

  // Adds a root, if the expression is relevant.
  template<typename T> void addRoot(Expression* curr, T contents) {
    if (isRelevant(curr)) {
      addRoot(ExpressionLocation{curr, 0}, contents);
    }
  }

  template<typename T> void addRoot(Location loc, T contents) {
    info.roots[loc] = contents;
  }

  void visitBlock(Block* curr) {
    if (curr->list.empty()) {
      return;
    }
    handleBreakTarget(curr);
    receiveChildValue(curr->list.back(), curr);
  }
  void visitIf(If* curr) {
    receiveChildValue(curr->ifTrue, curr);
    receiveChildValue(curr->ifFalse, curr);
  }
  void visitLoop(Loop* curr) { receiveChildValue(curr->body, curr); }
  void visitBreak(Break* curr) {
    handleBreakValue(curr);
    // The value may also flow through in a br_if (the type will indicate that,
    // which receiveChildValue will notice).
    receiveChildValue(curr->value, curr);
  }
  void visitSwitch(Switch* curr) { handleBreakValue(curr); }
  void visitLoad(Load* curr) {
    // We can only infer the type here (at least for now), and likewise in all
    // other memory operations.
    addRoot(curr, curr->type);
  }
  void visitStore(Store* curr) {}
  void visitAtomicRMW(AtomicRMW* curr) { addRoot(curr, curr->type); }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { addRoot(curr, curr->type); }
  void visitAtomicWait(AtomicWait* curr) { addRoot(curr, curr->type); }
  void visitAtomicNotify(AtomicNotify* curr) { addRoot(curr, curr->type); }
  void visitAtomicFence(AtomicFence* curr) { addRoot(curr, curr->type); }
  void visitSIMDExtract(SIMDExtract* curr) { addRoot(curr, curr->type); }
  void visitSIMDReplace(SIMDReplace* curr) { addRoot(curr, curr->type); }
  void visitSIMDShuffle(SIMDShuffle* curr) { addRoot(curr, curr->type); }
  void visitSIMDTernary(SIMDTernary* curr) { addRoot(curr, curr->type); }
  void visitSIMDShift(SIMDShift* curr) { addRoot(curr, curr->type); }
  void visitSIMDLoad(SIMDLoad* curr) { addRoot(curr, curr->type); }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    addRoot(curr, curr->type);
  }
  void visitMemoryInit(MemoryInit* curr) {}
  void visitDataDrop(DataDrop* curr) {}
  void visitMemoryCopy(MemoryCopy* curr) {}
  void visitMemoryFill(MemoryFill* curr) {}
  void visitConst(Const* curr) { addRoot(curr, curr->value); }
  void visitUnary(Unary* curr) {
    // Assume we only know the type in all math operations (for now).
    addRoot(curr, curr->type);
  }
  void visitBinary(Binary* curr) { addRoot(curr, curr->type); }
  void visitSelect(Select* curr) {
    receiveChildValue(curr->ifTrue, curr);
    receiveChildValue(curr->ifFalse, curr);
  }
  void visitDrop(Drop* curr) {}
  void visitMemorySize(MemorySize* curr) { addRoot(curr, curr->type); }
  void visitMemoryGrow(MemoryGrow* curr) { addRoot(curr, curr->type); }
  void visitRefNull(RefNull* curr) {
    addRoot(curr, Literal::makeNull(curr->type));
  }
  void visitRefIs(RefIs* curr) {
    // TODO: optimize when possible
    addRoot(curr, curr->type);
  }
  void visitRefFunc(RefFunc* curr) {
    addRoot(curr, Literal(curr->func, curr->type));
  }
  void visitRefEq(RefEq* curr) { addRoot(curr, curr->type); }
  void visitTableGet(TableGet* curr) {
    // TODO: optimize when possible
    addRoot(curr, curr->type);
  }
  void visitTableSet(TableSet* curr) {}
  void visitTableSize(TableSize* curr) { addRoot(curr, curr->type); }
  void visitTableGrow(TableGrow* curr) { addRoot(curr, curr->type); }

  void visitNop(Nop* curr) {}
  void visitUnreachable(Unreachable* curr) {}

#ifndef NDEBUG
  Index totalPops = 0;
  Index handledPops = 0;
#endif

  void visitPop(Pop* curr) {
    // For now we only handle pops in a catch body, set visitTry(). Note that
    // we've seen a pop so we can assert later on not having anything we cannot
    // handle.
#ifndef NDEBUG
    totalPops++;
#endif
  }
  void visitI31New(I31New* curr) { addRoot(curr, curr->type); }
  void visitI31Get(I31Get* curr) {
    // TODO: optimize like struct references
    addRoot(curr, curr->type);
  }

  void visitRefTest(RefTest* curr) {
    // TODO: optimize when possible
    addRoot(curr, curr->type);
  }
  void visitRefCast(RefCast* curr) {
    // We will handle this in a special way, as ref.cast only allows valid
    // values to flow through.
    if (isRelevant(curr->type)) {
      addSpecialChildParentLink(curr->ref, curr);
    }
  }
  void visitBrOn(BrOn* curr) {
    handleBreakValue(curr);
    // TODO: write out each case here in full for maximum optimizability.
    receiveChildValue(curr->ref, curr);
  }
  void visitRttCanon(RttCanon* curr) { addRoot(curr, curr->type); }
  void visitRttSub(RttSub* curr) { addRoot(curr, curr->type); }
  void visitRefAs(RefAs* curr) {
    // TODO optimize when possible
    addRoot(curr, curr->type);
  }

  // Locals read and write to their index.
  // TODO: we could use a LocalGraph for better precision
  void visitLocalGet(LocalGet* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->type.size(); i++) {
        info.links.push_back(
          {LocalLocation{getFunction(), curr->index, i},
           ExpressionLocation{curr, i}});
      }
    }
  }
  void visitLocalSet(LocalSet* curr) {
    if (!isRelevant(curr->value->type)) {
      return;
    }
    for (Index i = 0; i < curr->value->type.size(); i++) {
      info.links.push_back(
        {ExpressionLocation{curr->value, i},
         LocalLocation{getFunction(), curr->index, i}});
      if (curr->isTee()) {
        info.links.push_back(
          {ExpressionLocation{curr->value, i}, ExpressionLocation{curr, i}});
      }
    }
  }

  // Globals read and write from their location.
  void visitGlobalGet(GlobalGet* curr) {
    if (isRelevant(curr->type)) {
      info.links.push_back(
        {GlobalLocation{curr->name}, ExpressionLocation{curr, 0}});
    }
  }
  void visitGlobalSet(GlobalSet* curr) {
    if (isRelevant(curr->value->type)) {
      info.links.push_back(
        {ExpressionLocation{curr->value, 0}, GlobalLocation{curr->name}});
    }
  }

  // Iterates over a list of children and adds links to parameters
  // and results as needed. The param/result functions receive the index
  // and create the proper location for it.
  template<typename T>
  void handleCall(T* curr,
                  std::function<Location(Index)> makeParamLocation,
                  std::function<Location(Index)> makeResultLocation) {
    Index i = 0;
    for (auto* operand : curr->operands) {
      if (isRelevant(operand->type)) {
        info.links.push_back(
          {ExpressionLocation{operand, 0}, makeParamLocation(i)});
      }
      i++;
    }

    // Add results, if anything flows out.
    for (Index i = 0; i < curr->type.size(); i++) {
      if (isRelevant(curr->type[i])) {
        info.links.push_back(
          {makeResultLocation(i), ExpressionLocation{curr, i}});
      }
    }

    // If this is a return call then send the result to the function return as
    // well.
    if (curr->isReturn) {
      auto results = getFunction()->getResults();
      for (Index i = 0; i < results.size(); i++) {
        auto result = results[i];
        if (isRelevant(result)) {
          info.links.push_back(
            {makeResultLocation(i), ResultLocation{getFunction(), i}});
        }
      }
    }
  }

  // Calls send values to params in their possible targets, and receive
  // results.
  void visitCall(Call* curr) {
    auto* target = getModule()->getFunction(curr->target);
    handleCall(
      curr,
      [&](Index i) {
        return LocalLocation{target, i, 0};
      },
      [&](Index i) {
        return ResultLocation{target, i};
      });
  }
  void visitCallIndirect(CallIndirect* curr) {
    auto target = curr->heapType;
    handleCall(
      curr,
      [&](Index i) {
        return SignatureParamLocation{target, i};
      },
      [&](Index i) {
        return SignatureResultLocation{target, i};
      });
  }
  void visitCallRef(CallRef* curr) {
    auto targetType = curr->target->type;
    if (targetType != Type::unreachable) {
      auto heapType = targetType.getHeapType();
      handleCall(
        curr,
        [&](Index i) {
          return SignatureParamLocation{heapType, i};
        },
        [&](Index i) {
          return SignatureResultLocation{heapType, i};
        });
    }
  }

  // Creates a location for a null of a particular type and adds a root for it.
  // Such roots are where the default value of an i32 local comes from, or the
  // value in a ref.null.
  Location getNullLocation(Type type) {
    auto location = NullLocation{type};
    addRoot(location, Literal::makeZero(type));
    return location;
  }

  // Iterates over a list of children and adds links as needed. The
  // target of the link is created using a function that is passed
  // in, which receives the index of the child.
  void handleChildList(ExpressionList& operands,
                       std::function<Location(Index)> makeTarget) {
    Index i = 0;
    for (auto* operand : operands) {
      assert(!operand->type.isTuple());
      if (isRelevant(operand->type)) {
        info.links.push_back(
          {ExpressionLocation{operand, 0}, makeTarget(i)});
      }
      i++;
    }
  }

  void visitStructNew(StructNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    if (curr->isWithDefault()) {
      // Link the default values to the struct's fields.
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        info.links.push_back(
          {getNullLocation(fields[i].type), StructLocation{type, i}});
      }
    } else {
      // Link the operands to the struct's fields.
      handleChildList(curr->operands, [&](Index i) {
        return StructLocation{type, i};
      });
    }
    addRoot(curr, curr->type);
  }
  void visitArrayNew(ArrayNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    if (curr->init) {
      info.links.push_back(
        {ExpressionLocation{curr->init, 0}, ArrayLocation{type}});
    } else {
      info.links.push_back(
        {getNullLocation(type.getArray().element.type), ArrayLocation{type}});
    }
    addRoot(curr, curr->type);
  }
  void visitArrayInit(ArrayInit* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (!curr->values.empty()) {
      auto type = curr->type.getHeapType();
      handleChildList(curr->values,
                      [&](Index i) { return ArrayLocation{type}; });
    }
    addRoot(curr, curr->type);
  }

  // Struct operations access the struct fields' locations.
  void visitStructGet(StructGet* curr) {
    if (!isRelevant(curr->ref)) {
      // We are not tracking references, and so we cannot properly analyze
      // values read from them, and must assume the worst.
      addRoot(curr, curr->type);
      return;
    }
    if (isRelevant(curr->type)) {
      // The struct.get will receive different values depending on the contents
      // in the reference, so mark us as the parent of the ref, and we will
      // handle all of this in a special way during the flow. Note that we do
      // not even create a StructLocation here; anything that we need will be
      // added during the flow.
      addSpecialChildParentLink(curr->ref, curr);
    }
  }
  void visitStructSet(StructSet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    if (isRelevant(curr->value->type)) {
      // See comment on visitStructGet. Here we also connect the value.
      addSpecialChildParentLink(curr->ref, curr);
      addSpecialChildParentLink(curr->value, curr);
    }
  }
  // Array operations access the array's location, parallel to how structs work.
  void visitArrayGet(ArrayGet* curr) {
    if (!isRelevant(curr->ref)) {
      addRoot(curr, curr->type);
      return;
    }
    if (isRelevant(curr->type)) {
      addSpecialChildParentLink(curr->ref, curr);
    }
  }
  void visitArraySet(ArraySet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    if (isRelevant(curr->value->type)) {
      addSpecialChildParentLink(curr->ref, curr);
      addSpecialChildParentLink(curr->value, curr);
    }
  }

  void visitArrayLen(ArrayLen* curr) { addRoot(curr, curr->type); }
  void visitArrayCopy(ArrayCopy* curr) {}

  // TODO: Model which throws can go to which catches. For now, anything
  //       thrown is sent to the location of that tag, and any catch of that
  //       tag can read them
  void visitTry(Try* curr) {
    receiveChildValue(curr->body, curr);
    for (auto* catchBody : curr->catchBodies) {
      receiveChildValue(catchBody, curr);
    }

    auto numTags = curr->catchTags.size();
    for (Index tagIndex = 0; tagIndex < numTags; tagIndex++) {
      auto tag = curr->catchTags[tagIndex];
      auto* body = curr->catchBodies[tagIndex];

      auto params = getModule()->getTag(tag)->sig.params;
      if (params.size() == 0) {
        return;
      }

      // Find the pop of the tag's contents. The body must start with such a
      // pop, which might be of a tuple.
      FindAll<Pop> pops(body);
      assert(!pops.list.empty());
      auto* pop = pops.list[0];
      assert(pop->type.size() == params.size());
      for (Index i = 0; i < params.size(); i++) {
        if (isRelevant(params[i])) {
          info.links.push_back(
            {TagLocation{tag, i}, ExpressionLocation{pop, i}});
        }
      }

#ifndef NDEBUG
      // This pop was in the position we can handle, note that (see visitPop
      // for details).
      handledPops++;
#endif
    }
  }
  void visitThrow(Throw* curr) {
    auto& operands = curr->operands;
    if (!isRelevant(operands)) {
      return;
    }

    auto tag = curr->tag;
    for (Index i = 0; i < curr->operands.size(); i++) {
      info.links.push_back(
        {ExpressionLocation{operands[i], 0}, TagLocation{tag, i}});
    }
  }
  void visitRethrow(Rethrow* curr) {}

  void visitTupleMake(TupleMake* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->operands.size(); i++) {
        info.links.push_back({ExpressionLocation{curr->operands[i], 0},
                                    ExpressionLocation{curr, i}});
      }
    }
  }
  void visitTupleExtract(TupleExtract* curr) {
    if (isRelevant(curr->type)) {
      info.links.push_back({ExpressionLocation{curr->tuple, curr->index},
                                  ExpressionLocation{curr, 0}});
    }
  }

  void addResult(Expression* value) {
    if (value && isRelevant(value->type)) {
      for (Index i = 0; i < value->type.size(); i++) {
        info.links.push_back(
          {ExpressionLocation{value, i}, ResultLocation{getFunction(), i}});
      }
    }
  }

  void visitReturn(Return* curr) { addResult(curr->value); }

  void visitFunction(Function* curr) {
    // Vars have an initial value.
    for (Index i = 0; i < curr->getNumLocals(); i++) {
      if (curr->isVar(i)) {
        Index j = 0;
        for (auto t : curr->getLocalType(i)) {
          if (t.isDefaultable()) {
            info.links.push_back(
              {getNullLocation(t), LocalLocation{curr, i, j}});
          }
          j++;
        }
      }
    }

    // Functions with a result can flow a value out from their body.
    addResult(curr->body);

    // See visitPop().
    assert(handledPops == totalPops);
  }
};

} // anonymous namespace

void ContentOracle::analyze() {
#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "parallel phase\n";
#endif

  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    wasm, [&](Function* func, FuncInfo& info) {
      LinkFinder finder(info);

      if (func->imported()) {
        // Imports return unknown values.
        for (Index i = 0; i < func->getResults().size(); i++) {
          finder.addRoot(ResultLocation{func, i}, PossibleContents::many());
        }
        return;
      }

      finder.walkFunctionInModule(func, &wasm);
    });

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "single phase\n";
#endif

  // Also walk the global module code, adding it to the map as a function of
  // null.
  auto& globalInfo = analysis.map[nullptr];
  LinkFinder finder(globalInfo);
  finder.walkModuleCode(&wasm);

  // Connect global init values (which we've just processed, as part of the
  // module code) to the globals they initialize.
  for (auto& global : wasm.globals) {
    if (global->imported()) {
      // Imports are unknown values.
      finder.addRoot(GlobalLocation{global->name}, PossibleContents::many());
      continue;
    }
    auto* init = global->init;
    if (finder.isRelevant(init->type)) {
      globalInfo.links.push_back(
        {ExpressionLocation{init, 0}, GlobalLocation{global->name}});
    }
  }

  // Merge the function information into a single large graph that represents
  // the entire program all at once. First, gather all the links from all
  // the functions. We do so into a set, which deduplicates everythings.
  // map of the possible contents at each location.
  std::unordered_map<Location, PossibleContents> roots;

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "merging phase\n";
#endif

  for (auto& [func, info] : analysis.map) {
    for (auto& link : info.links) {
      links.insert(link);
    }
    for (auto& [root, value] : info.roots) {
      roots[root] = value;
    }
    for (auto [child, parent] : info.childParents) {
      childParents[child] = parent;
    }
  }

  // We no longer need the function-level info.
  analysis.map.clear();

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "external phase\n";
#endif

  // Add unknown incoming roots from parameters to exported functions and other
  // cases where we can't see the caller.
  auto calledFromOutside = [&](Name funcName) {
    auto* func = wasm.getFunction(funcName);
    for (Index i = 0; i < func->getParams().size(); i++) {
      roots[LocalLocation{func, i, 0}] = PossibleContents::many();
    }
  };

  for (auto& ex : wasm.exports) {
    if (ex->kind == ExternalKind::Function) {
      calledFromOutside(ex->value);
    } else if (ex->kind == ExternalKind::Table) {
      // If a table is exported, assume any function in tables can be called
      // from the outside.
      // TODO: This could be more precise about which tables
      // TODO: This does not handle table.get/table.set, or call_ref, for which
      //       we'd need to see which references are used and which escape etc.
      //       For now, assume a closed world for such such advanced use cases /
      //       assume this pass won't be run in them anyhow.
      // TODO: do this once if multiple tables are exported
      for (auto& elementSegment : wasm.elementSegments) {
        for (auto* curr : elementSegment->data) {
          if (auto* refFunc = curr->dynCast<RefFunc>()) {
            calledFromOutside(refFunc->func);
          }
        }
      }
    }
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "func phase\n";
#endif

  // Connect function parameters to their signature, so that any indirect call
  // of that signature will reach them.
  // TODO: find which functions are even taken by reference
  for (auto& func : wasm.functions) {
    for (Index i = 0; i < func->getParams().size(); i++) {
      links.insert({SignatureParamLocation{func->type, i},
                          LocalLocation{func.get(), i, 0}});
    }
    for (Index i = 0; i < func->getResults().size(); i++) {
      links.insert({ResultLocation{func.get(), i},
                          SignatureResultLocation{func->type, i}});
    }
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "struct phase\n";
#endif

  if (getTypeSystem() == TypeSystem::Nominal) {
    subTypes = std::make_unique<SubTypes>(wasm);
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "DAG phase\n";
#endif

  // Build the flow info. First, note the link targets.
  for (auto& link : links) {
    flowInfoMap[link.from].targets.push_back(link.to);
  }

#ifndef NDEBUG
  // The vector of targets must have no duplicates.
  for (auto& [location, info] : flowInfoMap) {
    disallowDuplicates(info.targets);
  }
#endif

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "roots phase\n";
#endif

  // Set up the roots, which are the starting state for the flow analysis.
  for (const auto& [location, value] : roots) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  init root\n";
    dump(location);
    value.dump(std::cout, &wasm);
    std::cout << '\n';
#endif

    // Update the root from having nothing to having its initial content.
    addWork({location, value});
  }

  updateNewLinks();

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "flow phase\n";
#endif

  // Flow the data.
  // TODO: unit test all the movements of PossibleContents, always making sure
  // they are Lyapunov. Rule out an infinite loop. On barista work.size() hangs
  // around 30K for a long time. but it does get lower. just very very slow?
  while (!workQueue.empty()) {
    //std::cout << "work left: " << workQueue.size() << '\n';
    auto work = workQueue.pop();

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "\npop work item\n";
    dump(work.first);
    std::cout << " with contents \n";
    work.second.dump(std::cout, &wasm);
    std::cout << '\n';
#endif

    processWork(work);

    updateNewLinks();
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm).
}

void ContentOracle::processWork(const Work& work) {
  auto& location = work.first;
  auto& arrivingContents = work.second;

  if (arrivingContents.isNone()) {
    // Nothing is arriving here at all.
    return;
  }

  auto& contents = flowInfoMap[location].contents;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "\nprocessWork src:\n";
  dump(location);
  std::cout << "  arriving:\n";
  arrivingContents.dump(std::cout, &wasm);
  std::cout << '\n';
  std::cout << "  existing:\n";
  contents.dump(std::cout, &wasm);
  std::cout << '\n';
#endif

  // When handling some cases we care about what actually
  // changed, so save the state before doing the update.
  auto oldContents = contents;
  if (!contents.combine(arrivingContents)) {
    assert(oldContents == contents);

    // Nothing changed; nothing more to do.
    return;
  }

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "  something changed!\n";
  contents.dump(std::cout, &wasm);
  std::cout << "\nat ";
  dump(location);
#endif

  if (auto* globalLoc = std::get_if<GlobalLocation>(&location)) {
    auto* global = wasm.getGlobal(globalLoc->name);
    if (global->mutable_ == Immutable) {
      // This is an immutable global. We never need to consider this value as
      // "Many", since in the worst case we can just use the immutable value.
      // That is, we can always replace this value with (global.get $name) which
      // will get the right value. Likewise, using the immutable value is better
      // than any value in a particular type, even an exact one.
      if (contents.isMany() || contents.isExactType()) {
        contents =
          PossibleContents::ImmutableGlobal{global->name, global->type};

        // TODO: We could do better here, to set global->init->type instead of
        //       global->type, or even the contents.getType() - either of those
        //       may be more refined. But other passes will handle that in
        //       general.

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
        std::cout << "  setting immglobal to ImmutableGlobal instead of Many\n";
        contents.dump(std::cout, &wasm);
        std::cout << '\n';
#endif

        // Furthermore, perhaps nothing changed at all of that was already the
        // previous value here.
        if (contents == oldContents) {
          return;
        }
      }
    }
  }

  // We made an actual change to this location. Add its targets to the work
  // queue.
  for (auto& target : flowInfoMap[location].targets) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  send to target\n";
    dump(target);
#endif

    addWork({target, contents});
  }

  // We are mostly done, except for handling interesting/special cases in the
  // flow.

  if (auto* targetExprLoc = std::get_if<ExpressionLocation>(&location)) {
    auto* targetExpr = targetExprLoc->expr;
    auto iter = childParents.find(targetExpr);
    if (iter != childParents.end()) {
      // The target is one of the special cases where it is an expression
      // for whom we must know the parent in order to handle things in a
      // special manner.
      auto* parent = iter->second;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
      std::cout << "  special, parent:\n" << *parent << '\n';
#endif

      // Something changed, handle the special cases.

      // Return the list of possible types that can read from a struct.get or
      // write from a struct.set, etc. This is passed the possible contents of
      // the reference, and computes which types it can contain.
      auto getPossibleTypes = [&](const PossibleContents& refContents,
                                  HeapType declaredRefType) -> std::unordered_set<HeapType> {
        // We can handle a null like none: a null never leads to an actual read
        // from anywhere, so we can ignore it.
        if (refContents.isNone() || refContents.isNull()) {
          return {};
        }

        if (refContents.isMany()) {
          std::unordered_set<HeapType> ret;
          for (auto type : subTypes->getAllSubTypesInclusive(declaredRefType)) {
            ret.insert(type);
          }
          return ret;
        }

        // Otherwise, this is an exact type or a constant that is not a null. In
        // both cases we know the exact type.
        assert(refContents.isExactType() || refContents.isConstant());
        return {refContents.getType().getHeapType()};
      };

      // Given a heap location, add a link from that location to an
      // expression that reads from it (e.g. from a StructLocation to a
      // struct.get).
      auto readFromHeap = [&](std::optional<Location> heapLoc,
                              Expression* target) {
        if (!heapLoc) {
          return;
        }
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
        std::cout << "    add special read\n";
#endif
        auto targetLoc = ExpressionLocation{target, 0};

        // Add this to the graph if it is an entirely new link.
        auto newLink = Link{*heapLoc, targetLoc};
        if (links.count(newLink) == 0) {
          newLinks.push_back(newLink);
          links.insert(newLink);
        }

        // Recurse: the parent may also be a special child, e.g.
        //   (struct.get
        //     (struct.get ..)
        //   )
        // TODO unrecurse with a stack, although such recursion will be rare
        addWork({targetLoc, flowInfoMap[*heapLoc].contents});
      };

      // Given the old and new contents at the current target, add reads to
      // it based on the latest changes. The reads are sent to |parent|,
      // which is either a struct.get or an array.get. That is, new contents
      // are possible for the reference, which means we need to read from
      // more possible heap locations. This receives a function that gets a
      // heap type and returns a location, which we will call on all
      // relevant heap types as we add the links.
      // @param getLocation: returns the location for a particular heap type, if
      //                     such a location exists.
      // @param declaredRefType: the type declared in the IR on the
      //                         reference input to the struct.get/array.get.
      auto readFromNewLocations =
        [&](std::function<std::optional<Location>(HeapType)> getLocation,
            HeapType declaredRefType) {
          auto oldPossibleTypes = getPossibleTypes(oldContents, declaredRefType);
          auto newPossibleTypes = getPossibleTypes(contents, declaredRefType);
          for (auto type : newPossibleTypes) {
            if (!oldPossibleTypes.count(type)) {
              // This is new.
              auto heapLoc = getLocation(type);
              if (heapLoc) {
                readFromHeap(*heapLoc,
                             parent);
              }
            }
          }

          // TODO: A less simple but more memory-efficient approach might be
          //       to keep special data structures on the side for such
          //       "dynamic" information, basically a list of all
          //       struct.gets impacted by each type, etc., and use those in
          //       the proper places. Then each location would have not just
          //       a list of target locations but also a list of target
          //       expressions perhaps, etc.
        };

      // Similar to readFromNewLocations, but sends values from a
      // struct.set/array.set to a heap location. In addition to the
      // |getLocation| function (which plays the same role as in
      // readFromNewLocations), gets the reference and the value of the
      // struct.set/array.set operation
      auto writeToNewLocations =
        [&](std::function<std::optional<Location>(HeapType)> getLocation,
            Expression* ref,
            Expression* value) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
          std::cout << "    add special writes\n";
#endif
          // We could set up links here, but as we get to this code in
          // any case when either the ref or the value of the struct.get has
          // new contents, we can just flow the values forward directly. We
          // can do that in a simple way that does not even check whether
          // the ref or the value was just updated: simply figure out the
          // values being written in the current state (which is after the
          // current update) and forward them.
          auto refContents = flowInfoMap[ExpressionLocation{ref, 0}].contents;
          auto valueContents = flowInfoMap[ExpressionLocation{value, 0}].contents;
          if (refContents.isNone()) {
            return;
          }
          if (refContents.isExactType() || refContents.isConstant()) {
            // Update the one possible type here.
            // TODO: In the case that this is a constant, it could be null
            //       or an immutable global, which we could do even more
            //       with.
            auto heapLoc = getLocation(refContents.getType().getHeapType());
            if (heapLoc) {
              addWork({*heapLoc, valueContents});
            }
          } else {
            assert(refContents.isMany());
            // Update all possible types here. First, subtypes, including the
            // type itself.
            auto type = ref->type.getHeapType();
            for (auto subType : subTypes->getAllSubTypesInclusive(type)) {
              auto heapLoc = getLocation(subType);
              if (heapLoc) {
                addWork({*heapLoc, valueContents});
              }
            }
          }
        };

      if (auto* get = parent->dynCast<StructGet>()) {
        // This is the reference child of a struct.get.
        assert(get->ref == targetExpr);
        readFromNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            if (get->index >= type.getStruct().fields.size()) {
              // This field is not present on this struct.
              return {};
            }
            return StructLocation{type, get->index};
          },
          get->ref->type.getHeapType());
      } else if (auto* set = parent->dynCast<StructSet>()) {
        // This is either the reference or the value child of a struct.set.
        // A change to either one affects what values are written to that
        // struct location, which we handle here.
        assert(set->ref == targetExpr || set->value == targetExpr);
        writeToNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            if (set->index >= type.getStruct().fields.size()) {
              // This field is not present on this struct.
              return {};
            }
            return StructLocation{type, set->index};
          },
          set->ref,
          set->value);
      } else if (auto* get = parent->dynCast<ArrayGet>()) {
        assert(get->ref == targetExpr);
        readFromNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            return ArrayLocation{type};
          },
          get->ref->type.getHeapType());
      } else if (auto* set = parent->dynCast<ArraySet>()) {
        assert(set->ref == targetExpr || set->value == targetExpr);
        writeToNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            return ArrayLocation{type};
          },
          set->ref,
          set->value);
      } else if (auto* cast = parent->dynCast<RefCast>()) {
        assert(cast->ref == targetExpr);
        // RefCast only allows valid values to go through: nulls and things of
        // the cast type. And of course Many is always passed through.
        bool isNull = contents.isConstantLiteral() &&
                      contents.getConstantLiteral().isNull();
        bool isMany = contents.isMany();
        // We cannot check for subtyping if the type is Many (getType() would
        // return none, which has no heap type).
        bool isSubType =
          isMany ? false
                 : HeapType::isSubType(contents.getType().getHeapType(),
                                       cast->getIntendedType());
        if (isNull || isMany || isSubType) {
          // Recurse: the parent may also be a special child, e.g.
          //   (struct.get
          //     (ref.cast ..)
          //   )
          // TODO unrecurse with a stack, although such recursion will be rare
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
          std::cout << "    ref.cast passing through\n";
#endif
          addWork({ExpressionLocation{parent, 0}, contents});
        }
        // TODO: ref.test and all other casts can be optimized (see the cast
        //       helper code used in OptimizeInstructions and RemoveUnusedBrs)
      } else {
        WASM_UNREACHABLE("bad childParents content");
      }
    }
  }
}

void ContentOracle::updateNewLinks() {
  // Update any new links.
  for (auto newLink : newLinks) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "\nnewLink:\n";
    dump(newLink.from);
    dump(newLink.to);
#endif

    auto& targets = flowInfoMap[newLink.from].targets;
    targets.push_back(newLink.to);

#ifndef NDEBUG
    disallowDuplicates(targets);
#endif
  }
  newLinks.clear();
}

} // namespace wasm
