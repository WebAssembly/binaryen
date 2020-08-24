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
    std::cout << ";; Signature\n";
    Signature emptySignature(Type::none, Type::none);
    std::cout << emptySignature << "\n";
    std::cout << Type(emptySignature, false) << "\n";
    std::cout << Type(emptySignature, true) << "\n";
    Signature signature(Type::i32, Type::f64);
    std::cout << signature << "\n";
    std::cout << Type(signature, false) << "\n";
    std::cout << Type(signature, true) << "\n";
  }
  {
    std::cout << "\n;; Struct\n";
    Struct emptyStruct({});
    std::cout << emptyStruct << "\n";
    std::cout << Type(emptyStruct, false) << "\n";
    std::cout << Type(emptyStruct, true) << "\n";
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
    std::cout << "\n;; Array\n";
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
    std::cout << "\n;; Tuple\n";
    Tuple emptyTuple({});
    std::cout << emptyTuple << "\n";
    std::cout << Type(emptyTuple) << "\n";
    Tuple tuple({
      Type::i32,
      Type::f64,
      Type::externref,
    });
    std::cout << tuple << "\n";
    std::cout << Type(tuple) << "\n";
  }
  {
    std::cout << "\n;; Signature of references (param/result)\n";
    Signature signature(Type(Struct({}), true),
                        Type(Array({Type::i32, true}), false));
    std::cout << signature << "\n";
  }
  {
    std::cout << "\n;; Signature of references (params/results)\n";
    Signature signature(Type({
                          Type(Struct({}), true),
                          Type(Array({Type::i32, true}), false),
                        }),
                        Type({
                          Type(Struct({}), false),
                          Type(Array({Type::i32, false}), true),
                        }));
    std::cout << signature << "\n";
  }
  {
    std::cout << "\n;; Struct of references\n";
    Struct structOfSignature({
      {Type(Signature(Type::none, Type::none), false), false},
      {Type(Signature(Type::none, Type::none), false), true},
      {Type(Signature(Type::none, Type::none), true), false},
      {Type(Signature(Type::none, Type::none), true), true},
    });
    std::cout << structOfSignature << "\n";
    std::cout << Type(structOfSignature, false) << "\n";
    std::cout << Type(structOfSignature, true) << "\n";
    Struct structOfStruct({
      {Type(Struct({}), false), false},
      {Type(Struct({}), false), true},
      {Type(Struct({}), true), false},
      {Type(Struct({}), true), true},
    });
    std::cout << structOfStruct << "\n";
    std::cout << Type(structOfStruct, false) << "\n";
    std::cout << Type(structOfStruct, true) << "\n";
    Struct structOfArray({
      {Type(Array({Type::i32, false}), false), false},
      {Type(Array({Type::i32, false}), false), true},
      {Type(Array({Type::i32, false}), true), false},
      {Type(Array({Type::i32, false}), true), true},
    });
    std::cout << structOfArray << "\n";
    std::cout << Type(structOfArray, false) << "\n";
    std::cout << Type(structOfArray, true) << "\n";
    Struct structOfEverything({
      {Type::i32, true},
      {Type(Signature(Type::none, Type::none), true), true},
      {Type(Struct({}), true), true},
      {Type(Array({Type::i32, true}), true), true},
    });
    std::cout << structOfEverything << "\n";
    std::cout << Type(structOfEverything, false) << "\n";
    std::cout << Type(structOfEverything, true) << "\n";
  }
  {
    std::cout << "\n;; Array of references\n";
    Array arrayOfSignature(
      {Type(Signature(Type::none, Type::none), true), false});
    std::cout << arrayOfSignature << "\n";
    std::cout << Type(arrayOfSignature, false) << "\n";
    std::cout << Type(arrayOfSignature, true) << "\n";
    Array arrayOfStruct({Type(Struct({}), true), true});
    std::cout << arrayOfStruct << "\n";
    std::cout << Type(arrayOfStruct, false) << "\n";
    std::cout << Type(arrayOfStruct, true) << "\n";
    Array arrayOfArray({Type(Array({Type::i32, false}), true), false});
    std::cout << arrayOfArray << "\n";
    std::cout << Type(arrayOfArray, false) << "\n";
    std::cout << Type(arrayOfArray, true) << "\n";
  }
  {
    std::cout << "\n;; Tuple of references\n";
    Tuple tuple({
      Type(Signature(Type::none, Type::none), false),
      Type(Signature(Type::none, Type::none), true),
      Type(Struct({}), false),
      Type(Struct({}), true),
      Type(Array({Type::i32, false}), false),
      Type(Array({Type::i32, false}), true),
    });
    std::cout << tuple << "\n";
    std::cout << Type(tuple) << "\n";
  }
  // TODO: Think about recursive types. Currently impossible to construct.
  {
    std::cout << "\n;; Recursive\n";
    Signature signatureSignature(Type::none, Type::none);
    signatureSignature.params = Type(signatureSignature, false);
    //                                ^ copies
    std::cout << signatureSignature << "\n";
    std::cout << Type(signatureSignature, false) << "\n";
    Signature signatureArraySignature(Type::none, Type::none);
    signatureArraySignature.params =
      Type(Array({Type(signatureArraySignature, false), false}), false);
    //                 ^ copies
    std::cout << signatureArraySignature << "\n";
    std::cout << Type(signatureArraySignature, false) << "\n";
  }
}

int main() {
  test_compound();
  test_printing();
}
