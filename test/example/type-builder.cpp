#include <cassert>
#include <iostream>

#include "wasm-type-printing.h"
#include "wasm-type.h"

using namespace wasm;

// Check that the builder works when there are duplicate definitions
void test_canonicalization() {
  std::cout << ";; Test canonicalization\n";

  // (type $struct (struct (field (ref null $sig) (ref null $sig))))
  // (type $sig (func))
  HeapType sig = Signature(Type::none, Type::none);
  HeapType struct_ = Struct({Field(Type(sig, Nullable), Immutable),
                             Field(Type(sig, Nullable), Immutable)});

  TypeBuilder builder(4);

  Type tempSigRef1 = builder.getTempRefType(builder[2], Nullable);
  Type tempSigRef2 = builder.getTempRefType(builder[3], Nullable);

  assert(tempSigRef1 != tempSigRef2);
  assert(tempSigRef1 != Type(sig, Nullable));
  assert(tempSigRef2 != Type(sig, Nullable));

  builder[0] =
    Struct({Field(tempSigRef1, Immutable), Field(tempSigRef1, Immutable)});
  builder[1] =
    Struct({Field(tempSigRef2, Immutable), Field(tempSigRef2, Immutable)});
  builder[2] = Signature(Type::none, Type::none);
  builder[3] = Signature(Type::none, Type::none);

  std::vector<HeapType> built = *builder.build();

  assert(built[0] == struct_);
  assert(built[1] == struct_);
  assert(built[2] == sig);
  assert(built[3] == sig);
}

// Check that defined basic HeapTypes are handled correctly.
void test_basic() {
  std::cout << ";; Test basic\n";

  TypeBuilder builder(6);

  Type anyref = builder.getTempRefType(builder[4], Nullable);
  Type i31ref = builder.getTempRefType(builder[5], NonNullable);

  builder[0] = Signature(Type::anyref, Type::i31ref);
  builder[1] = Signature(anyref, Type::i31ref);
  builder[2] = Signature(Type::anyref, i31ref);
  builder[3] = Signature(anyref, i31ref);
  builder[4] = HeapType::any;
  builder[5] = HeapType::i31;

  std::vector<HeapType> built = *builder.build();

  assert(built[0] == Signature(Type::anyref, Type::i31ref));
  assert(built[1] == built[0]);
  assert(built[2] == built[1]);
  assert(built[3] == built[2]);
  assert(built[4] == HeapType::any);
  assert(built[5] == HeapType::i31);
}

void test_recursive() {
  std::cout << ";; Test recursive types\n";

  {
    // Trivial recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(1);
      Type temp = builder.getTempRefType(builder[0], Nullable);
      builder[0] = Signature(Type::none, temp);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n\n";
    assert(built[0] == built[0].getSignature().results.getHeapType());
    assert(Type(built[0], Nullable) == built[0].getSignature().results);
  }

  {
    // Mutual recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(2);
      Type temp0 = builder.getTempRefType(builder[0], Nullable);
      Type temp1 = builder.getTempRefType(builder[1], Nullable);
      builder[0] = Signature(Type::none, temp1);
      builder[1] = Signature(Type::none, temp0);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[1]);
    assert(built[1].getSignature().results.getHeapType() == built[0]);
    assert(built[0] == built[1]);
  }

  {
    // A longer chain of recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(5);
      Type temp0 = builder.getTempRefType(builder[0], Nullable);
      Type temp1 = builder.getTempRefType(builder[1], Nullable);
      Type temp2 = builder.getTempRefType(builder[2], Nullable);
      Type temp3 = builder.getTempRefType(builder[3], Nullable);
      Type temp4 = builder.getTempRefType(builder[4], Nullable);
      builder[0] = Signature(Type::none, temp1);
      builder[1] = Signature(Type::none, temp2);
      builder[2] = Signature(Type::none, temp3);
      builder[3] = Signature(Type::none, temp4);
      builder[4] = Signature(Type::none, temp0);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n";
    std::cout << print(built[2]) << "\n";
    std::cout << print(built[3]) << "\n";
    std::cout << print(built[4]) << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[1]);
    assert(built[1].getSignature().results.getHeapType() == built[2]);
    assert(built[2].getSignature().results.getHeapType() == built[3]);
    assert(built[3].getSignature().results.getHeapType() == built[4]);
    assert(built[4].getSignature().results.getHeapType() == built[0]);
    assert(built[0] == built[1]);
    assert(built[1] == built[2]);
    assert(built[2] == built[3]);
    assert(built[3] == built[4]);
  }

  {
    // Check canonicalization for non-recursive parents and children of
    // recursive HeapTypes.
    std::vector<HeapType> built;
    {
      TypeBuilder builder(6);
      Type temp0 = builder.getTempRefType(builder[0], Nullable);
      Type temp1 = builder.getTempRefType(builder[1], Nullable);
      Type temp2 = builder.getTempRefType(builder[2], Nullable);
      Type temp3 = builder.getTempRefType(builder[3], Nullable);
      Type tuple0_2 = builder.getTempTupleType({temp0, temp2});
      Type tuple1_3 = builder.getTempTupleType({temp1, temp3});
      builder[0] = Signature(Type::none, tuple0_2);
      builder[1] = Signature(Type::none, tuple1_3);
      builder[2] = Signature();
      builder[3] = Signature();
      builder[4] = Signature(Type::none, temp0);
      builder[5] = Signature(Type::none, temp1);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n";
    std::cout << print(built[2]) << "\n";
    std::cout << print(built[3]) << "\n";
    std::cout << print(built[4]) << "\n";
    std::cout << print(built[5]) << "\n\n";
    assert(built[0] == built[1]);
    assert(built[2] == built[3]);
    assert(built[4] == built[5]);
    assert(built[4].getSignature().results.getHeapType() == built[0]);
    assert(built[5].getSignature().results.getHeapType() == built[1]);
    assert(built[0].getSignature().results ==
           Type({Type(built[0], Nullable), Type(built[2], Nullable)}));
    assert(built[1].getSignature().results ==
           Type({Type(built[1], Nullable), Type(built[3], Nullable)}));
  }

  {
    // Folded and unfolded
    std::vector<HeapType> built;
    {
      TypeBuilder builder(2);
      Type temp0 = builder.getTempRefType(builder[0], Nullable);
      builder[0] = Signature(Type::none, temp0);
      builder[1] = Signature(Type::none, temp0);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[0]);
    assert(built[1].getSignature().results.getHeapType() == built[0]);
    assert(built[0] == built[1]);
  }

  {
    // Including a basic heap type
    std::vector<HeapType> built;
    {
      TypeBuilder builder(3);
      Type temp0 = builder.getTempRefType(builder[0], Nullable);
      Type anyref = builder.getTempRefType(builder[2], Nullable);
      builder[0] = Signature(anyref, temp0);
      builder[1] = Signature(anyref, temp0);
      builder[2] = HeapType::any;
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[0]);
    assert(built[1].getSignature().results.getHeapType() == built[0]);
    assert(built[0].getSignature().params == Type::anyref);
    assert(built[1].getSignature().params == Type::anyref);
    assert(built[0] == built[1]);
    assert(built[2] == HeapType::any);
  }
}

void test_lub() {
  std::cout << ";; Test LUBs\n";

  auto LUB = [&](Type a, Type b) {
    Type lubAB = Type::getLeastUpperBound(a, b);
    Type lubBA = Type::getLeastUpperBound(b, a);
    assert(lubAB == lubBA);
    if (lubAB == Type::none) {
      assert(!Type::hasLeastUpperBound(a, b));
      assert(!Type::hasLeastUpperBound(b, a));
    } else {
      assert(Type::hasLeastUpperBound(a, b));
      assert(Type::hasLeastUpperBound(b, a));
      assert(Type::isSubType(a, lubAB));
      assert(Type::isSubType(b, lubAB));
    }
    return lubAB;
  };

  {
    // Basic Types
    for (auto other : {Type::funcref,
                       Type::externref,
                       Type::anyref,
                       Type::eqref,
                       Type::i31ref,
                       Type::dataref}) {
      assert(LUB(Type::anyref, other) == Type::anyref);
    }
    assert(LUB(Type::eqref, Type::funcref) == Type::anyref);
    assert(LUB(Type::i31ref, Type::dataref) == Type(HeapType::eq, NonNullable));
  }

  {
    // Nullable and non-nullable references
    Type nullable(HeapType::any, Nullable);
    Type nonNullable(HeapType::any, NonNullable);
    assert(LUB(nullable, nullable) == nullable);
    assert(LUB(nullable, nonNullable) == nullable);
    assert(LUB(nonNullable, nonNullable) == nonNullable);
  }

  {
    // Funcref with specific signature
    assert(LUB(Type::funcref, Type(Signature(), Nullable)) == Type::funcref);
  }

  {
    // Incompatible signatures
    Type a(Signature(Type::none, Type::anyref), Nullable);
    Type b(Signature(Type::anyref, Type::none), Nullable);
    assert(LUB(a, b) == Type::funcref);
  }

  {
    // Signatures incompatible in tuple size
    Type a(Signature(Type::none, {Type::anyref, Type::anyref}), Nullable);
    Type b(Signature(Type::none, {Type::anyref, Type::anyref, Type::anyref}),
           Nullable);
    assert(LUB(a, b) == Type::funcref);
  }

  // {
  //   // Covariance of function results
  //   Type a(Signature(Type::none, {Type::eqref, Type::funcref}), Nullable);
  //   Type b(Signature(Type::none, {Type::funcref, Type::eqref}), Nullable);
  //   assert(LUB(a, b) == Type(Signature(Type::none, {Type::anyref,
  //   Type::anyref}), Nullable));
  // }

  // TODO: Test contravariance in function parameters once that is supported.

  // {
  //   // Nested signatures
  //   Type baseA(Signature(Type::none, Type::eqref), Nullable);
  //   Type baseB(Signature(Type::none, Type::funcref), Nullable);
  //   Type a(Signature(Type::none, baseA), Nullable);
  //   Type b(Signature(Type::none, baseB), Nullable);
  //   Type baseLub(Signature(Type::none, Type::anyref), Nullable);
  //   Type lub(Signature(Type::none, baseLub), Nullable);
  //   assert(LUB(a, b) == lub);
  // }

  // TODO: Test recursive signatures once signature subtyping is supported.

  {
    // Mutable fields are invariant
    Type a(Array(Field(Type::eqref, Mutable)), Nullable);
    Type b(Array(Field(Type::funcref, Mutable)), Nullable);
    assert(LUB(a, b) == Type(HeapType::data, Nullable));
  }

  {
    // Immutable fields are covariant
    Type a(Array(Field(Type::eqref, Immutable)), Nullable);
    Type b(Array(Field(Type::funcref, Immutable)), Nullable);
    Type lub(Array(Field(Type::anyref, Immutable)), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // Depth subtyping
    Type a(Struct({Field(Type::eqref, Immutable)}), Nullable);
    Type b(Struct({Field(Type::funcref, Immutable)}), Nullable);
    Type lub(Struct({Field(Type::anyref, Immutable)}), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // Width subtyping
    Type a(Struct({Field(Type::i32, Immutable)}), Nullable);
    Type b(Struct({Field(Type::i32, Immutable), Field(Type::i32, Immutable)}),
           Nullable);
    assert(LUB(a, b) == a);
  }

  {
    // Width subtyping with different suffixes
    Type a(Struct({Field(Type::i32, Immutable), Field(Type::i64, Immutable)}),
           Nullable);
    Type b(Struct({Field(Type::i32, Immutable), Field(Type::f32, Immutable)}),
           Nullable);
    Type lub(Struct({Field(Type::i32, Immutable)}), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // Width and depth subtyping with different suffixes
    Type a(Struct({Field(Type::eqref, Immutable), Field(Type::i64, Immutable)}),
           Nullable);
    Type b(
      Struct({Field(Type::funcref, Immutable), Field(Type::f32, Immutable)}),
      Nullable);
    Type lub(Struct({Field(Type::anyref, Immutable)}), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // No common prefix
    Type a(
      Struct({Field(Type::i32, Immutable), Field(Type::anyref, Immutable)}),
      Nullable);
    Type b(
      Struct({Field(Type::f32, Immutable), Field(Type::anyref, Immutable)}),
      Nullable);
    Type lub(Struct(), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // Nested structs
    Type innerA(Struct({Field(Type::eqref, Immutable)}), Nullable);
    Type innerB(Struct({Field(Type::funcref, Immutable)}), Nullable);
    Type innerLub(Struct({Field(Type::anyref, Immutable)}), Nullable);
    Type a(Struct({Field(innerA, Immutable)}), Nullable);
    Type b(Struct({Field(innerB, Immutable)}), Nullable);
    Type lub(Struct({Field(innerLub, Immutable)}), Nullable);
    assert(LUB(a, b) == lub);
  }

  {
    // Recursive structs
    TypeBuilder builder(2);
    Type tempA = builder.getTempRefType(builder[0], Nullable);
    Type tempB = builder.getTempRefType(builder[1], Nullable);
    builder[0] =
      Struct({Field(tempB, Immutable), Field(Type::eqref, Immutable)});
    builder[1] =
      Struct({Field(tempA, Immutable), Field(Type::funcref, Immutable)});
    auto built = *builder.build();
    Type a(built[0], Nullable);
    Type b(built[1], Nullable);

    TypeBuilder lubBuilder(1);
    Type tempLub = builder.getTempRefType(lubBuilder[0], Nullable);
    lubBuilder[0] =
      Struct({Field(tempLub, Immutable), Field(Type::anyref, Immutable)});
    built = *lubBuilder.build();
    Type lub(built[0], Nullable);

    assert(LUB(a, b) == lub);
  }

  {
    // Incompatible Rtts
    Type a{Rtt(HeapType::eq)};
    Type b{Rtt(HeapType::func)};
    assert(LUB(a, b) == Type::none);
  }

  {
    // Rtts with matching depth
    Type a(Rtt(42, HeapType::any));
    assert(LUB(a, a) == a);
  }

  {
    // Rtts with mismatched depth
    Type a(Rtt(42, HeapType::any));
    Type b(Rtt(50, HeapType::any));
    Type lub{Rtt(HeapType::any)};
    assert(LUB(a, b) == lub);
  }

  {
    // Rtts with and without depth
    Type a(Rtt(42, HeapType::any));
    Type b{Rtt(HeapType::any)};
    assert(LUB(a, b) == b);
  }

  {
    // Rtts without depth
    Type a{Rtt(HeapType::any)};
    assert(LUB(a, a) == a);
  }
}

int main() {
  // Run the tests twice to ensure things still work when the global stores are
  // already populated.
  for (size_t i = 0; i < 2; ++i) {
    test_canonicalization();
    test_basic();
    test_recursive();
    test_lub();
  }
}
