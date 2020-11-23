#include <cassert>
#include <iostream>

#include "wasm-type.h"

using namespace wasm;

// Construct Signature, Struct, and Array heap types using undefined types.
void test_builder() {
  std::cout << ";; Test TypeBuilder\n";

  // (type $sig (func (param (ref $struct)) (result (ref $array))))
  // (type $struct (struct (field (ref null $array) (mut ref extern))))
  // (type $array (array (mut ref null extern)))

  TypeBuilder builder(3);

  Type refSig = builder.getTempRefType(0, false);
  Type refStruct = builder.getTempRefType(1, false);
  Type refArray = builder.getTempRefType(2, false);
  Type refNullArray = builder.getTempRefType(2, true);
  Type refExt(HeapType::ExternKind, false);
  Type refNullExt(HeapType::ExternKind, true);

  std::cout << "Before setting builder's heap types:\n";
  std::cout << "(ref $sig) => " << refSig << "\n";
  std::cout << "(ref $struct) => " << refStruct << "\n";
  std::cout << "(ref $array) => " << refArray << "\n";
  std::cout << "(ref null $array) => " << refNullArray << "\n\n";

  HeapType sig = Signature(refStruct, refArray);
  HeapType struct_ = Struct({Field(refNullArray, false), Field(refExt, true)});
  HeapType array = Array(Field(refNullExt, true));

  builder[0] = sig;
  builder[1] = struct_;
  builder[2] = array;

  std::cout << "After setting builder's heap types:\n";
  std::cout << "(ref $sig) => " << refSig << "\n";
  std::cout << "(ref $struct) => " << refStruct << "\n";
  std::cout << "(ref $array) => " << refArray << "\n";
  std::cout << "(ref null $array) => " << refNullArray << "\n\n";

  builder.build();

  refSig = Type(builder[0], false);
  refStruct = Type(builder[1], false);
  refArray = Type(builder[2], false);
  refNullArray = Type(builder[2], true);

  std::cout << "After building types:\n";
  std::cout << "(ref $sig) => " << refSig << "\n";
  std::cout << "(ref $struct) => " << refStruct << "\n";
  std::cout << "(ref $array) => " << refArray << "\n";
  std::cout << "(ref null $array) => " << refNullArray << "\n\n";
}

// Check that the builder works when there are duplicate definitions
void test_canonicalization() {
  std::cout << ";; Test canonicalization\n";

  // (type $struct (struct (field (ref null $sig))))
  // (type $sig (func))
  HeapType sig = Signature(Type::none, Type::none);
  HeapType struct_ = Struct({Field(Type(sig, true), false)});

  TypeBuilder builder(4);
  builder[0] = Struct({Field(builder.getTempRefType(2, true), false)});
  builder[1] = Struct({Field(builder.getTempRefType(3, true), false)});
  builder[2] = builder[3] = sig;

  builder.build();

  assert(Type(struct_, true) == Type(builder[0], true));
  assert(Type(struct_, true) == Type(builder[1], true));
  assert(Type(builder[0], false) == Type(builder[1], false));
}

void test_recursive() {
  std::cout << ";; Test recursive types\n";

  {
    // Trivial recursion
    TypeBuilder builder(1);
    builder[0] = Signature(Type::none, builder.getTempRefType(0, true));
    // builder.build();
  }

  {
    // Mutual recursion
    TypeBuilder builder(2);
    builder[0] = Signature(Type::none, builder.getTempRefType(1, true));
    builder[1] = Signature(Type::none, builder.getTempRefType(0, true));
    // builder.build();
  }

  {
    // A longer chain of recursion
    TypeBuilder builder(5);
    builder[0] = Signature(Type::none, builder.getTempRefType(1, true));
    builder[1] = Signature(Type::none, builder.getTempRefType(2, true));
    builder[2] = Signature(Type::none, builder.getTempRefType(3, true));
    builder[3] = Signature(Type::none, builder.getTempRefType(4, true));
    builder[4] = Signature(Type::none, builder.getTempRefType(0, true));
    // builder.build();
  }
}

int main() {
  test_builder();
  test_canonicalization();
  test_recursive();
}
