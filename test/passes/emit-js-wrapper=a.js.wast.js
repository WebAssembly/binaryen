if (typeof console === 'undefined') {
  console = { log: print };
}
var tempRet0;
var binary;
if (typeof process === 'object' && typeof require === 'function' /* node.js detection */) {
  var args = process.argv.slice(2);
  binary = require('fs').readFileSync(args[0]);
  if (!binary.buffer) binary = new Uint8Array(binary);
} else {
  var args;
  if (typeof scriptArgs != 'undefined') {
    args = scriptArgs;
  } else if (typeof arguments != 'undefined') {
    args = arguments;
  }
  if (typeof readbuffer === 'function') {
    binary = new Uint8Array(readbuffer(args[0]));
  } else {
    binary = read(args[0], 'binary');
  }
}
var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {
  'fuzzing-support': {
    'log-i32': function(x) { console.log('i32: ' + x) },
    'log-i64': function(x, y) { console.log('i64: ' + x + ', ' + y) },
    'log-f32': function(x) { console.log('f32: ' + x) },
    'log-f64': function(x) { console.log('f64: ' + x) }
  },
  'env': {
    'setTempRet0': function(x) { tempRet0 = x },
    'getTempRet0': function() { return tempRet0 },
  },
});
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('calling: add');
  console.log('   result: ' + instance.exports.add(0, 0));
} catch (e) {
  console.log('   exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('calling: no_return');
instance.exports.no_return(0);
} catch (e) {
  console.log('   exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('calling: types');
instance.exports.types(0, 0, 0, 0, 0);
} catch (e) {
  console.log('   exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('calling: types2');
instance.exports.types2(0, 0, 0);
} catch (e) {
  console.log('   exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('calling: types3');
  console.log('   result: ' + instance.exports.types3(0, 0, 0));
} catch (e) {
  console.log('   exception: ' + e);
}
console.log('done.')
