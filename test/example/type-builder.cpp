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

  Type tempSigRef1 = builder.getTempRefType(builder[0], Nullable);
  Type tempSigRef2 = builder.getTempRefType(builder[1], Nullable);

  assert(tempSigRef1 != tempSigRef2);
  assert(tempSigRef1 != Type(sig, Nullable));
  assert(tempSigRef2 != Type(sig, Nullable));

  builder[0] = Signature(Type::none, Type::none);
  builder[1] = Signature(Type::none, Type::none);
  builder[2] =
    Struct({Field(tempSigRef1, Immutable), Field(tempSigRef1, Immutable)});
  builder[3] =
    Struct({Field(tempSigRef2, Immutable), Field(tempSigRef2, Immutable)});

  std::vector<HeapType> built = *builder.build();

  assert(built[0] == sig);
  assert(built[1] == sig);
  assert(built[2] == struct_);
  assert(built[3] == struct_);
}

// Check that defined basic HeapTypes are handled correctly.
void test_basic() {
  std::cout << ";; Test basic\n";

  Type canonAnyref = Type(HeapType::any, Nullable);
  Type canonI31ref = Type(HeapType::i31, NonNullable);

  TypeBuilder builder(6);

  Type anyref = builder.getTempRefType(builder[4], Nullable);
  Type i31ref = builder.getTempRefType(builder[5], NonNullable);

  builder[0] = Signature(canonAnyref, canonI31ref);
  builder[1] = Signature(anyref, canonI31ref);
  builder[2] = Signature(canonAnyref, i31ref);
  builder[3] = Signature(anyref, i31ref);
  builder[4] = HeapType::any;
  builder[5] = HeapType::i31;

  std::vector<HeapType> built = *builder.build();

  assert(built[0] == Signature(canonAnyref, canonI31ref));
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
      builder.createRecGroup(0, 2);
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
  }

  {
    // A longer chain of recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(5);
      builder.createRecGroup(0, 5);
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
    assert(built[0] != built[1]);
    assert(built[1] != built[2]);
    assert(built[2] != built[3]);
    assert(built[3] != built[4]);
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
      builder[0] = Signature();
      builder[1] = Signature();
      builder.createRecGroup(2, 2);
      builder[2] = Signature(Type::none, tuple0_2);
      builder[3] = Signature(Type::none, tuple1_3);
      builder[4] = Signature(Type::none, temp2);
      builder[5] = Signature(Type::none, temp3);
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
    assert(built[2] != built[3]);
    assert(built[4] != built[5]);
    assert(built[4].getSignature().results.getHeapType() == built[2]);
    assert(built[5].getSignature().results.getHeapType() == built[3]);
    assert(built[2].getSignature().results ==
           Type({Type(built[0], Nullable), Type(built[2], Nullable)}));
    assert(built[3].getSignature().results ==
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
    assert(built[0] != built[1]);
  }

  {
    // Including a basic heap type
    std::vector<HeapType> built;
    {
      TypeBuilder builder(3);
      Type anyref = builder.getTempRefType(builder[0], Nullable);
      Type temp1 = builder.getTempRefType(builder[1], Nullable);
      builder[0] = HeapType::any;
      builder[1] = Signature(anyref, temp1);
      builder[2] = Signature(anyref, temp1);
      built = *builder.build();
    }
    IndexedTypeNameGenerator print(built);
    std::cout << print(built[0]) << "\n";
    std::cout << print(built[1]) << "\n\n";
    assert(built[0] == HeapType::any);
    assert(built[1].getSignature().results.getHeapType() == built[1]);
    assert(built[2].getSignature().results.getHeapType() == built[1]);
    assert(built[1].getSignature().params == Type(HeapType::any, Nullable));
    assert(built[2].getSignature().params == Type(HeapType::any, Nullable));
    assert(built[1] != built[2]);
  }
}

int main() {
  // Run the tests twice to ensure things still work when the global stores are
  // already populated.
  for (size_t i = 0; i < 2; ++i) {
    test_canonicalization();
    test_basic();
    test_recursive();
  }
}
