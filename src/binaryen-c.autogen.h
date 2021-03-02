// src/binaryen-c.autogen.h

BINARYEN_API BinaryenExpressionRef
BinaryenStructNew(BinaryenModuleRef module,
                  BinaryenExpressionRef rtt,
                  BinaryenExpressionRef* operands,
                  BinaryenIndex num_operands);

BINARYEN_API BinaryenExpressionRef BinaryenStructGet(BinaryenModuleRef module,
                                                     uint32_t index,
                                                     BinaryenExpressionRef ref,
                                                     uint32_t signed_,
                                                     BinaryenType type);

BINARYEN_API BinaryenExpressionRef
BinaryenStructSet(BinaryenModuleRef module,
                  uint32_t index,
                  BinaryenExpressionRef value,
                  BinaryenExpressionRef ref);
