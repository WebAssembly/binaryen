// src/binaryen-c.autogen.cpp

BINARYEN_API BinaryenExpressionRef
BinaryenStructNew(BinaryenModuleRef module, BinaryenExpressionRef rtt, BinaryenExpressionRef* operands, BinaryenIndex num_operands) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructNew(rtt, operands);
}

BINARYEN_API BinaryenExpressionRef
BinaryenStructGet(BinaryenModuleRef module, uint32_t index, BinaryenExpressionRef ref, uint32_t signed_) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructGet(index, ref, signed_);
}

BINARYEN_API BinaryenExpressionRef
BinaryenStructSet(BinaryenModuleRef module, uint32_t index, BinaryenExpressionRef value, BinaryenExpressionRef ref) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeStructSet(index, value, ref);
}
