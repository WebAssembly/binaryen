import * as mod_ule_x from 'mod\'ule\"x';

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
 var mod_ule_x = imports["mod\'ule\"x"];
 var base = mod_ule_x["ba\\se\'"];
 function exported() {
  base();
 }
 
 return {
  "exported": exported
 };
}

var retasmFunc = asmFunc({
  "mod\'ule\"x": mod_ule_x,
});
export var exported = retasmFunc.exported;
