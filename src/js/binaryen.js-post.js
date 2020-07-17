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

function i8sToStack(i8s) {
  var ret = stackAlloc(i8s.length);
  for (var i = 0; i < i8s.length; i++) {
    HEAP8[ret + i] = i8s[i];
  }
  return ret;
}

function initializeConstants() {

  // Types
  [ ['none', 'None'],
    ['i32', 'Int32'],
    ['i64', 'Int64'],
    ['f32', 'Float32'],
    ['f64', 'Float64'],
    ['v128', 'Vec128'],
    ['funcref', 'Funcref'],
    ['externref', 'Externref'],
    ['nullref', 'Nullref'],
    ['exnref', 'Exnref'],
    ['unreachable', 'Unreachable'],
    ['auto', 'Auto']
  ].forEach(function(entry) {
    Module[entry[0]] = Module['_BinaryenType' + entry[1]]();
  });

  // Expression ids
  Module['ExpressionIds'] = {};
  [ 'Invalid',
    'Block',
    'If',
    'Loop',
    'Break',
    'Switch',
    'Call',
    'CallIndirect',
    'LocalGet',
    'LocalSet',
    'GlobalGet',
    'GlobalSet',
    'Load',
    'Store',
    'Const',
    'Unary',
    'Binary',
    'Select',
    'Drop',
    'Return',
    'Host',
    'Nop',
    'Unreachable',
    'AtomicCmpxchg',
    'AtomicRMW',
    'AtomicWait',
    'AtomicNotify',
    'AtomicFence',
    'SIMDExtract',
    'SIMDReplace',
    'SIMDShuffle',
    'SIMDTernary',
    'SIMDShift',
    'SIMDLoad',
    'MemoryInit',
    'DataDrop',
    'MemoryCopy',
    'MemoryFill',
    'RefNull',
    'RefIsNull',
    'RefFunc',
    'Try',
    'Throw',
    'Rethrow',
    'BrOnExn',
    'TupleMake',
    'TupleExtract',
    'Pop'
  ].forEach(function(name) {
    Module['ExpressionIds'][name] = Module[name + 'Id'] = Module['_Binaryen' + name + 'Id']();
  });

  // External kinds
  Module['ExternalKinds'] = {};
  [ 'Function',
    'Table',
    'Memory',
    'Global',
    'Event'
  ].forEach(function(name) {
    Module['ExternalKinds'][name] = Module['External' + name] = Module['_BinaryenExternal' + name]();
  });

  // Features
  Module['Features'] = {};
  [ 'MVP',
    'Atomics',
    'BulkMemory',
    'MutableGlobals',
    'NontrappingFPToInt',
    'SignExt',
    'SIMD128',
    'ExceptionHandling',
    'TailCall',
    'ReferenceTypes',
    'Multivalue',
    'All'
  ].forEach(function(name) {
    Module['Features'][name] = Module['_BinaryenFeature' + name]();
  });

  // Operations
  Module['Operations'] = {};
  [ 'ClzInt32',
    'CtzInt32',
    'PopcntInt32',
    'NegFloat32',
    'AbsFloat32',
    'CeilFloat32',
    'FloorFloat32',
    'TruncFloat32',
    'NearestFloat32',
    'SqrtFloat32',
    'EqZInt32',
    'ClzInt64',
    'CtzInt64',
    'PopcntInt64',
    'NegFloat64',
    'AbsFloat64',
    'CeilFloat64',
    'FloorFloat64',
    'TruncFloat64',
    'NearestFloat64',
    'SqrtFloat64',
    'EqZInt64',
    'ExtendSInt32',
    'ExtendUInt32',
    'WrapInt64',
    'TruncSFloat32ToInt32',
    'TruncSFloat32ToInt64',
    'TruncUFloat32ToInt32',
    'TruncUFloat32ToInt64',
    'TruncSFloat64ToInt32',
    'TruncSFloat64ToInt64',
    'TruncUFloat64ToInt32',
    'TruncUFloat64ToInt64',
    'TruncSatSFloat32ToInt32',
    'TruncSatSFloat32ToInt64',
    'TruncSatUFloat32ToInt32',
    'TruncSatUFloat32ToInt64',
    'TruncSatSFloat64ToInt32',
    'TruncSatSFloat64ToInt64',
    'TruncSatUFloat64ToInt32',
    'TruncSatUFloat64ToInt64',
    'ReinterpretFloat32',
    'ReinterpretFloat64',
    'ConvertSInt32ToFloat32',
    'ConvertSInt32ToFloat64',
    'ConvertUInt32ToFloat32',
    'ConvertUInt32ToFloat64',
    'ConvertSInt64ToFloat32',
    'ConvertSInt64ToFloat64',
    'ConvertUInt64ToFloat32',
    'ConvertUInt64ToFloat64',
    'PromoteFloat32',
    'DemoteFloat64',
    'ReinterpretInt32',
    'ReinterpretInt64',
    'ExtendS8Int32',
    'ExtendS16Int32',
    'ExtendS8Int64',
    'ExtendS16Int64',
    'ExtendS32Int64',
    'AddInt32',
    'SubInt32',
    'MulInt32',
    'DivSInt32',
    'DivUInt32',
    'RemSInt32',
    'RemUInt32',
    'AndInt32',
    'OrInt32',
    'XorInt32',
    'ShlInt32',
    'ShrUInt32',
    'ShrSInt32',
    'RotLInt32',
    'RotRInt32',
    'EqInt32',
    'NeInt32',
    'LtSInt32',
    'LtUInt32',
    'LeSInt32',
    'LeUInt32',
    'GtSInt32',
    'GtUInt32',
    'GeSInt32',
    'GeUInt32',
    'AddInt64',
    'SubInt64',
    'MulInt64',
    'DivSInt64',
    'DivUInt64',
    'RemSInt64',
    'RemUInt64',
    'AndInt64',
    'OrInt64',
    'XorInt64',
    'ShlInt64',
    'ShrUInt64',
    'ShrSInt64',
    'RotLInt64',
    'RotRInt64',
    'EqInt64',
    'NeInt64',
    'LtSInt64',
    'LtUInt64',
    'LeSInt64',
    'LeUInt64',
    'GtSInt64',
    'GtUInt64',
    'GeSInt64',
    'GeUInt64',
    'AddFloat32',
    'SubFloat32',
    'MulFloat32',
    'DivFloat32',
    'CopySignFloat32',
    'MinFloat32',
    'MaxFloat32',
    'EqFloat32',
    'NeFloat32',
    'LtFloat32',
    'LeFloat32',
    'GtFloat32',
    'GeFloat32',
    'AddFloat64',
    'SubFloat64',
    'MulFloat64',
    'DivFloat64',
    'CopySignFloat64',
    'MinFloat64',
    'MaxFloat64',
    'EqFloat64',
    'NeFloat64',
    'LtFloat64',
    'LeFloat64',
    'GtFloat64',
    'GeFloat64',
    'MemorySize',
    'MemoryGrow',
    'AtomicRMWAdd',
    'AtomicRMWSub',
    'AtomicRMWAnd',
    'AtomicRMWOr',
    'AtomicRMWXor',
    'AtomicRMWXchg',
    'SplatVecI8x16',
    'ExtractLaneSVecI8x16',
    'ExtractLaneUVecI8x16',
    'ReplaceLaneVecI8x16',
    'SplatVecI16x8',
    'ExtractLaneSVecI16x8',
    'ExtractLaneUVecI16x8',
    'ReplaceLaneVecI16x8',
    'SplatVecI32x4',
    'ExtractLaneVecI32x4',
    'ReplaceLaneVecI32x4',
    'SplatVecI64x2',
    'ExtractLaneVecI64x2',
    'ReplaceLaneVecI64x2',
    'SplatVecF32x4',
    'ExtractLaneVecF32x4',
    'ReplaceLaneVecF32x4',
    'SplatVecF64x2',
    'ExtractLaneVecF64x2',
    'ReplaceLaneVecF64x2',
    'EqVecI8x16',
    'NeVecI8x16',
    'LtSVecI8x16',
    'LtUVecI8x16',
    'GtSVecI8x16',
    'GtUVecI8x16',
    'LeSVecI8x16',
    'LeUVecI8x16',
    'GeSVecI8x16',
    'GeUVecI8x16',
    'EqVecI16x8',
    'NeVecI16x8',
    'LtSVecI16x8',
    'LtUVecI16x8',
    'GtSVecI16x8',
    'GtUVecI16x8',
    'LeSVecI16x8',
    'LeUVecI16x8',
    'GeSVecI16x8',
    'GeUVecI16x8',
    'EqVecI32x4',
    'NeVecI32x4',
    'LtSVecI32x4',
    'LtUVecI32x4',
    'GtSVecI32x4',
    'GtUVecI32x4',
    'LeSVecI32x4',
    'LeUVecI32x4',
    'GeSVecI32x4',
    'GeUVecI32x4',
    'EqVecF32x4',
    'NeVecF32x4',
    'LtVecF32x4',
    'GtVecF32x4',
    'LeVecF32x4',
    'GeVecF32x4',
    'EqVecF64x2',
    'NeVecF64x2',
    'LtVecF64x2',
    'GtVecF64x2',
    'LeVecF64x2',
    'GeVecF64x2',
    'NotVec128',
    'AndVec128',
    'OrVec128',
    'XorVec128',
    'AndNotVec128',
    'BitselectVec128',
    'AbsVecI8x16',
    'NegVecI8x16',
    'AnyTrueVecI8x16',
    'AllTrueVecI8x16',
    'BitmaskVecI8x16',
    'ShlVecI8x16',
    'ShrSVecI8x16',
    'ShrUVecI8x16',
    'AddVecI8x16',
    'AddSatSVecI8x16',
    'AddSatUVecI8x16',
    'SubVecI8x16',
    'SubSatSVecI8x16',
    'SubSatUVecI8x16',
    'MulVecI8x16',
    'MinSVecI8x16',
    'MinUVecI8x16',
    'MaxSVecI8x16',
    'MaxUVecI8x16',
    'AvgrUVecI8x16',
    'AbsVecI16x8',
    'NegVecI16x8',
    'AnyTrueVecI16x8',
    'AllTrueVecI16x8',
    'BitmaskVecI16x8',
    'ShlVecI16x8',
    'ShrSVecI16x8',
    'ShrUVecI16x8',
    'AddVecI16x8',
    'AddSatSVecI16x8',
    'AddSatUVecI16x8',
    'SubVecI16x8',
    'SubSatSVecI16x8',
    'SubSatUVecI16x8',
    'MulVecI16x8',
    'MinSVecI16x8',
    'MinUVecI16x8',
    'MaxSVecI16x8',
    'MaxUVecI16x8',
    'AvgrUVecI16x8',
    'DotSVecI16x8ToVecI32x4',
    'AbsVecI32x4',
    'NegVecI32x4',
    'AnyTrueVecI32x4',
    'AllTrueVecI32x4',
    'BitmaskVecI32x4',
    'ShlVecI32x4',
    'ShrSVecI32x4',
    'ShrUVecI32x4',
    'AddVecI32x4',
    'SubVecI32x4',
    'MulVecI32x4',
    'MinSVecI32x4',
    'MinUVecI32x4',
    'MaxSVecI32x4',
    'MaxUVecI32x4',
    'NegVecI64x2',
    'AnyTrueVecI64x2',
    'AllTrueVecI64x2',
    'ShlVecI64x2',
    'ShrSVecI64x2',
    'ShrUVecI64x2',
    'AddVecI64x2',
    'SubVecI64x2',
    'MulVecI64x2',
    'AbsVecF32x4',
    'NegVecF32x4',
    'SqrtVecF32x4',
    'QFMAVecF32x4',
    'QFMSVecF32x4',
    'AddVecF32x4',
    'SubVecF32x4',
    'MulVecF32x4',
    'DivVecF32x4',
    'MinVecF32x4',
    'MaxVecF32x4',
    'PMinVecF32x4',
    'PMaxVecF32x4',
    'CeilVecF32x4',
    'FloorVecF32x4',
    'TruncVecF32x4',
    'NearestVecF32x4',
    'AbsVecF64x2',
    'NegVecF64x2',
    'SqrtVecF64x2',
    'QFMAVecF64x2',
    'QFMSVecF64x2',
    'AddVecF64x2',
    'SubVecF64x2',
    'MulVecF64x2',
    'DivVecF64x2',
    'MinVecF64x2',
    'MaxVecF64x2',
    'PMinVecF64x2',
    'PMaxVecF64x2',
    'CeilVecF64x2',
    'FloorVecF64x2',
    'TruncVecF64x2',
    'NearestVecF64x2',
    'TruncSatSVecF32x4ToVecI32x4',
    'TruncSatUVecF32x4ToVecI32x4',
    'TruncSatSVecF64x2ToVecI64x2',
    'TruncSatUVecF64x2ToVecI64x2',
    'ConvertSVecI32x4ToVecF32x4',
    'ConvertUVecI32x4ToVecF32x4',
    'ConvertSVecI64x2ToVecF64x2',
    'ConvertUVecI64x2ToVecF64x2',
    'LoadSplatVec8x16',
    'LoadSplatVec16x8',
    'LoadSplatVec32x4',
    'LoadSplatVec64x2',
    'LoadExtSVec8x8ToVecI16x8',
    'LoadExtUVec8x8ToVecI16x8',
    'LoadExtSVec16x4ToVecI32x4',
    'LoadExtUVec16x4ToVecI32x4',
    'LoadExtSVec32x2ToVecI64x2',
    'LoadExtUVec32x2ToVecI64x2',
    'NarrowSVecI16x8ToVecI8x16',
    'NarrowUVecI16x8ToVecI8x16',
    'NarrowSVecI32x4ToVecI16x8',
    'NarrowUVecI32x4ToVecI16x8',
    'WidenLowSVecI8x16ToVecI16x8',
    'WidenHighSVecI8x16ToVecI16x8',
    'WidenLowUVecI8x16ToVecI16x8',
    'WidenHighUVecI8x16ToVecI16x8',
    'WidenLowSVecI16x8ToVecI32x4',
    'WidenHighSVecI16x8ToVecI32x4',
    'WidenLowUVecI16x8ToVecI32x4',
    'WidenHighUVecI16x8ToVecI32x4',
    'SwizzleVec8x16',
  ].forEach(function(name) {
    Module['Operations'][name] = Module[name] = Module['_Binaryen' + name]();
  });

  // Expression side effects
  Module['SideEffects'] = {};
  [ 'None',
    'Branches',
    'Calls',
    'ReadsLocal',
    'WritesLocal',
    'ReadsGlobal',
    'WritesGlobal',
    'ReadsMemory',
    'WritesMemory',
    'ImplicitTrap',
    'IsAtomic',
    'Throws',
    'DanglingPop',
    'Any'
  ].forEach(function(name) {
    Module['SideEffects'][name] = Module['_BinaryenSideEffect' + name]();
  });

  // ExpressionRunner flags
  Module['ExpressionRunner']['Flags'] = {
    'Default': Module['_ExpressionRunnerFlagsDefault'](),
    'PreserveSideeffects': Module['_ExpressionRunnerFlagsPreserveSideeffects'](),
    'TraverseCalls': Module['_ExpressionRunnerFlagsTraverseCalls']()
  };
}

// 'Module' interface
Module['Module'] = function(module) {
  assert(!module); // guard against incorrect old API usage
  wrapModule(Module['_BinaryenModuleCreate'](), this);
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

  // The size of a single literal in memory as used in Const creation,
  // which is a little different: we don't want users to need to make
  // their own Literals, as the C API handles them by value, which means
  // we would leak them. Instead, Const creation is fused together with
  // an intermediate stack allocation of this size to pass the value.
  var sizeOfLiteral = _BinaryenSizeofLiteral();

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
  // 'callIndirect', 'returnCall', 'returnCallIndirect' are deprecated and may
  // be removed in a future release. Please use the the snake_case names
  // instead.
  self['callIndirect'] = self['call_indirect'] = function(target, operands, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results);
    });
  };
  self['returnCall'] = self['return_call'] = function(name, operands, type) {
    return preserveStack(function() {
      return Module['_BinaryenReturnCall'](module, strToStack(name), i32sToStack(operands), operands.length, type);
    });
  };
  self['returnCallIndirect'] = self['return_call_indirect'] = function(target, operands, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenReturnCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results);
    });
  };

  self['local'] = {
    'get': function(index, type) {
      return Module['_BinaryenLocalGet'](module, index, type);
    },
    'set': function(index, value) {
      return Module['_BinaryenLocalSet'](module, index, value);
    },
    'tee': function(index, value, type) {
      if (typeof type === 'undefined') {
        throw new Error("local.tee's type should be defined");
      }
      return Module['_BinaryenLocalTee'](module, index, value, type);
    }
  }

  self['global'] = {
    'get': function(name, type) {
      return Module['_BinaryenGlobalGet'](module, strToStack(name), type);
    },
    'set': function(name, value) {
      return Module['_BinaryenGlobalSet'](module, strToStack(name), value);
    }
  }

  self['memory'] = {
    'size': function() {
      return Module['_BinaryenHost'](module, Module['MemorySize']);
    },
    'grow': function(value) {
      return Module['_BinaryenHost'](module, Module['MemoryGrow'], null, i32sToStack([value]), 1);
    },
    'init': function(segment, dest, offset, size) {
      return Module['_BinaryenMemoryInit'](module, segment, dest, offset, size);
    },
    'copy': function(dest, source, size) {
      return Module['_BinaryenMemoryCopy'](module, dest, source, size);
    },
    'fill': function(dest, value, size) {
      return Module['_BinaryenMemoryFill'](module, dest, value, size);
    }
  }

  self['data'] = {
    'drop': function(segment) {
      return Module['_BinaryenDataDrop'](module, segment);
    }
  }

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
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralInt32'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
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
    'trunc_s_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat64ToInt32'], value);
      },
    },
    'trunc_u_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat32ToInt32'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat64ToInt32'], value);
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
    'atomic': {
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
      'wait': function(ptr, expected, timeout) {
        return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i32']);
      }
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['i32']);
    }
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
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralInt64'](tempLiteral, x, y);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
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
    'trunc_s_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatSFloat64ToInt64'], value);
      },
    },
    'trunc_u_sat': {
      'f32': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat32ToInt64'], value);
      },
      'f64': function(value) {
        return Module['_BinaryenUnary'](module, Module['TruncSatUFloat64ToInt64'], value);
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
    'atomic': {
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
      'wait': function(ptr, expected, timeout) {
        return Module['_BinaryenAtomicWait'](module, ptr, expected, timeout, Module['i64']);
      }
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['i64']);
    }
  };

  self['f32'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 4, true, offset, align, Module['f32'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 4, offset, align, ptr, value, Module['f32']);
    },
    'const': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat32'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat32Bits'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
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
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['f32']);
    }
  };

  self['f64'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 8, true, offset, align, Module['f64'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 8, offset, align, ptr, value, Module['f64']);
    },
    'const': function(x) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat64'](tempLiteral, x);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits': function(x, y) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralFloat64Bits'](tempLiteral, x, y);
        return Module['_BinaryenConst'](module, tempLiteral);
      });
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
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['f64']);
    }
  };

  self['v128'] = {
    'load': function(offset, align, ptr) {
      return Module['_BinaryenLoad'](module, 16, false, offset, align, Module['v128'], ptr);
    },
    'store': function(offset, align, ptr, value) {
      return Module['_BinaryenStore'](module, 16, offset, align, ptr, value, Module['v128']);
    },
    'const': function(i8s) {
      return preserveStack(function() {
        var tempLiteral = stackAlloc(sizeOfLiteral);
        Module['_BinaryenLiteralVec128'](tempLiteral, i8sToStack(i8s));
        return Module['_BinaryenConst'](module, tempLiteral);
      });
    },
    'not': function(value) {
      return Module['_BinaryenUnary'](module, Module['NotVec128'], value);
    },
    'and': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndVec128'], left, right);
    },
    'or': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['OrVec128'], left, right);
    },
    'xor': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['XorVec128'], left, right);
    },
    'andnot': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AndNotVec128'], left, right);
    },
    'bitselect': function(left, right, cond) {
      return Module['_BinaryenSIMDTernary'](module, Module['BitselectVec128'], left, right, cond);
    },
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['v128']);
    }
  };

  self['i8x16'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI8x16'], value);
    },
    'extract_lane_s': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneSVecI8x16'], vec, index);
    },
    'extract_lane_u': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneUVecI8x16'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI8x16'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI8x16'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI8x16'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI8x16'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI8x16'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI8x16'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI8x16'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI8x16'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI8x16'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI8x16'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI8x16'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecI8x16'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI8x16'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI8x16'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI8x16'], value);
    },
    'bitmask': function(value) {
      return Module['_BinaryenUnary'](module, Module['BitmaskVecI8x16'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI8x16'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI8x16'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI8x16'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI8x16'], left, right);
    },
    'add_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatSVecI8x16'], left, right);
    },
    'add_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatUVecI8x16'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI8x16'], left, right);
    },
    'sub_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatSVecI8x16'], left, right);
    },
    'sub_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatUVecI8x16'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI8x16'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI8x16'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI8x16'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI8x16'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI8x16'], left, right);
    },
    'avgr_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AvgrUVecI8x16'], left, right);
    },
    'narrow_i16x8_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowSVecI16x8ToVecI8x16'], left, right);
    },
    'narrow_i16x8_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowUVecI16x8ToVecI8x16'], left, right);
    },
  };

  self['i16x8'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI16x8'], value);
    },
    'extract_lane_s': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneSVecI16x8'], vec, index);
    },
    'extract_lane_u': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneUVecI16x8'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI16x8'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI16x8'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI16x8'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI16x8'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI16x8'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI16x8'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI16x8'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI16x8'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI16x8'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI16x8'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI16x8'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecI16x8'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI16x8'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI16x8'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI16x8'], value);
    },
    'bitmask': function(value) {
      return Module['_BinaryenUnary'](module, Module['BitmaskVecI16x8'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI16x8'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI16x8'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI16x8'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI16x8'], left, right);
    },
    'add_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatSVecI16x8'], left, right);
    },
    'add_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddSatUVecI16x8'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI16x8'], left, right);
    },
    'sub_saturate_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatSVecI16x8'], left, right);
    },
    'sub_saturate_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubSatUVecI16x8'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI16x8'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI16x8'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI16x8'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI16x8'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI16x8'], left, right);
    },
    'avgr_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AvgrUVecI16x8'], left, right);
    },
    'narrow_i32x4_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowSVecI32x4ToVecI16x8'], left, right);
    },
    'narrow_i32x4_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NarrowUVecI32x4ToVecI16x8'], left, right);
    },
    'widen_low_i8x16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowSVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighSVecI8x16ToVecI16x8'], value);
    },
    'widen_low_i8x16_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowUVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighUVecI8x16ToVecI16x8'], value);
    },
    'load8x8_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec8x8ToVecI16x8'], offset, align, ptr);
    },
    'load8x8_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec8x8ToVecI16x8'], offset, align, ptr);
    },
  };

  self['i32x4'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI32x4'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecI32x4'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI32x4'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecI32x4'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecI32x4'], left, right);
    },
    'lt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtSVecI32x4'], left, right);
    },
    'lt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtUVecI32x4'], left, right);
    },
    'gt_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtSVecI32x4'], left, right);
    },
    'gt_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtUVecI32x4'], left, right);
    },
    'le_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeSVecI32x4'], left, right);
    },
    'le_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeUVecI32x4'], left, right);
    },
    'ge_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeSVecI32x4'], left, right);
    },
    'ge_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeUVecI32x4'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecI32x4'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI32x4'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI32x4'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI32x4'], value);
    },
    'bitmask': function(value) {
      return Module['_BinaryenUnary'](module, Module['BitmaskVecI32x4'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI32x4'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI32x4'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI32x4'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI32x4'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI32x4'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI32x4'], left, right);
    },
    'min_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinSVecI32x4'], left, right);
    },
    'min_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinUVecI32x4'], left, right);
    },
    'max_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxSVecI32x4'], left, right);
    },
    'max_u': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxUVecI32x4'], left, right);
    },
    'dot_i16x8_s': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DotSVecI16x8ToVecI32x4'], left, right);
    },
    'trunc_sat_f32x4_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatSVecF32x4ToVecI32x4'], value);
    },
    'trunc_sat_f32x4_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatUVecF32x4ToVecI32x4'], value);
    },
    'widen_low_i16x8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowSVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighSVecI16x8ToVecI32x4'], value);
    },
    'widen_low_i16x8_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenLowUVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['WidenHighUVecI16x8ToVecI32x4'], value);
    },
    'load16x4_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec16x4ToVecI32x4'], offset, align, ptr);
    },
    'load16x4_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec16x4ToVecI32x4'], offset, align, ptr);
    },
  };

  self['i64x2'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecI64x2'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecI64x2'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecI64x2'], vec, index, value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecI64x2'], value);
    },
    'any_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AnyTrueVecI64x2'], value);
    },
    'all_true': function(value) {
      return Module['_BinaryenUnary'](module, Module['AllTrueVecI64x2'], value);
    },
    'shl': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShlVecI64x2'], vec, shift);
    },
    'shr_s': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrSVecI64x2'], vec, shift);
    },
    'shr_u': function(vec, shift) {
      return Module['_BinaryenSIMDShift'](module, Module['ShrUVecI64x2'], vec, shift);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecI64x2'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecI64x2'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecI64x2'], left, right);
    },
    'trunc_sat_f64x2_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatSVecF64x2ToVecI64x2'], value);
    },
    'trunc_sat_f64x2_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncSatUVecF64x2ToVecI64x2'], value);
    },
    'load32x2_s': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtSVec32x2ToVecI64x2'], offset, align, ptr);
    },
    'load32x2_u': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadExtUVec32x2ToVecI64x2'], offset, align, ptr);
    },
  };

  self['f32x4'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecF32x4'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecF32x4'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecF32x4'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecF32x4'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecF32x4'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtVecF32x4'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtVecF32x4'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeVecF32x4'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeVecF32x4'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecF32x4'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecF32x4'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtVecF32x4'], value);
    },
    'qfma': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMAVecF32x4'], a, b, c);
    },
    'qfms': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMSVecF32x4'], a, b, c);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecF32x4'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecF32x4'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecF32x4'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivVecF32x4'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinVecF32x4'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxVecF32x4'], left, right);
    },
    'pmin': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['PMinVecF32x4'], left, right);
    },
    'pmax': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['PMaxVecF32x4'], left, right);
    },
    'ceil': function(value) {
      return Module['_BinaryenUnary'](module, Module['CeilVecF32x4'], value);
    },
    'floor': function(value) {
      return Module['_BinaryenUnary'](module, Module['FloorVecF32x4'], value);
    },
    'trunc': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncVecF32x4'], value);
    },
    'nearest': function(value) {
      return Module['_BinaryenUnary'](module, Module['NearestVecF32x4'], value);
    },
    'convert_i32x4_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertSVecI32x4ToVecF32x4'], value);
    },
    'convert_i32x4_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertUVecI32x4ToVecF32x4'], value);
    },
  };

  self['f64x2'] = {
    'splat': function(value) {
      return Module['_BinaryenUnary'](module, Module['SplatVecF64x2'], value);
    },
    'extract_lane': function(vec, index) {
      return Module['_BinaryenSIMDExtract'](module, Module['ExtractLaneVecF64x2'], vec, index);
    },
    'replace_lane': function(vec, index, value) {
      return Module['_BinaryenSIMDReplace'](module, Module['ReplaceLaneVecF64x2'], vec, index, value);
    },
    'eq': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['EqVecF64x2'], left, right);
    },
    'ne': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['NeVecF64x2'], left, right);
    },
    'lt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LtVecF64x2'], left, right);
    },
    'gt': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GtVecF64x2'], left, right);
    },
    'le': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['LeVecF64x2'], left, right);
    },
    'ge': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['GeVecF64x2'], left, right);
    },
    'abs': function(value) {
      return Module['_BinaryenUnary'](module, Module['AbsVecF64x2'], value);
    },
    'neg': function(value) {
      return Module['_BinaryenUnary'](module, Module['NegVecF64x2'], value);
    },
    'sqrt': function(value) {
      return Module['_BinaryenUnary'](module, Module['SqrtVecF64x2'], value);
    },
    'qfma': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMAVecF64x2'], a, b, c);
    },
    'qfms': function(a, b, c) {
      return Module['_BinaryenSIMDTernary'](module, Module['QFMSVecF64x2'], a, b, c);
    },
    'add': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['AddVecF64x2'], left, right);
    },
    'sub': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SubVecF64x2'], left, right);
    },
    'mul': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MulVecF64x2'], left, right);
    },
    'div': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['DivVecF64x2'], left, right);
    },
    'min': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MinVecF64x2'], left, right);
    },
    'max': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['MaxVecF64x2'], left, right);
    },
    'pmin': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['PMinVecF64x2'], left, right);
    },
    'pmax': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['PMaxVecF64x2'], left, right);
    },
    'ceil': function(value) {
      return Module['_BinaryenUnary'](module, Module['CeilVecF64x2'], value);
    },
    'floor': function(value) {
      return Module['_BinaryenUnary'](module, Module['FloorVecF64x2'], value);
    },
    'trunc': function(value) {
      return Module['_BinaryenUnary'](module, Module['TruncVecF64x2'], value);
    },
    'nearest': function(value) {
      return Module['_BinaryenUnary'](module, Module['NearestVecF64x2'], value);
    },
    'convert_i64x2_s': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertSVecI64x2ToVecF64x2'], value);
    },
    'convert_i64x2_u': function(value) {
      return Module['_BinaryenUnary'](module, Module['ConvertUVecI64x2ToVecF64x2'], value);
    },
  };

  self['v8x16'] = {
    'shuffle': function(left, right, mask) {
      return preserveStack(function() {
        return Module['_BinaryenSIMDShuffle'](module, left, right, i8sToStack(mask));
      });
    },
    'swizzle': function(left, right) {
      return Module['_BinaryenBinary'](module, Module['SwizzleVec8x16'], left, right);
    },
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec8x16'], offset, align, ptr);
    },
  };

  self['v16x8'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec16x8'], offset, align, ptr);
    },
  };

  self['v32x4'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec32x4'], offset, align, ptr);
    },
  };

  self['v64x2'] = {
    'load_splat': function(offset, align, ptr) {
      return Module['_BinaryenSIMDLoad'](module, Module['LoadSplatVec64x2'], offset, align, ptr);
    },
  };

  self['funcref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['funcref']);
    }
  };

  self['externref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['externref']);
    }
  };

  self['nullref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['nullref']);
    }
  };

  self['exnref'] = {
    'pop': function() {
      return Module['_BinaryenPop'](module, Module['exnref']);
    }
  };

  self['ref'] = {
    'null': function() {
      return Module['_BinaryenRefNull'](module);
    },
    'is_null': function(value) {
      return Module['_BinaryenRefIsNull'](module, value);
    },
    'func': function(func) {
      return preserveStack(function() {
        return Module['_BinaryenRefFunc'](module, strToStack(func));
      });
    }
  };

  self['select'] = function(condition, ifTrue, ifFalse, type) {
    return Module['_BinaryenSelect'](
      module, condition, ifTrue, ifFalse, typeof type !== 'undefined' ? type : Module['auto']);
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

  self['atomic'] = {
    'notify': function(ptr, notifyCount) {
      return Module['_BinaryenAtomicNotify'](module, ptr, notifyCount);
    },
    'fence': function() {
      return Module['_BinaryenAtomicFence'](module);
    }
  };

  self['try'] = function(body, catchBody) {
    return Module['_BinaryenTry'](module, body, catchBody);
  };
  self['throw'] = function(event_, operands) {
    return preserveStack(function() {
      return Module['_BinaryenThrow'](module, strToStack(event_), i32sToStack(operands), operands.length);
    });
  };
  self['rethrow'] = function(exnref) {
    return Module['_BinaryenRethrow'](module, exnref);
  };
  self['br_on_exn'] = function(label, event_, exnref) {
    return preserveStack(function() {
      return Module['_BinaryenBrOnExn'](module, strToStack(label), strToStack(event_), exnref);
    });
  };

  self['tuple'] = {
    'make': function(elements) {
      return preserveStack(function() {
        return Module['_BinaryenTupleMake'](module, i32sToStack(elements), elements.length);
      });
    },
    'extract': function(tuple, index) {
      return Module['_BinaryenTupleExtract'](module, tuple, index);
    }
  };

  // 'Module' operations
  self['addFunction'] = function(name, params, results, varTypes, body) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunction'](module, strToStack(name), params, results, i32sToStack(varTypes), varTypes.length, body);
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
  self['getGlobal'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetGlobal'](module, strToStack(name));
    });
  };
  self['removeGlobal'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveGlobal'](module, strToStack(name));
    });
  }
  self['addEvent'] = function(name, attribute, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddEvent'](module, strToStack(name), attribute, params, results);
    });
  };
  self['getEvent'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenGetEvent'](module, strToStack(name));
    });
  };
  self['removeEvent'] = function(name) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveEvent'](module, strToStack(name));
    });
  };
  self['addFunctionImport'] = function(internalName, externalModuleName, externalBaseName, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddFunctionImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), params, results);
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
  self['addGlobalImport'] = function(internalName, externalModuleName, externalBaseName, globalType, mutable) {
    return preserveStack(function() {
      return Module['_BinaryenAddGlobalImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), globalType, mutable);
    });
  };
  self['addEventImport'] = function(internalName, externalModuleName, externalBaseName, attribute, params, results) {
    return preserveStack(function() {
      return Module['_BinaryenAddEventImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), attribute, params, results);
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
  self['addEventExport'] = function(internalName, externalName) {
    return preserveStack(function() {
      return Module['_BinaryenAddEventExport'](module, strToStack(internalName), strToStack(externalName));
    });
  };
  self['removeExport'] = function(externalName) {
    return preserveStack(function() {
      return Module['_BinaryenRemoveExport'](module, strToStack(externalName));
    });
  };
  self['setFunctionTable'] = function(initial, maximum, funcNames, offset) {
    return preserveStack(function() {
      return Module['_BinaryenSetFunctionTable'](module, initial, maximum,
        i32sToStack(funcNames.map(strToStack)),
        funcNames.length,
        offset || self['i32']['const'](0)
      );
    });
  };
  self['getFunctionTable'] = function() {
    return {
      'imported': Boolean(Module['_BinaryenIsFunctionTableImported'](module)),
      'segments': (function() {
        var arr = [];
        for (var i = 0, numSegments = Module['_BinaryenGetNumFunctionTableSegments'](module); i !== numSegments; ++i) {
          var seg = {'offset': Module['_BinaryenGetFunctionTableSegmentOffset'](module, i), 'names': []};
          for (var j = 0, segmentLength = Module['_BinaryenGetFunctionTableSegmentLength'](module, i); j !== segmentLength; ++j) {
            var ptr = Module['_BinaryenGetFunctionTableSegmentData'](module, i, j);
            seg['names'].push(UTF8ToString(ptr));
          }
          arr.push(seg);
        }
        return arr;
      })()
    };
  };
  self['setMemory'] = function(initial, maximum, exportName, segments, shared) {
    // segments are assumed to be { passive: bool, offset: expression ref, data: array of 8-bit data }
    if (!segments) segments = [];
    return preserveStack(function() {
      return Module['_BinaryenSetMemory'](
        module, initial, maximum, strToStack(exportName),
        i32sToStack(
          segments.map(function(segment) {
            return allocate(segment.data, 'i8', ALLOC_STACK);
          })
        ),
        i8sToStack(
          segments.map(function(segment) {
            return segment.passive;
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
  self['getNumMemorySegments'] = function() {
    return Module['_BinaryenGetNumMemorySegments'](module);
  }
  self['getMemorySegmentInfoByIndex'] = function(id) {
    return {
      'offset': Module['_BinaryenGetMemorySegmentByteOffset'](module, id),
      'data': (function(){
        var size = Module['_BinaryenGetMemorySegmentByteLength'](module, id);
        var ptr = _malloc(size);
        Module['_BinaryenCopyMemorySegmentData'](module, id, ptr);
        var res = new Uint8Array(size);
        res.set(new Uint8Array(buffer, ptr, size));
        _free(ptr);
        return res.buffer;
      })(),
      'passive': Boolean(Module['_BinaryenGetMemorySegmentPassive'](module, id))
    };
  }
  self['setStart'] = function(start) {
    return Module['_BinaryenSetStart'](module, start);
  };
  self['getFeatures'] = function() {
    return Module['_BinaryenModuleGetFeatures'](module);
  };
  self['setFeatures'] = function(features) {
    Module['_BinaryenModuleSetFeatures'](module, features);
  };
  self['addCustomSection'] = function(name, contents) {
    return preserveStack(function() {
      return Module['_BinaryenAddCustomSection'](module, strToStack(name), i8sToStack(contents), contents.length);
    });
  };
  self['getNumExports'] = function() {
    return Module['_BinaryenGetNumExports'](module);
  }
  self['getExportByIndex'] = function(id) {
    return Module['_BinaryenGetExportByIndex'](module, id);
  }
  self['getNumFunctions'] = function() {
    return Module['_BinaryenGetNumFunctions'](module);
  }
  self['getFunctionByIndex'] = function(id) {
    return Module['_BinaryenGetFunctionByIndex'](module, id);
  }
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
      var tempBuffer = stackAlloc(_BinaryenSizeofAllocateAndWriteResult());
      Module['_BinaryenModuleAllocateAndWrite'](tempBuffer, module, strToStack(sourceMapUrl));
      var binaryPtr    = HEAPU32[ tempBuffer >>> 2     ];
      var binaryBytes  = HEAPU32[(tempBuffer >>> 2) + 1];
      var sourceMapPtr = HEAPU32[(tempBuffer >>> 2) + 2];
      try {
        var buffer = new Uint8Array(binaryBytes);
        buffer.set(HEAPU8.subarray(binaryPtr, binaryPtr + binaryBytes));
        return typeof sourceMapUrl === 'undefined'
          ? buffer
          : { 'binary': buffer, 'sourceMap': UTF8ToString(sourceMapPtr) };
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
    return UTF8ToString(Module['_BinaryenModuleGetDebugInfoFileName'](module, index));
  };
  self['setDebugLocation'] = function(func, expr, fileIndex, lineNumber, columnNumber) {
    return Module['_BinaryenFunctionSetDebugLocation'](func, expr, fileIndex, lineNumber, columnNumber);
  };
  self['copyExpression'] = function(expr) {
    return Module['_BinaryenExpressionCopy'](expr, module);
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

// 'ExpressionRunner' interface
Module['ExpressionRunner'] = function(module, flags, maxDepth, maxLoopIterations) {
  var runner = Module['_ExpressionRunnerCreate'](module['ptr'], flags, maxDepth, maxLoopIterations);
  this['ptr'] = runner;

  this['setLocalValue'] = function(index, valueExpr) {
    return Boolean(Module['_ExpressionRunnerSetLocalValue'](runner, index, valueExpr));
  };
  this['setGlobalValue'] = function(name, valueExpr) {
    return preserveStack(function() {
      return Boolean(Module['_ExpressionRunnerSetGlobalValue'](runner, strToStack(name), valueExpr));
    });
  };
  this['runAndDispose'] = function(expr) {
    return Module['_ExpressionRunnerRunAndDispose'](runner, expr);
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
        'name': UTF8ToString(Module['_BinaryenBlockGetName'](expr)),
        'children': getAllNested(expr, Module['_BinaryenBlockGetNumChildren'], Module['_BinaryenBlockGetChildAt'])
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
        'name': UTF8ToString(Module['_BinaryenLoopGetName'](expr)),
        'body': Module['_BinaryenLoopGetBody'](expr)
      };
    case Module['BreakId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenBreakGetName'](expr)),
        'condition': Module['_BinaryenBreakGetCondition'](expr),
        'value': Module['_BinaryenBreakGetValue'](expr)
      };
    case Module['SwitchId']:
      return {
        'id': id,
        'type': type,
        'names': getAllNested(expr, Module['_BinaryenSwitchGetNumNames'], Module['_BinaryenSwitchGetNameAt']).map(function (p) {
          // Do not pass the index as the second parameter to UTF8ToString as that will cut off the string.
          return UTF8ToString(p);
        }),
        'defaultName': UTF8ToString(Module['_BinaryenSwitchGetDefaultName'](expr)),
        'condition': Module['_BinaryenSwitchGetCondition'](expr),
        'value': Module['_BinaryenSwitchGetValue'](expr)
      };
    case Module['CallId']:
      return {
        'id': id,
        'type': type,
        'isReturn': Boolean(Module['_BinaryenCallIsReturn'](expr)),
        'target': UTF8ToString(Module['_BinaryenCallGetTarget'](expr)),
        'operands': getAllNested(expr, Module[ '_BinaryenCallGetNumOperands'], Module['_BinaryenCallGetOperandAt'])
      };
    case Module['CallIndirectId']:
      return {
        'id': id,
        'type': type,
        'isReturn': Boolean(Module['_BinaryenCallIndirectIsReturn'](expr)),
        'target': Module['_BinaryenCallIndirectGetTarget'](expr),
        'operands': getAllNested(expr, Module['_BinaryenCallIndirectGetNumOperands'], Module['_BinaryenCallIndirectGetOperandAt'])
      };
    case Module['LocalGetId']:
      return {
        'id': id,
        'type': type,
        'index': Module['_BinaryenLocalGetGetIndex'](expr)
      };
    case Module['LocalSetId']:
      return {
        'id': id,
        'type': type,
        'isTee': Boolean(Module['_BinaryenLocalSetIsTee'](expr)),
        'index': Module['_BinaryenLocalSetGetIndex'](expr),
        'value': Module['_BinaryenLocalSetGetValue'](expr)
      };
    case Module['GlobalGetId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenGlobalGetGetName'](expr))
      };
    case Module['GlobalSetId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenGlobalSetGetName'](expr)),
        'value': Module['_BinaryenGlobalSetGetValue'](expr)
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
        case Module['f64']: value = Module['_BinaryenConstGetValueF64'](expr); break;
        case Module['v128']: {
          preserveStack(function() {
            var tempBuffer = stackAlloc(16);
            Module['_BinaryenConstGetValueV128'](expr, tempBuffer);
            value = new Array(16);
            for (var i = 0; i < 16; i++) {
              value[i] = HEAPU8[tempBuffer + i];
            }
          });
          break;
        }
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
    case Module['PopId']:
      return {
        'id': id,
        'type': type
      };
    case Module['HostId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenHostGetOp'](expr),
        'nameOperand': UTF8ToString(Module['_BinaryenHostGetNameOperand'](expr)),
        'operands': getAllNested(expr, Module['_BinaryenHostGetNumOperands'], Module['_BinaryenHostGetOperandAt'])
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
    case Module['AtomicNotifyId']:
      return {
        'id': id,
        'type': type,
        'ptr': Module['_BinaryenAtomicNotifyGetPtr'](expr),
        'notifyCount': Module['_BinaryenAtomicNotifyGetNotifyCount'](expr)
      };
    case Module['AtomicFenceId']:
      return {
        'id': id,
        'type': type,
        'order': Module['_BinaryenAtomicFenceGetOrder'](expr)
      };
    case Module['SIMDExtractId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDExtractGetOp'](expr),
        'vec': Module['_BinaryenSIMDExtractGetVec'](expr),
        'index': Module['_BinaryenSIMDExtractGetIndex'](expr)
      };
    case Module['SIMDReplaceId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDReplaceGetOp'](expr),
        'vec': Module['_BinaryenSIMDReplaceGetVec'](expr),
        'index': Module['_BinaryenSIMDReplaceGetIndex'](expr),
        'value': Module['_BinaryenSIMDReplaceGetValue'](expr)
      };
    case Module['SIMDShuffleId']:
      return preserveStack(function() {
        var tempBuffer = stackAlloc(16);
        Module['_BinaryenSIMDShuffleGetMask'](expr, tempBuffer);
        var mask = new Array(16);
        for (var i = 0; i < 16; i++) {
          mask[i] = HEAPU8[tempBuffer + i];
        }
        return {
          'id': id,
          'type': type,
          'left': Module['_BinaryenSIMDShuffleGetLeft'](expr),
          'right': Module['_BinaryenSIMDShuffleGetRight'](expr),
          'mask': mask
        };
      });
    case Module['SIMDTernaryId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDTernaryGetOp'](expr),
        'a': Module['_BinaryenSIMDTernaryGetA'](expr),
        'b': Module['_BinaryenSIMDTernaryGetB'](expr),
        'c': Module['_BinaryenSIMDTernaryGetC'](expr)
      };
    case Module['SIMDShiftId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDShiftGetOp'](expr),
        'vec': Module['_BinaryenSIMDShiftGetVec'](expr),
        'shift': Module['_BinaryenSIMDShiftGetShift'](expr)
      };
    case Module['SIMDLoadId']:
      return {
        'id': id,
        'type': type,
        'op': Module['_BinaryenSIMDLoadGetOp'](expr),
        'offset': Module['_BinaryenSIMDLoadGetOffset'](expr),
        'align': Module['_BinaryenSIMDLoadGetAlign'](expr),
        'ptr': Module['_BinaryenSIMDLoadGetPtr'](expr)
      };
    case Module['MemoryInitId']:
      return {
        'id': id,
        'segment': Module['_BinaryenMemoryInitGetSegment'](expr),
        'dest': Module['_BinaryenMemoryInitGetDest'](expr),
        'offset': Module['_BinaryenMemoryInitGetOffset'](expr),
        'size': Module['_BinaryenMemoryInitGetSize'](expr)
      };
    case Module['DataDropId']:
      return {
        'id': id,
        'segment': Module['_BinaryenDataDropGetSegment'](expr),
      };
    case Module['MemoryCopyId']:
      return {
        'id': id,
        'dest': Module['_BinaryenMemoryCopyGetDest'](expr),
        'source': Module['_BinaryenMemoryCopyGetSource'](expr),
        'size': Module['_BinaryenMemoryCopyGetSize'](expr)
      };
    case Module['MemoryFillId']:
      return {
        'id': id,
        'dest': Module['_BinaryenMemoryFillGetDest'](expr),
        'value': Module['_BinaryenMemoryFillGetValue'](expr),
        'size': Module['_BinaryenMemoryFillGetSize'](expr)
      };
    case Module['RefNullId']:
      return {
        'id': id,
        'type': type
      };
    case Module['RefIsNullId']:
      return {
        'id': id,
        'type': type,
        'value': Module['_BinaryenRefIsNullGetValue'](expr)
      };
    case Module['RefFuncId']:
      return {
        'id': id,
        'type': type,
        'func': UTF8ToString(Module['_BinaryenRefFuncGetFunc'](expr)),
      };
    case Module['TryId']:
      return {
        'id': id,
        'type': type,
        'body': Module['_BinaryenTryGetBody'](expr),
        'catchBody': Module['_BinaryenTryGetCatchBody'](expr)
      };
    case Module['ThrowId']:
      return {
        'id': id,
        'type': type,
        'event': UTF8ToString(Module['_BinaryenThrowGetEvent'](expr)),
        'operands': getAllNested(expr, Module['_BinaryenThrowGetNumOperands'], Module['_BinaryenThrowGetOperandAt'])
      };
    case Module['RethrowId']:
      return {
        'id': id,
        'type': type,
        'exnref': Module['_BinaryenRethrowGetExnref'](expr)
      };
    case Module['BrOnExnId']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(Module['_BinaryenBrOnExnGetName'](expr)),
        'event': UTF8ToString(Module['_BinaryenBrOnExnGetEvent'](expr)),
        'exnref': Module['_BinaryenBrOnExnGetExnref'](expr)
      };
    case Module['TupleMakeId']:
      return {
        'id': id,
        'type': type,
        'operands': getAllNested(expr, Module['_BinaryenTupleMakeGetNumOperands'], Module['_BinaryenTupleMakeGetOperandAt'])
      };
    case Module['TupleExtractId']:
      return {
        'id': id,
        'type': type,
        'tuple': Module['_BinaryenTupleExtractGetTuple'](expr),
        'index': Module['_BinaryenTupleExtractGetIndex'](expr)
      };

    default:
      throw Error('unexpected id: ' + id);
  }
};

// Gets the side effects of the specified expression
Module['getSideEffects'] = function(expr, features) {
  return Module['_BinaryenExpressionGetSideEffects'](expr, features);
};

Module['createType'] = function(types) {
  return preserveStack(function() {
    var array = i32sToStack(types);
    return Module['_BinaryenTypeCreate'](array, types.length);
  });
};

Module['expandType'] = function(ty) {
  return preserveStack(function() {
    var numTypes = Module['_BinaryenTypeArity'](ty);
    var array = stackAlloc(numTypes << 2);
    Module['_BinaryenTypeExpand'](ty, array);
    var types = [];
    for (var i = 0; i < numTypes; i++) {
      types.push(HEAPU32[(array >>> 2) + i]);
    }
    return types;
  });
};

// Obtains information about a 'Function'
Module['getFunctionInfo'] = function(func) {
  return {
    'name': UTF8ToString(Module['_BinaryenFunctionGetName'](func)),
    'module': UTF8ToString(Module['_BinaryenFunctionImportGetModule'](func)),
    'base': UTF8ToString(Module['_BinaryenFunctionImportGetBase'](func)),
    'params': Module['_BinaryenFunctionGetParams'](func),
    'results': Module['_BinaryenFunctionGetResults'](func),
    'vars': getAllNested(func, Module['_BinaryenFunctionGetNumVars'], Module['_BinaryenFunctionGetVar']),
    'body': Module['_BinaryenFunctionGetBody'](func)
  };
};

// Obtains information about a 'Global'
Module['getGlobalInfo'] = function(global) {
  return {
    'name': UTF8ToString(Module['_BinaryenGlobalGetName'](global)),
    'module': UTF8ToString(Module['_BinaryenGlobalImportGetModule'](global)),
    'base': UTF8ToString(Module['_BinaryenGlobalImportGetBase'](global)),
    'type': Module['_BinaryenGlobalGetType'](global),
    'mutable': Boolean(Module['_BinaryenGlobalIsMutable'](global)),
    'init': Module['_BinaryenGlobalGetInitExpr'](global)
  };
};

// Obtains information about a 'Event'
Module['getEventInfo'] = function(event_) {
  return {
    'name': UTF8ToString(Module['_BinaryenEventGetName'](event_)),
    'module': UTF8ToString(Module['_BinaryenEventImportGetModule'](event_)),
    'base': UTF8ToString(Module['_BinaryenEventImportGetBase'](event_)),
    'attribute': Module['_BinaryenEventGetAttribute'](event_),
    'params': Module['_BinaryenEventGetParams'](event_),
    'results': Module['_BinaryenEventGetResults'](event_)
  };
};

// Obtains information about an 'Export'
Module['getExportInfo'] = function(export_) {
  return {
    'kind': Module['_BinaryenExportGetKind'](export_),
    'name': UTF8ToString(Module['_BinaryenExportGetName'](export_)),
    'value': UTF8ToString(Module['_BinaryenExportGetValue'](export_))
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

// If building with Emscripten ASSERTIONS, there is a property added to
// Module to guard against users mistakening using the removed readBinary()
// API. We must defuse that carefully.
Object.defineProperty(Module, 'readBinary', { writable: true });

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
  Module['_BinaryenSetOptimizeLevel'](level);
};

// Gets the currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['getShrinkLevel'] = function() {
  return Module['_BinaryenGetShrinkLevel']();
};

// Sets the shrink level to use. 0, 1, 2 correspond to -O0, -Os, -Oz.
Module['setShrinkLevel'] = function(level) {
  Module['_BinaryenSetShrinkLevel'](level);
};

// Gets whether generating debug information is currently enabled or not.
Module['getDebugInfo'] = function() {
  return Boolean(Module['_BinaryenGetDebugInfo']());
};

// Enables or disables debug information in emitted binaries.
Module['setDebugInfo'] = function(on) {
  Module['_BinaryenSetDebugInfo'](on);
};

// Gets whether the low 1K of memory can be considered unused when optimizing.
Module['getLowMemoryUnused'] = function() {
  return Boolean(Module['_BinaryenGetLowMemoryUnused']());
};

// Enables or disables whether the low 1K of memory can be considered unused
// when optimizing.
Module['setLowMemoryUnused'] = function(on) {
  Module['_BinaryenSetLowMemoryUnused'](on);
};

// Gets the value of the specified arbitrary pass argument.
Module['getPassArgument'] = function(key) {
  return preserveStack(function() {
    var ret = Module['_BinaryenGetPassArgument'](strToStack(key));
    return ret !== 0 ? UTF8ToString(ret) : null;
  });
};

// Sets the value of the specified arbitrary pass argument. Removes the
// respective argument if `value` is NULL.
Module['setPassArgument'] = function (key, value) {
  preserveStack(function () {
    Module['_BinaryenSetPassArgument'](strToStack(key), strToStack(value));
  });
};

// Clears all arbitrary pass arguments.
Module['clearPassArguments'] = function() {
  Module['_BinaryenClearPassArguments']();
};

// Gets the function size at which we always inline.
Module['getAlwaysInlineMaxSize'] = function() {
  return Module['_BinaryenGetAlwaysInlineMaxSize']();
};

// Sets the function size at which we always inline.
Module['setAlwaysInlineMaxSize'] = function(size) {
  Module['_BinaryenSetAlwaysInlineMaxSize'](size);
};

// Gets the function size which we inline when functions are lightweight.
Module['getFlexibleInlineMaxSize'] = function() {
  return Module['_BinaryenGetFlexibleInlineMaxSize']();
};

// Sets the function size which we inline when functions are lightweight.
Module['setFlexibleInlineMaxSize'] = function(size) {
  Module['_BinaryenSetFlexibleInlineMaxSize'](size);
};

// Gets the function size which we inline when there is only one caller.
Module['getOneCallerInlineMaxSize'] = function() {
  return Module['_BinaryenGetOneCallerInlineMaxSize']();
};

// Sets the function size which we inline when there is only one caller.
Module['setOneCallerInlineMaxSize'] = function(size) {
  Module['_BinaryenSetOneCallerInlineMaxSize'](size);
};

// Expression wrappers

// Makes a wrapper class with the specified static members while
// automatically deriving instance methods and accessors.
function makeExpressionWrapper(ownStaticMembers) {
  function SpecificExpression(expr) {
    // can call the constructor without `new`
    if (!(this instanceof SpecificExpression)) {
      if (!expr) return null;
      return new SpecificExpression(expr);
    }
    Expression.call(this, expr);
  }
  // inherit static members of Expression
  Object.assign(SpecificExpression, Expression);
  // add own static members
  Object.assign(SpecificExpression, ownStaticMembers);
  // inherit from Expression
  (SpecificExpression.prototype = Object.create(Expression.prototype)).constructor = SpecificExpression;
  // make own instance members
  makeExpressionWrapperInstanceMembers(SpecificExpression.prototype, ownStaticMembers);
  return SpecificExpression;
}

// Makes instance members from the given static members
function makeExpressionWrapperInstanceMembers(prototype, staticMembers) {
  Object.keys(staticMembers).forEach(function(memberName) {
    var member = staticMembers[memberName];
    if (typeof member === "function") {
      // Instance method calls the respective static method
      prototype[memberName] = function(/* arguments */) {
        var numArgs = arguments.length;
        var args = new Array(1 + numArgs);
        args[0] = this['expr'];
        for (var i = 0; i < numArgs; ++i) {
          args[1 + i] = arguments[i];
        }
        return this.constructor[memberName].apply(null, args);
      };
      // Instance accessor calls the respective static methods
      var match;
      if (member.length === 1 && (match = memberName.match(/^(get|is)/))) {
        (function(propertyName, getter, setterIfAny) {
          Object.defineProperty(prototype, propertyName, {
            get: function() {
              return getter(this['expr']);
            },
            set: function(value) {
              if (setterIfAny) setterIfAny(this['expr'], value);
              else throw Error("property '" + propertyName + "' has no setter");
            }
          });
        })(
          memberName.charAt(match[1].length).toLowerCase() + memberName.substring(match[1].length + 1),
          staticMembers[memberName],
          staticMembers["set" + memberName.substring(match[1].length)]
        );
      }
    }
  });
}

// Base class of all expression wrappers
function Expression(expr) {
  if (!expr) throw Error("expression reference must not be null");
  this['expr'] = expr;
}
Expression['getId'] = function(expr) {
  return Module['_BinaryenExpressionGetId'](expr);
};
Expression['getType'] = function(expr) {
  return Module['_BinaryenExpressionGetType'](expr);
};
Expression['setType'] = function(expr, type) {
  Module['_BinaryenExpressionSetType'](expr, type);
};
Expression['finalize'] = function(expr) {
  return Module['_BinaryenExpressionFinalize'](expr);
};
Expression['toText'] = function(expr) {
  return Module['emitText'](expr);
};
makeExpressionWrapperInstanceMembers(Expression.prototype, Expression);
Expression.prototype['valueOf'] = function() {
  return this['expr'];
};

Module['Expression'] = Expression;

Module['Block'] = makeExpressionWrapper({
  'getName': function(expr) {
    var name = Module['_BinaryenBlockGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenBlockSetName'](expr, strToStack(name));
    });
  },
  'getNumChildren': function(expr) {
    return Module['_BinaryenBlockGetNumChildren'](expr);
  },
  'getChildren': function(expr) {
    var numChildren = Module['_BinaryenBlockGetNumChildren'](expr);
    var children = new Array(numChildren);
    var index = 0;
    while (index < numChildren) {
      children[index] = Module['_BinaryenBlockGetChildAt'](expr, index++);
    }
    return children;
  },
  'setChildren': function(expr, children) {
    var numChildren = children.length;
    var prevNumChildren = Module['_BinaryenBlockGetNumChildren'](expr);
    var index = 0;
    while (index < numChildren) {
      if (index < prevNumChildren) {
        Module['_BinaryenBlockSetChildAt'](expr, index, children[index]);
      } else {
        Module['_BinaryenBlockAppendChild'](expr, children[index]);
      }
      ++index;
    }
    while (prevNumChildren > index) {
      Module['_BinaryenBlockRemoveChildAt'](expr, --prevNumChildren);
    }
  },
  'getChildAt': function(expr, index) {
    return Module['_BinaryenBlockGetChildAt'](expr, index);
  },
  'setChildAt': function(expr, index, childExpr) {
    Module['_BinaryenBlockSetChildAt'](expr, index, childExpr);
  },
  'appendChild': function(expr, childExpr) {
    return Module['_BinaryenBlockAppendChild'](expr, childExpr);
  },
  'insertChildAt': function(expr, index, childExpr) {
    Module['_BinaryenBlockInsertChildAt'](expr, index, childExpr);
  },
  'removeChildAt': function(expr, index) {
    return Module['_BinaryenBlockRemoveChildAt'](expr, index);
  }
});

Module['If'] = makeExpressionWrapper({
  'getCondition': function(expr) {
    return Module['_BinaryenIfGetCondition'](expr);
  },
  'setCondition': function(expr, condExpr) {
    Module['_BinaryenIfSetCondition'](expr, condExpr);
  },
  'getIfTrue': function(expr) {
    return Module['_BinaryenIfGetIfTrue'](expr);
  },
  'setIfTrue': function(expr, ifTrueExpr) {
    Module['_BinaryenIfSetIfTrue'](expr, ifTrueExpr);
  },
  'getIfFalse': function(expr) {
    return Module['_BinaryenIfGetIfFalse'](expr);
  },
  'setIfFalse': function(expr, ifFalseExpr) {
    Module['_BinaryenIfSetIfFalse'](expr, ifFalseExpr);
  }
});

Module['Loop'] = makeExpressionWrapper({
  'getName': function(expr) {
    var name = Module['_BinaryenLoopGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenLoopSetName'](expr, strToStack(name));
    });
  },
  'getBody': function(expr) {
    return Module['_BinaryenLoopGetBody'](expr);
  },
  'setBody': function(expr, bodyExpr) {
    Module['_BinaryenLoopSetBody'](expr, bodyExpr);
  }
});

Module['Break'] = makeExpressionWrapper({
  'getName': function(expr) {
    var name = Module['_BinaryenBreakGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenBreakSetName'](expr, strToStack(name));
    });
  },
  'getCondition': function(expr) {
    return Module['_BinaryenBreakGetCondition'](expr);
  },
  'setCondition': function(expr, condExpr) {
    Module['_BinaryenBreakSetCondition'](expr, condExpr);
  },
  'getValue': function(expr) {
    return Module['_BinaryenBreakGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenBreakSetValue'](expr, valueExpr);
  }
});

Module['Switch'] = makeExpressionWrapper({
  'getNumNames': function(expr) {
    return Module['_BinaryenSwitchGetNumNames'](expr);
  },
  'getNames': function(expr) {
    var numNames = Module['_BinaryenSwitchGetNumNames'](expr);
    var names = new Array(numNames);
    var index = 0;
    while (index < numNames) {
      names[index] = UTF8ToString(Module['_BinaryenSwitchGetNameAt'](expr, index++));
    }
    return names;
  },
  'setNames': function(expr, names) {
    var numNames = names.length;
    var prevNumNames = Module['_BinaryenSwitchGetNumNames'](expr);
    var index = 0;
    while (index < numNames) {
      preserveStack(function() {
        if (index < prevNumNames) {
          Module['_BinaryenSwitchSetNameAt'](expr, index, strToStack(names[index]));
        } else {
          Module['_BinaryenSwitchAppendName'](expr, strToStack(names[index]));
        }
      });
      ++index;
    }
    while (prevNumNames > index) {
      Module['_BinaryenSwitchRemoveNameAt'](expr, --prevNumNames);
    }
  },
  'getDefaultName': function(expr) {
    var name = Module['_BinaryenSwitchGetDefaultName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setDefaultName': function(expr, defaultName) {
    preserveStack(function() {
      Module['_BinaryenSwitchSetDefaultName'](expr, strToStack(defaultName));
    });
  },
  'getCondition': function(expr) {
    return Module['_BinaryenSwitchGetCondition'](expr);
  },
  'setCondition': function(expr, condExpr) {
    Module['_BinaryenSwitchSetCondition'](expr, condExpr);
  },
  'getValue': function(expr) {
    return Module['_BinaryenSwitchGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenSwitchSetValue'](expr, valueExpr);
  },
  'getNameAt': function(expr, index) {
    return UTF8ToString(Module['_BinaryenSwitchGetNameAt'](expr, index));
  },
  'setNameAt': function(expr, index, name) {
    preserveStack(function() {
      Module['_BinaryenSwitchSetNameAt'](expr, index, strToStack(name));
    });
  },
  'appendName': function(expr, name) {
    preserveStack(function() {
      return Module['_BinaryenSwitchAppendName'](expr, strToStack(name));
    });
  },
  'insertNameAt': function(expr, index, name) {
    preserveStack(function() {
      Module['_BinaryenSwitchInsertNameAt'](expr, index, strToStack(name));
    });
  },
  'removeNameAt': function(expr, index) {
    return UTF8ToString(Module['_BinaryenSwitchRemoveNameAt'](expr, index));
  },
});

Module['Call'] = makeExpressionWrapper({
  'getTarget': function(expr) {
    return UTF8ToString(Module['_BinaryenCallGetTarget'](expr));
  },
  'setTarget': function(expr, targetName) {
    preserveStack(function() {
      Module['_BinaryenCallSetTarget'](expr, strToStack(targetName));
    });
  },
  'getNumOperands': function(expr) {
    return Module['_BinaryenCallGetNumOperands'](expr);
  },
  'getOperands': function(expr) {
    var numOperands = Module['_BinaryenCallGetNumOperands'](expr);
    var operands = new Array(numOperands);
    var index = 0;
    while (index < numOperands) {
      operands[index] = Module['_BinaryenCallGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands': function(expr, operands) {
    var numOperands = operands.length;
    var prevNumOperands = Module['_BinaryenCallGetNumOperands'](expr);
    var index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        Module['_BinaryenCallSetOperandAt'](expr, index, operands[index]);
      } else {
        Module['_BinaryenCallAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      Module['_BinaryenCallRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt': function(expr, index) {
    return Module['_BinaryenCallGetOperandAt'](expr, index);
  },
  'setOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenCallSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand': function(expr, operandExpr) {
    return Module['_BinaryenCallAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenCallInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt': function(expr, index) {
    return Module['_BinaryenCallRemoveOperandAt'](expr, index);
  },
  'isReturn': function(expr) {
    return Boolean(Module['_BinaryenCallIsReturn'](expr));
  },
  'setReturn': function(expr, isReturn) {
    Module['_BinaryenCallSetReturn'](expr, isReturn);
  }
});

Module['CallIndirect'] = makeExpressionWrapper({
  'getTarget': function(expr) {
    return Module['_BinaryenCallIndirectGetTarget'](expr);
  },
  'setTarget': function(expr, targetExpr) {
    Module['_BinaryenCallIndirectSetTarget'](expr, targetExpr);
  },
  'getNumOperands': function(expr) {
    return Module['_BinaryenCallIndirectGetNumOperands'](expr);
  },
  'getOperands': function(expr) {
    var numOperands = Module['_BinaryenCallIndirectGetNumOperands'](expr);
    var operands = new Array(numOperands);
    var index = 0;
    while (index < numOperands) {
      operands[index] = Module['_BinaryenCallIndirectGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands': function(expr, operands) {
    var numOperands = operands.length;
    var prevNumOperands = Module['_BinaryenCallIndirectGetNumOperands'](expr);
    var index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        Module['_BinaryenCallIndirectSetOperandAt'](expr, index, operands[index]);
      } else {
        Module['_BinaryenCallIndirectAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      Module['_BinaryenCallIndirectRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt': function(expr, index) {
    return Module['_BinaryenCallIndirectGetOperandAt'](expr, index);
  },
  'setOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenCallIndirectSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand': function(expr, operandExpr) {
    return Module['_BinaryenCallIndirectAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenCallIndirectInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt': function(expr, index) {
    return Module['_BinaryenCallIndirectRemoveOperandAt'](expr, index);
  },
  'isReturn': function(expr) {
    return Boolean(Module['_BinaryenCallIndirectIsReturn'](expr));
  },
  'setReturn': function(expr, isReturn) {
    Module['_BinaryenCallIndirectSetReturn'](expr, isReturn);
  },
  'getParams': function(expr) {
    return Module['_BinaryenCallIndirectGetParams'](expr);
  },
  'setParams': function(expr, params) {
    Module['_BinaryenCallIndirectSetParams'](expr, params);
  },
  'getResults': function(expr) {
    return Module['_BinaryenCallIndirectGetResults'](expr);
  },
  'setResults': function(expr, results) {
    Module['_BinaryenCallIndirectSetResults'](expr, results);
  }
});

Module['LocalGet'] = makeExpressionWrapper({
  'getIndex': function(expr) {
    return Module['_BinaryenLocalGetGetIndex'](expr);
  },
  'setIndex': function(expr, index) {
    Module['_BinaryenLocalGetSetIndex'](expr, index);
  }
});

Module['LocalSet'] = makeExpressionWrapper({
  'getIndex': function(expr) {
    return Module['_BinaryenLocalSetGetIndex'](expr);
  },
  'setIndex': function(expr, index) {
    Module['_BinaryenLocalSetSetIndex'](expr, index);
  },
  'isTee': function(expr) {
    return Boolean(Module['_BinaryenLocalSetIsTee'](expr));
  },
  'getValue': function(expr) {
    return Module['_BinaryenLocalSetGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenLocalSetSetValue'](expr, valueExpr);
  }
});

Module['GlobalGet'] = makeExpressionWrapper({
  'getName': function(expr) {
    return UTF8ToString(Module['_BinaryenGlobalGetGetName'](expr));
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenGlobalGetSetName'](expr, strToStack(name));
    });
  }
});

Module['GlobalSet'] = makeExpressionWrapper({
  'getName': function(expr) {
    return UTF8ToString(Module['_BinaryenGlobalSetGetName'](expr));
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenGlobalSetSetName'](expr, strToStack(name));
    });
  },
  'getValue': function(expr) {
    return Module['_BinaryenGlobalSetGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenGlobalSetSetValue'](expr, valueExpr);
  }
});

Module['Host'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenHostGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenHostSetOp'](expr, op);
  },
  'getNameOperand': function(expr) {
    var name = Module['_BinaryenHostGetNameOperand'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setNameOperand': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenHostSetNameOperand'](expr, strToStack(name));
    });
  },
  'getNumOperands': function(expr) {
    return Module['_BinaryenHostGetNumOperands'](expr);
  },
  'getOperands': function(expr) {
    var numOperands = Module['_BinaryenHostGetNumOperands'](expr);
    var operands = new Array(numOperands);
    var index = 0;
    while (index < numOperands) {
      operands[index] = Module['_BinaryenHostGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands': function(expr, operands) {
    var numOperands = operands.length;
    var prevNumOperands = Module['_BinaryenHostGetNumOperands'](expr);
    var index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        Module['_BinaryenHostSetOperandAt'](expr, index, operands[index]);
      } else {
        Module['_BinaryenHostAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      Module['_BinaryenHostRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt': function(expr, index) {
    return Module['_BinaryenHostGetOperandAt'](expr, index);
  },
  'setOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenHostSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand': function(expr, operandExpr) {
    return Module['_BinaryenHostAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenHostInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt': function(expr, index) {
    return Module['_BinaryenHostRemoveOperandAt'](expr, index);
  },
});

Module['Load'] = makeExpressionWrapper({
  'isAtomic': function(expr) {
    return Boolean(Module['_BinaryenLoadIsAtomic'](expr));
  },
  'setAtomic': function(expr, isAtomic) {
    Module['_BinaryenLoadSetAtomic'](expr, isAtomic);
  },
  'isSigned': function(expr) {
    return Boolean(Module['_BinaryenLoadIsSigned'](expr));
  },
  'setSigned': function(expr, isSigned) {
    Module['_BinaryenLoadSetSigned'](expr, isSigned);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenLoadGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenLoadSetOffset'](expr, offset);
  },
  'getBytes': function(expr) {
    return Module['_BinaryenLoadGetBytes'](expr);
  },
  'setBytes': function(expr, bytes) {
    Module['_BinaryenLoadSetBytes'](expr, bytes);
  },
  'getAlign': function(expr) {
    return Module['_BinaryenLoadGetAlign'](expr);
  },
  'setAlign': function(expr, align) {
    Module['_BinaryenLoadSetAlign'](expr, align);
  },
  'getPtr': function(expr) {
    return Module['_BinaryenLoadGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenLoadSetPtr'](expr, ptrExpr);
  }
});

Module['Store'] = makeExpressionWrapper({
  'isAtomic': function(expr) {
    return Boolean(Module['_BinaryenStoreIsAtomic'](expr));
  },
  'setAtomic': function(expr, isAtomic) {
    Module['_BinaryenStoreSetAtomic'](expr, isAtomic);
  },
  'getBytes': function(expr) {
    return Module['_BinaryenStoreGetBytes'](expr);
  },
  'setBytes': function(expr, bytes) {
    Module['_BinaryenStoreSetBytes'](expr, bytes);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenStoreGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenStoreSetOffset'](expr, offset);
  },
  'getAlign': function(expr) {
    return Module['_BinaryenStoreGetAlign'](expr);
  },
  'setAlign': function(expr, align) {
    Module['_BinaryenStoreSetAlign'](expr, align);
  },
  'getPtr': function(expr) {
    return Module['_BinaryenStoreGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenStoreSetPtr'](expr, ptrExpr);
  },
  'getValue': function(expr) {
    return Module['_BinaryenStoreGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenStoreSetValue'](expr, valueExpr);
  },
  'getValueType': function(expr) {
    return Module['_BinaryenStoreGetValueType'](expr);
  },
  'setValueType': function(expr, valueType) {
    Module['_BinaryenStoreSetValueType'](expr, valueType);
  }
});

Module['Const'] = makeExpressionWrapper({
  'getValueI32': function(expr) {
    return Module['_BinaryenConstGetValueI32'](expr);
  },
  'setValueI32': function(expr, value) {
    Module['_BinaryenConstSetValueI32'](expr, value);
  },
  'getValueI64Low': function(expr) {
    return Module['_BinaryenConstGetValueI64Low'](expr);
  },
  'setValueI64Low': function(expr, value) {
    Module['_BinaryenConstSetValueI64Low'](expr, value);
  },
  'getValueI64High': function(expr) {
    return Module['_BinaryenConstGetValueI64High'](expr);
  },
  'setValueI64High': function(expr, value) {
    Module['_BinaryenConstSetValueI64High'](expr, value);
  },
  'getValueF32': function(expr) {
    return Module['_BinaryenConstGetValueF32'](expr);
  },
  'setValueF32': function(expr, value) {
    Module['_BinaryenConstSetValueF32'](expr, value);
  },
  'getValueF64': function(expr) {
    return Module['_BinaryenConstGetValueF64'](expr);
  },
  'setValueF64': function(expr, value) {
    Module['_BinaryenConstSetValueF64'](expr, value);
  },
  'getValueV128': function(expr) {
    var value;
    preserveStack(function() {
      var tempBuffer = stackAlloc(16);
      Module['_BinaryenConstGetValueV128'](expr, tempBuffer);
      value = new Array(16);
      for (var i = 0 ; i < 16; ++i) {
        value[i] = HEAPU8[tempBuffer + i];
      }
    });
    return value;
  },
  'setValueV128': function(expr, value) {
    preserveStack(function() {
      var tempBuffer = stackAlloc(16);
      for (var i = 0 ; i < 16; ++i) {
        HEAPU8[tempBuffer + i] = value[i];
      }
      Module['_BinaryenConstSetValueV128'](expr, tempBuffer);
    });
  }
});

Module['Unary'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenUnaryGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenUnarySetOp'](expr, op);
  },
  'getValue': function(expr) {
    return Module['_BinaryenUnaryGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenUnarySetValue'](expr, valueExpr);
  }
});

Module['Binary'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenBinaryGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenBinarySetOp'](expr, op);
  },
  'getLeft': function(expr) {
    return Module['_BinaryenBinaryGetLeft'](expr);
  },
  'setLeft': function(expr, leftExpr) {
    Module['_BinaryenBinarySetLeft'](expr, leftExpr);
  },
  'getRight': function(expr) {
    return Module['_BinaryenBinaryGetRight'](expr);
  },
  'setRight': function(expr, rightExpr) {
    Module['_BinaryenBinarySetRight'](expr, rightExpr);
  }
});

Module['Select'] = makeExpressionWrapper({
  'getIfTrue': function(expr) {
    return Module['_BinaryenSelectGetIfTrue'](expr);
  },
  'setIfTrue': function(expr, ifTrueExpr) {
    Module['_BinaryenSelectSetIfTrue'](expr, ifTrueExpr);
  },
  'getIfFalse': function(expr) {
    return Module['_BinaryenSelectGetIfFalse'](expr);
  },
  'setIfFalse': function(expr, ifFalseExpr) {
    Module['_BinaryenSelectSetIfFalse'](expr, ifFalseExpr);
  },
  'getCondition': function(expr) {
    return Module['_BinaryenSelectGetCondition'](expr);
  },
  'setCondition': function(expr, condExpr) {
    Module['_BinaryenSelectSetCondition'](expr, condExpr);
  }
});

Module['Drop'] = makeExpressionWrapper({
  'getValue': function(expr) {
    return Module['_BinaryenDropGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenDropSetValue'](expr, valueExpr);
  }
});

Module['Return'] = makeExpressionWrapper({
  'getValue': function(expr) {
    return Module['_BinaryenReturnGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenReturnSetValue'](expr, valueExpr);
  }
});

Module['AtomicRMW'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenAtomicRMWGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenAtomicRMWSetOp'](expr, op);
  },
  'getBytes': function(expr) {
    return Module['_BinaryenAtomicRMWGetBytes'](expr);
  },
  'setBytes': function(expr, bytes) {
    Module['_BinaryenAtomicRMWSetBytes'](expr, bytes);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenAtomicRMWGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenAtomicRMWSetOffset'](expr, offset);
  },
  'getPtr': function(expr) {
    return Module['_BinaryenAtomicRMWGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenAtomicRMWSetPtr'](expr, ptrExpr);
  },
  'getValue': function(expr) {
    return Module['_BinaryenAtomicRMWGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenAtomicRMWSetValue'](expr, valueExpr);
  }
});

Module['AtomicCmpxchg'] = makeExpressionWrapper({
  'getBytes': function(expr) {
    return Module['_BinaryenAtomicCmpxchgGetBytes'](expr);
  },
  'setBytes': function(expr, bytes) {
    Module['_BinaryenAtomicCmpxchgSetBytes'](expr, bytes);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenAtomicCmpxchgGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenAtomicCmpxchgSetOffset'](expr, offset);
  },
  'getPtr': function(expr) {
    return Module['_BinaryenAtomicCmpxchgGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenAtomicCmpxchgSetPtr'](expr, ptrExpr);
  },
  'getExpected': function(expr) {
    return Module['_BinaryenAtomicCmpxchgGetExpected'](expr);
  },
  'setExpected': function(expr, expectedExpr) {
    Module['_BinaryenAtomicCmpxchgSetExpected'](expr, expectedExpr);
  },
  'getReplacement': function(expr) {
    return Module['_BinaryenAtomicCmpxchgGetReplacement'](expr);
  },
  'setReplacement': function(expr, replacementExpr) {
    Module['_BinaryenAtomicCmpxchgSetReplacement'](expr, replacementExpr);
  }
});

Module['AtomicWait'] = makeExpressionWrapper({
  'getPtr': function(expr) {
    return Module['_BinaryenAtomicWaitGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenAtomicWaitSetPtr'](expr, ptrExpr);
  },
  'getExpected': function(expr) {
    return Module['_BinaryenAtomicWaitGetExpected'](expr);
  },
  'setExpected': function(expr, expectedExpr) {
    Module['_BinaryenAtomicWaitSetExpected'](expr, expectedExpr);
  },
  'getTimeout': function(expr) {
    return Module['_BinaryenAtomicWaitGetTimeout'](expr);
  },
  'setTimeout': function(expr, timeoutExpr) {
    Module['_BinaryenAtomicWaitSetTimeout'](expr, timeoutExpr);
  },
  'getExpectedType': function(expr) {
    return Module['_BinaryenAtomicWaitGetExpectedType'](expr);
  },
  'setExpectedType': function(expr, expectedType) {
    Module['_BinaryenAtomicWaitSetExpectedType'](expr, expectedType);
  }
});

Module['AtomicNotify'] = makeExpressionWrapper({
  'getPtr': function(expr) {
    return Module['_BinaryenAtomicNotifyGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenAtomicNotifySetPtr'](expr, ptrExpr);
  },
  'getNotifyCount': function(expr) {
    return Module['_BinaryenAtomicNotifyGetNotifyCount'](expr);
  },
  'setNotifyCount': function(expr, notifyCountExpr) {
    Module['_BinaryenAtomicNotifySetNotifyCount'](expr, notifyCountExpr);
  }
});

Module['AtomicFence'] = makeExpressionWrapper({
  'getOrder': function(expr) {
    return Module['_BinaryenAtomicFenceGetOrder'](expr);
  },
  'setOrder': function(expr, order) {
    Module['_BinaryenAtomicFenceSetOrder'](expr, order);
  }
});

Module['SIMDExtract'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenSIMDExtractGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenSIMDExtractSetOp'](expr, op);
  },
  'getVec': function(expr) {
    return Module['_BinaryenSIMDExtractGetVec'](expr);
  },
  'setVec': function(expr, vecExpr) {
    Module['_BinaryenSIMDExtractSetVec'](expr, vecExpr);
  },
  'getIndex': function(expr) {
    return Module['_BinaryenSIMDExtractGetIndex'](expr);
  },
  'setIndex': function(expr, index) {
    Module['_BinaryenSIMDExtractSetIndex'](expr, index)
  }
});

Module['SIMDReplace'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenSIMDReplaceGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenSIMDReplaceSetOp'](expr, op);
  },
  'getVec': function(expr) {
    return Module['_BinaryenSIMDReplaceGetVec'](expr);
  },
  'setVec': function(expr, vecExpr) {
    Module['_BinaryenSIMDReplaceSetVec'](expr, vecExpr);
  },
  'getIndex': function(expr) {
    return Module['_BinaryenSIMDReplaceGetIndex'](expr);
  },
  'setIndex': function(expr, index) {
    Module['_BinaryenSIMDReplaceSetIndex'](expr, index);
  },
  'getValue': function(expr) {
    return Module['_BinaryenSIMDReplaceGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenSIMDReplaceSetValue'](expr, valueExpr);
  }
});

Module['SIMDShuffle'] = makeExpressionWrapper({
  'getLeft': function(expr) {
    return Module['_BinaryenSIMDShuffleGetLeft'](expr);
  },
  'setLeft': function(expr, leftExpr) {
    Module['_BinaryenSIMDShuffleSetLeft'](expr, leftExpr)
  },
  'getRight': function(expr) {
    return Module['_BinaryenSIMDShuffleGetRight'](expr);
  },
  'setRight': function(expr, rightExpr) {
    Module['_BinaryenSIMDShuffleSetRight'](expr, rightExpr);
  },
  'getMask': function(expr) {
    var mask;
    preserveStack(function() {
      var tempBuffer = stackAlloc(16);
      Module['_BinaryenSIMDShuffleGetMask'](expr, tempBuffer);
      mask = new Array(16);
      for (var i = 0 ; i < 16; ++i) {
        mask[i] = HEAPU8[tempBuffer + i];
      }
    });
    return mask;
  },
  'setMask': function(expr, mask) {
    preserveStack(function() {
      var tempBuffer = stackAlloc(16);
      for (var i = 0 ; i < 16; ++i) {
        HEAPU8[tempBuffer + i] = mask[i];
      }
      Module['_BinaryenSIMDShuffleSetMask'](expr, tempBuffer);
    });
  }
});

Module['SIMDTernary'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenSIMDTernaryGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenSIMDTernarySetOp'](expr, op);
  },
  'getA': function(expr) {
    return Module['_BinaryenSIMDTernaryGetA'](expr);
  },
  'setA': function(expr, aExpr) {
    Module['_BinaryenSIMDTernarySetA'](expr, aExpr);
  },
  'getB': function(expr) {
    return Module['_BinaryenSIMDTernaryGetB'](expr);
  },
  'setB': function(expr, bExpr) {
    Module['_BinaryenSIMDTernarySetB'](expr, bExpr);
  },
  'getC': function(expr) {
    return Module['_BinaryenSIMDTernaryGetC'](expr);
  },
  'setC': function(expr, cExpr) {
    Module['_BinaryenSIMDTernarySetC'](expr, cExpr);
  }
});

Module['SIMDShift'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenSIMDShiftGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenSIMDShiftSetOp'](expr, op);
  },
  'getVec': function(expr) {
    return Module['_BinaryenSIMDShiftGetVec'](expr);
  },
  'setVec': function(expr, vecExpr) {
    Module['_BinaryenSIMDShiftSetVec'](expr, vecExpr);
  },
  'getShift': function(expr) {
    return Module['_BinaryenSIMDShiftGetShift'](expr);
  },
  'setShift': function(expr, shiftExpr) {
    Module['_BinaryenSIMDShiftSetShift'](expr, shiftExpr);
  }
});

Module['SIMDLoad'] = makeExpressionWrapper({
  'getOp': function(expr) {
    return Module['_BinaryenSIMDLoadGetOp'](expr);
  },
  'setOp': function(expr, op) {
    Module['_BinaryenSIMDLoadSetOp'](expr, op);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenSIMDLoadGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenSIMDLoadSetOffset'](expr, offset);
  },
  'getAlign': function(expr) {
    return Module['_BinaryenSIMDLoadGetAlign'](expr);
  },
  'setAlign': function(expr, align) {
    Module['_BinaryenSIMDLoadSetAlign'](expr, align);
  },
  'getPtr': function(expr) {
    return Module['_BinaryenSIMDLoadGetPtr'](expr);
  },
  'setPtr': function(expr, ptrExpr) {
    Module['_BinaryenSIMDLoadSetPtr'](expr, ptrExpr);
  }
});

Module['MemoryInit'] = makeExpressionWrapper({
  'getSegment': function(expr) {
    return Module['_BinaryenMemoryInitGetSegment'](expr);
  },
  'setSegment': function(expr, segmentIndex) {
    Module['_BinaryenMemoryInitSetSegment'](expr, segmentIndex);
  },
  'getDest': function(expr) {
    return Module['_BinaryenMemoryInitGetDest'](expr);
  },
  'setDest': function(expr, destExpr) {
    Module['_BinaryenMemoryInitSetDest'](expr, destExpr);
  },
  'getOffset': function(expr) {
    return Module['_BinaryenMemoryInitGetOffset'](expr);
  },
  'setOffset': function(expr, offset) {
    Module['_BinaryenMemoryInitSetOffset'](expr, offset);
  },
  'getSize': function(expr) {
    return Module['_BinaryenMemoryInitGetSize'](expr);
  },
  'setSize': function(expr, sizeExpr) {
    Module['_BinaryenMemoryInitSetSize'](expr, sizeExpr);
  }
});

Module['DataDrop'] = makeExpressionWrapper({
  'getSegment': function(expr) {
    return Module['_BinaryenDataDropGetSegment'](expr);
  },
  'setSegment': function(expr, segmentIndex) {
    Module['_BinaryenDataDropSetSegment'](expr, segmentIndex);
  }
});

Module['MemoryCopy'] = makeExpressionWrapper({
  'getDest': function(expr) {
    return Module['_BinaryenMemoryCopyGetDest'](expr);
  },
  'setDest': function(expr, destExpr) {
    Module['_BinaryenMemoryCopySetDest'](expr, destExpr);
  },
  'getSource': function(expr) {
    return Module['_BinaryenMemoryCopyGetSource'](expr);
  },
  'setSource': function(expr, sourceExpr) {
    Module['_BinaryenMemoryCopySetSource'](expr, sourceExpr);
  },
  'getSize': function(expr) {
    return Module['_BinaryenMemoryCopyGetSize'](expr);
  },
  'setSize': function(expr, sizeExpr) {
    Module['_BinaryenMemoryCopySetSize'](expr, sizeExpr);
  }
});

Module['MemoryFill'] = makeExpressionWrapper({
  'getDest': function(expr) {
    return Module['_BinaryenMemoryFillGetDest'](expr);
  },
  'setDest': function(expr, destExpr) {
    Module['_BinaryenMemoryFillSetDest'](expr, destExpr);
  },
  'getValue': function(expr) {
    return Module['_BinaryenMemoryFillGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenMemoryFillSetValue'](expr, valueExpr);
  },
  'getSize': function(expr) {
    return Module['_BinaryenMemoryFillGetSize'](expr);
  },
  'setSize': function(expr, sizeExpr) {
    Module['_BinaryenMemoryFillSetSize'](expr, sizeExpr);
  }
});

Module['RefIsNull'] = makeExpressionWrapper({
  'getValue': function(expr) {
    return Module['_BinaryenRefIsNullGetValue'](expr);
  },
  'setValue': function(expr, valueExpr) {
    Module['_BinaryenRefIsNullSetValue'](expr, valueExpr);
  }
});

Module['RefFunc'] = makeExpressionWrapper({
  'getFunc': function(expr) {
    return UTF8ToString(Module['_BinaryenRefFuncGetFunc'](expr));
  },
  'setFunc': function(expr, funcName) {
    preserveStack(function() {
      Module['_BinaryenRefFuncSetFunc'](expr, strToStack(funcName));
    });
  }
});

Module['Try'] = makeExpressionWrapper({
  'getBody': function(expr) {
    return Module['_BinaryenTryGetBody'](expr);
  },
  'setBody': function(expr, bodyExpr) {
    Module['_BinaryenTrySetBody'](expr, bodyExpr);
  },
  'getCatchBody': function(expr) {
    return Module['_BinaryenTryGetCatchBody'](expr);
  },
  'setCatchBody': function(expr, catchBodyExpr) {
    Module['_BinaryenTrySetCatchBody'](expr, catchBodyExpr);
  }
});

Module['Throw'] = makeExpressionWrapper({
  'getEvent': function(expr) {
    return UTF8ToString(Module['_BinaryenThrowGetEvent'](expr));
  },
  'setEvent': function(expr, eventName) {
    preserveStack(function() {
      Module['_BinaryenThrowSetEvent'](expr, strToStack(eventName));
    });
  },
  'getNumOperands': function(expr) {
    return Module['_BinaryenThrowGetNumOperands'](expr);
  },
  'getOperands': function(expr) {
    var numOperands = Module['_BinaryenThrowGetNumOperands'](expr);
    var operands = new Array(numOperands);
    var index = 0;
    while (index < numOperands) {
      operands[index] = Module['_BinaryenThrowGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands': function(expr, operands) {
    var numOperands = operands.length;
    var prevNumOperands = Module['_BinaryenThrowGetNumOperands'](expr);
    var index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        Module['_BinaryenThrowSetOperandAt'](expr, index, operands[index]);
      } else {
        Module['_BinaryenThrowAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      Module['_BinaryenThrowRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt': function(expr, index) {
    return Module['_BinaryenThrowGetOperandAt'](expr, index);
  },
  'setOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenThrowSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand': function(expr, operandExpr) {
    return Module['_BinaryenThrowAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenThrowInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt': function(expr, index) {
    return Module['_BinaryenThrowRemoveOperandAt'](expr, index);
  },
});

Module['Rethrow'] = makeExpressionWrapper({
  'getExnref': function(expr) {
    return Module['_BinaryenRethrowGetExnref'](expr);
  },
  'setExnref': function(expr, exnrefExpr) {
    Module['_BinaryenRethrowSetExnref'](expr, exnrefExpr);
  }
});

Module['BrOnExn'] = makeExpressionWrapper({
  'getEvent': function(expr) {
    return UTF8ToString(Module['_BinaryenBrOnExnGetEvent'](expr));
  },
  'setEvent': function(expr, eventName) {
    preserveStack(function() {
      Module['_BinaryenBrOnExnSetEvent'](expr, strToStack(eventName));
    });
  },
  'getName': function(expr) {
    return UTF8ToString(Module['_BinaryenBrOnExnGetName'](expr));
  },
  'setName': function(expr, name) {
    preserveStack(function() {
      Module['_BinaryenBrOnExnSetName'](expr, strToStack(name));
    });
  },
  'getExnref': function(expr) {
    return Module['_BinaryenBrOnExnGetExnref'](expr);
  },
  'setExnref': function(expr, exnrefExpr) {
    Module['_BinaryenBrOnExnSetExnref'](expr, exnrefExpr);
  }
});

Module['TupleMake'] = makeExpressionWrapper({
  'getNumOperands': function(expr) {
    return Module['_BinaryenTupleMakeGetNumOperands'](expr);
  },
  'getOperands': function(expr) {
    var numOperands = Module['_BinaryenTupleMakeGetNumOperands'](expr);
    var operands = new Array(numOperands);
    var index = 0;
    while (index < numOperands) {
      operands[index] = Module['_BinaryenTupleMakeGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands': function(expr, operands) {
    var numOperands = operands.length;
    var prevNumOperands = Module['_BinaryenTupleMakeGetNumOperands'](expr);
    var index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        Module['_BinaryenTupleMakeSetOperandAt'](expr, index, operands[index]);
      } else {
        Module['_BinaryenTupleMakeAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      Module['_BinaryenTupleMakeRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt': function(expr, index) {
    return Module['_BinaryenTupleMakeGetOperandAt'](expr, index);
  },
  'setOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenTupleMakeSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand': function(expr, operandExpr) {
    return Module['_BinaryenTupleMakeAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt': function(expr, index, operandExpr) {
    Module['_BinaryenTupleMakeInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt': function(expr, index) {
    return Module['_BinaryenTupleMakeRemoveOperandAt'](expr, index);
  }
});

Module['TupleExtract'] = makeExpressionWrapper({
  'getTuple': function(expr) {
    return Module['_BinaryenTupleExtractGetTuple'](expr);
  },
  'setTuple': function(expr, tupleExpr) {
    Module['_BinaryenTupleExtractSetTuple'](expr, tupleExpr);
  },
  'getIndex': function(expr) {
    return Module['_BinaryenTupleExtractGetIndex'](expr);
  },
  'setIndex': function(expr, index) {
    Module['_BinaryenTupleExtractSetIndex'](expr, index);
  }
});

// Additional customizations

Module['exit'] = function(status) {
  // Instead of exiting silently on errors, always show an error with
  // a stack trace, for debuggability.
  if (status != 0) throw new Error('exiting due to error: ' + status);
};

// Indicates if Binaryen has been loaded and is ready
Module['isReady'] = runtimeInitialized;

// Provide a mechanism to tell when the module is ready
//
// if (!binaryen.isReady) await binaryen.ready;
// ...
//
var pendingPromises = [];
var initializeError = null;
Object.defineProperty(Module, 'ready', {
  get: function() {
    return new Promise(function(resolve, reject) {
      if (initializeError) {
        reject(initializeError);
      } else if (runtimeInitialized) {
        resolve(Module);
      } else {
        pendingPromises.push({
          resolve: resolve,
          reject: reject
        });
      }
    });
  }
});

// Intercept the onRuntimeInitialized hook if necessary
if (runtimeInitialized) {
  initializeConstants();
} else {
  Module['onRuntimeInitialized'] = (function(super_) {
    return function() {
      try {
        initializeConstants();
        if (super_) super_();
        Module['isReady'] = true;
        pendingPromises.forEach(function(p) {
          p.resolve(Module);
        });
      } catch (e) {
        initializeError = e;
        pendingPromises.forEach(function(p) {
          p.reject(e);
        });
      } finally {
        pendingPromises = [];
      }
    };
  })(Module['onRuntimeInitialized']);
}
