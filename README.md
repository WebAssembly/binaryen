# Binaryen

Binaryen is a compiler and toolchain infrastructure library for WebAssembly, written in C++. It can:

 * **Parse** and **emit** WebAssembly, supporting the current S-Expression format.
 * **Interpret** WebAssembly. The interpreter passes 100% of the spec test suite.
 * **Compile** asm.js to WebAssembly, which together with [Emscripten](http://emscripten.org) which compiles to asm.js, gives you a complete compiler toolchain from C and C++ to WebAssembly. This passes all of the relevant part of Emscripten's test suite (everything but some odd Emscripten features like split memory).
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
bin/binaryen-shell [.wast file] [options] [passes, see --help] [--help]
````

The binaryen shell receives a .wast file as input, and can run transformation passes on it, as well as print it (before and/or after the transformations). For example, try

````
bin/binaryen-shell test/if_else.wast -print-before
````

That will pretty-print out one of the testcases in the test suite. To run a transformation pass on it, try

````
bin/binaryen-shell test/if_else.wast -print-before -print-after -lower-if-else
````

The `lower-if-else` pass lowers if-else into a block and a break. You can see the change the transformation causes by comparing the print before versus after.

It's easy to add your own transformation passes to the shell, just add `.cpp` files into `src/passes`, and rebuild the shell. For example code, take a look at the [`lower-if-else` pass](https://github.com/WebAssembly/binaryen/blob/master/src/passes/LowerIfElse.cpp).

Some more notes:

 * See `bin/binaryen-shell --help` for the full list of options and passes.
 * Setting `BINARYEN_DEBUG=1` in the env will emit some debugging info.

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

Run Emscripten's `emcc` command, passing it an additional flag:

```
emcc -s 'BINARYEN="path-to-this-dir"' [whatever other emcc flags you want]
```

(Note the need for quotes on the path, and on the entire `BINARYEN=..` argument, due to how shell argument parsing works.) The `BINARYEN` flag tells it to emit code using `wasm.js`, and where to find `wasm.js` itself. The output `*.js` file will then contain the entire polyfill (`asm2wasm` translator + `wasm.js` interpreter). The asm.js code will be in `*.asm.js`.

### C/C++ Source => asm2wasm => WebAssembly

Using emcc you can generate asm.js files for direct parsing by `asm2wasm` on the commandline, for example using

```
emcc src.cpp -o a.html --separate-asm
```

That will emit `a.html`, `a.js`, and `a.asm.js`. That last file is the asm.js module, which you can pass into `asm2wasm`.

For basic tests, that command should work, but in general you need a few more arguments to emcc, see what emcc.py does when given the `BINARYEN` option, including:

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

## FAQ

* How does `asm2wasm` relate to the new WebAssembly backend which is being developed in upstream LLVM?

This is separate from that. `asm2wasm` focuses on compiling asm.js to WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because while in the long term Emscripten hopes to use the new WebAssembly backend, the `asm2wasm` route is a very quick and easy way to generate WebAssembly output. It will also be useful for benchmarking the new backend as it progresses.

* How about compiling asm.js to WebAssembly (the opposite direction of `asm2wasm`)? Wouldn't that be useful for polyfilling?

It would be useful, but it is a much harder task, due to some decisions made in WebAssembly. For example, WebAssembly can have control flow nested inside expressions, which can't directly map to asm.js. It could be supported by outlining the code to another function, or to compiling it down into new basic blocks and control-flow-free instructions, but it is hard to do so in a way that is both fast to do and emits code that is fast to execute. On the other hand, compiling asm.js to WebAssembly is almost straightforward.

* Can `asm2wasm` compile any asm.js code?

Almost. Some decisions made in WebAssembly preclude that, for example, there are no global variables. That means that `asm2wasm` has to map asm.js global variables onto locations in memory, but then it must know of a safe zone in memory in which to do so, and that information is not directly available in asm.js.

`asm2wasm` and `emcc_to_wasm.js.sh` do some integration with Emscripten in order to work around these issues, like asking Emscripten to reserve same space for the globals, etc.

* Why the weird name for the project?

"Binaryen" is a combination of **binary** - since WebAssembly is a binary format for the web - and **Emscripten** - with which it can integrate in order to compile C and C++ all the way to WebAssembly, via asm.js. Binaryen began as Emscripten's WebAssembly processing library (`wasm-emscripten`).

"Binaryen" is pronounced [in the same manner](http://www.makinggameofthrones.com/production-diary/2011/2/11/official-pronunciation-guide-for-game-of-thrones.html) as "[Targaryen](https://en.wikipedia.org/wiki/List_of_A_Song_of_Ice_and_Fire_characters#House_Targaryen)": *bi-NAIR-ee-in*. Valar Morcodeis.

