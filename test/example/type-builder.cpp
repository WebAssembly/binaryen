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

  TypeBuilder builder(3);

  Type refSig = builder.getTempRefType(0, NonNullable);
  Type refStruct = builder.getTempRefType(1, NonNullable);
  Type refArray = builder.getTempRefType(2, NonNullable);
  Type refNullArray = builder.getTempRefType(2, Nullable);
  Type rttArray = builder.getTempRttType(2, 0);
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

  builder.setHeapType(0, sig);
  builder.setHeapType(1, struct_);
  builder.setHeapType(2, array);

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

  assert(refSig != newRefSig);
  assert(refStruct != newRefStruct);
  assert(refArray != newRefArray);
  assert(refNullArray != newRefNullArray);
  assert(rttArray != newRttArray);

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

  Type tempSigRef1 = builder.getTempRefType(2, Nullable);
  Type tempSigRef2 = builder.getTempRefType(3, Nullable);

  assert(tempSigRef1 != tempSigRef2);
  assert(tempSigRef1 != Type(sig, Nullable));
  assert(tempSigRef2 != Type(sig, Nullable));

  builder.setHeapType(
    0, Struct({Field(tempSigRef1, Immutable), Field(tempSigRef1, Immutable)}));
  builder.setHeapType(
    1, Struct({Field(tempSigRef2, Immutable), Field(tempSigRef2, Immutable)}));
  builder.setHeapType(2, Signature(Type::none, Type::none));
  builder.setHeapType(3, Signature(Type::none, Type::none));

  std::vector<HeapType> built = builder.build();

  assert(built[0] == struct_);
  assert(built[1] == struct_);
  assert(built[2] == sig);
  assert(built[3] == sig);
}

void test_recursive() {
  std::cout << ";; Test recursive types\n";

  {
    // Trivial recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(1);
      Type temp = builder.getTempRefType(0, Nullable);
      builder.setHeapType(0, Signature(Type::none, temp));
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
      Type temp0 = builder.getTempRefType(0, Nullable);
      Type temp1 = builder.getTempRefType(1, Nullable);
      builder.setHeapType(0, Signature(Type::none, temp1));
      builder.setHeapType(1, Signature(Type::none, temp0));
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n\n";
    assert(built[0].getSignature().results.getHeapType() == built[1]);
    assert(built[1].getSignature().results.getHeapType() == built[0]);
  }

  {
    // A longer chain of recursion
    std::vector<HeapType> built;
    {
      TypeBuilder builder(5);
      Type temp0 = builder.getTempRefType(0, Nullable);
      Type temp1 = builder.getTempRefType(1, Nullable);
      Type temp2 = builder.getTempRefType(2, Nullable);
      Type temp3 = builder.getTempRefType(3, Nullable);
      Type temp4 = builder.getTempRefType(4, Nullable);
      builder.setHeapType(0, Signature(Type::none, temp1));
      builder.setHeapType(1, Signature(Type::none, temp2));
      builder.setHeapType(2, Signature(Type::none, temp3));
      builder.setHeapType(3, Signature(Type::none, temp4));
      builder.setHeapType(4, Signature(Type::none, temp0));
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
  }

  {
    // Check canonicalization for non-recursive parents and children of
    // recursive HeapTypes.
    std::vector<HeapType> built;
    {
      TypeBuilder builder(6);
      Type temp0 = builder.getTempRefType(0, Nullable);
      Type temp1 = builder.getTempRefType(1, Nullable);
      Type temp2 = builder.getTempRefType(2, Nullable);
      Type temp3 = builder.getTempRefType(3, Nullable);
      Type tuple0_2 = builder.getTempTupleType({temp0, temp2});
      Type tuple1_3 = builder.getTempTupleType({temp1, temp3});
      builder.setHeapType(0, Signature(Type::none, tuple0_2));
      builder.setHeapType(1, Signature(Type::none, tuple1_3));
      builder.setHeapType(2, Signature());
      builder.setHeapType(3, Signature());
      builder.setHeapType(4, Signature(Type::none, temp0));
      builder.setHeapType(5, Signature(Type::none, temp1));
      built = builder.build();
    }
    std::cout << built[0] << "\n";
    std::cout << built[1] << "\n";
    std::cout << built[2] << "\n";
    std::cout << built[3] << "\n";
    std::cout << built[4] << "\n";
    std::cout << built[5] << "\n\n";
    assert(built[0] != built[1]); // TODO: canonicalize recursive types
    assert(built[2] == built[3]);
    assert(built[4] != built[5]); // Contain "different" recursive types
    assert(built[4].getSignature().results.getHeapType() == built[0]);
    assert(built[5].getSignature().results.getHeapType() == built[1]);
    assert(built[0].getSignature().results ==
           Type({Type(built[0], Nullable), Type(built[2], Nullable)}));
    assert(built[1].getSignature().results ==
           Type({Type(built[1], Nullable), Type(built[3], Nullable)}));
  }
}

int main() {
  test_builder();
  test_canonicalization();
  test_recursive();
}
