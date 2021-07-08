#include <iostream>

#include <ir/local-graph.h>
#include <wasm-builder.h>
#include <wasm.h>

using namespace wasm;

int main() {
  Module wasm;
  Builder builder(wasm);

  {
    Function foo;
    foo.type = Signature(Type::none, Type::none);
    foo.vars = {Type::i32};
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(0, Type::i32);
    foo.body = builder.makeBlock({
      builder.makeLocalSet(0, builder.makeConst(Literal(int32_t(0)))),
      // two equivalent gets, as both are preceded by the same single set
      builder.makeDrop(get1),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature(Type::none, Type::none);
    foo.vars = {Type::i32};
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(0, Type::i32);
    foo.body = builder.makeBlock({
      // two non-equivalent gets, as there is a set in between them
      builder.makeDrop(get1),
      builder.makeLocalSet(0, builder.makeConst(Literal(int32_t(0)))),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(!graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature({Type::i32}, Type::none);
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(0, Type::i32);
    foo.body = builder.makeBlock({
      // two equivalent gets of the same parameter
      builder.makeDrop(get1),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature({Type::i32}, Type::none);
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(0, Type::i32);
    foo.body = builder.makeBlock({
      // two non-equivalent gets of the same parameter, as there is a set
      builder.makeDrop(get1),
      builder.makeLocalSet(0, builder.makeConst(Literal(int32_t(0)))),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(!graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature({Type::i32, Type::i32}, Type::none);
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(1, Type::i32);
    foo.body = builder.makeBlock({
      // two non-equivalent gets as they are of different parameters
      builder.makeDrop(get1),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(!graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature(Type::none, Type::none);
    foo.vars = {Type::i32, Type::i32};
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(1, Type::i32);
    foo.body = builder.makeBlock({
      // two equivalent gets, even though they have a different index, as both
      // use the zero initialized value
      builder.makeDrop(get1),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(graph.equivalent(get1, get2));
  }

  {
    Function foo;
    foo.type = Signature(Type::none, Type::none);
    foo.vars = {Type::i32, Type::f64};
    auto* get1 = builder.makeLocalGet(0, Type::i32);
    auto* get2 = builder.makeLocalGet(1, Type::f64);
    foo.body = builder.makeBlock({
      // two non-equivalent gets as their zero-init value is different
      builder.makeDrop(get1),
      builder.makeDrop(get2),
    });
    LocalGraph graph(&foo);
    assert(!graph.equivalent(get1, get2));
  }

  std::cout << "Success." << std::endl;

  return 0;
}
