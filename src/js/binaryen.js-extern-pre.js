// FIXME: The Emscripten shell requires this variable to be present, even though
// we are building to ES6 (where it doesn't exist) and the .wasm blob is inlined
// see: https://github.com/emscripten-core/emscripten/issues/11792
var __dirname = "";

// FIXME: The Emscripten shell requires this function to be present, even though
// we are building to ESM (where it doesn't exist) and the result is not used
// see: https://github.com/emscripten-core/emscripten/pull/17851
function require() {
  return {};
}
