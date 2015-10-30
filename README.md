# wasm-emscripten

This repository contains tools to compile C/C++ to WebAssembly s-expressions, using [Emscripten](http://emscripten.org/), by translating Emscripten's asm.js output into WebAssembly.

More specifically, this repository contains an asm.js-to-WebAssembly compiler, **asm2wasm**, built on Emscripten's asm optimizer infrastructure. That can directly compile asm.js to WebAssembly. You can use Emscripten to build C++ into asm.js, and together the two tools let you compile C/C++ to WebAssembly.

## Building asm2wasm

```
$ ./build.sh
```

This requires a C++11 compiler.

## Running

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

Set `ASM2WASM_DEBUG=1` in the env to see debug info, about asm.js nodes as they are parsed, etc.

## Starting from C/C++ Source

[Grab Emscripten](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html), and build the source file into asm.js, for example using

```
emcc src.cpp -o a.html --separate-asm
```

That will emit `a.html`, `a.js`, and `a.asm.js`. That last file is the asm.js module, which you can pass into `asm2wasm`.

 * Note: you can try `-O1` or higher, but you should probably use `--profiling` which keeps the code semi-readable (otherwise, you'll get minified names, etc., and that code path is untested).

## TODO

 * Start running the output through WebAssembly interpreters. Right now it is likely wrong in many ways.
 * WebAssembly lacks global variables, so `asm2wasm` maps them onto addresses in memory. This requires that you have some reserved space for those variables. You can do that with `emcc -s GLOBAL_BASE=1000`. We still need to write the code to copy the globals there.
 * Emscripten emits asm.js and JavaScript, that work together using web APIs to do things like print, render, etc. Need to figure out how to test that.
 * We could probably optimize the emitted WebAssembly.

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

## FAQ

 * How does this relate to the new WebAssembly backend which is being developed in upstream LLVM?
  * This is separate from that. This project focuses on compiling asm.js to WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because while in the long term Emscripten hopes to use the new WebAssembly backend, the `asm2wasm` route is a very quick and easy way to generate WebAssembly output. It will also be useful for benchmarking the new backend as it progresses.

## License & Contributing

Same as Emscripten: MIT license.

For changes to `src/`, please make pulls into emscripten's `asm2wasm` branch (in `tools/optimizer`; this code is sync'ed with there, for convenience).

