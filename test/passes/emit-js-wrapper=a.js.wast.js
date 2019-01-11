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
function literal(x, type) {
  var ret = type + '.const ';
  switch (type) {
    case 'i32': ret += (x | 0); break;
    case 'f32':
    case 'f64': {
      if (x == 0 && (1 / x) < 0) ret += '-';
      ret += x;
      break;
    }
    default: throw 'what?';
  }
  return ret;
}
var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {
  'fuzzing-support': {
    'log-i32': function(x)    { console.log('[LoggingExternalInterface logging ' + literal(x, 'i32') + ']') },
    'log-i64': function(x, y) { console.log('[LoggingExternalInterface logging ' + literal(x, 'i32') + ' ' + literal(y, 'i32') + ']') },
    'log-f32': function(x)    { console.log('[LoggingExternalInterface logging ' + literal(x, 'f64') + ']') },
    'log-f64': function(x)    { console.log('[LoggingExternalInterface logging ' + literal(x, 'f64') + ']') },
  },
  'env': {
    'setTempRet0': function(x) { tempRet0 = x },
    'getTempRet0': function() { return tempRet0 },
  },
});
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('[fuzz-exec] calling $add');
  console.log('[fuzz-exec] note result: $add => ' + literal(instance.exports.add(0, 0), 'i32'));
} catch (e) {
  console.log('exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('[fuzz-exec] calling $no_return');
  instance.exports.no_return(0);
} catch (e) {
  console.log('exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('[fuzz-exec] calling $types');
  instance.exports.types(0, 0, 0, 0, 0);
} catch (e) {
  console.log('exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('[fuzz-exec] calling $types2');
  instance.exports.types2(0, 0, 0);
} catch (e) {
  console.log('exception: ' + e);
}
if (instance.exports.hangLimitInitializer) instance.exports.hangLimitInitializer();
try {
  console.log('[fuzz-exec] calling $types3');
  console.log('[fuzz-exec] note result: $types3 => ' + literal(instance.exports.types3(0, 0, 0), 'i32'));
} catch (e) {
  console.log('exception: ' + e);
}
