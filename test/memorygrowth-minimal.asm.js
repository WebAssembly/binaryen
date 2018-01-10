Module["asm"] =  (function(global,env,buffer) {

 "almost asm";
 var a = global.Int8Array;
 var b = global.Int16Array;
 var c = global.Int32Array;
 var d = global.Uint8Array;
 var e = global.Uint16Array;
 var f = global.Uint32Array;
 var g = global.Float32Array;
 var h = global.Float64Array;
 var i = new a(buffer);
 var j = new b(buffer);
 var k = new c(buffer);
 var l = new d(buffer);
 var m = new e(buffer);
 var n = new f(buffer);
 var o = new g(buffer);
 var p = new h(buffer);
 var q = global.byteLength;

 function replaceBuffer(newBuffer) {
  if (q(newBuffer) & 16777215 || q(newBuffer) <= 16777215 || q(newBuffer) > 2147483648) return false;
  i = new a(newBuffer);
  j = new b(newBuffer);
  k = new c(newBuffer);
  l = new d(newBuffer);
  m = new e(newBuffer);
  n = new f(newBuffer);
  o = new g(newBuffer);
  p = new h(newBuffer);
  buffer = newBuffer;
  return true;
 }
 return {
  _emscripten_replace_memory: replaceBuffer
 };
})


;
