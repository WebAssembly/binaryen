Module["asm"] = (function(global, env, buffer) {
 "use asm";
 var setTempRet0=env.setTempRet0;
 var Math_imul = global.Math.imul;
 function test1() {
  var $b$1 = 0, $x_sroa_0_0_extract_trunc = 0, $2 = 0, $1$1 = 0, $1$0 = 0;
  // Here we use setTempRet0 as if it returns i32, and later as if no return value.
  // We should *not* expand the return type to f64, as this is not an overloaded return value
  return (setTempRet0((((Math_imul($b$1, $x_sroa_0_0_extract_trunc) | 0) + $2 | 0) + $1$1 | $1$1 & 0) | 0), 0 | $1$0 & -1) | 0;
 }
 function test2() {
  setTempRet0(10);
 }
 return {
 };
});



