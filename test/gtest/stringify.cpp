/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "passes/stringify-walker.h"
#include "wasm-type.h"
#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

struct FuncStart {
  Function* func;
  bool operator==(const FuncStart& other) const { return func == other.func; }
};

struct BlockStart {
  Block* block;
  bool operator==(const BlockStart& other) const {
    return block == other.block;
  }
};

struct IfStart {
  If* iff;
  bool operator==(const IfStart& other) const { return iff == other.iff; }
};

struct ElseStart {
  bool operator==(const ElseStart&) const { return true; }
};

struct LoopStart {
  Loop* loop;
  bool operator==(const LoopStart& other) const { return loop == other.loop; }
};

struct TryStart {
  Try* tryy;
  bool operator==(const TryStart& other) const { return tryy == other.tryy; }
};

struct CatchStart {
  Name tag;
  bool operator==(const CatchStart& other) const { return tag == other.tag; }
};

struct CatchAllStart {
  bool operator==(const CatchAllStart&) const { return true; }
};

struct TryTableStart {
  TryTable* tryt;
  bool operator==(const TryTableStart& other) const {
    return tryt == other.tryt;
  }
};

struct End {
  Expression* curr;
  bool operator==(const End& other) const { return curr == other.curr; }
};

using Delimiter = std::variant<FuncStart,
                               BlockStart,
                               IfStart,
                               ElseStart,
                               LoopStart,
                               TryStart,
                               CatchStart,
                               CatchAllStart,
                               TryTableStart,
                               End>;

using Visited = std::variant<Expression*, Delimiter>;

std::ostream& operator<<(std::ostream& o, const FuncStart& v) {
  return o << "FuncStart(" << v.func->name << ")";
}

std::ostream& operator<<(std::ostream& o, const BlockStart& v) {
  return o << "BlockStart(" << v.block->name << ")";
}

std::ostream& operator<<(std::ostream& o, const IfStart& v) {
  return o << "IfStart(" << v.iff << ")";
}

std::ostream& operator<<(std::ostream& o, const ElseStart& v) {
  return o << "ElseStart";
}

std::ostream& operator<<(std::ostream& o, const LoopStart& v) {
  return o << "LoopStart(" << v.loop->name << ")";
}

std::ostream& operator<<(std::ostream& o, const TryStart& v) {
  return o << "TryStart(" << v.tryy->name << ")";
}

std::ostream& operator<<(std::ostream& o, const CatchStart& v) {
  return o << "CatchStart(" << v.tag << ")";
}

std::ostream& operator<<(std::ostream& o, const CatchAllStart& v) {
  return o << "CatchAllStart";
}

std::ostream& operator<<(std::ostream& o, const TryTableStart& v) {
  return o << "TryTableStart(" << v.tryt << ")";
}

std::ostream& operator<<(std::ostream& o, const End& v) {
  return o << "End(" << v.curr << ")";
}

std::ostream& operator<<(std::ostream& o, const Visited& v) {
  std::visit([&](auto&& arg) { o << arg; }, v);
  return o;
}

struct TestStringifyWalker : StringifyWalker<TestStringifyWalker> {
  using SeparatorReason = StringifyWalker<TestStringifyWalker>::SeparatorReason;

  std::vector<Visited> visited;

  void visitExpression(Expression* curr) { visited.push_back(curr); }

  void addUniqueSymbol(SeparatorReason curr) {
    if (auto* func = curr.getFuncStart()) {
      visited.push_back(FuncStart{func->func});
    } else if (auto* block = curr.getBlockStart()) {
      visited.push_back(BlockStart{block->block});
    } else if (auto* iff = curr.getIfStart()) {
      visited.push_back(IfStart{iff->iff});
    } else if (curr.getElseStart()) {
      visited.push_back(ElseStart{});
    } else if (auto* loop = curr.getLoopStart()) {
      visited.push_back(LoopStart{loop->loop});
    } else if (auto* tryy = curr.getTryStart()) {
      visited.push_back(TryStart{tryy->tryy});
    } else if (auto* tag = curr.getCatchStart()) {
      visited.push_back(CatchStart{tag->tag});
    } else if (curr.getCatchAllStart()) {
      visited.push_back(CatchAllStart{});
    } else if (auto* tryt = curr.getTryTableStart()) {
      visited.push_back(TryTableStart{tryt->tryt});
    } else if (auto* end = curr.getEnd()) {
      visited.push_back(End{end->curr});
    }
  }
};

TEST(StringifyWalkerTest, Nop) {
  Module wasm;
  Builder builder(wasm);

  // (func $func nop)
  auto* nop = builder.makeNop();
  auto f = builder.makeFunction("func", Signature(), {}, nop);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{
    Visited(FuncStart{func}), Visited(nop), Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, Add) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (i32.add
  //     (i32.const 0)
  //     (i32.const 1)
  //   )
  // )
  auto* a = builder.makeConst(uint32_t(0));
  auto* b = builder.makeConst(uint32_t(1));
  auto* add = builder.makeBinary(AddInt32, a, b);
  auto f = builder.makeFunction("func", Signature(), {}, add);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(a),
                                Visited(b),
                                Visited(add),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, EmptyBlock) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (block)
  // )
  auto* block = builder.makeBlock();
  auto f = builder.makeFunction("func", Signature(), {}, block);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(block),
                                Visited(End{nullptr}),
                                Visited(BlockStart{block}),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, SingletonBlock) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (block
  //     (nop)
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* block = builder.makeBlock({nop});
  auto f = builder.makeFunction("func", Signature(), {}, block);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(block),
                                Visited(End{nullptr}),
                                Visited(BlockStart{block}),
                                Visited(nop),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, Block) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (block
  //     (nop)
  //     (nop)
  //     (nop)
  //   )
  // )
  auto* nop1 = builder.makeNop();
  auto* nop2 = builder.makeNop();
  auto* nop3 = builder.makeNop();
  auto* block = builder.makeBlock({nop1, nop2, nop3});
  auto f = builder.makeFunction("func", Signature(), {}, block);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(block),
                                Visited(End{nullptr}),
                                Visited(BlockStart{block}),
                                Visited(nop1),
                                Visited(nop2),
                                Visited(nop3),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, NestedBlocks) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (block $a
  //     (block $b
  //       (block $c
  //         (nop)
  //       )
  //     )
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* c = builder.makeBlock({nop});
  auto* b = builder.makeBlock({c});
  auto* a = builder.makeBlock({b});
  auto f = builder.makeFunction("func", Signature(), {}, a);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(a),
                                Visited(End{nullptr}),
                                Visited(BlockStart{a}),
                                Visited(b),
                                Visited(End{nullptr}),
                                Visited(BlockStart{b}),
                                Visited(c),
                                Visited(End{nullptr}),
                                Visited(BlockStart{c}),
                                Visited(nop),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, MixedBlock) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (block $a
  //     (block $b)
  //     (nop)
  //     (block $c)
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* b = builder.makeBlock();
  auto* c = builder.makeBlock();
  auto* a = builder.makeBlock({b, nop, c});
  auto f = builder.makeFunction("func", Signature(), {}, a);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited{FuncStart{func}},
                                Visited(a),
                                Visited(End{nullptr}),
                                Visited(BlockStart{a}),
                                Visited(b),
                                Visited(nop),
                                Visited(c),
                                Visited(End{nullptr}),
                                Visited(BlockStart{b}),
                                Visited(End{nullptr}),
                                Visited(BlockStart{c}),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, AddBlocks) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (i32.add
  //     (block (i32.const 0))
  //     (block (i32.const 1))
  //   )
  // )
  auto* c0 = builder.makeConst(uint32_t(0));
  auto* c1 = builder.makeConst(uint32_t(1));
  auto* lhs = builder.makeBlock({c0});
  auto* rhs = builder.makeBlock({c1});
  auto* add = builder.makeBinary(AddInt32, lhs, rhs);
  auto f = builder.makeFunction("func", Signature(), {}, add);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(lhs),
                                Visited(rhs),
                                Visited(add),
                                Visited(End{nullptr}),
                                Visited(BlockStart{lhs}),
                                Visited(c0),
                                Visited(End{nullptr}),
                                Visited(BlockStart{rhs}),
                                Visited(c1),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, IfElse) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (if
  //     (i32.const 1)
  //     (then (nop))
  //     (else (nop))
  //   )
  // )
  auto* cond = builder.makeConst(uint32_t(1));
  auto* ifTrue = builder.makeNop();
  auto* ifFalse = builder.makeNop();
  auto* iff = builder.makeIf(cond, ifTrue, ifFalse);
  auto f = builder.makeFunction("func", Signature(), {}, iff);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(cond),
                                Visited(iff),
                                Visited(End{nullptr}),
                                Visited(IfStart{iff}),
                                Visited(ifTrue),
                                Visited(ElseStart{}),
                                Visited(ifFalse),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, If) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (if
  //     (i32.const 1)
  //     (then (nop))
  //   )
  // )
  auto* cond = builder.makeConst(uint32_t(1));
  auto* ifTrue = builder.makeNop();
  auto* iff = builder.makeIf(cond, ifTrue);
  auto f = builder.makeFunction("func", Signature(), {}, iff);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(cond),
                                Visited(iff),
                                Visited(End{nullptr}),
                                Visited(IfStart{iff}),
                                Visited(ifTrue),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, IfNestedCondition) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (if
  //     (if
  //       (i32.const 1)
  //       (then (i32.const 2))
  //       (else (i32.const 3))
  //     )
  //     (then (nop))
  //     (else (nop))
  //   )
  // )
  auto* c1 = builder.makeConst(uint32_t(1));
  auto* c2 = builder.makeConst(uint32_t(2));
  auto* c3 = builder.makeConst(uint32_t(3));

  auto* cond = builder.makeIf(c1, c2, c3);
  auto* ifTrue = builder.makeNop();
  auto* ifFalse = builder.makeNop();
  auto* iff = builder.makeIf(cond, ifTrue, ifFalse);
  auto f = builder.makeFunction("func", Signature(), {}, iff);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(c1),
                                Visited(cond),
                                Visited(iff),
                                Visited(End{nullptr}),
                                Visited(IfStart{cond}),
                                Visited(c2),
                                Visited(ElseStart{}),
                                Visited(c3),
                                Visited(End{nullptr}),
                                Visited(IfStart{iff}),
                                Visited(ifTrue),
                                Visited(ElseStart{}),
                                Visited(ifFalse),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, Loop) {
  Module wasm;
  Builder builder(wasm);

  // (func $func (loop (nop)))
  auto* nop = builder.makeNop();
  auto* loop = builder.makeLoop("loop", nop);
  auto f = builder.makeFunction("func", Signature(), {}, loop);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(loop),
                                Visited(End{nullptr}),
                                Visited(LoopStart{loop}),
                                Visited(nop),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, Try) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (try
  //     (do (nop))
  //   )
  // )
  auto* nop = builder.makeNop();
  std::vector<Name> tags;
  std::vector<Expression*> bodies;
  auto* tryy = builder.makeTry(nop, tags, bodies);
  auto f = builder.makeFunction("func", Signature(), {}, tryy);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(tryy),
                                Visited(End{nullptr}),
                                Visited(TryStart{tryy}),
                                Visited(nop),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, TryCatch) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (try
  //     (do (nop))
  //     (catch $e (nop))
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* body = builder.makeNop();
  std::vector<Name> tags{"e"};
  std::vector<Expression*> bodies{body};
  auto* tryy = builder.makeTry(nop, tags, bodies);
  auto f = builder.makeFunction("func", Signature(), {}, tryy);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(tryy),
                                Visited(End{nullptr}),
                                Visited(TryStart{tryy}),
                                Visited(nop),
                                Visited(CatchStart{"e"}),
                                Visited(body),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, TryCatchAll) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (try
  //     (do (nop))
  //     (catch_all (nop))
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* body = builder.makeNop();
  std::vector<Name> tags;
  std::vector<Expression*> bodies{body};
  auto* tryy = builder.makeTry(nop, tags, bodies);
  auto f = builder.makeFunction("func", Signature(), {}, tryy);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(tryy),
                                Visited(End{nullptr}),
                                Visited(TryStart{tryy}),
                                Visited(nop),
                                Visited(CatchAllStart{}),
                                Visited(body),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

TEST(StringifyWalkerTest, TryMultipleCatch) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (try
  //     (do (nop))
  //     (catch $e1 (nop))
  //     (catch $e2 (nop))
  //     (catch_all (nop))
  //   )
  // )
  auto* nop = builder.makeNop();
  auto* body1 = builder.makeNop();
  auto* body2 = builder.makeNop();
  auto* body3 = builder.makeNop();
  std::vector<Name> tags{"e1", "e2"};
  std::vector<Expression*> bodies{body1, body2, body3};
  auto* tryy = builder.makeTry(nop, tags, bodies);
  auto f = builder.makeFunction("func", Signature(), {}, tryy);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(tryy),
                                Visited(End{nullptr}),
                                Visited(TryStart{tryy}),
                                Visited(nop),
                                Visited(CatchStart{"e1"}),
                                Visited(body1),
                                Visited(CatchStart{"e2"}),
                                Visited(body2),
                                Visited(CatchAllStart{}),
                                Visited(body3),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}

// TEST(StringifyWalkerTest, TryDelegate) {
//   Module wasm;
//   Builder builder(wasm);

//   // (func $func
//   //   (try
//   //     (do (nop))
//   //     (delegate 0)
//   //   )
//   // )
//   auto* nop = builder.makeNop();
//   auto* tryy = builder.makeTry(nop, DELEGATE_CALLER_TARGET);
//   auto f = builder.makeFunction("func", Signature(), {}, tryy);
//   auto* func = f.get();

//   wasm.addFunction(std::move(f));
//   TestStringifyWalker walker;
//   walker.walkModule(&wasm);

//   std::vector<Visited> expected{Visited(FuncStart{func}),
//                                 Visited(tryy),
//                                 Visited(End{nullptr}),
//                                 Visited(TryStart{tryy}),
//                                 Visited(nop),
//                                 Visited(Delegate{})};
//   EXPECT_EQ(walker.visited, expected);
// }

TEST(StringifyWalkerTest, TryTable) {
  Module wasm;
  Builder builder(wasm);

  // (func $func
  //   (try_table
  //     (nop)
  //   )
  // )
  auto* nop = builder.makeNop();
  std::vector<Name> tags;
  std::vector<Name> labels;
  std::vector<bool> refs;
  auto* tryy = builder.makeTryTable(nop, tags, labels, refs);
  auto f = builder.makeFunction("func", Signature(), {}, tryy);
  auto* func = f.get();

  wasm.addFunction(std::move(f));
  TestStringifyWalker walker;
  walker.walkModule(&wasm);

  std::vector<Visited> expected{Visited(FuncStart{func}),
                                Visited(tryy),
                                Visited(End{nullptr}),
                                Visited(TryTableStart{tryy}),
                                Visited(nop),
                                Visited(End{nullptr})};
  EXPECT_EQ(walker.visited, expected);
}
