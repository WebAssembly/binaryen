// export friendly API methods

function preserveStack(func) {
  try {
    var stack = Runtime.stackSave();
    return func();
  } finally {
    Runtime.stackRestore(stack);
  }
};

function strToStack(str) {
  return allocate(intArrayFromString(str), 'i8', ALLOC_STACK);
}

function ptrsToStack(ptrs) {
  return allocate(ptrs, 'i32', ALLOC_STACK);
}

Module['None'] = function() {
  return Module['_BinaryenNone']();
};
Module['Int32'] = function() {
  return Module['_BinaryenInt32']();
};
Module['Int64'] = function() {
  return Module['_BinaryenInt64']();
};
Module['Float32'] = function() {
  return Module['_BinaryenFloat32']();
};
Module['Float64'] = function() {
  return Module['_BinaryenFloat64']();
};
Module['ModuleCreate'] = function() {
  return Module['_BinaryenModuleCreate']();
};
Module['ModuleDispose]' = function(module) {
  Module['_BinaryenModuleDispose'](module);
};
Module['AddFunctionType]' = function(module, name, result, paramTypes) {
  preserveStack(function() {
    return Module['_BinaryenAddFunctionType'](module, strToStack(name), result,
                                              ptrsToStack(paramTypes), paramTypes.length);
  });
};
// Literals: we keep a mapping. These stay alive as long as we do.
var Literals = {
  map: []
};
Module['LiteralInt32'] = function(x) {
  // Literals: the LLVM ABI requires that we pass in a pointer to the struct we "return"
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralInt32'](ptr, x);
  return ret;
};
Module['LiteralInt64'] = function(l, h) {
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralInt64'](ptr, l, h);
  return ret;
};
Module['LiteralFloat32'] = function(x) {
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralFloat32'](ptr, x);
  return ret;
};
Module['LiteralFloat64'] = function(x) {
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralFloat64'](ptr, x);
  return ret;
};
Module['LiteralFloat32Bits'] = function(x) {
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralFloat32Bits'](ptr, x);
  return ret;
};
Module['LiteralFloat64Bits'] = function(l, h) {
  var ptr = _malloc(16);
  var ret = Literals.map.length;
  Literals.map[ret] = ptr;
  Module['_BinaryenLiteralFloat64Bits'](ptr, l, h);
  return ret;
};
Module['ClzInt32'] = function() {
  return Module['_BinaryenClzInt32']();
};
Module['CtzInt32'] = function() {
  return Module['_BinaryenCtzInt32']();
};
Module['PopcntInt32'] = function() {
  return Module['_BinaryenPopcntInt32']();
};
Module['NegFloat32'] = function() {
  return Module['_BinaryenNegFloat32']();
};
Module['AbsFloat32'] = function() {
  return Module['_BinaryenAbsFloat32']();
};
Module['CeilFloat32'] = function() {
  return Module['_BinaryenCeilFloat32']();
};
Module['FloorFloat32'] = function() {
  return Module['_BinaryenFloorFloat32']();
};
Module['TruncFloat32'] = function() {
  return Module['_BinaryenTruncFloat32']();
};
Module['NearestFloat32'] = function() {
  return Module['_BinaryenNearestFloat32']();
};
Module['SqrtFloat32'] = function() {
  return Module['_BinaryenSqrtFloat32']();
};
Module['EqZInt32'] = function() {
  return Module['_BinaryenEqZInt32']();
};
Module['ClzInt64'] = function() {
  return Module['_BinaryenClzInt64']();
};
Module['CtzInt64'] = function() {
  return Module['_BinaryenCtzInt64']();
};
Module['PopcntInt64'] = function() {
  return Module['_BinaryenPopcntInt64']();
};
Module['NegFloat64'] = function() {
  return Module['_BinaryenNegFloat64']();
};
Module['AbsFloat64'] = function() {
  return Module['_BinaryenAbsFloat64']();
};
Module['CeilFloat64'] = function() {
  return Module['_BinaryenCeilFloat64']();
};
Module['FloorFloat64'] = function() {
  return Module['_BinaryenFloorFloat64']();
};
Module['TruncFloat64'] = function() {
  return Module['_BinaryenTruncFloat64']();
};
Module['NearestFloat64'] = function() {
  return Module['_BinaryenNearestFloat64']();
};
Module['SqrtFloat64'] = function() {
  return Module['_BinaryenSqrtFloat64']();
};
Module['EqZInt64'] = function() {
  return Module['_BinaryenEqZInt64']();
};
Module['ExtendSInt32'] = function() {
  return Module['_BinaryenExtendSInt32']();
};
Module['ExtentUInt32'] = function() {
  return Module['_BinaryenExtentUInt32']();
};
Module['WrapInt64'] = function() {
  return Module['_BinaryenWrapInt64']();
};
Module['TruncSFloat32ToInt32'] = function() {
  return Module['_BinaryenTruncSFloat32ToInt32']();
};
Module['TruncSFloat32ToInt64'] = function() {
  return Module['_BinaryenTruncSFloat32ToInt64']();
};
Module['TruncUFloat32ToInt32'] = function() {
  return Module['_BinaryenTruncUFloat32ToInt32']();
};
Module['TruncUFloat32ToInt64'] = function() {
  return Module['_BinaryenTruncUFloat32ToInt64']();
};
Module['TruncSFloat64ToInt32'] = function() {
  return Module['_BinaryenTruncSFloat64ToInt32']();
};
Module['TruncSFloat64ToInt64'] = function() {
  return Module['_BinaryenTruncSFloat64ToInt64']();
};
Module['TruncUFloat64ToInt32'] = function() {
  return Module['_BinaryenTruncUFloat64ToInt32']();
};
Module['TruncUFloat64ToInt64'] = function() {
  return Module['_BinaryenTruncUFloat64ToInt64']();
};
Module['ReinterpretFloat32'] = function() {
  return Module['_BinaryenReinterpretFloat32']();
};
Module['ReinterpretFloat64'] = function() {
  return Module['_BinaryenReinterpretFloat64']();
};
Module['ConvertSInt32ToFloat32'] = function() {
  return Module['_BinaryenConvertSInt32ToFloat32']();
};
Module['ConvertSInt32ToFloat64'] = function() {
  return Module['_BinaryenConvertSInt32ToFloat64']();
};
Module['ConvertUInt32ToFloat32'] = function() {
  return Module['_BinaryenConvertUInt32ToFloat32']();
};
Module['ConvertUInt32ToFloat64'] = function() {
  return Module['_BinaryenConvertUInt32ToFloat64']();
};
Module['ConvertSInt64ToFloat32'] = function() {
  return Module['_BinaryenConvertSInt64ToFloat32']();
};
Module['ConvertSInt64ToFloat64'] = function() {
  return Module['_BinaryenConvertSInt64ToFloat64']();
};
Module['ConvertUInt64ToFloat32'] = function() {
  return Module['_BinaryenConvertUInt64ToFloat32']();
};
Module['ConvertUInt64ToFloat64'] = function() {
  return Module['_BinaryenConvertUInt64ToFloat64']();
};
Module['PromoteFloat32'] = function() {
  return Module['_BinaryenPromoteFloat32']();
};
Module['DemoteFloat64'] = function() {
  return Module['_BinaryenDemoteFloat64']();
};
Module['ReinterpretInt32'] = function() {
  return Module['_BinaryenReinterpretInt32']();
};
Module['ReinterpretInt64'] = function() {
  return Module['_BinaryenReinterpretInt64']();
};
Module['AddInt32'] = function() {
  return Module['_BinaryenAddInt32']();
};
Module['SubInt32'] = function() {
  return Module['_BinaryenSubInt32']();
};
Module['MulInt32'] = function() {
  return Module['_BinaryenMulInt32']();
};
Module['DivSInt32'] = function() {
  return Module['_BinaryenDivSInt32']();
};
Module['DivUInt32'] = function() {
  return Module['_BinaryenDivUInt32']();
};
Module['RemSInt32'] = function() {
  return Module['_BinaryenRemSInt32']();
};
Module['RemUInt32'] = function() {
  return Module['_BinaryenRemUInt32']();
};
Module['AndInt32'] = function() {
  return Module['_BinaryenAndInt32']();
};
Module['OrInt32'] = function() {
  return Module['_BinaryenOrInt32']();
};
Module['XorInt32'] = function() {
  return Module['_BinaryenXorInt32']();
};
Module['ShlInt32'] = function() {
  return Module['_BinaryenShlInt32']();
};
Module['ShrUInt32'] = function() {
  return Module['_BinaryenShrUInt32']();
};
Module['ShrSInt32'] = function() {
  return Module['_BinaryenShrSInt32']();
};
Module['RotLInt32'] = function() {
  return Module['_BinaryenRotLInt32']();
};
Module['RotRInt32'] = function() {
  return Module['_BinaryenRotRInt32']();
};
Module['EqInt32'] = function() {
  return Module['_BinaryenEqInt32']();
};
Module['NeInt32'] = function() {
  return Module['_BinaryenNeInt32']();
};
Module['LtSInt32'] = function() {
  return Module['_BinaryenLtSInt32']();
};
Module['LtUInt32'] = function() {
  return Module['_BinaryenLtUInt32']();
};
Module['LeSInt32'] = function() {
  return Module['_BinaryenLeSInt32']();
};
Module['LeUInt32'] = function() {
  return Module['_BinaryenLeUInt32']();
};
Module['GtSInt32'] = function() {
  return Module['_BinaryenGtSInt32']();
};
Module['GtUInt32'] = function() {
  return Module['_BinaryenGtUInt32']();
};
Module['GeSInt32'] = function() {
  return Module['_BinaryenGeSInt32']();
};
Module['GeUInt32'] = function() {
  return Module['_BinaryenGeUInt32']();
};
Module['AddInt64'] = function() {
  return Module['_BinaryenAddInt64']();
};
Module['SubInt64'] = function() {
  return Module['_BinaryenSubInt64']();
};
Module['MulInt64'] = function() {
  return Module['_BinaryenMulInt64']();
};
Module['DivSInt64'] = function() {
  return Module['_BinaryenDivSInt64']();
};
Module['DivUInt64'] = function() {
  return Module['_BinaryenDivUInt64']();
};
Module['RemSInt64'] = function() {
  return Module['_BinaryenRemSInt64']();
};
Module['RemUInt64'] = function() {
  return Module['_BinaryenRemUInt64']();
};
Module['AndInt64'] = function() {
  return Module['_BinaryenAndInt64']();
};
Module['OrInt64'] = function() {
  return Module['_BinaryenOrInt64']();
};
Module['XorInt64'] = function() {
  return Module['_BinaryenXorInt64']();
};
Module['ShlInt64'] = function() {
  return Module['_BinaryenShlInt64']();
};
Module['ShrUInt64'] = function() {
  return Module['_BinaryenShrUInt64']();
};
Module['ShrSInt64'] = function() {
  return Module['_BinaryenShrSInt64']();
};
Module['RotLInt64'] = function() {
  return Module['_BinaryenRotLInt64']();
};
Module['RotRInt64'] = function() {
  return Module['_BinaryenRotRInt64']();
};
Module['EqInt64'] = function() {
  return Module['_BinaryenEqInt64']();
};
Module['NeInt64'] = function() {
  return Module['_BinaryenNeInt64']();
};
Module['LtSInt64'] = function() {
  return Module['_BinaryenLtSInt64']();
};
Module['LtUInt64'] = function() {
  return Module['_BinaryenLtUInt64']();
};
Module['LeSInt64'] = function() {
  return Module['_BinaryenLeSInt64']();
};
Module['LeUInt64'] = function() {
  return Module['_BinaryenLeUInt64']();
};
Module['GtSInt64'] = function() {
  return Module['_BinaryenGtSInt64']();
};
Module['GtUInt64'] = function() {
  return Module['_BinaryenGtUInt64']();
};
Module['GeSInt64'] = function() {
  return Module['_BinaryenGeSInt64']();
};
Module['GeUInt64'] = function() {
  return Module['_BinaryenGeUInt64']();
};
Module['AddFloat32'] = function() {
  return Module['_BinaryenAddFloat32']();
};
Module['SubFloat32'] = function() {
  return Module['_BinaryenSubFloat32']();
};
Module['MulFloat32'] = function() {
  return Module['_BinaryenMulFloat32']();
};
Module['DivFloat32'] = function() {
  return Module['_BinaryenDivFloat32']();
};
Module['CopySignFloat32'] = function() {
  return Module['_BinaryenCopySignFloat32']();
};
Module['MinFloat32'] = function() {
  return Module['_BinaryenMinFloat32']();
};
Module['MaxFloat32'] = function() {
  return Module['_BinaryenMaxFloat32']();
};
Module['EqFloat32'] = function() {
  return Module['_BinaryenEqFloat32']();
};
Module['NeFloat32'] = function() {
  return Module['_BinaryenNeFloat32']();
};
Module['LtFloat32'] = function() {
  return Module['_BinaryenLtFloat32']();
};
Module['LeFloat32'] = function() {
  return Module['_BinaryenLeFloat32']();
};
Module['GtFloat32'] = function() {
  return Module['_BinaryenGtFloat32']();
};
Module['GeFloat32'] = function() {
  return Module['_BinaryenGeFloat32']();
};
Module['AddFloat64'] = function() {
  return Module['_BinaryenAddFloat64']();
};
Module['SubFloat64'] = function() {
  return Module['_BinaryenSubFloat64']();
};
Module['MulFloat64'] = function() {
  return Module['_BinaryenMulFloat64']();
};
Module['DivFloat64'] = function() {
  return Module['_BinaryenDivFloat64']();
};
Module['CopySignFloat64'] = function() {
  return Module['_BinaryenCopySignFloat64']();
};
Module['MinFloat64'] = function() {
  return Module['_BinaryenMinFloat64']();
};
Module['MaxFloat64'] = function() {
  return Module['_BinaryenMaxFloat64']();
};
Module['EqFloat64'] = function() {
  return Module['_BinaryenEqFloat64']();
};
Module['NeFloat64'] = function() {
  return Module['_BinaryenNeFloat64']();
};
Module['LtFloat64'] = function() {
  return Module['_BinaryenLtFloat64']();
};
Module['LeFloat64'] = function() {
  return Module['_BinaryenLeFloat64']();
};
Module['GtFloat64'] = function() {
  return Module['_BinaryenGtFloat64']();
};
Module['GeFloat64'] = function() {
  return Module['_BinaryenGeFloat64']();
};
Module['PageSize'] = function() {
  return Module['_BinaryenPageSize']();
};
Module['CurrentMemory'] = function() {
  return Module['_BinaryenCurrentMemory']();
};
Module['GrowMemory'] = function() {
  return Module['_BinaryenGrowMemory']();
};
Module['HasFeature'] = function() {
  return Module['_BinaryenHasFeature']();
};
Module['Block'] = function(module, name, children) {
  preserveStack(function() {
    return Module['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                                    ptrsToStack(children), children.length);
  });
};
Module['If'] = function(module, condition, ifTrue, ifFalse) {
  return Module['_BinaryenIf'](module, condition, ifTrue, ifFalse);
};
Module['Loop'] = function(module, label, body) {
  preserveStack(function() {
    return Module['_BinaryenLoop'](module, strToStack(label), body);
  });
};
Module['Break'] = function(module, label, condition, value) {
  preserveStack(function() {
    return Module['_BinaryenBreak'](module, strToStack(label), condition, value);
  });
};
Module['Switch'] = function(module, names, defaultName, condition, value) {
  preserveStack(function() {
    var namePtrs = [];
    names.forEach(function(name) {
      namePtrs.push_back(strToStack(name));
    });
    return Module['_BinaryenSwitch'](module, ptrsToStack(namePtrs), namePtrs.length
                                     strToStack(defaultName), condition, value);
  });
};
Module['Call'] = function(module, name, operands, type) {
  preserveStack(function() {
    return Module['_BinaryenCall'](module, strToStack(name), ptrsToStack(operands), operands.length, type);
  });
};
Module['CallImport'] = function(module, name, operands, type) {
  preserveStack(function() {
    return Module['_BinaryenCallImport'](module, strToStack(name), ptrsToStack(operands), operands.length, type);
  });
};
Module['CallIndirect'] = function(module, target, operands, type) {
  preserveStack(function() {
    return Module['_BinaryenCallIndirect'](module, target, ptrsToStack(operands), operands.length, type);
  });
};
Module['GetLocal'] = function(module, type) {
  return Module['_BinaryenGetLocal'](module, type);
};
Module['SetLocal'] = function(module, value) {
  return Module['_Binaryen'](module, value);
};
Module['TeeLocal'] = function(module, value) {
  return Module['_Binaryen'](module, value);
};
Module['Load'] = function(module, bytes, signed, offset, align, type, ptr) {
  return Module['_BinaryenLoad'](module, bytes, signed, offset, align, type, ptr);
};
Module['Store'] = function(module, bytes, offset, align, type, ptr, value) {
  return Module['_BinaryenStore'](module, bytes, offset, align, type, ptr, value);
};
Module['Const'] = function(module, value) {
  return Module['_BinaryenConst'](module, Literals.map[value]);
};
Module['Unary'] = function(module, op, value) {
  return Module['_BinaryenUnary'](module, op, value);
};
Module['Binary'] = function(module, op, left, right) {
  return Module['_BinaryenBinary'](module, op, left, right);
};
Module['Select'] = function(module, condition, ifTrue, ifFalse) {
  return Module['_BinaryenSelect'](module, condition, ifTrue, ifFalse);
};
Module['Drop'] = function(module, value) {
  return Module['_BinaryenDrop'](module, value);
};
Module['Return'] = function(module, value) {
  return Module['_BinaryenReturn'](module, value);
};
Module['Host'] = function() {
  throw 'TODO';
};
Module['Nop'] = function(module) {
  return Module['_BinaryenNop'](module);
};
Module['Unreachable'] = function(module) {
  return Module['_BinaryenUnreachable'](module);
};
Module['ExpressionPrint'] = function(module, expr) {
  return Module['_BinaryenExpressionPrint'](module, expr);
};
Module['AddFunction'] = function() {
  return Module['_Binaryen']();
};
Module['AddImport'] = function() {
  return Module['_Binaryen']();
};
Module['AddExport'] = function() {
  return Module['_Binaryen']();
};
Module['SetFunctionTable'] = function() {
  return Module['_Binaryen']();
};
Module['SetMemory'] = function() {
  return Module['_Binaryen']();
};
Module['SetStart'] = function() {
  return Module['_Binaryen']();
};
Module['ModulePrint'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleValidate'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleOptimize'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleAutoDrop'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleWrite'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleRead'] = function() {
  return Module['_Binaryen']();
};
Module['ModuleInterpret'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperCreate'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperAddBlock'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperAddBranch'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperAddBlockWithSwitch'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperAddBranchForSwitch'] = function() {
  return Module['_Binaryen']();
};
Module['RelooperRenderAndDispose'] = function() {
  return Module['_Binaryen']();
};
Module['SetAPITracing'] = function() {
  return Module['_Binaryen']();
};
Module['

  return Module;
};

if (typeof exports != 'undefined') {
  (function(){
    var a = Binaryen();
    if (typeof module === 'object') {
      module.exports = a;
    } else {
      for (var k in a) {
        exports[k] = a[k];
      }
    }
  })();
}
(typeof window !== 'undefined' ? window :
 typeof global !== 'undefined' && (
  typeof process === 'undefined' ||
  
  // Note: We must export "Binaryen" even inside a CommonJS/AMD/UMD module
  // space because check.py generates a.js which requires Binaryen global var
  ( process.argv &&
    Array.isArray(process.argv) &&
    process.argv[1] &&
    (process.argv[1].substr(-5) === '/a.js' ||
     process.argv[1].substr(-5) === '\\a.js')
  )

 ) ? global :
 this
)['Binaryen'] = Binaryen;
