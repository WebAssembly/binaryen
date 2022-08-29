#include <cassert>
#include <iostream>

#include "wasm-type.h"

using namespace wasm;

void test_compound() {
  {
    HeapType func(HeapType::func);
    assert(Type(func, NonNullable).getID() == Type(func, NonNullable).getID());
    assert(Type(func, NonNullable).getID() != Type(func, Nullable).getID());
    HeapType sameFunc(HeapType::func);
    assert(Type(func, NonNullable).getID() ==
           Type(sameFunc, NonNullable).getID());

    HeapType any(HeapType::any);
    assert(Type(any, NonNullable).getID() == Type(any, NonNullable).getID());
    assert(Type(any, NonNullable).getID() != Type(any, Nullable).getID());
    HeapType sameAny(HeapType::any);
    assert(Type(any, NonNullable).getID() ==
           Type(sameAny, NonNullable).getID());

    HeapType eq(HeapType::eq);
    assert(Type(eq, NonNullable).getID() == Type(eq, NonNullable).getID());
    assert(Type(eq, NonNullable).getID() != Type(eq, Nullable).getID());
    HeapType sameEq(HeapType::eq);
    assert(Type(eq, NonNullable).getID() == Type(sameEq, NonNullable).getID());

    HeapType i31(HeapType::i31);
    assert(Type(i31, NonNullable).getID() == Type(i31, NonNullable).getID());
    assert(Type(i31, NonNullable).getID() != Type(i31, Nullable).getID());
    HeapType sameI31(HeapType::i31);
    assert(Type(i31, NonNullable).getID() ==
           Type(sameI31, NonNullable).getID());
  }
  {
    Signature signature(Type::i32, Type::none);
    assert(Type(signature, NonNullable).getID() ==
           Type(signature, NonNullable).getID());
    assert(Type(signature, NonNullable).getID() !=
           Type(signature, Nullable).getID());

    Signature sameSignature(Type::i32, Type::none);
    assert(Type(signature, NonNullable).getID() ==
           Type(sameSignature, NonNullable).getID());

    Signature otherSignature(Type::f64, Type::none);
    assert(Type(signature, NonNullable).getID() !=
           Type(otherSignature, NonNullable).getID());
  }
  {
    Struct struct_{};
    assert(Type(struct_, NonNullable).getID() ==
           Type(struct_, NonNullable).getID());
    assert(Type(struct_, NonNullable).getID() !=
           Type(struct_, Nullable).getID());

    Struct sameStruct{};
    assert(Type(struct_, NonNullable).getID() ==
           Type(sameStruct, NonNullable).getID());

    Struct otherStruct({{Type::i32, Immutable}});
    assert(Type(struct_, NonNullable).getID() !=
           Type(otherStruct, NonNullable).getID());
  }
  {
    Array array({Type::i32, Immutable});
    assert(Type(array, NonNullable).getID() ==
           Type(array, NonNullable).getID());
    assert(Type(array, NonNullable).getID() != Type(array, Nullable).getID());

    Array sameArray({Type::i32, Immutable});
    assert(Type(array, NonNullable).getID() ==
           Type(sameArray, NonNullable).getID());

    Array otherArray({Type::f64, Mutable});
    assert(Type(array, NonNullable).getID() !=
           Type(otherArray, NonNullable).getID());
  }
  {
    Tuple singleTuple({Type::i32});
    assert(Type(singleTuple).getID() == Type::i32);

    Tuple tuple({Type::i32, Type::f64});
    assert(Type(tuple).getID() == Type(tuple).getID());

    Tuple sameTuple({Type::i32, Type::f64});
    assert(Type(tuple).getID() == Type(sameTuple).getID());

    Tuple otherTuple({Type::f64, Type::i64});
    assert(Type(tuple).getID() != Type(otherTuple).getID());
  }
}

void test_printing() {
  {
    std::cout << ";; Heap types\n";
    std::cout << HeapType(HeapType::func) << "\n";
    std::cout << Type(HeapType::func, Nullable) << "\n";
    std::cout << Type(HeapType::func, NonNullable) << "\n";
    std::cout << HeapType(HeapType::any) << "\n";
    std::cout << Type(HeapType::any, Nullable) << "\n";
    std::cout << Type(HeapType::any, NonNullable) << "\n";
    std::cout << HeapType(HeapType::eq) << "\n";
    std::cout << Type(HeapType::eq, Nullable) << "\n";
    std::cout << Type(HeapType::eq, NonNullable) << "\n";
    std::cout << HeapType(HeapType::i31) << "\n";
    std::cout << Type(HeapType::i31, Nullable) << "\n";
    std::cout << Type(HeapType::i31, NonNullable) << "\n";
    std::cout << Signature(Type::none, Type::none) << "\n";
    std::cout << HeapType(Struct{}) << "\n";
    std::cout << HeapType(Array({Type::i32, Immutable})) << "\n";
  }
  {
    std::cout << "\n;; Signature\n";
    Signature emptySignature(Type::none, Type::none);
    std::cout << emptySignature << "\n";
    std::cout << Type(emptySignature, NonNullable) << "\n";
    std::cout << Type(emptySignature, Nullable) << "\n";
    Signature signature(Type::i32, Type::f64);
    std::cout << signature << "\n";
    std::cout << Type(signature, NonNullable) << "\n";
    std::cout << Type(signature, Nullable) << "\n";
  }
  {
    std::cout << "\n;; Struct\n";
    Struct emptyStruct{};
    std::cout << emptyStruct << "\n";
    std::cout << Type(emptyStruct, NonNullable) << "\n";
    std::cout << Type(emptyStruct, Nullable) << "\n";
    Struct struct_({
      {Type::i32, Immutable},
      {Type::i64, Immutable},
      {Type::f32, Mutable},
      {Type::f64, Mutable},
    });
    std::cout << struct_ << "\n";
    std::cout << Type(struct_, NonNullable) << "\n";
    std::cout << Type(struct_, Nullable) << "\n";
  }
  {
    std::cout << "\n;; Array\n";
    Array array({Type::i32, Immutable});
    std::cout << array << "\n";
    std::cout << Type(array, NonNullable) << "\n";
    std::cout << Type(array, Nullable) << "\n";
    Array arrayMut({Type::i64, Mutable});
    std::cout << arrayMut << "\n";
    std::cout << Type(arrayMut, NonNullable) << "\n";
    std::cout << Type(arrayMut, Nullable) << "\n";
  }
  {
    std::cout << "\n;; Tuple\n";
    Tuple emptyTuple{};
    std::cout << emptyTuple << "\n";
    std::cout << Type(emptyTuple) << "\n";
    Tuple tuple({
      Type::i32,
      Type::f64,
    });
    std::cout << tuple << "\n";
    std::cout << Type(tuple) << "\n";
  }
  {
    std::cout << "\n;; Signature of references (param/result)\n";
    Signature signature(Type(Struct{}, Nullable),
                        Type(Array({Type::i32, Mutable}), NonNullable));
    std::cout << signature << "\n";
  }
  {
    std::cout << "\n;; Signature of references (params/results)\n";
    Signature signature(Type({
                          Type(Struct{}, Nullable),
                          Type(Array({Type::i32, Mutable}), NonNullable),
                        }),
                        Type({
                          Type(Struct{}, NonNullable),
                          Type(Array({Type::i32, Immutable}), Nullable),
                        }));
    std::cout << signature << "\n";
  }
  {
    std::cout << "\n;; Struct of references\n";
    Struct structOfSignature({
      {Type(Signature(Type::none, Type::none), NonNullable), Immutable},
      {Type(Signature(Type::none, Type::none), NonNullable), Mutable},
      {Type(Signature(Type::none, Type::none), Nullable), Immutable},
      {Type(Signature(Type::none, Type::none), Nullable), Mutable},
    });
    std::cout << structOfSignature << "\n";
    std::cout << Type(structOfSignature, NonNullable) << "\n";
    std::cout << Type(structOfSignature, Nullable) << "\n";
    Struct structOfStruct({
      {Type(Struct{}, NonNullable), Immutable},
      {Type(Struct{}, NonNullable), Mutable},
      {Type(Struct{}, Nullable), Immutable},
      {Type(Struct{}, Nullable), Mutable},
    });
    std::cout << structOfStruct << "\n";
    std::cout << Type(structOfStruct, NonNullable) << "\n";
    std::cout << Type(structOfStruct, Nullable) << "\n";
    Struct structOfArray({
      {Type(Array({Type::i32, Immutable}), NonNullable), Immutable},
      {Type(Array({Type::i32, Immutable}), NonNullable), Mutable},
      {Type(Array({Type::i32, Immutable}), Nullable), Immutable},
      {Type(Array({Type::i32, Immutable}), Nullable), Mutable},
    });
    std::cout << structOfArray << "\n";
    std::cout << Type(structOfArray, NonNullable) << "\n";
    std::cout << Type(structOfArray, Nullable) << "\n";
    Struct structOfEverything({
      {Type::i32, Mutable},
      {Type(Signature(Type::none, Type::none), Nullable), Mutable},
      {Type(Struct{}, Nullable), Mutable},
      {Type(Array({Type::i32, Mutable}), Nullable), Mutable},
    });
    std::cout << structOfEverything << "\n";
    std::cout << Type(structOfEverything, NonNullable) << "\n";
    std::cout << Type(structOfEverything, Nullable) << "\n";
  }
  {
    std::cout << "\n;; Array of references\n";
    Array arrayOfSignature(
      {Type(Signature(Type::none, Type::none), Nullable), Immutable});
    std::cout << arrayOfSignature << "\n";
    std::cout << Type(arrayOfSignature, NonNullable) << "\n";
    std::cout << Type(arrayOfSignature, Nullable) << "\n";
    Array arrayOfStruct({Type(Struct{}, Nullable), Mutable});
    std::cout << arrayOfStruct << "\n";
    std::cout << Type(arrayOfStruct, NonNullable) << "\n";
    std::cout << Type(arrayOfStruct, Nullable) << "\n";
    Array arrayOfArray(
      {Type(Array({Type::i32, Immutable}), Nullable), Immutable});
    std::cout << arrayOfArray << "\n";
    std::cout << Type(arrayOfArray, NonNullable) << "\n";
    std::cout << Type(arrayOfArray, Nullable) << "\n";
  }
  {
    std::cout << "\n;; Tuple of references\n";
    Tuple tuple({
      Type(Signature(Type::none, Type::none), NonNullable),
      Type(Signature(Type::none, Type::none), Nullable),
      Type(Struct{}, NonNullable),
      Type(Struct{}, Nullable),
      Type(Array({Type::i32, Immutable}), NonNullable),
      Type(Array({Type::i32, Immutable}), Nullable),
    });
    std::cout << tuple << "\n";
    std::cout << Type(tuple) << "\n";
  }
  {
    std::cout << "\n;; Recursive (not really)\n";
    Signature signatureSignature(Type::none, Type::none);
    signatureSignature.params = Type(signatureSignature, NonNullable);
    //                                ^ copies
    std::cout << signatureSignature << "\n";
    std::cout << Type(signatureSignature, NonNullable) << "\n";
    Signature signatureArraySignature(Type::none, Type::none);
    signatureArraySignature.params =
      Type(Array({Type(signatureArraySignature, NonNullable), Immutable}),
           NonNullable);
    //                 ^ copies
    std::cout << signatureArraySignature << "\n";
    std::cout << Type(signatureArraySignature, NonNullable) << "\n";
  }
}

int main() {
  test_compound();
  test_printing();
}
