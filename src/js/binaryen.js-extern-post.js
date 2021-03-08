
})();
if (typeof exports === 'object' && typeof module === 'object')
  module.exports = binaryen;
else if (typeof define === 'function' && define['amd'])
  define([], function() { return binaryen; });
else if (typeof exports === 'object')
  exports["binaryen"] = binaryen;