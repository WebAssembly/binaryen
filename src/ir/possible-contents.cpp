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

// We are going to do a very large flow operation, potentially, as we create
// a Location for every interesting part in the entire wasm, and some of those
// places will have lots of links (like a struct field may link out to every
// single struct.get of that type), so we must make the data structures here
// as efficient as possible. Towards that goal, we work with location
// *indexes* where possible, which are small (32 bits) and do not require any
// complex hashing when we use them in sets or maps.
//
// Note that we do not use indexes everywhere, since the initial analysis is
// done in parallel, and we do not have a fixed indexing of locations yet. When
// we merge the parallel data we create that indexing, and use indexes from then
// on.
using LocationIndex = uint32_t;

#ifndef NDEBUG
template<typename T> void disallowDuplicates(const T& targets) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::unordered_set<LocationIndex> uniqueTargets;
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
  } else if (auto* loc = std::get_if<SpecialLocation>(&location)) {
    std::cout << "  Specialloc " << loc->index << '\n';
  } else {
    std::cout << "  (other)\n";
  }
}
#endif

// A link indicates a flow of content from one location to another. For
// example, if we do a local.get and return that value from a function, then
// we have a link from a LocalLocaiton to a ResultLocation.
template<typename T> struct Link {
  T from;
  T to;

  bool operator==(const Link<T>& other) const {
    return from == other.from && to == other.to;
  }
};

using LocationLink = Link<Location>;
using IndexLink = Link<LocationIndex>;

} // anonymous namespace

} // namespace wasm

namespace std {

template<> struct hash<wasm::LocationLink> {
  size_t operator()(const wasm::LocationLink& loc) const {
    return std::hash<std::pair<wasm::Location, wasm::Location>>{}(
      {loc.from, loc.to});
  }
};

template<> struct hash<wasm::IndexLink> {
  size_t operator()(const wasm::IndexLink& loc) const {
    return std::hash<std::pair<wasm::LocationIndex, wasm::LocationIndex>>{}(
      {loc.from, loc.to});
  }
};

} // namespace std

namespace wasm {

namespace {

// The data we gather from each function, as we process them in parallel. Later
// this will be merged into a single big graph.
struct FuncInfo {
  // All the links we found in this function. Rarely are there duplicates
  // in this list (say when writing to the same global location from another
  // global location), and we do not try to deduplicate here, just store them in
  // a plain array for now, which is faster (later, when we merge all the info
  // from the functions, we need to deduplicate anyhow).
  std::vector<LocationLink> links;

  // All the roots of the graph, that is, places that begin containing some
  // partcular content. That includes *.const, ref.func, struct.new, etc. All
  // possible contents in the rest of the graph flow from such places.
  // The map here is of the root to the value beginning in it.
  std::unordered_map<Location, PossibleContents> roots;

  // See childParents comment elsewhere XXX where?
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
            info.links.push_back({ExpressionLocation{value, i},
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
    if (isRelevant(curr->type)) { // TODO: check this in the called function
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
    // TODO optimize when possible: like RefCast, not all values flow through.
    receiveChildValue(curr->value, curr);
  }

  // Locals read and write to their index.
  // TODO: we could use a LocalGraph for better precision
  void visitLocalGet(LocalGet* curr) {
    if (isRelevant(curr->type)) {
      for (Index i = 0; i < curr->type.size(); i++) {
        info.links.push_back({LocalLocation{getFunction(), curr->index, i},
                              ExpressionLocation{curr, i}});
      }
    }
  }
  void visitLocalSet(LocalSet* curr) {
    if (!isRelevant(curr->value->type)) {
      return;
    }
    for (Index i = 0; i < curr->value->type.size(); i++) {
      info.links.push_back({ExpressionLocation{curr->value, i},
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
    // TODO: the table identity could also be used here
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
        info.links.push_back({ExpressionLocation{operand, 0}, makeTarget(i)});
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

struct Flower {
  Module& wasm;

  Flower(Module& wasm);

  // Maps location indexes to the location stored in them. We also have a map
  // for the reverse relationship (we hope to use that map as little as possible
  // as it requires more work than just using an index).
  std::vector<Location> locations;
  std::unordered_map<Location, LocationIndex> locationIndexes;

  Location getLocation(LocationIndex index) {
    assert(index < locations.size());
    return locations[index];
  }

  // Maps location indexes to the contents in the corresponding locations.
  // TODO: merge with |locations|?
  std::vector<PossibleContents> locationContents;

  PossibleContents& getContents(LocationIndex index) {
    assert(index < locationContents.size());
    return locationContents[index];
  }

  // Maps location indexes to the vector of targets to which that location sends
  // content.
  // TODO: merge with |locations|?
  // Commonly? there is a single target e.g. an expression has a single parent
  // and only sends a value there.
  // TODO: benchmark SmallVector<1> some more, but it seems to not help
  std::vector<std::vector<LocationIndex>> locationTargets;

  std::vector<LocationIndex>& getTargets(LocationIndex index) {
    assert(index < locationTargets.size());
    return locationTargets[index];
  }

  // Convert the data into the efficient LocationIndex form we will use during
  // the flow analysis. This method returns the indx of a location, allocating
  // one if this is the first time we see it.
  LocationIndex getIndex(const Location& location) {
    // New locations may be indexed during the flow, since we add new links
    // during the flow. Allocate indexes and other bookkeeping as necessary.
    auto iter = locationIndexes.find(location);
    if (iter != locationIndexes.end()) {
      return iter->second;
    }

    // Allocate a new index here.
    size_t index = locations.size();
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  new index " << index << " for ";
    dump(location);
#endif
    if (index >= std::numeric_limits<LocationIndex>::max()) {
      // 32 bits should be enough since each location takes at least one byte
      // in the binary, and we don't have 4GB wasm binaries yet... do we?
      Fatal() << "Too many locations for 32 bits";
    }
    locations.push_back(location);
    locationIndexes[location] = index;

    // Update additional data.
    locationContents.resize(locationContents.size() + 1);
    assert(locationContents.size() == locations.size());
    locationTargets.resize(locationTargets.size() + 1);
    assert(locationTargets.size() == locations.size());

    return index;
  }

  IndexLink getIndexes(const LocationLink& link) {
    return {getIndex(link.from), getIndex(link.to)};
  }

  // TODO: would getIndex(Expression*) be faster? We could have a map of
  //       Exprssion -> LocationIndex, and avoid creating a full Location.
  //       that doesn't help Links tho

  // Internals for flow.

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
  // struct.get. To handle such things, we set add a childParent link, and then
  // when we update the child we can handle any possible action regarding the
  // parent.
  std::unordered_map<LocationIndex, LocationIndex> childParents;

  // The work remaining to do during the flow: locations that we are sending an
  // update to. This maps the target location to the new contents, which is
  // efficient since we may send contents A to a target and then send further
  // contents B before we even get to processing that target; rather than queue
  // two work items, we want just one with the combined contents.
  // XXX update docs here, this contains the OLD contents here actually.
  std::unordered_map<LocationIndex, PossibleContents> workQueue;

  // During the flow we will need information about subtyping.
  //
  // XXX
  // We need a *MemoTree*. Each node represents one field in one heap type, in
  // which we store the exact value a get would read, or the cone value a get
  // would read (i.e., a get of that heap type or a subtype - a memo of all
  // subtypes), and the same for sets. All the memoization then lets us do
  // incremental work with maximal efficiency:
  //
  //  * Updating the ref or value of an exact set:
  //    * Update the exact field of that type.
  //    * Update the gets that depend on it.
  //    * Do the same for the cone field of all supertypes, as a read of a cone
  //    of a
  //      super might be reading this type. Go up the supers while the field is
  //      still relevant.
  //  * Updating the ref or value of a cone set:
  //    * Update the exact value of all subtypes, as we might be writing to any
  //      of them.
  //    * Update the cone field of all supertypes, as above.
  //
  // At all times, the cone field in a type must be equal to the sum over all
  // subtypes. It is just a memoization of it. Perhaps we can defer that
  // memoization to the reads?
  //
  //  * Updating the ref of an exact get: Just read the exact value there.
  //  * Updating the ref of a cone exact get: ...
  //  * Either way, add yourself if you aren't already to the readers of the
  //    relevant exact values.
  //  *
  //    * If we have a memoed value for an exact get of that field, use it.
  //    * If we have no value, compute it and write a memory. To compute it,
  //      it is the sum over
  //    * Either way, add the get to the list of exact gets of that field, if
  //      we aren't there already.
  //
  // XXX We should assume the common case is cones on both sets and gets, and
  // try to optimize that. While an exact set or get can be a single operation
  // if we do no memoization, we should probably memoize for the sake of cones.
  // But maybe start with a dedicated data structure of type fields with no
  // memoization, and go from there. In such a struct, exact gets and sets are
  // one operation. A cone set must apply its value to all subtypes, and a cone
  // get must read from all subtypes - O(n) operations.
  //  * However, maybe an even simpler memoization is, for gets, to see if some
  //    other get already exists of what we need. Say we are a cone read of type
  //    A, field 3, then if any other get already exists we've already computed
  //    the value for it - and can just read it. That would actually be the
  //    common case!
  //    But cone sets will still need to write to all subs. I guess a
  //    memoization we can do there is to store a cone marker, with a value: at
  //    A:3 we've applied the value V to the entire cone. That means that if we
  //    are at A:3 - either starting there, or along the way - we need go no
  //    further if our value adds nothing on top of V!

  // Maps a heap type + an index in the type (0 for an array) to the index of a
  // SpecialLocation for a cone read of those contents. XXX move comment to here
  std::unordered_map<std::pair<HeapType, Index>, LocationIndex> canonicalConeReads;

  std::unique_ptr<SubTypes> subTypes;

  // All existing links in the graph. We keep this to know when a link we want
  // to add is new or not.
  std::unordered_set<IndexLink> links;

  // We may add new links as we flow. Do so to a temporary structure on
  // the side to avoid any aliasing as we work.
  std::vector<IndexLink> newLinks;

  // This applies the new contents to the given location, and if something
  // changes it adds a work item to further propagate. TODO rename
  // Returns the combined contents with this change.
  PossibleContents addWork(LocationIndex locationIndex,
                           const PossibleContents& newContents);

  // Slow helper, which should be avoided when possible.
  // FIXME count these with logging and ensure we issue few of these calls
  PossibleContents addWork(const Location& location,
                           const PossibleContents& newContents) {
    return addWork(getIndex(location), newContents);
  }

  // Update a target location with contents arriving to it. Add new work as
  // relevant based on what happens there.
  // XXX comment
  void processWork(LocationIndex locationIndex,
                   const PossibleContents& oldContents);

  void updateNewLinks();
};

Flower::Flower(Module& wasm) : wasm(wasm) {
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

  // Also walk the global module code (for simplicitiy, also add it to the
  // function map, using a "function" key of nullptr).
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
  // the functions. We do so into sets, which deduplicates everything.

  // The roots are not declared in the class as we only need them during this
  // function itself.
  std::unordered_map<Location, PossibleContents> roots;

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "merging phase\n";
#endif

  for (auto& [func, info] : analysis.map) {
    for (auto& link : info.links) {
      links.insert(getIndexes(link));
    }
    for (auto& [root, value] : info.roots) {
      roots[root] = value;
    }
    for (auto [child, parent] : info.childParents) {
      childParents[getIndex(ExpressionLocation{child, 0})] =
        getIndex(ExpressionLocation{parent, 0});
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
      links.insert(getIndexes({SignatureParamLocation{func->type, i},
                               LocalLocation{func.get(), i, 0}}));
    }
    for (Index i = 0; i < func->getResults().size(); i++) {
      links.insert(getIndexes({ResultLocation{func.get(), i},
                               SignatureResultLocation{func->type, i}}));
    }
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "struct phase\n";
#endif

  if (getTypeSystem() == TypeSystem::Nominal) {
    subTypes = std::make_unique<SubTypes>(wasm);
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "indexing phase\n";
#endif

  for (auto& link : links) {
    auto fromIndex = link.from;
    auto toIndex = link.to;

    // Add this link to |locationTargets|.
    getTargets(fromIndex).push_back(toIndex);
  }

  // Roots may appear that have no links to them, so index them as well to make
  // sure everything is covered.
  for (const auto& [location, _] : roots) {
    getIndex(location);
  }

  // TODO: numLocations = locations.size() ?

#ifndef NDEBUG
  // Each vector of targets (which is a vector for efficiency) must have no
  // duplicates.
  for (auto& targets : locationTargets) {
    disallowDuplicates(targets);
  }
#endif

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "roots phase\n";
#endif

  // Set up the roots, which are the starting state for the flow analysis: add
  // work to set up their initial values.
  for (const auto& [location, value] : roots) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "  init root\n";
    dump(location);
    value.dump(std::cout, &wasm);
    std::cout << '\n';
#endif

    addWork(location, value);
  }

#ifdef POSSIBLE_CONTENTS_DEBUG
  std::cout << "flow phase\n";
  size_t iters = 0;
#endif

  // Flow the data.
  while (!workQueue.empty()) {
    // TODO: assert on no cycles - store a set of all (location, value) pairs
    //       we've ever seen.
    // TODO: profile manually to see how much time we spend in each Location
    //       flavor
    // TODO: if we are Many, delete all our outgoing links - we'll never prop
    //       again
    // TODO: make the wokr queue map of location => contents.
#ifdef POSSIBLE_CONTENTS_DEBUG
    iters++;
    if ((iters & 255) == 0) {
      std::cout << iters++ << " iters, work left: " << workQueue.size() << '\n';
    }
#endif

    auto iter = workQueue.begin();
    auto locationIndex = iter->first;
    auto contents = iter->second;
    workQueue.erase(iter);

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "\npop work item\n";
    dump(getLocation(locationIndex));
    std::cout << " with contents \n";
    contents.dump(std::cout, &wasm);
    std::cout << '\n';
#endif

    processWork(locationIndex, contents);

    updateNewLinks();
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm).
}

PossibleContents Flower::addWork(LocationIndex locationIndex,
                                 const PossibleContents& newContents) {
  // The work queue contains the *old* contents, which if they already exist we
  // do not need to alter.
  auto& contents = getContents(locationIndex);
  auto oldContents = contents;
  if (!contents.combine(newContents)) {
    // The new contents did not change anything. Either there is an existing
    // work item but we didn't add anything on top, or there is no work item but
    // we don't add anything on top of the current contents. Either way there is
    // nothing to do.
    return contents;
  }

  // Add a work item if there isn't already.
  // TODO: do this more efficiently with insert.second
  if (!workQueue.count(locationIndex)) {
    workQueue[locationIndex] = oldContents;
  }

  return contents;
}

void Flower::processWork(LocationIndex locationIndex,
                         const PossibleContents& oldContents) {
  const auto location = getLocation(locationIndex);
  auto& contents = locationContents[locationIndex];
  // |contents| is the value after the new data arrives. As something arrives,
  // and we never send nothing around, it cannot be None.
  assert(!contents.isNone());
  // We never update after something is already in the Many state, as that would
  // just be waste for no benefit.
  assert(!oldContents.isMany());
  // We only update when there is a reason.
  assert(contents != oldContents);

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "\nprocessWork src:\n";
  dump(location);
  std::cout << "  arriving:\n";
  contents.dump(std::cout, &wasm);
  std::cout << '\n';
  std::cout << "  existing:\n";
  contents.dump(std::cout, &wasm);
  std::cout << '\n';
#endif

  // Handle special cases: Some locations modify the arriving contents.
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
        //       general. And ImmutableGlobal carries around the type declared
        //       in the global (since that is the type a global.get would get
        //       if we apply this optimization and write a global.get there).

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

  // Something changed!

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
  std::cout << "  something changed!\n";
  contents.dump(std::cout, &wasm);
  std::cout << "\nat ";
  dump(location);
#endif

  // Add all targets this location links to, sending them the new contents. As
  // we do so, prune any targets that end up in the Many state, as there will
  // never be a reason to send them anything again.
  auto& targets = getTargets(locationIndex);

  targets.erase(std::remove_if(targets.begin(),
                               targets.end(),
                               [&](LocationIndex targetIndex) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
                                 std::cout << "  send to target\n";
                                 dump(getLocation(targetIndex));
#endif
                                 return addWork(targetIndex, contents).isMany();
                               }),
                targets.end());
  targets.shrink_to_fit(); // XXX

  if (contents.isMany()) {
    // We just added work to send Many to all our targets. We'll never need to
    // send anything else ever again, but we should have already removed all the
    // targets since we made them Many as well in the above operation.
    assert(targets.empty());
  }

  // We are mostly done, except for handling interesting/special cases in the
  // flow, additional operations that we need to do aside from sending the new
  // contents to the linked targets.

  if (auto* targetExprLoc = std::get_if<ExpressionLocation>(&location)) {
    auto* targetExpr = targetExprLoc->expr;
    auto iter = childParents.find(locationIndex);
    if (iter != childParents.end()) {
      // The target is one of the special cases where it is an expression
      // for whom we must know the parent in order to handle things in a
      // special manner.
      auto parentIndex = iter->second;
      auto* parent =
        std::get<ExpressionLocation>(getLocation(parentIndex)).expr;

#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
      std::cout << "  special, parent:\n" << *parent << '\n';
#endif

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
        auto newLink = LocationLink{*heapLoc, targetLoc};
        auto newIndexLink = getIndexes(newLink);
        if (links.count(newIndexLink) == 0) {
          newLinks.push_back(newIndexLink);
          links.insert(newIndexLink);
        }

        // Add a work item to receive the new contents there now.
        addWork(targetLoc, getContents(getIndex(*heapLoc)));
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
      // TODO: it seems like we don't need getLocation to return optional, see
      //       asserts.
      auto readFromNewLocations =
        [&](std::function<std::optional<Location>(HeapType)> getLocation,
            Index fieldIndex,
            HeapType declaredRefType) {
          if (contents.isNull()) {
            // Nothing is read here.
            return;
          }
          if (contents.isExactType()) {
            // Add a single link to this exact location.
            auto heapLoc = getLocation(contents.getType().getHeapType());
            assert(heapLoc);
            readFromHeap(*heapLoc, parent);
          } else {
            // Otherwise, this is a cone: the declared type of the reference, or
            // any subtype of that, as both Many and ConstantGlobal reduce to
            // that in this case TODO text
            // TODO: the ConstantGlobal case may have a different cone type than
            //       the declaredRefType, we could use that here.
            assert(contents.isMany() || contents.isConstantGlobal());

            // TODO: a cone with no subtypes needs no canonical location, just
            //       add direct links

            // We introduce a special location for a cone read, because what we
            // need here are N links, from each of the N subtypes - and we need
            // that for each struct.get of a cone. If there are M such gets then
            // we have N * M edges for this. Instead, make a single canonical
            // "cone read" location, and add a single link to it from here.
            auto& coneReadIndex = canonicalConeReads[std::pair<HeapType, Index>(declaredRefType, fieldIndex)];
            if (coneReadIndex == 0) {
              // 0 is an impossible index for a LocationIndex (as there must be
              // something at index 0 already - the ExpressionLocation of this
              // very expression, in particular), so we can use that as an
              // indicator that we have never allocated one yet, and do so now.
              // Use locationIndexes.size() as the internal index FIXME nice API
              auto coneRead = SpecialLocation{Index(locationIndexes.size())};
              coneReadIndex = getIndex(coneRead);
              assert(coneRead.index == coneReadIndex);
              // TODO: if the old contents here were an exact type then we could
              // remove the old link, which becomes redundant now. But removing
              // links is not efficient, so maybe not worth it.
              for (auto type : subTypes->getAllSubTypesInclusive(declaredRefType)) {
                auto heapLoc = getLocation(type);
                assert(heapLoc);
                auto newLink = LocationLink{*heapLoc, coneRead};
                auto newIndexLink = getIndexes(newLink);
                // TODO: helper for this "add link" pattern, including the addWork
                assert(links.count(newIndexLink) == 0);
                newLinks.push_back(newIndexLink);
                links.insert(newIndexLink);
                addWork(coneReadIndex, getContents(getIndex(*heapLoc)));
              }
            }

            // Link to the canonical location.
            auto newLink = LocationLink{SpecialLocation{coneReadIndex}, ExpressionLocation{parent, 0}};
            auto newIndexLink = getIndexes(newLink);
            // Check if this link exists already - we may have been a
            // ConstantGlobal that becomes a Many, and the type may have been
            // identical.
            if (links.count(newIndexLink) == 0) {
              newLinks.push_back(newIndexLink);
              links.insert(newIndexLink);
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
      // struct.set/array.set operation.
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
          auto refContents = getContents(getIndex(ExpressionLocation{ref, 0}));
          auto valueContents =
            getContents(getIndex(ExpressionLocation{value, 0}));
          if (refContents.isNone()) {
            return;
          }
          if (refContents.isExactType() || refContents.isConstant()) {
            // Update the one possible type here.
            // TODO: In the case that this is a constant, it could be null
            //       or an immutable global, which we could do even more
            //       with.
            auto heapLoc = getLocation(refContents.getType().getHeapType());
            assert(heapLoc);
            if (heapLoc) {
              addWork(*heapLoc, valueContents);
            }
          } else {
            assert(refContents.isMany());
            // Update all possible types here. First, subtypes, including the
            // type itself.
            auto type = ref->type.getHeapType();
            for (auto subType : subTypes->getAllSubTypesInclusive(type)) {
              auto heapLoc = getLocation(subType);
              assert(heapLoc);
              if (heapLoc) {
                addWork(*heapLoc, valueContents);
              }
            }
          }
        };

      if (auto* get = parent->dynCast<StructGet>()) {
        // This is the reference child of a struct.get.
        assert(get->ref == targetExpr);
        readFromNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            if (!type.isStruct()) {
              return {};
            }
            if (get->index >= type.getStruct().fields.size()) {
              // This field is not present on this struct.
              return {};
            }
            return StructLocation{type, get->index};
          },
          get->index,
          get->ref->type.getHeapType());
      } else if (auto* set = parent->dynCast<StructSet>()) {
        // This is either the reference or the value child of a struct.set.
        // A change to either one affects what values are written to that
        // struct location, which we handle here.
        assert(set->ref == targetExpr || set->value == targetExpr);
        writeToNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            if (!type.isStruct()) {
              return {};
            }
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
            if (!type.isArray()) {
              return {};
            }
            return ArrayLocation{type};
          },
          0,
          get->ref->type.getHeapType());
      } else if (auto* set = parent->dynCast<ArraySet>()) {
        assert(set->ref == targetExpr || set->value == targetExpr);
        writeToNewLocations(
          [&](HeapType type) -> std::optional<Location> {
            if (!type.isArray()) {
              return {};
            }
            return ArrayLocation{type};
          },
          set->ref,
          set->value);
      } else if (auto* cast = parent->dynCast<RefCast>()) {
        assert(cast->ref == targetExpr);
        // RefCast only allows valid values to go through: nulls and things of
        // the cast type. Filter anything else out.
        bool isMany = contents.isMany();
        PossibleContents filtered;
        if (isMany) {
          // Just pass the Many through.
          // TODO: we could emit a cone type here when we get one, instead of
          //       emitting a Many in any of these code paths
          filtered = contents;
        } else {
          auto intendedType = cast->getIntendedType();
          bool mayBeSubType =
            HeapType::isSubType(contents.getType().getHeapType(), intendedType);
          if (mayBeSubType) {
            // The contents are not Many, but they may be a subtype, so they are
            // something like an exact type that is a subtype. Pass that
            // through. (When we get cone types, we could filter the cone here.)
            filtered.combine(contents);
          }
          bool mayBeNull = contents.getType().isNullable();
          if (mayBeNull) {
            filtered.combine(PossibleContents(
              Literal::makeNull(Type(intendedType, Nullable))));
          }
        }
        if (!filtered.isNone()) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
          std::cout << "    ref.cast passing through\n";
#endif
          addWork(ExpressionLocation{parent, 0}, filtered);
        }
        // TODO: ref.test and all other casts can be optimized (see the cast
        //       helper code used in OptimizeInstructions and RemoveUnusedBrs)
      } else {
        WASM_UNREACHABLE("bad childParents content");
      }
    }
  }
}

void Flower::updateNewLinks() {
  // Update any new links.
  for (auto newLink : newLinks) {
#if defined(POSSIBLE_CONTENTS_DEBUG) && POSSIBLE_CONTENTS_DEBUG >= 2
    std::cout << "\nnewLink:\n";
    dump(getLocation(newLink.from));
    dump(getLocation(newLink.to));
#endif

    auto& targets = getTargets(newLink.from);
    targets.push_back(newLink.to);

#ifndef NDEBUG
    disallowDuplicates(targets);
#endif
  }
  newLinks.clear();
}

} // anonymous namespace

void ContentOracle::analyze() {
  Flower flower(wasm);
  for (LocationIndex i = 0; i < flower.locations.size(); i++) {
    locationContents[flower.getLocation(i)] = flower.getContents(i);
  }
}

} // namespace wasm
