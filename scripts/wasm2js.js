// wasm2js.js - enough of a polyfill for the WebAssembly object so that we can load
// wasm2js code that way. Similar to the same file in emscripten, but tailored for
// fuzzing purposes here.

var WebAssembly = {
  Memory: function(opts) {
    return {
      buffer: new ArrayBuffer(opts['initial'] * 64 * 1024),
      grow: function(amount) {
        var oldBuffer = this.buffer;
        var ret = __growWasmMemory(amount);
        assert(this.buffer !== oldBuffer); // the call should have updated us
        return ret;
      }
    };
  },

  Table: function(opts) {
    var ret = new Array(opts['initial']);
    ret.grow = function(by) {
      ret.push(null);
    };
    ret.set = function(i, func) {
      ret[i] = func;
    };
    ret.get = function(i) {
      return ret[i];
    };
    return ret;
  },

  Module: function(binary) {
    // TODO: use the binary and info somehow - right now the wasm2js output is embedded in
    // the main JS
    return {};
  },

  Instance: function(module, info) {
    // TODO: use the module and info somehow - right now the wasm2js output is embedded in
    // the main JS
    var decodeBase64 = typeof atob === 'function' ? atob : function (input) {
      var keyStr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';

      var output = '';
      var chr1, chr2, chr3;
      var enc1, enc2, enc3, enc4;
      var i = 0;
      // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
      input = input.replace(/[^A-Za-z0-9\+\/\=]/g, '');
      do {
        enc1 = keyStr.indexOf(input.charAt(i++));
        enc2 = keyStr.indexOf(input.charAt(i++));
        enc3 = keyStr.indexOf(input.charAt(i++));
        enc4 = keyStr.indexOf(input.charAt(i++));

        chr1 = (enc1 << 2) | (enc2 >> 4);
        chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
        chr3 = ((enc3 & 3) << 6) | enc4;

        output = output + String.fromCharCode(chr1);

        if (enc3 !== 64) {
          output = output + String.fromCharCode(chr2);
        }
        if (enc4 !== 64) {
          output = output + String.fromCharCode(chr3);
        }
      } while (i < input.length);
      return output;
    };
    var atob = decodeBase64;
    // Additional imports
    asmLibraryArg['__tempMemory__'] = 0; // risky!
    // This will be replaced by the actual wasm2js code.
    var exports = instantiate(asmLibraryArg, wasmMemory, wasmTable);
    return {
      'exports': exports
    };
  },

  instantiate: function(binary, info) {
    return {
      then: function(ok, err) {
        ok({
          'instance': new WebAssembly.Instance(new WebAssembly.Module(binary, info))
        });
      }
    };
  }
};

var tempRet0 = 0;

var asmLibraryArg = {
  log_i32: function(x) {
    console.log('[LoggingExternalInterface logging ' + literal(x, 'i32') + ']');
  },
  log_i64: function(x, h) {
    console.log('[LoggingExternalInterface logging ' + literal(x, 'i32') + ' ' + literal(h, 'i32') + ']');
  },
  log_f32: function(x) {
    console.log('[LoggingExternalInterface logging ' + literal(x, 'f64') + ']');
  },
  log_f64: function(x) {
    console.log('[LoggingExternalInterface logging ' + literal(x, 'f64') + ']');
  },
  log_execution: function(loc) {
    console.log('log_execution ' + loc);
  },
  setTempRet0: function(x) {
    tempRet0 = x;
  },
  getTempRet0: function() {
    return x;
  },
  get_i32: function(loc, index, value) {
    console.log('get_i32 ' + [loc, index, value]);
    return value;
  },
  get_i64: function(loc, index, low, high) {
    console.log('get_i64 ' + [loc, index, low, high]);
    asmLibraryArg['setTempRet0'](high);
    return low;
  },
  get_f32: function(loc, index, value) {
    console.log('get_f32 ' + [loc, index, value]);
    return value;
  },
  get_f64: function(loc, index, value) {
    console.log('get_f64 ' + [loc, index, value]);
    return value;
  },
  get_anyref: function(loc, index, value) {
    console.log('get_anyref ' + [loc, index, value]);
    return value;
  },
  get_exnref: function(loc, index, value) {
    console.log('get_exnref ' + [loc, index, value]);
    return value;
  },
  set_i32: function(loc, index, value) {
    console.log('set_i32 ' + [loc, index, value]);
    return value;
  },
  set_i64: function(loc, index, low, high) {
    console.log('set_i64 ' + [loc, index, low, high]);
    asmLibraryArg['setTempRet0'](high);
    return low;
  },
  set_f32: function(loc, index, value) {
    console.log('set_f32 ' + [loc, index, value]);
    return value;
  },
  set_f64: function(loc, index, value) {
    console.log('set_f64 ' + [loc, index, value]);
    return value;
  },
  set_anyref: function(loc, index, value) {
    console.log('set_anyref ' + [loc, index, value]);
    return value;
  },
  set_exnref: function(loc, index, value) {
    console.log('set_exnref ' + [loc, index, value]);
    return value;
  },
  load_ptr: function(loc, bytes, offset, ptr) {
    console.log('load_ptr ' + [loc, bytes, offset, ptr]);
    return ptr;
  },
  load_val_i32: function(loc, value) {
    console.log('load_val_i32 ' + [loc, value]);
    return value;
  },
  load_val_i64: function(loc, low, high) {
    console.log('load_val_i64 ' + [loc, low, high]);
    asmLibraryArg['setTempRet0'](high);
    return low;
  },
  load_val_f32: function(loc, value) {
    console.log('loaload_val_i32d_ptr ' + [loc, value]);
    return value;
  },
  load_val_f64: function(loc, value) {
    console.log('load_val_f64 ' + [loc, value]);
    return value;
  },
  store_ptr: function(loc, bytes, offset, ptr) {
    console.log('store_ptr ' + [loc, bytes, offset, ptr]);
    return ptr;
  },
  store_val_i32: function(loc, value) {
    console.log('store_val_i32 ' + [loc, value]);
    return value;
  },
  store_val_i64: function(loc, low, high) {
    console.log('store_val_i64 ' + [loc, low, high]);
    asmLibraryArg['setTempRet0'](high);
    return low;
  },
  store_val_f32: function(loc, value) {
    console.log('loastore_val_i32d_ptr ' + [loc, value]);
    return value;
  },
  store_val_f64: function(loc, value) {
    console.log('store_val_f64 ' + [loc, value]);
    return value;
  },
};

var wasmMemory = new WebAssembly.Memory({ initial: 1 });
var wasmTable = new WebAssembly.Table({ initial: 1 });

