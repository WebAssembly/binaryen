import * as mod_ule from 'mod.ule';

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
 var mod_ule = imports["mod.ule"];
 var base = mod_ule["ba.se"];
 function $0() {
  base();
 }
 
 return {
  "exported": $0
 };
}

var retasmFunc = asmFunc({
  "mod.ule": mod_ule,
});
export var exported = retasmFunc.exported;
