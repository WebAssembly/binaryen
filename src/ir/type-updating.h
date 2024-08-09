/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_type_updating_h
#define wasm_ir_type_updating_h

#include "ir/branch-utils.h"
#include "ir/module-utils.h"
#include "support/insert_ordered.h"
#include "wasm-traversal.h"

namespace wasm {

//
// A class that tracks type dependencies between nodes, letting you update types
// efficiently when removing and altering code incrementally.
//
// Altering code can alter types beyond the current node in the following ways:
//
//  1. Removing a break can make a block unreachable, if nothing else reaches
//     it.
//  2. Altering the type of a child to unreachable can make the parent
//     unreachable.
//
// Most passes don't do either of the above and can just do replaceCurrent when
// replacing one thing with another, which is fine as no types need to be
// updated outside of the item being replaced. Passes that do one of the two
// things mentioned need to update types in the IR affected by the change (which
// can include any of the parent nodes, in general) and they have two main ways
// to do so:
//
//  * Call ReFinalize() after making all their changes. The IR will be in an
//    invalid state while making the changes, and only fixed up at the end by
//    ReFinalize(), but often that is good enough.
//  * Use this class, TypeUpdater. This lets you update the IR after each
//    incremental change that you perform, keeping the IR valid constantly.
//
struct TypeUpdater
  : public ExpressionStackWalker<TypeUpdater,
                                 UnifiedExpressionVisitor<TypeUpdater>> {
  // Part 1: Scanning

  // track names to their blocks, so that when we remove a break to
  // a block, we know how to find it if we need to update it
  struct BlockInfo {
    Block* block = nullptr;
    int numBreaks = 0;
  };
  std::map<Name, BlockInfo> blockInfos;

  // track the parent of each node, as child type changes may lead to
  // unreachability
  std::map<Expression*, Expression*> parents;

  void visitExpression(Expression* curr) {
    if (expressionStack.size() > 1) {
      parents[curr] = expressionStack[expressionStack.size() - 2];
    } else {
      parents[curr] = nullptr; // this is the top level
    }
    // discover block/break relationships
    if (auto* block = curr->dynCast<Block>()) {
      if (block->name.is()) {
        blockInfos[block->name].block = block;
      }
    } else {
      BranchUtils::operateOnScopeNameUses(curr, [&](Name& name) {
        // ensure info exists, discoverBreaks can then fill it
        blockInfos[name];
      });
    }
    // add a break to the info, for break and switch
    discoverBreaks(curr, +1);
  }

  // Part 2: Updating

  // Node replacements, additions, removals and type changes should be noted. An
  // exception is nodes you know will never be looked at again.

  // note the replacement of one node with another. this should be called
  // after performing the replacement.
  // this does *not* look into the node by default. see
  // noteReplacementWithRecursiveRemoval (we don't support recursive addition
  // because in practice we do not create new trees in the passes that use this,
  // they just move around children)
  void noteReplacement(Expression* from,
                       Expression* to,
                       bool recursivelyRemove = false) {
    auto parent = parents[from];
    if (recursivelyRemove) {
      noteRecursiveRemoval(from);
    } else {
      noteRemoval(from);
    }
    // if we are replacing with a child, i.e. a node that was already present
    // in the ast, then we just have a type and parent to update
    if (parents.find(to) != parents.end()) {
      parents[to] = parent;
      if (from->type != to->type) {
        propagateTypesUp(to);
      }
    } else {
      noteAddition(to, parent, from);
    }
  }

  void noteReplacementWithRecursiveRemoval(Expression* from, Expression* to) {
    noteReplacement(from, to, true);
  }

  // note the removal of a node
  void noteRemoval(Expression* curr) {
    noteRemovalOrAddition(curr, nullptr);
    parents.erase(curr);
  }

  // note the removal of a node and all its children
  void noteRecursiveRemoval(Expression* curr) {
    struct Recurser
      : public PostWalker<Recurser, UnifiedExpressionVisitor<Recurser>> {
      TypeUpdater& parent;

      Recurser(TypeUpdater& parent, Expression* root) : parent(parent) {
        walk(root);
      }

      void visitExpression(Expression* curr) { parent.noteRemoval(curr); }
    };

    Recurser(*this, curr);
  }

  void noteAddition(Expression* curr,
                    Expression* parent,
                    Expression* previous = nullptr) {
    assert(parents.find(curr) == parents.end()); // must not already exist
    noteRemovalOrAddition(curr, parent);
    // if we didn't replace with the exact same type, propagate types up
    if (!(previous && previous->type == curr->type)) {
      propagateTypesUp(curr);
    }
  }

  // if parent is nullptr, this is a removal
  void noteRemovalOrAddition(Expression* curr, Expression* parent) {
    parents[curr] = parent;
    discoverBreaks(curr, parent ? +1 : -1);
  }

  // Applies a type change to a node, and potentially to its parents.
  void changeType(Expression* curr, Type type) {
    if (curr->type != type) {
      curr->type = type;
      propagateTypesUp(curr);
    }
  }

  // adds (or removes) breaks depending on break/switch contents
  void discoverBreaks(Expression* curr, int change) {
    BranchUtils::operateOnScopeNameUsesAndSentTypes(
      curr,
      [&](Name& name, Type type) { noteBreakChange(name, change, type); });
    // TODO: it may be faster to accumulate all changes to a set first, then
    // call noteBreakChange on the unique values, as a switch can be quite
    // large and have lots of repeated targets.
  }

  void noteBreakChange(Name name, int change, Type type) {
    auto iter = blockInfos.find(name);
    if (iter == blockInfos.end()) {
      return; // we can ignore breaks to loops
    }
    auto& info = iter->second;
    info.numBreaks += change;
    assert(info.numBreaks >= 0);
    auto* block = info.block;
    if (block) { // if to a loop, can ignore
      if (info.numBreaks == 0) {
        // dropped to 0! the block may now be unreachable. that
        // requires that it doesn't have a fallthrough
        makeBlockUnreachableIfNoFallThrough(block);
      } else if (change == 1 && info.numBreaks == 1) {
        // bumped to 1! the block may now be reachable
        if (block->type != Type::unreachable) {
          return; // was already reachable, had a fallthrough
        }
        changeTypeTo(block, type);
      }
    }
  }

  // alters the type of a node to a new type.
  // this propagates the type change through all the parents.
  void changeTypeTo(Expression* curr, Type newType) {
    if (curr->type == newType) {
      return; // nothing to do
    }
    curr->type = newType;
    propagateTypesUp(curr);
  }

  // given a node that has a new type, or is a new node, update
  // all the parents accordingly. the existence of the node and
  // any changes to it already occurred, this just updates the
  // parents following that. i.e., nothing is done to the
  // node we start on, it's done.
  // the one thing we need to do here is propagate unreachability,
  // no other change is possible
  void propagateTypesUp(Expression* curr) {
    if (curr->type != Type::unreachable) {
      return;
    }
    while (1) {
      auto* child = curr;
      curr = parents[child];
      if (!curr) {
        return;
      }
      // get ready to apply unreachability to this node
      if (curr->type == Type::unreachable) {
        return; // already unreachable, stop here
      }
      // most nodes become unreachable if a child is unreachable,
      // but exceptions exist
      if (auto* block = curr->dynCast<Block>()) {
        // if the block has a fallthrough, it can keep its type
        if (block->list.back()->type.isConcrete()) {
          return; // did not turn
        }
        // if the block has breaks, it can keep its type
        if (!block->name.is() || blockInfos[block->name].numBreaks == 0) {
          curr->type = Type::unreachable;
        } else {
          return; // did not turn
        }
      } else if (auto* iff = curr->dynCast<If>()) {
        // We only want to change a concrete type to unreachable here, so undo
        // anything else. Other changes can be a problem, like refining the type
        // of an if for GC-using code, as the code all around us only assumes we
        // are propagating unreachability and not doing a full refinalize.
        auto old = iff->type;
        iff->finalize();
        if (curr->type != Type::unreachable) {
          iff->type = old;
          return; // did not turn
        }
      } else if (auto* tryy = curr->dynCast<Try>()) {
        // See comment on If, above.
        auto old = tryy->type;
        tryy->finalize();
        if (curr->type != Type::unreachable) {
          tryy->type = old;
          return; // did not turn
        }
      } else {
        curr->type = Type::unreachable;
      }
    }
  }

  // efficiently update the type of a block, given the data we know. this
  // can remove a concrete type and turn the block unreachable when it is
  // unreachable, and it does this efficiently, without scanning the full
  // contents
  void maybeUpdateTypeToUnreachable(Block* curr) {
    if (!curr->type.isConcrete()) {
      return; // nothing concrete to change to unreachable
    }
    if (curr->name.is() && blockInfos[curr->name].numBreaks > 0) {
      return; // has a break, not unreachable
    }
    // look for a fallthrough
    makeBlockUnreachableIfNoFallThrough(curr);
  }

  void makeBlockUnreachableIfNoFallThrough(Block* curr) {
    if (curr->type == Type::unreachable) {
      return; // no change possible
    }
    if (!curr->list.empty() && curr->list.back()->type.isConcrete()) {
      // should keep type due to fallthrough, even if has an unreachable child
      return;
    }
    for (auto* child : curr->list) {
      if (child->type == Type::unreachable) {
        // no fallthrough, and an unreachable, => this block is now unreachable
        changeTypeTo(curr, Type::unreachable);
        return;
      }
    }
  }

  // efficiently update the type of an if, given the data we know. this
  // can remove a concrete type and turn the if unreachable when it is
  // unreachable
  void maybeUpdateTypeToUnreachable(If* curr) {
    if (!curr->type.isConcrete()) {
      return; // nothing concrete to change to unreachable
    }
    // See comment in propagateTypesUp() for If regarding restoring the type.
    auto old = curr->type;
    curr->finalize();
    if (curr->type == Type::unreachable) {
      propagateTypesUp(curr);
    } else {
      curr->type = old;
    }
  }

  void maybeUpdateTypeToUnreachable(Try* curr) {
    if (!curr->type.isConcrete()) {
      return; // nothing concrete to change to unreachable
    }
    // See comment in propagateTypesUp() for Try regarding restoring the type.
    auto old = curr->type;
    curr->finalize();
    if (curr->type == Type::unreachable) {
      propagateTypesUp(curr);
    } else {
      curr->type = old;
    }
  }

  bool hasBreaks(Block* block) {
    return block->name.is() && blockInfos[block->name].numBreaks > 0;
  }
};

// Rewrites global heap types across an entire module, allowing changes to be
// made while doing so.
class GlobalTypeRewriter {
public:
  Module& wasm;

  GlobalTypeRewriter(Module& wasm);
  virtual ~GlobalTypeRewriter() {}

  // Main entry point. This performs the entire process of creating new heap
  // types and calling the hooks below, then applies the new types throughout
  // the module.
  //
  // This only operates on private types (so as not to modify the module's
  // external ABI). It takes as a parameter a list of public types to consider
  // private, which allows more flexibility (e.g. in closed world if a pass
  // knows a type is safe to modify despite being public, it can add it).
  void update(const std::vector<HeapType>& additionalPrivateTypes = {});

  using TypeMap = std::unordered_map<HeapType, HeapType>;

  // Given a map of old type => new type to use instead, this rewrites all type
  // uses in the module to apply that map. This is used internally in update()
  // but may be useful by itself as well.
  //
  // The input map does not need to contain all the types. Whenever a type does
  // not appear, it is mapped to itself.
  void mapTypes(const TypeMap& oldToNewTypes);

  // Users of `mapTypes` may want to update the type names according to their
  // mapping. This is not done automatically in `mapTypes` because other users
  // may want the names to reflect that types have been replaced.
  void mapTypeNames(const TypeMap& oldToNewTypes);

  // Subclasses can implement these methods to modify the new set of types that
  // we map to. By default, we simply copy over the types, and these functions
  // are the hooks to apply changes through. The methods receive as input the
  // old type, and a structure that they can modify. That structure is the one
  // used to define the new type in the TypeBuilder.
  virtual void modifyStruct(HeapType oldType, Struct& struct_) {}
  virtual void modifyArray(HeapType oldType, Array& array) {}
  virtual void modifySignature(HeapType oldType, Signature& sig) {}

  // This additional hook is called after modify* and other operations, and
  // allows the caller to do things like typeBuilder[i].setOpen(false);
  //
  // This is provided the builder, the index we are on, and the old heap type
  // for that index.
  virtual void
  modifyTypeBuilderEntry(TypeBuilder& typeBuilder, Index i, HeapType oldType) {}

  // Subclasses can override this method to modify supertypes. The new
  // supertype, if any, must be a supertype (or the same as) the original
  // supertype.
  virtual std::optional<HeapType> getDeclaredSuperType(HeapType oldType) {
    return oldType.getDeclaredSuperType();
  }

  // Map an old type to a temp type. This can be called from the above hooks,
  // so that they can use a proper temp type of the TypeBuilder while modifying
  // things.
  Type getTempType(Type type);
  Type getTempTupleType(Tuple tuple);

  using SignatureUpdates = std::unordered_map<HeapType, Signature>;

  // Helper for the repeating pattern of just updating Signature types using a
  // map of old heap type => new Signature.
  static void
  updateSignatures(const SignatureUpdates& updates,
                   Module& wasm,
                   const std::vector<HeapType>& additionalPrivateTypes = {}) {
    if (updates.empty()) {
      return;
    }

    class SignatureRewriter : public GlobalTypeRewriter {
      const SignatureUpdates& updates;

    public:
      SignatureRewriter(Module& wasm,
                        const SignatureUpdates& updates,
                        const std::vector<HeapType>& additionalPrivateTypes)
        : GlobalTypeRewriter(wasm), updates(updates) {
        update(additionalPrivateTypes);
      }

      void modifySignature(HeapType oldSignatureType, Signature& sig) override {
        auto iter = updates.find(oldSignatureType);
        if (iter != updates.end()) {
          sig.params = getTempType(iter->second.params);
          sig.results = getTempType(iter->second.results);
        }
      }
    } rewriter(wasm, updates, additionalPrivateTypes);
  }

protected:
  // Builds new types after updating their contents using the hooks below and
  // returns a map from the old types to the modified types. Used internally in
  // update().
  //
  // See above regarding private types.
  TypeMap
  rebuildTypes(const std::vector<HeapType>& additionalPrivateTypes = {});

private:
  TypeBuilder typeBuilder;

  // Map old types to their indices in the builder.
  InsertOrderedMap<HeapType, Index> typeIndices;
};

class TypeMapper : public GlobalTypeRewriter {
public:
  using TypeUpdates = std::unordered_map<HeapType, HeapType>;

  const TypeUpdates& mapping;

  std::unordered_map<HeapType, Signature> newSignatures;

  TypeMapper(Module& wasm, const TypeUpdates& mapping)
    : GlobalTypeRewriter(wasm), mapping(mapping) {}

  // As rebuildTypes, this can take an optional set of additional types to
  // consider private (and therefore to modify).
  void map(const std::vector<HeapType>& additionalPrivateTypes = {}) {
    // Update the internals of types (struct fields, signatures, etc.) to
    // refer to the merged types.
    auto newMapping = rebuildTypes(additionalPrivateTypes);

    // Compose the user-provided mapping from old types to other old types with
    // the new mapping from old types to new types. `newMapping` will become
    // a copy of `mapping` except that the destination types will be the newly
    // built types.
    for (auto& [src, dest] : mapping) {
      if (auto it = newMapping.find(dest); it != newMapping.end()) {
        newMapping[src] = it->second;
      } else {
        // This mapping was to a type that was not rebuilt, perhaps because it
        // is a basic type. Just use this mapping unmodified.
        newMapping[src] = dest;
      }
    }

    // Map the types of expressions (curr->type, etc.) to the correct new types.
    mapTypes(newMapping);
  }

  Type getNewType(Type type) {
    if (!type.isRef()) {
      return type;
    }
    auto heapType = type.getHeapType();
    auto iter = mapping.find(heapType);
    if (iter != mapping.end()) {
      return getTempType(Type(iter->second, type.getNullability()));
    }
    return getTempType(type);
  }

  void modifyStruct(HeapType oldType, Struct& struct_) override {
    auto& oldFields = oldType.getStruct().fields;
    for (Index i = 0; i < oldFields.size(); i++) {
      auto& oldField = oldFields[i];
      auto& newField = struct_.fields[i];
      newField.type = getNewType(oldField.type);
    }
  }
  void modifyArray(HeapType oldType, Array& array) override {
    array.element.type = getNewType(oldType.getArray().element.type);
  }
  void modifySignature(HeapType oldSignatureType, Signature& sig) override {
    auto getUpdatedTypeList = [&](Type type) {
      std::vector<Type> vec;
      for (auto t : type) {
        vec.push_back(getNewType(t));
      }
      return getTempTupleType(vec);
    };

    auto oldSig = oldSignatureType.getSignature();
    sig.params = getUpdatedTypeList(oldSig.params);
    sig.results = getUpdatedTypeList(oldSig.results);
  }
  std::optional<HeapType> getDeclaredSuperType(HeapType oldType) override {
    // If the super is mapped, get it from the mapping.
    auto super = oldType.getDeclaredSuperType();
    if (super) {
      if (auto it = mapping.find(*super); it != mapping.end()) {
        return it->second;
      }
    }
    return super;
  }
};

namespace TypeUpdating {

// Checks whether a type is valid as a local, or whether
// handleNonDefaultableLocals() can handle it if not.
bool canHandleAsLocal(Type type);

// Finds non-nullable locals, which are currently not supported, and handles
// them. Atm this turns them into nullable ones, and adds ref.as_non_null on
// their uses (which keeps the type of the users identical).
// This may also handle other types of nondefaultable locals in the future.
void handleNonDefaultableLocals(Function* func, Module& wasm);

// Returns the type that a local should be, after handling of non-
// defaultability.
Type getValidLocalType(Type type, FeatureSet features);

// Given a local.get, returns a proper replacement for it, taking into account
// the extra work we need to do to handle non-defaultable values (e.g., add a
// ref.as_non_null around it, if the local should be non-nullable but is not).
Expression* fixLocalGet(LocalGet* get, Module& wasm);

// Applies new types of parameters to a function. This does all the necessary
// changes aside from altering the function type, which the caller is expected
// to do after we run (the caller might simply change the type, but in other
// cases the caller  might be rewriting the types and need to preserve their
// identity in terms of nominal typing, so we don't change the type here). The
// specific things this function does are to update the types of local.get/tee
// operations, refinalize, etc., basically all operations necessary to ensure
// validation with the new types.
//
// While doing so, we can either update or not update the types of local.get and
// local.tee operations. (We do not update them here if we'll be doing an update
// later in the caller, which is the case if we are rewriting function types).
enum LocalUpdatingMode { Update, DoNotUpdate };

void updateParamTypes(Function* func,
                      const std::vector<Type>& newParamTypes,
                      Module& wasm,
                      LocalUpdatingMode localUpdating = Update);

} // namespace TypeUpdating

} // namespace wasm

#endif // wasm_ir_type_updating_h
