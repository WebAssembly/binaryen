Module["asm"] = (function(global, env, buffer) {
 "use asm";
 var Math_imul = global.Math.imul;
 function _test(i1, i2, i3, i4, i5) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  i4 = i4 | 0;
  i5 = i5 | 0;
  var d6 = 0.0;
  if (!i5) {
   d6 = +(Math_imul(i4, i3) | 0);
   d6 = (+(i3 | 0) + d6) * (+(i4 | 0) + d6);
   i5 = ~~d6;
   return i5 | 0;
  } else {
   d6 = +(Math_imul(i2, i1) | 0);
   d6 = (+(i3 | 0) + d6) * (d6 + +(i4 | 0));
   i5 = ~~d6;
   return i5 | 0;
  }
  return 0;
 }
 return {
  _test: _test
 };
});



