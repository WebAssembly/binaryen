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
    if (!str) return 0;
    return allocate(intArrayFromString(str), 'i8', ALLOC_STACK);
  }

  function i32sToStack(i32s) {
    var ret = Runtime.stackAlloc(i32s.length << 2);
    for (var i = 0; i < i32s.length; i++) {
      HEAP32[ret + (i << 2) >> 2] = i32s[i];
    }
    return ret;
  }

  Module['none'] = Module['_BinaryenNone']();
  Module['i32'] = Module['_BinaryenInt32']();
  Module['i64'] = Module['_BinaryenInt64']();
  Module['f32'] = Module['_BinaryenFloat32']();
  Module['f64'] = Module['_BinaryenFloat64']();
  Module['undefined'] = Module['_BinaryenUndefined']();

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
  Module['ExtendUInt32'] = Module['_BinaryenExtendUInt32']();
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
  Module['Module'] = function(module) {
    if (!module) module = Module['_BinaryenModuleCreate']();
    this['ptr'] = module;

    this['dispose'] = function() {
      Module['_BinaryenModuleDispose'](module);
    };
    this['addFunctionType'] = function(name, result, paramTypes) {
      return preserveStack(function() {
        return Module['_BinaryenAddFunctionType'](module, strToStack(name), result,
                                                  i32sToStack(paramTypes), paramTypes.length);
      });
    };
    this['getFunctionTypeBySignature'] = function(result, paramTypes) {
      return preserveStack(function() {
        return Module['_BinaryenGetFunctionTypeBySignature'](module, result,
                                                             i32sToStack(paramTypes), paramTypes.length);
      });
    };

    this['block'] = function(name, children, type) {
      return preserveStack(function() {
        return Module['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                                        i32sToStack(children), children.length,
                                        typeof type !== 'undefined' ? type : Module['undefined']);
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
          namei32s.push(strToStack(name));
        });
        return Module['_BinaryenSwitch'](module, i32sToStack(namei32s), namei32s.length,
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
        return Module['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, strToStack(type));
      });
    };
    this['getLocal'] = function(index, type) {
      return Module['_BinaryenGetLocal'](module, index, type);
    };
    this['setLocal'] = function(index, value) {
      return Module['_BinaryenSetLocal'](module, index, value);
    };
    this['teeLocal'] = function(index, value) {
      return Module['_BinaryenTeeLocal'](module, index, value);
    };
    this['getGlobal'] = function(name, type) {
      return Module['_BinaryenGetGlobal'](module, strToStack(name), type);
    }
    this['setGlobal'] = function(name, value) {
      return Module['_BinaryenSetGlobal'](module, strToStack(name), value);
    }
    this['currentMemory'] = function() {
      return Module['_BinaryenHost'](module, Module['CurrentMemory']);
    }
    this['growMemory'] = function(value) {
      return Module['_BinaryenHost'](module, Module['GrowMemory'], null, i32sToStack([value]), 1);
    }
    this['hasFeature'] = function(name) {
      return Module['_BinaryenHost'](module, Module['HasFeature'], strToStack(name));
    }

    // The Const creation API is a little different: we don't want users to
    // need to make their own Literals, as the C API handles them by value,
    // which means we would leak them. Instead, this is the only API that
    // accepts Literals, so fuse it with Literal creation
    var literal = _malloc(16); // a single literal in memory. the LLVM C ABI
                               // makes us pass pointers to this.

    this['i32'] = {
      'load': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['i32'], ptr);
      },
      'load8_s': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 1, true, offset, align, Module['i32'], ptr);
      },
      'load8_u': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 1, false, offset, align, Module['i32'], ptr);
      },
      'load16_s': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 2, true, offset, align, Module['i32'], ptr);
      },
      'load16_u': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 2, false, offset, align, Module['i32'], ptr);
      },
      'store': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['i32']);
      },
      'store8': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 1, offset, align, ptr, value, Module['i32']);
      },
      'store16': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 2, offset, align, ptr, value, Module['i32']);
      },
      'const': function(x) {
        Module['_BinaryenLiteralInt32'](literal, x);
        return Module['_BinaryenConst'](module, literal);
      },
      'clz': function(value) {
        return Module['_BinaryenUnary'](module, Module['ClzInt32'], value);
      },
      'ctz': function(value) {
        return Module['_BinaryenUnary'](module, Module['CtzInt32'], value);
      },
      'popcnt': function(value) {
        return Module['_BinaryenUnary'](module, Module['PopcntInt32'], value);
      },
      'eqz': function(value) {
        return Module['_BinaryenUnary'](module, Module['EqZInt32'], value);
      },
      'trunc_s': {
        'f32': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncSFloat32ToInt32'], value);
        },
        'f64': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncSFloat64ToInt32'], value);
        },
      },
      'trunc_u': {
        'f32': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncUFloat32ToInt32'], value);
        },
        'f64': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncUFloat64ToInt32'], value);
        },
      },
      'reinterpret': function(value) {
        return Module['_BinaryenUnary'](module, Module['ReinterpretFloat32'], value);
      },
      'wrap': function(value) {
        return Module['_BinaryenUnary'](module, Module['WrapInt64'], value);
      },
      'add': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AddInt32'], left, right);
      },
      'sub': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['SubInt32'], left, right);
      },
      'mul': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MulInt32'], left, right);
      },
      'div_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivSInt32'], left, right);
      },
      'div_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivUInt32'], left, right);
      },
      'rem_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RemSInt32'], left, right);
      },
      'rem_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RemUInt32'], left, right);
      },
      'and': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AndInt32'], left, right);
      },
      'or': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['OrInt32'], left, right);
      },
      'xor': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['XorInt32'], left, right);
      },
      'shl': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShlInt32'], left, right);
      },
      'shr_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShrUInt32'], left, right);
      },
      'shr_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShrSInt32'], left, right);
      },
      'rotl': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RotLInt32'], left, right);
      },
      'rotr': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RotRInt32'], left, right);
      },
      'eq': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['EqInt32'], left, right);
      },
      'ne': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['NeInt32'], left, right);
      },
      'lt_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtSInt32'], left, right);
      },
      'lt_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtUInt32'], left, right);
      },
      'le_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeSInt32'], left, right);
      },
      'le_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeUInt32'], left, right);
      },
      'gt_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtSInt32'], left, right);
      },
      'gt_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtUInt32'], left, right);
      },
      'ge_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeSInt32'], left, right);
      },
      'ge_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeUInt32'], left, right);
      },
    };

    this['i64'] = {
      'load': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['i64'], ptr);
      },
      'load8_s': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 1, true, offset, align, Module['i64'], ptr);
      },
      'load8_u': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 1, false, offset, align, Module['i64'], ptr);
      },
      'load16_s': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 2, true, offset, align, Module['i64'], ptr);
      },
      'load16_u': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 2, false, offset, align, Module['i64'], ptr);
      },
      'load32_s': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['i64'], ptr);
      },
      'load32_u': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 4, false, offset, align, Module['i64'], ptr);
      },
      'store': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['i64']);
      },
      'store8': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 1, offset, align, ptr, value, Module['i64']);
      },
      'store16': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 2, offset, align, ptr, value, Module['i64']);
      },
      'store32': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['i64']);
      },
      'const': function(x, y) {
        Module['_BinaryenLiteralInt64'](literal, x, y);
        return Module['_BinaryenConst'](module, literal);
      },
      'clz': function(value) {
        return Module['_BinaryenUnary'](module, Module['ClzInt64'], value);
      },
      'ctz': function(value) {
        return Module['_BinaryenUnary'](module, Module['CtzInt64'], value);
      },
      'popcnt': function(value) {
        return Module['_BinaryenUnary'](module, Module['PopcntInt64'], value);
      },
      'eqz': function(value) {
        return Module['_BinaryenUnary'](module, Module['EqZInt64'], value);
      },
      'trunc_s': {
        'f32': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncSFloat32ToInt64'], value);
        },
        'f64': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncSFloat64ToInt64'], value);
        },
      },
      'trunc_u': {
        'f32': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncUFloat32ToInt64'], value);
        },
        'f64': function(value) {
          return Module['_BinaryenUnary'](module, Module['TruncUFloat64ToInt64'], value);
        },
      },
      'reinterpret': function(value) {
        return Module['_BinaryenUnary'](module, Module['ReinterpretFloat64'], value);
      },
      'extend_s': function(value) {
        return Module['_BinaryenUnary'](module, Module['ExtendSInt32'], value);
      },
      'extend_u': function(value) {
        return Module['_BinaryenUnary'](module, Module['ExtendUInt32'], value);
      },
      'add': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AddInt64'], left, right);
      },
      'sub': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['SubInt64'], left, right);
      },
      'mul': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MulInt64'], left, right);
      },
      'div_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivSInt64'], left, right);
      },
      'div_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivUInt64'], left, right);
      },
      'rem_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RemSInt64'], left, right);
      },
      'rem_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RemUInt64'], left, right);
      },
      'and': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AndInt64'], left, right);
      },
      'or': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['OrInt64'], left, right);
      },
      'xor': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['XorInt64'], left, right);
      },
      'shl': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShlInt64'], left, right);
      },
      'shr_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShrUInt64'], left, right);
      },
      'shr_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['ShrSInt64'], left, right);
      },
      'rotl': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RotLInt64'], left, right);
      },
      'rotr': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['RotRInt64'], left, right);
      },
      'eq': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['EqInt64'], left, right);
      },
      'ne': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['NeInt64'], left, right);
      },
      'lt_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtSInt64'], left, right);
      },
      'lt_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtUInt64'], left, right);
      },
      'le_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeSInt64'], left, right);
      },
      'le_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeUInt64'], left, right);
      },
      'gt_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtSInt64'], left, right);
      },
      'gt_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtUInt64'], left, right);
      },
      'ge_s': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeSInt64'], left, right);
      },
      'ge_u': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeUInt64'], left, right);
      },
    };

    this['f32'] = {
      'load': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['f32'], ptr);
      },
      'store': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['f32']);
      },
      'const': function(x) {
        Module['_BinaryenLiteralFloat32'](literal, x);
        return Module['_BinaryenConst'](module, literal);
      },
      'const_bits': function(x) {
        Module['_BinaryenLiteralFloat32Bits'](literal, x);
        return Module['_BinaryenConst'](module, literal);
      },
      'neg': function(value) {
        return Module['_BinaryenUnary'](module, Module['NegFloat32'], value);
      },
      'abs': function(value) {
        return Module['_BinaryenUnary'](module, Module['AbsFloat32'], value);
      },
      'ceil': function(value) {
        return Module['_BinaryenUnary'](module, Module['CeilFloat32'], value);
      },
      'floor': function(value) {
        return Module['_BinaryenUnary'](module, Module['FloorFloat32'], value);
      },
      'trunc': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncFloat32'], value);
      },
      'nearest': function(value) {
        return Module['_BinaryenUnary'](module, Module['NearestFloat32'], value);
      },
      'sqrt': function(value) {
        return Module['_BinaryenUnary'](module, Module['SqrtFloat32'], value);
      },
      'reinterpret': function(value) {
        return Module['_BinaryenUnary'](module, Module['ReinterpretInt32'], value);
      },
      'convert_s': {
        'i32': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertSInt32ToFloat32'], value);
        },
        'i64': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertSInt64ToFloat32'], value);
        },
      },
      'convert_u': {
        'i32': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertUInt32ToFloat32'], value);
        },
        'i64': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertUInt64ToFloat32'], value);
        },
      },
      'demote': function(value) {
        return Module['_BinaryenUnary'](module, Module['DemoteFloat64'], value);
      },
      'add': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AddFloat32'], left, right);
      },
      'sub': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['SubFloat32'], left, right);
      },
      'mul': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MulFloat32'], left, right);
      },
      'div': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivFloat32'], left, right);
      },
      'copysign': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['CopySignFloat32'], left, right);
      },
      'min': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MinFloat32'], left, right);
      },
      'max': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MaxFloat32'], left, right);
      },
      'eq': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['EqFloat32'], left, right);
      },
      'ne': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['NeFloat32'], left, right);
      },
      'lt': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtFloat32'], left, right);
      },
      'le': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeFloat32'], left, right);
      },
      'gt': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtFloat32'], left, right);
      },
      'ge': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeFloat32'], left, right);
      },
    };

    this['f64'] = {
      'load': function(offset, align, ptr) {
        return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['f64'], ptr);
      },
      'store': function(offset, align, ptr, value) {
        return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['f64']);
      },
      'const': function(x) {
        Module['_BinaryenLiteralFloat64'](literal, x);
        return Module['_BinaryenConst'](module, literal);
      },
      'const_bits': function(x, y) {
        Module['_BinaryenLiteralFloat64Bits'](literal, x, y);
        return Module['_BinaryenConst'](module, literal);
      },
      'neg': function(value) {
        return Module['_BinaryenUnary'](module, Module['NegFloat64'], value);
      },
      'abs': function(value) {
        return Module['_BinaryenUnary'](module, Module['AbsFloat64'], value);
      },
      'ceil': function(value) {
        return Module['_BinaryenUnary'](module, Module['CeilFloat64'], value);
      },
      'floor': function(value) {
        return Module['_BinaryenUnary'](module, Module['FloorFloat64'], value);
      },
      'trunc': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncFloat64'], value);
      },
      'nearest': function(value) {
        return Module['_BinaryenUnary'](module, Module['NearestFloat64'], value);
      },
      'sqrt': function(value) {
        return Module['_BinaryenUnary'](module, Module['SqrtFloat64'], value);
      },
      'reinterpret': function(value) {
        return Module['_BinaryenUnary'](module, Module['ReinterpretInt64'], value);
      },
      'convert_s': {
        'i32': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertSInt32ToFloat64'], value);
        },
        'i64': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertSInt64ToFloat64'], value);
        },
      },
      'convert_u': {
        'i32': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertUInt32ToFloat64'], value);
        },
        'i64': function(value) {
          return Module['_BinaryenUnary'](module, Module['ConvertUInt64ToFloat64'], value);
        },
      },
      'promote': function(value) {
        return Module['_BinaryenUnary'](module, Module['PromoteFloat32'], value);
      },
      'add': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['AddFloat64'], left, right);
      },
      'sub': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['SubFloat64'], left, right);
      },
      'mul': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MulFloat64'], left, right);
      },
      'div': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['DivFloat64'], left, right);
      },
      'copysign': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['CopySignFloat64'], left, right);
      },
      'min': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MinFloat64'], left, right);
      },
      'max': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['MaxFloat64'], left, right);
      },
      'eq': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['EqFloat64'], left, right);
      },
      'ne': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['NeFloat64'], left, right);
      },
      'lt': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LtFloat64'], left, right);
      },
      'le': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['LeFloat64'], left, right);
      },
      'gt': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GtFloat64'], left, right);
      },
      'ge': function(left, right) {
        return Module['_BinaryenBinary'](module, Module['GeFloat64'], left, right);
      },
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
    this['addFunction'] = function(name, functionType, varTypes, body) {
      return preserveStack(function() {
        return Module['_BinaryenAddFunction'](module, strToStack(name), functionType, i32sToStack(varTypes), varTypes.length, body);
      });
    };
    this['addGlobal'] = function(name, type, mutable, init) {
      return preserveStack(function() {
        return Module['_BinaryenAddGlobal'](module, strToStack(name), type, mutable, init);
      });
    }
    this['addImport'] = function(internalName, externalModuleName, externalBaseName, type) {
      return preserveStack(function() {
        return Module['_BinaryenAddImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), type);
      });
    };
    this['removeImport'] = function(internalName) {
      return preserveStack(function() {
        return Module['_BinaryenRemoveImport'](module, strToStack(internalName));
      });
    };
    this['addExport'] = function(internalName, externalName) {
      return preserveStack(function() {
        return Module['_BinaryenAddExport'](module, strToStack(internalName), strToStack(externalName));
      });
    };
    this['removeExport'] = function(externalName) {
      return preserveStack(function() {
        return Module['_BinaryenRemoveExport'](module, strToStack(externalName));
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
    this['emitText'] = function() {
      var old = Module['print'];
      var ret = '';
      Module['print'] = function(x) { ret += x + '\n' };
      Module['_BinaryenModulePrint'](module);
      Module['print'] = old;
      return ret;
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
    this['emitBinary'] = function() {
      if (!writeBuffer) writeBuffer = _malloc(MAX);
      var bytes = Module['_BinaryenModuleWrite'](module, writeBuffer, MAX);
      assert(bytes < MAX, 'FIXME: hardcoded limit on module size'); // we should not use the whole buffer
      return new Uint8Array(HEAPU8.subarray(writeBuffer, writeBuffer + bytes));
    };
    this['interpret'] = function() {
      return Module['_BinaryenModuleInterpret'](module);
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
      return Module['_RelooperRenderAndDispose'](relooper, entry, labelHelper, module['ptr']);
    };
  };

  // emit text of an expression or a module
  Module['emitText'] = function(expr) {
    if (typeof expr === 'object') {
      return expr.emitText();
    }
    var old = Module['print'];
    var ret = '';
    Module['print'] = function(x) { ret += x + '\n' };
    Module['_BinaryenExpressionPrint'](expr);
    Module['print'] = old;
    return ret;
  };

  Module['readBinary'] = function(data) {
    var buffer = allocate(data, 'i8', ALLOC_NORMAL);
    var ptr = Module['_BinaryenModuleRead'](buffer, data.length);
    _free(buffer);
    return new Module['Module'](ptr);
  };

  Module['parseText'] = function(text) {
    var buffer = _malloc(text.length + 1);
    writeAsciiToMemory(text, buffer);
    var ptr = Module['_BinaryenModuleParse'](buffer);
    _free(buffer);
    return new Module['Module'](ptr);
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
