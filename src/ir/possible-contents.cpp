//#define POSSIBLE_TYPES_DEBUG 2
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

#include <variant>

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/possible-contents.h"
#include "ir/subtypes.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {

namespace {

#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
void dump(Location location) {
  if (auto* loc = std::get_if<ExpressionLocation>(&location)) {
    std::cout << "  exprloc \n" << *loc->expr << " (parent? " << !!loc->parent
              << ")\n";
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
    std::cout << "  Arrayloc " << '\n';
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
  // All the connections we found in this function. Rarely are there duplicates
  // in this list (say when writing to the same global location from another
  // global location), and we do not try to deduplicate here, just store them in
  // a plain array for now, which is faster (later, when we merge all the info
  // from the functions, we need to deduplicate anyhow).
  // TODO rename to links
  std::vector<Connection> connections;

  // All the roots of the graph, that is, places where we should mark a type as
  // possible before starting the analysis. This includes struct.new, ref.func,
  // etc. All possible types in the rest of the graph flow from such places.
  // The map here is of the root to the value beginning in it.
  std::unordered_map<Location, PossibleContents> roots;

  // In some cases we need to know the parent of an expression. This maps such
  // children to their parents. TODO merge comments
  // In some cases we need to know the parent of the expression, like with GC
  // operations. Consider this:
  //
  //  (struct.set $A k
  //    (local.get $ref)
  //    (local.get $value)
  //  )
  //
  // Imagine that the first local.get, for $ref, receives a new value. That can
  // affect where the struct.set sends values: if previously that local.get had
  // no possible contents, and now it does, then we have StructLocations to
  // update. Likewise, when the second local.get is updated we must do the same,
  // but again which StructLocations we update depends on the ref passed to the
  // struct.get. To handle such things, we set |parent| to the parent, and check
  // for it during the flow. In the common case, however, where the parent does
  // not matter, this field can be nullptr XXX.
  //
  // In practice we always create an ExpressionLocation with a nullptr parent
  // for everything, so the local.gets above would each have two: one
  // ExpressionLocation without a parent, that is used in the graph normally,
  // and whose value flows into an ExpressionLocation with a parent equal to the
  // struct.set. This is practical because normally we do not know the parent of
  // each node as we traverse, so always adding a parent would make the graph-
  // building logic more complicated.
  std::unordered_map<Expression*, Expression*> childParents;
};

struct ConnectionFinder
  : public PostWalker<ConnectionFinder, OverriddenVisitor<ConnectionFinder>> {
  FuncInfo& info;

  ConnectionFinder(FuncInfo& info) : info(info) {}

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
            info.connections.push_back(
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
          info.connections.push_back({BranchLocation{getFunction(), target, i},
                                      ExpressionLocation{curr, i}});
        }
      });
    }
  }

  // Connect a child's value to the parent, that is, all things possible in the
  // child may flow to the parent.
  void connectChildToParent(Expression* child, Expression* parent) {
    if (isRelevant(parent) && isRelevant(child)) {
      // The tuple sizes must match (or, if not a tuple, the size should be 1 in
      // both cases.
      assert(child->type.size() == parent->type.size());
      for (Index i = 0; i < child->type.size(); i++) {
        info.connections.push_back(
          {ExpressionLocation{child, i}, ExpressionLocation{parent, i}});
      }
    }
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
    connectChildToParent(curr->list.back(), curr);
  }
  void visitIf(If* curr) {
    connectChildToParent(curr->ifTrue, curr);
    connectChildToParent(curr->ifFalse, curr);
  }
  void visitLoop(Loop* curr) { connectChildToParent(curr->body, curr); }
  void visitBreak(Break* curr) {
    handleBreakValue(curr);
    // The value may also flow through in a br_if (the type will indicate that,
    // which connectChildToParent will notice).
    connectChildToParent(curr->value, curr);
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
    connectChildToParent(curr->ifTrue, curr);
    connectChildToParent(curr->ifFalse, curr);
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
    // we've seen one so we can assert on this later.
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
    // TODO: optimize when possible
    addRoot(curr, curr->type);
  }
  void visitBrOn(BrOn* curr) {
    handleBreakValue(curr);
    connectChildToParent(curr->ref, curr);
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
        info.connections.push_back(
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
      info.connections.push_back(
        {ExpressionLocation{curr->value, i},
         LocalLocation{getFunction(), curr->index, i}});
      if (curr->isTee()) {
        info.connections.push_back(
          {ExpressionLocation{curr->value, i}, ExpressionLocation{curr, i}});
      }
    }
  }

  // Globals read and write from their location.
  void visitGlobalGet(GlobalGet* curr) {
    if (isRelevant(curr->type)) {
      info.connections.push_back(
        {GlobalLocation{curr->name}, ExpressionLocation{curr, 0}});
    }
  }
  void visitGlobalSet(GlobalSet* curr) {
    if (isRelevant(curr->value->type)) {
      info.connections.push_back(
        {ExpressionLocation{curr->value, 0}, GlobalLocation{curr->name}});
    }
  }

  // Iterates over a list of children and adds connections to parameters
  // and results as needed. The param/result functions receive the index
  // and create the proper location for it.
  template<typename T>
  void handleCall(T* curr,
                  std::function<Location(Index)> makeParamLocation,
                  std::function<Location(Index)> makeResultLocation) {
    Index i = 0;
    for (auto* operand : curr->operands) {
      if (isRelevant(operand->type)) {
        info.connections.push_back(
          {ExpressionLocation{operand, 0}, makeParamLocation(i)});
      }
      i++;
    }

    // Add results, if anything flows out.
    for (Index i = 0; i < curr->type.size(); i++) {
      if (isRelevant(curr->type[i])) {
        info.connections.push_back(
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
          info.connections.push_back(
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

  // Creates a location for a null of a particular type. All nulls are roots as
  // a value begins there, which we set up here.
  Location getNullLocation(Type type) {
    auto location = NullLocation{type};
    addRoot(location, Literal::makeZero(type));
    return location;
  }

  // Iterates over a list of children and adds connections as needed. The
  // target of the connection is created using a function that is passed
  // in which receives the index of the child.
  void handleChildList(ExpressionList& operands,
                       std::function<Location(Index)> makeTarget) {
    Index i = 0;
    for (auto* operand : operands) {
      assert(!operand->type.isTuple());
      if (isRelevant(operand->type)) {
        info.connections.push_back(
          {ExpressionLocation{operand, 0}, makeTarget(i)});
      }
      i++;
    }
  }

  // Creation operations form the starting connections from where data
  // flows. We will create an ExpressionLocation for them when their
  // parent uses them, as we do for all instructions, so nothing special
  // needs to be done here, but we do need to create connections from
  // inputs - the initialization of their data - to the proper places.
  void visitStructNew(StructNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    if (curr->isWithDefault()) {
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        info.connections.push_back(
          {getNullLocation(fields[i].type), StructLocation{type, i}});
      }
    } else {
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
    // Note that if there is no initial value here then it is null, which is
    // not something we need to connect.
    auto type = curr->type.getHeapType();
    // TODO simplify if to avoid 2 push_backs
    if (curr->init) {
      info.connections.push_back(
        {ExpressionLocation{curr->init, 0}, ArrayLocation{type}});
    } else {
      info.connections.push_back(
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

  // Add connections to make it possible to reach an expression's parent, which
  // we need during the flow in special cases. See the comment on the |parent|
  // field on the ExpressionLocation class for more details. FIXME comment
  void linkChildToParent(Expression* child, Expression* parent) {
    // The mechanism we use is to connect the main location (referred to in
    // various other places potentially) to a new location that has the parent.
    // The main location feeds values to the latter, and we can then use the
    // parent in the main flow logic.
    info.childParents[child] = parent;
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
      info.connections.push_back(
        {StructLocation{curr->ref->type.getHeapType(), curr->index},
         ExpressionLocation{curr, 0}});

      // The struct.get will receive different values depending on the contents
      // in the reference, so mark us as the parent of the ref.
      linkChildToParent(curr->ref, curr);
    }
  }
  void visitStructSet(StructSet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    if (isRelevant(curr->value->type)) {
      info.connections.push_back(
        {ExpressionLocation{curr->value, 0},
         StructLocation{curr->ref->type.getHeapType(), curr->index}});

      // See comment on visitStructGet. Here we also connect the value.
      linkChildToParent(curr->ref, curr);
      linkChildToParent(curr->value, curr);
    }
  }
  // Array operations access the array's location.
  void visitArrayGet(ArrayGet* curr) {
    if (!isRelevant(curr->ref)) {
      // We are not tracking references, and so we cannot properly analyze
      // values read from them, and must assume the worst.
      addRoot(curr, curr->type);
      return;
    }
    if (isRelevant(curr->type)) {
      info.connections.push_back({ArrayLocation{curr->ref->type.getHeapType()},
                                  ExpressionLocation{curr, 0}});

      // See StructGet comment.
      linkChildToParent(curr->ref, curr);
    }
  }
  void visitArraySet(ArraySet* curr) {
    if (curr->ref->type == Type::unreachable) {
      return;
    }
    if (isRelevant(curr->value->type)) {
      info.connections.push_back(
        {ExpressionLocation{curr->value, 0},
         ArrayLocation{curr->ref->type.getHeapType()}});

      // See StructSet comment.
      linkChildToParent(curr->ref, curr);
      linkChildToParent(curr->value, curr);
    }
  }

  void visitArrayLen(ArrayLen* curr) { addRoot(curr, curr->type); }
  void visitArrayCopy(ArrayCopy* curr) {}

  // TODO: Model which throws can go to which catches. For now, anything
  //       thrown is sent to the location of that tag, and any catch of that
  //       tag can read them
  void visitTry(Try* curr) {
    connectChildToParent(curr->body, curr);
    for (auto* catchBody : curr->catchBodies) {
      connectChildToParent(catchBody, curr);
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
          info.connections.push_back(
            {TagLocation{tag, i}, ExpressionLocation{pop, i}});
        }
      }

      // This pop was in the position we can handle, note that (see visitPop
      // for details).
#ifndef NDEBUG
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
      info.connections.push_back(
        {ExpressionLocation{operands[i], 0}, TagLocation{tag, i}});
    }
  }
  void visitRethrow(Rethrow* curr) {}

  void visitTupleMake(TupleMake* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->operands.size(); i++) {
        info.connections.push_back({ExpressionLocation{curr->operands[i], 0},
                                    ExpressionLocation{curr, i}});
      }
    }
  }
  void visitTupleExtract(TupleExtract* curr) {
    if (isRelevant(curr->type)) {
      info.connections.push_back({ExpressionLocation{curr->tuple, curr->index},
                                  ExpressionLocation{curr, 0}});
    }
  }

  void addResult(Expression* value) {
    if (value && isRelevant(value->type)) {
      for (Index i = 0; i < value->type.size(); i++) {
        info.connections.push_back(
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
            info.connections.push_back(
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
#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "parallel phase\n";
#endif

  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    wasm, [&](Function* func, FuncInfo& info) {
      ConnectionFinder finder(info);

      if (func->imported()) {
        // Imports return unknown values.
        for (Index i = 0; i < func->getResults().size(); i++) {
          finder.addRoot(ResultLocation{func, i}, PossibleContents::many());
        }
        return;
      }

      finder.walkFunctionInModule(func, &wasm);
    });

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "single phase\n";
#endif

  // Also walk the global module code, adding it to the map as a function of
  // null.
  auto& globalInfo = analysis.map[nullptr];
  ConnectionFinder finder(globalInfo);
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
      globalInfo.connections.push_back(
        {ExpressionLocation{init, 0}, GlobalLocation{global->name}});
    }
  }

  // Merge the function information into a single large graph that represents
  // the entire program all at once. First, gather all the connections from all
  // the functions. We do so into a set, which deduplicates everythings.
  // map of the possible types at each location.
  std::unordered_set<Connection> connections;
  std::unordered_map<Location, PossibleContents> roots;
  std::unordered_map<Expression*, Expression*> childParents;

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "merging phase\n";
#endif

  for (auto& [func, info] : analysis.map) {
    for (auto& connection : info.connections) {
      connections.insert(connection);
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

#ifdef POSSIBLE_TYPES_DEBUG
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

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "func phase\n";
#endif

  // Connect function parameters to their signature, so that any indirect call
  // of that signature will reach them.
  // TODO: find which functions are even taken by reference
  for (auto& func : wasm.functions) {
    for (Index i = 0; i < func->getParams().size(); i++) {
      connections.insert({SignatureParamLocation{func->type, i},
                          LocalLocation{func.get(), i, 0}});
    }
    for (Index i = 0; i < func->getResults().size(); i++) {
      connections.insert({ResultLocation{func.get(), i},
                          SignatureResultLocation{func->type, i}});
    }
  }

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "struct phase\n";
#endif

  // During the flow we will need information about subtyping.
  std::unique_ptr<SubTypes> subTypes;
  if (getTypeSystem() == TypeSystem::Nominal) {
    subTypes = std::make_unique<SubTypes>(wasm);
  }

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "DAG phase\n";
#endif

  // Build the flow info. First, note the connection targets.
  for (auto& connection : connections) {
    flowInfoMap[connection.from].targets.push_back(connection.to);
  }

#ifndef NDEBUG
  // The vector of targets must have no duplicates.
  auto disallowDuplicates = [&](const std::vector<Location>& targets) {
    std::unordered_set<Location> uniqueTargets;
    for (const auto& target : targets) {
      uniqueTargets.insert(target);
    }
    assert(uniqueTargets.size() == targets.size());
  };
  for (auto& [location, info] : flowInfoMap) {
    disallowDuplicates(info.targets);
  }
#endif

  // The work remaining to do: locations that we just updated, which means we
  // should update their children when we pop them from this queue.
  UniqueDeferredQueue<Location> work;

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "roots phase\n";
#endif

  // Set up the roots, which are the starting state for the flow analysis.
  for (const auto& [location, value] : roots) {
#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
    std::cout << "  init root\n";
    dump(location);
    value.dump(std::cout);
    std::cout << '\n';
#endif
    flowInfoMap[location].types = value;
    work.push(location);
  }

#ifdef POSSIBLE_TYPES_DEBUG
  std::cout << "flow phase\n";
#endif

  // Flow the data.
  while (!work.empty()) {
    auto location = work.pop();
    const auto& info = flowInfoMap[location];

    // TODO: We can refine the types here, by not flowing anything through a
    //       ref.cast that it would trap on.
    const auto& types = info.types;

#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
    std::cout << "pop item\n";
    dump(location);
#endif

    // Update types from an input to an output, and add more work if we found
    // any.
    auto updateTypes = [&](Location input,
                           const PossibleContents& inputContents,
                           Location target,
                           PossibleContents& targetContents) {
      if (inputContents.isNone()) {
        return;
      }
#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
      std::cout << "    updateTypes src:\n";
      inputContents.dump(std::cout);
      std::cout << '\n';
      std::cout << "    updateTypes dest:\n";
      targetContents.dump(std::cout);
      std::cout << '\n';
#endif
      if (targetContents.combine(inputContents)) {
        // We inserted something, so there is work to do in this target.
        work.push(target);
#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
        std::cout << "    more work\n";
#endif
      }
    };

    const auto& targets = info.targets;
    if (targets.empty()) {
      continue;
    }

    // We may add new connections as we go. Do so to a temporary structure on
    // the side as we are iterating on |targets| here, which might be one of the
    // lists we want to update.
    std::vector<Connection> newConnections;

    // Update the targets, and add the ones that change to the remaining work.
    for (auto& target : targets) {
#if defined(POSSIBLE_TYPES_DEBUG) && POSSIBLE_TYPES_DEBUG >= 2
      std::cout << "  send to target\n";
      dump(target);
#endif

      auto& targetContents = flowInfoMap[target].types;

      if (auto* targetExprLoc = std::get_if<ExpressionLocation>(&location)) {
        auto* targetExpr = targetExprLoc->expr;
        auto iter = childParents.find(targetExpr);
        if (iter != childParents.end()) {
          // The target is one of the special cases where it is an expression
          // for whom we must know the parent in order to handle things in a
          // special manner.
          auto* parent = iter->second;

          // When handling these special cases we care about what actually
          // changed, so save the state before doing the update.
          auto oldTargetContents = targetContents;
          updateTypes(location, types, target, targetContents);
          if (oldTargetContents == targetContents) {
            // Nothing changed; nothing more to do.
            continue;
          }

          // Something changed, handle the special cases.

          auto type = targetContents.getType().getHeapType();

          if (auto* get = parent->dynCast<StructGet>()) {
            assert(get->ref == targetExpr);
            // This is the reference child of a struct.get, and we have just
            // added new contents to that reference. That means that the
            // struct.get can read from more locations, for example because no
            // type was possible here before but now one is, so we need to add
            // the contents possible in that type's field here. Not only do we
            // need to update those values now, but any future change to the
            // contents possible in that type's field will impact us, so create
            // new connections in the graph.
            // TODO: A less simple but more memory-efficient approach might be
            //       to keep special data structures on the side for such
            //       "dynamic" information, basically a list of all struct.gets
            //       impacted by each type, etc., and use those in the proper
            //       places. Then each location would have not just a list of
            //       target locations but also a list of target expressions
            //       perhaps, etc.
            if (oldTargetContents.isNone()) {
              // Nothing was present before, so we can just add the new stuff.
              assert(!targetContents.isNone());
              if (targetContents.isType()) {
                // A single new type was added here. Add a link from its field
                // to this get.
                newConnections.push_back({
                  StructLocation{type, get->index},
                  target
                });
              } else {
                // Many types are possible here. We will need to assume the
                // worst, which is any subtype of the type on the struct.get.
                assert(targetContents.isMany());
                // TODO: caching of AllSubTypes lists?
                for (auto subType : subTypes.getAllSubTypes(type)) {
                  newConnections.push_back({
                    StructLocation{subType, get->index},
                    target
                  });
                }
              }
            } else {
              // Something was present before, but now there is more. Atm there
              // is just one such case, a single type that is now many.
              assert(oldTargetContents.isType());
              assert(targetContents.isMany());
              auto oldType = oldTargetContents.getType();
              for (auto subType : subTypes.getAllSubTypes(type)) {
                if (subType != oldType) {
                  newConnections.push_back({
                    StructLocation{subType, get->index},
                    target
                  });
                }
              }
            }
          } else {
            WASM_UNREACHABLE("bad childParents content");
          }

          continue;
        }
      }

      // Otherwise, this is not a special case, and just do the update.
      updateTypes(location, types, target, targetContents);
    }

    // Update any new connections
    newConnections..
#ifndef NDEBUG
    disallowDuplicates(..);
#endif
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm).
}

} // namespace wasm

/*
TODO: w.wasm failure on LIMIT=1
TODO: null deref at runtime on j2wasm output
*/
