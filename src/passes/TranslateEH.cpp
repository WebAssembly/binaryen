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
// TranslateEHOldToNew translates the old Phase 3 EH instructions, which include
// try, catch, catch_all, delegate, and rethrow, into the new EH instructions,
// which include try_table (with catch / catch_ref / catch_all / catch_all_ref)
// and throw_ref, passed at the Oct 2023 CG meeting. This translator can be used
// as a standalone tool by users of the previous EH toolchain to generate
// binaries for the new spec without recompiling, and also can be used at the
// end of the Binaryen pipeline to produce binaries for the new spec while the
// end-to-end toolchain implementation for the new spec is in progress.
//
// TODO
// TranslateEHNewToOld translates the new EH instructions to the old ones. This
// can be used as a stopgap tool while Binaryen implementation for the whole
// optimization pipeline is not complete but we need to test our LLVM
// implementation for the new spec. This has not been implemented yet.
//

#include <ir/drop.h>
#include <ir/find_all.h>
#include <ir/label-utils.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

namespace {

// Translates the old EH instructions (try / catch / catch_all / delegate /
// rethrow) into the new ones (try_table (+ catch / catch_ref / catch_all /
// catch_all_ref) / throw_ref).
struct TranslateEHOldToNew
  : public WalkerPass<PostWalker<TranslateEHOldToNew>> {
  bool isFunctionParallel() override { return true; }

  // Scans and records which try labels are targetted by delegates and rethrows.
  struct TargetTryLabelScanner : public PostWalker<TargetTryLabelScanner> {
    TargetTryLabelScanner(Function* func) { walkFunction(func); }

    std::unordered_set<Name> delegateTargets;
    std::unordered_set<Name> rethrowTargets;
    bool isTargettedByDelegates(Try* curr) const {
      return delegateTargets.find(curr->name) != delegateTargets.end();
    }
    bool isTargettedByRethrows(Try* curr) const {
      return rethrowTargets.find(curr->name) != rethrowTargets.end();
    }

    void visitTry(Try* curr) {
      if (curr->isDelegate()) {
        delegateTargets.insert(curr->delegateTarget);
      }
    }

    void visitRethrow(Rethrow* curr) { rethrowTargets.insert(curr->target); }
  };

  // For each try label targetted by rethrows, assign a local that will contain
  // its exnref in the new spec (via try + catch(_all)_ref instruction), so that
  // every 'rethrow $somelabel' can later be translated into
  // 'throw_ref $somelocal'.
  //
  // In the examples below, try's (do) bodies are omitted for the sake of
  // simplicity.
  //
  // For example,
  // (try $l0
  //   (catch
  //     (try $l1
  //       (catch
  //         (rethrow $l0) ;; will become (throw_ref $local0)
  //       )
  //       (catch
  //         (rethrow $l1) ;; will become (throw_ref $local1)
  //       )
  //     )
  //   )
  // )
  // In this case, we need two locals for exnrefs, each for $l0 and $l1.
  //
  // Note that the number of locals required is the maximum depth of try-catch
  // nests, when only counting 'try's that are targetted by rethrows, which
  // means the pattern below only needs one extra local:
  // (try $l0
  //   (catch
  //     (rethrow $l0)
  //   )
  // )
  // (try $l1
  //   (catch
  //     (rethrow $l1)
  //   )
  // )
  // Because the two trys are not nested within each other, one local can be
  // reused in both trys.
  //
  // Also even if there is a try-catch nest with depth N, if only some of them
  // is targetted by rethrows, we only need that many extra local for the whole
  // nest:
  // (try $l0
  //   (catch
  //     (try $l1
  //       (catch
  //         ...
  //         ...
  //         (try $lN
  //           (catch
  //             ;; If this is the only rethrow in this nest, we only need one
  //             ;; extra exnref local for all N try-catches
  //             (rethrow $l1)
  //           )
  //         )
  //         ...
  //         ...
  //       )
  //     )
  //   )
  // )
  struct ExnrefLocalAssigner : public PostWalker<ExnrefLocalAssigner> {
    TargetTryLabelScanner* labelScanner = nullptr;

    std::vector<Index> exnrefLocals;
    std::unordered_map<Name, Index> rethrowTargetToExnrefLocal;

    // Depth of the current try nest, when only counting trys targetted with
    // rethrows.
    size_t rethrowTryDepth = 0;

    ExnrefLocalAssigner(Function* func, TargetTryLabelScanner* labelScanner)
      : labelScanner(labelScanner) {
      walkFunction(func);
    }

    bool hasExnrefLocal(Name rethrowTarget) const {
      return rethrowTargetToExnrefLocal.find(rethrowTarget) !=
             rethrowTargetToExnrefLocal.end();
    }
    Index getExnrefLocal(Name rethrowTarget) const {
      auto it = rethrowTargetToExnrefLocal.find(rethrowTarget);
      assert(it != rethrowTargetToExnrefLocal.end());
      return it->second;
    }

    static void incrementRethrowTryDepth(ExnrefLocalAssigner* self,
                                         Expression** currp) {
      self->rethrowTryDepth++;
    }
    static void decrementRethrowTryDepth(ExnrefLocalAssigner* self,
                                         Expression** currp) {
      self->rethrowTryDepth--;
    }

    static void scan(ExnrefLocalAssigner* self, Expression** currp) {
      auto* curr = *currp;
      if (auto* tryy = curr->dynCast<Try>()) {
        if (self->labelScanner->isTargettedByRethrows(tryy)) {
          self->pushTask(decrementRethrowTryDepth, currp);
        }
      }
      PostWalker<ExnrefLocalAssigner>::scan(self, currp);
      if (auto* tryy = curr->dynCast<Try>()) {
        if (self->labelScanner->isTargettedByRethrows(tryy)) {
          self->pushTask(incrementRethrowTryDepth, currp);
        }
      }
    }

    void visitTry(Try* curr) {
      if (labelScanner->isTargettedByRethrows(curr)) {
        while (exnrefLocals.size() < rethrowTryDepth) {
          exnrefLocals.push_back(
            Builder::addVar(getFunction(), Type(HeapType::exn, Nullable)));
        }
        rethrowTargetToExnrefLocal[curr->name] =
          exnrefLocals[rethrowTryDepth - 1];
      }
    }
  };

  std::unique_ptr<LabelUtils::LabelManager> labels;
  std::unique_ptr<TargetTryLabelScanner> labelScanner;
  std::unique_ptr<ExnrefLocalAssigner> localAssigner;

  std::unordered_map<Name, Name> delegateTargetToBrTarget;
  // Scratch locals used to contain extracted values and (extracted values,
  // exnref) tuples for a short time.
  std::unordered_map<Type, Index> typeToScratchLocal;

  bool refinalize = false;

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TranslateEHOldToNew>();
  }

  // Get a scratch local for a given type. These locals are used to contain
  // extracted value(s) and (extracted value(s), exnref) tuples for a short
  // time. Because these locals are written and read right after that, we can
  // reuse these for all extracted values and (extracted values, exnref) tuples
  // as long as the type matches.
  Index getScratchLocal(Type type) {
    auto it = typeToScratchLocal.find(type);
    if (it != typeToScratchLocal.end()) {
      return it->second;
    }
    typeToScratchLocal[type] = Builder::addVar(getFunction(), type);
    return typeToScratchLocal[type];
  }

  // Process try labels targetted by rethrows. This does NOT transform the
  // current 'try' into 'try_table' yet; it only adds block, br, and throw_ref
  // instructions to complete the conversions of inner try~delegates that target
  // the current try.
  void processDelegateTarget(Try* curr, Block* outerBlock) {
    Builder builder(*getModule());

    // Convert
    //
    // (try $delegate_target (result sometype)
    //   (do
    //     ...
    //     ;; This had originally been an inner try~delegate and has been
    //     ;; already translated to try_table at this point. See
    //     ;; processDelegate() for how it is done.
    //     (try_table (catch_all_ref $delegate_br_target)
    //       ...
    //     )
    //     ...
    //   (catch
    //     ...
    //   )
    // )
    //
    // to =>
    //
    // If sometype (try's type) is none:
    // (block $outer (result sometype)
    //   (try (result sometype)
    //     (do
    //       (throw_ref
    //         (block $delegate_br_target (result exnref)
    //           ...
    //           (try_table (catch_all_ref $delegate_br_target)
    //             ...
    //           )
    //           ...
    //           (br $outer)
    //         )
    //       )
    //     )
    //     (catch
    //       ...
    //     )
    //   )
    // )
    //
    // If sometype (try's type) is concrete:
    // (block $outer (result sometype)
    //   (try (result sometype)
    //     (do
    //       (throw_ref
    //         (block $delegate_br_target (result exnref)
    //           (br $outer
    //             ...
    //             (try_table (catch_all_ref $delegate_br_target)
    //               ...
    //             )
    //             ...
    //           )
    //         )
    //       )
    //     )
    //     (catch
    //       ...
    //     )
    //   )
    // )
    //
    // Note that the current try-catch (or try-delegate) stays as is for now; it
    // will be converted to a try_table later in processDelegate() and
    // processCatches().
    //
    // Also note that even in case there are multiple inner try~delegates
    // targetting this try, we need to do this only once per try target. Those
    // multiple try~delegates that used to target the same delegate target now
    // jump to the same $delegate_br_target using catch_all_ref.
    Name delegateBrTarget = delegateTargetToBrTarget[curr->name];
    Expression* innerBody = nullptr;
    if (curr->type.isConcrete()) {
      auto* brToOuter = builder.makeBreak(outerBlock->name, curr->body);
      innerBody = builder.blockifyWithName(
        brToOuter, delegateBrTarget, nullptr, Type(HeapType::exn, Nullable));
    } else {
      auto* brToOuter = curr->body->type == Type::unreachable
                          ? nullptr
                          : builder.makeBreak(outerBlock->name);
      innerBody = builder.blockifyWithName(
        curr->body, delegateBrTarget, brToOuter, Type(HeapType::exn, Nullable));
    }
    curr->body = builder.makeThrowRef(innerBody);
    assert(outerBlock->list.empty());
    outerBlock->list.push_back(curr->body);
  }

  void processDelegate(Try* curr) {
    Builder builder(*getModule());
    // Convert
    // (try
    //   (do
    //     ...
    //   )
    //   (delegate $delegate_target)
    // )
    //
    // to =>
    //
    // (try_table (catch_ref $delegate_br_target)
    //   ...
    // )
    //
    // $delegate_br_target is a block label that will be created in
    // processDelegateTarget(), when we process the 'try' that is the target of
    // this try~delegate. See processDelegateTarget() for how the rest of the
    // conversion is completed.
    replaceCurrent(
      builder.makeTryTable(curr->body,
                           {Name()},
                           {delegateTargetToBrTarget[curr->delegateTarget]},
                           {true}));
  }

  void processCatches(Try* curr, Block* outerBlock) {
    Module* wasm = getModule();
    Builder builder(*wasm);

    // Determine whether a given catch body should be translated to
    // catch/catch_all vs. catch_ref/catch_all_ref.
    auto shouldBeRef = [&](Expression* catchBody) -> bool {
      // If this try is targetted by rethrows and those rethrows exist in the
      // current catch body, we need to use catch_ref/catch_all_ref. By this
      // point, all rethrows in the catch bodies have been already converted to
      // throw_refs, so we check the local numbers to see if those (original)
      // rethrows used to target the current try label.
      if (localAssigner->hasExnrefLocal(curr->name)) {
        Index local = localAssigner->getExnrefLocal(curr->name);
        for (auto* throwRef : FindAll<ThrowRef>(catchBody).list) {
          if (auto* localGet = throwRef->exnref->cast<LocalGet>()) {
            if (localGet->index == local) {
              return true;
            }
          }
        }
      }
      return false;
    };

    // Create try_table instruction with catch clauses.
    std::vector<Name> catchTags;
    std::vector<Name> catchDests;
    std::vector<bool> catchRefs;
    for (Index i = 0; i < curr->catchTags.size(); i++) {
      catchTags.push_back(curr->catchTags[i]);
      catchDests.push_back(labels->getUnique("catch"));
      catchRefs.push_back(shouldBeRef(curr->catchBodies[i]));
    }
    if (curr->hasCatchAll()) {
      catchTags.push_back(Name());
      catchDests.push_back(labels->getUnique("catch_all"));
      catchRefs.push_back(shouldBeRef(curr->catchBodies.back()));
    }
    auto* tryTable = builder.makeTryTable(
      curr->body, catchTags, catchDests, catchRefs, curr->type);

    // If we don't have any catches, we don't need to do more.
    if (curr->catchBodies.empty()) { // catch-less try
      replaceCurrent(tryTable);
      return;
    }

    // Now we convert catch bodies.
    //
    // For simplicity, let's assume all tags have the none type and there are no
    // rethrows (which have converted to throw_refs at this point) and the try's
    // type is none as well. Then
    //
    // (try
    //   (catch $e
    //     (catch_body)
    //   )
    //   (catch_all
    //     (catch_all_body)
    //   )
    // )
    //
    // becomes
    //
    // (block $outer
    //   (block $catch_all
    //     (block $catch
    //       (try_table (catch $e $catch) (catch_all $catch_all)
    //         ...
    //       )
    //       (br $outer)
    //     )
    //     (catch_body)
    //     (br $outer)
    //   )
    //   (catch_all_body) ;; We don't need (br $outer) for the last catch
    // )
    //
    // Here (block $outer) has been already created and given as an argument to
    // this function. This is the outer block that will contain the whole
    // structure.
    //
    // If there are more catch clauses, there will be more layers of blocks,
    // catch bodies, and (br $outer)s.
    //
    // If try's type is concrete, (br $outer)s will contain try_table and catch
    // bodies as values:
    //
    // (block $outer
    //   (block $catch_all
    //     (block $catch
    //       (br $outer
    //         (try_table (result sometype)
    //                    (catch $e $catch) (catch_all $catch_all)
    //           ...
    //         )
    //       )
    //     )
    //     (br $outer
    //       (catch_body)
    //     )
    //   )
    //   (catch_all_body) ;; We don't need (br $outer) for the last catch
    // )
    //
    // ---
    //
    // When a tag has a concrete type, we assign it to a scratch local of that
    // type, and (pop tagtype) would have been already converted to
    // (local.get $scratch) in visitPop(). These scratch locals have extremely
    // short lifetimes; basically they are read right after they are written, so
    // we can reuse them throughout the function.
    //
    // So, when there is no rethrows (throw_refs), and if we assume that try's
    // type is none for simplicity,
    // (try
    //   ...
    //   (catch $e-i32 ;; concrete type
    //     (use_inst
    //       (pop i32)
    //     )
    //   )
    // )
    //
    // becomes
    // (block $outer
    //   (local.set $scratch-i32
    //     (block $catch (result tagtype)
    //       (try_table (catch $e-i32 $catch)
    //         ...
    //       )
    //       (br $outer)
    //     )
    //   )
    //   (use_inst
    //     (local.get $scratch-i32)
    //   )
    // )
    //
    // When the tag type is none or it is a catch_all, but there are rethrows
    // (throws_refs at this point) within the catch body that targets this try's
    // label, we use catch_ref (or catch_all_ref in case of catch_all), and
    // assign the block return value to a exnref local. rethrows would have been
    // converted to (local.get $exn) in visitRethrow() already. Unlike scratch
    // locals used for pops, exnref locals can have longer lifetimes and
    // assigned in ExnrefLocalAssigner. So for example,
    // (try $l0
    //   ...
    //   (catch_all
    //     (rethrow $l0)
    //   )
    // )
    //
    // becomes
    //
    // (block $outer
    //   (local.set $exn
    //     (block $catch_all (result exnref)
    //       (try_table (catch_all_ref $catch_all)
    //         ...
    //       )
    //       (br $outer)
    //     )
    //   )
    //   (throw_ref
    //     (local.get $exn)
    //   )
    // )
    //
    // When the tag type is concrete and also there are rethrows within the
    // catch body that targets this try's label, (extracted values, exnref)
    // is saved in a tuple local matching its tuple type, and tuple.extract
    // instructions are added to extract each of them and set them to a scratch
    // local for a later pop and exnref local for later throw_ref.
    //
    // (try $l0
    //   ...
    //   (catch $e-i32 ;; concrete type
    //     (use_inst
    //       (pop i32)
    //     )
    //     (rethrow $l0)
    //   )
    // )
    //
    // becomes
    //
    // (block $outer
    //   (local.set $tuple
    //     (block $catch (result i32 exnref)
    //       (try_table (catch_ref $e-i32 $catch)
    //         ...
    //       )
    //       (br $outer)
    //     )
    //   )
    //   (local.set $scratch-i32
    //     (tuple.extract 2 0
    //       (local.get $tuple)
    //     )
    //   )
    //   (local.set $exn
    //     (tuple.extract 2 1
    //       (local.get $tuple)
    //     )
    //   )
    //   (block
    //     (use_inst
    //       (local.get $scratch-i32)
    //     )
    //     (throw_ref
    //       (local.get $exn)
    //     )
    //   )
    // )
    //
    // The transformation is similar when the tag type itself is a tuple and
    // there are rethrows. We store the whole (tag types, exnref) in a tuple
    // scratch local, and tuple.extract 1~(n-1)th elements and set them in
    // another scratch local and nth element in an exnref local.

    // Make the body for the innermost block
    std::vector<Expression*> items;
    if (tryTable->type.isConcrete()) {
      items.push_back(builder.makeBreak(outerBlock->name, tryTable));
    } else {
      items.push_back(tryTable);
      if (tryTable->type != Type::unreachable) {
        items.push_back(builder.makeBreak(outerBlock->name));
      }
    }

    // Convert each catch body to a wrapping block + catch body + br
    for (Index i = 0; i < tryTable->catchTags.size(); i++) {
      Type sentType = tryTable->sentTypes[i];
      auto* catchBody = curr->catchBodies[i];
      Type tagType = Type::none;
      if (tryTable->catchTags[i]) {
        tagType = wasm->getTag(tryTable->catchTags[i])->sig.params;
      }

      // This is to be the body of the next(outer) level block
      std::vector<Expression*> nextItems;

      auto* block = builder.makeBlock(tryTable->catchDests[i], items, sentType);

      if (tryTable->catchRefs[i]) {
        // When we use the exnref (i.e., there are throw_refs in the catch body)
        Index exnrefLocal = localAssigner->getExnrefLocal(curr->name);
        if (tagType.isConcrete()) {
          // If the tag type is single and we use the exnref, the block
          // returns (tagtype, exnref). Get a scratch local to contain this
          // tuple and reassign its elements to a pop scratch local and this
          // try's corresponding exnref local respectively.
          //
          // If the tag type is a tuple and we use the exnref, the block returns
          // (tagtype0, ..., tagtypeN, exnref). Assign (tagtype0, ..., tagtypeN)
          // to a scratch (tuple) local and the exnref to this try's
          // corresponding exnref local respectively.
          Index allLocal = getScratchLocal(sentType);
          Index popLocal = getScratchLocal(tagType);
          auto* allLocalSet = builder.makeLocalSet(allLocal, block);
          nextItems.push_back(allLocalSet);
          Expression* popLocalSet = nullptr;
          if (tagType.isTuple()) {
            std::vector<Expression*> popVals;
            for (Index j = 0; j < tagType.size(); j++) {
              popVals.push_back(builder.makeTupleExtract(
                builder.makeLocalGet(allLocal, sentType), j));
            }
            popLocalSet =
              builder.makeLocalSet(popLocal, builder.makeTupleMake(popVals));
          } else {
            popLocalSet = builder.makeLocalSet(
              popLocal,
              builder.makeTupleExtract(builder.makeLocalGet(allLocal, sentType),
                                       0));
          }
          nextItems.push_back(popLocalSet);
          auto* exnrefLocalSet = builder.makeLocalSet(
            exnrefLocal,
            builder.makeTupleExtract(builder.makeLocalGet(allLocal, sentType),
                                     sentType.size() - 1));
          nextItems.push_back(exnrefLocalSet);
        } else {
          // If the tag type is none and we use the exnref, the block only
          // returns exnref. Assign in to this try's corresponding exnref local.
          auto* exnrefLocalSet = builder.makeLocalSet(exnrefLocal, block);
          nextItems.push_back(exnrefLocalSet);
        }
      } else {
        // When we don't use exnref and the tag type is concrete, we get a
        // scratch local of the tag type and assign the block return value to
        // that local. This process is the same for single and tuple tag types.
        // If the tag type is none, we don't need to use any locals.
        if (tagType.isConcrete()) {
          Index popLocal = getScratchLocal(tagType);
          auto* popLocalSet = builder.makeLocalSet(popLocal, block);
          nextItems.push_back(popLocalSet);
        } else {
          nextItems.push_back(block);
        }
      }

      if (catchBody->type.isConcrete()) {
        // If this is the last catch body, we can omit the br and fall through
        if (i < tryTable->catchTags.size() - 1) {
          nextItems.push_back(builder.makeBreak(outerBlock->name, catchBody));
        } else {
          nextItems.push_back(catchBody);
        }
      } else {
        nextItems.push_back(catchBody);
        // If this is the last catch body, we can omit the br and fall through
        if (i < tryTable->catchTags.size() - 1 &&
            catchBody->type != Type::unreachable) {
          nextItems.push_back(builder.makeBreak(outerBlock->name));
        }
      }
      items.swap(nextItems);
    }

    // In case this was already popuated in processDelegateTarget(), we empty
    // the block to repopulate with the newly created structures here
    outerBlock->list.clear();
    for (auto* item : items) {
      outerBlock->list.push_back(item);
    }
  }

  void visitTry(Try* curr) {
    refinalize = true;
    Builder builder(*getModule());
    Block* outerBlock = nullptr;
    auto it = delegateTargetToBrTarget.find(curr->name);
    if (it != delegateTargetToBrTarget.end() || curr->isCatch()) {
      outerBlock =
        builder.makeBlock(labels->getUnique("outer"), {}, curr->type);
    }

    if (it != delegateTargetToBrTarget.end()) {
      processDelegateTarget(curr, outerBlock);
    }
    if (curr->isDelegate()) {
      processDelegate(curr);
    } else { // try-catch or catch-less try
      processCatches(curr, outerBlock);
    }

    if (outerBlock) {
      replaceCurrent(outerBlock);
    }
  }

  void visitPop(Pop* curr) {
    // We can assume a 'pop' value is always in a scratch local that matches
    // its type, because these locals are read right after being written and can
    // be reused for all pops. This applies to tuple type pops as well.
    Builder builder(*getModule());
    Index popLocal = getScratchLocal(curr->type);
    replaceCurrent(builder.makeLocalGet(popLocal, curr->type));
  }

  void visitRethrow(Rethrow* curr) {
    // After we assigned an exnref local for each try label targetted by
    // rethrows, we can assume the exnref we want to rethrow is located in that
    // exnref local at this point. We ensure this to happen when converting
    // the corresponding 'try' to 'try_table' by using catch_ref/catch_all_ref
    // and assining the exnref to that local.
    Builder builder(*getModule());
    Index exnrefLocal = localAssigner->getExnrefLocal(curr->target);
    replaceCurrent(builder.makeThrowRef(
      builder.makeLocalGet(exnrefLocal, Type(HeapType::exn, Nullable))));
  }

  // Similar to processDelegateTarget(), but does it for the caller delegate
  // target, which means we should rethrow to the caller.
  void processCallerDelegateTarget() {
    Name callerDelegateBrTarget =
      delegateTargetToBrTarget[DELEGATE_CALLER_TARGET];
    Builder builder(*getModule());
    Function* func = getFunction();

    // The transformation is similar to that of normal delegate targets, but
    // instead of branching to an outer label in case no exception is thrown, we
    // just return.
    //
    // Convert
    //
    // (func $test (result sometype)
    //   ...
    //   (try_table (catch_all_ref $caller_delegate_br_target)
    //     ...
    //   )
    //   ...
    // )
    //
    // to =>
    //
    // If sometype (func's type) is none:
    // (func $test (result sometype)
    //   (throw_ref
    //     (block $caller_delegate_br_target (result exnref)
    //       ...
    //       (try_table (catch_all_ref $caller_delegate_br_target)
    //         ...
    //       )
    //       ...
    //       (return)
    //     )
    //   )
    // )
    //
    // If sometype (func's type) is none:
    // INNER_BODY =
    // If sometype (func's type) is concrete:
    //   (throw_ref
    //     (block $caller_delegate_br_target (result exnref)
    //       (return
    //         ...
    //         (try_table (catch_all_ref $caller_delegate_br_target)
    //           ...
    //         )
    //         ...
    //       )
    //     )
    //   )
    // )
    Expression* innerBody = nullptr;
    if (func->body->type.isConcrete()) {
      auto* ret = builder.makeReturn(func->body);
      innerBody = builder.blockifyWithName(
        ret, callerDelegateBrTarget, nullptr, Type(HeapType::exn, Nullable));
    } else {
      auto* ret = builder.makeReturn();
      innerBody = builder.blockifyWithName(
        func->body, callerDelegateBrTarget, ret, Type(HeapType::exn, Nullable));
    }
    func->body = builder.makeThrowRef(innerBody);
  }

  void doWalkFunction(Function* func) {
    labels = std::make_unique<LabelUtils::LabelManager>(func);
    labelScanner = std::make_unique<TargetTryLabelScanner>(func);
    localAssigner =
      std::make_unique<ExnrefLocalAssigner>(func, labelScanner.get());

    // Create a unique br target label for each existing delegate target label,
    // because we are going to achieve 'delegate's effects with 'br's. See
    // processDelegateTarget() for details.
    for (auto& target : labelScanner->delegateTargets) {
      delegateTargetToBrTarget[target] = labels->getUnique(target.toString());
    }

    super::doWalkFunction(func);

    // Similar to processDelegateTarget(), but for the caller target.
    if (delegateTargetToBrTarget.find(DELEGATE_CALLER_TARGET) !=
        delegateTargetToBrTarget.end()) {
      processCallerDelegateTarget();
    }
  }
};

struct TranslateEHNewToOld
  : public WalkerPass<PostWalker<TranslateEHNewToOld>> {
  // TODO
};

} // namespace

Pass* createTranslateEHOldToNewPass() { return new TranslateEHOldToNew(); }

Pass* createTranslateEHNewToOldPass() { return new TranslateEHNewToOld(); }

} // namespace wasm
