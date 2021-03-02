// src/binaryen-c.autogen.cpp

BINARYEN_API BinaryenExpressionRef
BinaryenStructNew(BinaryenModuleRef module,
                  BinaryenExpressionRef rtt,
                  BinaryenExpressionRef* operands,
                  BinaryenIndex num_operands) {
  std::vector<Expression*> operands_list;
  for (BinaryenIndex i = 0; i < num_operands; i++) {
    operands_list.push_back((Expression*)operands[i]);
  }
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructNew(rtt, operands_list));
}

BINARYEN_API BinaryenExpressionRef BinaryenStructGet(BinaryenModuleRef module,
                                                     uint32_t index,
                                                     BinaryenExpressionRef ref,
                                                     uint32_t signed_,
                                                     BinaryenType type) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructGet(index, ref, signed_, Type(type)));
}

BINARYEN_API BinaryenExpressionRef
BinaryenStructSet(BinaryenModuleRef module,
                  uint32_t index,
                  BinaryenExpressionRef value,
                  BinaryenExpressionRef ref) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructSet(index, value, ref));
}
