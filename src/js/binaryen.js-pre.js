// Make sure node is able to find the .wasm next to the .js file. Only relevant
// when building binaryen-wasm.js (not used for binaryen.js currently).
if (
  typeof process === 'object' && typeof require === 'function' && // IS_NODE
  typeof window !== 'object' &&                                   // !IS_WEB
  typeof importScripts !== 'function'                             // !IS_WORKER
) {
  Module['locateFile'] = function(file) {
    var nodePath = require('path');
    return nodePath.join(__dirname, file);
  };
}
