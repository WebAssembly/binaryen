import * as env from 'env';

function asmFunc(imports) {
 var env = imports.env;
 var FUNCTION_TABLE = env.table;
 var Math_imul = Math.imul;
 var Math_fround = Math.fround;
 var Math_abs = Math.abs;
 var Math_clz32 = Math.clz32;
 var Math_min = Math.min;
 var Math_max = Math.max;
 var Math_floor = Math.floor;
 var Math_ceil = Math.ceil;
 var Math_trunc = Math.trunc;
 var Math_sqrt = Math.sqrt;
 function foo_true(x) {
  x = x | 0;
  return FUNCTION_TABLE[(x ? 1 : 0) | 0]() | 0 | 0;
 }
 
 function foo_false(x) {
  x = x | 0;
  return FUNCTION_TABLE[(x ? 0 : 1) | 0]() | 0 | 0;
 }
 
 function __wasm_table_grow(value, delta) {
  var oldSize = FUNCTION_TABLE.length;
  FUNCTION_TABLE.length = oldSize + delta;
  if (newSize > oldSize) {
   __wasm_table_fill(oldSize, value, delta)
  }
  return oldSize;
 }
 
 function __wasm_table_fill(dest, value, size) {
  var i = 0;
  while (i < size) {
   FUNCTION_TABLE[dest + i] = value;
   i = i + 1;
  };
 }
 
 function __wasm_table_copy(dest, source, size) {
  var i = 0;
  while (i < size) {
   FUNCTION_TABLE[dest + i] = FUNCTION_TABLE[source + i];
   i = i + 1;
  };
 }
 
 return {
  "foo_true": foo_true, 
  "foo_false": foo_false
 };
}

var retasmFunc = asmFunc({
  "env": env,
});
export var foo_true = retasmFunc.foo_true;
export var foo_false = retasmFunc.foo_false;
