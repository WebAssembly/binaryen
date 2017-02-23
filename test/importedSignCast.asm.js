function asm(global, env, buffer) {
  "use asm";

  var gm = env._emscripten_glIsTexture;

  function func() {
    gm(0) << 24 >> 24;
  }

  var FUNCTION_TABLE_a = [ gm ];

  return { func: func };
}

