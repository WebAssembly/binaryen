// Print the label names that a wasm file has in its name section. This cannot
// be seen in the disassembly: when we do not write a name, reading the binary
// back simply generates one again, which looks the same in the output.

var filename = process.argv[2];
var bytes = new Uint8Array(require('fs').readFileSync(filename));
var module = new WebAssembly.Module(bytes);
var data = new Uint8Array(WebAssembly.Module.customSections(module, 'name')[0]);

var pos = 0;

function leb() {
  var result = 0, shift = 0, byte;
  do {
    byte = data[pos++];
    result |= (byte & 0x7f) << shift;
    shift += 7;
  } while (byte & 0x80);
  return result;
}

function str() {
  var len = leb();
  var s = new TextDecoder('utf-8').decode(data.subarray(pos, pos + len));
  pos += len;
  return s;
}

var total = 0;
while (pos < data.length) {
  var id = leb();
  var end = leb() + pos;
  // Subsection 3 holds the label names, as a map from function index to a map
  // from label index to name.
  if (id == 3) {
    for (var funcs = leb(); funcs > 0; funcs--) {
      var func = leb();
      for (var labels = leb(); labels > 0; labels--) {
        var label = leb();
        console.log('function ' + func + ', label ' + label + ': ' + str());
        total++;
      }
    }
  }
  pos = end;
}
console.log(total + ' label name' + (total == 1 ? '' : 's'));
