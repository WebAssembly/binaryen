Module["asm"] =  (function(global, env, buffer) {
  'almost asm';

  var HEAP8 = new global.Int8Array(buffer);
  var HEAP16 = new global.Int16Array(buffer);
  var HEAP32 = new global.Int32Array(buffer);
  var HEAPU8 = new global.Uint8Array(buffer);
  var HEAPU16 = new global.Uint16Array(buffer);
  var HEAPU32 = new global.Uint32Array(buffer);
  var HEAPF32 = new global.Float32Array(buffer);
  var HEAPF64 = new global.Float64Array(buffer);

  var STACKTOP=env.STACKTOP|0;
  var STACK_MAX=env.STACK_MAX|0;

  var abortStackOverflow=env.abortStackOverflow;

  // when printing the full ast, we should see a |block i32| that
  // normal printing hides, but is crucial for validation
  function stackAlloc(size) {
    size = size|0;
    var ret = 0;
    ret = STACKTOP;
    STACKTOP = (STACKTOP + size)|0;
    STACKTOP = (STACKTOP + 15)&-16;
    if ((STACKTOP|0) >= (STACK_MAX|0)) abortStackOverflow(size|0);
    return ret|0;
  }

  return { stackAlloc: stackAlloc };
})
;
