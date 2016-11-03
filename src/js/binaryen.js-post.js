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
(typeof window !== 'undefined' ? window :
 typeof global !== 'undefined' && (
  typeof process === 'undefined' ||
  
  // Note: We must export "Binaryen" even inside a CommonJS/AMD/UMD module
  // space because check.py generates a.js which requires Binaryen global var
  ( process.argv &&
    Array.isArray(process.argv) &&
    process.argv[1] &&
    (process.argv[1].substr(-5) === '/a.js' ||
     process.argv[1].substr(-5) === '\\a.js')
  )

 ) ? global :
 this
)['Binaryen'] = Binaryen;
