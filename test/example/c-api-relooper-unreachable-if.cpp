// beginning a Binaryen API trace
#include <math.h>
#include <map>
#include "binaryen-c.h"
int main() {
  std::map<size_t, BinaryenFunctionTypeRef> functionTypes;
  std::map<size_t, BinaryenExpressionRef> expressions;
  std::map<size_t, BinaryenFunctionRef> functions;
  std::map<size_t, RelooperBlockRef> relooperBlocks;
  BinaryenModuleRef the_module = NULL;
  RelooperRef the_relooper = NULL;
  the_module = BinaryenModuleCreate();
  expressions[size_t(NULL)] = BinaryenExpressionRef(NULL);
  BinaryenModuleAutoDrop(the_module);
  {
    const char* segments[] = { 0 };
    BinaryenExpressionRef segmentOffsets[] = { 0 };
    BinaryenIndex segmentSizes[] = { 0 };
    BinaryenSetMemory(the_module, 256, 256, "memory", segments, segmentOffsets, segmentSizes, 0, 0);
  }
  the_relooper = RelooperCreate(the_module);
  expressions[1] = BinaryenGetLocal(the_module, 0, 1);
  expressions[2] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[3] = BinaryenStore(the_module, 4, 0, 0, expressions[2], expressions[1], 1);
  expressions[4] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[3], expressions[4] };
    expressions[5] = BinaryenBlock(the_module, "bb0", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[5]);
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[0] = BinaryenAddFunctionType(the_module, "rustfn-0-40", 0, paramTypes, 0);
  }
  expressions[6] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[7] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[6]);
  expressions[8] = BinaryenSetLocal(the_module, 0, expressions[7]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[8]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[9] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 1);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[0] = BinaryenAddFunction(the_module, "tinycore::eh_personality", functionTypes[0], varTypes, 3, expressions[9]);
  }
  BinaryenAddFunctionExport(the_module, "tinycore::eh_personality", "tinycore::eh_personality");
  the_relooper = RelooperCreate(the_module);
  expressions[10] = BinaryenGetLocal(the_module, 0, 1);
  expressions[11] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[12] = BinaryenStore(the_module, 4, 0, 0, expressions[11], expressions[10], 1);
  expressions[13] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[12], expressions[13] };
    expressions[14] = BinaryenBlock(the_module, "bb0", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[14]);
  expressions[15] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[16] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[15]);
  expressions[17] = BinaryenSetLocal(the_module, 0, expressions[16]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[17]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[18] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 1);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[1] = BinaryenAddFunction(the_module, "tinycore::eh_unwind_resume", functionTypes[0], varTypes, 3, expressions[18]);
  }
  BinaryenAddFunctionExport(the_module, "tinycore::eh_unwind_resume", "tinycore::eh_unwind_resume");
  the_relooper = RelooperCreate(the_module);
  {
    BinaryenExpressionRef children[] = { 0 };
    expressions[19] = BinaryenBlock(the_module, "bb0", children, 0, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[19]);
  {
    BinaryenExpressionRef children[] = { 0 };
    expressions[20] = BinaryenBlock(the_module, "bb1", children, 0, BinaryenTypeAuto());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[20]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[0], expressions[0]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[1], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[1] = BinaryenAddFunctionType(the_module, "rustfn-0-42", 0, paramTypes, 0);
  }
  expressions[21] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[22] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[21]);
  expressions[23] = BinaryenSetLocal(the_module, 0, expressions[22]);
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[23]);
  RelooperAddBranch(relooperBlocks[2], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[24] = RelooperRenderAndDispose(the_relooper, relooperBlocks[2], 1);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[2] = BinaryenAddFunction(the_module, "tinycore::panic_fmt", functionTypes[1], varTypes, 3, expressions[24]);
  }
  BinaryenAddFunctionExport(the_module, "tinycore::panic_fmt", "tinycore::panic_fmt");
  the_relooper = RelooperCreate(the_module);
  expressions[25] = BinaryenGetLocal(the_module, 0, 1);
  expressions[26] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[27] = BinaryenStore(the_module, 4, 0, 0, expressions[26], expressions[25], 1);
  expressions[28] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[27], expressions[28] };
    expressions[29] = BinaryenBlock(the_module, "bb0", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[29]);
  expressions[30] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[31] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[30]);
  expressions[32] = BinaryenSetLocal(the_module, 0, expressions[31]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[32]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[33] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 1);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[3] = BinaryenAddFunction(the_module, "tinycore::rust_eh_register_frames", functionTypes[0], varTypes, 3, expressions[33]);
  }
  BinaryenAddFunctionExport(the_module, "tinycore::rust_eh_register_frames", "tinycore::rust_eh_register_frames");
  the_relooper = RelooperCreate(the_module);
  expressions[34] = BinaryenGetLocal(the_module, 0, 1);
  expressions[35] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[36] = BinaryenStore(the_module, 4, 0, 0, expressions[35], expressions[34], 1);
  expressions[37] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[36], expressions[37] };
    expressions[38] = BinaryenBlock(the_module, "bb0", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[38]);
  expressions[39] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[40] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[39]);
  expressions[41] = BinaryenSetLocal(the_module, 0, expressions[40]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[41]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[42] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 1);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[4] = BinaryenAddFunction(the_module, "tinycore::rust_eh_unregister_frames", functionTypes[0], varTypes, 3, expressions[42]);
  }
  BinaryenAddFunctionExport(the_module, "tinycore::rust_eh_unregister_frames", "tinycore::rust_eh_unregister_frames");
  the_relooper = RelooperCreate(the_module);
  expressions[43] = BinaryenGetLocal(the_module, 0, 1);
  expressions[44] = BinaryenSetLocal(the_module, 1, expressions[43]);
  expressions[45] = BinaryenGetLocal(the_module, 1, 1);
  expressions[46] = BinaryenSetLocal(the_module, 2, expressions[45]);
  {
    BinaryenType paramTypes[] = { 1 };
    functionTypes[2] = BinaryenAddFunctionType(the_module, "print_i32", 0, paramTypes, 1);
  }
  BinaryenAddFunctionImport(the_module, "print_i32", "spectest", "print", functionTypes[2]);
  expressions[47] = BinaryenGetLocal(the_module, 2, 1);
  {
    BinaryenExpressionRef operands[] = { expressions[47] };
    expressions[48] = BinaryenCall(the_module, "print_i32", operands, 1, 0);
  }
  {
    BinaryenExpressionRef children[] = { expressions[44], expressions[46], expressions[48] };
    expressions[49] = BinaryenBlock(the_module, "bb0", children, 3, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[49]);
  expressions[50] = BinaryenGetLocal(the_module, 3, 1);
  expressions[51] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[52] = BinaryenStore(the_module, 4, 0, 0, expressions[51], expressions[50], 1);
  expressions[53] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[52], expressions[53] };
    expressions[54] = BinaryenBlock(the_module, "bb1", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[54]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 1 };
    functionTypes[3] = BinaryenAddFunctionType(the_module, "rustfn-0-49", 0, paramTypes, 1);
  }
  expressions[55] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[56] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[55]);
  expressions[57] = BinaryenSetLocal(the_module, 3, expressions[56]);
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[57]);
  RelooperAddBranch(relooperBlocks[2], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[58] = RelooperRenderAndDispose(the_relooper, relooperBlocks[2], 4);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 2 };
    functions[5] = BinaryenAddFunction(the_module, "wasm::print_i32", functionTypes[3], varTypes, 5, expressions[58]);
  }
  BinaryenAddFunctionExport(the_module, "wasm::print_i32", "wasm::print_i32");
  the_relooper = RelooperCreate(the_module);
  expressions[59] = BinaryenConst(the_module, BinaryenLiteralInt32(1));
  expressions[60] = BinaryenSetLocal(the_module, 0, expressions[59]);
  expressions[61] = BinaryenGetLocal(the_module, 0, 1);
  expressions[62] = BinaryenSetLocal(the_module, 2, expressions[61]);
  expressions[63] = BinaryenGetLocal(the_module, 2, 1);
  expressions[64] = BinaryenConst(the_module, BinaryenLiteralInt32(2));
  expressions[65] = BinaryenUnary(the_module, 22, expressions[63]);
  expressions[66] = BinaryenUnary(the_module, 22, expressions[64]);
  expressions[67] = BinaryenBinary(the_module, 25, expressions[65], expressions[66]);
  expressions[68] = BinaryenSetLocal(the_module, 8, expressions[67]);
  expressions[69] = BinaryenGetLocal(the_module, 8, 2);
  expressions[70] = BinaryenUnary(the_module, 24, expressions[69]);
  expressions[71] = BinaryenConst(the_module, BinaryenLiteralInt64(32));
  expressions[72] = BinaryenGetLocal(the_module, 8, 2);
  expressions[73] = BinaryenBinary(the_module, 36, expressions[72], expressions[71]);
  expressions[74] = BinaryenUnary(the_module, 24, expressions[73]);
  expressions[75] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[76] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[75]);
  expressions[77] = BinaryenConst(the_module, BinaryenLiteralInt32(128));
  expressions[78] = BinaryenBinary(the_module, 1, expressions[76], expressions[77]);
  expressions[79] = BinaryenTeeLocal(the_module, 3, expressions[78]);
  expressions[80] = BinaryenStore(the_module, 4, 0, 0, expressions[75], expressions[79], 1);
  expressions[81] = BinaryenGetLocal(the_module, 3, 1);
  expressions[82] = BinaryenStore(the_module, 4, 0, 0, expressions[81], expressions[70], 1);
  expressions[83] = BinaryenStore(the_module, 4, 4, 0, expressions[81], expressions[74], 1);
  {
    BinaryenExpressionRef children[] = { expressions[60], expressions[62], expressions[68], expressions[80], expressions[82], expressions[83] };
    expressions[84] = BinaryenBlock(the_module, "bb0", children, 6, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[84]);
  expressions[85] = BinaryenGetLocal(the_module, 3, 1);
  expressions[86] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[85]);
  expressions[87] = BinaryenSetLocal(the_module, 1, expressions[86]);
  expressions[88] = BinaryenGetLocal(the_module, 1, 1);
  expressions[89] = BinaryenSetLocal(the_module, 4, expressions[88]);
  expressions[90] = BinaryenGetLocal(the_module, 4, 1);
  expressions[91] = BinaryenSetLocal(the_module, 5, expressions[90]);
  expressions[92] = BinaryenGetLocal(the_module, 6, 1);
  expressions[93] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[94] = BinaryenStore(the_module, 4, 0, 0, expressions[93], expressions[92], 1);
  expressions[95] = BinaryenGetLocal(the_module, 5, 1);
  expressions[96] = BinaryenReturn(the_module, expressions[95]);
  {
    BinaryenExpressionRef children[] = { expressions[87], expressions[89], expressions[91], expressions[94], expressions[96] };
    expressions[97] = BinaryenBlock(the_module, "bb1", children, 5, BinaryenTypeAuto());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[97]);
  expressions[98] = BinaryenGetLocal(the_module, 3, 1);
  expressions[99] = BinaryenLoad(the_module, 4, 0, 8, 0, 1, expressions[98]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[99], expressions[0]);
  expressions[100] = BinaryenUnreachable(the_module);
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[100]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[2], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[4] = BinaryenAddFunctionType(the_module, "rustfn-0-54", 1, paramTypes, 0);
  }
  expressions[101] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[102] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[101]);
  expressions[103] = BinaryenSetLocal(the_module, 6, expressions[102]);
  relooperBlocks[3] = RelooperAddBlock(the_relooper, expressions[103]);
  RelooperAddBranch(relooperBlocks[3], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[104] = RelooperRenderAndDispose(the_relooper, relooperBlocks[3], 7);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 1, 1, 1, 1, 2 };
    functions[6] = BinaryenAddFunction(the_module, "real_main", functionTypes[4], varTypes, 9, expressions[104]);
  }
  BinaryenAddFunctionExport(the_module, "real_main", "real_main");
  the_relooper = RelooperCreate(the_module);
  expressions[105] = BinaryenGetLocal(the_module, 0, 1);
  expressions[106] = BinaryenSetLocal(the_module, 2, expressions[105]);
  {
    BinaryenExpressionRef operands[] = { 0 };
    expressions[107] = BinaryenCall(the_module, "real_main", operands, 0, 1);
  }
  expressions[108] = BinaryenSetLocal(the_module, 4, expressions[107]);
  {
    BinaryenExpressionRef children[] = { expressions[106], expressions[108] };
    expressions[109] = BinaryenBlock(the_module, "bb0", children, 2, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[109]);
  expressions[110] = BinaryenGetLocal(the_module, 4, 1);
  expressions[111] = BinaryenConst(the_module, BinaryenLiteralInt32(3));
  expressions[112] = BinaryenUnary(the_module, 22, expressions[110]);
  expressions[113] = BinaryenUnary(the_module, 22, expressions[111]);
  expressions[114] = BinaryenBinary(the_module, 25, expressions[112], expressions[113]);
  expressions[115] = BinaryenSetLocal(the_module, 11, expressions[114]);
  expressions[116] = BinaryenGetLocal(the_module, 11, 2);
  expressions[117] = BinaryenUnary(the_module, 24, expressions[116]);
  expressions[118] = BinaryenConst(the_module, BinaryenLiteralInt64(32));
  expressions[119] = BinaryenGetLocal(the_module, 11, 2);
  expressions[120] = BinaryenBinary(the_module, 36, expressions[119], expressions[118]);
  expressions[121] = BinaryenUnary(the_module, 24, expressions[120]);
  expressions[122] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[123] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[122]);
  expressions[124] = BinaryenConst(the_module, BinaryenLiteralInt32(128));
  expressions[125] = BinaryenBinary(the_module, 1, expressions[123], expressions[124]);
  expressions[126] = BinaryenTeeLocal(the_module, 5, expressions[125]);
  expressions[127] = BinaryenStore(the_module, 4, 0, 0, expressions[122], expressions[126], 1);
  expressions[128] = BinaryenGetLocal(the_module, 5, 1);
  expressions[129] = BinaryenStore(the_module, 4, 0, 0, expressions[128], expressions[117], 1);
  expressions[130] = BinaryenStore(the_module, 4, 4, 0, expressions[128], expressions[121], 1);
  {
    BinaryenExpressionRef children[] = { expressions[115], expressions[127], expressions[129], expressions[130] };
    expressions[131] = BinaryenBlock(the_module, "bb1", children, 4, BinaryenTypeAuto());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[131]);
  expressions[132] = BinaryenGetLocal(the_module, 5, 1);
  expressions[133] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[132]);
  expressions[134] = BinaryenSetLocal(the_module, 3, expressions[133]);
  expressions[135] = BinaryenGetLocal(the_module, 3, 1);
  expressions[136] = BinaryenSetLocal(the_module, 6, expressions[135]);
  expressions[137] = BinaryenGetLocal(the_module, 6, 1);
  {
    BinaryenExpressionRef operands[] = { expressions[137] };
    expressions[138] = BinaryenCall(the_module, "wasm::print_i32", operands, 1, 0);
  }
  {
    BinaryenExpressionRef children[] = { expressions[134], expressions[136], expressions[138] };
    expressions[139] = BinaryenBlock(the_module, "bb2", children, 3, BinaryenTypeAuto());
  }
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[139]);
  expressions[140] = BinaryenGetLocal(the_module, 3, 1);
  expressions[141] = BinaryenSetLocal(the_module, 7, expressions[140]);
  expressions[142] = BinaryenGetLocal(the_module, 7, 1);
  expressions[143] = BinaryenSetLocal(the_module, 8, expressions[142]);
  expressions[144] = BinaryenGetLocal(the_module, 9, 1);
  expressions[145] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[146] = BinaryenStore(the_module, 4, 0, 0, expressions[145], expressions[144], 1);
  expressions[147] = BinaryenGetLocal(the_module, 8, 1);
  expressions[148] = BinaryenReturn(the_module, expressions[147]);
  {
    BinaryenExpressionRef children[] = { expressions[141], expressions[143], expressions[146], expressions[148] };
    expressions[149] = BinaryenBlock(the_module, "bb3", children, 4, BinaryenTypeAuto());
  }
  relooperBlocks[3] = RelooperAddBlock(the_relooper, expressions[149]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[0], expressions[0]);
  expressions[150] = BinaryenGetLocal(the_module, 5, 1);
  expressions[151] = BinaryenLoad(the_module, 4, 0, 8, 0, 1, expressions[150]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[2], expressions[151], expressions[0]);
  expressions[152] = BinaryenUnreachable(the_module);
  relooperBlocks[4] = RelooperAddBlock(the_relooper, expressions[152]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[4], expressions[0], expressions[0]);
  RelooperAddBranch(relooperBlocks[2], relooperBlocks[3], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 1, 1 };
    functionTypes[5] = BinaryenAddFunctionType(the_module, "rustfn-0-57", 1, paramTypes, 2);
  }
  expressions[153] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[154] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[153]);
  expressions[155] = BinaryenSetLocal(the_module, 9, expressions[154]);
  relooperBlocks[5] = RelooperAddBlock(the_relooper, expressions[155]);
  RelooperAddBranch(relooperBlocks[5], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[156] = RelooperRenderAndDispose(the_relooper, relooperBlocks[5], 10);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 };
    functions[7] = BinaryenAddFunction(the_module, "main", functionTypes[5], varTypes, 10, expressions[156]);
  }
  BinaryenAddFunctionExport(the_module, "main", "main");
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[6] = BinaryenAddFunctionType(the_module, "__wasm_start", 0, paramTypes, 0);
  }
  {
    const char* segments[] = { 0 };
    BinaryenExpressionRef segmentOffsets[] = { 0 };
    BinaryenIndex segmentSizes[] = { 0 };
    BinaryenSetMemory(the_module, 1, 1, NULL, segments, segmentOffsets, segmentSizes, 0, 0);
  }
  expressions[157] = BinaryenConst(the_module, BinaryenLiteralInt32(65535));
  expressions[158] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[159] = BinaryenStore(the_module, 4, 0, 0, expressions[158], expressions[157], 1);
  expressions[160] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[161] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  {
    BinaryenExpressionRef operands[] = { expressions[160], expressions[161] };
    expressions[162] = BinaryenCall(the_module, "main", operands, 2, 1);
  }
  expressions[163] = BinaryenDrop(the_module, expressions[162]);
  {
    BinaryenExpressionRef children[] = { expressions[159], expressions[163] };
    expressions[164] = BinaryenBlock(the_module, NULL, children, 2, BinaryenTypeAuto());
  }
  BinaryenAddFunctionExport(the_module, "__wasm_start", "rust_entry");
  {
    BinaryenType varTypes[] = { 0 };
    functions[8] = BinaryenAddFunction(the_module, "__wasm_start", functionTypes[6], varTypes, 0, expressions[164]);
  }
  BinaryenSetStart(the_module, functions[8]);
  the_relooper = RelooperCreate(the_module);
  expressions[165] = BinaryenGetLocal(the_module, 0, 1);
  expressions[166] = BinaryenSetLocal(the_module, 2, expressions[165]);
  expressions[167] = BinaryenGetLocal(the_module, 1, 1);
  expressions[168] = BinaryenSetLocal(the_module, 3, expressions[167]);
  expressions[169] = BinaryenGetLocal(the_module, 2, 1);
  expressions[170] = BinaryenSetLocal(the_module, 4, expressions[169]);
  expressions[171] = BinaryenGetLocal(the_module, 3, 1);
  expressions[172] = BinaryenSetLocal(the_module, 5, expressions[171]);
  expressions[173] = BinaryenGetLocal(the_module, 4, 1);
  expressions[174] = BinaryenGetLocal(the_module, 5, 1);
  expressions[175] = BinaryenUnary(the_module, 22, expressions[173]);
  expressions[176] = BinaryenUnary(the_module, 22, expressions[174]);
  expressions[177] = BinaryenBinary(the_module, 25, expressions[175], expressions[176]);
  expressions[178] = BinaryenSetLocal(the_module, 10, expressions[177]);
  expressions[179] = BinaryenGetLocal(the_module, 10, 2);
  expressions[180] = BinaryenUnary(the_module, 24, expressions[179]);
  expressions[181] = BinaryenConst(the_module, BinaryenLiteralInt64(32));
  expressions[182] = BinaryenGetLocal(the_module, 10, 2);
  expressions[183] = BinaryenBinary(the_module, 36, expressions[182], expressions[181]);
  expressions[184] = BinaryenUnary(the_module, 24, expressions[183]);
  expressions[185] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[186] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[185]);
  expressions[187] = BinaryenConst(the_module, BinaryenLiteralInt32(128));
  expressions[188] = BinaryenBinary(the_module, 1, expressions[186], expressions[187]);
  expressions[189] = BinaryenTeeLocal(the_module, 6, expressions[188]);
  expressions[190] = BinaryenStore(the_module, 4, 0, 0, expressions[185], expressions[189], 1);
  expressions[191] = BinaryenGetLocal(the_module, 6, 1);
  expressions[192] = BinaryenStore(the_module, 4, 0, 0, expressions[191], expressions[180], 1);
  expressions[193] = BinaryenStore(the_module, 4, 4, 0, expressions[191], expressions[184], 1);
  {
    BinaryenExpressionRef children[] = { expressions[166], expressions[168], expressions[170], expressions[172], expressions[178], expressions[190], expressions[192], expressions[193] };
    expressions[194] = BinaryenBlock(the_module, "bb0", children, 8, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[194]);
  expressions[195] = BinaryenGetLocal(the_module, 6, 1);
  expressions[196] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[195]);
  expressions[197] = BinaryenSetLocal(the_module, 7, expressions[196]);
  expressions[198] = BinaryenGetLocal(the_module, 8, 1);
  expressions[199] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[200] = BinaryenStore(the_module, 4, 0, 0, expressions[199], expressions[198], 1);
  expressions[201] = BinaryenGetLocal(the_module, 7, 1);
  expressions[202] = BinaryenReturn(the_module, expressions[201]);
  {
    BinaryenExpressionRef children[] = { expressions[197], expressions[200], expressions[202] };
    expressions[203] = BinaryenBlock(the_module, "bb1", children, 3, BinaryenTypeAuto());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[203]);
  expressions[204] = BinaryenGetLocal(the_module, 6, 1);
  expressions[205] = BinaryenLoad(the_module, 4, 0, 8, 0, 1, expressions[204]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[205], expressions[0]);
  expressions[206] = BinaryenUnreachable(the_module);
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[206]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[2], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 1, 1 };
    functionTypes[7] = BinaryenAddFunctionType(the_module, "rustfn-0-13", 1, paramTypes, 2);
  }
  expressions[207] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[208] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[207]);
  expressions[209] = BinaryenSetLocal(the_module, 8, expressions[208]);
  relooperBlocks[3] = RelooperAddBlock(the_relooper, expressions[209]);
  RelooperAddBranch(relooperBlocks[3], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[210] = RelooperRenderAndDispose(the_relooper, relooperBlocks[3], 9);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 1, 1, 1, 1, 2 };
    functions[9] = BinaryenAddFunction(the_module, "_isize_as_tinycore::Add_::add", functionTypes[7], varTypes, 9, expressions[210]);
  }
  BinaryenAddFunctionExport(the_module, "_isize_as_tinycore::Add_::add", "_isize_as_tinycore::Add_::add");
  the_relooper = RelooperCreate(the_module);
  expressions[211] = BinaryenGetLocal(the_module, 0, 1);
  expressions[212] = BinaryenSetLocal(the_module, 1, expressions[211]);
  expressions[213] = BinaryenGetLocal(the_module, 1, 1);
  expressions[214] = BinaryenSetLocal(the_module, 2, expressions[213]);
  expressions[215] = BinaryenGetLocal(the_module, 2, 1);
  expressions[216] = BinaryenUnary(the_module, 20, expressions[215]);
  expressions[217] = BinaryenSetLocal(the_module, 3, expressions[216]);
  expressions[218] = BinaryenGetLocal(the_module, 4, 1);
  expressions[219] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[220] = BinaryenStore(the_module, 4, 0, 0, expressions[219], expressions[218], 1);
  expressions[221] = BinaryenGetLocal(the_module, 3, 1);
  expressions[222] = BinaryenReturn(the_module, expressions[221]);
  {
    BinaryenExpressionRef children[] = { expressions[212], expressions[214], expressions[217], expressions[220], expressions[222] };
    expressions[223] = BinaryenBlock(the_module, "bb0", children, 5, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[223]);
  {
    BinaryenType paramTypes[] = { 1 };
    functionTypes[8] = BinaryenAddFunctionType(the_module, "rustfn-0-22", 1, paramTypes, 1);
  }
  expressions[224] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[225] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[224]);
  expressions[226] = BinaryenSetLocal(the_module, 4, expressions[225]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[226]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[227] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 5);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 1, 2 };
    functions[10] = BinaryenAddFunction(the_module, "_bool_as_tinycore::Not_::not", functionTypes[8], varTypes, 6, expressions[227]);
  }
  BinaryenAddFunctionExport(the_module, "_bool_as_tinycore::Not_::not", "_bool_as_tinycore::Not_::not");
  the_relooper = RelooperCreate(the_module);
  expressions[228] = BinaryenGetLocal(the_module, 0, 1);
  expressions[229] = BinaryenSetLocal(the_module, 2, expressions[228]);
  expressions[230] = BinaryenGetLocal(the_module, 1, 1);
  expressions[231] = BinaryenSetLocal(the_module, 3, expressions[230]);
  expressions[232] = BinaryenGetLocal(the_module, 2, 1);
  expressions[233] = BinaryenSetLocal(the_module, 4, expressions[232]);
  expressions[234] = BinaryenGetLocal(the_module, 3, 1);
  expressions[235] = BinaryenSetLocal(the_module, 5, expressions[234]);
  expressions[236] = BinaryenGetLocal(the_module, 4, 1);
  expressions[237] = BinaryenGetLocal(the_module, 5, 1);
  expressions[238] = BinaryenBinary(the_module, 15, expressions[236], expressions[237]);
  expressions[239] = BinaryenSetLocal(the_module, 6, expressions[238]);
  expressions[240] = BinaryenGetLocal(the_module, 7, 1);
  expressions[241] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[242] = BinaryenStore(the_module, 4, 0, 0, expressions[241], expressions[240], 1);
  expressions[243] = BinaryenGetLocal(the_module, 6, 1);
  expressions[244] = BinaryenReturn(the_module, expressions[243]);
  {
    BinaryenExpressionRef children[] = { expressions[229], expressions[231], expressions[233], expressions[235], expressions[239], expressions[242], expressions[244] };
    expressions[245] = BinaryenBlock(the_module, "bb0", children, 7, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[245]);
  {
    BinaryenType paramTypes[] = { 1, 1 };
    functionTypes[9] = BinaryenAddFunctionType(the_module, "rustfn-0-33", 1, paramTypes, 2);
  }
  expressions[246] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[247] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[246]);
  expressions[248] = BinaryenSetLocal(the_module, 7, expressions[247]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[248]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[249] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 8);
  {
    BinaryenType varTypes[] = { 1, 1, 1, 1, 1, 1, 1, 2 };
    functions[11] = BinaryenAddFunction(the_module, "_i16_as_tinycore::PartialEq_::eq", functionTypes[9], varTypes, 8, expressions[249]);
  }
  BinaryenAddFunctionExport(the_module, "_i16_as_tinycore::PartialEq_::eq", "_i16_as_tinycore::PartialEq_::eq");
  the_relooper = RelooperCreate(the_module);
  expressions[250] = BinaryenGetLocal(the_module, 0, 1);
  expressions[251] = BinaryenSetLocal(the_module, 2, expressions[250]);
  expressions[252] = BinaryenGetLocal(the_module, 1, 1);
  expressions[253] = BinaryenSetLocal(the_module, 3, expressions[252]);
  expressions[254] = BinaryenGetLocal(the_module, 2, 2);
  expressions[255] = BinaryenSetLocal(the_module, 4, expressions[254]);
  expressions[256] = BinaryenGetLocal(the_module, 3, 2);
  expressions[257] = BinaryenSetLocal(the_module, 5, expressions[256]);
  expressions[258] = BinaryenGetLocal(the_module, 4, 2);
  expressions[259] = BinaryenGetLocal(the_module, 5, 2);
  expressions[260] = BinaryenBinary(the_module, 40, expressions[258], expressions[259]);
  expressions[261] = BinaryenSetLocal(the_module, 6, expressions[260]);
  expressions[262] = BinaryenGetLocal(the_module, 7, 1);
  expressions[263] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[264] = BinaryenStore(the_module, 4, 0, 0, expressions[263], expressions[262], 1);
  expressions[265] = BinaryenGetLocal(the_module, 6, 1);
  expressions[266] = BinaryenReturn(the_module, expressions[265]);
  {
    BinaryenExpressionRef children[] = { expressions[251], expressions[253], expressions[255], expressions[257], expressions[261], expressions[264], expressions[266] };
    expressions[267] = BinaryenBlock(the_module, "bb0", children, 7, BinaryenTypeAuto());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[267]);
  {
    BinaryenType paramTypes[] = { 1, 1 };
    functionTypes[10] = BinaryenAddFunctionType(the_module, "rustfn-0-37", 1, paramTypes, 2);
  }
  expressions[268] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[269] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[268]);
  expressions[270] = BinaryenSetLocal(the_module, 7, expressions[269]);
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[270]);
  RelooperAddBranch(relooperBlocks[1], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[271] = RelooperRenderAndDispose(the_relooper, relooperBlocks[1], 8);
  {
    BinaryenType varTypes[] = { 1, 1, 2, 2, 1, 1, 1, 2 };
    functions[12] = BinaryenAddFunction(the_module, "_i64_as_tinycore::PartialEq_::eq", functionTypes[10], varTypes, 8, expressions[271]);
  }
  BinaryenAddFunctionExport(the_module, "_i64_as_tinycore::PartialEq_::eq", "_i64_as_tinycore::PartialEq_::eq");
  BinaryenModuleValidate(the_module);
  BinaryenModuleDispose(the_module);
  functionTypes.clear();
  expressions.clear();
  functions.clear();
  relooperBlocks.clear();
}

