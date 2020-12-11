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

  Type refSig = builder.getTempRefType(0, false);
  Type refStruct = builder.getTempRefType(1, false);
  Type refArray = builder.getTempRefType(2, false);
  Type refNullArray = builder.getTempRefType(2, true);
  Type rttArray = builder.getTempRttType(2, 0);
  Type refNullExt(HeapType::ext, true);

  Signature sig(refStruct, builder.getTempTupleType({refArray, Type::i32}));
  Struct struct_({Field(refNullArray, false), Field(rttArray, true)});
  Array array(Field(refNullExt, true));

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

  Type newRefSig = Type(built[0], false);
  Type newRefStruct = Type(built[1], false);
  Type newRefArray = Type(built[2], false);
  Type newRefNullArray = Type(built[2], true);
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

  // (type $struct (struct (field (ref null $sig))))
  // (type $sig (func))
  HeapType sig = Signature(Type::none, Type::none);
  HeapType struct_ = Struct({Field(Type(sig, true), false)});

  TypeBuilder builder(4);

  Type tempSigRef1 = builder.getTempRefType(2, true);
  Type tempSigRef2 = builder.getTempRefType(3, true);

  assert(tempSigRef1 != tempSigRef2);
  assert(tempSigRef1 != Type(sig, true));
  assert(tempSigRef2 != Type(sig, true));

  builder.setHeapType(0, Struct({Field(tempSigRef1, false)}));
  builder.setHeapType(1, Struct({Field(tempSigRef2, false)}));
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
    TypeBuilder builder(1);
    Type temp = builder.getTempRefType(0, true);
    builder.setHeapType(0, Signature(Type::none, temp));
    // std::vector<HeapType> built = builder.build();
  }

  {
    // Mutual recursion
    TypeBuilder builder(2);
    Type temp0 = builder.getTempRefType(0, true);
    Type temp1 = builder.getTempRefType(1, true);
    builder.setHeapType(0, Signature(Type::none, temp1));
    builder.setHeapType(1, Signature(Type::none, temp0));
    // std::vector<HeapType> built = builder.build();
  }

  {
    // A longer chain of recursion
    TypeBuilder builder(5);
    Type temp0 = builder.getTempRefType(0, true);
    Type temp1 = builder.getTempRefType(1, true);
    Type temp2 = builder.getTempRefType(2, true);
    Type temp3 = builder.getTempRefType(3, true);
    Type temp4 = builder.getTempRefType(4, true);
    builder.setHeapType(0, Signature(Type::none, temp1));
    builder.setHeapType(1, Signature(Type::none, temp2));
    builder.setHeapType(2, Signature(Type::none, temp3));
    builder.setHeapType(3, Signature(Type::none, temp4));
    builder.setHeapType(4, Signature(Type::none, temp0));
    // std::vector<HeapType> built = builder.build();
  }
}

int main() {
  test_builder();
  test_canonicalization();
  test_recursive();
}
