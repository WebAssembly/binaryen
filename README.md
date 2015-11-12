# Binaryen

Binaryen is a C++ library for WebAssembly. It can:

 * **Interpret** WebAssembly. It passes 100% of the spec test suite.
 * **Compile** asm.js to WebAssembly, which together with [Emscripten](http://emscripten.org), gives you a complete compiler toolchain from C and C++ to WebAssembly (Emscripten compiles C and C++ to asm.js, Binaryen compiles that to WebAssembly).
 * **Polyfill** WebAssembly, by running it in the interpreter compiled to JavaScript, if the browser does not yet have native support.

To provide those capabilities, Binaryen has a simple and flexible API for **representing and processing** WebAssembly modules. The interpreter, validator, pretty-printer, etc. are built on that foundation. The core of this is in [wasm.h](https://github.com/WebAssembly/binaryen/blob/master/src/wasm.h), which contains classes that define a WebAssembly module, and tools to process those. For a simple example of how to use Binaryen, see [test/example/find_div0s.cpp](https://github.com/WebAssembly/binaryen/blob/master/test/example/find_div0s.cpp), which creates a module and then searches it for a specific pattern.

## Tools

This repository contains code that builds the following tools in `bin/`:

 * **binaryen-shell**: A shell that can load and interpret WebAssembly code in S-Expression format, and can run the spec test suite.
 * **asm2wasm**: An asm.js-to-WebAssembly compiler, built on Emscripten's asm optimizer infrastructure. That can directly compile asm.js to WebAssembly.
 * **wasm.js**: A polyfill for WebAssembly support in browsers. It receives an asm.js module, parses it using an internal build of `asm2wasm`, and runs the resulting WebAssembly in a WebAssembly interpreter. It provides what looks like an asm.js module, while running WebAssembly inside.

Usage instructions for each are below.

## Building

```
$ ./build.sh
```

* `binaryen-shell` and `asm2wasm` require a C++11 compiler.
* If you also want to compile C/C++ to WebAssembly (and not just asm.js to WebAssembly), you'll need Emscripten. You'll need the `incoming` branch there (which you can get via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)).
* `wasm.js` also requires Emscripten.

## Running

### binaryen-shell

Run

````
bin/binaryen-shell [.wast file] [--print-before]
````

 * `--print-before` will print the module before running it.
 * Setting `BINARYEN_DEBUG=1` in the env will emit a lot of debugging info.

### asm2wasm

run

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
./emcc_to_wasm.js.sh [.c or .cpp file] [whatever other emcc flags you want]
```

That will call `emcc` and then emit `a.normal.js`, a normal asm.js build for comparison purposes, and `a.wasm.js`, which contains the entire polyfill (`asm2wasm` translator + `wasm.js` interpreter).

### C/C++ Source => asm2wasm => WebAssembly

Using emcc you can generate asm.js files for direct parsing by `asm2wasm` on the commandline, for example using

```
emcc src.cpp -o a.html --separate-asm
```

That will emit `a.html`, `a.js`, and `a.asm.js`. That last file is the asm.js module, which you can pass into `asm2wasm`.

For basic tests, that command should work, but in general you need a few more arguments to emcc, see emcc's usage in `emcc_to_wasm.js.sh`, specifically:

 * `ALIASING_FUNCTION_POINTERS=0` because WebAssembly does not allow aliased function pointers (there is a single table).
 * `GLOBAL_BASE=1000` because WebAssembly lacks global variables, so `asm2wasm` maps them onto addresses in memory. This requires that you have some reserved space for those variables. With that argument, we reserve the area up to `1000`.

## Testing

```
./check.py
```

(or `python check.py`) will run `binaryen-shell`, `asm2wasm`, and `wasm.js` on the testcases in `test/`, and verify their outputs.

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run them all.
 * `asm2wasm` tests require no dependencies. `wasm.js` tests require `emcc` and `nodejs` in the path.

## License & Contributing

Same as Emscripten: MIT license.

(`src/emscripten-optimizer` is synced with `tools/optimizer/` in the main emscripten repo, for convenience)

## TODO

 * Reference interpreter lacks module importing support; imports are Nop'ed in native builds, but enabled in emcc builds (so wasm.js works).
 * Memory section needs the right size.

## FAQ

* How does `asm2wasm` relate to the new WebAssembly backend which is being developed in upstream LLVM?

This is separate from that. `asm2wasm` focuses on compiling asm.js to WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because while in the long term Emscripten hopes to use the new WebAssembly backend, the `asm2wasm` route is a very quick and easy way to generate WebAssembly output. It will also be useful for benchmarking the new backend as it progresses.

* Why the weird name for the project?

"Binaryen" is a combination of **binary** - since WebAssembly is a binary format for the web - and **Emscripten** - with which it can integrate in order to compile C and C++ all the way to WebAssembly, via asm.js. Binaryen began as Emscripten's WebAssembly processing library (`wasm-emscripten`).

"Binaryen" is pronounced [in the same manner](http://www.makinggameofthrones.com/production-diary/2011/2/11/official-pronunciation-guide-for-game-of-thrones.html) as "[Targaryen](https://en.wikipedia.org/wiki/List_of_A_Song_of_Ice_and_Fire_characters#House_Targaryen)": *bi-NAIR-ee-in*. Valar Morcodeis.

