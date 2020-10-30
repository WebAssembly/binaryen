// We have a 'Module' below, so alias the generated one
const MODULE = Module;

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
  return str ? allocate(intArrayFromString(str), 'i8', ALLOC_STACK) : 0;
}

function i32sToStack(i32s) {
  const ret = stackAlloc(i32s.length << 2);
  HEAP32.set(i32s, ret >>> 2);
  return ret;
}

function i8sToStack(i8s) {
  const ret = stackAlloc(i8s.length);
  HEAP8.set(i8s, ret);
  return ret;
}

export const Types = {};
export const ExpressionIds = {};
export const ExternalKinds = {};
export const Features = {};
export const Operations = {};
export const SideEffects = {};

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
    ['exnref', 'Exnref'],
    ['anyref', 'Anyref'],
    ['eqref', 'Eqref'],
    ['i31ref', 'I31ref'],
    ['unreachable', 'Unreachable'],
    ['auto', 'Auto']
  ].forEach(entry => {
    const value = MODULE['_BinaryenType' + entry[1]]();
    Types[entry[0]] = value;
    Types[value] = entry[0];
  });

  // Expression ids
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
    'MemorySize',
    'MemoryGrow',
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
    'RefEq',
    'Try',
    'Throw',
    'Rethrow',
    'BrOnExn',
    'TupleMake',
    'TupleExtract',
    'Pop',
    'I31New',
    'I31Get',
    'RefTest',
    'RefCast',
    'BrOnCast',
    'RttCanon',
    'RttSub',
    'StructNew',
    'StructGet',
    'StructSet',
    'ArrayNew',
    'ArrayGet',
    'ArraySet',
    'ArrayLen'
  ].forEach(name => {
    const value = MODULE['_Binaryen' + name + 'Id']();
    ExpressionIds[name] = value;
    ExpressionIds[value] = name;
  });

  // External kinds
  [ 'Function',
    'Table',
    'Memory',
    'Global',
    'Event'
  ].forEach(name => {
    const value = MODULE['_BinaryenExternal' + name]();
    ExternalKinds[name] = value;
    ExternalKinds[value] = name;
  });

  // Features
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
    'GC',
    'Memory64',
    'All'
  ].forEach(name => {
    const value = MODULE['_BinaryenFeature' + name]();
    Features[name] = value;
    Features[value] = name;
  });

  // Operations
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
  ].forEach(name => {
    const value = MODULE['_Binaryen' + name](); 
    Operations[name] = value;
    Operations[value] = name;
  });

  // Expression side effects
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
  ].forEach(name => {
    const value = MODULE['_BinaryenSideEffect' + name]();
    SideEffects[name] = value;
    SideEffects[value] = name;
  });

  // ExpressionRunner flags
  [
    'Default',
    'PreserveSideeffects',
    'TraverseCalls'
  ].forEach(name => {
    const value = MODULE['_ExpressionRunnerFlags' + name]();
    ExpressionRunner['Flags'][name] = value;
    ExpressionRunner['Flags'][value] = name;
  });
}

// 'Module' interface
function BynModule(module) {
  assert(!module); // guard against incorrect old API usage
  wrapModule(MODULE['_BinaryenModuleCreate'](), this);
}

export { BynModule as Module };

// Receives a C pointer to a C Module and a JS object, and creates
// the JS wrappings on the object to access the C data.
// This is meant for internal use only, and is necessary as we
// want to access Module from JS that were perhaps not created
// from JS.
export function wrapModule(module, self = {}) {
  assert(module); // guard against incorrect old API usage

  self['ptr'] = module;

  // The size of a single literal in memory as used in Const creation,
  // which is a little different: we don't want users to need to make
  // their own Literals, as the C API handles them by value, which means
  // we would leak them. Instead, Const creation is fused together with
  // an intermediate stack allocation of this size to pass the value.
  const sizeOfLiteral = _BinaryenSizeofLiteral();

  // 'Expression' creation
  self['block'] = function(name, children, type) {
    return preserveStack(() =>
      MODULE['_BinaryenBlock'](module, name ? strToStack(name) : 0,
                               i32sToStack(children), children.length,
                               typeof type !== 'undefined' ? type : Types['none'])
    );
  };
  self['if'] = function(condition, ifTrue, ifFalse) {
    return MODULE['_BinaryenIf'](module, condition, ifTrue, ifFalse);
  };
  self['loop'] = function(label, body) {
    return preserveStack(() => MODULE['_BinaryenLoop'](module, strToStack(label), body));
  };
  self['break'] = self['br'] = function(label, condition, value) {
    return preserveStack(() => MODULE['_BinaryenBreak'](module, strToStack(label), condition, value));
  };
  self['br_if'] = function(label, condition, value) {
    return self['br'](label, condition, value);
  };
  self['switch'] = function(names, defaultName, condition, value) {
    return preserveStack(() =>
      MODULE['_BinaryenSwitch'](module, i32sToStack(names.map(strToStack)), names.length, strToStack(defaultName), condition, value)
    );
  };
  self['call'] = function(name, operands, type) {
    return preserveStack(() => MODULE['_BinaryenCall'](module, strToStack(name), i32sToStack(operands), operands.length, type));
  };
  // 'callIndirect', 'returnCall', 'returnCallIndirect' are deprecated and may
  // be removed in a future release. Please use the the snake_case names
  // instead.
  self['callIndirect'] = self['call_indirect'] = function(target, operands, params, results) {
    return preserveStack(() =>
      MODULE['_BinaryenCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results)
    );
  };
  self['returnCall'] = self['return_call'] = function(name, operands, type) {
    return preserveStack(() =>
      MODULE['_BinaryenReturnCall'](module, strToStack(name), i32sToStack(operands), operands.length, type)
    );
  };
  self['returnCallIndirect'] = self['return_call_indirect'] = function(target, operands, params, results) {
    return preserveStack(() =>
      MODULE['_BinaryenReturnCallIndirect'](module, target, i32sToStack(operands), operands.length, params, results)
    );
  };

  self['local'] = {
    'get'(index, type) {
      return MODULE['_BinaryenLocalGet'](module, index, type);
    },
    'set'(index, value) {
      return MODULE['_BinaryenLocalSet'](module, index, value);
    },
    'tee'(index, value, type) {
      if (typeof type === 'undefined') {
        throw new Error("local.tee's type should be defined");
      }
      return MODULE['_BinaryenLocalTee'](module, index, value, type);
    }
  }

  self['global'] = {
    'get'(name, type) {
      return MODULE['_BinaryenGlobalGet'](module, strToStack(name), type);
    },
    'set'(name, value) {
      return MODULE['_BinaryenGlobalSet'](module, strToStack(name), value);
    }
  }

  self['memory'] = {
    'size'() {
      return MODULE['_BinaryenMemorySize'](module);
    },
    'grow'(value) {
      return MODULE['_BinaryenMemoryGrow'](module, value);
    },
    'init'(segment, dest, offset, size) {
      return MODULE['_BinaryenMemoryInit'](module, segment, dest, offset, size);
    },
    'copy'(dest, source, size) {
      return MODULE['_BinaryenMemoryCopy'](module, dest, source, size);
    },
    'fill'(dest, value, size) {
      return MODULE['_BinaryenMemoryFill'](module, dest, value, size);
    }
  }

  self['data'] = {
    'drop'(segment) {
      return MODULE['_BinaryenDataDrop'](module, segment);
    }
  }

  self['i32'] = {
    'load'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 4, true, offset, align, Types['i32'], ptr);
    },
    'load8_s'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 1, true, offset, align, Types['i32'], ptr);
    },
    'load8_u'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 1, false, offset, align, Types['i32'], ptr);
    },
    'load16_s'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 2, true, offset, align, Types['i32'], ptr);
    },
    'load16_u'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 2, false, offset, align, Types['i32'], ptr);
    },
    'store'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 4, offset, align, ptr, value, Types['i32']);
    },
    'store8'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 1, offset, align, ptr, value, Types['i32']);
    },
    'store16'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 2, offset, align, ptr, value, Types['i32']);
    },
    'const'(x) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralInt32'](tempLiteral, x);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'clz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ClzInt32'], value);
    },
    'ctz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CtzInt32'], value);
    },
    'popcnt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['PopcntInt32'], value);
    },
    'eqz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['EqZInt32'], value);
    },
    'trunc_s': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSFloat32ToInt32'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSFloat64ToInt32'], value);
      },
    },
    'trunc_u': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncUFloat32ToInt32'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncUFloat64ToInt32'], value);
      },
    },
    'trunc_s_sat': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatSFloat32ToInt32'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatSFloat64ToInt32'], value);
      },
    },
    'trunc_u_sat': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatUFloat32ToInt32'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatUFloat64ToInt32'], value);
      },
    },
    'reinterpret'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ReinterpretFloat32'], value);
    },
    'extend8_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendS8Int32'], value);
    },
    'extend16_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendS16Int32'], value);
    },
    'wrap'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WrapInt64'], value);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddInt32'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubInt32'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulInt32'], left, right);
    },
    'div_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivSInt32'], left, right);
    },
    'div_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivUInt32'], left, right);
    },
    'rem_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RemSInt32'], left, right);
    },
    'rem_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RemUInt32'], left, right);
    },
    'and'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AndInt32'], left, right);
    },
    'or'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['OrInt32'], left, right);
    },
    'xor'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['XorInt32'], left, right);
    },
    'shl'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShlInt32'], left, right);
    },
    'shr_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShrUInt32'], left, right);
    },
    'shr_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShrSInt32'], left, right);
    },
    'rotl'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RotLInt32'], left, right);
    },
    'rotr'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RotRInt32'], left, right);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqInt32'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeInt32'], left, right);
    },
    'lt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtSInt32'], left, right);
    },
    'lt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtUInt32'], left, right);
    },
    'le_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeSInt32'], left, right);
    },
    'le_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeUInt32'], left, right);
    },
    'gt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtSInt32'], left, right);
    },
    'gt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtUInt32'], left, right);
    },
    'ge_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeSInt32'], left, right);
    },
    'ge_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeUInt32'], left, right);
    },
    'atomic': {
      'load'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 4, offset, Types['i32'], ptr);
      },
      'load8_u'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 1, offset, Types['i32'], ptr);
      },
      'load16_u'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 2, offset, Types['i32'], ptr);
      },
      'store'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Types['i32']);
      },
      'store8'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Types['i32']);
      },
      'store16'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Types['i32']);
      },
      'rmw': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 4, offset, ptr, value, Types['i32']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 4, offset, ptr, value, Types['i32']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 4, offset, ptr, value, Types['i32']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 4, offset, ptr, value, Types['i32']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 4, offset, ptr, value, Types['i32']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 4, offset, ptr, value, Types['i32']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Types['i32'])
        },
      },
      'rmw8_u': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 1, offset, ptr, value, Types['i32']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 1, offset, ptr, value, Types['i32']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 1, offset, ptr, value, Types['i32']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 1, offset, ptr, value, Types['i32']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 1, offset, ptr, value, Types['i32']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 1, offset, ptr, value, Types['i32']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Types['i32'])
        },
      },
      'rmw16_u': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 2, offset, ptr, value, Types['i32']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 2, offset, ptr, value, Types['i32']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 2, offset, ptr, value, Types['i32']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 2, offset, ptr, value, Types['i32']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 2, offset, ptr, value, Types['i32']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 2, offset, ptr, value, Types['i32']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Types['i32'])
        },
      },
      'wait'(ptr, expected, timeout) {
        return MODULE['_BinaryenAtomicWait'](module, ptr, expected, timeout, Types['i32']);
      }
    },
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['i32']);
    }
  };

  self['i64'] = {
    'load'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 8, true, offset, align, Types['i64'], ptr);
    },
    'load8_s'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 1, true, offset, align, Types['i64'], ptr);
    },
    'load8_u'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 1, false, offset, align, Types['i64'], ptr);
    },
    'load16_s'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 2, true, offset, align, Types['i64'], ptr);
    },
    'load16_u'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 2, false, offset, align, Types['i64'], ptr);
    },
    'load32_s'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 4, true, offset, align, Types['i64'], ptr);
    },
    'load32_u'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 4, false, offset, align, Types['i64'], ptr);
    },
    'store'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 8, offset, align, ptr, value, Types['i64']);
    },
    'store8'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 1, offset, align, ptr, value, Types['i64']);
    },
    'store16'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 2, offset, align, ptr, value, Types['i64']);
    },
    'store32'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 4, offset, align, ptr, value, Types['i64']);
    },
    'const'(x, y) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralInt64'](tempLiteral, x, y);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'clz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ClzInt64'], value);
    },
    'ctz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CtzInt64'], value);
    },
    'popcnt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['PopcntInt64'], value);
    },
    'eqz'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['EqZInt64'], value);
    },
    'trunc_s': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSFloat32ToInt64'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSFloat64ToInt64'], value);
      },
    },
    'trunc_u': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncUFloat32ToInt64'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncUFloat64ToInt64'], value);
      },
    },
    'trunc_s_sat': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatSFloat32ToInt64'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatSFloat64ToInt64'], value);
      },
    },
    'trunc_u_sat': {
      'f32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatUFloat32ToInt64'], value);
      },
      'f64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['TruncSatUFloat64ToInt64'], value);
      },
    },
    'reinterpret'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ReinterpretFloat64'], value);
    },
    'extend8_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendS8Int64'], value);
    },
    'extend16_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendS16Int64'], value);
    },
    'extend32_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendS32Int64'], value);
    },
    'extend_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendSInt32'], value);
    },
    'extend_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ExtendUInt32'], value);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddInt64'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubInt64'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulInt64'], left, right);
    },
    'div_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivSInt64'], left, right);
    },
    'div_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivUInt64'], left, right);
    },
    'rem_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RemSInt64'], left, right);
    },
    'rem_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RemUInt64'], left, right);
    },
    'and'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AndInt64'], left, right);
    },
    'or'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['OrInt64'], left, right);
    },
    'xor'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['XorInt64'], left, right);
    },
    'shl'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShlInt64'], left, right);
    },
    'shr_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShrUInt64'], left, right);
    },
    'shr_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['ShrSInt64'], left, right);
    },
    'rotl'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RotLInt64'], left, right);
    },
    'rotr'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['RotRInt64'], left, right);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqInt64'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeInt64'], left, right);
    },
    'lt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtSInt64'], left, right);
    },
    'lt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtUInt64'], left, right);
    },
    'le_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeSInt64'], left, right);
    },
    'le_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeUInt64'], left, right);
    },
    'gt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtSInt64'], left, right);
    },
    'gt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtUInt64'], left, right);
    },
    'ge_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeSInt64'], left, right);
    },
    'ge_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeUInt64'], left, right);
    },
    'atomic': {
      'load'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 8, offset, Types['i64'], ptr);
      },
      'load8_u'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 1, offset, Types['i64'], ptr);
      },
      'load16_u'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 2, offset, Types['i64'], ptr);
      },
      'load32_u'(offset, ptr) {
        return MODULE['_BinaryenAtomicLoad'](module, 4, offset, Types['i64'], ptr);
      },
      'store'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 8, offset, ptr, value, Types['i64']);
      },
      'store8'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 1, offset, ptr, value, Types['i64']);
      },
      'store16'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 2, offset, ptr, value, Types['i64']);
      },
      'store32'(offset, ptr, value) {
        return MODULE['_BinaryenAtomicStore'](module, 4, offset, ptr, value, Types['i64']);
      },
      'rmw': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 8, offset, ptr, value, Types['i64']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 8, offset, ptr, value, Types['i64']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 8, offset, ptr, value, Types['i64']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 8, offset, ptr, value, Types['i64']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 8, offset, ptr, value, Types['i64']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 8, offset, ptr, value, Types['i64']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 8, offset, ptr, expected, replacement, Types['i64'])
        },
      },
      'rmw8_u': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 1, offset, ptr, value, Types['i64']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 1, offset, ptr, value, Types['i64']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 1, offset, ptr, value, Types['i64']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 1, offset, ptr, value, Types['i64']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 1, offset, ptr, value, Types['i64']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 1, offset, ptr, value, Types['i64']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 1, offset, ptr, expected, replacement, Types['i64'])
        },
      },
      'rmw16_u': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 2, offset, ptr, value, Types['i64']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 2, offset, ptr, value, Types['i64']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 2, offset, ptr, value, Types['i64']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 2, offset, ptr, value, Types['i64']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 2, offset, ptr, value, Types['i64']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 2, offset, ptr, value, Types['i64']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 2, offset, ptr, expected, replacement, Types['i64'])
        },
      },
      'rmw32_u': {
        'add'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAdd'], 4, offset, ptr, value, Types['i64']);
        },
        'sub'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWSub'], 4, offset, ptr, value, Types['i64']);
        },
        'and'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWAnd'], 4, offset, ptr, value, Types['i64']);
        },
        'or'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWOr'], 4, offset, ptr, value, Types['i64']);
        },
        'xor'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXor'], 4, offset, ptr, value, Types['i64']);
        },
        'xchg'(offset, ptr, value) {
          return MODULE['_BinaryenAtomicRMW'](module, Operations['AtomicRMWXchg'], 4, offset, ptr, value, Types['i64']);
        },
        'cmpxchg'(offset, ptr, expected, replacement) {
          return MODULE['_BinaryenAtomicCmpxchg'](module, 4, offset, ptr, expected, replacement, Types['i64'])
        },
      },
      'wait'(ptr, expected, timeout) {
        return MODULE['_BinaryenAtomicWait'](module, ptr, expected, timeout, Types['i64']);
      }
    },
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['i64']);
    }
  };

  self['f32'] = {
    'load'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 4, true, offset, align, Types['f32'], ptr);
    },
    'store'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 4, offset, align, ptr, value, Types['f32']);
    },
    'const'(x) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralFloat32'](tempLiteral, x);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits'(x) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralFloat32Bits'](tempLiteral, x);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegFloat32'], value);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsFloat32'], value);
    },
    'ceil'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CeilFloat32'], value);
    },
    'floor'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['FloorFloat32'], value);
    },
    'trunc'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncFloat32'], value);
    },
    'nearest'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NearestFloat32'], value);
    },
    'sqrt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SqrtFloat32'], value);
    },
    'reinterpret'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ReinterpretInt32'], value);
    },
    'convert_s': {
      'i32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertSInt32ToFloat32'], value);
      },
      'i64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertSInt64ToFloat32'], value);
      },
    },
    'convert_u': {
      'i32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertUInt32ToFloat32'], value);
      },
      'i64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertUInt64ToFloat32'], value);
      },
    },
    'demote'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['DemoteFloat64'], value);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddFloat32'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubFloat32'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulFloat32'], left, right);
    },
    'div'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivFloat32'], left, right);
    },
    'copysign'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['CopySignFloat32'], left, right);
    },
    'min'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinFloat32'], left, right);
    },
    'max'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxFloat32'], left, right);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqFloat32'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeFloat32'], left, right);
    },
    'lt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtFloat32'], left, right);
    },
    'le'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeFloat32'], left, right);
    },
    'gt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtFloat32'], left, right);
    },
    'ge'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeFloat32'], left, right);
    },
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['f32']);
    }
  };

  self['f64'] = {
    'load'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 8, true, offset, align, Types['f64'], ptr);
    },
    'store'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 8, offset, align, ptr, value, Types['f64']);
    },
    'const'(x) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralFloat64'](tempLiteral, x);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'const_bits'(x, y) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralFloat64Bits'](tempLiteral, x, y);
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegFloat64'], value);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsFloat64'], value);
    },
    'ceil'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CeilFloat64'], value);
    },
    'floor'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['FloorFloat64'], value);
    },
    'trunc'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncFloat64'], value);
    },
    'nearest'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NearestFloat64'], value);
    },
    'sqrt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SqrtFloat64'], value);
    },
    'reinterpret'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ReinterpretInt64'], value);
    },
    'convert_s': {
      'i32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertSInt32ToFloat64'], value);
      },
      'i64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertSInt64ToFloat64'], value);
      },
    },
    'convert_u': {
      'i32'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertUInt32ToFloat64'], value);
      },
      'i64'(value) {
        return MODULE['_BinaryenUnary'](module, Operations['ConvertUInt64ToFloat64'], value);
      },
    },
    'promote'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['PromoteFloat32'], value);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddFloat64'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubFloat64'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulFloat64'], left, right);
    },
    'div'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivFloat64'], left, right);
    },
    'copysign'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['CopySignFloat64'], left, right);
    },
    'min'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinFloat64'], left, right);
    },
    'max'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxFloat64'], left, right);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqFloat64'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeFloat64'], left, right);
    },
    'lt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtFloat64'], left, right);
    },
    'le'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeFloat64'], left, right);
    },
    'gt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtFloat64'], left, right);
    },
    'ge'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeFloat64'], left, right);
    },
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['f64']);
    }
  };

  self['v128'] = {
    'load'(offset, align, ptr) {
      return MODULE['_BinaryenLoad'](module, 16, false, offset, align, Types['v128'], ptr);
    },
    'store'(offset, align, ptr, value) {
      return MODULE['_BinaryenStore'](module, 16, offset, align, ptr, value, Types['v128']);
    },
    'const'(i8s) {
      return preserveStack(() => {
        const tempLiteral = stackAlloc(sizeOfLiteral);
        MODULE['_BinaryenLiteralVec128'](tempLiteral, i8sToStack(i8s));
        return MODULE['_BinaryenConst'](module, tempLiteral);
      });
    },
    'not'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NotVec128'], value);
    },
    'and'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AndVec128'], left, right);
    },
    'or'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['OrVec128'], left, right);
    },
    'xor'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['XorVec128'], left, right);
    },
    'andnot'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AndNotVec128'], left, right);
    },
    'bitselect'(left, right, cond) {
      return MODULE['_BinaryenSIMDTernary'](module, Operations['BitselectVec128'], left, right, cond);
    },
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['v128']);
    }
  };

  self['i8x16'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecI8x16'], value);
    },
    'extract_lane_s'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneSVecI8x16'], vec, index);
    },
    'extract_lane_u'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneUVecI8x16'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecI8x16'], vec, index, value);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqVecI8x16'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeVecI8x16'], left, right);
    },
    'lt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtSVecI8x16'], left, right);
    },
    'lt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtUVecI8x16'], left, right);
    },
    'gt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtSVecI8x16'], left, right);
    },
    'gt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtUVecI8x16'], left, right);
    },
    'le_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeSVecI8x16'], left, right);
    },
    'le_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeUVecI8x16'], left, right);
    },
    'ge_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeSVecI8x16'], left, right);
    },
    'ge_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeUVecI8x16'], left, right);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsVecI8x16'], value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecI8x16'], value);
    },
    'any_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AnyTrueVecI8x16'], value);
    },
    'all_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AllTrueVecI8x16'], value);
    },
    'bitmask'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['BitmaskVecI8x16'], value);
    },
    'shl'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShlVecI8x16'], vec, shift);
    },
    'shr_s'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrSVecI8x16'], vec, shift);
    },
    'shr_u'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrUVecI8x16'], vec, shift);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecI8x16'], left, right);
    },
    'add_saturate_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddSatSVecI8x16'], left, right);
    },
    'add_saturate_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddSatUVecI8x16'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecI8x16'], left, right);
    },
    'sub_saturate_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubSatSVecI8x16'], left, right);
    },
    'sub_saturate_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubSatUVecI8x16'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecI8x16'], left, right);
    },
    'min_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinSVecI8x16'], left, right);
    },
    'min_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinUVecI8x16'], left, right);
    },
    'max_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxSVecI8x16'], left, right);
    },
    'max_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxUVecI8x16'], left, right);
    },
    'avgr_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AvgrUVecI8x16'], left, right);
    },
    'narrow_i16x8_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NarrowSVecI16x8ToVecI8x16'], left, right);
    },
    'narrow_i16x8_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NarrowUVecI16x8ToVecI8x16'], left, right);
    },
  };

  self['i16x8'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecI16x8'], value);
    },
    'extract_lane_s'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneSVecI16x8'], vec, index);
    },
    'extract_lane_u'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneUVecI16x8'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecI16x8'], vec, index, value);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqVecI16x8'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeVecI16x8'], left, right);
    },
    'lt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtSVecI16x8'], left, right);
    },
    'lt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtUVecI16x8'], left, right);
    },
    'gt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtSVecI16x8'], left, right);
    },
    'gt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtUVecI16x8'], left, right);
    },
    'le_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeSVecI16x8'], left, right);
    },
    'le_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeUVecI16x8'], left, right);
    },
    'ge_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeSVecI16x8'], left, right);
    },
    'ge_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeUVecI16x8'], left, right);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsVecI16x8'], value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecI16x8'], value);
    },
    'any_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AnyTrueVecI16x8'], value);
    },
    'all_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AllTrueVecI16x8'], value);
    },
    'bitmask'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['BitmaskVecI16x8'], value);
    },
    'shl'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShlVecI16x8'], vec, shift);
    },
    'shr_s'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrSVecI16x8'], vec, shift);
    },
    'shr_u'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrUVecI16x8'], vec, shift);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecI16x8'], left, right);
    },
    'add_saturate_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddSatSVecI16x8'], left, right);
    },
    'add_saturate_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddSatUVecI16x8'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecI16x8'], left, right);
    },
    'sub_saturate_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubSatSVecI16x8'], left, right);
    },
    'sub_saturate_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubSatUVecI16x8'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecI16x8'], left, right);
    },
    'min_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinSVecI16x8'], left, right);
    },
    'min_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinUVecI16x8'], left, right);
    },
    'max_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxSVecI16x8'], left, right);
    },
    'max_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxUVecI16x8'], left, right);
    },
    'avgr_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AvgrUVecI16x8'], left, right);
    },
    'narrow_i32x4_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NarrowSVecI32x4ToVecI16x8'], left, right);
    },
    'narrow_i32x4_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NarrowUVecI32x4ToVecI16x8'], left, right);
    },
    'widen_low_i8x16_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenLowSVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenHighSVecI8x16ToVecI16x8'], value);
    },
    'widen_low_i8x16_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenLowUVecI8x16ToVecI16x8'], value);
    },
    'widen_high_i8x16_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenHighUVecI8x16ToVecI16x8'], value);
    },
    'load8x8_s'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtSVec8x8ToVecI16x8'], offset, align, ptr);
    },
    'load8x8_u'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtUVec8x8ToVecI16x8'], offset, align, ptr);
    },
  };

  self['i32x4'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecI32x4'], value);
    },
    'extract_lane'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneVecI32x4'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecI32x4'], vec, index, value);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqVecI32x4'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeVecI32x4'], left, right);
    },
    'lt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtSVecI32x4'], left, right);
    },
    'lt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtUVecI32x4'], left, right);
    },
    'gt_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtSVecI32x4'], left, right);
    },
    'gt_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtUVecI32x4'], left, right);
    },
    'le_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeSVecI32x4'], left, right);
    },
    'le_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeUVecI32x4'], left, right);
    },
    'ge_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeSVecI32x4'], left, right);
    },
    'ge_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeUVecI32x4'], left, right);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsVecI32x4'], value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecI32x4'], value);
    },
    'any_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AnyTrueVecI32x4'], value);
    },
    'all_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AllTrueVecI32x4'], value);
    },
    'bitmask'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['BitmaskVecI32x4'], value);
    },
    'shl'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShlVecI32x4'], vec, shift);
    },
    'shr_s'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrSVecI32x4'], vec, shift);
    },
    'shr_u'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrUVecI32x4'], vec, shift);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecI32x4'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecI32x4'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecI32x4'], left, right);
    },
    'min_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinSVecI32x4'], left, right);
    },
    'min_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinUVecI32x4'], left, right);
    },
    'max_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxSVecI32x4'], left, right);
    },
    'max_u'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxUVecI32x4'], left, right);
    },
    'dot_i16x8_s'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DotSVecI16x8ToVecI32x4'], left, right);
    },
    'trunc_sat_f32x4_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncSatSVecF32x4ToVecI32x4'], value);
    },
    'trunc_sat_f32x4_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncSatUVecF32x4ToVecI32x4'], value);
    },
    'widen_low_i16x8_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenLowSVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenHighSVecI16x8ToVecI32x4'], value);
    },
    'widen_low_i16x8_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenLowUVecI16x8ToVecI32x4'], value);
    },
    'widen_high_i16x8_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['WidenHighUVecI16x8ToVecI32x4'], value);
    },
    'load16x4_s'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtSVec16x4ToVecI32x4'], offset, align, ptr);
    },
    'load16x4_u'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtUVec16x4ToVecI32x4'], offset, align, ptr);
    },
  };

  self['i64x2'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecI64x2'], value);
    },
    'extract_lane'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneVecI64x2'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecI64x2'], vec, index, value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecI64x2'], value);
    },
    'any_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AnyTrueVecI64x2'], value);
    },
    'all_true'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AllTrueVecI64x2'], value);
    },
    'shl'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShlVecI64x2'], vec, shift);
    },
    'shr_s'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrSVecI64x2'], vec, shift);
    },
    'shr_u'(vec, shift) {
      return MODULE['_BinaryenSIMDShift'](module, Operations['ShrUVecI64x2'], vec, shift);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecI64x2'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecI64x2'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecI64x2'], left, right);
    },
    'trunc_sat_f64x2_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncSatSVecF64x2ToVecI64x2'], value);
    },
    'trunc_sat_f64x2_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncSatUVecF64x2ToVecI64x2'], value);
    },
    'load32x2_s'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtSVec32x2ToVecI64x2'], offset, align, ptr);
    },
    'load32x2_u'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadExtUVec32x2ToVecI64x2'], offset, align, ptr);
    },
  };

  self['f32x4'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecF32x4'], value);
    },
    'extract_lane'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneVecF32x4'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecF32x4'], vec, index, value);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqVecF32x4'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeVecF32x4'], left, right);
    },
    'lt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtVecF32x4'], left, right);
    },
    'gt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtVecF32x4'], left, right);
    },
    'le'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeVecF32x4'], left, right);
    },
    'ge'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeVecF32x4'], left, right);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsVecF32x4'], value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecF32x4'], value);
    },
    'sqrt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SqrtVecF32x4'], value);
    },
    'qfma'(a, b, c) {
      return MODULE['_BinaryenSIMDTernary'](module, Operations['QFMAVecF32x4'], a, b, c);
    },
    'qfms'(a, b, c) {
      return MODULE['_BinaryenSIMDTernary'](module, Operations['QFMSVecF32x4'], a, b, c);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecF32x4'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecF32x4'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecF32x4'], left, right);
    },
    'div'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivVecF32x4'], left, right);
    },
    'min'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinVecF32x4'], left, right);
    },
    'max'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxVecF32x4'], left, right);
    },
    'pmin'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['PMinVecF32x4'], left, right);
    },
    'pmax'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['PMaxVecF32x4'], left, right);
    },
    'ceil'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CeilVecF32x4'], value);
    },
    'floor'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['FloorVecF32x4'], value);
    },
    'trunc'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncVecF32x4'], value);
    },
    'nearest'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NearestVecF32x4'], value);
    },
    'convert_i32x4_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ConvertSVecI32x4ToVecF32x4'], value);
    },
    'convert_i32x4_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ConvertUVecI32x4ToVecF32x4'], value);
    },
  };

  self['f64x2'] = {
    'splat'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SplatVecF64x2'], value);
    },
    'extract_lane'(vec, index) {
      return MODULE['_BinaryenSIMDExtract'](module, Operations['ExtractLaneVecF64x2'], vec, index);
    },
    'replace_lane'(vec, index, value) {
      return MODULE['_BinaryenSIMDReplace'](module, Operations['ReplaceLaneVecF64x2'], vec, index, value);
    },
    'eq'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['EqVecF64x2'], left, right);
    },
    'ne'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['NeVecF64x2'], left, right);
    },
    'lt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LtVecF64x2'], left, right);
    },
    'gt'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GtVecF64x2'], left, right);
    },
    'le'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['LeVecF64x2'], left, right);
    },
    'ge'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['GeVecF64x2'], left, right);
    },
    'abs'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['AbsVecF64x2'], value);
    },
    'neg'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NegVecF64x2'], value);
    },
    'sqrt'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['SqrtVecF64x2'], value);
    },
    'qfma'(a, b, c) {
      return MODULE['_BinaryenSIMDTernary'](module, Operations['QFMAVecF64x2'], a, b, c);
    },
    'qfms'(a, b, c) {
      return MODULE['_BinaryenSIMDTernary'](module, Operations['QFMSVecF64x2'], a, b, c);
    },
    'add'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['AddVecF64x2'], left, right);
    },
    'sub'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SubVecF64x2'], left, right);
    },
    'mul'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MulVecF64x2'], left, right);
    },
    'div'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['DivVecF64x2'], left, right);
    },
    'min'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MinVecF64x2'], left, right);
    },
    'max'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['MaxVecF64x2'], left, right);
    },
    'pmin'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['PMinVecF64x2'], left, right);
    },
    'pmax'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['PMaxVecF64x2'], left, right);
    },
    'ceil'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['CeilVecF64x2'], value);
    },
    'floor'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['FloorVecF64x2'], value);
    },
    'trunc'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['TruncVecF64x2'], value);
    },
    'nearest'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['NearestVecF64x2'], value);
    },
    'convert_i64x2_s'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ConvertSVecI64x2ToVecF64x2'], value);
    },
    'convert_i64x2_u'(value) {
      return MODULE['_BinaryenUnary'](module, Operations['ConvertUVecI64x2ToVecF64x2'], value);
    },
  };

  self['v8x16'] = {
    'shuffle'(left, right, mask) {
      return preserveStack(() => MODULE['_BinaryenSIMDShuffle'](module, left, right, i8sToStack(mask)));
    },
    'swizzle'(left, right) {
      return MODULE['_BinaryenBinary'](module, Operations['SwizzleVec8x16'], left, right);
    },
    'load_splat'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadSplatVec8x16'], offset, align, ptr);
    },
  };

  self['v16x8'] = {
    'load_splat'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadSplatVec16x8'], offset, align, ptr);
    },
  };

  self['v32x4'] = {
    'load_splat'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadSplatVec32x4'], offset, align, ptr);
    },
  };

  self['v64x2'] = {
    'load_splat'(offset, align, ptr) {
      return MODULE['_BinaryenSIMDLoad'](module, Operations['LoadSplatVec64x2'], offset, align, ptr);
    },
  };

  self['funcref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['funcref']);
    }
  };

  self['externref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['externref']);
    }
  };

  self['exnref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['exnref']);
    }
  };

  self['anyref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['anyref']);
    }
  };

  self['eqref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['eqref']);
    }
  };

  self['i31ref'] = {
    'pop'() {
      return MODULE['_BinaryenPop'](module, Types['i31ref']);
    }
  };

  self['ref'] = {
    'null'(type) {
      return MODULE['_BinaryenRefNull'](module, type);
    },
    'is_null'(value) {
      return MODULE['_BinaryenRefIsNull'](module, value);
    },
    'func'(func) {
      return preserveStack(() => MODULE['_BinaryenRefFunc'](module, strToStack(func)));
    },
    'eq'(left, right) {
      return MODULE['_BinaryenRefEq'](module, left, right);
    }
  };

  self['select'] = function(condition, ifTrue, ifFalse, type) {
    return MODULE['_BinaryenSelect'](module, condition, ifTrue, ifFalse, typeof type !== 'undefined' ? type : Types['auto']);
  };
  self['drop'] = function(value) {
    return MODULE['_BinaryenDrop'](module, value);
  };
  self['return'] = function(value) {
    return MODULE['_BinaryenReturn'](module, value);
  };
  self['nop'] = function() {
    return MODULE['_BinaryenNop'](module);
  };
  self['unreachable'] = function() {
    return MODULE['_BinaryenUnreachable'](module);
  };

  self['atomic'] = {
    'notify'(ptr, notifyCount) {
      return MODULE['_BinaryenAtomicNotify'](module, ptr, notifyCount);
    },
    'fence'() {
      return MODULE['_BinaryenAtomicFence'](module);
    }
  };

  self['try'] = function(body, catchBody) {
    return MODULE['_BinaryenTry'](module, body, catchBody);
  };
  self['throw'] = function(event_, operands) {
    return preserveStack(() => MODULE['_BinaryenThrow'](module, strToStack(event_), i32sToStack(operands), operands.length));
  };
  self['rethrow'] = function(exnref) {
    return MODULE['_BinaryenRethrow'](module, exnref);
  };
  self['br_on_exn'] = function(label, event_, exnref) {
    return preserveStack(() => MODULE['_BinaryenBrOnExn'](module, strToStack(label), strToStack(event_), exnref));
  };

  self['tuple'] = {
    'make'(elements) {
      return preserveStack(() => MODULE['_BinaryenTupleMake'](module, i32sToStack(elements), elements.length));
    },
    'extract'(tuple, index) {
      return MODULE['_BinaryenTupleExtract'](module, tuple, index);
    }
  };

  self['i31'] = {
    'new'(value) {
      return MODULE['_BinaryenI31New'](module, value);
    },
    'get_s'(i31) {
      return MODULE['_BinaryenI31Get'](module, i31, 1);
    },
    'get_u'(i31) {
      return MODULE['_BinaryenI31Get'](module, i31, 0);
    }
  };

  // 'Module' operations
  self['addFunction'] = function(name, params, results, varTypes, body) {
    return preserveStack(() =>
      MODULE['_BinaryenAddFunction'](module, strToStack(name), params, results, i32sToStack(varTypes), varTypes.length, body)
    );
  };
  self['getFunction'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenGetFunction'](module, strToStack(name)));
  };
  self['removeFunction'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenRemoveFunction'](module, strToStack(name)));
  };
  self['addGlobal'] = function(name, type, mutable, init) {
    return preserveStack(() => MODULE['_BinaryenAddGlobal'](module, strToStack(name), type, mutable, init));
  }
  self['getGlobal'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenGetGlobal'](module, strToStack(name)));
  };
  self['removeGlobal'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenRemoveGlobal'](module, strToStack(name)));
  }
  self['addEvent'] = function(name, attribute, params, results) {
    return preserveStack(() => MODULE['_BinaryenAddEvent'](module, strToStack(name), attribute, params, results));
  };
  self['getEvent'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenGetEvent'](module, strToStack(name)));
  };
  self['removeEvent'] = function(name) {
    return preserveStack(() => MODULE['_BinaryenRemoveEvent'](module, strToStack(name)));
  };
  self['addFunctionImport'] = function(internalName, externalModuleName, externalBaseName, params, results) {
    return preserveStack(() =>
      MODULE['_BinaryenAddFunctionImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), params, results)
    );
  };
  self['addTableImport'] = function(internalName, externalModuleName, externalBaseName) {
    return preserveStack(() =>
      MODULE['_BinaryenAddTableImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName))
    );
  };
  self['addMemoryImport'] = function(internalName, externalModuleName, externalBaseName, shared) {
    return preserveStack(() =>
      MODULE['_BinaryenAddMemoryImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), shared)
    );
  };
  self['addGlobalImport'] = function(internalName, externalModuleName, externalBaseName, globalType, mutable) {
    return preserveStack(() =>
      MODULE['_BinaryenAddGlobalImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), globalType, mutable)
    );
  };
  self['addEventImport'] = function(internalName, externalModuleName, externalBaseName, attribute, params, results) {
    return preserveStack(() =>
      MODULE['_BinaryenAddEventImport'](module, strToStack(internalName), strToStack(externalModuleName), strToStack(externalBaseName), attribute, params, results)
    );
  };
  self['addExport'] = // deprecated
  self['addFunctionExport'] = function(internalName, externalName) {
    return preserveStack(() => MODULE['_BinaryenAddFunctionExport'](module, strToStack(internalName), strToStack(externalName)));
  };
  self['addTableExport'] = function(internalName, externalName) {
    return preserveStack(() => MODULE['_BinaryenAddTableExport'](module, strToStack(internalName), strToStack(externalName)));
  };
  self['addMemoryExport'] = function(internalName, externalName) {
    return preserveStack(() => MODULE['_BinaryenAddMemoryExport'](module, strToStack(internalName), strToStack(externalName)));
  };
  self['addGlobalExport'] = function(internalName, externalName) {
    return preserveStack(() => MODULE['_BinaryenAddGlobalExport'](module, strToStack(internalName), strToStack(externalName)));
  };
  self['addEventExport'] = function(internalName, externalName) {
    return preserveStack(() => MODULE['_BinaryenAddEventExport'](module, strToStack(internalName), strToStack(externalName)));
  };
  self['removeExport'] = function(externalName) {
    return preserveStack(() => MODULE['_BinaryenRemoveExport'](module, strToStack(externalName)));
  };
  self['setFunctionTable'] = function(initial, maximum, funcNames, offset = self['i32']['const'](0)) {
    return preserveStack(() => {
      return MODULE['_BinaryenSetFunctionTable'](module, initial, maximum,
        i32sToStack(funcNames.map(strToStack)),
        funcNames.length,
        offset
      );
    });
  };
  self['getFunctionTable'] = function() {
    return {
      'imported': Boolean(MODULE['_BinaryenIsFunctionTableImported'](module)),
      'segments': (function() {
        const numSegments = MODULE['_BinaryenGetNumFunctionTableSegments'](module)
        const arr = new Array(numSegments);
        for (let i = 0; i !== numSegments; ++i) {
          const segmentLength = MODULE['_BinaryenGetFunctionTableSegmentLength'](module, i);
          const names = new Array(segmentLength);
          for (let j = 0; j !== segmentLength; ++j) {
            const ptr = MODULE['_BinaryenGetFunctionTableSegmentData'](module, i, j);
            names[j] = UTF8ToString(ptr);
          }
          arr[i] = {
            'offset': MODULE['_BinaryenGetFunctionTableSegmentOffset'](module, i),
            'names': names
          };
        }
        return arr;
      })()
    };
  };
  self['setMemory'] = function(initial, maximum, exportName, segments = [], shared = false) {
    // segments are assumed to be { passive: bool, offset: expression ref, data: array of 8-bit data }
    return preserveStack(() => {
      const segmentsLen = segments.length;
      const segmentData = new Array(segmentsLen);
      const segmentDataLen = new Array(segmentsLen);
      const segmentPassive = new Array(segmentsLen);
      const segmentOffset = new Array(segmentsLen);
      for (let i = 0; i < segmentsLen; i++) {
        const { data, offset, passive } = segments[i];
        segmentData[i] = allocate(data, 'i8', ALLOC_STACK);
        segmentDataLen[i] = data.length;
        segmentPassive[i] = passive;
        segmentOffset[i] = offset;
      }
      return MODULE['_BinaryenSetMemory'](
        module, initial, maximum, strToStack(exportName),
        i32sToStack(segmentData),
        i8sToStack(segmentPassive),
        i32sToStack(segmentOffset),
        i32sToStack(segmentDataLen),
        segmentsLen,
        shared
      );
    });
  };
  self['getNumMemorySegments'] = function() {
    return MODULE['_BinaryenGetNumMemorySegments'](module);
  }
  self['getMemorySegmentInfoByIndex'] = function(id) {
    return {
      'offset': MODULE['_BinaryenGetMemorySegmentByteOffset'](module, id),
      'data': (function(){
        const size = MODULE['_BinaryenGetMemorySegmentByteLength'](module, id);
        const ptr = _malloc(size);
        MODULE['_BinaryenCopyMemorySegmentData'](module, id, ptr);
        const res = new Uint8Array(size);
        res.set(new Uint8Array(buffer, ptr, size));
        _free(ptr);
        return res.buffer;
      })(),
      'passive': Boolean(MODULE['_BinaryenGetMemorySegmentPassive'](module, id))
    };
  }
  self['setStart'] = function(start) {
    return MODULE['_BinaryenSetStart'](module, start);
  };
  self['getFeatures'] = function() {
    return MODULE['_BinaryenModuleGetFeatures'](module);
  };
  self['setFeatures'] = function(features) {
    MODULE['_BinaryenModuleSetFeatures'](module, features);
  };
  self['addCustomSection'] = function(name, contents) {
    return preserveStack(() =>
      MODULE['_BinaryenAddCustomSection'](module, strToStack(name), i8sToStack(contents), contents.length)
    );
  };
  self['getNumExports'] = function() {
    return MODULE['_BinaryenGetNumExports'](module);
  }
  self['getExportByIndex'] = function(id) {
    return MODULE['_BinaryenGetExportByIndex'](module, id);
  }
  self['getNumFunctions'] = function() {
    return MODULE['_BinaryenGetNumFunctions'](module);
  }
  self['getFunctionByIndex'] = function(id) {
    return MODULE['_BinaryenGetFunctionByIndex'](module, id);
  }
  self['emitText'] = function() {
    const old = out;
    let ret = '';
    out = x => { ret += x + '\n' };
    MODULE['_BinaryenModulePrint'](module);
    out = old;
    return ret;
  };
  self['emitStackIR'] = function(optimize) {
    self['runPasses'](['generate-stack-ir']);
    if (optimize) self['runPasses'](['optimize-stack-ir']);
    const old = out;
    let ret = '';
    out = x => { ret += x + '\n' };
    self['runPasses'](['print-stack-ir']);
    out = old;
    return ret;
  };
  self['emitAsmjs'] = function() {
    const old = out;
    let ret = '';
    out = x => { ret += x + '\n' };
    MODULE['_BinaryenModulePrintAsmjs'](module);
    out = old;
    return ret;
  };
  self['validate'] = function() {
    return MODULE['_BinaryenModuleValidate'](module);
  };
  self['optimize'] = function() {
    return MODULE['_BinaryenModuleOptimize'](module);
  };
  self['optimizeFunction'] = function(func) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return MODULE['_BinaryenFunctionOptimize'](func, module);
  };
  self['runPasses'] = function(passes) {
    return preserveStack(() =>
      MODULE['_BinaryenModuleRunPasses'](module, i32sToStack(passes.map(strToStack)), passes.length)
    );
  };
  self['runPassesOnFunction'] = function(func, passes) {
    if (typeof func === 'string') func = self['getFunction'](func);
    return preserveStack(() =>
      MODULE['_BinaryenFunctionRunPasses'](func, module, i32sToStack(passes.map(strToStack)), passes.length)
    );
  };
  self['autoDrop'] = function() {
    return MODULE['_BinaryenModuleAutoDrop'](module);
  };
  self['dispose'] = function() {
    MODULE['_BinaryenModuleDispose'](module);
  };
  self['emitBinary'] = function(sourceMapUrl) {
    return preserveStack(() => {
      const tempBuffer = stackAlloc(_BinaryenSizeofAllocateAndWriteResult());
      MODULE['_BinaryenModuleAllocateAndWrite'](tempBuffer, module, strToStack(sourceMapUrl));
      const binaryPtr    = HEAPU32[ tempBuffer >>> 2     ];
      const binaryBytes  = HEAPU32[(tempBuffer >>> 2) + 1];
      const sourceMapPtr = HEAPU32[(tempBuffer >>> 2) + 2];
      try {
        const buffer = new Uint8Array(binaryBytes);
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
    return MODULE['_BinaryenModuleInterpret'](module);
  };
  self['addDebugInfoFileName'] = function(filename) {
    return preserveStack(() => MODULE['_BinaryenModuleAddDebugInfoFileName'](module, strToStack(filename)));
  };
  self['getDebugInfoFileName'] = function(index) {
    return UTF8ToString(MODULE['_BinaryenModuleGetDebugInfoFileName'](module, index));
  };
  self['setDebugLocation'] = function(func, expr, fileIndex, lineNumber, columnNumber) {
    return MODULE['_BinaryenFunctionSetDebugLocation'](func, expr, fileIndex, lineNumber, columnNumber);
  };
  self['copyExpression'] = function(expr) {
    return MODULE['_BinaryenExpressionCopy'](expr, module);
  };

  return self;
}
MODULE['wrapModule'] = wrapModule;

// 'Relooper' interface
MODULE['Relooper'] = function(module) {
  assert(module && typeof module === 'object' && module['ptr'] && module['block'] && module['if']); // guard against incorrect old API usage
  const relooper = MODULE['_RelooperCreate'](module['ptr']);
  this['ptr'] = relooper;

  this['addBlock'] = function(code) {
    return MODULE['_RelooperAddBlock'](relooper, code);
  };
  this['addBranch'] = function(from, to, condition, code) {
    return MODULE['_RelooperAddBranch'](from, to, condition, code);
  };
  this['addBlockWithSwitch'] = function(code, condition) {
    return MODULE['_RelooperAddBlockWithSwitch'](relooper, code, condition);
  };
  this['addBranchForSwitch'] = function(from, to, indexes, code) {
    return preserveStack(() => MODULE['_RelooperAddBranchForSwitch'](from, to, i32sToStack(indexes), indexes.length, code));
  };
  this['renderAndDispose'] = function(entry, labelHelper) {
    return MODULE['_RelooperRenderAndDispose'](relooper, entry, labelHelper);
  };
};

// 'ExpressionRunner' interface
export function ExpressionRunner(module, flags, maxDepth, maxLoopIterations) {
  const runner = MODULE['_ExpressionRunnerCreate'](module['ptr'], flags, maxDepth, maxLoopIterations);
  this['ptr'] = runner;

  this['setLocalValue'] = function(index, valueExpr) {
    return Boolean(MODULE['_ExpressionRunnerSetLocalValue'](runner, index, valueExpr));
  };
  this['setGlobalValue'] = function(name, valueExpr) {
    return preserveStack(() => Boolean(MODULE['_ExpressionRunnerSetGlobalValue'](runner, strToStack(name), valueExpr)));
  };
  this['runAndDispose'] = function(expr) {
    return MODULE['_ExpressionRunnerRunAndDispose'](runner, expr);
  };
}
ExpressionRunner['Flags'] = {};

function getAllNested(ref, numFn, getFn) {
  const num = numFn(ref);
  const ret = new Array(num);
  for (let i = 0; i < num; ++i) ret[i] = getFn(ref, i);
  return ret;
}

// Gets the specific id of an 'Expression'
export function getExpressionId(expr) {
  return MODULE['_BinaryenExpressionGetId'](expr);
};

// Gets the result type of an 'Expression'
export function getExpressionType(expr) {
  return MODULE['_BinaryenExpressionGetType'](expr);
};

// Obtains information about an 'Expression'
export  function getExpressionInfo(expr) {
  const id = MODULE['_BinaryenExpressionGetId'](expr);
  const type = MODULE['_BinaryenExpressionGetType'](expr);
  switch (id) {
    case ExpressionIds['Block']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenBlockGetName'](expr)),
        'children': getAllNested(expr, MODULE['_BinaryenBlockGetNumChildren'], MODULE['_BinaryenBlockGetChildAt'])
      };
    case ExpressionIds['If']:
      return {
        'id': id,
        'type': type,
        'condition': MODULE['_BinaryenIfGetCondition'](expr),
        'ifTrue': MODULE['_BinaryenIfGetIfTrue'](expr),
        'ifFalse': MODULE['_BinaryenIfGetIfFalse'](expr)
      };
    case ExpressionIds['Loop']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenLoopGetName'](expr)),
        'body': MODULE['_BinaryenLoopGetBody'](expr)
      };
    case ExpressionIds['Break']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenBreakGetName'](expr)),
        'condition': MODULE['_BinaryenBreakGetCondition'](expr),
        'value': MODULE['_BinaryenBreakGetValue'](expr)
      };
    case ExpressionIds['Switch']:
      return {
        'id': id,
        'type': type,
         // Do not pass the index as the second parameter to UTF8ToString as that will cut off the string.
        'names': getAllNested(expr, MODULE['_BinaryenSwitchGetNumNames'], MODULE['_BinaryenSwitchGetNameAt']).map(p => UTF8ToString(p)),
        'defaultName': UTF8ToString(MODULE['_BinaryenSwitchGetDefaultName'](expr)),
        'condition': MODULE['_BinaryenSwitchGetCondition'](expr),
        'value': MODULE['_BinaryenSwitchGetValue'](expr)
      };
    case ExpressionIds['Call']:
      return {
        'id': id,
        'type': type,
        'isReturn': Boolean(MODULE['_BinaryenCallIsReturn'](expr)),
        'target': UTF8ToString(MODULE['_BinaryenCallGetTarget'](expr)),
        'operands': getAllNested(expr, MODULE[ '_BinaryenCallGetNumOperands'], MODULE['_BinaryenCallGetOperandAt'])
      };
    case ExpressionIds['CallIndirect']:
      return {
        'id': id,
        'type': type,
        'isReturn': Boolean(MODULE['_BinaryenCallIndirectIsReturn'](expr)),
        'target': MODULE['_BinaryenCallIndirectGetTarget'](expr),
        'operands': getAllNested(expr, MODULE['_BinaryenCallIndirectGetNumOperands'], MODULE['_BinaryenCallIndirectGetOperandAt'])
      };
    case ExpressionIds['LocalGet']:
      return {
        'id': id,
        'type': type,
        'index': MODULE['_BinaryenLocalGetGetIndex'](expr)
      };
    case ExpressionIds['LocalSet']:
      return {
        'id': id,
        'type': type,
        'isTee': Boolean(MODULE['_BinaryenLocalSetIsTee'](expr)),
        'index': MODULE['_BinaryenLocalSetGetIndex'](expr),
        'value': MODULE['_BinaryenLocalSetGetValue'](expr)
      };
    case ExpressionIds['GlobalGet']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenGlobalGetGetName'](expr))
      };
    case ExpressionIds['GlobalSet']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenGlobalSetGetName'](expr)),
        'value': MODULE['_BinaryenGlobalSetGetValue'](expr)
      };
    case ExpressionIds['Load']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(MODULE['_BinaryenLoadIsAtomic'](expr)),
        'isSigned': Boolean(MODULE['_BinaryenLoadIsSigned'](expr)),
        'offset': MODULE['_BinaryenLoadGetOffset'](expr),
        'bytes': MODULE['_BinaryenLoadGetBytes'](expr),
        'align': MODULE['_BinaryenLoadGetAlign'](expr),
        'ptr': MODULE['_BinaryenLoadGetPtr'](expr)
      };
    case ExpressionIds['Store']:
      return {
        'id': id,
        'type': type,
        'isAtomic': Boolean(MODULE['_BinaryenStoreIsAtomic'](expr)),
        'offset': MODULE['_BinaryenStoreGetOffset'](expr),
        'bytes': MODULE['_BinaryenStoreGetBytes'](expr),
        'align': MODULE['_BinaryenStoreGetAlign'](expr),
        'ptr': MODULE['_BinaryenStoreGetPtr'](expr),
        'value': MODULE['_BinaryenStoreGetValue'](expr)
      };
    case ExpressionIds['Const']: {
      let value;
      switch (type) {
        case Types['i32']: value = MODULE['_BinaryenConstGetValueI32'](expr); break;
        case Types['i64']: value = {
          'low':  MODULE['_BinaryenConstGetValueI64Low'](expr),
          'high': MODULE['_BinaryenConstGetValueI64High'](expr)
        }; break;
        case Types['f32']: value = MODULE['_BinaryenConstGetValueF32'](expr); break;
        case Types['f64']: value = MODULE['_BinaryenConstGetValueF64'](expr); break;
        case Types['v128']: {
          preserveStack(() => {
            const tempBuffer = stackAlloc(16);
            MODULE['_BinaryenConstGetValueV128'](expr, tempBuffer);
            value = new Array(16);
            for (let i = 0; i < 16; i++) {
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
    case ExpressionIds['Unary']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenUnaryGetOp'](expr),
        'value': MODULE['_BinaryenUnaryGetValue'](expr)
      };
    case ExpressionIds['Binary']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenBinaryGetOp'](expr),
        'left': MODULE['_BinaryenBinaryGetLeft'](expr),
        'right':  MODULE['_BinaryenBinaryGetRight'](expr)
      };
    case ExpressionIds['Select']:
      return {
        'id': id,
        'type': type,
        'ifTrue': MODULE['_BinaryenSelectGetIfTrue'](expr),
        'ifFalse': MODULE['_BinaryenSelectGetIfFalse'](expr),
        'condition': MODULE['_BinaryenSelectGetCondition'](expr)
      };
    case ExpressionIds['Drop']:
      return {
        'id': id,
        'type': type,
        'value': MODULE['_BinaryenDropGetValue'](expr)
      };
    case ExpressionIds['Return']:
      return {
        'id': id,
        'type': type,
        'value': MODULE['_BinaryenReturnGetValue'](expr)
      };
    case ExpressionIds['Nop']:
    case ExpressionIds['Unreachable']:
    case ExpressionIds['Pop']:
      return {
        'id': id,
        'type': type
      };
    case ExpressionIds['MemorySize']:
      return {
        'id': id,
        'type': type
      };
    case ExpressionIds['MemoryGrow']:
      return {
        'id': id,
        'type': type,
        'delta': MODULE['_BinaryenMemoryGrowGetDelta'](expr)
      }
    case ExpressionIds['AtomicRMW']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenAtomicRMWGetOp'](expr),
        'bytes': MODULE['_BinaryenAtomicRMWGetBytes'](expr),
        'offset': MODULE['_BinaryenAtomicRMWGetOffset'](expr),
        'ptr': MODULE['_BinaryenAtomicRMWGetPtr'](expr),
        'value': MODULE['_BinaryenAtomicRMWGetValue'](expr)
      };
    case ExpressionIds['AtomicCmpxchg']:
      return {
        'id': id,
        'type': type,
        'bytes': MODULE['_BinaryenAtomicCmpxchgGetBytes'](expr),
        'offset': MODULE['_BinaryenAtomicCmpxchgGetOffset'](expr),
        'ptr': MODULE['_BinaryenAtomicCmpxchgGetPtr'](expr),
        'expected': MODULE['_BinaryenAtomicCmpxchgGetExpected'](expr),
        'replacement': MODULE['_BinaryenAtomicCmpxchgGetReplacement'](expr)
      };
    case ExpressionIds['AtomicWait']:
      return {
        'id': id,
        'type': type,
        'ptr': MODULE['_BinaryenAtomicWaitGetPtr'](expr),
        'expected': MODULE['_BinaryenAtomicWaitGetExpected'](expr),
        'timeout': MODULE['_BinaryenAtomicWaitGetTimeout'](expr),
        'expectedType': MODULE['_BinaryenAtomicWaitGetExpectedType'](expr)
      };
    case ExpressionIds['AtomicNotify']:
      return {
        'id': id,
        'type': type,
        'ptr': MODULE['_BinaryenAtomicNotifyGetPtr'](expr),
        'notifyCount': MODULE['_BinaryenAtomicNotifyGetNotifyCount'](expr)
      };
    case ExpressionIds['AtomicFence']:
      return {
        'id': id,
        'type': type,
        'order': MODULE['_BinaryenAtomicFenceGetOrder'](expr)
      };
    case ExpressionIds['SIMDExtract']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenSIMDExtractGetOp'](expr),
        'vec': MODULE['_BinaryenSIMDExtractGetVec'](expr),
        'index': MODULE['_BinaryenSIMDExtractGetIndex'](expr)
      };
    case ExpressionIds['SIMDReplace']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenSIMDReplaceGetOp'](expr),
        'vec': MODULE['_BinaryenSIMDReplaceGetVec'](expr),
        'index': MODULE['_BinaryenSIMDReplaceGetIndex'](expr),
        'value': MODULE['_BinaryenSIMDReplaceGetValue'](expr)
      };
    case ExpressionIds['SIMDShuffle']:
      return preserveStack(() => {
        const tempBuffer = stackAlloc(16);
        MODULE['_BinaryenSIMDShuffleGetMask'](expr, tempBuffer);
        const mask = new Array(16);
        for (let i = 0; i < 16; i++) {
          mask[i] = HEAPU8[tempBuffer + i];
        }
        return {
          'id': id,
          'type': type,
          'left': MODULE['_BinaryenSIMDShuffleGetLeft'](expr),
          'right': MODULE['_BinaryenSIMDShuffleGetRight'](expr),
          'mask': mask
        };
      });
    case ExpressionIds['SIMDTernary']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenSIMDTernaryGetOp'](expr),
        'a': MODULE['_BinaryenSIMDTernaryGetA'](expr),
        'b': MODULE['_BinaryenSIMDTernaryGetB'](expr),
        'c': MODULE['_BinaryenSIMDTernaryGetC'](expr)
      };
    case ExpressionIds['SIMDShift']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenSIMDShiftGetOp'](expr),
        'vec': MODULE['_BinaryenSIMDShiftGetVec'](expr),
        'shift': MODULE['_BinaryenSIMDShiftGetShift'](expr)
      };
    case ExpressionIds['SIMDLoad']:
      return {
        'id': id,
        'type': type,
        'op': MODULE['_BinaryenSIMDLoadGetOp'](expr),
        'offset': MODULE['_BinaryenSIMDLoadGetOffset'](expr),
        'align': MODULE['_BinaryenSIMDLoadGetAlign'](expr),
        'ptr': MODULE['_BinaryenSIMDLoadGetPtr'](expr)
      };
    case ExpressionIds['MemoryInit']:
      return {
        'id': id,
        'segment': MODULE['_BinaryenMemoryInitGetSegment'](expr),
        'dest': MODULE['_BinaryenMemoryInitGetDest'](expr),
        'offset': MODULE['_BinaryenMemoryInitGetOffset'](expr),
        'size': MODULE['_BinaryenMemoryInitGetSize'](expr)
      };
    case ExpressionIds['DataDrop']:
      return {
        'id': id,
        'segment': MODULE['_BinaryenDataDropGetSegment'](expr),
      };
    case ExpressionIds['MemoryCopy']:
      return {
        'id': id,
        'dest': MODULE['_BinaryenMemoryCopyGetDest'](expr),
        'source': MODULE['_BinaryenMemoryCopyGetSource'](expr),
        'size': MODULE['_BinaryenMemoryCopyGetSize'](expr)
      };
    case ExpressionIds['MemoryFill']:
      return {
        'id': id,
        'dest': MODULE['_BinaryenMemoryFillGetDest'](expr),
        'value': MODULE['_BinaryenMemoryFillGetValue'](expr),
        'size': MODULE['_BinaryenMemoryFillGetSize'](expr)
      };
    case ExpressionIds['RefNull']:
      return {
        'id': id,
        'type': type
      };
    case ExpressionIds['RefIsNull']:
      return {
        'id': id,
        'type': type,
        'value': MODULE['_BinaryenRefIsNullGetValue'](expr)
      };
    case ExpressionIds['RefFunc']:
      return {
        'id': id,
        'type': type,
        'func': UTF8ToString(MODULE['_BinaryenRefFuncGetFunc'](expr)),
      };
    case ExpressionIds['RefEq']:
      return {
        'id': id,
        'type': type,
        'left': MODULE['_BinaryenRefEqGetLeft'](expr),
        'right': MODULE['_BinaryenRefEqGetRight'](expr)
      };
    case ExpressionIds['Try']:
      return {
        'id': id,
        'type': type,
        'body': MODULE['_BinaryenTryGetBody'](expr),
        'catchBody': MODULE['_BinaryenTryGetCatchBody'](expr)
      };
    case ExpressionIds['Throw']:
      return {
        'id': id,
        'type': type,
        'event': UTF8ToString(MODULE['_BinaryenThrowGetEvent'](expr)),
        'operands': getAllNested(expr, MODULE['_BinaryenThrowGetNumOperands'], MODULE['_BinaryenThrowGetOperandAt'])
      };
    case ExpressionIds['Rethrow']:
      return {
        'id': id,
        'type': type,
        'exnref': MODULE['_BinaryenRethrowGetExnref'](expr)
      };
    case ExpressionIds['BrOnExn']:
      return {
        'id': id,
        'type': type,
        'name': UTF8ToString(MODULE['_BinaryenBrOnExnGetName'](expr)),
        'event': UTF8ToString(MODULE['_BinaryenBrOnExnGetEvent'](expr)),
        'exnref': MODULE['_BinaryenBrOnExnGetExnref'](expr)
      };
    case ExpressionIds['TupleMake']:
      return {
        'id': id,
        'type': type,
        'operands': getAllNested(expr, MODULE['_BinaryenTupleMakeGetNumOperands'], MODULE['_BinaryenTupleMakeGetOperandAt'])
      };
    case ExpressionIds['TupleExtract']:
      return {
        'id': id,
        'type': type,
        'tuple': MODULE['_BinaryenTupleExtractGetTuple'](expr),
        'index': MODULE['_BinaryenTupleExtractGetIndex'](expr)
      };
    case ExpressionIds['I31New']:
      return {
        'id': id,
        'type': type,
        'value': MODULE['_BinaryenI31NewGetValue'](expr)
      };
    case ExpressionIds['I31Get']:
      return {
        'id': id,
        'type': type,
        'i31': MODULE['_BinaryenI31GetGetI31'](expr),
        'isSigned': Boolean(MODULE['_BinaryenI31GetIsSigned'](expr))
      };

    default:
      throw Error('unexpected id: ' + id);
  }
};

// Gets the side effects of the specified expression
export function getSideEffects(expr, features) {
  return MODULE['_BinaryenExpressionGetSideEffects'](expr, features);
};

export function createType(types) {
  return preserveStack(() => MODULE['_BinaryenTypeCreate'](i32sToStack(types), types.length));
};

export function expandType(ty) {
  return preserveStack(() => {
    const numTypes = MODULE['_BinaryenTypeArity'](ty);
    const array = stackAlloc(numTypes << 2);
    MODULE['_BinaryenTypeExpand'](ty, array);
    const types = new Array(numTypes);
    for (let i = 0; i < numTypes; i++) {
      types[i] = HEAPU32[(array >>> 2) + i];
    }
    return types;
  });
};

// Obtains information about a 'Function'
export function getFunctionInfo(func) {
  return {
    'name': UTF8ToString(MODULE['_BinaryenFunctionGetName'](func)),
    'module': UTF8ToString(MODULE['_BinaryenFunctionImportGetModule'](func)),
    'base': UTF8ToString(MODULE['_BinaryenFunctionImportGetBase'](func)),
    'params': MODULE['_BinaryenFunctionGetParams'](func),
    'results': MODULE['_BinaryenFunctionGetResults'](func),
    'vars': getAllNested(func, MODULE['_BinaryenFunctionGetNumVars'], MODULE['_BinaryenFunctionGetVar']),
    'body': MODULE['_BinaryenFunctionGetBody'](func)
  };
};

// Obtains information about a 'Global'
export function getGlobalInfo(global) {
  return {
    'name': UTF8ToString(MODULE['_BinaryenGlobalGetName'](global)),
    'module': UTF8ToString(MODULE['_BinaryenGlobalImportGetModule'](global)),
    'base': UTF8ToString(MODULE['_BinaryenGlobalImportGetBase'](global)),
    'type': MODULE['_BinaryenGlobalGetType'](global),
    'mutable': Boolean(MODULE['_BinaryenGlobalIsMutable'](global)),
    'init': MODULE['_BinaryenGlobalGetInitExpr'](global)
  };
};

// Obtains information about a 'Event'
export function getEventInfo(event_) {
  return {
    'name': UTF8ToString(MODULE['_BinaryenEventGetName'](event_)),
    'module': UTF8ToString(MODULE['_BinaryenEventImportGetModule'](event_)),
    'base': UTF8ToString(MODULE['_BinaryenEventImportGetBase'](event_)),
    'attribute': MODULE['_BinaryenEventGetAttribute'](event_),
    'params': MODULE['_BinaryenEventGetParams'](event_),
    'results': MODULE['_BinaryenEventGetResults'](event_)
  };
};

// Obtains information about an 'Export'
export function getExportInfo(export_) {
  return {
    'kind': MODULE['_BinaryenExportGetKind'](export_),
    'name': UTF8ToString(MODULE['_BinaryenExportGetName'](export_)),
    'value': UTF8ToString(MODULE['_BinaryenExportGetValue'](export_))
  };
};

// Emits text format of an expression or a module
export function emitText(expr) {
  if (typeof expr === 'object') {
    return expr['emitText']();
  }
  const old = out;
  let ret = '';
  out = x => { ret += x + '\n' };
  MODULE['_BinaryenExpressionPrint'](expr);
  out = old;
  return ret;
};

// Parses a binary to a module

function bynReadBinary(data) {
  const buffer = allocate(data, 'i8', ALLOC_NORMAL);
  const ptr = MODULE['_BinaryenModuleRead'](buffer, data.length);
  _free(buffer);
  return wrapModule(ptr);
};

export { bynReadBinary as readBinary };

// Parses text format to a module
export function parseText(text) {
  const buffer = _malloc(text.length + 1);
  writeAsciiToMemory(text, buffer);
  const ptr = MODULE['_BinaryenModuleParse'](buffer);
  _free(buffer);
  return wrapModule(ptr);
};

// Gets the currently set optimize level. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
export function getOptimizeLevel() {
  return MODULE['_BinaryenGetOptimizeLevel']();
};

// Sets the optimization level to use. 0, 1, 2 correspond to -O0, -O1, -O2, etc.
export function setOptimizeLevel(level) {
  MODULE['_BinaryenSetOptimizeLevel'](level);
};

// Gets the currently set shrink level. 0, 1, 2 correspond to -O0, -Os, -Oz.
export function getShrinkLevel() {
  return MODULE['_BinaryenGetShrinkLevel']();
};

// Sets the shrink level to use. 0, 1, 2 correspond to -O0, -Os, -Oz.
export function setShrinkLevel(level) {
  MODULE['_BinaryenSetShrinkLevel'](level);
};

// Gets whether generating debug information is currently enabled or not.
export function getDebugInfo() {
  return Boolean(MODULE['_BinaryenGetDebugInfo']());
};

// Enables or disables debug information in emitted binaries.
export function setDebugInfo(on) {
  MODULE['_BinaryenSetDebugInfo'](on);
};

// Gets whether the low 1K of memory can be considered unused when optimizing.
export function getLowMemoryUnused() {
  return Boolean(MODULE['_BinaryenGetLowMemoryUnused']());
};

// Enables or disables whether the low 1K of memory can be considered unused
// when optimizing.
export function setLowMemoryUnused(on) {
  MODULE['_BinaryenSetLowMemoryUnused'](on);
};

// Gets whether fast math optimizations are enabled, ignoring for example
// corner cases of floating-point math like NaN changes.
export function getFastMath() {
  return Boolean(MODULE['_BinaryenGetFastMath']());
};

// Enables or disables fast math optimizations, ignoring for example
// corner cases of floating-point math like NaN changes.
export function setFastMath(value) {
  MODULE['_BinaryenSetFastMath'](value);
};

// Gets the value of the specified arbitrary pass argument.
export function getPassArgument(key) {
  return preserveStack(() => {
    const ret = MODULE['_BinaryenGetPassArgument'](strToStack(key));
    return ret !== 0 ? UTF8ToString(ret) : null;
  });
};

// Sets the value of the specified arbitrary pass argument. Removes the
// respective argument if `value` is NULL.
export function setPassArgument(key, value) {
  preserveStack(() => { MODULE['_BinaryenSetPassArgument'](strToStack(key), strToStack(value)) });
};

// Clears all arbitrary pass arguments.
export function clearPassArguments() {
  MODULE['_BinaryenClearPassArguments']();
};

// Gets the function size at which we always inline.
export function getAlwaysInlineMaxSize() {
  return MODULE['_BinaryenGetAlwaysInlineMaxSize']();
};

// Sets the function size at which we always inline.
export function setAlwaysInlineMaxSize(size) {
  MODULE['_BinaryenSetAlwaysInlineMaxSize'](size);
};

// Gets the function size which we inline when functions are lightweight.
export function getFlexibleInlineMaxSize() {
  return MODULE['_BinaryenGetFlexibleInlineMaxSize']();
};

// Sets the function size which we inline when functions are lightweight.
export function setFlexibleInlineMaxSize(size) {
  MODULE['_BinaryenSetFlexibleInlineMaxSize'](size);
};

// Gets the function size which we inline when there is only one caller.
export function getOneCallerInlineMaxSize() {
  return MODULE['_BinaryenGetOneCallerInlineMaxSize']();
};

// Sets the function size which we inline when there is only one caller.
export function setOneCallerInlineMaxSize(size) {
  MODULE['_BinaryenSetOneCallerInlineMaxSize'](size);
};

// Gets the value which allow inline functions that are not "lightweight".
export function getAllowInliningFunctionsWithLoops() {
  return Boolean(MODULE['_BinaryenGetAllowInliningFunctionsWithLoops']());
};

// Sets the value which allow inline functions that are not "lightweight".
export function setAllowInliningFunctionsWithLoops(value) {
  MODULE['_BinaryenSetAllowInliningFunctionsWithLoops'](value);
};

// Expression wrappers

// Private symbol used to store the underlying C-API pointer of a wrapped object.
const thisPtr = Symbol();

// Makes a specific expression wrapper class with the specified static members
// while automatically deriving instance methods and accessors.
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
  // derive own instance members
  deriveWrapperInstanceMembers(SpecificExpression.prototype, ownStaticMembers);
  return SpecificExpression;
}

// Derives the instance members of a wrapper class from the given static
// members.
function deriveWrapperInstanceMembers(prototype, staticMembers) {
  // Given a static member `getName(ptr)` for example, an instance method
  // `getName()` and a `name` accessor with the `this` argument bound will be
  // derived and added to the wrapper's prototype. If a corresponding static
  // `setName(ptr)` is present, a setter for the `name` accessor will be added
  // as well.
  Object.keys(staticMembers).forEach(memberName => {
    const member = staticMembers[memberName];
    if (typeof member === "function") {
      // Instance method calls the respective static method with `this` bound.
      prototype[memberName] = function(...args) {
        return this.constructor[memberName](this[thisPtr], ...args);
      };
      // Instance accessors call the respective static methods. Accessors are
      // derived only if the respective underlying static method takes exactly
      // one argument, the `this` argument, e.g. `getChild(ptr, idx)` does not
      // trigger an accessor.
      let match;
      if (member.length === 1 && (match = memberName.match(/^(get|is)/))) {
        const index = match[1].length;
        const propertyName = memberName.charAt(index).toLowerCase() + memberName.substring(index + 1);
        const setterIfAny = staticMembers["set" + memberName.substring(index)];
        Object.defineProperty(prototype, propertyName, {
          get() {
            return member(this[thisPtr]);
          },
          set(value) {
            if (setterIfAny) setterIfAny(this[thisPtr], value);
            else throw Error("property '" + propertyName + "' has no setter");
          }
        });
      }
    }
  });
}

// Base class of all expression wrappers
export function Expression(expr) {
  if (!expr) throw Error("expression reference must not be null");
  this[thisPtr] = expr;
}
Expression['getId'] = function(expr) {
  return MODULE['_BinaryenExpressionGetId'](expr);
};
Expression['getType'] = function(expr) {
  return MODULE['_BinaryenExpressionGetType'](expr);
};
Expression['setType'] = function(expr, type) {
  MODULE['_BinaryenExpressionSetType'](expr, type);
};
Expression['finalize'] = function(expr) {
  return MODULE['_BinaryenExpressionFinalize'](expr);
};
Expression['toText'] = function(expr) {
  return MODULE['emitText'](expr);
};
deriveWrapperInstanceMembers(Expression.prototype, Expression);
Expression.prototype['valueOf'] = function() {
  return this[thisPtr];
};

export const Block = makeExpressionWrapper({
  'getName'(expr) {
    const name = MODULE['_BinaryenBlockGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenBlockSetName'](expr, strToStack(name)) });
  },
  'getNumChildren'(expr) {
    return MODULE['_BinaryenBlockGetNumChildren'](expr);
  },
  'getChildren'(expr) {
    const numChildren = MODULE['_BinaryenBlockGetNumChildren'](expr);
    const children = new Array(numChildren);
    let index = 0;
    while (index < numChildren) {
      children[index] = MODULE['_BinaryenBlockGetChildAt'](expr, index++);
    }
    return children;
  },
  'setChildren'(expr, children) {
    const numChildren = children.length;
    let prevNumChildren = MODULE['_BinaryenBlockGetNumChildren'](expr);
    let index = 0;
    while (index < numChildren) {
      if (index < prevNumChildren) {
        MODULE['_BinaryenBlockSetChildAt'](expr, index, children[index]);
      } else {
        MODULE['_BinaryenBlockAppendChild'](expr, children[index]);
      }
      ++index;
    }
    while (prevNumChildren > index) {
      MODULE['_BinaryenBlockRemoveChildAt'](expr, --prevNumChildren);
    }
  },
  'getChildAt'(expr, index) {
    return MODULE['_BinaryenBlockGetChildAt'](expr, index);
  },
  'setChildAt'(expr, index, childExpr) {
    MODULE['_BinaryenBlockSetChildAt'](expr, index, childExpr);
  },
  'appendChild'(expr, childExpr) {
    return MODULE['_BinaryenBlockAppendChild'](expr, childExpr);
  },
  'insertChildAt'(expr, index, childExpr) {
    MODULE['_BinaryenBlockInsertChildAt'](expr, index, childExpr);
  },
  'removeChildAt'(expr, index) {
    return MODULE['_BinaryenBlockRemoveChildAt'](expr, index);
  }
});

export const If = makeExpressionWrapper({
  'getCondition'(expr) {
    return MODULE['_BinaryenIfGetCondition'](expr);
  },
  'setCondition'(expr, condExpr) {
    MODULE['_BinaryenIfSetCondition'](expr, condExpr);
  },
  'getIfTrue'(expr) {
    return MODULE['_BinaryenIfGetIfTrue'](expr);
  },
  'setIfTrue'(expr, ifTrueExpr) {
    MODULE['_BinaryenIfSetIfTrue'](expr, ifTrueExpr);
  },
  'getIfFalse'(expr) {
    return MODULE['_BinaryenIfGetIfFalse'](expr);
  },
  'setIfFalse'(expr, ifFalseExpr) {
    MODULE['_BinaryenIfSetIfFalse'](expr, ifFalseExpr);
  }
});

export const Loop = makeExpressionWrapper({
  'getName'(expr) {
    const name = MODULE['_BinaryenLoopGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenLoopSetName'](expr, strToStack(name)) });
  },
  'getBody'(expr) {
    return MODULE['_BinaryenLoopGetBody'](expr);
  },
  'setBody'(expr, bodyExpr) {
    MODULE['_BinaryenLoopSetBody'](expr, bodyExpr);
  }
});

export const Break = makeExpressionWrapper({
  'getName'(expr) {
    const name = MODULE['_BinaryenBreakGetName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenBreakSetName'](expr, strToStack(name)) });
  },
  'getCondition'(expr) {
    return MODULE['_BinaryenBreakGetCondition'](expr);
  },
  'setCondition'(expr, condExpr) {
    MODULE['_BinaryenBreakSetCondition'](expr, condExpr);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenBreakGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenBreakSetValue'](expr, valueExpr);
  }
});

export const Switch = makeExpressionWrapper({
  'getNumNames'(expr) {
    return MODULE['_BinaryenSwitchGetNumNames'](expr);
  },
  'getNames'(expr) {
    const numNames = MODULE['_BinaryenSwitchGetNumNames'](expr);
    const names = new Array(numNames);
    let index = 0;
    while (index < numNames) {
      names[index] = UTF8ToString(MODULE['_BinaryenSwitchGetNameAt'](expr, index++));
    }
    return names;
  },
  'setNames'(expr, names) {
    const numNames = names.length;
    let prevNumNames = MODULE['_BinaryenSwitchGetNumNames'](expr);
    let index = 0;
    while (index < numNames) {
      preserveStack(() => {
        if (index < prevNumNames) {
          MODULE['_BinaryenSwitchSetNameAt'](expr, index, strToStack(names[index]));
        } else {
          MODULE['_BinaryenSwitchAppendName'](expr, strToStack(names[index]));
        }
      });
      ++index;
    }
    while (prevNumNames > index) {
      MODULE['_BinaryenSwitchRemoveNameAt'](expr, --prevNumNames);
    }
  },
  'getDefaultName'(expr) {
    const name = MODULE['_BinaryenSwitchGetDefaultName'](expr);
    return name ? UTF8ToString(name) : null;
  },
  'setDefaultName'(expr, defaultName) {
    preserveStack(() => { MODULE['_BinaryenSwitchSetDefaultName'](expr, strToStack(defaultName)) });
  },
  'getCondition'(expr) {
    return MODULE['_BinaryenSwitchGetCondition'](expr);
  },
  'setCondition'(expr, condExpr) {
    MODULE['_BinaryenSwitchSetCondition'](expr, condExpr);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenSwitchGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenSwitchSetValue'](expr, valueExpr);
  },
  'getNameAt'(expr, index) {
    return UTF8ToString(MODULE['_BinaryenSwitchGetNameAt'](expr, index));
  },
  'setNameAt'(expr, index, name) {
    preserveStack(() => { MODULE['_BinaryenSwitchSetNameAt'](expr, index, strToStack(name)) });
  },
  'appendName'(expr, name) {
    preserveStack(() => MODULE['_BinaryenSwitchAppendName'](expr, strToStack(name)));
  },
  'insertNameAt'(expr, index, name) {
    preserveStack(() => { MODULE['_BinaryenSwitchInsertNameAt'](expr, index, strToStack(name)) });
  },
  'removeNameAt'(expr, index) {
    return UTF8ToString(MODULE['_BinaryenSwitchRemoveNameAt'](expr, index));
  },
});

export const Call = makeExpressionWrapper({
  'getTarget'(expr) {
    return UTF8ToString(MODULE['_BinaryenCallGetTarget'](expr));
  },
  'setTarget'(expr, targetName) {
    preserveStack(() => { MODULE['_BinaryenCallSetTarget'](expr, strToStack(targetName)) });
  },
  'getNumOperands'(expr) {
    return MODULE['_BinaryenCallGetNumOperands'](expr);
  },
  'getOperands'(expr) {
    const numOperands = MODULE['_BinaryenCallGetNumOperands'](expr);
    const operands = new Array(numOperands);
    let index = 0;
    while (index < numOperands) {
      operands[index] = MODULE['_BinaryenCallGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands'(expr, operands) {
    const numOperands = operands.length;
    let prevNumOperands = MODULE['_BinaryenCallGetNumOperands'](expr);
    let index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        MODULE['_BinaryenCallSetOperandAt'](expr, index, operands[index]);
      } else {
        MODULE['_BinaryenCallAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      MODULE['_BinaryenCallRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt'(expr, index) {
    return MODULE['_BinaryenCallGetOperandAt'](expr, index);
  },
  'setOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenCallSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand'(expr, operandExpr) {
    return MODULE['_BinaryenCallAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenCallInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt'(expr, index) {
    return MODULE['_BinaryenCallRemoveOperandAt'](expr, index);
  },
  'isReturn'(expr) {
    return Boolean(MODULE['_BinaryenCallIsReturn'](expr));
  },
  'setReturn'(expr, isReturn) {
    MODULE['_BinaryenCallSetReturn'](expr, isReturn);
  }
});

export const CallIndirect = makeExpressionWrapper({
  'getTarget'(expr) {
    return MODULE['_BinaryenCallIndirectGetTarget'](expr);
  },
  'setTarget'(expr, targetExpr) {
    MODULE['_BinaryenCallIndirectSetTarget'](expr, targetExpr);
  },
  'getNumOperands'(expr) {
    return MODULE['_BinaryenCallIndirectGetNumOperands'](expr);
  },
  'getOperands'(expr) {
    const numOperands = MODULE['_BinaryenCallIndirectGetNumOperands'](expr);
    const operands = new Array(numOperands);
    let index = 0;
    while (index < numOperands) {
      operands[index] = MODULE['_BinaryenCallIndirectGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands'(expr, operands) {
    const numOperands = operands.length;
    let prevNumOperands = MODULE['_BinaryenCallIndirectGetNumOperands'](expr);
    let index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        MODULE['_BinaryenCallIndirectSetOperandAt'](expr, index, operands[index]);
      } else {
        MODULE['_BinaryenCallIndirectAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      MODULE['_BinaryenCallIndirectRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt'(expr, index) {
    return MODULE['_BinaryenCallIndirectGetOperandAt'](expr, index);
  },
  'setOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenCallIndirectSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand'(expr, operandExpr) {
    return MODULE['_BinaryenCallIndirectAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenCallIndirectInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt'(expr, index) {
    return MODULE['_BinaryenCallIndirectRemoveOperandAt'](expr, index);
  },
  'isReturn'(expr) {
    return Boolean(MODULE['_BinaryenCallIndirectIsReturn'](expr));
  },
  'setReturn'(expr, isReturn) {
    MODULE['_BinaryenCallIndirectSetReturn'](expr, isReturn);
  },
  'getParams'(expr) {
    return MODULE['_BinaryenCallIndirectGetParams'](expr);
  },
  'setParams'(expr, params) {
    MODULE['_BinaryenCallIndirectSetParams'](expr, params);
  },
  'getResults'(expr) {
    return MODULE['_BinaryenCallIndirectGetResults'](expr);
  },
  'setResults'(expr, results) {
    MODULE['_BinaryenCallIndirectSetResults'](expr, results);
  }
});

export const LocalGet = makeExpressionWrapper({
  'getIndex'(expr) {
    return MODULE['_BinaryenLocalGetGetIndex'](expr);
  },
  'setIndex'(expr, index) {
    MODULE['_BinaryenLocalGetSetIndex'](expr, index);
  }
});

export const LocalSet = makeExpressionWrapper({
  'getIndex'(expr) {
    return MODULE['_BinaryenLocalSetGetIndex'](expr);
  },
  'setIndex'(expr, index) {
    MODULE['_BinaryenLocalSetSetIndex'](expr, index);
  },
  'isTee'(expr) {
    return Boolean(MODULE['_BinaryenLocalSetIsTee'](expr));
  },
  'getValue'(expr) {
    return MODULE['_BinaryenLocalSetGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenLocalSetSetValue'](expr, valueExpr);
  }
});

export const GlobalGet = makeExpressionWrapper({
  'getName'(expr) {
    return UTF8ToString(MODULE['_BinaryenGlobalGetGetName'](expr));
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenGlobalGetSetName'](expr, strToStack(name)) });
  }
});

export const GlobalSet = makeExpressionWrapper({
  'getName'(expr) {
    return UTF8ToString(MODULE['_BinaryenGlobalSetGetName'](expr));
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenGlobalSetSetName'](expr, strToStack(name)) });
  },
  'getValue'(expr) {
    return MODULE['_BinaryenGlobalSetGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenGlobalSetSetValue'](expr, valueExpr);
  }
});

export const MemorySize = makeExpressionWrapper({});

export const MemoryGrow = makeExpressionWrapper({
  'getDelta'(expr) {
    return MODULE['_BinaryenMemoryGrowGetDelta'](expr);
  },
  'setDelta'(expr, deltaExpr) {
    MODULE['_BinaryenMemoryGrowSetDelta'](expr, deltaExpr);
  }
});

export const Load = makeExpressionWrapper({
  'isAtomic'(expr) {
    return Boolean(MODULE['_BinaryenLoadIsAtomic'](expr));
  },
  'setAtomic'(expr, isAtomic) {
    MODULE['_BinaryenLoadSetAtomic'](expr, isAtomic);
  },
  'isSigned'(expr) {
    return Boolean(MODULE['_BinaryenLoadIsSigned'](expr));
  },
  'setSigned'(expr, isSigned) {
    MODULE['_BinaryenLoadSetSigned'](expr, isSigned);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenLoadGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenLoadSetOffset'](expr, offset);
  },
  'getBytes'(expr) {
    return MODULE['_BinaryenLoadGetBytes'](expr);
  },
  'setBytes'(expr, bytes) {
    MODULE['_BinaryenLoadSetBytes'](expr, bytes);
  },
  'getAlign'(expr) {
    return MODULE['_BinaryenLoadGetAlign'](expr);
  },
  'setAlign'(expr, align) {
    MODULE['_BinaryenLoadSetAlign'](expr, align);
  },
  'getPtr'(expr) {
    return MODULE['_BinaryenLoadGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenLoadSetPtr'](expr, ptrExpr);
  }
});

export const Store = makeExpressionWrapper({
  'isAtomic'(expr) {
    return Boolean(MODULE['_BinaryenStoreIsAtomic'](expr));
  },
  'setAtomic'(expr, isAtomic) {
    MODULE['_BinaryenStoreSetAtomic'](expr, isAtomic);
  },
  'getBytes'(expr) {
    return MODULE['_BinaryenStoreGetBytes'](expr);
  },
  'setBytes'(expr, bytes) {
    MODULE['_BinaryenStoreSetBytes'](expr, bytes);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenStoreGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenStoreSetOffset'](expr, offset);
  },
  'getAlign'(expr) {
    return MODULE['_BinaryenStoreGetAlign'](expr);
  },
  'setAlign'(expr, align) {
    MODULE['_BinaryenStoreSetAlign'](expr, align);
  },
  'getPtr'(expr) {
    return MODULE['_BinaryenStoreGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenStoreSetPtr'](expr, ptrExpr);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenStoreGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenStoreSetValue'](expr, valueExpr);
  },
  'getValueType'(expr) {
    return MODULE['_BinaryenStoreGetValueType'](expr);
  },
  'setValueType'(expr, valueType) {
    MODULE['_BinaryenStoreSetValueType'](expr, valueType);
  }
});

export const Const = makeExpressionWrapper({
  'getValueI32'(expr) {
    return MODULE['_BinaryenConstGetValueI32'](expr);
  },
  'setValueI32'(expr, value) {
    MODULE['_BinaryenConstSetValueI32'](expr, value);
  },
  'getValueI64Low'(expr) {
    return MODULE['_BinaryenConstGetValueI64Low'](expr);
  },
  'setValueI64Low'(expr, value) {
    MODULE['_BinaryenConstSetValueI64Low'](expr, value);
  },
  'getValueI64High'(expr) {
    return MODULE['_BinaryenConstGetValueI64High'](expr);
  },
  'setValueI64High'(expr, value) {
    MODULE['_BinaryenConstSetValueI64High'](expr, value);
  },
  'getValueF32'(expr) {
    return MODULE['_BinaryenConstGetValueF32'](expr);
  },
  'setValueF32'(expr, value) {
    MODULE['_BinaryenConstSetValueF32'](expr, value);
  },
  'getValueF64'(expr) {
    return MODULE['_BinaryenConstGetValueF64'](expr);
  },
  'setValueF64'(expr, value) {
    MODULE['_BinaryenConstSetValueF64'](expr, value);
  },
  'getValueV128'(expr) {
    let value;
    preserveStack(() => {
      const tempBuffer = stackAlloc(16);
      MODULE['_BinaryenConstGetValueV128'](expr, tempBuffer);
      value = new Array(16);
      for (let i = 0 ; i < 16; ++i) {
        value[i] = HEAPU8[tempBuffer + i];
      }
    });
    return value;
  },
  'setValueV128'(expr, value) {
    preserveStack(() => {
      const tempBuffer = stackAlloc(16);
      for (let i = 0 ; i < 16; ++i) {
        HEAPU8[tempBuffer + i] = value[i];
      }
      MODULE['_BinaryenConstSetValueV128'](expr, tempBuffer);
    });
  }
});

export const Unary = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenUnaryGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenUnarySetOp'](expr, op);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenUnaryGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenUnarySetValue'](expr, valueExpr);
  }
});

export const Binary = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenBinaryGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenBinarySetOp'](expr, op);
  },
  'getLeft'(expr) {
    return MODULE['_BinaryenBinaryGetLeft'](expr);
  },
  'setLeft'(expr, leftExpr) {
    MODULE['_BinaryenBinarySetLeft'](expr, leftExpr);
  },
  'getRight'(expr) {
    return MODULE['_BinaryenBinaryGetRight'](expr);
  },
  'setRight'(expr, rightExpr) {
    MODULE['_BinaryenBinarySetRight'](expr, rightExpr);
  }
});

export const Select = makeExpressionWrapper({
  'getIfTrue'(expr) {
    return MODULE['_BinaryenSelectGetIfTrue'](expr);
  },
  'setIfTrue'(expr, ifTrueExpr) {
    MODULE['_BinaryenSelectSetIfTrue'](expr, ifTrueExpr);
  },
  'getIfFalse'(expr) {
    return MODULE['_BinaryenSelectGetIfFalse'](expr);
  },
  'setIfFalse'(expr, ifFalseExpr) {
    MODULE['_BinaryenSelectSetIfFalse'](expr, ifFalseExpr);
  },
  'getCondition'(expr) {
    return MODULE['_BinaryenSelectGetCondition'](expr);
  },
  'setCondition'(expr, condExpr) {
    MODULE['_BinaryenSelectSetCondition'](expr, condExpr);
  }
});

export const Drop = makeExpressionWrapper({
  'getValue'(expr) {
    return MODULE['_BinaryenDropGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenDropSetValue'](expr, valueExpr);
  }
});

export const Return = makeExpressionWrapper({
  'getValue'(expr) {
    return MODULE['_BinaryenReturnGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenReturnSetValue'](expr, valueExpr);
  }
});

export const AtomicRMW = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenAtomicRMWGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenAtomicRMWSetOp'](expr, op);
  },
  'getBytes'(expr) {
    return MODULE['_BinaryenAtomicRMWGetBytes'](expr);
  },
  'setBytes'(expr, bytes) {
    MODULE['_BinaryenAtomicRMWSetBytes'](expr, bytes);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenAtomicRMWGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenAtomicRMWSetOffset'](expr, offset);
  },
  'getPtr'(expr) {
    return MODULE['_BinaryenAtomicRMWGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenAtomicRMWSetPtr'](expr, ptrExpr);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenAtomicRMWGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenAtomicRMWSetValue'](expr, valueExpr);
  }
});

export const AtomicCmpxchg = makeExpressionWrapper({
  'getBytes'(expr) {
    return MODULE['_BinaryenAtomicCmpxchgGetBytes'](expr);
  },
  'setBytes'(expr, bytes) {
    MODULE['_BinaryenAtomicCmpxchgSetBytes'](expr, bytes);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenAtomicCmpxchgGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenAtomicCmpxchgSetOffset'](expr, offset);
  },
  'getPtr'(expr) {
    return MODULE['_BinaryenAtomicCmpxchgGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenAtomicCmpxchgSetPtr'](expr, ptrExpr);
  },
  'getExpected'(expr) {
    return MODULE['_BinaryenAtomicCmpxchgGetExpected'](expr);
  },
  'setExpected'(expr, expectedExpr) {
    MODULE['_BinaryenAtomicCmpxchgSetExpected'](expr, expectedExpr);
  },
  'getReplacement'(expr) {
    return MODULE['_BinaryenAtomicCmpxchgGetReplacement'](expr);
  },
  'setReplacement'(expr, replacementExpr) {
    MODULE['_BinaryenAtomicCmpxchgSetReplacement'](expr, replacementExpr);
  }
});

export const AtomicWait = makeExpressionWrapper({
  'getPtr'(expr) {
    return MODULE['_BinaryenAtomicWaitGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenAtomicWaitSetPtr'](expr, ptrExpr);
  },
  'getExpected'(expr) {
    return MODULE['_BinaryenAtomicWaitGetExpected'](expr);
  },
  'setExpected'(expr, expectedExpr) {
    MODULE['_BinaryenAtomicWaitSetExpected'](expr, expectedExpr);
  },
  'getTimeout'(expr) {
    return MODULE['_BinaryenAtomicWaitGetTimeout'](expr);
  },
  'setTimeout'(expr, timeoutExpr) {
    MODULE['_BinaryenAtomicWaitSetTimeout'](expr, timeoutExpr);
  },
  'getExpectedType'(expr) {
    return MODULE['_BinaryenAtomicWaitGetExpectedType'](expr);
  },
  'setExpectedType'(expr, expectedType) {
    MODULE['_BinaryenAtomicWaitSetExpectedType'](expr, expectedType);
  }
});

export const AtomicNotify = makeExpressionWrapper({
  'getPtr'(expr) {
    return MODULE['_BinaryenAtomicNotifyGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenAtomicNotifySetPtr'](expr, ptrExpr);
  },
  'getNotifyCount'(expr) {
    return MODULE['_BinaryenAtomicNotifyGetNotifyCount'](expr);
  },
  'setNotifyCount'(expr, notifyCountExpr) {
    MODULE['_BinaryenAtomicNotifySetNotifyCount'](expr, notifyCountExpr);
  }
});

export const AtomicFence = makeExpressionWrapper({
  'getOrder'(expr) {
    return MODULE['_BinaryenAtomicFenceGetOrder'](expr);
  },
  'setOrder'(expr, order) {
    MODULE['_BinaryenAtomicFenceSetOrder'](expr, order);
  }
});

export const SIMDExtract = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenSIMDExtractGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenSIMDExtractSetOp'](expr, op);
  },
  'getVec'(expr) {
    return MODULE['_BinaryenSIMDExtractGetVec'](expr);
  },
  'setVec'(expr, vecExpr) {
    MODULE['_BinaryenSIMDExtractSetVec'](expr, vecExpr);
  },
  'getIndex'(expr) {
    return MODULE['_BinaryenSIMDExtractGetIndex'](expr);
  },
  'setIndex'(expr, index) {
    MODULE['_BinaryenSIMDExtractSetIndex'](expr, index)
  }
});

export const SIMDReplace = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenSIMDReplaceGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenSIMDReplaceSetOp'](expr, op);
  },
  'getVec'(expr) {
    return MODULE['_BinaryenSIMDReplaceGetVec'](expr);
  },
  'setVec'(expr, vecExpr) {
    MODULE['_BinaryenSIMDReplaceSetVec'](expr, vecExpr);
  },
  'getIndex'(expr) {
    return MODULE['_BinaryenSIMDReplaceGetIndex'](expr);
  },
  'setIndex'(expr, index) {
    MODULE['_BinaryenSIMDReplaceSetIndex'](expr, index);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenSIMDReplaceGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenSIMDReplaceSetValue'](expr, valueExpr);
  }
});

export const SIMDShuffle = makeExpressionWrapper({
  'getLeft'(expr) {
    return MODULE['_BinaryenSIMDShuffleGetLeft'](expr);
  },
  'setLeft'(expr, leftExpr) {
    MODULE['_BinaryenSIMDShuffleSetLeft'](expr, leftExpr)
  },
  'getRight'(expr) {
    return MODULE['_BinaryenSIMDShuffleGetRight'](expr);
  },
  'setRight'(expr, rightExpr) {
    MODULE['_BinaryenSIMDShuffleSetRight'](expr, rightExpr);
  },
  'getMask'(expr) {
    let mask;
    preserveStack(() => {
      const tempBuffer = stackAlloc(16);
      MODULE['_BinaryenSIMDShuffleGetMask'](expr, tempBuffer);
      mask = new Array(16);
      for (let i = 0 ; i < 16; ++i) {
        mask[i] = HEAPU8[tempBuffer + i];
      }
    });
    return mask;
  },
  'setMask'(expr, mask) {
    preserveStack(() => {
      const tempBuffer = stackAlloc(16);
      for (let i = 0 ; i < 16; ++i) {
        HEAPU8[tempBuffer + i] = mask[i];
      }
      MODULE['_BinaryenSIMDShuffleSetMask'](expr, tempBuffer);
    });
  }
});

export const SIMDTernary = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenSIMDTernaryGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenSIMDTernarySetOp'](expr, op);
  },
  'getA'(expr) {
    return MODULE['_BinaryenSIMDTernaryGetA'](expr);
  },
  'setA'(expr, aExpr) {
    MODULE['_BinaryenSIMDTernarySetA'](expr, aExpr);
  },
  'getB'(expr) {
    return MODULE['_BinaryenSIMDTernaryGetB'](expr);
  },
  'setB'(expr, bExpr) {
    MODULE['_BinaryenSIMDTernarySetB'](expr, bExpr);
  },
  'getC'(expr) {
    return MODULE['_BinaryenSIMDTernaryGetC'](expr);
  },
  'setC'(expr, cExpr) {
    MODULE['_BinaryenSIMDTernarySetC'](expr, cExpr);
  }
});

export const SIMDShift = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenSIMDShiftGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenSIMDShiftSetOp'](expr, op);
  },
  'getVec'(expr) {
    return MODULE['_BinaryenSIMDShiftGetVec'](expr);
  },
  'setVec'(expr, vecExpr) {
    MODULE['_BinaryenSIMDShiftSetVec'](expr, vecExpr);
  },
  'getShift'(expr) {
    return MODULE['_BinaryenSIMDShiftGetShift'](expr);
  },
  'setShift'(expr, shiftExpr) {
    MODULE['_BinaryenSIMDShiftSetShift'](expr, shiftExpr);
  }
});

export const SIMDLoad = makeExpressionWrapper({
  'getOp'(expr) {
    return MODULE['_BinaryenSIMDLoadGetOp'](expr);
  },
  'setOp'(expr, op) {
    MODULE['_BinaryenSIMDLoadSetOp'](expr, op);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenSIMDLoadGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenSIMDLoadSetOffset'](expr, offset);
  },
  'getAlign'(expr) {
    return MODULE['_BinaryenSIMDLoadGetAlign'](expr);
  },
  'setAlign'(expr, align) {
    MODULE['_BinaryenSIMDLoadSetAlign'](expr, align);
  },
  'getPtr'(expr) {
    return MODULE['_BinaryenSIMDLoadGetPtr'](expr);
  },
  'setPtr'(expr, ptrExpr) {
    MODULE['_BinaryenSIMDLoadSetPtr'](expr, ptrExpr);
  }
});

export const MemoryInit = makeExpressionWrapper({
  'getSegment'(expr) {
    return MODULE['_BinaryenMemoryInitGetSegment'](expr);
  },
  'setSegment'(expr, segmentIndex) {
    MODULE['_BinaryenMemoryInitSetSegment'](expr, segmentIndex);
  },
  'getDest'(expr) {
    return MODULE['_BinaryenMemoryInitGetDest'](expr);
  },
  'setDest'(expr, destExpr) {
    MODULE['_BinaryenMemoryInitSetDest'](expr, destExpr);
  },
  'getOffset'(expr) {
    return MODULE['_BinaryenMemoryInitGetOffset'](expr);
  },
  'setOffset'(expr, offset) {
    MODULE['_BinaryenMemoryInitSetOffset'](expr, offset);
  },
  'getSize'(expr) {
    return MODULE['_BinaryenMemoryInitGetSize'](expr);
  },
  'setSize'(expr, sizeExpr) {
    MODULE['_BinaryenMemoryInitSetSize'](expr, sizeExpr);
  }
});

export const DataDrop = makeExpressionWrapper({
  'getSegment'(expr) {
    return MODULE['_BinaryenDataDropGetSegment'](expr);
  },
  'setSegment'(expr, segmentIndex) {
    MODULE['_BinaryenDataDropSetSegment'](expr, segmentIndex);
  }
});

export const MemoryCopy = makeExpressionWrapper({
  'getDest'(expr) {
    return MODULE['_BinaryenMemoryCopyGetDest'](expr);
  },
  'setDest'(expr, destExpr) {
    MODULE['_BinaryenMemoryCopySetDest'](expr, destExpr);
  },
  'getSource'(expr) {
    return MODULE['_BinaryenMemoryCopyGetSource'](expr);
  },
  'setSource'(expr, sourceExpr) {
    MODULE['_BinaryenMemoryCopySetSource'](expr, sourceExpr);
  },
  'getSize'(expr) {
    return MODULE['_BinaryenMemoryCopyGetSize'](expr);
  },
  'setSize'(expr, sizeExpr) {
    MODULE['_BinaryenMemoryCopySetSize'](expr, sizeExpr);
  }
});

export const MemoryFill = makeExpressionWrapper({
  'getDest'(expr) {
    return MODULE['_BinaryenMemoryFillGetDest'](expr);
  },
  'setDest'(expr, destExpr) {
    MODULE['_BinaryenMemoryFillSetDest'](expr, destExpr);
  },
  'getValue'(expr) {
    return MODULE['_BinaryenMemoryFillGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenMemoryFillSetValue'](expr, valueExpr);
  },
  'getSize'(expr) {
    return MODULE['_BinaryenMemoryFillGetSize'](expr);
  },
  'setSize'(expr, sizeExpr) {
    MODULE['_BinaryenMemoryFillSetSize'](expr, sizeExpr);
  }
});

export const RefIsNull = makeExpressionWrapper({
  'getValue'(expr) {
    return MODULE['_BinaryenRefIsNullGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenRefIsNullSetValue'](expr, valueExpr);
  }
});

export const RefFunc = makeExpressionWrapper({
  'getFunc'(expr) {
    return UTF8ToString(MODULE['_BinaryenRefFuncGetFunc'](expr));
  },
  'setFunc'(expr, funcName) {
    preserveStack(() => { MODULE['_BinaryenRefFuncSetFunc'](expr, strToStack(funcName)) });
  }
});

export const RefEq = makeExpressionWrapper({
  'getLeft'(expr) {
    return MODULE['_BinaryenRefEqGetLeft'](expr);
  },
  'setLeft'(expr, leftExpr) {
    return MODULE['_BinaryenRefEqSetLeft'](expr, leftExpr);
  },
  'getRight'(expr) {
    return MODULE['_BinaryenRefEqGetRight'](expr);
  },
  'setRight'(expr, rightExpr) {
    return MODULE['_BinaryenRefEqSetRight'](expr, rightExpr);
  }
});

export const Try = makeExpressionWrapper({
  'getBody'(expr) {
    return MODULE['_BinaryenTryGetBody'](expr);
  },
  'setBody'(expr, bodyExpr) {
    MODULE['_BinaryenTrySetBody'](expr, bodyExpr);
  },
  'getCatchBody'(expr) {
    return MODULE['_BinaryenTryGetCatchBody'](expr);
  },
  'setCatchBody'(expr, catchBodyExpr) {
    MODULE['_BinaryenTrySetCatchBody'](expr, catchBodyExpr);
  }
});

export const Throw = makeExpressionWrapper({
  'getEvent'(expr) {
    return UTF8ToString(MODULE['_BinaryenThrowGetEvent'](expr));
  },
  'setEvent'(expr, eventName) {
    preserveStack(() => { MODULE['_BinaryenThrowSetEvent'](expr, strToStack(eventName)) });
  },
  'getNumOperands'(expr) {
    return MODULE['_BinaryenThrowGetNumOperands'](expr);
  },
  'getOperands'(expr) {
    const numOperands = MODULE['_BinaryenThrowGetNumOperands'](expr);
    const operands = new Array(numOperands);
    let index = 0;
    while (index < numOperands) {
      operands[index] = MODULE['_BinaryenThrowGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands'(expr, operands) {
    const numOperands = operands.length;
    let prevNumOperands = MODULE['_BinaryenThrowGetNumOperands'](expr);
    let index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        MODULE['_BinaryenThrowSetOperandAt'](expr, index, operands[index]);
      } else {
        MODULE['_BinaryenThrowAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      MODULE['_BinaryenThrowRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt'(expr, index) {
    return MODULE['_BinaryenThrowGetOperandAt'](expr, index);
  },
  'setOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenThrowSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand'(expr, operandExpr) {
    return MODULE['_BinaryenThrowAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenThrowInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt'(expr, index) {
    return MODULE['_BinaryenThrowRemoveOperandAt'](expr, index);
  },
});

export const Rethrow = makeExpressionWrapper({
  'getExnref'(expr) {
    return MODULE['_BinaryenRethrowGetExnref'](expr);
  },
  'setExnref'(expr, exnrefExpr) {
    MODULE['_BinaryenRethrowSetExnref'](expr, exnrefExpr);
  }
});

export const BrOnExn = makeExpressionWrapper({
  'getEvent'(expr) {
    return UTF8ToString(MODULE['_BinaryenBrOnExnGetEvent'](expr));
  },
  'setEvent'(expr, eventName) {
    preserveStack(() => { MODULE['_BinaryenBrOnExnSetEvent'](expr, strToStack(eventName)) });
  },
  'getName'(expr) {
    return UTF8ToString(MODULE['_BinaryenBrOnExnGetName'](expr));
  },
  'setName'(expr, name) {
    preserveStack(() => { MODULE['_BinaryenBrOnExnSetName'](expr, strToStack(name)) });
  },
  'getExnref'(expr) {
    return MODULE['_BinaryenBrOnExnGetExnref'](expr);
  },
  'setExnref'(expr, exnrefExpr) {
    MODULE['_BinaryenBrOnExnSetExnref'](expr, exnrefExpr);
  }
});

export const TupleMake = makeExpressionWrapper({
  'getNumOperands'(expr) {
    return MODULE['_BinaryenTupleMakeGetNumOperands'](expr);
  },
  'getOperands'(expr) {
    const numOperands = MODULE['_BinaryenTupleMakeGetNumOperands'](expr);
    const operands = new Array(numOperands);
    let index = 0;
    while (index < numOperands) {
      operands[index] = MODULE['_BinaryenTupleMakeGetOperandAt'](expr, index++);
    }
    return operands;
  },
  'setOperands'(expr, operands) {
    const numOperands = operands.length;
    let prevNumOperands = MODULE['_BinaryenTupleMakeGetNumOperands'](expr);
    let index = 0;
    while (index < numOperands) {
      if (index < prevNumOperands) {
        MODULE['_BinaryenTupleMakeSetOperandAt'](expr, index, operands[index]);
      } else {
        MODULE['_BinaryenTupleMakeAppendOperand'](expr, operands[index]);
      }
      ++index;
    }
    while (prevNumOperands > index) {
      MODULE['_BinaryenTupleMakeRemoveOperandAt'](expr, --prevNumOperands);
    }
  },
  'getOperandAt'(expr, index) {
    return MODULE['_BinaryenTupleMakeGetOperandAt'](expr, index);
  },
  'setOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenTupleMakeSetOperandAt'](expr, index, operandExpr);
  },
  'appendOperand'(expr, operandExpr) {
    return MODULE['_BinaryenTupleMakeAppendOperand'](expr, operandExpr);
  },
  'insertOperandAt'(expr, index, operandExpr) {
    MODULE['_BinaryenTupleMakeInsertOperandAt'](expr, index, operandExpr);
  },
  'removeOperandAt'(expr, index) {
    return MODULE['_BinaryenTupleMakeRemoveOperandAt'](expr, index);
  }
});

export const TupleExtract = makeExpressionWrapper({
  'getTuple'(expr) {
    return MODULE['_BinaryenTupleExtractGetTuple'](expr);
  },
  'setTuple'(expr, tupleExpr) {
    MODULE['_BinaryenTupleExtractSetTuple'](expr, tupleExpr);
  },
  'getIndex'(expr) {
    return MODULE['_BinaryenTupleExtractGetIndex'](expr);
  },
  'setIndex'(expr, index) {
    MODULE['_BinaryenTupleExtractSetIndex'](expr, index);
  }
});

export const I31New = makeExpressionWrapper({
  'getValue'(expr) {
    return MODULE['_BinaryenI31NewGetValue'](expr);
  },
  'setValue'(expr, valueExpr) {
    MODULE['_BinaryenI31NewSetValue'](expr, valueExpr);
  }
});

export const I31Get = makeExpressionWrapper({
  'getI31'(expr) {
    return MODULE['_BinaryenI31GetGetI31'](expr);
  },
  'setI31'(expr, i31Expr) {
    MODULE['_BinaryenI31GetSetI31'](expr, i31Expr);
  },
  'isSigned'(expr) {
    return Boolean(MODULE['_BinaryenI31GetIsSigned'](expr));
  },
  'setSigned'(expr, isSigned) {
    MODULE['_BinaryenI31GetSetSigned'](expr, isSigned);
  }
});

// Function wrapper

const BynFunction = (() => {
  // Closure compiler doesn't allow multiple `Function`s at top-level, so:
  function Function(func) {
    if (!(this instanceof Function)) {
      if (!func) return null;
      return new Function(func);
    }
    if (!func) throw Error("function reference must not be null");
    this[thisPtr] = func;
  }
  Function['getName'] = function(func) {
    return UTF8ToString(MODULE['_BinaryenFunctionGetName'](func));
  };
  Function['getParams'] = function(func) {
    return MODULE['_BinaryenFunctionGetParams'](func);
  };
  Function['getResults'] = function(func) {
    return MODULE['_BinaryenFunctionGetResults'](func);
  };
  Function['getNumVars'] = function(func) {
    return MODULE['_BinaryenFunctionGetNumVars'](func);
  };
  Function['getVar'] = function(func, index) {
    return MODULE['_BinaryenFunctionGetVar'](func, index);
  };
  Function['getNumLocals'] = function(func) {
    return MODULE['_BinaryenFunctionGetNumLocals'](func);
  };
  Function['hasLocalName'] = function(func, index) {
    return Boolean(MODULE['_BinaryenFunctionHasLocalName'](func, index));
  };
  Function['getLocalName'] = function(func, index) {
    return UTF8ToString(MODULE['_BinaryenFunctionGetLocalName'](func, index));
  };
  Function['setLocalName'] = function(func, index, name) {
    preserveStack(() => {
      MODULE['_BinaryenFunctionSetLocalName'](func, index, strToStack(name));
    });
  };
  Function['getBody'] = function(func) {
    return MODULE['_BinaryenFunctionGetBody'](func);
  };
  Function['setBody'] = function(func, bodyExpr) {
    MODULE['_BinaryenFunctionSetBody'](func, bodyExpr);
  };
  deriveWrapperInstanceMembers(Function.prototype, Function);
  Function.prototype['valueOf'] = function() {
    return this[thisPtr];
  };
  return Function;
})();

export { BynFunction as Function };

// Additional customizations

MODULE['exit'] = function(status) {
  // Instead of exiting silently on errors, always show an error with
  // a stack trace, for debuggability.
  if (status != 0) throw new Error('exiting due to error: ' + status);
};

// Provide a mechanism to tell when the module is ready
//
// await binaryen.ready;
// ...
//
let pendingPromises = [];
let initializeError = null;

export const ready = new Promise((resolve, reject) => {
  if (initializeError) {
    reject(initializeError);
  } else if (runtimeInitialized) {
    resolve(MODULE);
  } else {
    pendingPromises.push({ resolve, reject });
  }
});

// Intercept the onRuntimeInitialized hook if necessary
if (runtimeInitialized) {
  initializeConstants();
} else {
  MODULE['onRuntimeInitialized'] = (super_ => () => {
    try {
      initializeConstants();
      if (super_) super_();
      pendingPromises.forEach(p => { p.resolve(MODULE) });
    } catch (e) {
      initializeError = e;
      pendingPromises.forEach(p => { p.reject(e) });
    } finally {
      pendingPromises = [];
    }
  })(MODULE['onRuntimeInitialized']);
}

// Default export one gets upon either
// * `import binaryen from "binaryen"` or
// * `const binaryen = require("binaryen")`.
export default {
  Types,
  ExpressionIds,
  ExternalKinds,
  Features,
  Operations,
  SideEffects,
  Module: BynModule,
  wrapModule,
  ExpressionRunner,
  getExpressionId,
  getExpressionType,
  getExpressionInfo,
  getSideEffects,
  createType,
  expandType,
  getFunctionInfo,
  getGlobalInfo,
  getEventInfo,
  getExportInfo,
  emitText,
  readBinary: bynReadBinary,
  parseText,
  getOptimizeLevel,
  setOptimizeLevel,
  getShrinkLevel,
  setShrinkLevel,
  getDebugInfo,
  setDebugInfo,
  getLowMemoryUnused,
  setLowMemoryUnused,
  getFastMath,
  setFastMath,
  getPassArgument,
  setPassArgument,
  clearPassArguments,
  getAlwaysInlineMaxSize,
  setAlwaysInlineMaxSize,
  getFlexibleInlineMaxSize,
  setFlexibleInlineMaxSize,
  getOneCallerInlineMaxSize,
  setOneCallerInlineMaxSize,
  getAllowInliningFunctionsWithLoops,
  setAllowInliningFunctionsWithLoops,
  Expression,
  Block,
  If,
  Loop,
  Break,
  Switch,
  Call,
  CallIndirect,
  LocalGet,
  LocalSet,
  GlobalGet,
  GlobalSet,
  MemorySize,
  MemoryGrow,
  Load,
  Store,
  Const,
  Unary,
  Binary,
  Select,
  Drop,
  Return,
  AtomicRMW,
  AtomicCmpxchg,
  AtomicWait,
  AtomicNotify,
  AtomicFence,
  SIMDExtract,
  SIMDReplace,
  SIMDShuffle,
  SIMDTernary,
  SIMDShift,
  SIMDLoad,
  MemoryInit,
  DataDrop,
  MemoryCopy,
  MemoryFill,
  RefIsNull,
  RefFunc,
  RefEq,
  Try,
  Throw,
  Rethrow,
  BrOnExn,
  TupleMake,
  TupleExtract,
  I31New,
  I31Get,
  Function: BynFunction,
  ready
};
