# Binaryen

Binaryen is a compiler and toolchain infrastructure library for WebAssembly, written in C++. It can:

 * **Parse** and **emit** WebAssembly, supporting the current S-Expression format.
 * **Interpret** WebAssembly. The interpreter passes 100% of the spec test suite.
 * **Compile** asm.js to WebAssembly, which together with [Emscripten](http://emscripten.org) which compiles C and C++ to asm.js, gives you a complete compiler toolchain from C and C++ to WebAssembly. This passes all of the relevant part of Emscripten's test suite (everything but some odd Emscripten features like split memory).
 * **Polyfill** WebAssembly, by running it in the interpreter compiled to JavaScript, if the browser does not yet have native support.

To provide those capabilities, Binaryen has a simple and flexible API for **representing and processing** WebAssembly modules. The interpreter, validator, pretty-printer, etc. are built on that foundation. The core of this is in [wasm.h](https://github.com/WebAssembly/binaryen/blob/master/src/wasm.h), which contains classes that define a WebAssembly module, and tools to process those. For a simple example of how to use Binaryen, see [test/example/find_div0s.cpp](https://github.com/WebAssembly/binaryen/blob/master/test/example/find_div0s.cpp), which creates a module and then searches it for a specific pattern.

Consult the [contributing instructions](Contributing.md) if you're interested in participating.

Current build status: [![Build Status](https://travis-ci.org/WebAssembly/binaryen.svg?branch=master)](https://travis-ci.org/WebAssembly/binaryen)

## Tools

This repository contains code that builds the following tools in `bin/`:

 * **binaryen-shell**: A shell that can load and interpret WebAssembly code in S-Expression format, as well as run transformation passes on it. It can also run the spec test suite.
 * **wasm-as**: Assembles WebAssembly in text format (currently S-Expression format) into binary format (currently v8 format).
 * **wasm-dis**: Un-assembles WebAssembly in binary format (currently v8 format) into text format (currently S-Expression format).
 * **asm2wasm**: An asm.js-to-WebAssembly compiler, built on Emscripten's asm optimizer infrastructure. This is used by Emscripten in Binaryen mode when it uses Emscripten's fastcomp asm.js backend.
 * **wasm2asm**: A WebAssembly-to-asm.js compiler, the reverse of `asm2wasm`. This is a work in progress.
 * **s2wasm**: A compiler from the `.s` format emitted by the new WebAssembly backend being developed in LLVM. This is used by Emscripten in Binaryen mode when it integrates with the new LLVM backend.
 * **wasm.js**: A WebAssembly-to-JavaScript bridge. wasm.js contains Binaryen components compiled to JavaScript, including the interpreter, `asm2wasm`, the S-Expression parser, etc., which allow you to load WebAssembly and execute it even if the browser doesn't have native support yet. Having `asm2wasm` also gives the option to take an asm.js build and execute it as WebAssembly, which is useful for testing.

Usage instructions for each are below.

## Building

First run `update.py` to initialize the git submodules and fetch the test files. You may need to re-run `update.py` from time to time.

Then do

```
cmake . && make
```
Note that you can also use `ninja` as your generator: `cmake -G ninja . && ninja`.

* `binaryen-shell` and `asm2wasm` require a C++11 compiler.
* If you also want to compile C/C++ to WebAssembly (and not just asm.js to WebAssembly), you'll need Emscripten. You'll need the `incoming` branch there (which you can get via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)).
* `wasm.js` also requires Emscripten. You can compile it with `build.sh`. A pre-compiled build is provided in this repo already, so you don't need to.

## Running

### binaryen-shell

Run

````
bin/binaryen-shell [.wast file] [options] [passes, see --help] [--help]
````

The binaryen shell receives a .wast file as input, and can run transformation passes on it, as well as print it (before and/or after the transformations). For example, try

````
bin/binaryen-shell test/passes/lower-if-else.wast --print
````

That will pretty-print out one of the test cases in the test suite. To run a transformation pass on it, try

````
bin/binaryen-shell test/passes/lower-if-else.wast --print --lower-if-else
````

The `lower-if-else` pass lowers if-else into a block and a break. You can see the change the transformation causes by comparing the output of the two print commands.

It's easy to add your own transformation passes to the shell, just add `.cpp` files into `src/passes`, and rebuild the shell. For example code, take a look at the [`lower-if-else` pass](https://github.com/WebAssembly/binaryen/blob/master/src/passes/LowerIfElse.cpp).

Some more notes:

 * See `bin/binaryen-shell --help` for the full list of options and passes.
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
  function add(x, y) {
    x = x | 0;
    y = y | 0;
    return x + y | 0;
  }
```

You should see something like this:

![example output](https://raw.github.com/WebAssembly/wasm-emscripten/master/media/example.png)

On Linux and Mac you should see pretty colors as in that image. Set `COLORS=0` in the env to disable colors if you prefer that. Set `COLORS=1` in the env to force colors (useful when piping to `more`, for example).

Pass `--debug` on the command line to see debug info, about asm.js functions as they are parsed, etc. `--debug=2` will show even more info.

### wasm.js

Update your emscripten configuration file, setting the `BINARYEN_ROOT` variable to point to the directory containing binaryen.

Run Emscripten's `emcc` command, passing it an additional flag:

```
emcc -s BINARYEN=1 [whatever other emcc flags you want]
```

The `BINARYEN` flag tells it to emit code using `wasm.js`, and the `BINARYEN_ROOT` config variable tells where to find `wasm.js` itself. The output `*.js` file will then contain the entire polyfill (`asm2wasm` translator + `wasm.js` interpreter). The asm.js code will be in `*.asm.js`.

### C/C++ Source => asm2wasm => WebAssembly

Using emcc you can generate asm.js files for direct parsing by `asm2wasm` on the commandline, for example using

```
emcc src.cpp -o a.html --separate-asm
```

That will emit `a.html`, `a.js`, and `a.asm.js`. That last file is the asm.js module, which you can pass into `asm2wasm`.

For basic tests, that command should work, but in general you need a few more arguments to emcc, see what emcc.py does when given the `BINARYEN` option, including:

 * `ALIASING_FUNCTION_POINTERS=0` because WebAssembly does not allow aliased function pointers (there is a single table).
 * `GLOBAL_BASE=1000` because WebAssembly lacks global variables, so `asm2wasm` maps them onto addresses in memory. This requires that you have some reserved space for those variables. With that argument, we reserve the area up to `1000`.

### C/C++ Source => WebAssembly LLVM backend => s2wasm => WebAssembly

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

 * You can see vanilla LLVM tested with Emscripten in `check.py` in this repo (look for `VANILLA_EMCC` in that file), using an Emscripten submodule.
 * Due to current limitations of the WebAssembly backend, you might want to build with `-s ONLY_MY_CODE=1 -O1`, which will avoid linking in libc (which contains varargs, which are not yet supported), and optimizes so that the stack is not used (which is also not yet supported).
 * The output when building in this mode is similar to what you get in general when building with Binaryen in Emscripten: a main `.js` file, and the compiled code in a `.wast` file alongside it.
 * Build with `EMCC_DEBUG=1` in the env to see Emscripten's debug output as it runs the various tools, and also to save the intermediate files in `/tmp/emscripten_temp`. It will save both the `.s` and `.wast` files there (in addition to other files it normally saves).

## Testing

```
./check.py
```

(or `python check.py`) will run `binaryen-shell`, `asm2wasm`, `wasm.js`, etc. on the testcases in `test/`, and verify their outputs.

It will also run `s2wasm` through the last known good LLVM output from the [build waterfall][], as fetched by `update.py`.

  [build waterfall]: https://build.chromium.org/p/client.wasm.llvm/console

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run them all.
 * Some tests require `emcc` or `nodejs` in the path. They will not run if the tool cannot be found, and you'll see a warning.
 * We have tests from upstream in `tests/spec` and `tests/waterfall`, in git submodules. Running `./update.py` should update those.

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
