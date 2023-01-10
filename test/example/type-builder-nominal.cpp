#include <cassert>
#include <iostream>

#include "wasm-builder.h"
#include "wasm-type-printing.h"
#include "wasm-type.h"

using namespace wasm;

// Construct Signature, Struct, and Array heap types using undefined types.
void test_builder() {
  std::cout << ";; Test TypeBuilder\n";

  // (type $sig (func (param (ref $struct)) (result (ref $array) i32)))
  // (type $struct (struct (field (ref null $array))))
  // (type $array (array (mut anyref)))

  TypeBuilder builder;
  assert(builder.size() == 0);
  builder.grow(3);
  assert(builder.size() == 3);

  Type refSig = builder.getTempRefType(builder[0], NonNullable);
  Type refStruct = builder.getTempRefType(builder[1], NonNullable);
  Type refArray = builder.getTempRefType(builder[2], NonNullable);
  Type refNullArray = builder.getTempRefType(builder[2], Nullable);
  Type refNullAny(HeapType::any, Nullable);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, Immutable)});
  Array array(Field(refNullAny, Mutable));

  {
    IndexedTypeNameGenerator print(builder);
    std::cout << "Before setting heap types:\n";
    std::cout << "$sig => " << print(builder[0]) << "\n";
    std::cout << "$struct => " << print(builder[1]) << "\n";
    std::cout << "$array => " << print(builder[2]) << "\n";
    std::cout << "(ref $sig) => " << print(refSig) << "\n";
    std::cout << "(ref $struct) => " << print(refStruct) << "\n";
    std::cout << "(ref $array) => " << print(refArray) << "\n";
    std::cout << "(ref null $array) => " << print(refNullArray) << "\n";
  }

  builder[0] = sig;
  builder[1] = struct_;
  builder[2] = array;

  {
    IndexedTypeNameGenerator print(builder);
    std::cout << "After setting heap types:\n";
    std::cout << "$sig => " << print(builder[0]) << "\n";
    std::cout << "$struct => " << print(builder[1]) << "\n";
    std::cout << "$array => " << print(builder[2]) << "\n";
    std::cout << "(ref $sig) => " << print(refSig) << "\n";
    std::cout << "(ref $struct) => " << print(refStruct) << "\n";
    std::cout << "(ref $array) => " << print(refArray) << "\n";
    std::cout << "(ref null $array) => " << print(refNullArray) << "\n";
  }

  std::vector<HeapType> built = *builder.build();

  Type newRefSig = Type(built[0], NonNullable);
  Type newRefStruct = Type(built[1], NonNullable);
  Type newRefArray = Type(built[2], NonNullable);
  Type newRefNullArray = Type(built[2], Nullable);

  {
    IndexedTypeNameGenerator print(built);
    std::cout << "After building types:\n";
    std::cout << "$sig => " << print(built[0]) << "\n";
    std::cout << "$struct => " << print(built[1]) << "\n";
    std::cout << "$array => " << print(built[2]) << "\n";
    std::cout << "(ref $sig) => " << print(newRefSig) << "\n";
    std::cout << "(ref $struct) => " << print(newRefStruct) << "\n";
    std::cout << "(ref $array) => " << print(newRefArray) << "\n";
    std::cout << "(ref null $array) => " << print(newRefNullArray) << "\n";
  }
}

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

  assert(built[0] != struct_);
  assert(built[1] != struct_);
  assert(built[0] != built[1]);
  assert(built[2] != sig);
  assert(built[3] != sig);
  assert(built[2] != built[3]);
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

  assert(built[0].getSignature() == Signature(canonAnyref, canonI31ref));
  assert(built[1].getSignature() == built[0].getSignature());
  assert(built[2].getSignature() == built[1].getSignature());
  assert(built[3].getSignature() == built[2].getSignature());
  assert(built[4] == HeapType::any);
  assert(built[5] == HeapType::i31);
}

// Check that signatures created with TypeBuilders are properly recorded as
// canonical.
void test_signatures(bool warm) {
  std::cout << ";; Test canonical signatures\n";

  Type canonAnyref = Type(HeapType::any, Nullable);
  Type canonI31ref = Type(HeapType::i31, NonNullable);

  TypeBuilder builder(2);
  Type tempRef = builder.getTempRefType(builder[0], Nullable);
  builder[0] = Signature(canonI31ref, canonAnyref);
  builder[1] = Signature(tempRef, tempRef);
  std::vector<HeapType> built = *builder.build();

  HeapType small = Signature(canonI31ref, canonAnyref);
  HeapType big = Signature(Type(Signature(canonI31ref, canonAnyref), Nullable),
                           Type(Signature(canonI31ref, canonAnyref), Nullable));
  if (warm) {
    assert(built[0] != small);
    assert(built[1] != big);
  } else {
    assert(built[0] == small);
    assert(built[1] == big);
  }
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
    assert(built[0] != built[1]);
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
    assert(built[0] != built[1]);
    assert(built[0] != built[2]);
    assert(built[0] != built[3]);
    assert(built[0] != built[4]);
    assert(built[1] != built[2]);
    assert(built[1] != built[3]);
    assert(built[1] != built[4]);
    assert(built[2] != built[3]);
    assert(built[2] != built[4]);
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
    assert(built[0] != built[1]);
    assert(built[2] != built[3]);
    assert(built[4] != built[5]);
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
    assert(built[0] != built[1]);
  }
}

void test_subtypes() {
  std::cout << ";; Test subtyping\n";

  Type anyref = Type(HeapType::any, Nullable);
  Type eqref = Type(HeapType::eq, Nullable);

  auto LUB = [&](HeapType a, HeapType b) {
    Type refA = Type(a, Nullable);
    Type refB = Type(b, Nullable);
    Type lubAB = Type::getLeastUpperBound(refA, refB);
    Type lubBA = Type::getLeastUpperBound(refB, refA);
    assert(lubAB == lubBA);
    assert(lubAB != Type::none);
    HeapType lub = lubAB.getHeapType();
    assert(Type::hasLeastUpperBound(refA, refB));
    assert(Type::hasLeastUpperBound(refB, refA));
    assert(Type::isSubType(refA, lubAB));
    assert(Type::isSubType(refB, lubAB));
    assert(HeapType::isSubType(a, lub));
    assert(HeapType::isSubType(b, lub));
    assert(lub == a || !HeapType::isSubType(lub, a));
    assert(lub == b || !HeapType::isSubType(lub, b));
    return lub;
  };

  {
    // Subtype declarations, but still no subtypes
    std::vector<HeapType> built;
    {
      TypeBuilder builder(3);
      builder[0].subTypeOf(builder[1]);
      builder[0] = Struct{};
      builder[1] = Struct{};
      builder[2] = Struct{};
      built = *builder.build();
    }
    assert(LUB(built[0], built[2]) == HeapType::struct_);
  }

  {
    // Subtyping of identical types
    std::vector<HeapType> built;
    {
      TypeBuilder builder(6);
      builder[0].subTypeOf(builder[1]);
      builder[2].subTypeOf(builder[3]);
      builder[4].subTypeOf(builder[5]);
      builder[0] = Struct({Field(Type::i32, Mutable), Field(anyref, Mutable)});
      builder[1] = Struct({Field(Type::i32, Mutable), Field(anyref, Mutable)});
      builder[2] = Signature(Type::i32, anyref);
      builder[3] = Signature(Type::i32, anyref);
      builder[4] = Array(Field(Type::i32, Mutable));
      builder[5] = Array(Field(Type::i32, Mutable));
      built = *builder.build();
    }
    assert(LUB(built[0], built[1]) == built[1]);
    assert(LUB(built[2], built[3]) == built[3]);
    assert(LUB(built[4], built[5]) == built[5]);
  }

  {
    // Width subtyping
    std::vector<HeapType> built;
    {
      TypeBuilder builder(2);
      builder[0] = Struct({Field(Type::i32, Immutable)});
      builder[1] =
        Struct({Field(Type::i32, Immutable), Field(Type::i32, Immutable)});
      builder[1].subTypeOf(builder[0]);
      built = *builder.build();
    }
    assert(LUB(built[1], built[0]) == built[0]);
  }

  {
    // Depth subtyping
    std::vector<HeapType> built;
    {
      TypeBuilder builder(2);
      builder[0] = Struct({Field(anyref, Immutable)});
      builder[1] = Struct({Field(eqref, Immutable)});
      builder[1].subTypeOf(builder[0]);
      built = *builder.build();
    }
    assert(LUB(built[1], built[0]) == built[0]);
  }

  {
    // Mutually recursive subtyping
    std::vector<HeapType> built;
    {
      TypeBuilder builder(4);
      Type a = builder.getTempRefType(builder[0], Nullable);
      Type b = builder.getTempRefType(builder[1], Nullable);
      Type c = builder.getTempRefType(builder[2], Nullable);
      Type d = builder.getTempRefType(builder[3], Nullable);
      builder[1].subTypeOf(builder[0]);
      builder[3].subTypeOf(builder[2]);
      builder[0] = Struct({Field(c, Immutable)});
      builder[1] = Struct({Field(d, Immutable)});
      builder[2] = Struct({Field(a, Immutable)});
      builder[3] = Struct({Field(b, Immutable)});
      built = *builder.build();
    }
    assert(LUB(built[0], built[1]) == built[0]);
    assert(LUB(built[2], built[3]) == built[2]);
  }
}

int main() {
  wasm::setTypeSystem(TypeSystem::Nominal);

  // Run the tests twice to ensure things still work when the global stores are
  // already populated.
  for (size_t i = 0; i < 2; ++i) {
    test_builder();
    test_canonicalization();
    test_basic();
    test_signatures(i == 1);
    test_recursive();
    test_subtypes();
  }
}
