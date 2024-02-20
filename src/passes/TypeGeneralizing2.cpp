/*
 * Copyright 2023 WebAssembly Community Group participants
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
// This is an alternative implementation of TypeGeneralizing, for comparison and
// exploration.
//
// Generalize the types of program locations as much as possible, both to
// eliminate unnecessarily refined types from the type section and (TODO) to
// weaken casts that cast to unnecessarily refined types. If the casts are
// weakened enough, they will be able to be removed by OptimizeInstructions.
//
// Perform an analysis on the types of program to discover how much the type of
// each location can be generalized without breaking validation or changing
// program behavior. The analysis is a basic flow operation: we find the
// "static", unavoidable constraints and consider them roots, and then flow from
// there to affect everything else. For example, when we update the type of a
// block then the block's last child must then be flowed to, as the child must
// be a subtype of the block, etc.
//

#include "analysis/lattices/valtype.h"
#include "ir/possible-contents.h"
#include "ir/subtype-exprs.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-traversal.h"
#include "wasm.h"

#define TYPEGEN_DEBUG 0

#if TYPEGEN_DEBUG
#define DBG(statement) statement
#else
#define DBG(statement)
#endif

namespace wasm {

namespace {

struct TypeGeneralizing
  : WalkerPass<ControlFlowWalker<TypeGeneralizing,
                                 SubtypingDiscoverer<TypeGeneralizing>>> {
  using Super = WalkerPass<
    ControlFlowWalker<TypeGeneralizing, SubtypingDiscoverer<TypeGeneralizing>>>;

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TypeGeneralizing>();
  }

  // Visitors during the walk. We purposefully do not visit the super of any of
  // these.

  // We track local operations so that we can optimize them later.
  void visitLocalGet(LocalGet* curr) { gets.push_back(curr); }
  void visitLocalSet(LocalSet* curr) {
    sets.push_back(curr);

    // If this is a parameter then we cannot modify it, and so we add a root
    // here: the value written to the param must be a subtype of the never-to-
    // change param type.
    if (getFunction()->isParam(curr->index)) {
      addRoot(curr->value, getFunction()->getLocalType(curr->index));
    }
  }

  std::vector<LocalGet*> gets;
  std::vector<LocalSet*> sets;

  void visitStructGet(StructGet* curr) {
    // Connect the reference to us. As the reference becomes more refined, so do
    // we. This is handled in the transfer function.
    connectSrcToDest(curr->ref, curr);
  }
  void visitStructSet(StructSet* curr) {
    auto refType = curr->ref->type;
    if (!refType.isStruct()) {
      // This is a bottom type or unreachable. Do not allow the ref to change.
      addRoot(curr->ref, refType);
      return;
    }

    // Find the constraint on the ref and value and apply them. Note that these
    // do not need any dynamic handling, because a struct.set implies
    // mutability, which implies the field's type is identical in all supers and
    // subs due to how the wasm type system works.
    auto minimalRefType =
      getLeastRefinedStruct(refType.getHeapType(), curr->index);
    addRoot(curr->ref, Type(minimalRefType, Nullable));
    const auto& fields = minimalRefType.getStruct().fields;
    addRoot(curr->value, fields[curr->index].type);
  }

  void requireNonBasicArray(Expression* ref) {
    if (!ref->type.isArray()) {
      self()->noteSubtype(ref, ref->type);
      return;
    }
    auto heapType = getLeastRefinedArray(ref->type.getHeapType());
    self()->noteSubtype(ref, Type(heapType, Nullable));
  }
  void requireBasicArray(Expression* ref) {
    if (!ref->type.isArray()) {
      self()->noteSubtype(ref, ref->type);
      return;
    }
    self()->noteSubtype(ref, Type(HeapType::array, Nullable));
  }

  void visitArrayGet(ArrayGet* curr) {
    // As with StructGet, this is handled in the transfer function.
    connectSrcToDest(curr->ref, curr);
  }
  void visitArraySet(ArraySet* curr) {
    requireNonBasicArray(curr->ref);
    Super::visitArraySet(curr);
  }
  void visitArrayLen(ArrayLen* curr) { requireBasicArray(curr->ref); }
  void visitArrayCopy(ArrayCopy* curr) {
    // Start minimal; see the next comment for more.
    requireNonBasicArray(curr->destRef);
    requireNonBasicArray(curr->srcRef);
    // As the dest ref refines, we may need to refine the source ref. Connect
    // those two through the copy, and we will handle that in the transfer
    // function (the copy itself has no value, and we will calculate the change
    // for the dest there and apply it; we do not connect the source to the dest
    // directly because the copy mediates between them and defines in what
    // manner the source affects the dest).
    connectSrcToDest(curr, curr->destRef);
    connectSrcToDest(curr->srcRef, curr);
  }
  void visitArrayFill(ArrayFill* curr) {
    requireNonBasicArray(curr->ref);
    Super::visitArrayFill(curr);
  }
  void visitArrayInitData(ArrayInitData* curr) {
    requireNonBasicArray(curr->ref);
  }
  void visitArrayInitElem(ArrayInitElem* curr) {
    requireNonBasicArray(curr->ref);
    Super::visitArrayInitElem(curr);
  }

  // Hooks that are called by SubtypingDiscoverer.

  void noteSubtype(Type sub, Type super) {
    // Nothing to do; a totally static and fixed constraint.
  }
  void noteSubtype(HeapType sub, HeapType super) {
    // As above.
  }
  void noteSubtype(Expression* sub, Type super) {
    // This expression's type must be a subtype of a fixed type, so it is a
    // root.
    addRoot(sub, super);
  }
  void noteSubtype(Type sub, Expression* super) {
    // A fixed type that must be a subtype of an expression's type. We do not
    // need to do anything here, as we will just be generalizing expression
    // types, so we will not break these constraints.
  }
  void noteSubtype(Expression* sub, Expression* super) {
    // Two expressions with subtyping between them. Add a link in the graph so
    // that we flow requirements along.
    connectSrcToDest(sub, super);
  }

  void noteCast(HeapType src, HeapType dest) {
    // Same as in noteSubtype.
  }
  void noteCast(Expression* src, Type dest) {
    // Same as in noteSubtype.
  }
  void noteCast(Expression* src, Expression* dest) {
    if (dest->is<RefCast>()) {
      // All a cast requires of its input is that it have the proper top type so
      // it can be cast. TODO: Can we do better? Nullability?
      addRoot(
        src,
        Type(dest->type.getHeapType().getTop(), dest->type.getNullability()));
    } else if (dest->is<RefAs>()) {
      // Handle this in an optimal manner in the transfer function.
      connectSrcToDest(src, dest);
    }
  }

  // Internal graph for the flow. We track the predecessors so that we know who
  // to update after updating a location. For example, when we update the type
  // of a block then the block's last child must then be flowed to, so the child
  // is a pred of the block. We also track successors so that we can tell where
  // to read updates from (which the transfer function needs in some cases).
  // TODO: SmallVector<1>s?
  std::unordered_map<Location, std::vector<Location>> preds;
  std::unordered_map<Location, std::vector<Location>> succs;

  // Connect a source location to where that value arrives. For example, a
  // block's last element arrives in the block.
  void connectSrcToDest(Expression* src, Expression* dest) {
    connectSrcToDest(getLocation(src), getLocation(dest));
  }

  void connectSrcToDest(const Location& srcLoc, const Location& destLoc) {
    DBG({
      std::cerr << "Connecting ";
      dump(srcLoc);
      std::cerr << " to ";
      dump(destLoc);
    });
    preds[destLoc].push_back(srcLoc);
    succs[srcLoc].push_back(destLoc);
  }

  Location getLocation(Expression* expr) {
    // TODO: tuples
    return ExpressionLocation{expr, 0};
  }

  // The analysis we do here is on types: each location will monotonically
  // increase until all locations stabilize at the fixed point.
  analysis::ValType typeLattice;

  using LatticeElement = analysis::ValType::Element;

  // The roots in the graph: constraints that we know from the start and from
  // which the flow begins. Each root is a location and its type.
  std::unordered_map<Location, LatticeElement> roots;

  void addRoot(Expression* expr, LatticeElement type) {
    if (!type.isRef()) {
      return;
    }
    // There may already exist a type for a particular root, so merge them in,
    // in the same manner as during the flow (a meet).
    typeLattice.meet(roots[getLocation(expr)], type);
  }

  // The types of locations as we discover them. When the flow is complete,
  // these are the final types.
  std::unordered_map<Location, LatticeElement> locTypes;

  // A list of locations to process. When we process one, we compute the
  // transfer function for it and set up any further flow.
  UniqueDeferredQueue<Location> toFlow;

  // After we update a location's type, this function sets up the flow to
  // reach all preds.
  void flowFrom(Location loc) {
    DBG({
      std::cerr << "Flowing from ";
      dump(loc);
    });
    for (auto dep : preds[loc]) {
      DBG({
        std::cerr << "  to ";
        dump(dep);
      });
      toFlow.push(dep);
    }
  }

  // Update a location, that is, apply the transfer function there. This reads
  // the information that affects this location and computes the new type there.
  // If the type changed, then apply it and flow onwards.
  //
  // We are given the values at successor locations, that is, the values that
  // influence us and that we read from to compute our new value. We are also
  // given the locations they arrive from, or an empty optional if this is a
  // root (roots are the initial values where the flow begins).
  void update(Location loc,
              std::vector<LatticeElement> succValues,
              std::optional<std::vector<Location>> succLocs) {
    DBG({
      std::cerr << "Updating \n";
      dump(loc);
    });

    // Some successors have special handling. Where such handling exists, it
    // updates |succValues| for the processing below (which typically ends up
    // being used in the generic meet operation, but there is customization in
    // some cases there as well) and may also update |loc| (if the location to
    // be updated is different).
    if (succLocs && succLocs->size() == 1) {
      auto succLoc = (*succLocs)[0];
      auto& succValue = succValues[0];
      if (auto* exprLoc = std::get_if<ExpressionLocation>(&succLoc)) {
        if (auto* get = exprLoc->expr->dynCast<StructGet>()) {
          // The situation is this:
          //
          //  (struct.get K  ;; succLoc
          //   (loc)         ;; loc
          //  )
          //
          // That is, our successor is a struct.get, so we are the reference of
          // that struct.get.
          succValue = transferStructGet(succValue, get->ref, get->index);
        } else if (auto* get = exprLoc->expr->dynCast<ArrayGet>()) {
          succValue = transferArrayGet(succValue, get->ref);
        } else if (auto* copy = exprLoc->expr->dynCast<ArrayCopy>()) {
          succValue = transferArrayCopy(succValue, copy);
        }
      }
    }

    DBG({
      for (auto value : succValues) {
        std::cerr << "  succ value: " << ModuleType(*getModule(), value)
                  << '\n';
      }
    });

    auto& locType = locTypes[loc];
    auto old = locType;

    // Some locations have special handling.
    bool handled = false;
    if (auto* exprLoc = std::get_if<ExpressionLocation>(&loc)) {
      if (auto* refAs = exprLoc->expr->dynCast<RefAs>()) {
        // There is a single successor (the place this RefAs sends a value
        // to).
        auto succType = succValues[0];
        switch (refAs->op) {
          case RefAsNonNull:
            // ref.as_non_null does not require its input to be non-nullable -
            // all it does is enforce non-nullability - but it does pass along
            // the heap type requirement. (We do not need to do a meet
            // operation here because our monotonicity is proven by succ's.)
            locType = Type(succType.getHeapType(), Nullable);
            break;
          case ExternInternalize:
            // Internalize accepts any input of heap type extern. Pass along
            // the nullability of the successor (whose monotonicity proves
            // ours).
            locType = Type(HeapType::ext, succType.getNullability());
            break;
          case ExternExternalize:
            locType = Type(HeapType::any, succType.getNullability());
            break;
        }
        handled = true;
      }
    }
    if (!handled) {
      // Perform a generic meet operation over all successors.
      for (auto value : succValues) {
        DBG({
          std::cerr << "  old: " << ModuleType(*getModule(), locType)
                    << " new: " << ModuleType(*getModule(), value) << "\n";
        });
        if (typeLattice.meet(locType, value)) {
          DBG({
            std::cerr << "    result: " << ModuleType(*getModule(), locType)
                      << "\n";
          });
        }
      }
    }
    if (locType != old) {
      // We changed something here, so flow onwards.
      flowFrom(loc);

#ifndef NDEBUG
      // Verify monotonicity.
      assert(typeLattice.compare(locType, old) == analysis::LESS);
#endif
    }
  }

  // Given a struct.get operation, this receives the type the get must emit, the
  // reference child of the struct.get, and the index it operates on. It then
  // computes the type for the reference and returns that. This forms the core
  // of the transfer logic for a struct.get.
  LatticeElement
  transferStructGet(Type outputType, Expression* ref, Index index) {
    if (!ref->type.isStruct()) {
      return ref->type;
    }

    // Get the least-refined struct type that still has (at least) the necessary
    // type for that field. This is monotonic because as the field type
    // refines we will return something more refined (or equal) here.
    auto heapType =
      getLeastRefinedStruct(ref->type.getHeapType(), index, outputType);
    return Type(heapType, Nullable);
  }

  // Return the least refined struct type parent of a given type that still has
  // a particular field, and if a field type is provided, that also has a field
  // that is at least as refined as the given one.
  HeapType getLeastRefinedStruct(HeapType curr,
                                 Index index,
                                 std::optional<Type> fieldType = {}) {
    while (true) {
      auto next = curr.getDeclaredSuperType();
      if (!next) {
        // There is no super.
        break;
      }
      const auto& fields = next->getStruct().fields;
      if (index >= fields.size() ||
          (fieldType && !Type::isSubType(fields[index].type, *fieldType))) {
        // There is no field at that index, or it is unsuitable.
        break;
      }
      curr = *next;
    }
    return curr;
  }

  LatticeElement transferArrayGet(LatticeElement outputType, Expression* ref) {
    if (!ref->type.isArray()) {
      return ref->type;
    }

    auto heapType = getLeastRefinedArray(ref->type.getHeapType(), outputType);
    return Type(heapType, Nullable);
  }

  // Given a new type for the source of an ArrayCopy, compute the new type for
  // the dest.
  LatticeElement transferArrayCopy(LatticeElement destType, ArrayCopy* copy) {
    if (!destType.isArray()) {
      // No constraint here.
      return Type(HeapType::array, Nullable);
    }
    // Similar to ArrayGet: We know the current output type, and can compute
    // the input/dest.
    auto destElementType = destType.getHeapType().getArray().element.type;
    return transferArrayGet(destElementType, copy->srcRef);
  }

  // Similar to getLeastRefinedStruct.
  HeapType getLeastRefinedArray(HeapType curr,
                                std::optional<Type> elementType = {}) {
    while (true) {
      auto next = curr.getDeclaredSuperType();
      if (!next) {
        // There is no super.
        break;
      }
      if (elementType &&
          !Type::isSubType(next->getArray().element.type, *elementType)) {
        // The element is not suitable.
        break;
      }
      curr = *next;
    }
    return curr;
  }

  void visitFunction(Function* func) {
    Super::visitFunction(func);

    DBG({ std::cerr << "TypeGeneralizing: " << func->name << "\n"; });

    // Finish setting up the graph: LocalLocals are "abstract" things that we
    // did not walk, so set them up manually. Each LocalLocation is connected
    // to the sets and gets for that index.
    for (auto* get : gets) {
      // This is not true subtyping here - really these have the same type - but
      // this sets up the connections between them. This is important to prevent
      // quadratic size of the graph: N gets for an index are connected to the
      // single location for that index, which is connected to M sets for it,
      // giving us N + M instead of N * M (which we'd get if we connected gets
      // to sets directly).
      connectSrcToDest(LocalLocation{func, get->index}, getLocation(get));
    }
    for (auto* set : sets) {
      connectSrcToDest(getLocation(set->value),
                       LocalLocation{func, set->index});
      if (set->type.isConcrete()) {
        // This is a tee with a value, and that value shares the location of
        // the local.
        connectSrcToDest(LocalLocation{func, set->index}, getLocation(set));
      }
    }

    // Set up locals.
    auto numLocals = func->getNumLocals();
    for (Index i = 0; i < numLocals; i++) {
      auto type = func->getLocalType(i);
      if (type.isRef()) {
        if (func->isParam(i)) {
          // We cannot alter params.
          locTypes[LocalLocation{func, i}] = type;
        } else {
          // Start each var with the top type. If we see nothing else, that is
          // what will remain.
          locTypes[LocalLocation{func, i}] =
            Type(type.getHeapType().getTop(), Nullable);
        }
      }
    }

    // First, apply the roots. Each is an update of a location with a single
    // successor, the type we start that root from.
    for (auto& [loc, value] : roots) {
      DBG({
        std::cerr << "root: " << value << "\n";
        dump(loc);
      });
      update(loc, {value}, {});
    }

    // Second, perform the flow: iteratively get an location that might change
    // when we update it, as its successors changed, and if it does queue to
    // flow from there.
    while (!toFlow.empty()) {
      auto loc = toFlow.pop();
      auto& succLocs = succs[loc];
      std::vector<LatticeElement> succValues;
      for (auto& succ : succLocs) {
        succValues.push_back(locTypes[succ]);
      }
      update(loc, succValues, succLocs);
    }

    // Finally, apply the results of the flow: the types at LocalLocations are
    // now the types of the locals.
    auto numParams = func->getNumParams();
    for (Index i = numParams; i < numLocals; i++) {
      auto& localType = func->vars[i - numParams];
      if (localType.isRef()) {
        localType = locTypes[LocalLocation{func, i}];
        assert(localType.isRef());
      }
    }
    for (auto* get : gets) {
      get->type = func->getLocalType(get->index);
    }
    for (auto* set : sets) {
      if (set->type.isRef()) {
        set->type = func->getLocalType(set->index);
      }
    }

    // TODO: avoid when not needed
    ReFinalize().walkFunctionInModule(func, getModule());
  }

#ifdef TYPEGEN_DEBUG
  void dump(const Location& loc) {
    if (auto* exprLoc = std::get_if<ExpressionLocation>(&loc)) {
      std::cerr << "exprLoc  " << ModuleExpression(*getModule(), exprLoc->expr)
                << '\n';
    } else if (auto* localLoc = std::get_if<LocalLocation>(&loc)) {
      std::cerr << "localloc " << localLoc->index << '\n';
    } else {
      std::cerr << "unknown location\n";
    }
  }
#endif
};

} // anonymous namespace

Pass* createTypeGeneralizing2Pass() { return new TypeGeneralizing; }

} // namespace wasm
