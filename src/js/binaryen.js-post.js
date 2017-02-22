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

  function i32sToStack(i32s) {
    var ret = Runtime.stackAlloc(i32s.length << 2);
    for (var i = 0; i < i32s.length; i++) {
      HEAP32[ret + (i << 2) >> 2] = i32s[i];
    }
    return ret;
  }

  Module['None'] = Module['_BinaryenNone'];
  Module['Int32'] = Module['_BinaryenInt32']();
  Module['Int64'] = Module['_BinaryenInt64']();
  Module['Float32'] = Module['_BinaryenFloat32']();
  Module['Float64'] = Module['_BinaryenFloat64']();

  Module['ClzInt32'] = Module['_BinaryenClzInt32']();
  Module['CtzInt32'] = Module['_BinaryenCtzInt32']();
  Module['PopcntInt32'] = Module['_BinaryenPopcntInt32']();
  Module['NegFloat32'] = Module['_BinaryenNegFloat32']();
  Module['AbsFloat32'] = Module['_BinaryenAbsFloat32']();
  Module['CeilFloat32'] = Module['_BinaryenCeilFloat32']();
  Module['FloorFloat32'] = Module['_BinaryenFloorFloat32']();
  Module['TruncFloat32'] = Module['_BinaryenTruncFloat32']();
  Module['NearestFloat32'] = Module['_BinaryenNearestFloat32']();
  Module['SqrtFloat32'] = Module['_BinaryenSqrtFloat32']();
  Module['EqZInt32'] = Module['_BinaryenEqZInt32']();
  Module['ClzInt64'] = Module['_BinaryenClzInt64']();
  Module['CtzInt64'] = Module['_BinaryenCtzInt64']();
  Module['PopcntInt64'] = Module['_BinaryenPopcntInt64']();
  Module['NegFloat64'] = Module['_BinaryenNegFloat64']();
  Module['AbsFloat64'] = Module['_BinaryenAbsFloat64']();
  Module['CeilFloat64'] = Module['_BinaryenCeilFloat64']();
  Module['FloorFloat64'] = Module['_BinaryenFloorFloat64']();
  Module['TruncFloat64'] = Module['_BinaryenTruncFloat64']();
  Module['NearestFloat64'] = Module['_BinaryenNearestFloat64']();
  Module['SqrtFloat64'] = Module['_BinaryenSqrtFloat64']();
  Module['EqZInt64'] = Module['_BinaryenEqZInt64']();
  Module['ExtendSInt32'] = Module['_BinaryenExtendSInt32']();
  Module['ExtentUInt32'] = Module['_BinaryenExtentUInt32']();
  Module['WrapInt64'] = Module['_BinaryenWrapInt64']();
  Module['TruncSFloat32ToInt32'] = Module['_BinaryenTruncSFloat32ToInt32']();
  Module['TruncSFloat32ToInt64'] = Module['_BinaryenTruncSFloat32ToInt64']();
  Module['TruncUFloat32ToInt32'] = Module['_BinaryenTruncUFloat32ToInt32']();
  Module['TruncUFloat32ToInt64'] = Module['_BinaryenTruncUFloat32ToInt64']();
  Module['TruncSFloat64ToInt32'] = Module['_BinaryenTruncSFloat64ToInt32']();
  Module['TruncSFloat64ToInt64'] = Module['_BinaryenTruncSFloat64ToInt64']();
  Module['TruncUFloat64ToInt32'] = Module['_BinaryenTruncUFloat64ToInt32']();
  Module['TruncUFloat64ToInt64'] = Module['_BinaryenTruncUFloat64ToInt64']();
  Module['ReinterpretFloat32'] = Module['_BinaryenReinterpretFloat32']();
  Module['ReinterpretFloat64'] = Module['_BinaryenReinterpretFloat64']();
  Module['ConvertSInt32ToFloat32'] = Module['_BinaryenConvertSInt32ToFloat32']();
  Module['ConvertSInt32ToFloat64'] = Module['_BinaryenConvertSInt32ToFloat64']();
  Module['ConvertUInt32ToFloat32'] = Module['_BinaryenConvertUInt32ToFloat32']();
  Module['ConvertUInt32ToFloat64'] = Module['_BinaryenConvertUInt32ToFloat64']();
  Module['ConvertSInt64ToFloat32'] = Module['_BinaryenConvertSInt64ToFloat32']();
  Module['ConvertSInt64ToFloat64'] = Module['_BinaryenConvertSInt64ToFloat64']();
  Module['ConvertUInt64ToFloat32'] = Module['_BinaryenConvertUInt64ToFloat32']();
  Module['ConvertUInt64ToFloat64'] = Module['_BinaryenConvertUInt64ToFloat64']();
  Module['PromoteFloat32'] = Module['_BinaryenPromoteFloat32']();
  Module['DemoteFloat64'] = Module['_BinaryenDemoteFloat64']();
  Module['ReinterpretInt32'] = Module['_BinaryenReinterpretInt32']();
  Module['ReinterpretInt64'] = Module['_BinaryenReinterpretInt64']();
  Module['AddInt32'] = Module['_BinaryenAddInt32']();
  Module['SubInt32'] = Module['_BinaryenSubInt32']();
  Module['MulInt32'] = Module['_BinaryenMulInt32']();
  Module['DivSInt32'] = Module['_BinaryenDivSInt32']();
  Module['DivUInt32'] = Module['_BinaryenDivUInt32']();
  Module['RemSInt32'] = Module['_BinaryenRemSInt32']();
  Module['RemUInt32'] = Module['_BinaryenRemUInt32']();
  Module['AndInt32'] = Module['_BinaryenAndInt32']();
  Module['OrInt32'] = Module['_BinaryenOrInt32']();
  Module['XorInt32'] = Module['_BinaryenXorInt32']();
  Module['ShlInt32'] = Module['_BinaryenShlInt32']();
  Module['ShrUInt32'] = Module['_BinaryenShrUInt32']();
  Module['ShrSInt32'] = Module['_BinaryenShrSInt32']();
  Module['RotLInt32'] = Module['_BinaryenRotLInt32']();
  Module['RotRInt32'] = Module['_BinaryenRotRInt32']();
  Module['EqInt32'] = Module['_BinaryenEqInt32']();
  Module['NeInt32'] = Module['_BinaryenNeInt32']();
  Module['LtSInt32'] = Module['_BinaryenLtSInt32']();
  Module['LtUInt32'] = Module['_BinaryenLtUInt32']();
  Module['LeSInt32'] = Module['_BinaryenLeSInt32']();
  Module['LeUInt32'] = Module['_BinaryenLeUInt32']();
  Module['GtSInt32'] = Module['_BinaryenGtSInt32']();
  Module['GtUInt32'] = Module['_BinaryenGtUInt32']();
  Module['GeSInt32'] = Module['_BinaryenGeSInt32']();
  Module['GeUInt32'] = Module['_BinaryenGeUInt32']();
  Module['AddInt64'] = Module['_BinaryenAddInt64']();
  Module['SubInt64'] = Module['_BinaryenSubInt64']();
  Module['MulInt64'] = Module['_BinaryenMulInt64']();
  Module['DivSInt64'] = Module['_BinaryenDivSInt64']();
  Module['DivUInt64'] = Module['_BinaryenDivUInt64']();
  Module['RemSInt64'] = Module['_BinaryenRemSInt64']();
  Module['RemUInt64'] = Module['_BinaryenRemUInt64']();
  Module['AndInt64'] = Module['_BinaryenAndInt64']();
  Module['OrInt64'] = Module['_BinaryenOrInt64']();
  Module['XorInt64'] = Module['_BinaryenXorInt64']();
  Module['ShlInt64'] = Module['_BinaryenShlInt64']();
  Module['ShrUInt64'] = Module['_BinaryenShrUInt64']();
  Module['ShrSInt64'] = Module['_BinaryenShrSInt64']();
  Module['RotLInt64'] = Module['_BinaryenRotLInt64']();
  Module['RotRInt64'] = Module['_BinaryenRotRInt64']();
  Module['EqInt64'] = Module['_BinaryenEqInt64']();
  Module['NeInt64'] = Module['_BinaryenNeInt64']();
  Module['LtSInt64'] = Module['_BinaryenLtSInt64']();
  Module['LtUInt64'] = Module['_BinaryenLtUInt64']();
  Module['LeSInt64'] = Module['_BinaryenLeSInt64']();
  Module['LeUInt64'] = Module['_BinaryenLeUInt64']();
  Module['GtSInt64'] = Module['_BinaryenGtSInt64']();
  Module['GtUInt64'] = Module['_BinaryenGtUInt64']();
  Module['GeSInt64'] = Module['_BinaryenGeSInt64']();
  Module['GeUInt64'] = Module['_BinaryenGeUInt64']();
  Module['AddFloat32'] = Module['_BinaryenAddFloat32']();
  Module['SubFloat32'] = Module['_BinaryenSubFloat32']();
  Module['MulFloat32'] = Module['_BinaryenMulFloat32']();
  Module['DivFloat32'] = Module['_BinaryenDivFloat32']();
  Module['CopySignFloat32'] = Module['_BinaryenCopySignFloat32']();
  Module['MinFloat32'] = Module['_BinaryenMinFloat32']();
  Module['MaxFloat32'] = Module['_BinaryenMaxFloat32']();
  Module['EqFloat32'] = Module['_BinaryenEqFloat32']();
  Module['NeFloat32'] = Module['_BinaryenNeFloat32']();
  Module['LtFloat32'] = Module['_BinaryenLtFloat32']();
  Module['LeFloat32'] = Module['_BinaryenLeFloat32']();
  Module['GtFloat32'] = Module['_BinaryenGtFloat32']();
  Module['GeFloat32'] = Module['_BinaryenGeFloat32']();
  Module['AddFloat64'] = Module['_BinaryenAddFloat64']();
  Module['SubFloat64'] = Module['_BinaryenSubFloat64']();
  Module['MulFloat64'] = Module['_BinaryenMulFloat64']();
  Module['DivFloat64'] = Module['_BinaryenDivFloat64']();
  Module['CopySignFloat64'] = Module['_BinaryenCopySignFloat64']();
  Module['MinFloat64'] = Module['_BinaryenMinFloat64']();
  Module['MaxFloat64'] = Module['_BinaryenMaxFloat64']();
  Module['EqFloat64'] = Module['_BinaryenEqFloat64']();
  Module['NeFloat64'] = Module['_BinaryenNeFloat64']();
  Module['LtFloat64'] = Module['_BinaryenLtFloat64']();
  Module['LeFloat64'] = Module['_BinaryenLeFloat64']();
  Module['GtFloat64'] = Module['_BinaryenGtFloat64']();
  Module['GeFloat64'] = Module['_BinaryenGeFloat64']();
  Module['PageSize'] = Module['_BinaryenPageSize']();
  Module['CurrentMemory'] = Module['_BinaryenCurrentMemory']();
  Module['GrowMemory'] = Module['_BinaryenGrowMemory']();
  Module['HasFeature'] = Module['_BinaryenHasFeature']();

  // we provide a JS Module() object interface
  Module['Module'] = function() {
    var module = this.ptr = Module['_BinaryenModuleCreate']();

    this['dispose'] = function() {
      Module['_BinaryenModuleDispose'](module);
    };
    this['addFunctionType'] = function(name, result, paramTypes) {
      return preserveStack(function() {
        return Module['_BinaryenAddFunctionType'](module, strToStack(name), result,
                                                  i32sToStack(paramTypes), paramTypes.length);
      });
    };

    this['block'] = function(name, children) {
      return preserveStack(function() {
        return Module['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                                        i32sToStack(children), children.length);
      });
    };
    this['if'] = function(condition, ifTrue, ifFalse) {
      return Module['_BinaryenIf'](module, condition, ifTrue, ifFalse);
    };
    this['loop'] = function(label, body) {
      return preserveStack(function() {
        return Module['_BinaryenLoop'](module, strToStack(label), body);
      });
    };
    this['break'] = function(label, condition, value) {
      return preserveStack(function() {
        return Module['_BinaryenBreak'](module, strToStack(label), condition, value);
      });
    };
    this['switch'] = function(names, defaultName, condition, value) {
      return preserveStack(function() {
        var namei32s = [];
        names.forEach(function(name) {
          namei32s.push_back(strToStack(name));
        });
        return Module['_BinaryenSwitch'](module, i32sToStack(namePtrs), namePtrs.length,
                                         strToStack(defaultName), condition, value);
      });
    };
    this['call'] = function(name, operands, type) {
      return preserveStack(function() {
        return Module['_BinaryenCall'](module, strToStack(name), i32sToStack(operands), operands.length, type);
      });
    };
    this['callImport'] = function(name, operands, type) {
      return preserveStack(function() {
        return Module['_BinaryenCallImport'](module, strToStack(name), i32sToStack(operands), operands.length, type);
      });
    };
    this['callIndirect'] = function(target, operands, type) {
      return preserveStack(function() {
        return Module['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, type);
      });
    };
    this['getLocal'] = function(type) {
      return Module['_BinaryenGetLocal'](module, type);
    };
    this['setLocal'] = function(value) {
      return Module['_Binaryen'](module, value);
    };
    this['teeLocal'] = function(value) {
      return Module['_Binaryen'](module, value);
    };
    this['load'] = function(bytes, signed, offset, align, type, ptr) {
      return Module['_BinaryenLoad'](module, bytes, signed, offset, align, type, ptr);
    };
    this['store'] = function(bytes, offset, align, type, ptr, value) {
      return Module['_BinaryenStore'](module, bytes, offset, align, type, ptr, value);
    };

    // The Const creation API is a little different: we don't want users to
    // need to make their own Literals, as the C API handles them by value,
    // which means we would leak them. Instead, this is the only API that
    // accepts Literals, so fuse it with Literal creation
    var literal = _malloc(16); // a single literal in memory. the LLVM C ABI
                               // makes us pass pointers to this.
    this['constInt32'] = function(x) {
      Module['_BinaryenLiteralInt32'](ptr, x);
      return Module['_BinaryenConst'](module, literal);
    };
    this['constInt64'] = function(l, h) {
      Module['_BinaryenLiteralInt64'](ptr, l, h);
      return Module['_BinaryenConst'](module, literal);
    };
    this['constFloat32'] = function(x) {
      Module['_BinaryenLiteralFloat32'](ptr, x);
      return Module['_BinaryenConst'](module, literal);
    };
    this['constFloat64'] = function(x) {
      Module['_BinaryenLiteralFloat64'](ptr, x);
      return Module['_BinaryenConst'](module, literal);
    };
    this['constFloat32Bits'] = function(x) {
      Module['_BinaryenLiteralFloat32Bits'](ptr, x);
      return Module['_BinaryenConst'](module, literal);
    };
    this['constFloat64Bits'] = function(l, h) {
      Module['_BinaryenLiteralFloat64Bits'](ptr, l, h);
      return Module['_BinaryenConst'](module, literal);
    };

    this['unary'] = function(op, value) {
      return Module['_BinaryenUnary'](module, op, value);
    };
    this['binary'] = function(op, left, right) {
      return Module['_BinaryenBinary'](module, op, left, right);
    };
    this['select'] = function(condition, ifTrue, ifFalse) {
      return Module['_BinaryenSelect'](module, condition, ifTrue, ifFalse);
    };
    this['drop'] = function(value) {
      return Module['_BinaryenDrop'](module, value);
    };
    this['return'] = function(value) {
      return Module['_BinaryenReturn'](module, value);
    };
    this['host'] = function() {
      throw 'TODO';
    };
    this['nop'] = function() {
      return Module['_BinaryenNop'](module);
    };
    this['unreachable'] = function() {
      return Module['_BinaryenUnreachable'](module);
    };
    this['printExpression'] = function(expr) {
      return Module['_BinaryenExpressionPrint'](module, expr);
    };
    this['addFunction'] = function(name, functionType, varTypes, body) {
      return preserveStack(function() {
        return Module['_BinaryenAddFunction'](module, strToStack(name), functionType, i32sToStack(varTypes), varTypes.length, body);
      });
    };
    this['addImport'] = function(internalName, externalModuleName, externalBaseName, type) {
      return preserveStack(function() {
        return Module['_BinaryenAddImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), type);
      });
    };
    this['addExport'] = function(internalName, externalName) {
      return preserveStack(function() {
        return Module['_BinaryenAddExport'](module, strToStack(internalName), strToStack(externalName));
      });
    };
    this['setFunctionTable'] = function(funcs) {
      return preserveStack(function() {
        return Module['_BinaryenSetFunctionTable'](module, i32sToStack(funcs), funcs.length);
      });
    };
    this['setMemory'] = function(initial, maximum, exportName, segments) {
      // segments are assumed to be { offset: expression ref, data: array of 8-bit data }
      return preserveStack(function() {
        return Module['_BinaryenSetMemory'](
          module, initial, maximum, strToStack(exportName),
          i32sToStack(
            segments.map(function(segment) {
              return allocate(segment.data, 'i8', ALLOC_STACK);
            })
          ),
          i32sToStack(
            segments.map(function(segment) {
              return segment.offset;
            })
          ),
          i32sToStack(
            segments.map(function(segment) {
              return segment.data.length;
            })
          ),
          segments.length
        );
      });
    };
    this['setStart'] = function(start) {
      return Module['_BinaryenSetStart'](module, start);
    };
    this['print'] = function() {
      return Module['_BinaryenModulePrint'](module);
    };
    this['validate'] = function() {
      return Module['_BinaryenModuleValidate'](module);
    };
    this['optimize'] = function() {
      return Module['_BinaryenModuleOptimize'](module);
    };
    this['autoDrop'] = function() {
      return Module['_BinaryenModuleAutoDrop'](module);
    };

    // TODO: fix this hard-wired limit
    var MAX = 1024*1024;
    var writeBuffer = null;
    this['writeToBinary'] = function() {
      if (!writeBuffer) writeBuffer = _malloc(MAX);
      var bytes = Module['_BinaryenModuleWrite'](module, writeBuffer, MAX);
      assert(bytes < MAX, 'FIXME: hardcoded limit on module size'); // we should not use the whole buffer
      return new UInt8Array(HEAPU8.subarray(writeBuffer, writeBuffer + bytes));
    };
    this['readFromBinary'] = function(data) {
      var buffer = allocate(data, 'i8', ALLOC_MALLOC);
      var ret = Module['_BinaryenModuleRead'](buffer, data.length);
      _free(buffer);
      return ret;
    };
    this['interpret'] = function() {
      return Module['_BinaryenInterpret'](module);
    };
  };

  Module['Relooper'] = function() {
    var relooper = this.ptr = Module['_RelooperCreate']();

    this['addBlock'] = function(code) {
      return Module['_RelooperAddBlock'](relooper, code);
    };
    this['addBranch'] = function(from, to, condition, code) {
      return Module['_RelooperAddBranch'](from, to, condition, code);
    };
    this['addBlockWithSwitch'] = function(code, condition) {
      return Module['_RelooperAddBlockWithSwitch'](relooper, code, condition);
    };
    this['addBranchForSwitch'] = function(from, to, indexes, code) {
      return preserveStack(function() {
        return Module['_RelooperAddBranchForSwitch'](from, to, i32sToStack(indexes), indexes.length, code);
      });
    };
    this['renderAndDispose'] = function(entry, labelHelper, module) {
      return Module['_RelooperRelooperRenderAndDispose'](relooper, entry, labelHelper, module);
    };
  };

  Module['setAPITracing'] = function(on) {
    return Module['_BinaryenSetAPITracing'](on);
  };

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
)['Binaryen'] = Binaryen();
