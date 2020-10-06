#include <cassert>
#include <iostream>

#include "ir/stack-utils.h"
#include "literal.h"
#include "mixed_arena.h"
#include "wasm-builder.h"
#include "wasm-printing.h"
#include "wasm-type.h"
#include "wasm.h"

using namespace wasm;

Module module;
Builder builder(module);

void test_remove_nops() {
  std::cout << ";; Test removeNops\n";
  auto* block = builder.makeBlock(
    {
      builder.makeNop(),
      builder.makeConst(Literal(int32_t(0))),
      builder.makeNop(),
      builder.makeConst(Literal(int64_t(0))),
      builder.makeNop(),
      builder.makeNop(),
    },
    {Type::i32, Type::i64});
  WasmPrinter::printExpression(block, std::cout);
  std::cout << "\n";
  StackUtils::removeNops(block);
  WasmPrinter::printExpression(block, std::cout);
  std::cout << "\n";
}

void test_stack_signatures() {
  std::cout << ";; Test stack signatures\n";
  // Typed block
  auto* block = builder.makeBlock({builder.makeUnreachable()}, Type::f32);
  assert(StackSignature(block) ==
         (StackSignature{Type::none, Type::f32, false}));
  // Unreachable block
  auto* unreachable =
    builder.makeBlock({builder.makeUnreachable()}, Type::unreachable);
  assert(StackSignature(unreachable) ==
         (StackSignature{Type::none, Type::none, true}));
  {
    // Typed loop
    auto* loop = builder.makeLoop("loop", unreachable, Type::f32);
    assert(StackSignature(loop) ==
           (StackSignature{Type::none, Type::f32, false}));
  }
  {
    // Unreachable loop
    auto* loop = builder.makeLoop("loop", unreachable, Type::unreachable);
    assert(StackSignature(loop) ==
           (StackSignature{Type::none, Type::none, true}));
  }
  {
    // If (no else)
    auto* if_ = builder.makeIf(
      builder.makePop(Type::i32), unreachable, nullptr, Type::none);
    assert(StackSignature(if_) ==
           (StackSignature{Type::i32, Type::none, false}));
  }
  {
    // If (with else)
    auto* if_ =
      builder.makeIf(builder.makePop(Type::i32), block, block, Type::f32);
    assert(StackSignature(if_) ==
           (StackSignature{Type::i32, Type::f32, false}));
  }
  {
    // Call
    auto* call =
      builder.makeCall("foo",
                       {builder.makePop(Type::i32), builder.makePop(Type::f32)},
                       {Type::i64, Type::f64});
    assert(
      StackSignature(call) ==
      (StackSignature{{Type::i32, Type::f32}, {Type::i64, Type::f64}, false}));
  }
  {
    // Return Call
    auto* call =
      builder.makeCall("bar",
                       {builder.makePop(Type::i32), builder.makePop(Type::f32)},
                       Type::unreachable,
                       true);
    assert(StackSignature(call) ==
           (StackSignature{{Type::i32, Type::f32}, Type::none, true}));
  }
  {
    // Return
    auto* ret = builder.makeReturn(builder.makePop(Type::i32));
    assert(StackSignature(ret) ==
           (StackSignature{Type::i32, Type::none, true}));
  }
  {
    // Multivalue return
    auto* ret = builder.makeReturn(builder.makePop({Type::i32, Type::f32}));
    assert(StackSignature(ret) ==
           (StackSignature{{Type::i32, Type::f32}, Type::none, true}));
  }
}

void test_signature_composition() {
  std::cout << ";; Test stack signature composition\n";
  // No unreachables
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, false}));
  }
  {
    StackSignature a{Type::none, Type::i32, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(a.composes(b));
    assert(a + b == StackSignature(Type::f32, Type::none, false));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{Type::i32, Type::none, false};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::f32, false}));
  }
  {
    StackSignature a{Type::none, Type::f32, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(!a.composes(b));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{Type::f32, Type::none, false};
    assert(!a.composes(b));
  }
  // First unreachable
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, true}));
  }
  {
    StackSignature a{Type::none, Type::i32, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(a.composes(b));
    assert(a + b == StackSignature(Type::none, Type::none, true));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{Type::i32, Type::none, false};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::f32, true}));
  }
  {
    StackSignature a{Type::none, Type::f32, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, false};
    assert(!a.composes(b));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{Type::f32, Type::none, false};
    assert(!a.composes(b));
  }
  // Second unreachable
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, true}));
  }
  {
    StackSignature a{Type::none, Type::i32, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(a.composes(b));
    assert(a + b == StackSignature(Type::f32, Type::none, true));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{Type::i32, Type::none, true};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, true}));
  }
  {
    StackSignature a{Type::none, Type::f32, false};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(!a.composes(b));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, false};
    StackSignature b{Type::f32, Type::none, true};
    assert(!a.composes(b));
  }
  // Both unreachable
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, true}));
  }
  {
    StackSignature a{Type::none, Type::i32, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(a.composes(b));
    assert(a + b == StackSignature(Type::none, Type::none, true));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{Type::i32, Type::none, true};
    assert(a.composes(b));
    assert(a + b == (StackSignature{Type::none, Type::none, true}));
  }
  {
    StackSignature a{Type::none, Type::f32, true};
    StackSignature b{{Type::f32, Type::i32}, Type::none, true};
    assert(!a.composes(b));
  }
  {
    StackSignature a{Type::none, {Type::f32, Type::i32}, true};
    StackSignature b{Type::f32, Type::none, true};
    assert(!a.composes(b));
  }
}

void test_signature_satisfaction() {
  std::cout << ";; Test stack signature satisfaction\n";
  // No unreachable
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b(Type::i32, Type::f32);
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b({Type::i64, Type::i32}, {Type::i64, Type::f32});
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b({Type::i64, Type::i32}, {Type::i64, Type::i64, Type::f32});
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b({Type::i64, Type::i32}, {Type::f64, Type::f32});
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b(Type::none, Type::f32);
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b(Type::i32, Type::none);
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, false};
    Signature b(Type::f32, Type::i32);
    assert(!a.satisfies(b));
  }
  // With unreachable
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b(Type::i32, Type::f32);
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b({Type::i64, Type::i32}, {Type::i64, Type::f32});
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b({Type::i64, Type::i32}, {Type::i64, Type::i64, Type::f32});
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b({Type::i64, Type::i32}, {Type::f64, Type::f32});
    assert(a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b(Type::none, Type::f32);
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b(Type::i32, Type::none);
    assert(!a.satisfies(b));
  }
  {
    StackSignature a{Type::i32, Type::f32, true};
    Signature b(Type::f32, Type::i32);
    assert(!a.satisfies(b));
  }
}

void test_stack_flow() {
  std::cout << ";; Test stack flow\n";
  {
    // Simple case:
    // foo
    //  │i32
    // bar
    //  │f32
    // end
    auto* foo = builder.makeCall("foo", {}, Type::i32);
    auto* bar =
      builder.makeCall("bar", {builder.makePop(Type::i32)}, Type::f32);
    auto* block = builder.makeBlock({foo, bar}, Type::f32);
    StackFlow flow(block);

    auto fooSrcs = flow.srcs.find(foo);
    assert(fooSrcs != flow.srcs.end());
    assert(fooSrcs->second.size() == 0);

    auto fooDests = flow.dests.find(foo);
    assert(fooDests != flow.dests.end());
    assert(fooDests->second.size() == 1);
    assert(fooDests->second[0] ==
           (StackFlow::Location{bar, 0, Type::i32, false}));

    auto barSrcs = flow.srcs.find(bar);
    assert(barSrcs != flow.dests.end());
    assert(barSrcs->second.size() == 1);
    assert(barSrcs->second[0] ==
           (StackFlow::Location{foo, 0, Type::i32, false}));

    auto barDests = flow.dests.find(bar);
    assert(barDests != flow.dests.end());
    assert(barDests->second.size() == 1);
    assert(barDests->second[0] ==
           (StackFlow::Location{block, 0, Type::f32, false}));

    auto blockSrcs = flow.srcs.find(block);
    assert(blockSrcs != flow.srcs.end());
    assert(blockSrcs->second.size() == 1);
    assert(blockSrcs->second[0] ==
           (StackFlow::Location{bar, 0, Type::f32, false}));
  }
  {
    // Interesting case:
    // foo
    //  ├─────┬─────┐
    //  │i32  │f32  │i64
    //  │     │    bar
    //  │     │     │f64
    //  │    baz╶───┘
    //  │     ├─────┐
    //  ╵     ╵i64  │f32
    // ret╶─────────┘
    //  ╷     ╷     ╷
    //  │i64  │f64  │i32
    //  │    quux╶──┘
    // end
    auto* foo = builder.makeCall("foo", {}, {Type::i32, Type::f32, Type::i64});
    auto* bar =
      builder.makeCall("bar", {builder.makePop(Type::i64)}, Type::f64);
    auto* baz =
      builder.makeCall("baz",
                       {builder.makePop(Type::f32), builder.makePop(Type::f64)},
                       {Type::i64, Type::f32});
    auto* ret = builder.makeReturn(builder.makePop(Type::f32));
    auto* quux =
      builder.makeCall("quux",
                       {builder.makePop(Type::f64), builder.makePop(Type::i32)},
                       Type::none);
    auto* block = builder.makeBlock({foo, bar, baz, ret, quux}, Type::i64);
    StackFlow flow(block);

    assert(flow.srcs.find(foo)->second.size() == 0);

    const auto& fooDests = flow.dests[foo];
    assert(fooDests.size() == 3);
    assert(fooDests[0] == (StackFlow::Location{ret, 0, Type::i32, true}));
    assert(fooDests[1] == (StackFlow::Location{baz, 0, Type::f32, false}));
    assert(fooDests[2] == (StackFlow::Location{bar, 0, Type::i64, false}));

    const auto& barSrcs = flow.srcs[bar];
    assert(barSrcs.size() == 1);
    assert(barSrcs[0] == (StackFlow::Location{foo, 2, Type::i64, false}));

    const auto& barDests = flow.dests[bar];
    assert(barDests.size() == 1);
    assert(barDests[0] == (StackFlow::Location{baz, 1, Type::f64, false}));

    const auto& bazSrcs = flow.srcs[baz];
    assert(bazSrcs.size() == 2);
    assert(bazSrcs[0] == (StackFlow::Location{foo, 1, Type::f32, false}));
    assert(bazSrcs[1] == (StackFlow::Location{bar, 0, Type::f64, false}));

    const auto& bazDests = flow.dests[baz];
    assert(bazDests.size() == 2);
    assert(bazDests[0] == (StackFlow::Location{ret, 1, Type::i64, true}));
    assert(bazDests[1] == (StackFlow::Location{ret, 2, Type::f32, false}));

    const auto& retSrcs = flow.srcs[ret];
    assert(retSrcs.size() == 3);
    assert(retSrcs[0] == (StackFlow::Location{foo, 0, Type::i32, false}));
    assert(retSrcs[1] == (StackFlow::Location{baz, 0, Type::i64, false}));
    assert(retSrcs[2] == (StackFlow::Location{baz, 1, Type::f32, false}));

    const auto& retDests = flow.dests[ret];
    assert(retDests.size() == 3);
    assert(retDests[0] == (StackFlow::Location{block, 0, Type::i64, false}));
    assert(retDests[1] == (StackFlow::Location{quux, 0, Type::f64, false}));
    assert(retDests[2] == (StackFlow::Location{quux, 1, Type::i32, false}));

    const auto& quuxSrcs = flow.srcs[quux];
    assert(quuxSrcs.size() == 2);
    assert(quuxSrcs[0] == (StackFlow::Location{ret, 1, Type::f64, true}));
    assert(quuxSrcs[1] == (StackFlow::Location{ret, 2, Type::i32, true}));

    const auto& quuxDests = flow.dests[quux];
    assert(quuxDests.size() == 0);

    const auto& blockSrcs = flow.srcs[block];
    assert(blockSrcs.size() == 1);
    assert(blockSrcs[0] == (StackFlow::Location{ret, 0, Type::i64, true}));

    assert(flow.getSignature(foo) == StackSignature(foo));
    assert(flow.getSignature(bar) == StackSignature(bar));
    assert(flow.getSignature(baz) == StackSignature(baz));
    assert(flow.getSignature(ret) ==
           (StackSignature{{Type::i32, Type::i64, Type::f32},
                           {Type::i64, Type::f64, Type::i32},
                           true}));
    assert(flow.getSignature(quux) == StackSignature(quux));
  }
}

int main() {
  test_remove_nops();
  test_stack_signatures();
  test_signature_composition();
  test_signature_satisfaction();
  test_stack_flow();
}
