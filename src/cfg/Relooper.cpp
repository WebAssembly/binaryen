/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include "Relooper.h"

#include <string.h>
#include <stdlib.h>

#include <list>
#include <stack>
#include <string>

#include "ast_utils.h"
#include "parsing.h"

namespace CFG {

template <class T, class U> static bool contains(const T& container, const U& contained) {
  return !!container.count(contained);
}

#ifdef RELOOPER_DEBUG
static void PrintDebug(const char *Format, ...);
#define DebugDump(x, ...) Debugging::Dump(x, __VA_ARGS__)
#else
#define PrintDebug(x, ...)
#define DebugDump(x, ...)
#endif

// Rendering utilities

static wasm::Expression* HandleFollowupMultiples(wasm::Expression* Ret, Shape* Parent, RelooperBuilder& Builder, bool InLoop) {
  if (!Parent->Next) return Ret;

  auto* Curr = Ret->dynCast<wasm::Block>();
  if (!Curr || Curr->name.is()) {
    Curr = Builder.makeBlock(Ret);
  }
  // for each multiple after us, we create a block target for breaks to reach
  while (Parent->Next) {
    auto* Multiple = Shape::IsMultiple(Parent->Next);
    if (!Multiple) break;
    for (auto& iter : Multiple->InnerMap) {
      int Id = iter.first;
      Shape* Body = iter.second;
      Curr->name = Builder.getBlockBreakName(Id);
      Curr->finalize(); // it may now be reachable, via a break
      auto* Outer = Builder.makeBlock(Curr);
      Outer->list.push_back(Body->Render(Builder, InLoop));
      Outer->finalize(); // TODO: not really necessary
      Curr = Outer;
    }
    Parent->Next = Parent->Next->Next;
  }
  // after the multiples is a simple or a loop, in both cases we must hit an entry
  // block, and so this is the last one we need to take into account now (this
  // is why we require that loops hit an entry).
  if (Parent->Next) {
    auto* Simple = Shape::IsSimple(Parent->Next);
    if (Simple) {
      // breaking on the next block's id takes us out, where we
      // will reach its rendering
      Curr->name = Builder.getBlockBreakName(Simple->Inner->Id);
    } else {
      // add one break target per entry for the loop
      auto* Loop = Shape::IsLoop(Parent->Next);
      assert(Loop);
      assert(Loop->Entries.size() > 0);
      if (Loop->Entries.size() == 1) {
        Curr->name = Builder.getBlockBreakName((*Loop->Entries.begin())->Id);
      } else {
        for (auto* Entry : Loop->Entries) {
          Curr->name = Builder.getBlockBreakName(Entry->Id);
          Curr->finalize();
          auto* Outer = Builder.makeBlock(Curr);
          Outer->finalize(); // TODO: not really necessary
          Curr = Outer;
        }
      }
    }
  }
  Curr->finalize();
  return Curr;
}

// Branch

Branch::Branch(wasm::Expression* ConditionInit, wasm::Expression* CodeInit) : Ancestor(nullptr), Condition(ConditionInit), Code(CodeInit) {}

Branch::Branch(std::vector<wasm::Index>&& ValuesInit, wasm::Expression* CodeInit) : Ancestor(nullptr), Code(CodeInit) {
  if (ValuesInit.size() > 0) {
    SwitchValues = wasm::make_unique<std::vector<wasm::Index>>(ValuesInit);
  }
  // otherwise, it is the default
}

wasm::Expression* Branch::Render(RelooperBuilder& Builder, Block *Target, bool SetLabel) {
  auto* Ret = Builder.makeBlock();
  if (Code) Ret->list.push_back(Code);
  if (SetLabel) Ret->list.push_back(Builder.makeSetLabel(Target->Id));
  if (Type == Break) {
    Ret->list.push_back(Builder.makeBlockBreak(Target->Id));
  } else if (Type == Continue) {
    assert(Ancestor);
    Ret->list.push_back(Builder.makeShapeContinue(Ancestor->Id));
  }
  Ret->finalize();
  return Ret;
}

// Block

Block::Block(wasm::Expression* CodeInit, wasm::Expression* SwitchConditionInit) : Parent(nullptr), Id(-1), Code(CodeInit), SwitchCondition(SwitchConditionInit), IsCheckedMultipleEntry(false) {}

Block::~Block() {
  for (BlockBranchMap::iterator iter = ProcessedBranchesOut.begin(); iter != ProcessedBranchesOut.end(); iter++) {
    delete iter->second;
  }
  for (BlockBranchMap::iterator iter = BranchesOut.begin(); iter != BranchesOut.end(); iter++) {
    delete iter->second;
  }
}

void Block::AddBranchTo(Block *Target, wasm::Expression* Condition, wasm::Expression* Code) {
  assert(!contains(BranchesOut, Target)); // cannot add more than one branch to the same target
  BranchesOut[Target] = new Branch(Condition, Code);
}

void Block::AddSwitchBranchTo(Block *Target, std::vector<wasm::Index>&& Values, wasm::Expression* Code) {
  assert(!contains(BranchesOut, Target)); // cannot add more than one branch to the same target
  BranchesOut[Target] = new Branch(std::move(Values), Code);
}

wasm::Expression* Block::Render(RelooperBuilder& Builder, bool InLoop) {
  auto* Ret = Builder.makeBlock();
  if (IsCheckedMultipleEntry && InLoop) {
    Ret->list.push_back(Builder.makeSetLabel(0));
  }
  if (Code) Ret->list.push_back(Code);

  if (!ProcessedBranchesOut.size()) {
    Ret->finalize();
    return Ret;
  }

  bool SetLabel = true; // in some cases it is clear we can avoid setting label, see later

  // A setting of the label variable (label = x) is necessary if it can
  // cause an impact. The main case is where we set label to x, then elsewhere
  // we check if label is equal to that value, i.e., that label is an entry
  // in a multiple block. We also need to reset the label when we enter
  // that block, so that each setting is a one-time action: consider
  //
  //    while (1) {
  //      if (check) label = 1;
  //      if (label == 1) { label = 0 }
  //    }
  //
  // (Note that this case is impossible due to fusing, but that is not
  // material here.) So setting to 0 is important just to clear the 1 for
  // future iterations.
  // TODO: When inside a loop, if necessary clear the label variable
  //       once on the top, and never do settings that are in effect clears

  // Fusing: If the next is a Multiple, we can fuse it with this block. Note
  // that we must be the Inner of a Simple, so fusing means joining a Simple
  // to a Multiple. What happens there is that all options in the Multiple
  // *must* appear in the Simple (the Simple is the only one reaching the
  // Multiple), so we can remove the Multiple and add its independent groups
  // into the Simple's branches.
  MultipleShape *Fused = Shape::IsMultiple(Parent->Next);
  if (Fused) {
    PrintDebug("Fusing Multiple to Simple\n", 0);
    Parent->Next = Parent->Next->Next;
    // When the Multiple has the same number of groups as we have branches,
    // they will all be fused, so it is safe to not set the label at all.
    // If a switch, then we can have multiple branches to the same target
    // (in different table indexes), and so this check is not sufficient TODO: optimize
    if (SetLabel && Fused->InnerMap.size() == ProcessedBranchesOut.size() && !SwitchCondition) {
      SetLabel = false;
    }
  }

  Block *DefaultTarget = nullptr; // The block we branch to without checking the condition, if none of the other conditions held.

  // Find the default target, the one without a condition
  for (BlockBranchMap::iterator iter = ProcessedBranchesOut.begin(); iter != ProcessedBranchesOut.end(); iter++) {
    if ((!SwitchCondition && !iter->second->Condition) || (SwitchCondition && !iter->second->SwitchValues)) {
      assert(!DefaultTarget && "block has branches without a default (nullptr for the condition)"); // Must be exactly one default // nullptr
      DefaultTarget = iter->first;
    }
  }
  assert(DefaultTarget); // Since each block *must* branch somewhere, this must be set

  wasm::Expression* Root = nullptr; // root of the main part, that we are about to emit

  if (!SwitchCondition) {
    // We'll emit a chain of if-elses
    wasm::If* CurrIf = nullptr;

    // we build an if, then add a child, then add a child to that, etc., so we must
    // finalize them in reverse order
    std::vector<wasm::If*> finalizeStack;

    wasm::Expression* RemainingConditions = nullptr;

    for (BlockBranchMap::iterator iter = ProcessedBranchesOut.begin();; iter++) {
      Block *Target;
      Branch *Details;
      if (iter != ProcessedBranchesOut.end()) {
        Target = iter->first;
        if (Target == DefaultTarget) continue; // done at the end
        Details = iter->second;
        assert(Details->Condition); // must have a condition if this is not the default target
      } else {
        Target = DefaultTarget;
        Details = ProcessedBranchesOut[DefaultTarget];
      }
      bool SetCurrLabel = SetLabel && Target->IsCheckedMultipleEntry;
      bool HasFusedContent = Fused && contains(Fused->InnerMap, Target->Id);
      if (HasFusedContent) {
        assert(Details->Type == Branch::Break);
        Details->Type = Branch::Direct;
      }
      wasm::Expression* CurrContent = nullptr;
      bool IsDefault = iter == ProcessedBranchesOut.end();
      if (SetCurrLabel || Details->Type != Branch::Direct || HasFusedContent || Details->Code) {
        CurrContent = Details->Render(Builder, Target, SetCurrLabel);
        if (HasFusedContent) {
          CurrContent = Builder.blockify(CurrContent, Fused->InnerMap.find(Target->Id)->second->Render(Builder, InLoop));
        }
      }
      // If there is nothing to show in this branch, omit the condition
      if (CurrContent) {
        if (IsDefault) {
          wasm::Expression* Now;
          if (RemainingConditions) {
            Now = Builder.makeIf(RemainingConditions, CurrContent);
            finalizeStack.push_back(Now->cast<wasm::If>());
          } else {
            Now = CurrContent;
          }
          if (!CurrIf) {
            assert(!Root);
            Root = Now;
          } else {
            CurrIf->ifFalse = Now;
            CurrIf->finalize();
          }
        } else {
          auto* Now = Builder.makeIf(Details->Condition, CurrContent);
          finalizeStack.push_back(Now);
          if (!CurrIf) {
            assert(!Root);
            Root = CurrIf = Now;
          } else {
            CurrIf->ifFalse = Now;
            CurrIf->finalize();
            CurrIf = Now;
          }
        }
      } else {
        auto* Now = Builder.makeUnary(wasm::EqZInt32, Details->Condition);
        if (RemainingConditions) {
          RemainingConditions = Builder.makeBinary(wasm::AndInt32, RemainingConditions, Now);
        } else {
          RemainingConditions = Now;
        }
      }
      if (IsDefault) break;
    }

    // finalize the if-chains
    while (finalizeStack.size() > 0) {
      wasm::If* curr = finalizeStack.back();
      finalizeStack.pop_back();
      curr->finalize();
    }

  } else {
    // Emit a switch
    auto Base = std::string("switch$") + std::to_string(Id);
    auto SwitchDefault = wasm::Name(Base + "$default");
    auto SwitchLeave = wasm::Name(Base + "$leave");
    std::map<Block*, wasm::Name> BlockNameMap;
    auto* Outer = Builder.makeBlock();
    auto* Inner = Outer;
    std::vector<wasm::Name> Table;
    for (auto& iter : ProcessedBranchesOut) {
      Block *Target = iter.first;
      Branch *Details = iter.second;
      wasm::Name CurrName;
      if (Details->SwitchValues) {
        CurrName = wasm::Name(Base + "$case$" + std::to_string(Target->Id));
      } else {
        CurrName = SwitchDefault;
      }
      // generate the content for this block
      bool SetCurrLabel = SetLabel && Target->IsCheckedMultipleEntry;
      bool HasFusedContent = Fused && contains(Fused->InnerMap, Target->Id);
      if (HasFusedContent) {
        assert(Details->Type == Branch::Break);
        Details->Type = Branch::Direct;
      }
      wasm::Expression* CurrContent = nullptr;
      if (SetCurrLabel || Details->Type != Branch::Direct || HasFusedContent || Details->Code) {
        CurrContent = Details->Render(Builder, Target, SetCurrLabel);
        if (HasFusedContent) {
          CurrContent = Builder.blockify(CurrContent, Fused->InnerMap.find(Target->Id)->second->Render(Builder, InLoop));
        }
      }
      // generate a block to branch to, if we have content
      if (CurrContent) {
        auto* NextOuter = Builder.makeBlock();
        NextOuter->list.push_back(Outer);
        Outer->name = CurrName; // breaking on Outer leads to the content in NextOuter
        NextOuter->list.push_back(CurrContent);
        // if this is not a dead end, also need to break to the outside
        // this is both an optimization, and avoids incorrectness as adding
        // a brak in unreachable code can make a place look reachable that isn't
        if (CurrContent->type != wasm::unreachable) {
          NextOuter->list.push_back(Builder.makeBreak(SwitchLeave));
        }
        // prepare for more nesting
        Outer = NextOuter;
      } else {
        CurrName = SwitchLeave; // just go out straight from the table
        if (!Details->SwitchValues) {
          // this is the default, and it has no content. So make the default be the leave
          for (auto& Value : Table) {
            if (Value == SwitchDefault) Value = SwitchLeave;
          }
          SwitchDefault = SwitchLeave;
        }
      }
      if (Details->SwitchValues) {
        for (auto Value : *Details->SwitchValues) {
          while (Table.size() <= Value) Table.push_back(SwitchDefault);
          Table[Value] = CurrName;
        }
      }
    }
    // finish up the whole pattern
    Outer->name = SwitchLeave;
    Inner->list.push_back(Builder.makeSwitch(Table, SwitchDefault, SwitchCondition));
    Root = Outer;
  }

  if (Root) {
    Ret->list.push_back(Root);
  }
  Ret->finalize();

  return Ret;
}

// SimpleShape

wasm::Expression* SimpleShape::Render(RelooperBuilder& Builder, bool InLoop) {
  auto* Ret = Inner->Render(Builder, InLoop);
  Ret = HandleFollowupMultiples(Ret, this, Builder, InLoop);
  if (Next) {
    Ret = Builder.makeSequence(Ret, Next->Render(Builder, InLoop));
  }
  return Ret;
}


// MultipleShape

wasm::Expression* MultipleShape::Render(RelooperBuilder& Builder, bool InLoop) {
  // TODO: consider switch
  // emit an if-else chain
  wasm::If *FirstIf = nullptr, *CurrIf = nullptr;
  std::vector<wasm::If*> finalizeStack;
  for (IdShapeMap::iterator iter = InnerMap.begin(); iter != InnerMap.end(); iter++) {
    auto* Now = Builder.makeIf(
      Builder.makeCheckLabel(iter->first),
      iter->second->Render(Builder, InLoop)
    );
    finalizeStack.push_back(Now);
    if (!CurrIf) {
      FirstIf = CurrIf = Now;
    } else {
      CurrIf->ifFalse = Now;
      CurrIf->finalize();
      CurrIf = Now;
    }
  }
  while (finalizeStack.size() > 0) {
    wasm::If* curr = finalizeStack.back();
    finalizeStack.pop_back();
    curr->finalize();
  }
  wasm::Expression* Ret = Builder.makeBlock(FirstIf);
  Ret = HandleFollowupMultiples(Ret, this, Builder, InLoop);
  if (Next) {
    Ret = Builder.makeSequence(Ret, Next->Render(Builder, InLoop));
  }
  return Ret;
}

// LoopShape

wasm::Expression* LoopShape::Render(RelooperBuilder& Builder, bool InLoop) {
  wasm::Expression* Ret = Builder.makeLoop(Builder.getShapeContinueName(Id), Inner->Render(Builder, true));
  Ret = HandleFollowupMultiples(Ret, this, Builder, InLoop);
  if (Next) {
    Ret = Builder.makeSequence(Ret, Next->Render(Builder, InLoop));
  }
  return Ret;
}

// Relooper

Relooper::Relooper() : Root(nullptr), MinSize(false), BlockIdCounter(1), ShapeIdCounter(0) { // block ID 0 is reserved for clearings
}

Relooper::~Relooper() {
  for (unsigned i = 0; i < Blocks.size(); i++) delete Blocks[i];
  for (unsigned i = 0; i < Shapes.size(); i++) delete Shapes[i];
}

void Relooper::AddBlock(Block *New, int Id) {
  New->Id = Id == -1 ? BlockIdCounter++ : Id;
  Blocks.push_back(New);
}

struct RelooperRecursor {
  Relooper *Parent;
  RelooperRecursor(Relooper *ParentInit) : Parent(ParentInit) {}
};

typedef std::list<Block*> BlockList;

void Relooper::Calculate(Block *Entry) {
  // Scan and optimize the input
  struct PreOptimizer : public RelooperRecursor {
    PreOptimizer(Relooper *Parent) : RelooperRecursor(Parent) {}
    BlockSet Live;

    void FindLive(Block *Root) {
      BlockList ToInvestigate;
      ToInvestigate.push_back(Root);
      while (ToInvestigate.size() > 0) {
        Block *Curr = ToInvestigate.front();
        ToInvestigate.pop_front();
        if (contains(Live, Curr)) continue;
        Live.insert(Curr);
        for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
          ToInvestigate.push_back(iter->first);
        }
      }
    }
  };
  PreOptimizer Pre(this);
  Pre.FindLive(Entry);

  // Add incoming branches from live blocks, ignoring dead code
  for (unsigned i = 0; i < Blocks.size(); i++) {
    Block *Curr = Blocks[i];
    if (!contains(Pre.Live, Curr)) continue;
    for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
      iter->first->BranchesIn.insert(Curr);
    }
  }

  // Recursively process the graph

  struct Analyzer : public RelooperRecursor {
    Analyzer(Relooper *Parent) : RelooperRecursor(Parent) {}

    // Add a shape to the list of shapes in this Relooper calculation
    void Notice(Shape *New) {
      New->Id = Parent->ShapeIdCounter++;
      Parent->Shapes.push_back(New);
    }

    // Create a list of entries from a block. If LimitTo is provided, only results in that set
    // will appear
    void GetBlocksOut(Block *Source, BlockSet& Entries, BlockSet *LimitTo = nullptr) {
      for (BlockBranchMap::iterator iter = Source->BranchesOut.begin(); iter != Source->BranchesOut.end(); iter++) {
        if (!LimitTo || contains(*LimitTo, iter->first)) {
          Entries.insert(iter->first);
        }
      }
    }

    // Converts/processes all branchings to a specific target
    void Solipsize(Block *Target, Branch::FlowType Type, Shape *Ancestor, BlockSet &From) {
      PrintDebug("Solipsizing branches into %d\n", Target->Id);
      DebugDump(From, "  relevant to solipsize: ");
      for (BlockSet::iterator iter = Target->BranchesIn.begin(); iter != Target->BranchesIn.end();) {
        Block *Prior = *iter;
        if (!contains(From, Prior)) {
          iter++;
          continue;
        }
        Branch *PriorOut = Prior->BranchesOut[Target];
        PriorOut->Ancestor = Ancestor;
        PriorOut->Type = Type;
        iter++; // carefully increment iter before erasing
        Target->BranchesIn.erase(Prior);
        Target->ProcessedBranchesIn.insert(Prior);
        Prior->BranchesOut.erase(Target);
        Prior->ProcessedBranchesOut[Target] = PriorOut;
        PrintDebug("  eliminated branch from %d\n", Prior->Id);
      }
    }

    Shape *MakeSimple(BlockSet &Blocks, Block *Inner, BlockSet &NextEntries) {
      PrintDebug("creating simple block with block #%d\n", Inner->Id);
      SimpleShape *Simple = new SimpleShape;
      Notice(Simple);
      Simple->Inner = Inner;
      Inner->Parent = Simple;
      if (Blocks.size() > 1) {
        Blocks.erase(Inner);
        GetBlocksOut(Inner, NextEntries, &Blocks);
        BlockSet JustInner;
        JustInner.insert(Inner);
        for (BlockSet::iterator iter = NextEntries.begin(); iter != NextEntries.end(); iter++) {
          Solipsize(*iter, Branch::Break, Simple, JustInner);
        }
      }
      return Simple;
    }

    Shape *MakeLoop(BlockSet &Blocks, BlockSet& Entries, BlockSet &NextEntries) {
      // Find the inner blocks in this loop. Proceed backwards from the entries until
      // you reach a seen block, collecting as you go.
      BlockSet InnerBlocks;
      BlockSet Queue = Entries;
      while (Queue.size() > 0) {
        Block *Curr = *(Queue.begin());
        Queue.erase(Queue.begin());
        if (!contains(InnerBlocks, Curr)) {
          // This element is new, mark it as inner and remove from outer
          InnerBlocks.insert(Curr);
          Blocks.erase(Curr);
          // Add the elements prior to it
          for (BlockSet::iterator iter = Curr->BranchesIn.begin(); iter != Curr->BranchesIn.end(); iter++) {
            Queue.insert(*iter);
          }
#if 0
          // Add elements it leads to, if they are dead ends. There is no reason not to hoist dead ends
          // into loops, as it can avoid multiple entries after the loop
          for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
            Block *Target = iter->first;
            if (Target->BranchesIn.size() <= 1 && Target->BranchesOut.size() == 0) {
              Queue.insert(Target);
            }
          }
#endif
        }
      }
      assert(InnerBlocks.size() > 0);

      for (BlockSet::iterator iter = InnerBlocks.begin(); iter != InnerBlocks.end(); iter++) {
        Block *Curr = *iter;
        for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
          Block *Possible = iter->first;
          if (!contains(InnerBlocks, Possible)) {
            NextEntries.insert(Possible);
          }
        }
      }

#if 0
      // We can avoid multiple next entries by hoisting them into the loop.
      if (NextEntries.size() > 1) {
        BlockBlockSetMap IndependentGroups;
        FindIndependentGroups(NextEntries, IndependentGroups, &InnerBlocks);

        while (IndependentGroups.size() > 0 && NextEntries.size() > 1) {
          Block *Min = nullptr;
          int MinSize = 0;
          for (BlockBlockSetMap::iterator iter = IndependentGroups.begin(); iter != IndependentGroups.end(); iter++) {
            Block *Entry = iter->first;
            BlockSet &Blocks = iter->second;
            if (!Min || Blocks.size() < MinSize) { // TODO: code size, not # of blocks
              Min = Entry;
              MinSize = Blocks.size();
            }
          }
          // check how many new entries this would cause
          BlockSet &Hoisted = IndependentGroups[Min];
          bool abort = false;
          for (BlockSet::iterator iter = Hoisted.begin(); iter != Hoisted.end() && !abort; iter++) {
            Block *Curr = *iter;
            for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
              Block *Target = iter->first;
              if (!contains(Hoisted, Target) && !contains(NextEntries, Target)) {
                // abort this hoisting
                abort = true;
                break;
              }
            }
          }
          if (abort) {
            IndependentGroups.erase(Min);
            continue;
          }
          // hoist this entry
          PrintDebug("hoisting %d into loop\n", Min->Id);
          NextEntries.erase(Min);
          for (BlockSet::iterator iter = Hoisted.begin(); iter != Hoisted.end(); iter++) {
            Block *Curr = *iter;
            InnerBlocks.insert(Curr);
            Blocks.erase(Curr);
          }
          IndependentGroups.erase(Min);
        }
      }
#endif

      PrintDebug("creating loop block:\n", 0);
      DebugDump(InnerBlocks, "  inner blocks:");
      DebugDump(Entries, "  inner entries:");
      DebugDump(Blocks, "  outer blocks:");
      DebugDump(NextEntries, "  outer entries:");

      LoopShape *Loop = new LoopShape();
      Notice(Loop);

      // Solipsize the loop, replacing with break/continue and marking branches as Processed (will not affect later calculations)
      // A. Branches to the loop entries become a continue to this shape
      for (BlockSet::iterator iter = Entries.begin(); iter != Entries.end(); iter++) {
        Solipsize(*iter, Branch::Continue, Loop, InnerBlocks);
      }
      // B. Branches to outside the loop (a next entry) become breaks on this shape
      for (BlockSet::iterator iter = NextEntries.begin(); iter != NextEntries.end(); iter++) {
        Solipsize(*iter, Branch::Break, Loop, InnerBlocks);
      }
      // Finish up
      Shape *Inner = Process(InnerBlocks, Entries);
      Loop->Inner = Inner;
      Loop->Entries = Entries;
      return Loop;
    }

    // For each entry, find the independent group reachable by it. The independent group is
    // the entry itself, plus all the blocks it can reach that cannot be directly reached by another entry. Note that we
    // ignore directly reaching the entry itself by another entry.
    //   @param Ignore - previous blocks that are irrelevant
    void FindIndependentGroups(BlockSet &Entries, BlockBlockSetMap& IndependentGroups, BlockSet *Ignore = nullptr) {
      typedef std::map<Block*, Block*> BlockBlockMap;

      struct HelperClass {
        BlockBlockSetMap& IndependentGroups;
        BlockBlockMap Ownership; // For each block, which entry it belongs to. We have reached it from there.

        HelperClass(BlockBlockSetMap& IndependentGroupsInit) : IndependentGroups(IndependentGroupsInit) {}
        void InvalidateWithChildren(Block *New) { // TODO: rename New
          BlockList ToInvalidate; // Being in the list means you need to be invalidated
          ToInvalidate.push_back(New);
          while (ToInvalidate.size() > 0) {
            Block *Invalidatee = ToInvalidate.front();
            ToInvalidate.pop_front();
            Block *Owner = Ownership[Invalidatee];
            if (contains(IndependentGroups, Owner)) { // Owner may have been invalidated, do not add to IndependentGroups!
              IndependentGroups[Owner].erase(Invalidatee);
            }
            if (Ownership[Invalidatee]) { // may have been seen before and invalidated already
              Ownership[Invalidatee] = nullptr;
              for (BlockBranchMap::iterator iter = Invalidatee->BranchesOut.begin(); iter != Invalidatee->BranchesOut.end(); iter++) {
                Block *Target = iter->first;
                BlockBlockMap::iterator Known = Ownership.find(Target);
                if (Known != Ownership.end()) {
                  Block *TargetOwner = Known->second;
                  if (TargetOwner) {
                    ToInvalidate.push_back(Target);
                  }
                }
              }
            }
          }
        }
      };
      HelperClass Helper(IndependentGroups);

      // We flow out from each of the entries, simultaneously.
      // When we reach a new block, we add it as belonging to the one we got to it from.
      // If we reach a new block that is already marked as belonging to someone, it is reachable by
      // two entries and is not valid for any of them. Remove it and all it can reach that have been
      // visited.

      BlockList Queue; // Being in the queue means we just added this item, and we need to add its children
      for (BlockSet::iterator iter = Entries.begin(); iter != Entries.end(); iter++) {
        Block *Entry = *iter;
        Helper.Ownership[Entry] = Entry;
        IndependentGroups[Entry].insert(Entry);
        Queue.push_back(Entry);
      }
      while (Queue.size() > 0) {
        Block *Curr = Queue.front();
        Queue.pop_front();
        Block *Owner = Helper.Ownership[Curr]; // Curr must be in the ownership map if we are in the queue
        if (!Owner) continue; // we have been invalidated meanwhile after being reached from two entries
        // Add all children
        for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
          Block *New = iter->first;
          BlockBlockMap::iterator Known = Helper.Ownership.find(New);
          if (Known == Helper.Ownership.end()) {
            // New node. Add it, and put it in the queue
            Helper.Ownership[New] = Owner;
            IndependentGroups[Owner].insert(New);
            Queue.push_back(New);
            continue;
          }
          Block *NewOwner = Known->second;
          if (!NewOwner) continue; // We reached an invalidated node
          if (NewOwner != Owner) {
            // Invalidate this and all reachable that we have seen - we reached this from two locations
            Helper.InvalidateWithChildren(New);
          }
          // otherwise, we have the same owner, so do nothing
        }
      }

      // Having processed all the interesting blocks, we remain with just one potential issue:
      // If a->b, and a was invalidated, but then b was later reached by someone else, we must
      // invalidate b. To check for this, we go over all elements in the independent groups,
      // if an element has a parent which does *not* have the same owner, we must remove it
      // and all its children.

      for (BlockSet::iterator iter = Entries.begin(); iter != Entries.end(); iter++) {
        BlockSet &CurrGroup = IndependentGroups[*iter];
        BlockList ToInvalidate;
        for (BlockSet::iterator iter = CurrGroup.begin(); iter != CurrGroup.end(); iter++) {
          Block *Child = *iter;
          for (BlockSet::iterator iter = Child->BranchesIn.begin(); iter != Child->BranchesIn.end(); iter++) {
            Block *Parent = *iter;
            if (Ignore && contains(*Ignore, Parent)) continue;
            if (Helper.Ownership[Parent] != Helper.Ownership[Child]) {
              ToInvalidate.push_back(Child);
            }
          }
        }
        while (ToInvalidate.size() > 0) {
          Block *Invalidatee = ToInvalidate.front();
          ToInvalidate.pop_front();
          Helper.InvalidateWithChildren(Invalidatee);
        }
      }

      // Remove empty groups
      for (BlockSet::iterator iter = Entries.begin(); iter != Entries.end(); iter++) {
        if (IndependentGroups[*iter].size() == 0) {
          IndependentGroups.erase(*iter);
        }
      }

#ifdef RELOOPER_DEBUG
      PrintDebug("Investigated independent groups:\n");
      for (BlockBlockSetMap::iterator iter = IndependentGroups.begin(); iter != IndependentGroups.end(); iter++) {
        DebugDump(iter->second, " group: ");
      }
#endif
    }

    Shape *MakeMultiple(BlockSet &Blocks, BlockSet& Entries, BlockBlockSetMap& IndependentGroups, BlockSet &NextEntries, bool IsCheckedMultiple) {
      PrintDebug("creating multiple block with %d inner groups\n", IndependentGroups.size());
      MultipleShape *Multiple = new MultipleShape();
      Notice(Multiple);
      BlockSet CurrEntries;
      for (BlockBlockSetMap::iterator iter = IndependentGroups.begin(); iter != IndependentGroups.end(); iter++) {
        Block *CurrEntry = iter->first;
        BlockSet &CurrBlocks = iter->second;
        PrintDebug("  multiple group with entry %d:\n", CurrEntry->Id);
        DebugDump(CurrBlocks, "    ");
        // Create inner block
        CurrEntries.clear();
        CurrEntries.insert(CurrEntry);
        for (BlockSet::iterator iter = CurrBlocks.begin(); iter != CurrBlocks.end(); iter++) {
          Block *CurrInner = *iter;
          // Remove the block from the remaining blocks
          Blocks.erase(CurrInner);
          // Find new next entries and fix branches to them
          for (BlockBranchMap::iterator iter = CurrInner->BranchesOut.begin(); iter != CurrInner->BranchesOut.end();) {
            Block *CurrTarget = iter->first;
            BlockBranchMap::iterator Next = iter;
            Next++;
            if (!contains(CurrBlocks, CurrTarget)) {
              NextEntries.insert(CurrTarget);
              Solipsize(CurrTarget, Branch::Break, Multiple, CurrBlocks); 
            }
            iter = Next; // increment carefully because Solipsize can remove us
          }
        }
        Multiple->InnerMap[CurrEntry->Id] = Process(CurrBlocks, CurrEntries);
        if (IsCheckedMultiple) {
          CurrEntry->IsCheckedMultipleEntry = true;
        }
      }
      DebugDump(Blocks, "  remaining blocks after multiple:");
      // Add entries not handled as next entries, they are deferred
      for (BlockSet::iterator iter = Entries.begin(); iter != Entries.end(); iter++) {
        Block *Entry = *iter;
        if (!contains(IndependentGroups, Entry)) {
          NextEntries.insert(Entry);
        }
      }
      return Multiple;
    }

    // Main function.
    // Process a set of blocks with specified entries, returns a shape
    // The Make* functions receive a NextEntries. If they fill it with data, those are the entries for the
    //   ->Next block on them, and the blocks are what remains in Blocks (which Make* modify). In this way
    //   we avoid recursing on Next (imagine a long chain of Simples, if we recursed we could blow the stack).
    Shape *Process(BlockSet &Blocks, BlockSet& InitialEntries) {
      PrintDebug("Process() called\n", 0);
      BlockSet *Entries = &InitialEntries;
      BlockSet TempEntries[2];
      int CurrTempIndex = 0;
      BlockSet *NextEntries;
      Shape *Ret = nullptr;
      Shape *Prev = nullptr;
      #define Make(call) \
        Shape *Temp = call; \
        if (Prev) Prev->Next = Temp; \
        if (!Ret) Ret = Temp; \
        if (!NextEntries->size()) { PrintDebug("Process() returning\n", 0); return Ret; } \
        Prev = Temp; \
        Entries = NextEntries; \
        continue;
      while (1) {
        PrintDebug("Process() running\n", 0);
        DebugDump(Blocks, "  blocks : ");
        DebugDump(*Entries, "  entries: ");

        CurrTempIndex = 1-CurrTempIndex;
        NextEntries = &TempEntries[CurrTempIndex];
        NextEntries->clear();

        if (Entries->size() == 0) return Ret;
        if (Entries->size() == 1) {
          Block *Curr = *(Entries->begin());
          if (Curr->BranchesIn.size() == 0) {
            // One entry, no looping ==> Simple
            Make(MakeSimple(Blocks, Curr, *NextEntries));
          }
          // One entry, looping ==> Loop
          Make(MakeLoop(Blocks, *Entries, *NextEntries));
        }

        // More than one entry, try to eliminate through a Multiple groups of
        // independent blocks from an entry/ies. It is important to remove through
        // multiples as opposed to looping since the former is more performant.
        BlockBlockSetMap IndependentGroups;
        FindIndependentGroups(*Entries, IndependentGroups);

        PrintDebug("Independent groups: %d\n", IndependentGroups.size());

        if (IndependentGroups.size() > 0) {
          // We can handle a group in a multiple if its entry cannot be reached by another group.
          // Note that it might be reachable by itself - a loop. But that is fine, we will create
          // a loop inside the multiple block, which is both the performant order to do it, and
          // preserves the property that a loop will always reach an entry.
          for (BlockBlockSetMap::iterator iter = IndependentGroups.begin(); iter != IndependentGroups.end();) {
            Block *Entry = iter->first;
            BlockSet &Group = iter->second;
            BlockBlockSetMap::iterator curr = iter++; // iterate carefully, we may delete
            for (BlockSet::iterator iterBranch = Entry->BranchesIn.begin(); iterBranch != Entry->BranchesIn.end(); iterBranch++) {
              Block *Origin = *iterBranch;
              if (!contains(Group, Origin)) {
                // Reached from outside the group, so we cannot handle this
                PrintDebug("Cannot handle group with entry %d because of incoming branch from %d\n", Entry->Id, Origin->Id);
                IndependentGroups.erase(curr);
                break;
              }
            }
          }

          // As an optimization, if we have 2 independent groups, and one is a small dead end, we can handle only that dead end.
          // The other then becomes a Next - without nesting in the code and recursion in the analysis.
          // TODO: if the larger is the only dead end, handle that too
          // TODO: handle >2 groups
          // TODO: handle not just dead ends, but also that do not branch to the NextEntries. However, must be careful
          //       there since we create a Next, and that Next can prevent eliminating a break (since we no longer
          //       naturally reach the same place), which may necessitate a one-time loop, which makes the unnesting
          //       pointless.
          if (IndependentGroups.size() == 2) {
            // Find the smaller one
            BlockBlockSetMap::iterator iter = IndependentGroups.begin();
            Block *SmallEntry = iter->first;
            int SmallSize = iter->second.size();
            iter++;
            Block *LargeEntry = iter->first;
            int LargeSize = iter->second.size();
            if (SmallSize != LargeSize) { // ignore the case where they are identical - keep things symmetrical there
              if (SmallSize > LargeSize) {
                Block *Temp = SmallEntry;
                SmallEntry = LargeEntry;
                LargeEntry = Temp; // Note: we did not flip the Sizes too, they are now invalid. TODO: use the smaller size as a limit?
              }
              // Check if dead end
              bool DeadEnd = true;
              BlockSet &SmallGroup = IndependentGroups[SmallEntry];
              for (BlockSet::iterator iter = SmallGroup.begin(); iter != SmallGroup.end(); iter++) {
                Block *Curr = *iter;
                for (BlockBranchMap::iterator iter = Curr->BranchesOut.begin(); iter != Curr->BranchesOut.end(); iter++) {
                  Block *Target = iter->first;
                  if (!contains(SmallGroup, Target)) {
                    DeadEnd = false;
                    break;
                  }
                }
                if (!DeadEnd) break;
              }
              if (DeadEnd) {
                PrintDebug("Removing nesting by not handling large group because small group is dead end\n", 0);
                IndependentGroups.erase(LargeEntry);
              }
            }
          }

          PrintDebug("Handleable independent groups: %d\n", IndependentGroups.size());

          if (IndependentGroups.size() > 0) {
            // Some groups removable ==> Multiple
            // This is a checked multiple if it has an entry that is an entry to this Process call, that is,
            // if we can reach it from outside this set of blocks, then we must check the label variable
            // to do so. Otherwise, if it is just internal blocks, those can always be jumped to forward,
            // without using the label variable
            bool Checked = false;
            for (auto* Entry : *Entries) {
              if (InitialEntries.count(Entry)) {
                Checked = true;
                break;
              }
            }
            Make(MakeMultiple(Blocks, *Entries, IndependentGroups, *NextEntries, Checked));
          }
        }
        // No independent groups, must be loopable ==> Loop
        Make(MakeLoop(Blocks, *Entries, *NextEntries));
      }
    }
  };

  // Main

  BlockSet AllBlocks;
  for (BlockSet::iterator iter = Pre.Live.begin(); iter != Pre.Live.end(); iter++) {
    Block *Curr = *iter;
    AllBlocks.insert(Curr);
#ifdef RELOOPER_DEBUG
    PrintDebug("Adding block %d (%s)\n", Curr->Id, Curr->Code);
#endif
  }

  BlockSet Entries;
  Entries.insert(Entry);
  Root = Analyzer(this).Process(AllBlocks, Entries);
  assert(Root);
}

wasm::Expression* Relooper::Render(RelooperBuilder& Builder) {
  assert(Root);
  auto* ret = Root->Render(Builder, false);
  // we may use the same name for more than one block in HandleFollowupMultiples
  wasm::UniqueNameMapper::uniquify(ret);
  return ret;
}

#ifdef RELOOPER_DEBUG
// Debugging

void Debugging::Dump(BlockSet &Blocks, const char *prefix) {
  if (prefix) printf("%s ", prefix);
  for (BlockSet::iterator iter = Blocks.begin(); iter != Blocks.end(); iter++) {
    Block *Curr = *iter;
    printf("%d:\n", Curr->Id);
    for (BlockBranchMap::iterator iter2 = Curr->BranchesOut.begin(); iter2 != Curr->BranchesOut.end(); iter2++) {
      Block *Other = iter2->first;
      printf("  -> %d\n", Other->Id);
      assert(contains(Other->BranchesIn, Curr));
    }
  }
}

void Debugging::Dump(Shape *S, const char *prefix) {
  if (prefix) printf("%s ", prefix);
  if (!S) {
    printf(" (null)\n");
    return;
  }
  printf(" %d ", S->Id);
  if (SimpleShape *Simple = Shape::IsSimple(S)) {
    printf("<< Simple with block %d\n", Simple->Inner->Id);
  } else if (MultipleShape *Multiple = Shape::IsMultiple(S)) {
    printf("<< Multiple\n");
    for (IdShapeMap::iterator iter = Multiple->InnerMap.begin(); iter != Multiple->InnerMap.end(); iter++) {
      printf("     with entry %d\n", iter->first);
    }
  } else if (Shape::IsLoop(S)) {
    printf("<< Loop\n");
  } else {
    abort();
  }
}

static void PrintDebug(const char *Format, ...) {
  printf("// ");
  va_list Args;
  va_start(Args, Format);
  vprintf(Format, Args);
  va_end(Args);
}
#endif

} // namespace CFG
