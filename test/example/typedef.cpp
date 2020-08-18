#include <cassert>
#include <iostream>

#include "wasm-type.h"

using namespace wasm;

void test_compound() {
  {
    Signature signature(Type::i32, Type::none);
    assert(Type(signature, false).getID() == Type(signature, false).getID());
    assert(Type(signature, false).getID() != Type(signature, true).getID());

    Signature sameSignature(Type::i32, Type::none);
    assert(Type(signature, false).getID() ==
           Type(sameSignature, false).getID());

    Signature otherSignature(Type::f64, Type::none);
    assert(Type(signature, false).getID() !=
           Type(otherSignature, false).getID());
  }
  {
    Struct struct_({});
    assert(Type(struct_, false).getID() == Type(struct_, false).getID());
    assert(Type(struct_, false).getID() != Type(struct_, true).getID());

    Struct sameStruct({});
    assert(Type(struct_, false).getID() == Type(sameStruct, false).getID());

    Struct otherStruct({{Type::i32, false}});
    assert(Type(struct_, false).getID() != Type(otherStruct, false).getID());
  }
  {
    Array array({Type::i32, false});
    assert(Type(array, false).getID() == Type(array, false).getID());
    assert(Type(array, false).getID() != Type(array, true).getID());

    Array sameArray({Type::i32, false});
    assert(Type(array, false).getID() == Type(sameArray, false).getID());

    Array otherArray({Type::f64, true});
    assert(Type(array, false).getID() != Type(otherArray, false).getID());
  }
  {
    Tuple singleTuple({Type::i32});
    assert(Type(singleTuple).getID() == Type::i32);

    Tuple tuple({Type::i32, Type::f64});
    assert(Type(tuple).getID() == Type(tuple).getID());

    Tuple sameTuple({Type::i32, Type::f64});
    assert(Type(tuple).getID() == Type(sameTuple).getID());

    Tuple otherTuple({Type::f64, Type::externref});
    assert(Type(tuple).getID() != Type(otherTuple).getID());
  }
}

void test_printing() {
  {
    std::cout << "# Signature\n";
    Signature signature(Type::i32, Type::none);
    std::cout << signature << "\n";
    std::cout << Type(signature, false) << "\n";
    std::cout << Type(signature, true) << "\n";
  }
  {
    std::cout << "# Struct\n";
    Struct struct_({
      {Type::i32, false},
      {Type::i64, false},
      {Type::f32, true},
      {Type::f64, true},
      {Type::externref, false},
    });
    std::cout << struct_ << "\n";
    std::cout << Type(struct_, false) << "\n";
    std::cout << Type(struct_, true) << "\n";
  }
  {
    std::cout << "# Array\n";
    Array array({Type::i32, false});
    std::cout << array << "\n";
    std::cout << Type(array, false) << "\n";
    std::cout << Type(array, true) << "\n";
    Array arrayMut({Type::externref, true});
    std::cout << arrayMut << "\n";
    std::cout << Type(arrayMut, false) << "\n";
    std::cout << Type(arrayMut, true) << "\n";
  }
  {
    std::cout << "# Tuple\n";
    Tuple tuple({
      Type::i32,
      Type::f64,
      Type::externref,
    });
    std::cout << tuple << "\n";
    std::cout << Type(tuple) << "\n";
  }
  // FIXME: Can't expand a single compound `params` type, see
  // https://github.com/WebAssembly/binaryen/pull/3012#discussion_r471842763
  // {
  //   Signature signature(Type(Array({Type::i32, false}), false), Type::none);
  //   std::cout << signature << "\n";
  // }
}

int main() {
  test_compound();
  test_printing();
}
