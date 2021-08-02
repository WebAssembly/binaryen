#include <cassert>
#include <iostream>

#include "wasm-type.h"

using namespace wasm;

// Construct Signature, Struct, and Array heap types using undefined types.
void test_builder() {
  std::cout << ";; Test TypeBuilder\n";

  // (type $sig (func (param (ref $struct)) (result (ref $array) i32)))
  // (type $struct (struct (field (ref null $array) (mut rtt 0 $array))))
  // (type $array (array (mut externref)))

  TypeBuilder builder;
  assert(builder.size() == 0);
  builder.grow(3);
  assert(builder.size() == 3);

  Type refSig = builder.getTempRefType(builder[0], NonNullable);
  Type refStruct = builder.getTempRefType(builder[1], NonNullable);
  Type refArray = builder.getTempRefType(builder[2], NonNullable);
  Type refNullArray = builder.getTempRefType(builder[2], Nullable);
  Type rttArray = builder.getTempRttType(Rtt(0, builder[2]));
  Type refNullExt(HeapType::ext, Nullable);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, Immutable), Field(rttArray, Mutable)});
  Array array(Field(refNullExt, Mutable));

  std::cout << "Before setting heap types:\n";
  std::cout << "(ref $sig) => " << refSig << "\n";
  std::cout << "(ref $struct) => " << refStruct << "\n";
  std::cout << "(ref $array) => " << refArray << "\n";
  std::cout << "(ref null $array) => " << refNullArray << "\n";
  std::cout << "(rtt 0 $array) => " << rttArray << "\n\n";

  builder[0] = sig;
  builder[1] = struct_;
  builder[2] = array;

  std::cout << "After setting heap types:\n";
  std::cout << "(ref $sig) => " << refSig << "\n";
  std::cout << "(ref $struct) => " << refStruct << "\n";
  std::cout << "(ref $array) => " << refArray << "\n";
  std::cout << "(ref null $array) => " << refNullArray << "\n";
  std::cout << "(rtt 0 $array) => " << rttArray << "\n\n";

  std::vector<HeapType> built = builder.build();

  Type newRefSig = Type(built[0], NonNullable);
  Type newRefStruct = Type(built[1], NonNullable);
  Type newRefArray = Type(built[2], NonNullable);
  Type newRefNullArray = Type(built[2], Nullable);
  Type newRttArray = Type(Rtt(0, built[2]));

  std::cout << "After building types:\n";
  std::cout << "(ref $sig) => " << newRefSig << "\n";
  std::cout << "(ref $struct) => " << newRefStruct << "\n";
  std::cout << "(ref $array) => " << newRefArray << "\n";
  std::cout << "(ref null $array) => " << newRefNullArray << "\n";
  std::cout << "(rtt 0 $array) => " << newRttArray << "\n\n";
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

  std::vector<HeapType> built = builder.build();

  assert(built[0] != struct_);
  assert(built[1] != struct_);
  assert(built[0] != built[1]);
  assert(built[2] != sig);
  assert(built[3] != sig);
  assert(built[2] != built[3]);
}

// Check that signatures created with TypeBuilders are properly recorded as
// canonical.
void test_signatures(bool warm) {
  std::cout << ";; Test canonical signatures\n";

  TypeBuilder builder(2);
  Type tempRef = builder.getTempRefType(builder[0], Nullable);
  builder[0] = Signature(Type::anyref, Type::i31ref);
  builder[1] = Signature(tempRef, tempRef);
  std::vector<HeapType> built = builder.build();

  HeapType small = Signature(Type::anyref, Type::i31ref);
  HeapType big =
    Signature(Type(Signature(Type::anyref, Type::i31ref), Nullable),
              Type(Signature(Type::anyref, Type::i31ref), Nullable));
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
      built = builder.build();
    }
    std::cout << built[0] << "\n\n";
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
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n\n";
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
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n";
    std::cout << built[2] << "\n";
    std::cout << built[3] << "\n";
    std::cout << built[4] << "\n\n";
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
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n";
    std::cout << built[2] << "\n";
    std::cout << built[3] << "\n";
    std::cout << built[4] << "\n";
    std::cout << built[5] << "\n\n";
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
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[0]);
    assert(built[1].getSignature().results.getHeapType() == built[0]);
    assert(built[0] != built[1]);
  }
}

void test_subtypes() {
  std::cout << ";; Test subtyping\n";

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
    // Basic Types
    for (auto other : {HeapType::func,
                       HeapType::ext,
                       HeapType::any,
                       HeapType::eq,
                       HeapType::i31,
                       HeapType::data}) {
      assert(LUB(HeapType::any, other) == HeapType::any);
    }
    assert(LUB(HeapType::eq, HeapType::func) == HeapType::any);
    assert(LUB(HeapType::i31, HeapType::data) == HeapType::eq);
  }

  {
    // Identity
    std::vector<HeapType> built;
    {
      TypeBuilder builder(3);
      builder[0] = Signature(Type::none, Type::none);
      builder[1] = Struct{};
      builder[2] = Array(Field(Type::i32, Mutable));
      built = builder.build();
    }
    assert(LUB(built[0], built[0]) == built[0]);
    assert(LUB(built[1], built[1]) == built[1]);
    assert(LUB(built[2], built[2]) == built[2]);
  }

  {
    // No subtype declarations mean no subtypes
    std::vector<HeapType> built;
    {
      TypeBuilder builder(5);
      Type structRef0 = builder.getTempRefType(builder[0], Nullable);
      Type structRef1 = builder.getTempRefType(builder[1], Nullable);
      builder[0] = Struct{};
      builder[1] = Struct{};
      builder[2] = Signature(Type::none, Type::anyref);
      builder[3] = Signature(Type::none, structRef0);
      builder[4] = Signature(Type::none, structRef1);
      built = builder.build();
    }
    assert(LUB(built[0], built[1]) == HeapType::data);
    assert(LUB(built[2], built[3]) == HeapType::func);
    assert(LUB(built[2], built[4]) == HeapType::func);
  }

  {
    // Subtype declarations, but still no subtypes
    std::vector<HeapType> built;
    {
      TypeBuilder builder(3);
      builder[0].subTypeOf(builder[1]);
      builder[0] = Struct{};
      builder[1] = Struct{};
      builder[2] = Struct{};
      built = builder.build();
    }
    assert(LUB(built[0], built[2]) == HeapType::data);
  }

  {
    // Subtyping of identical types
    std::vector<HeapType> built;
    {
      TypeBuilder builder(6);
      builder[0].subTypeOf(builder[1]);
      builder[2].subTypeOf(builder[3]);
      builder[4].subTypeOf(builder[5]);
      builder[0] =
        Struct({Field(Type::i32, Mutable), Field(Type::anyref, Mutable)});
      builder[1] =
        Struct({Field(Type::i32, Mutable), Field(Type::anyref, Mutable)});
      builder[2] = Signature(Type::i32, Type::anyref);
      builder[3] = Signature(Type::i32, Type::anyref);
      builder[4] = Array(Field(Type::i32, Mutable));
      builder[5] = Array(Field(Type::i32, Mutable));
      built = builder.build();
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
      built = builder.build();
    }
    assert(LUB(built[1], built[0]) == built[0]);
  }

  {
    // Depth subtyping
    std::vector<HeapType> built;
    {
      TypeBuilder builder(2);
      builder[0] = Struct({Field(Type::anyref, Immutable)});
      builder[1] = Struct({Field(Type::funcref, Immutable)});
      builder[1].subTypeOf(builder[0]);
      built = builder.build();
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
      built = builder.build();
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
    test_signatures(i == 1);
    test_recursive();
    test_subtypes();
  }
}
