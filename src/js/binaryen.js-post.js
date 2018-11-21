// export friendly API methods

function preserveStack(func) {
  try {
    var stack = stackSave();
    return func();
  } finally {
    stackRestore(stack);
  }
}

function strToStack(str) {
  if (!str) return 0;
  return allocate(intArrayFromString(str), 'i8', ALLOC_STACK);
}

function i32sToStack(i32s) {
  var ret = stackAlloc(i32s.length << 2);
  for (var i = 0; i < i32s.length; i++) {
    HEAP32[ret + (i << 2) >> 2] = i32s[i];
  }
  return ret;
}

// Types
Module['none'] = Module['_BinaryenTypeNone']();
Module['i32'] = Module['_BinaryenTypeInt32']();
Module['i64'] = Module['_BinaryenTypeInt64']();
Module['f32'] = Module['_BinaryenTypeFloat32']();
Module['f64'] = Module['_BinaryenTypeFloat64']();
Module['unreachable'] = Module['_BinaryenTypeUnreachable']();
Module['auto'] = /* deprecated */ Module['undefined'] = Module['_BinaryenTypeAuto']();

// Expression ids
Module['InvalidId'] = Module['_BinaryenInvalidId']();
Module['BlockId'] = Module['_BinaryenBlockId']();
Module['IfId'] = Module['_BinaryenIfId']();
Module['LoopId'] = Module['_BinaryenLoopId']();
Module['BreakId'] = Module['_BinaryenBreakId']();
Module['SwitchId'] = Module['_BinaryenSwitchId']();
Module['CallId'] = Module['_BinaryenCallId']();
Module['CallIndirectId'] = Module['_BinaryenCallIndirectId']();
Module['GetLocalId'] = Module['_BinaryenGetLocalId']();
Module['SetLocalId'] = Module['_BinaryenSetLocalId']();
Module['GetGlobalId'] = Module['_BinaryenGetGlobalId']();
Module['SetGlobalId'] = Module['_BinaryenSetGlobalId']();
Module['LoadId'] = Module['_BinaryenLoadId']();
Module['StoreId'] = Module['_BinaryenStoreId']();
Module['ConstId'] = Module['_BinaryenConstId']();
Module['UnaryId'] = Module['_BinaryenUnaryId']();
Module['BinaryId'] = Module['_BinaryenBinaryId']();
Module['SelectId'] = Module['_BinaryenSelectId']();
Module['DropId'] = Module['_BinaryenDropId']();
Module['ReturnId'] = Module['_BinaryenReturnId']();
Module['HostId'] = Module['_BinaryenHostId']();
Module['NopId'] = Module['_BinaryenNopId']();
Module['UnreachableId'] = Module['_BinaryenUnreachableId']();
Module['AtomicCmpxchgId'] = Module['_BinaryenAtomicCmpxchgId']();
Module['AtomicRMWId'] = Module['_BinaryenAtomicRMWId']();
Module['AtomicWaitId'] = Module['_BinaryenAtomicWaitId']();
Module['AtomicWakeId'] = Module['_BinaryenAtomicWakeId']();

// External kinds
Module['ExternalFunction'] = Module['_BinaryenExternalFunction']();
Module['ExternalTable'] = Module['_BinaryenExternalTable']();
Module['ExternalMemory'] = Module['_BinaryenExternalMemory']();
Module['ExternalGlobal'] = Module['_BinaryenExternalGlobal']();

// Operations
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
Module['ExtendS8Int32'] = Module['_BinaryenExtendS8Int32']();
Module['ExtendS16Int32'] = Module['_BinaryenExtendS16Int32']();
Module['ExtendS8Int64'] = Module['_BinaryenExtendS8Int64']();
Module['ExtendS16Int64'] = Module['_BinaryenExtendS16Int64']();
Module['ExtendS32Int64'] = Module['_BinaryenExtendS32Int64']();
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
Module['CurrentMemory'] = Module['_BinaryenCurrentMemory']();
Module['GrowMemory'] = Module['_BinaryenGrowMemory']();
Module['AtomicRMWAdd'] = Module['_BinaryenAtomicRMWAdd']();
Module['AtomicRMWSub'] = Module['_BinaryenAtomicRMWSub']();
Module['AtomicRMWAnd'] = Module['_BinaryenAtomicRMWAnd']();
Module['AtomicRMWOr'] = Module['_BinaryenAtomicRMWOr']();
Module['AtomicRMWXor'] = Module['_BinaryenAtomicRMWXor']();
Module['AtomicRMWXchg'] = Module['_BinaryenAtomicRMWXchg']();

// 'Module' interface
Module['Module'] = function(module) {
  assert(!module); // guard against incorrect old API usage
  var module = Module['_BinaryenModuleCreate']();

  wrapModule(module, this);
};

// Receives a C pointer to a C Module and a JS object, and creates
// the JS wrappings on the object to access the C data.
// This is meant for internal use only, and is necessary as we
// want to access Module from JS that were perhaps not created
// from JS.
function wrapModule(module, self) {
  assert(module); // guard against incorrect old API usage
  if (!self) self = {};

  self['ptr'] = module;

  // 'Expression' creation
  self['block'] = function(name, children, type) {
    return preserveStack(function() {
      return Module['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                                      i32sToStack(children), children.length,
                                      typeof type !== 'undefined' ? type : Module['none']);
    });
  };
  self['if'] = function(condition, ifTrue, ifFalse) {
    return Module['_BinaryenIf'](module, condition, ifTrue, ifFalse);
  };
  self['loop'] = function(label, body) {
    return preserveStack(function() {
      return Module['_BinaryenLoop'](module, strToStack(label), body);
    });
  };
  self['break'] = self['br'] = function(label, condition, value) {
    return preserveStack(function() {
      return Module['_BinaryenBreak'](module, strToStack(label), condition, value);
    });
  };
  self['br_if'] = function(label, condition, value) {
    return self['br'](label, condition, value);
  };
  self['switch'] = function(names, defaultName, condition, value) {
    return preserveStack(function() {
      var namei32s = [];
      names.forEach(function(name) {
        namei32s.push(strToStack(name));
      });
      return Module['_BinaryenSwitch'](module, i32sToStack(namei32s), namei32s.length,
                                       strToStack(defaultName), condition, value);
    });
  };
  self['call'] = function(name, operands, type) {
    return preserveStack(function() {
      return Module['_BinaryenCall'](module, strToStack(name), i32sToStack(operands), operands.length, type);
    });
  };
  self['callIndirect'] = self['call_indirect'] = function(target, operands, type) {
    return preserveStack(function() {
      return Module['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, strToStack(type));
    });
  };
  self['getLocal'] = self['get_local'] = function(index, type) {
    return Module['_BinaryenGetLocal'](module, index, type);
  };
  self['setLocal'] = self['set_local'] = self['set_local'] = function(index, value) {
    return Module['_BinaryenSetLocal'](module, index, value);
  };
  self['teeLocal'] = self['tee_local'] = function(index, value) {
    return Module['_BinaryenTeeLocal'](module, index, value);
  };
  self['getGlobal'] = self['get_global'] = function(name, type) {
    return Module['_BinaryenGetGlobal'](module, strToStack(name), type);
  }
  self['setGlobal'] = self['set_global'] = function(name, value) {
    return Module['_BinaryenSetGlobal'](module, strToStack(name), value);
  }
  self['currentMemory'] = self['current_memory'] = function() {
    return Module['_BinaryenHost'](module, Module['CurrentMemory']);
  }
  self['growMemory'] = self['grow_memory'] = function(value) {
    return Module['_BinaryenHost'](module, Module['GrowMemory'], null, i32sToStack([value]), 1);
  }

  // The Const creation API is a little different: we don't want users to
  // need to make their own Literals, as the C API handles them by value,
  // which means we would leak them. Instead, this is the only API that
  // accepts Literals, so fuse it with Literal creation
  var temp = _malloc(16); // a single literal in memory. the LLVM C ABI
                          // makes us pass pointers to this.

  self['i32'] = {
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
      Module['_BinaryenLiteralInt32'](temp, x);
      return Module['_BinaryenConst'](module, temp);
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
    'extend8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS8Int32'], value);
    },
    'extend16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS16Int32'], value);
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
    'atomic':{
      'load': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 4, offset, Module['i32'], ptr);
      },
      'load8_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 1, offset, Module['i32'], ptr);
      },
      'load16_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 2, offset, Module['i32'], ptr);
      },
      'store': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Module['i32']);
      },
      'store8': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Module['i32']);
      },
      'store16': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Module['i32']);
      },
      'rmw': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 4, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 4, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 4, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 4, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 4, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 4, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Module['i32'])
        },
      },
      'rmw8_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 1, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 1, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 1, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 1, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 1, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 1, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Module['i32'])
        },
      },
      'rmw16_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 2, offset, ptr, value, Module['i32']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 2, offset, ptr, value, Module['i32']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 2, offset, ptr, value, Module['i32']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 2, offset, ptr, value, Module['i32']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 2, offset, ptr, value, Module['i32']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 2, offset, ptr, value, Module['i32']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Module['i32'])
        },
      },
    },
    'wait': function(ptr, expected, timeout) {
      return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i32']);
    },
  };

  self['i64'] = {
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
      Module['_BinaryenLiteralInt64'](temp, x, y);
      return Module['_BinaryenConst'](module, temp);
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
    'extend8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS8Int64'], value);
    },
    'extend16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS16Int64'], value);
    },
    'extend32_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ExtendS32Int64'], value);
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
    'atomic':{
      'load': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 8, offset, Module['i64'], ptr);
      },
      'load8_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 1, offset, Module['i64'], ptr);
      },
      'load16_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 2, offset, Module['i64'], ptr);
      },
      'load32_u': function(offset, ptr) {
        return Module['_BinaryenAtomicLoad'](module, 4, offset, Module['i64'], ptr);
      },
      'store': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 8, offset, ptr, value, Module['i64']);
      },
      'store8': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Module['i64']);
      },
      'store16': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Module['i64']);
      },
      'store32': function(offset, ptr, value) {
        return Module['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Module['i64']);
      },
      'rmw': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 8, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 8, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 8, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 8, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 8, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 8, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 8, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw8_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 1, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 1, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 1, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 1, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 1, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 1, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw16_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 2, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 2, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 2, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 2, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 2, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 2, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Module['i64'])
        },
      },
      'rmw32_u': {
        'add': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAdd'], 4, offset, ptr, value, Module['i64']);
        },
        'sub': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWSub'], 4, offset, ptr, value, Module['i64']);
        },
        'and': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWAnd'], 4, offset, ptr, value, Module['i64']);
        },
        'or': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWOr'], 4, offset, ptr, value, Module['i64']);
        },
        'xor': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXor'], 4, offset, ptr, value, Module['i64']);
        },
        'xchg': function(offset, ptr, value) {
          return Module['_BinaryenAtomicRMW'](module, Module['AtomicRMWXchg'], 4, offset, ptr, value, Module['i64']);
        },
        'cmpxchg': function(offset, ptr, expected, replacement) {
          return Module['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Module['i64'])
        },
      },
    },
    'wait': function(ptr, expected, timeout) {
      return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i64']);
    },
  };

  self['f32'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['f32'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['f32']);
    },
    'const': function(x) {
      Module['_BinaryenLiteralFloat32'](temp, x);
      return Module['_BinaryenConst'](module, temp);
    },
    'const_bits': function(x) {
      Module['_BinaryenLiteralFloat32Bits'](temp, x);
      return Module['_BinaryenConst'](module, temp);
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

  self['f64'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['f64'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['f64']);
    },
    'const': function(x) {
      Module['_BinaryenLiteralFloat64'](temp, x);
      return Module['_BinaryenConst'](module, temp);
    },
    'const_bits': function(x, y) {
      Module['_BinaryenLiteralFloat64Bits'](temp, x, y);
      return Module['_BinaryenConst'](module, temp);
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

  self['select'] = function(condition, ifTrue, ifFalse) {
    return Module['_BinaryenSelect'](module, condition, ifTrue, ifFalse);
  };
  self['drop'] = function(value) {
    return Module['_BinaryenDrop'](module, value);
  };
  self['return'] = function(value) {
    return Module['_BinaryenReturn'](module, value);
  };
  self['host'] = function(op, name, operands) {
    if (!operands) operands = [];
    return preserveStack(function() {
      return Module['_BinaryenHost'](module, op, strToStack(name), i32sToStack(operands), operands.length);
    });
  };
  self['nop'] = function() {
    return Module['_BinaryenNop'](module);
  };
  self['unreachable'] = function() {
    return Module['_BinaryenUnreachable'](module);
  };
  self['wake'] = function(ptr, wakeCount) {
    return Module['_BinaryenAtomicWake'](module, ptr, wakeCount);
  };

  // 'Module' operations
  self['addFunctionType'] = function(name, result, paramTypes) {
    if (!paramTypes) paramTypes = [];
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionType'](module, strToStack(name), result,
                                                i32sToStack(paramTypes), paramTypes.length);
    });
  };
  self['getFunctionTypeBySignature'] = function(result, paramTypes) {
    if (!paramTypes) paramTypes = [];
    return preserveStack(function() {
      return Module['_BinaryenGetFunctionTypeBySignature'](module, result,
                                                           i32sToStack(paramTypes), paramTypes.length);
    });
  };
  self['removeFunctionType'] = function(name) {
    return preserveStack(function () {
      return Module['_BinaryenRemoveFunctionType'](module, strToStack(name));
    });
  };
  self['addFunction'] = function(name, functionType, varTypes, body) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunction'](module, strToStack(name), functionType, i32sToStack(varTypes), varTypes.length, body);
    });
  };
  self['getFunction'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetFunction'](module, strToStack(name));
    });
  };
  self['removeFunction'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveFunction'](module, strToStack(name));
    });
  };
  self['addGlobal'] = function(name, type, mutable, init) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobal'](module, strToStack(name), type, mutable, init);
    });
  }
  self['removeGlobal'] = function(name) {
    return preserveStack(function () {
      return Module['_BinaryenRemoveGlobal'](module, strToStack(name));
    });
  }
  self['addFunctionImport'] = function(internalName, externalModuleName, externalBaseName, functionType) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), functionType);
    });
  };
  self['addTableImport'] = function(internalName, externalModuleName, externalBaseName) {
    return preserveStack(function() {
      return Module['_BinaryenAddTableImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName));
    });
  };
  self['addMemoryImport'] = function(internalName, externalModuleName, externalBaseName, shared) {
    return preserveStack(function() {
      return Module['_BinaryenAddMemoryImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), shared);
    });
  };
  self['addGlobalImport'] = function(internalName, externalModuleName, externalBaseName, globalType) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobalImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), globalType);
    });
  };
  self['addExport'] = // deprecated
  self['addFunctionExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addTableExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddTableExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addMemoryExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddMemoryExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['addGlobalExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobalExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['removeExport'] = function(externalName) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveExport'](module, strToStack(externalName));
    });
  };
  self['setFunctionTable'] = function(initial, maximum, funcNames) {
    return preserveStack(function() {
      return Module['_BinaryenSetFunctionTable'](module, initial, maximum,
        i32sToStack(funcNames.map(strToStack)),
        funcNames.length
      );
    });
  };
  self['setMemory'] = function(initial, maximum, exportName, segments, shared) {
    // segments are assumed to be { offset: expression ref, data: array of 8-bit data }
    if (!segments) segments = [];
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
        segments.length,
        shared
      );
    });
  };
  self['setStart'] = function(start) {
    return Module['_BinaryenSetStart'](module, start);
  };
  self['emitText'] = function() {
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    Module['_BinaryenModulePrint'](module);
    out = old;
    return ret;
  };
  self['emitStackIR'] = function(optimize) {
    self['runPasses'](['generate-stack-ir']);
    if (optimize) self['runPasses'](['optimize-stack-ir']);
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    self['runPasses'](['print-stack-ir']);
    out = old;
    return ret;
  };
  self['emitAsmjs'] = function() {
    var old = out;
    var ret = '';
    out = function(x) { ret += x + '\n' };
    Module['_BinaryenModulePrintAsmjs'](module);
    out = old;
    return ret;
  };
  self['validate'] = function() {
    return Module['_BinaryenModuleValidate'](module);
  };
  self['optimize'] = function() {
    return Module['_BinaryenModuleOptimize'](module);
  };
  self['optimizeFunction'] = function(func) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return Module['_BinaryenFunctionOptimize'](func, module);
  };
  self['runPasses'] = function(passes) {
    return preserveStack(function() {
      return Module['_BinaryenModuleRunPasses'](module, i32sToStack(
        passes.map(strToStack)
      ), passes.length);
    });
  };
  self['runPassesOnFunction'] = function(func, passes) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return preserveStack(function() {
      return Module['_BinaryenFunctionRunPasses'](func, module, i32sToStack(
        passes.map(strToStack)
      ), passes.length);
    });
  };
  self['autoDrop'] = function() {
    return Module['_BinaryenModuleAutoDrop'](module);
  };
  self['dispose'] = function() {
    Module['_BinaryenModuleDispose'](module);
  };
  self['emitBinary'] = function(sourceMapUrl) {
    return preserveStack(function() {
      Module['_BinaryenModuleAllocateAndWrite'](temp, module, strToStack(sourceMapUrl));
      var binaryPtr    = HEAPU32[ temp >>> 2     ];
      var binaryBytes  = HEAPU32[(temp >>> 2) + 1];
      var sourceMapPtr = HEAPU32[(temp >>> 2) + 2];
      try {
        var buffer = new Uint8Array(binaryBytes);
        buffer.set(HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
        return typeof sourceMapUrl === 'undefined'
          ? buffer
          : { 'binary': buffer, 'sourceMap': Pointer_stringify(sourceMapPtr) };
      } finally {
        _free(binaryPtr);
        if (sourceMapPtr) _free(sourceMapPtr);
      }
    });
  };
  self['interpret'] = function() {
    return Module['_BinaryenModuleInterpret'](module);
  };
  self['addDebugInfoFileName'] = function(filename) {
    return preserveStack(function() {
      return Module['_BinaryenModuleAddDebugInfoFileName'](module, strToStack(filename));
    });
  };
  self['getDebugInfoFileName'] = function(index) {
    return Pointer_stringify(Module['_BinaryenModuleGetDebugInfoFileName'](module, index));
  };
  self['setDebugLocation'] = function(func, expr, fileIndex, lineNumber, columnNumber) {
    return Module['_BinaryenFunctionSetDebugLocation'](func, expr, fileIndex, lineNumber, columnNumber);
  };

  return self;
}
Module['wrapModule'] = wrapModule;

// 'Relooper' interface
Module['Relooper'] = function(module) {
  assert(module && typeof module === 'object' && module['ptr'] && module['block'] && module['if']); // guard against incorrect old API usage
  var relooper = Module['_RelooperCreate'](module['ptr']);
  this['ptr'] = relooper;

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
  this['renderAndDispose'] = function(entry, labelHelper) {
    return Module['_RelooperRenderAndDispose'](relooper, entry, labelHelper);
  };
};

function getAllNested(ref, numFn, getFn) {
  var num = numFn(ref);
  var ret = new Array(num);
  for (var i = 0; i < num; ++i) ret[i] = getFn(ref, i);
  return ret;
}

// Gets the specific id of an 'Expression'
Module['getExpressionId'] = function(expr) {
  return Module['_BinaryenExpressionGetId'](expr);
};

// Gets the result type of an 'Expression'
Module['getExpressionType'] = function(expr) {
  return Module['_BinaryenExpressionGetType'](expr);
};

// Obtains information about an 'Expression'
Module['getExpressionInfo'] = function(expr) {
  var id = Module['_BinaryenExpressionGetId'](expr);
  var type = Module['_BinaryenExpressionGetType'](expr);
  switch (id) {
    case Module['BlockId']:
      return {
        'id': id,
        'type': type,
        'name': Pointer_stringify(Module['_BinaryenBlockGetName'](expr)),
        'children': getAllNested(expr, Module['_BinaryenBlockGetNumChildren'], Module['_BinaryenBlockGetChild'])
      };
    case Module['IfId']:
      return {
        'id': id,
        'type': type,
        'condition': Module['_BinaryenIfGetCondition'](expr),
        'ifTrue': Module['_BinaryenIfGetIfTrue'](expr),
        'ifFalse': Module['_BinaryenIfGetIfFalse'](expr)
      };
    case Module['LoopId']:
      return {
        'id': id,
        'type': type,
        'name': Pointer_stringify(Module['_BinaryenLoopGetName'](expr)),
        'body': Module['_BinaryenLoopGetBody'](expr)
      };
    case Module['BreakId']:
      return {
        'id': id,
        'type': type,
        'name': Pointer_stringify(Module['_BinaryenBreakGetName'](expr)),
        'condition': Module['_BinaryenBreakGetCondition'](expr),
        'value': Module['_BinaryenBreakGetValue'](expr)
      };
    case Module['SwitchId']:
      return {
        'id': id,
        'type': type,
        'names': getAllNested(expr, Module['_BinaryenSwitchGetNumNames'], Module['_BinaryenSwitchGetName']).map(Pointer_stringify),
        'defaultName': Pointer_stringify(Module['_BinaryenSwitchGetDefaultName'](expr)),
        'condition': Module['_BinaryenSwitchGetCondition'](expr),
        'value': Module['_BinaryenSwitchGetValue'](expr)
      };
    case Module['CallId']:
      return {
        'id': id,
        'type': type,
        'target': Pointer_stringify(Module['_BinaryenCallGetTarget'](expr)),
        'operands': getAllNested(expr, Module[ '_BinaryenCallGetNumOperands'], Module['_BinaryenCallGetOperand'])
      };
    case Module['CallIndirectId']:
      return {
        'id': id,
        'type': type,
        'target': Module['_BinaryenCallIndirectGetTarget'](expr),
        'operands': getAllNested(expr, Module['_BinaryenCallIndirectGetNumOperands'], Module['_BinaryenCallIndirectGetOperand'])
      };
    case Module['GetLocalId']:
      return {
        'id': id,
        'type': type,
        'index': Module['_BinaryenGetLocalGetIndex'](expr)
      };
    case Module['SetLocalId']:
      return {
        'id': id,
        'type': type,
        'isTee': Boolean(Module['_BinaryenSetLocalIsTee'](expr)),
        'index': Module['_BinaryenSetLocalGetIndex'](expr),
        'value': Module['_BinaryenSetLocalGetValue'](expr)
      };
    case Module['GetGlobalId']:
      return {
        'id': id,
        'type': type,
        'name': Pointer_stringify(Module['_BinaryenGetGlobalGetName'](expr))
      };
    case Module['SetGlobalId']:
      return {
        'id': id,
        'type': type,
        'name': Pointer_stringify(Module['_BinaryenSetGlobalGetName'](expr)),
        'value': Module['_BinaryenSetGlobalGetValue'](expr)
      };
    case Module['LoadId']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(Module['_BinaryenLoadIsAtomic'](expr)),
        'isSigned': Boolean(Module['_BinaryenLoadIsSigned'](expr)),
        'offset': Module['_BinaryenLoadGetOffset'](expr),
        'bytes': Module['_BinaryenLoadGetBytes'](expr),
        'align': Module['_BinaryenLoadGetAlign'](expr),
        'ptr': Module['_BinaryenLoadGetPtr'](expr)
      };
    case Module['StoreId']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(Module['_BinaryenStoreIsAtomic'](expr)),
        'offset': Module['_BinaryenStoreGetOffset'](expr),
        'bytes': Module['_BinaryenStoreGetBytes'](expr),
        'align': Module['_BinaryenStoreGetAlign'](expr),
        'ptr': Module['_BinaryenStoreGetPtr'](expr),
        'value': Module['_BinaryenStoreGetValue'](expr)
      };
    case Module['ConstId']: {
      var value;
      switch (type) {
        case Module['i32']: value = Module['_BinaryenConstGetValueI32'](expr); break;
        case Module['i64']: value = { 'low': Module['_BinaryenConstGetValueI64Low'](expr), 'high': Module['_BinaryenConstGetValueI64High'](expr) }; break;
        case Module['f32']: value = Module['_BinaryenConstGetValueF32'](expr); break;
        case Module['f64']: value =  Module['_BinaryenConstGetValueF64'](expr); break;
        default: throw Error('unexpected type: ' + type);
      }
      return {
        'id': id,
        'type': type,
        'value': value
      };
    }
    case Module['UnaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenUnaryGetOp'](expr),
        'value': Module['_BinaryenUnaryGetValue'](expr)
      };
    case Module['BinaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenBinaryGetOp'](expr),
        'left': Module['_BinaryenBinaryGetLeft'](expr),
        'right':  Module['_BinaryenBinaryGetRight'](expr)
      };
    case Module['SelectId']:
      return {
        'id': id,
        'type': type,
        'ifTrue': Module['_BinaryenSelectGetIfTrue'](expr),
        'ifFalse': Module['_BinaryenSelectGetIfFalse'](expr),
        'condition': Module['_BinaryenSelectGetCondition'](expr)
      };
    case Module['DropId']:
      return {
        'id': id,
        'type': type,
        'value': Module['_BinaryenDropGetValue'](expr)
      };
    case Module['ReturnId']:
      return {
        'id': id,
        'type': type,
        'value': Module['_BinaryenReturnGetValue'](expr)
      };
    case Module['NopId']:
    case Module['UnreachableId']:
      return {
        'id': id,
        'type': type
      };
    case Module['HostId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenHostGetOp'](expr),
        'nameOperand': Pointer_stringify(Module['_BinaryenHostGetNameOperand'](expr)),
        'operands': getAllNested(expr, Module['_BinaryenHostGetNumOperands'], Module['_BinaryenHostGetOperand'])
      };
    case Module['AtomicRMWId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenAtomicRMWGetOp'](expr),
        'bytes': Module['_BinaryenAtomicRMWGetBytes'](expr),
        'offset': Module['_BinaryenAtomicRMWGetOffset'](expr),
        'ptr': Module['_BinaryenAtomicRMWGetPtr'](expr),
        'value': Module['_BinaryenAtomicRMWGetValue'](expr)
      };
    case Module['AtomicCmpxchgId']:
      return {
        'id': id,
        'type': type,
        'bytes': Module['_BinaryenAtomicCmpxchgGetBytes'](expr),
        'offset': Module['_BinaryenAtomicCmpxchgGetOffset'](expr),
        'ptr': Module['_BinaryenAtomicCmpxchgGetPtr'](expr),
        'expected': Module['_BinaryenAtomicCmpxchgGetExpected'](expr),
        'replacement': Module['_BinaryenAtomicCmpxchgGetReplacement'](expr)
      };
    case Module['AtomicWaitId']:
      return {
        'id': id,
        'type': type,
        'ptr': Module['_BinaryenAtomicWaitGetPtr'](expr),
        'expected': Module['_BinaryenAtomicWaitGetExpected'](expr),
        'timeout': Module['_BinaryenAtomicWaitGetTimeout'](expr),
        'expectedType': Module['_BinaryenAtomicWaitGetExpectedType'](expr)
      };
    case Module['AtomicWakeId']:
      return {
        'id': id,
        'type': type,
        'ptr': Module['_BinaryenAtomicWakeGetPtr'](expr),
        'wakeCount': Module['_BinaryenAtomicWakeGetWakeCount'](expr)
      };
    default:
      throw Error('unexpected id: ' + id);
  }
};

// Obtains information about a 'FunctionType'
Module['getFunctionTypeInfo'] = function(func) {
  return {
    'name': Pointer_stringify(Module['_BinaryenFunctionTypeGetName'](func)),
    'params': getAllNested(func, Module['_BinaryenFunctionTypeGetNumParams'], Module['_BinaryenFunctionTypeGetParam']),
    'result': Module['_BinaryenFunctionTypeGetResult'](func)
  };
};

// Obtains information about a 'Function'
Module['getFunctionInfo'] = function(func) {
  return {
    'name': Pointer_stringify(Module['_BinaryenFunctionGetName'](func)),
    'module': Pointer_stringify(Module['_BinaryenFunctionImportGetModule'](func)),
    'base': Pointer_stringify(Module['_BinaryenFunctionImportGetBase'](func)),
    'type': Pointer_stringify(Module['_BinaryenFunctionGetType'](func)),
    'params': getAllNested(func, Module['_BinaryenFunctionGetNumParams'], Module['_BinaryenFunctionGetParam']),
    'result': Module['_BinaryenFunctionGetResult'](func),
    'vars': getAllNested(func, Module['_BinaryenFunctionGetNumVars'], Module['_BinaryenFunctionGetVar']),
    'body': Module['_BinaryenFunctionGetBody'](func)
  };
};

// Obtains information about a 'Global'
Module['getGlobalInfo'] = function(func) {
  return {
    'name': Pointer_stringify(Module['_BinaryenGlobalGetName'](func)),
    'module': Pointer_stringify(Module['_BinaryenGlobalImportGetModule'](func)),
    'base': Pointer_stringify(Module['_BinaryenGlobalImportGetBase'](func)),
    'type': Pointer_stringify(Module['_BinaryenGlobalGetType'](func))
  };
};

// Obtains information about an 'Export'
Module['getExportInfo'] = function(export_) {
  return {
    'kind': Module['_BinaryenExportGetKind'](export_),
    'name': Pointer_stringify(Module['_BinaryenExportGetName'](export_)),
    'value': Pointer_stringify(Module['_BinaryenExportGetValue'](export_))
  };
};

// Emits text format of an expression or a module
Module['emitText'] = function(expr) {
  if (typeof expr === 'object') {
    return expr.emitText();
  }
  var old = out;
  var ret = '';
  out = function(x) { ret += x + '\n' };
  Module['_BinaryenExpressionPrint'](expr);
  out = old;
  return ret;
};

// Parses a binary to a module
Module['readBinary'] = function(data) {
  var buffer = allocate(data, 'i8', ALLOC_NORMAL);
  var ptr = Module['_BinaryenModuleRead'](buffer, data.length);
  _free(buffer);
  return wrapModule(ptr);
};

// Parses text format to a module
Module['parseText'] = function(text) {
  var buffer = _malloc(text.length + 1);
  writeAsciiToMemory(text, buffer);
  var ptr = Module['_BinaryenModuleParse'](buffer);
  _free(buffer);
  return wrapModule(ptr);
};

// Gets the currently set optimize level. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
Module['getOptimizeLevel'] = function() {
  return Module['_BinaryenGetOptimizeLevel']();
};

// Sets the optimization level to use. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
Module['setOptimizeLevel'] = function(level) {
  return Module['_BinaryenSetOptimizeLevel'](level);
};

// Gets the currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['getShrinkLevel'] = function() {
  return Module['_BinaryenGetShrinkLevel']();
};

// Sets the shrink level to use. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['setShrinkLevel'] = function(level) {
  return Module['_BinaryenSetShrinkLevel'](level);
};

// Gets whether generating debug information is currently enabled or not.
Module['getDebugInfo'] = function() {
  return Boolean(Module['_BinaryenGetDebugInfo']());
};

// Enables or disables debug information in emitted binaries.
Module['setDebugInfo'] = function(on) {
  return Module['_BinaryenSetDebugInfo'](on);
};

// Enables or disables C-API tracing
Module['setAPITracing'] = function(on) {
  return Module['_BinaryenSetAPITracing'](on);
};

// Additional customizations

Module['exit'] = function(status) {
  // Instead of exiting silently on errors, always show an error with
  // a stack trace, for debuggability.
  if (status != 0) throw new Error('exiting due to error: ' + status);
};

