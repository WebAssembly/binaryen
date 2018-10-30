[![Build Status](https://travis-ci.org/WebAssembly/binaryen.svg?branch=master)](https://travis-ci.org/WebAssembly/binaryen)
[![Windows CI](https://ci.appveyor.com/api/projects/status/nvm9tuwxnup9h5ar/branch/master?svg=true)](https://ci.appveyor.com/project/WebAssembly/binaryen/branch/master)

# Binaryen

Binaryen is a compiler and toolchain infrastructure library for WebAssembly,
written in C++. It aims to make [compiling to WebAssembly] **easy, fast, and
effective**:

 * **Easy**: Binaryen has a simple [C API] in a single header, and can also be
   [used from JavaScript][JS_API]. It accepts input in [WebAssembly-like
   form][compile_to_wasm] but also accepts a general [control flow graph] for
   compilers that prefer that.

 * **Fast**: Binaryen's internal IR uses compact data structures and is designed
   for completely parallel codegen and optimization, using all available CPU
   cores. Binaryen's IR also compiles down to WebAssembly extremely easily and
   quickly because it is essentially a subset of WebAssembly.

 * **Effective**: Binaryen's optimizer has many [passes] that can improve code
   very significantly (e.g. local coloring to coalesce local variables; dead
   code elimination; precomputing expressions when possible at compile time;
   etc.). These optimizations aim to make Binaryen powerful enough to be used as
   a [compiler backend][backend] by itself.  One specific area of focus is on
   WebAssembly-specific optimizations (that general-purpose compilers might not
   do), which you can think of as wasm [minification] , similar to minification
   for JavaScript, CSS, etc., all of which are language-specific (an example of
   such an optimization is block return value generation in `SimplifyLocals`).

Compilers built using Binaryen include

 * [`asm2wasm`](https://github.com/WebAssembly/binaryen/blob/master/src/asm2wasm.h) which compiles asm.js to WebAssembly
 * [`AssemblyScript`](https://github.com/AssemblyScript/assemblyscript) which compiles TypeScript to Binaryen IR
 * [`wasm2js`](https://github.com/WebAssembly/binaryen/blob/master/src/wasm2js.h) which compiles WebAssembly to JS
 * [`Asterius`](https://github.com/tweag/asterius) which compiles Haskell to WebAssembly

Binaryen also provides a set of **toolchain utilities** that can

 * **Parse** and **emit** WebAssembly. In particular this lets you load
   WebAssembly, optimize it using Binaryen, and re-emit it, thus implementing a
   wasm-to-wasm optimizer in a single command.
 * **Interpret** WebAssembly as well as run the WebAssembly spec tests.
 * Integrate with **[Emscripten](http://emscripten.org)** in order to provide a
   complete compiler toolchain from C and C++ to WebAssembly.
 * **Polyfill** WebAssembly by running it in the interpreter compiled to
   JavaScript, if the browser does not yet have native support (useful for
   testing).

Consult the [contributing instructions](Contributing.md) if you're interested in
participating.

## Binaryen IR

Binaryen's internal IR is designed to be

 * **Flexible and fast** for optimization.
 * **As close as possible to WebAssembly** so it is simple and fast to convert
   it to and from WebAssembly.

There are a few differences between Binaryen IR and the WebAssembly language:

 * Tree structure
   * Binaryen IR [is a tree][binaryen_ir], i.e., it has hierarchical structure,
     for convenience of optimization. This differs from the WebAssembly binary
     format which is a stack machine.
   * Consequently Binaryen's text format allows only s-expressions.
     WebAssembly's official text format is primarily a linear instruction list
     (with s-expression extensions). Binaryen can't read the linear style, but
     it can read a wasm text file if it contains only s-expressions.
 * Types and unreachable code
   * WebAssembly limits block/if/loop types to none and the concrete value types
     (i32, i64, f32, f64). Binaryen IR has an unreachable type, and it allows
     block/if/loop to take it, allowing [local transforms that don't need to
     know the global context][unreachable]. As a result, Binaryen's default
     text output is not necessarily valid wasm text. (To get valid wasm text,
     you can do `--generate-stack-ir --print-stack-ir`, which prints Stack IR,
     this is guaranteed to be valid for wasm parsers.)
   * Binaryen ignores unreachable code when reading WebAssembly binaries. That
     means that if you read a wasm file with unreachable code, that code will be
     discarded as if it were optimized out (often this is what you want anyhow,
     and optimized programs have no unreachable code anyway, but if you write an
     unoptimized file and then read it, it may look different). The reason for
     this behavior is that unreachable code in WebAssembly has corner cases that
     are tricky to handle in Binaryen IR (it can be very unstructured, and
     Binaryen IR is more structured than WebAssembly as noted earlier). Note
     that Binaryen does support unreachable code in .wat text files, since as we
     saw Binaryen only supports s-expressions there, which are structured.
 * Blocks
   * Binaryen IR has only one node that contains a variable-length list of
     operands: the block. WebAssembly on the other hand allows lists in loops,
     if arms, and the top level of a function. Binaryen's IR has a single
     operand for all non-block nodes; this operand may of course be a block.
     The motivation for this property is that many passes need special code
     for iterating on lists, so having a single IR node with a list simplifies
     them.
   * As in wasm, blocks and loops may have names. Branch targets in the IR are
     resolved by name (as opposed to nesting depth). This has 2 consequences:
     * Blocks without names may not be branch targets.
     * Names are required to be unique. (Reading .wat files with duplicate names
       is supported; the names are modified when the IR is constructed).
   * As an optimization, a block that is the child of a loop (or if arm, or
     function toplevel) and which has no branches targeting it will not be
     emitted when generating wasm. Instead its list of operands will be directly
     used in the containing node. Such a block is sometimes called an "implicit
     block".

As a result, you might notice that round-trip conversions (wasm => Binaryen IR
=> wasm) change code a little in some corner cases.

 * When optimizing Binaryen uses an additional IR, Stack IR (see
   `src/wasm-stack.h`). Stack IR allows a bunch of optimizations that are
   tailored for the stack machine form of WebAssembly's binary format (but Stack
   IR is less efficient for general optimizations than the main Binaryen IR). If
   you have a wasm file that has been particularly well-optimized, a simple
   round-trip conversion (just read and write, without optimization) may cause
   more noticeable differences, as Binaryen fits it into Binaryen IR's more
   structured format. If you also optimize during the round-trip conversion then
   Stack IR opts will be run and the final wasm will be better optimized.

Notes when working with Binaryen IR:

 * As mentioned above, Binaryen IR has a tree structure. As a result, each
   expression should have exactly one parent - you should not "reuse" a node by
   having it appear more than once in the tree. The motivation for this
   limitation is that when we optimize we modify nodes, so if they appear more
   than once in the tree, a change in one place can appear in another
   incorrectly.
 * For similar reasons, nodes should not appear in more than one functions.

## Tools

This repository contains code that builds the following tools in `bin/`:

 * **wasm-shell**: A shell that can load and interpret WebAssembly code. It can
   also run the spec test suite.
 * **wasm-as**: Assembles WebAssembly in text format (currently S-Expression
   format) into binary format (going through Binaryen IR).
 * **wasm-dis**: Un-assembles WebAssembly in binary format into text format
   (going through Binaryen IR).
 * **wasm-opt**: Loads WebAssembly and runs Binaryen IR passes on it.
 * **asm2wasm**: An asm.js-to-WebAssembly compiler, using Emscripten's asm
   optimizer infrastructure. This is used by Emscripten in Binaryen mode when it
   uses Emscripten's fastcomp asm.js backend.
 * **wasm2js**: A WebAssembly-to-JS compiler (still experimental).
 * **wasm-merge**: Combines wasm files into a single big wasm file (without
   sophisticated linking).
 * **wasm-ctor-eval**: A tool that can execute C++ global constructors ahead of
   time. Used by Emscripten.
 * **wasm-emscripten-finalize**: Takes a wasm binary produced by llvm+lld and
   performs emscripten-specific passes over it.
 * **wasm.js**: wasm.js contains Binaryen components compiled to JavaScript,
   including the interpreter, `asm2wasm`, the S-Expression parser, etc., which
   allow you to use Binaryen with Emscripten and execute code compiled to WASM
   even if the browser doesn't have native support yet. This can be useful as a
   (slow) polyfill.
 * **binaryen.js**: A standalone JavaScript library that exposes Binaryen methods for [creating and optimizing WASM modules](https://github.com/WebAssembly/binaryen/blob/master/test/binaryen.js/hello-world.js). For builds, see [binaryen.js on npm](https://www.npmjs.com/package/binaryen) (or download it directly from [github](https://raw.githubusercontent.com/AssemblyScript/binaryen.js/master/index.js), [rawgit](https://cdn.rawgit.com/AssemblyScript/binaryen.js/master/index.js), or [unpkg](https://unpkg.com/binaryen@latest/index.js)).

Usage instructions for each are below.

## Building

```
cmake . && make
```
Note that you can also use `ninja` as your generator: `cmake -G Ninja . && ninja`

* A C++11 compiler is required.
* The JavaScript components can be built using `build-js.sh`, see notes inside. Normally this is not needed as builds are provided in this repo already.

If you also want to compile C/C++ to WebAssembly (and not just asm.js to WebAssembly), you'll need Emscripten. You'll need the `incoming` branch there (which you can get via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)), for more details see [the wiki](https://github.com/kripken/emscripten/wiki/WebAssembly).

### Visual C++

1. Using the Microsoft Visual Studio Installer, install the "Visual C++ tools for CMake" component.

1. Generate the projects:

   ```
   mkdir build
   cd build
   "%VISUAL_STUDIO_ROOT%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" ..
   ```

   Substitute VISUAL_STUDIO_ROOT with the path to your Visual Studio
   installation. In case you are using the Visual Studio Build Tools, the path
   will be "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools".

1. From the Developer Command Prompt, build the desired projects:

   ```
   msbuild binaryen.vcxproj
   ```

   CMake generates a project named "ALL_BUILD.vcxproj" for conveniently building all the projects.

## Running

### wasm-opt

Run

````
bin/wasm-opt [.wasm or .wat file] [options] [passes, see --help] [--help]
````

The wasm optimizer receives WebAssembly as input, and can run transformation
passes on it, as well as print it (before and/or after the transformations). For
example, try

````
bin/wasm-opt test/passes/lower-if-else.wast --print
````

That will pretty-print out one of the test cases in the test suite. To run a
transformation pass on it, try

````
bin/wasm-opt test/passes/lower-if-else.wast --print --lower-if-else
````

The `lower-if-else` pass lowers if-else into a block and a break. You can see
the change the transformation causes by comparing the output of the two print
commands.

It's easy to add your own transformation passes to the shell, just add `.cpp`
files into `src/passes`, and rebuild the shell. For example code, take a look at
the [`lower-if-else` pass](https://github.com/WebAssembly/binaryen/blob/master/src/passes/LowerIfElse.cpp).

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

By default you should see pretty colors as in that image. Set `COLORS=0` in the
env to disable colors if you prefer that. On Linux and Mac, you can set
`COLORS=1` in the env to force colors (useful when piping to `more`, for
example). For Windows, pretty colors are only available when `stdout/stderr` are
not redirected/piped.

Pass `--debug` on the command line to see debug info, about asm.js functions as
they are parsed, etc.

### C/C++ Source ⇒ asm2wasm ⇒ WebAssembly

When using `emcc` with the `BINARYEN` option, it will use Binaryen to build to
WebAssembly. This lets you compile C and C++ to WebAssembly, with emscripten
using asm.js internally as a build step. Since emscripten's asm.js generation is
very stable, and asm2wasm is a fairly simple process, this method of compiling C
and C++ to WebAssembly is usable already. See the [emscripten
wiki](https://github.com/kripken/emscripten/wiki/WebAssembly) for more details
about how to use it.

## Testing

```
./check.py
```

(or `python check.py`) will run `wasm-shell`, `wasm-opt`, `asm2wasm`, `wasm.js`, etc. on the testcases in `test/`, and verify their outputs.

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for
   parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run
   them all.
 * Some tests require `emcc` or `nodejs` in the path. They will not run if the
   tool cannot be found, and you'll see a warning.
 * We have tests from upstream in `tests/spec`, in git submodules. Running
   `./check.py` should update those.

## Design Principles

 * **Interned strings for names**: It's very convenient to have names on nodes,
   instead of just numeric indices etc. To avoid most of the performance
   difference between strings and numeric indices, all strings are interned,
   which means there is a single copy of each string in memory, string
   comparisons are just a pointer comparison, etc.
 * **Allocate in arenas**: Based on experience with other
   optimizing/transformating toolchains, it's not worth the overhead to
   carefully track memory of individual nodes. Instead, we allocate all elements
   of a module in an arena, and the entire arena can be freed when the module is
   no longer needed.

## FAQ

* How does `asm2wasm` relate to the new WebAssembly backend which is being
  developed in upstream LLVM?

This is separate from that. `asm2wasm` focuses on compiling asm.js to
WebAssembly, as emitted by Emscripten's asm.js backend. This is useful because
while in the long term Emscripten hopes to use the new WebAssembly backend, the
`asm2wasm` route is a very quick and easy way to generate WebAssembly output.
It will also be useful for benchmarking the new backend as it progresses.

* How about compiling WebAssembly to asm.js (the opposite direction of
  `asm2wasm`)? Wouldn't that be useful for polyfilling?

Experimentation with this is happening, in `wasm2js`.

This would be useful, but it is a much harder task, due to some decisions made
in WebAssembly. For example, WebAssembly can have control flow nested inside
expressions, which can't directly map to asm.js. It could be supported by
outlining the code to another function, or to compiling it down into new basic
blocks and control-flow-free instructions, but it is hard to do so in a way that
is both fast to do and emits code that is fast to execute. On the other hand,
compiling asm.js to WebAssembly is almost straightforward.

We just have to do more work on `wasm2js` and see how efficient we can make it.

* Can `asm2wasm` compile any asm.js code?

Almost. Some decisions made in WebAssembly preclude that, for example, there are
no global variables. That means that `asm2wasm` has to map asm.js global
variables onto locations in memory, but then it must know of a safe zone in
memory in which to do so, and that information is not directly available in
asm.js.

`asm2wasm` and `emcc_to_wasm.js.sh` do some integration with Emscripten in order
to work around these issues, like asking Emscripten to reserve same space for
the globals, etc.

* Why the weird name for the project?

"Binaryen" is a combination of **binary** - since WebAssembly is a binary format
for the web - and **Emscripten** - with which it can integrate in order to
compile C and C++ all the way to WebAssembly, via asm.js. Binaryen began as
Emscripten's WebAssembly processing library (`wasm-emscripten`).

"Binaryen" is pronounced [in the same manner](http://www.makinggameofthrones.com/production-diary/2011/2/11/official-pronunciation-guide-for-game-of-thrones.html) as "[Targaryen](https://en.wikipedia.org/wiki/List_of_A_Song_of_Ice_and_Fire_characters#House_Targaryen)": *bi-NAIR-ee-in*. Or something like that? Anyhow, however Targaryen is correctly pronounced, they should rhyme. Aside from pronunciation, the Targaryen house words, "Fire and Blood", have also inspired Binaryen's: "Code and Bugs."

* Does it compile under Windows and/or Visual Studio?

Yes, it does. Here's a step-by-step [tutorial][win32]  on how to compile it
under **Windows 10 x64** with with **CMake** and **Visual Studio 2015**. Help
would be appreciated on Windows and OS X as most of the core devs are on Linux.

[compiling to WebAssembly]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen
[win32]: https://github.com/brakmic/brakmic/blob/master/webassembly/COMPILING_WIN32.ms
[C API]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#c-api-1
[control flow graph]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#cfg-api
[JS_API]: https://github.com/WebAssembly/binaryen/wiki/binaryen.js-API
[compile_to_wasm]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#what-do-i-need-to-have-in-order-to-use-binaryen-to-compile-to-webassembly
[passes]: https://github.com/WebAssembly/binaryen/tree/master/src/passes
[backend]: https://kripken.github.io/talks/binaryen.html#/9
[minification]: https://kripken.github.io/talks/binaryen.html#/2
[unreachable]: https://github.com/WebAssembly/binaryen/issues/903
[binaryen_ir]: https://github.com/WebAssembly/binaryen/issues/663
