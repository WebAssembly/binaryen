#include <cassert>
#include <iostream>

#include "wasm-type.h"

using namespace wasm;

void test_compound() {
  {
    HeapType func(HeapType::FuncKind);
    assert(Type(func, true).getID() == Type::funcref);
    assert(Type(func, false).getID() == Type(func, false).getID());
    assert(Type(func, false).getID() != Type(func, true).getID());
    HeapType sameFunc(HeapType::FuncKind);
    assert(Type(func, false).getID() == Type(sameFunc, false).getID());

    HeapType extern_(HeapType::ExternKind);
    assert(Type(extern_, true).getID() == Type::externref);
    assert(Type(extern_, false).getID() == Type(extern_, false).getID());
    assert(Type(extern_, false).getID() != Type(extern_, true).getID());
    HeapType sameExtern(HeapType::ExternKind);
    assert(Type(extern_, false).getID() == Type(sameExtern, false).getID());

    HeapType exn(HeapType::ExnKind);
    assert(Type(exn, true).getID() == Type::exnref);
    assert(Type(exn, false).getID() == Type(exn, false).getID());
    assert(Type(exn, false).getID() != Type(exn, true).getID());
    HeapType sameExn(HeapType::ExnKind);
    assert(Type(exn, false).getID() == Type(sameExn, false).getID());

    HeapType any(HeapType::AnyKind);
    assert(Type(any, true).getID() == Type::anyref);
    assert(Type(any, false).getID() == Type(any, false).getID());
    assert(Type(any, false).getID() != Type(any, true).getID());
    HeapType sameAny(HeapType::AnyKind);
    assert(Type(any, false).getID() == Type(sameAny, false).getID());

    HeapType eq(HeapType::EqKind);
    // assert(Type(eq, true).getID() == Type::eqref);
    assert(Type(eq, false).getID() == Type(eq, false).getID());
    assert(Type(eq, false).getID() != Type(eq, true).getID());
    HeapType sameEq(HeapType::EqKind);
    assert(Type(eq, false).getID() == Type(sameEq, false).getID());

    HeapType i31(HeapType::I31Kind);
    // assert(Type(i31, false).getID() == Type::i31ref);
    assert(Type(i31, false).getID() == Type(i31, false).getID());
    assert(Type(i31, false).getID() != Type(i31, true).getID());
    HeapType sameI31(HeapType::I31Kind);
    assert(Type(i31, false).getID() == Type(sameI31, false).getID());
  }
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
  {
    Rtt rtt(0, HeapType::FuncKind);
    assert(Type(rtt).getID() == Type(rtt).getID());

    Rtt sameRtt(0, HeapType::FuncKind);
    assert(rtt == sameRtt);
    assert(Type(rtt).getID() == Type(sameRtt).getID());

    Rtt otherDepthRtt(1, HeapType::FuncKind);
    assert(rtt != otherDepthRtt);
    assert(Type(rtt).getID() != Type(otherDepthRtt).getID());

    Rtt otherHeapTypeRtt(0, HeapType::AnyKind);
    assert(rtt != otherHeapTypeRtt);
    assert(Type(rtt).getID() != Type(otherHeapTypeRtt).getID());

    Rtt structRtt(0, Struct({}));
    assert(Type(structRtt).getID() == Type(structRtt).getID());

    Rtt sameStructRtt(0, Struct({}));
    assert(structRtt == sameStructRtt);
    assert(Type(structRtt).getID() == Type(sameStructRtt).getID());

    Rtt otherStructRtt(0, Struct({{Type::i32, false}}));
    assert(structRtt != otherStructRtt);
    assert(Type(structRtt).getID() != Type(otherStructRtt).getID());
  }
}

void test_printing() {
  {
    std::cout << ";; Heap types\n";
    std::cout << HeapType(HeapType::FuncKind) << "\n";
    std::cout << Type(HeapType::FuncKind, true) << "\n";
    std::cout << Type(HeapType::FuncKind, false) << "\n";
    std::cout << HeapType(HeapType::ExternKind) << "\n";
    std::cout << Type(HeapType::ExternKind, true) << "\n";
    std::cout << Type(HeapType::ExternKind, false) << "\n";
    std::cout << HeapType(HeapType::AnyKind) << "\n";
    std::cout << Type(HeapType::AnyKind, true) << "\n";
    std::cout << Type(HeapType::AnyKind, false) << "\n";
    std::cout << HeapType(HeapType::EqKind) << "\n";
    std::cout << Type(HeapType::EqKind, true) << "\n";
    std::cout << Type(HeapType::EqKind, false) << "\n";
    std::cout << HeapType(HeapType::I31Kind) << "\n";
    std::cout << Type(HeapType::I31Kind, true) << "\n";
    std::cout << Type(HeapType::I31Kind, false) << "\n";
    std::cout << HeapType(HeapType::ExnKind) << "\n";
    std::cout << Type(HeapType::ExnKind, true) << "\n";
    std::cout << Type(HeapType::ExnKind, false) << "\n";
    std::cout << HeapType(Signature(Type::none, Type::none)) << "\n";
    std::cout << HeapType(Struct({})) << "\n";
    std::cout << HeapType(Array({Type::i32, false})) << "\n";
  }
  {
    std::cout << "\n;; Signature\n";
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
    std::cout << "\n;; Rtt\n";
    std::cout << Rtt(0, HeapType::FuncKind) << "\n";
    std::cout << Type(Rtt(0, HeapType::FuncKind)) << "\n";
    std::cout << Rtt(1, HeapType::ExternKind) << "\n";
    std::cout << Type(Rtt(1, HeapType::ExternKind)) << "\n";
    std::cout << Rtt(2, HeapType::AnyKind) << "\n";
    std::cout << Type(Rtt(2, HeapType::AnyKind)) << "\n";
    std::cout << Rtt(3, HeapType::EqKind) << "\n";
    std::cout << Type(Rtt(3, HeapType::EqKind)) << "\n";
    std::cout << Rtt(4, HeapType::I31Kind) << "\n";
    std::cout << Type(Rtt(4, HeapType::I31Kind)) << "\n";
    std::cout << Rtt(5, HeapType::ExnKind) << "\n";
    std::cout << Type(Rtt(5, HeapType::ExnKind)) << "\n";
    Rtt signatureRtt(6, Signature(Type::none, Type::none));
    std::cout << signatureRtt << "\n";
    std::cout << Type(signatureRtt) << "\n";
    Rtt structRtt(7, Struct({}));
    std::cout << structRtt << "\n";
    std::cout << Type(structRtt) << "\n";
    Rtt arrayRtt(8, Array({Type::i32, false}));
    std::cout << arrayRtt << "\n";
    std::cout << Type(arrayRtt) << "\n";
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
    std::cout << "\n;; Recursive (not really)\n";
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
