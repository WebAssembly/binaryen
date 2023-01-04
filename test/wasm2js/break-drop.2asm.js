
function asmFunc(imports) {
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
 function $0() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  
 }
 
 return {
  "br": $0, 
  "br_if": $1, 
  "br_table": $2
 };
}

var retasmFunc = asmFunc({
});
export var br = retasmFunc.br;
export var br_if = retasmFunc.br_if;
export var br_table = retasmFunc.br_table;
