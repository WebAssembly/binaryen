[![Build Status](https://travis-ci.org/WebAssembly/binaryen.svg?branch=master)](https://travis-ci.org/WebAssembly/binaryen) [![Windows CI](https://ci.appveyor.com/api/projects/status/nvm9tuwxnup9h5ar/branch/master?svg=true)](https://ci.appveyor.com/project/WebAssembly/binaryen/branch/master)

# Binaryen

Binaryen is a compiler and toolchain infrastructure library for WebAssembly, written in C++. It aims to make [compiling to WebAssembly](https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen) **easy, fast, and effective**:

 * **Easy**: Binaryen has a simple [C API](https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#c-api-1) in a single header. It accepts input in [WebAssembly-like form](https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#what-do-i-need-to-have-in-order-to-use-binaryen-to-compile-to-webassembly) but also accepts a general [control flow graph](https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#cfg-api) for compilers that prefer that.
 * **Fast**: Binaryen's internal IR uses compact data structures and is designed for completely parallel codegen and optimization, using all available CPU cores. Binaryen's IR also compiles down to WebAssembly extremely easily and quickly because it is essentially a subset of WebAssembly.
 * **Effective**: Binaryen's optimizer has [many passes](https://github.com/WebAssembly/binaryen/tree/master/src/passes) that can improve code very significantly (e.g. local coloring to coalesce local variables; dead code elimination; precomputing expressions when possible at compile time; etc.). These optimizations aim to make Binaryen powerful enough to be [used as a compiler backend by itself](https://kripken.github.io/talks/binaryen.html#/9). One specific area of focus is on WebAssembly-specific optimizations (that general-purpose compilers might not do), which you can think of as [wasm minification](https://kripken.github.io/talks/binaryen.html#/2), similar to minification for JavaScript, CSS, etc., all of which are language-specific (an example of such an optimization is block return value generation in `SimplifyLocals`).

Compilers built using Binaryen include

 * [`asm2wasm`](https://github.com/WebAssembly/binaryen/blob/master/src/asm2wasm.h) which compiles asm.js
 * [`s2wasm`](https://github.com/WebAssembly/binaryen/blob/master/src/s2wasm.h) which compiles the LLVM WebAssembly's backend `.s` output format
 * [`mir2wasm`](https://github.com/brson/mir2wasm/) which compiles Rust MIR

Those compilers generate Binaryen IR which can then be optimized and emitted as WebAssembly (the first two use the internal C++ API, the last the C API).

Binaryen also provides a set of **toolchain utilities** that can

 * **Parse** and **emit** WebAssembly. In particular this lets you load WebAssembly, optimize it using Binaryen, and re-emit it, thus implementing a wasm-to-wasm optimizer.
 * **Interpret** WebAssembly as well as run the WebAssembly spec tests.
 * Integrate with **[Emscripten](http://emscripten.org)** in order to provide a complete compiler toolchain from C and C++ to WebAssembly.
 * **Polyfill** WebAssembly by running it in the interpreter compiled to JavaScript, if the browser does not yet have native support (useful for testing).

Consult the [contributing instructions](Contributing.md) if you're interested in participating.

## Binaryen IR

Binaryen's internal IR is an AST, designed to be

 * **Flexible and fast** for optimization.
 * **As close as possible to WebAssembly** so it is simple and fast to convert it to and from WebAssembly.

The differences between Binaryen IR and WebAssembly are:

 * Binaryen IR [is an AST](https://github.com/WebAssembly/binaryen/issues/663), for convenience of optimization. This differs from the WebAssembly binary format which is a stack machine.
 * WebAssembly limits block/if/loop types to none and the concrete value types (i32, i64, f32, f64). Binaryen IR has an unreachable type, and it allows block/if/loop to take it, allowing [local transforms that don't need to know the global context](https://github.com/WebAssembly/binaryen/issues/903).
 * Binaryen IR's text format requires the names of blocks and loops to be unique. This differs from the WebAssembly s-expression format which allows duplicate names (and depends on scoping to disambiguate).

As a result, you might notice that round-trip conversions (wasm => Binaryen IR => wasm) change code a little in some corner cases.

## Tools

This repository contains code that builds the following tools in `bin/`:

 * **wasm-shell**: A shell that can load and interpret WebAssembly code. It can also run the spec test suite.
 * **wasm-as**: Assembles WebAssembly in text format (currently S-Expression format) into binary format (going through Binaryen IR).
 * **wasm-dis**: Un-assembles WebAssembly in binary format into text format (going through Binaryen IR).
 * **wasm-opt**: Loads WebAssembly and runs Binaryen IR passes on it.
 * **asm2wasm**: An asm.js-to-WebAssembly compiler, using Emscripten's asm optimizer infrastructure. This is used by Emscripten in Binaryen mode when it uses Emscripten's fastcomp asm.js backend.
 * **s2wasm**: A compiler from the `.s` format emitted by the new WebAssembly backend being developed in LLVM. This is used by Emscripten in Binaryen mode when it integrates with the new LLVM backend.
 * **wasm.js**: wasm.js contains Binaryen components compiled to JavaScript, including the interpreter, `asm2wasm`, the S-Expression parser, etc., which allow you to use Binaryen with Emscripten and execute code compiled to WASM even if the browser doesn't have native support yet. This can be useful as a (slow) polyfill.
 * **binaryen.js**: A standalone JavaScript library that exposes Binaryen methods for [creating and optimizing WASM modules](https://github.com/WebAssembly/binaryen/blob/master/test/binaryen.js/test.js).

Usage instructions for each are below.

## Building

```
cmake . && make
```
Note that you can also use `ninja` as your generator: `cmake -G Ninja . && ninja`

* A C++11 compiler is required.
* The JavaScript components can be built using `build-js.sh`, see notes inside. Normally this is not needed as builds are provided in this repo already.

If you also want to compile C/C++ to WebAssembly (and not just asm.js to WebAssembly), you'll need Emscripten. You'll need the `incoming` branch there (which you can get via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)), for more details see [the wiki](https://github.com/kripken/emscripten/wiki/WebAssembly).

## Running

### wasm-opt

Run

````
bin/wasm-opt [.wast file] [options] [passes, see --help] [--help]
````

The wasm optimizer receives a .wast file as input, and can run transformation passes on it, as well as print it (before and/or after the transformations). For example, try

````
bin/wasm-opt test/passes/lower-if-else.wast --print
````

That will pretty-print out one of the test cases in the test suite. To run a transformation pass on it, try

````
bin/wasm-opt test/passes/lower-if-else.wast --print --lower-if-else
````

The `lower-if-else` pass lowers if-else into a block and a break. You can see the change the transformation causes by comparing the output of the two print commands.

It's easy to add your own transformation passes to the shell, just add `.cpp` files into `src/passes`, and rebuild the shell. For example code, take a look at the [`lower-if-else` pass](https://github.com/WebAssembly/binaryen/blob/master/src/passes/LowerIfElse.cpp).

Some more notes:

 * See `bin/wasm-opt --help` for the full list of options and passes.
 * Passing `--debug` will emit some debugging info.

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
function () {
  "use asm";
  function add(x, y) {
    x = x | 0;
    y = y | 0;
    return x + y | 0;
  }
  return { add: add };
}
```

You should see something like this:

![example output](https://raw.github.com/WebAssembly/wasm-emscripten/master/media/example.png)

By default you should see pretty colors as in that image. Set `COLORS=0` in the env to disable colors if you prefer that. On Linux and Mac, you can set `COLORS=1` in the env to force colors (useful when piping to `more`, for example). For Windows, pretty colors are only available when `stdout/stderr` are not redirected/piped.

Pass `--debug` on the command line to see debug info, about asm.js functions as they are parsed, etc.

### C/C++ Source ⇒ asm2wasm ⇒ WebAssembly

When using `emcc` with the `BINARYEN` option, it will use Binaryen to build to WebAssembly. This lets you compile C and C++ to WebAssembly, with emscripten using asm.js internally as a build step. Since emscripten's asm.js generation is very stable, and asm2wasm is a fairly simple process, this method of compiling C and C++ to WebAssembly is usable already. See the [emscripten wiki](https://github.com/kripken/emscripten/wiki/WebAssembly) for more details about how to use it.

### C/C++ Source ⇒ WebAssembly LLVM backend ⇒ s2wasm ⇒ WebAssembly

Binaryen's `s2wasm` tool can translate the `.s` output from the LLVM WebAssembly backend into WebAssembly. You can receive `.s` output from `llc`, and then run `s2wasm` on that:

````
llc code.ll -march=wasm32 -filetype=asm -o code.s
s2wasm code.s > code.wast
````

You can also use Emscripten, which will do those steps for you (as well as link to system libraries, etc.). You can use either normal Emscripten, including it's "fastcomp" fork of LLVM, or you can use "vanilla" LLVM, that is, pure upstream LLVM without Emscripten's additions. With Vanilla LLVM, you can build with

````
./emcc input.cpp -s BINARYEN=1
````

With normal Emscripten, you will need to tell it to use the WebAssembly backend, since its default is asm.js, by setting an env var,

````
EMCC_WASM_BACKEND=1 ./emcc input.cpp -s BINARYEN=1
````

(without the env var, the `BINARYEN` option will make it use the asm.js backend, then `asm2wasm`).

For more details, see the [emscripten wiki](https://github.com/kripken/emscripten/wiki/WebAssembly).

## Testing

```
./check.py
```

(or `python check.py`) will run `wasm-shell`, `wasm-opt`, `asm2wasm`, `wasm.js`, etc. on the testcases in `test/`, and verify their outputs.

It will also run `s2wasm` through the last known good LLVM output from the [build waterfall][].

  [build waterfall]: https://build.chromium.org/p/client.wasm.llvm/console

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run them all.
 * Some tests require `emcc` or `nodejs` in the path. They will not run if the tool cannot be found, and you'll see a warning.
 * We have tests from upstream in `tests/spec` and `tests/waterfall`, in git submodules. Running `./check.py` should update those.

## Design Principles

 * **Interned strings for names**: It's very convenient to have names on nodes, instead of just numeric indices etc. To avoid most of the performance difference between strings and numeric indices, all strings are interned, which means there is a single copy of each string in memory, string comparisons are just a pointer comparison, etc.
 * **Allocate in arenas**: Based on experience with other optimizing/transformating toolchains, it's not worth the overhead to carefully track memory of individual nodes. Instead, we allocate all elements of a module in an arena, and the entire arena can be freed when the module is no longer needed.

## FAQ

* How does `asm2wasm` relate to the new WebAssembly backend which is being developed in upstream LLVM?

This is separate from that. `asm2wasm` focuses on compiling asm.js to WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because while in the long term Emscripten hopes to use the new WebAssembly backend, the `asm2wasm` route is a very quick and easy way to generate WebAssembly output. It will also be useful for benchmarking the new backend as it progresses.

* How about compiling WebAssembly to asm.js (the opposite direction of `asm2wasm`)? Wouldn't that be useful for polyfilling?

Experimentation with this is happening, in `wasm2asm`.

This would be useful, but it is a much harder task, due to some decisions made in WebAssembly. For example, WebAssembly can have control flow nested inside expressions, which can't directly map to asm.js. It could be supported by outlining the code to another function, or to compiling it down into new basic blocks and control-flow-free instructions, but it is hard to do so in a way that is both fast to do and emits code that is fast to execute. On the other hand, compiling asm.js to WebAssembly is almost straightforward.

We just have to do more work on `wasm2asm` and see how efficient we can make it.

* Can `asm2wasm` compile any asm.js code?

Almost. Some decisions made in WebAssembly preclude that, for example, there are no global variables. That means that `asm2wasm` has to map asm.js global variables onto locations in memory, but then it must know of a safe zone in memory in which to do so, and that information is not directly available in asm.js.

`asm2wasm` and `emcc_to_wasm.js.sh` do some integration with Emscripten in order to work around these issues, like asking Emscripten to reserve same space for the globals, etc.

* Why the weird name for the project?

"Binaryen" is a combination of **binary** - since WebAssembly is a binary format for the web - and **Emscripten** - with which it can integrate in order to compile C and C++ all the way to WebAssembly, via asm.js. Binaryen began as Emscripten's WebAssembly processing library (`wasm-emscripten`).

"Binaryen" is pronounced [in the same manner](http://www.makinggameofthrones.com/production-diary/2011/2/11/official-pronunciation-guide-for-game-of-thrones.html) as "[Targaryen](https://en.wikipedia.org/wiki/List_of_A_Song_of_Ice_and_Fire_characters#House_Targaryen)": *bi-NAIR-ee-in*. Or something like that? Anyhow, however Targaryen is correctly pronounced, they should rhyme. Aside from pronunciation, the Targaryen house words, "Fire and Blood", have also inspired Binaryen's: "Code and Bugs."

* Does it compile under Windows and/or Visual Studio?

Yes, it does. Here's a step-by-step [tutorial](https://github.com/brakmic/brakmic/blob/master/webassembly/COMPILING_WIN32.md "Compiling under Win32") on how to compile it under **Windows 10 x64** with **CMake** and **Visual Studio 2015**. Help would be appreciated on Windows and OS X as most of the core devs are on Linux.
