return Module;
};
if (typeof exports != 'undefined') {
  (function(){
    var a = Binaryen();
    if (typeof module === 'object') {
      module.exports = a;
    } else {
      for (var k in a) {
        exports[k] = a[k];
      }
    }
  })();
}
this['Binaryen'] = Binaryen;
