var filename = process.argv[2];
var module = new WebAssembly.Module(require('fs').readFileSync(filename));
var sections = WebAssembly.Module.customSections(module, 'string.consts');
var array = new Uint8Array(sections[0]);
var string = new TextDecoder('utf-8').decode(array);
console.log("JSON:", string);
