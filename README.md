# wasm-emscripten

This repository contains tools to compile C/C++ to WebAssembly s-expressions, using [Emscripten](http://emscripten.org/), by translating Emscripten's asm.js output into WebAssembly, as well as a WebAssembly interpreter that can run the translated code.

More specifically, this repository contains:

 * **asm2wasm**: An asm.js-to-WebAssembly compiler, built on Emscripten's asm optimizer infrastructure. That can directly compile asm.js to WebAssembly. You can use Emscripten to build C++ into asm.js, and together the two tools let you compile C/C++ to WebAssembly.
 * **wasm.js**: A polyfill for WebAssembly support in browsers. It receives an asm.js module, parses it using `asm2wasm`, and runs the resulting WebAssembly in a WebAssembly interpreter. It provides what looks like an asm.js module, while running WebAssembly inside.

## Building asm2wasm

```
$ ./build.sh
```

This requires a C++11 compiler.

Note: you might want to add `-O2` or such.

## Running

### asm2wasm

Just run

```
bin/asm2wasm [input.asm.js file]
```

This will print out a WebAssembly module in s-expression format to the console.

For example, try

```
$ bin/asm2wasm test/hello_world.asm.js
```

That input file contains

```javascript
  function add(x, y) {
    x = x | 0;
    y = y | 0;
    return x + y | 0;
  }
```

You should see something like this:

![example output](https://raw.github.com/WebAssembly/wasm-emscripten/master/media/example.png)

On Linux and Mac you should see pretty colors as in that image. Set `COLORS=0` in the env to disable colors if you prefer that. Set `COLORS=1` in the env to force colors (useful when piping to `more`, for example).

Set `ASM2WASM_DEBUG=1` in the env to see debug info, about asm.js functions as they are parsed, etc. `2` will show even more info.

### wasm.js

Run

```
./emcc_to_polyfill.sh [filename.c ; whatever other emcc flags you want]
```

That will call `emcc` and then emit `a.normal.js`, a normal asm.js build for comparison purposes, and `a.wasm.js`, which contains the entire polyfill (`asm2wasm` translator + `wasm.js` interpreter).

You will need `emcc`, so you should [grab Emscripten](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html).

### C/C++ Source => asm2wasm

Using emcc you can generate asm.js files for direct parsing by `asm2wasm` on the commandline, for example using

```
emcc src.cpp -o a.html --separate-asm
```

That will emit `a.html`, `a.js`, and `a.asm.js`. That last file is the asm.js module, which you can pass into `asm2wasm`.

If you want an optimized buid, use

```
emcc src.cpp -o a.html --separate-asm -O[2,3,etc.] -s ALIASING_FUNCTION_POINTERS=0
```

You need `ALIASING_FUNCTION_POINTERS=0` because WebAssembly does not allow aliased funciton pointers (there is a single table).

## Testing

```
./check.py
```

(or `python check.py`) will run `asm2wasm` on the testcases in `test/`, and verify their outputs.

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run them all.
 * `asm2wasm` tests require no dependencies. `wasm.js` tests require `emcc` and `nodejs` in the path.

## FAQ

 * How does this relate to the new WebAssembly backend which is being developed in upstream LLVM?
  * This is separate from that. This project focuses on compiling asm.js to WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because while in the long term Emscripten hopes to use the new WebAssembly backend, the `asm2wasm` route is a very quick and easy way to generate WebAssembly output. It will also be useful for benchmarking the new backend as it progresses.

## License & Contributing

Same as Emscripten: MIT license.

For changes to `src/`, please make pulls into emscripten's `asm2wasm` branch (in `tools/optimizer`; this code is sync'ed with there, for convenience).

## TODO

 * Waiting for switch to stablize on the spec repo; switches are Nop'ed.
 * Waiting for an interpreter with module importing support; imports are Nop'ed.
 * Start running the output through WebAssembly interpreters. Right now it is likely wrong in many ways.
 * WebAssembly lacks global variables, so `asm2wasm` maps them onto addresses in memory. This requires that you have some reserved space for those variables. You can do that with `emcc -s GLOBAL_BASE=1000`. We still need to write the code to copy the globals there.
 * Emscripten emits asm.js and JavaScript, that work together using web APIs to do things like print, render, etc. Need to figure out how to test that.
 * We could probably optimize the emitted WebAssembly.
 * Memory section needs the right size.

