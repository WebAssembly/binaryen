// Make sure node is able to find the .wasm next to the .js file. Only relevant
// when building binaryen-wasm.js (not used for binaryen.js currently).
if (
  // NOTE: Can't use ENVIRONMENT_IS_NODE here because it isn't defined yet.
  // https://github.com/kripken/emscripten/blob/incoming/src/shell.js#L26-L53
  typeof process === 'object' && typeof require === 'function' && // IS_NODE
  typeof window !== 'object' &&                                   // !IS_WEB
  typeof importScripts !== 'function'                             // !IS_WORKER
) {
  Module['locateFile'] = function(file) {
    var nodePath = require('path');
    return nodePath.join(__dirname, file);
  };
}
