
function asmFunc(env) {
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 function $0(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x == y | 0;
 }
 
 function $1(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x != y | 0;
 }
 
 function $2(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x < y | 0;
 }
 
 function $3(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x <= y | 0;
 }
 
 function $4(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x > y | 0;
 }
 
 function $5(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return x >= y | 0;
 }
 
 return {
  "eq": $0, 
  "ne": $1, 
  "lt": $2, 
  "le": $3, 
  "gt": $4, 
  "ge": $5
 };
}

var retasmFunc = asmFunc({ abort() { throw new Error('abort'); } });
export var eq = retasmFunc.eq;
export var ne = retasmFunc.ne;
export var lt = retasmFunc.lt;
export var le = retasmFunc.le;
export var gt = retasmFunc.gt;
export var ge = retasmFunc.ge;
