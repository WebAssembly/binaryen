var filename = process.argv[2];
var module = new WebAssembly.Module(require('fs').readFileSync(filename));
var sections = WebAssembly.Module.customSections(module, 'string.consts');
var array = new Uint8Array(sections[0]);
var string = new TextDecoder('utf-8').decode(array);

function standardizeEncoding(s) {
  // Different node.js versions print differently, so we must standardize to
  // pass tests in all places. In particular at some point node.js started to
  // abbreviate \u0000 as \x00 (both of which are valid).
  return s.replace('\\u0000', '\\x00');
}

console.log("string:", standardizeEncoding(string));

var json = JSON.stringify(JSON.parse(string));
console.log("JSON:", standardizeEncoding(json));
