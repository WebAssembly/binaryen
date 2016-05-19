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

/*
This is an optimized C++ implemention of the Relooper algorithm originally
developed as part of Emscripten. This implementation includes optimizations
added since the original academic paper [1] was published about it.

[1] Alon Zakai. 2011. Emscripten: an LLVM-to-JavaScript compiler. In Proceedings of the ACM international conference companion on Object oriented programming systems languages and applications companion (SPLASH '11). ACM, New York, NY, USA, 301-312. DOI=10.1145/2048147.2048224 http://doi.acm.org/10.1145/2048147.2048224
*/

#include <assert.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

#include <map>
#include <deque>
#include <set>
#include <list>

#include "wasm.h"
#include "wasm-builder.h"

namespace CFG {

class RelooperBuilder : public wasm::Builder {
  wasm::Index labelHelper;

public:
  RelooperBuilder(wasm::Module& wasm, wasm::Index labelHelper) : wasm::Builder(wasm), labelHelper(labelHelper) {}

  wasm::GetLocal* makeGetLabel() {
    return makeGetLocal(labelHelper, wasm::i32);
  }
  wasm::SetLocal* makeSetLabel(wasm::Index value) {
    return makeSetLocal(labelHelper, makeConst(wasm::Literal(int32_t(value))));
  }
  wasm::Binary* makeCheckLabel(wasm::Index value) {
    return makeBinary(wasm::EqInt32, makeGetLabel(), makeConst(wasm::Literal(int32_t(value))));
  }
  wasm::Break* makeBreak(int id) {
    return wasm::Builder::makeBreak(getBreakName(id));
  }
  wasm::Break* makeContinue(int id) {
    return wasm::Builder::makeBreak(getContinueName(id));
  }

  wasm::Name getBreakName(int id) {
    return wasm::Name(std::string("shape$") + std::to_string(id) + "$break");
  }
  wasm::Name getContinueName(int id) {
    return wasm::Name(std::string("shape$") + std::to_string(id) + "$continue");
  }
};

struct Block;
struct Shape;

// Info about a branching from one block to another
struct Branch {
  enum FlowType {
    Direct = 0,   // We will directly reach the right location through other means, no need for continue or break
    Break = 1,
    Continue = 2,
    Nested = 3    // This code is directly reached, but we must be careful to ensure it is nested in an if - it is not reached
                  // unconditionally, other code paths exist alongside it that we need to make sure do not intertwine
  };
  Shape *Ancestor; // If not NULL, this shape is the relevant one for purposes of getting to the target block. We break or continue on it
  Branch::FlowType Type; // If Ancestor is not NULL, this says whether to break or continue

  // A branch either has a condition expression if the block ends in ifs, or if the block ends in a switch, then an index, which
  // becomes the index in the table of the switch.
  union {
    wasm::Expression* Condition; // The condition for which we branch. For example, "my_var == 1". Conditions are checked one by one. One of the conditions should have NULL as the condition, in which case it is the default
    wasm::Index Index; // The index in the table of the switch that we correspond do
  };

  wasm::Expression* Code; // If provided, code that is run right before the branch is taken. This is useful for phis

  Branch(wasm::Expression* ConditionInit, wasm::Expression* CodeInit = nullptr);
  Branch(wasm::Index IndexInit, wasm::Expression* CodeInit = nullptr);

  // Emits code for branch
   wasm::Expression* Render(RelooperBuilder& Builder, Block *Target, bool SetLabel);
};

// like std::set, except that begin() -> end() iterates in the
// order that elements were added to the set (not in the order
// of operator<(T, T))
template<typename T>
struct InsertOrderedSet
{
  std::map<T, typename std::list<T>::iterator>  Map;
  std::list<T>                                  List;

  typedef typename std::list<T>::iterator iterator;
  iterator begin() { return List.begin(); }
  iterator end() { return List.end(); }

  void erase(const T& val) {
    auto it = Map.find(val);
    if (it != Map.end()) {
      List.erase(it->second);
      Map.erase(it);
    }
  }

  void erase(iterator position) {
    Map.erase(*position);
    List.erase(position);
  }

  // cheating a bit, not returning the iterator
  void insert(const T& val) {
    auto it = Map.find(val);
    if (it == Map.end()) {
      List.push_back(val);
      Map.insert(std::make_pair(val, --List.end()));
    }
  }

  size_t size() const { return Map.size(); }

  void clear() {
    Map.clear();
    List.clear();
  }

  size_t count(const T& val) const { return Map.count(val); }

  InsertOrderedSet() {}
  InsertOrderedSet(const InsertOrderedSet& other) {
    for (auto i : other.List) {
      insert(i); // inserting manually creates proper iterators
    }
  }
  InsertOrderedSet& operator=(const InsertOrderedSet& other) {
    abort(); // TODO, watch out for iterators
  }
};

// like std::map, except that begin() -> end() iterates in the
// order that elements were added to the map (not in the order
// of operator<(Key, Key))
template<typename Key, typename T>
struct InsertOrderedMap
{
  std::map<Key, typename std::list<std::pair<Key,T>>::iterator> Map;
  std::list<std::pair<Key,T>>                                   List;

  T& operator[](const Key& k) {
    auto it = Map.find(k);
    if (it == Map.end()) {
      List.push_back(std::make_pair(k, T()));
      auto e = --List.end();
      Map.insert(std::make_pair(k, e));
      return e->second;
    }
    return it->second->second;
  }

  typedef typename std::list<std::pair<Key,T>>::iterator iterator;
  iterator begin() { return List.begin(); }
  iterator end() { return List.end(); }

  void erase(const Key& k) {
    auto it = Map.find(k);
    if (it != Map.end()) {
      List.erase(it->second);
      Map.erase(it);
    }
  }

  void erase(iterator position) {
    erase(position->first);
  }

  size_t size() const { return Map.size(); }
  size_t count(const Key& k) const { return Map.count(k); }

  InsertOrderedMap() {}
  InsertOrderedMap(InsertOrderedMap& other) {
    abort(); // TODO, watch out for iterators
  }
  InsertOrderedMap& operator=(const InsertOrderedMap& other) {
    abort(); // TODO, watch out for iterators
  }
};


typedef InsertOrderedSet<Block*> BlockSet;
typedef InsertOrderedMap<Block*, Branch*> BlockBranchMap;

// Represents a basic block of code - some instructions that end with a
// control flow modifier (a branch, return or throw).
struct Block {
  // Branches become processed after we finish the shape relevant to them. For example,
  // when we recreate a loop, branches to the loop start become continues and are now
  // processed. When we calculate what shape to generate from a set of blocks, we ignore
  // processed branches.
  // Blocks own the Branch objects they use, and destroy them when done.
  BlockBranchMap BranchesOut;
  BlockSet BranchesIn;
  BlockBranchMap ProcessedBranchesOut;
  BlockSet ProcessedBranchesIn;
  Shape *Parent; // The shape we are directly inside
  int Id; // A unique identifier, defined when added to relooper. Note that this uniquely identifies a *logical* block - if we split it, the two instances have the same content *and* the same Id
  wasm::Expression* Code; // The code in this block. This can be arbitrary wasm code, including internal control flow, it should just not branch to the outside
  wasm::Expression* SwitchCondition; // If nullptr, then this block ends in ifs (or nothing). otherwise, this block ends in a switch, done on this condition
  bool IsCheckedMultipleEntry; // If true, we are a multiple entry, so reaching us requires setting the label variable

  Block(wasm::Expression* CodeInit, wasm::Expression* SwitchConditionInit = nullptr);
  ~Block();

  void AddBranchTo(Block *Target, wasm::Expression* Condition, wasm::Expression* Code = nullptr);
  void AddBranchTo(Block *Target, wasm::Index Index, wasm::Expression* Code = nullptr);

  // Emit code for the block, including its contents and branchings out
  wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop);
};

// Represents a structured control flow shape, one of
//
//  Simple: No control flow at all, just instructions. If several
//          blocks, then 
//
//  Multiple: A shape with more than one entry. If the next block to
//            be entered is among them, we run it and continue to
//            the next shape, otherwise we continue immediately to the
//            next shape.
//
//  Loop: An infinite loop.
//
//  Emulated: Control flow is managed by a switch in a loop. This
//            is necessary in some cases, for example when control
//            flow is not known until runtime (indirect branches,
//            setjmp returns, etc.)
//

struct SimpleShape;
struct MultipleShape;
struct LoopShape;
struct EmulatedShape;

struct Shape {
  int Id; // A unique identifier. Used to identify loops, labels are Lx where x is the Id. Defined when added to relooper
  Shape *Next; // The shape that will appear in the code right after this one
  Shape *Natural; // The shape that control flow gets to naturally (if there is Next, then this is Next)

  enum ShapeType {
    Simple,
    Multiple,
    Loop,
    Emulated
  };
  ShapeType Type;

  Shape(ShapeType TypeInit) : Id(-1), Next(NULL), Type(TypeInit) {}
  virtual ~Shape() {}

  virtual wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop) = 0;

  static SimpleShape *IsSimple(Shape *It) { return It && It->Type == Simple ? (SimpleShape*)It : NULL; }
  static MultipleShape *IsMultiple(Shape *It) { return It && It->Type == Multiple ? (MultipleShape*)It : NULL; }
  static LoopShape *IsLoop(Shape *It) { return It && It->Type == Loop ? (LoopShape*)It : NULL; }
  static EmulatedShape *IsEmulated(Shape *It) { return It && It->Type == Emulated ? (EmulatedShape*)It : NULL; }
};

struct SimpleShape : public Shape {
  Block *Inner;

  SimpleShape() : Shape(Simple), Inner(NULL) {}
  wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop) override;
};

// Blocks with the same id were split and are identical, so we just care about ids in Multiple entries
typedef std::map<int, Shape*> IdShapeMap;

struct MultipleShape : public Shape {
  IdShapeMap InnerMap; // entry block ID -> shape

  MultipleShape() : Shape(Multiple) {}

  wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop) override;
};

struct LoopShape : public Shape {
  Shape *Inner;

  LoopShape() : Shape(Loop), Inner(NULL) {}
  wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop) override;
};

// TODO EmulatedShape is only partially functional. Currently it can be used for the
//      entire set of blocks being relooped, but not subsets.
struct EmulatedShape : public Shape {
  Block *Entry;
  BlockSet Blocks;

  EmulatedShape() : Shape(Emulated) { }
  wasm::Expression* Render(RelooperBuilder& Builder, bool InLoop) override;
};

// Implements the relooper algorithm for a function's blocks.
//
// Usage:
//  1. Instantiate this struct.
//  2. Call AddBlock with the blocks you have. Each should already
//     have its branchings in specified (the branchings out will
//     be calculated by the relooper).
//  3. Call Render().
//
// Implementation details: The Relooper instance has
// ownership of the blocks and shapes, and frees them when done.
struct Relooper {
  std::deque<Block*> Blocks;
  std::deque<Shape*> Shapes;
  Shape *Root;
  bool Emulate;
  bool MinSize;
  int BlockIdCounter;
  int ShapeIdCounter;

  Relooper();
  ~Relooper();

  void AddBlock(Block *New, int Id=-1);

  // Calculates the shapes
  void Calculate(Block *Entry);

  // Renders the result.
  wasm::Expression* Render(RelooperBuilder& Builder);

  // Sets whether we must emulate everything with switch-loop code
  void SetEmulate(int E) { Emulate = !!E; }

  // Sets us to try to minimize size
  void SetMinSize(bool MinSize_) { MinSize = MinSize_; }
};

typedef InsertOrderedMap<Block*, BlockSet> BlockBlockSetMap;

#ifdef RELOOPER_DEBUG
struct Debugging {
  static void Dump(BlockSet &Blocks, const char *prefix=NULL);
  static void Dump(Shape *S, const char *prefix=NULL);
};
#endif

} // namespace CFG
