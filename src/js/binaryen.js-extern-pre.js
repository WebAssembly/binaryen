// FIXME: The Emscripten shell requires this variable to be present, even though
// we are building to ES6 (where it doesn't exist) and the .wasm blob is inlined
// see: https://github.com/emscripten-core/emscripten/issues/11792
var __dirname = "";
