[![CI](https://github.com/WebAssembly/binaryen/workflows/CI/badge.svg?branch=master&event=push)](https://github.com/WebAssembly/binaryen/actions?query=workflow%3ACI)

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

 * **Effective**: Binaryen's optimizer has many passes (see an overview later
   down) that can improve code size and speed. These optimizations aim to make
   Binaryen powerful enough to be used as a [compiler backend][backend] by
   itself.  One specific area of focus is on WebAssembly-specific optimizations
   (that general-purpose compilers might not do), which you can think of as
   wasm [minification] , similar to minification for JavaScript, CSS, etc., all
   of which are language-specific.

Compilers using Binaryen include:

 * [`AssemblyScript`](https://github.com/AssemblyScript/assemblyscript) which compiles a subset of TypeScript to WebAssembly
 * [`wasm2js`](https://github.com/WebAssembly/binaryen/blob/master/src/wasm2js.h) which compiles WebAssembly to JS
 * [`Asterius`](https://github.com/tweag/asterius) which compiles Haskell to WebAssembly
 * [`Grain`](https://github.com/grain-lang/grain) which compiles Grain to WebAssembly

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
   * Binaryen uses Stack IR to optimize "stacky" code (that can't be
     represented in structured form).
   * When stacky code must be represented in Binaryen IR, such as with
     multivalue instructions and blocks, it is represented with tuple types that
     do not exist in the WebAssembly language. In addition to multivalue
     instructions, locals and globals can also have tuple types in Binaryen IR
     but not in WebAssembly.
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
 * Multivalue
   * Binaryen will not represent multivalue instructions and values directly.
     Binaryen's main focus is on optimization of wasm, and therefore the question
     of whether we should have multivalue in the main IR is whether it justifes
     the extra complexity there. Experiments show that the shrinking of code
     size thanks to multivalue is useful but small, just 1-3% or so. Given that,
     we prefer to keep the main IR simple, and focus on multivalue optimizations
     in Stack IR, which is more suitable for such things.
   * Binaryen does still need to implement the "ABI" level of multivalue, that
     is, we need multivalue calls because those may cross module boundaries,
     and so they are observable externally. To support that, Binaryen may use
     `push` and `pop` as mentioned earlier; another option is to add LLVM-like
     `extractvalue/composevalue` instructions.

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

 * **wasm-opt**: Loads WebAssembly and runs Binaryen IR passes on it.
 * **wasm-as**: Assembles WebAssembly in text format (currently S-Expression
   format) into binary format (going through Binaryen IR).
 * **wasm-dis**: Un-assembles WebAssembly in binary format into text format
   (going through Binaryen IR).
 * **wasm2js**: A WebAssembly-to-JS compiler. This is used by Emscripten to
   generate JavaScript as an alternative to WebAssembly.
 * **wasm-reduce**: A testcase reducer for WebAssembly files. Given a wasm file
   that is interesting for some reason (say, it crashes a specific VM),
   wasm-reduce can find a smaller wasm file that has the same property, which is
   often easier to debug. See the
   [docs](https://github.com/WebAssembly/binaryen/wiki/Fuzzing#reducing)
   for more details.
 * **wasm-shell**: A shell that can load and interpret WebAssembly code. It can
   also run the spec test suite.
 * **wasm-emscripten-finalize**: Takes a wasm binary produced by llvm+lld and
   performs emscripten-specific passes over it.
 * **wasm-ctor-eval**: A tool that can execute C++ global constructors ahead of
   time. Used by Emscripten.
 * **binaryen.js**: A standalone JavaScript library that exposes Binaryen methods for [creating and optimizing WASM modules](https://github.com/WebAssembly/binaryen/blob/master/test/binaryen.js/hello-world.js). For builds, see [binaryen.js on npm](https://www.npmjs.com/package/binaryen) (or download it directly from [github](https://raw.githubusercontent.com/AssemblyScript/binaryen.js/master/index.js), [rawgit](https://cdn.rawgit.com/AssemblyScript/binaryen.js/master/index.js), or [unpkg](https://unpkg.com/binaryen@latest/index.js)).

Usage instructions for each are below.

## Binaryen Optimizations

Binaryen contains
[a lot of optimization passes](https://github.com/WebAssembly/binaryen/tree/master/src/passes)
to make WebAssembly smaller and faster. You can run the Binaryen optimizer by
using ``wasm-opt``, but also they can be run while using other tools, like
``wasm2js`` and ``wasm-metadce``.

The full list of passes is in the link above. This section summarizes some key
points:

* The default optimization pipeline is set up by functions like
  [`addDefaultFunctionOptimizationPasses`](https://github.com/WebAssembly/binaryen/blob/369b8bdd3d9d49e4d9e0edf62e14881c14d9e352/src/passes/pass.cpp#L396).
* There are various
  [pass options](https://github.com/WebAssembly/binaryen/blob/369b8bdd3d9d49e4d9e0edf62e14881c14d9e352/src/pass.h#L85)
  that you can set, to adjust the optimization and shrink levels, whether to
  ignore unlikely traps, inlining heuristics, fast-math, and so forth. See
  ``wasm-opt --help`` for how to set them and other details.

See each optimization passes for details of what it does, but here is a quick
overview of some of the more important ones:

Particularly important passes are in blue italics.

* **CoalesceLocals** - Key “register allocation” pass. Does a live range
  analysis and then reuses locals in order to minimize their number, as well as
  to remove copies between them.
* **CodeFolding** - Avoids duplicate code by merging it (e.g. if two `if` arms
  have some shared instructions at their end).
* **CodePushing** - “Pushes” code forward past branch operations, potentially
  allowing the code to not be run if the branch is taken.
* **DeadArgumentElimination** - LTO pass to remove arguments to a function if it
  is always called with the same constants.
* **DeadCodeElimination**
* **Directize** - Turn an indirect call into a normal call, when the table index
  is constant.
* **DuplicateFunctionElimination** - LTO pass.
* **Inlining** - LTO pass.
* **LocalCSE** - Simple local common subexpression elimination.
* **LoopInvariantCodeMotion**
* **MemoryPacking** - Key "optimize data segments" pass that combines segments,
  removes unneeded parts, etc.
* **MergeBlocks** - Merge a `block` to an outer one where possible, reducing
  their number.
* **MergeLocals** - When two locals have the same value in part of their
  overlap, pick in a way to help CoalesceLocals do better later (split off from
  CoalesceLocals to keep the latter simple).
* **MinifyImportsAndExports** - Minifies them to “a”, “b”, etc.
* **OptimizeAddedConstants** - Optimize a load/store with an added constant into
  a constant offset.
* **OptimizeInstructions** - Key peephole optimization pass with a constantly
  increasing list of patterns.
* **PickLoadSigns** - Adjust whether a load is signed or unsigned in order to
  avoid sign/unsign operations later.
* **Precompute** - Calculates constant expressions at compile time, using the
  built-in interpreter (which is guaranteed to be able to handle any constant
  expression).
* **ReReloop** - Transforms wasm structured control flow to a CFG and then goes
  back to structured form using the Relooper algorithm, which may find more
  optimal shapes.
* **RedundantSetElimination** - Removes a `local.set` of a value that is already
  present in a local. (Overlaps with CoalesceLocals; this achieves the specific
  operation just mentioned without all the other work CoalesceLocals does, and
  therefore is useful in other places in the optimization pipeline.)
* **RemoveUnsedBrs** - Key “minor control flow optimizations” pass, including
  jump threading and various transforms that can get rid of a `br` or `br_table`
  (like turning a `block` with a `br` in the middle into an `if` when possible).
* **RemoveUnusedModuleElements** - “Global DCE”, an LTO pass that removes
  imports, functions, globals, etc., when they are not used.
* **ReorderFunctions** - Put more-called functions first, potentially allowing
  the LEB emitted to call them to be smaller (in a very large program).
* **ReorderLocals** - Put more-used locals first, potentially allowing the LEB
  emitted to use them to be smaller (in a very large function). After the
  sorting, it also removes locals not used at all.
* **SimplifyGlobals** - Optimizes globals in various ways, for example,
  coalescing them, removing mutability from a global never modified, applying a
  constant value from an immutable global, etc.
* **SimplifyLocals** - Key “`local.get/set/tee`” optimization pass, doing things
  like replacing a set and a get with moving the set’s value to the get (and
  creating a tee) where possible. Also creates `block/if/loop` return values
  instead of using a local to pass the value.
* **Vacuum** - Key “remove silly unneeded code” pass, doing things like removing
  an `if` arm that has no contents, a drop of a constant value with no side
  effects, a `block` with a single child, etc.

“LTO” in the above means an optimization is Link Time Optimization-like in that
it works across multiple functions, but in a sense Binaryen is always “LTO” as
it usually is run on the final linked wasm.

Advanced optimization techniques in the Binaryen optimizer include
[SSAification](https://github.com/WebAssembly/binaryen/blob/master/src/passes/SSAify.cpp),
[Flat IR](https://github.com/WebAssembly/binaryen/blob/master/src/ir/flat.h), and
[Stack/Poppy IR](https://github.com/WebAssembly/binaryen/blob/master/src/ir/stack-utils.h).

Binaryen also contains various passes that do other things than optimizations,
like
[legalization for JavaScript](https://github.com/WebAssembly/binaryen/blob/master/src/passes/LegalizeJSInterface.cpp),
[Asyncify](https://github.com/WebAssembly/binaryen/blob/master/src/passes/Asyncify.cpp),
etc.

## Building

```
cmake . && make
```

A C++14 compiler is required. Note that you can also use `ninja` as your generator: `cmake -G Ninja . && ninja`.

Binaryen.js can be built using Emscripten, which can be installed via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)).

```
emcmake cmake . && emmake make binaryen_js
```

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
bin/wasm-opt test/passes/lower-if-else.wat --print
````

That will pretty-print out one of the test cases in the test suite. To run a
transformation pass on it, try

````
bin/wasm-opt test/passes/lower-if-else.wat --print --lower-if-else
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

### wasm2js

Run

```
bin/wasm2js [input.wasm file]
```

This will print out JavaScript to the console.

For example, try

```
$ bin/wasm2js test/hello_world.wat
```

That output contains

```
 function add(x, y) {
  x = x | 0;
  y = y | 0;
  return x + y | 0 | 0;
 }
```

as a translation of

```
 (func $add (; 0 ;) (type $0) (param $x i32) (param $y i32) (result i32)
  (i32.add
   (local.get $x)
   (local.get $y)
  )
 )
```

wasm2js's output is in ES6 module format - basically, it converts a wasm
module into an ES6 module (to run on older browsers and Node.js versions
you can use Babel etc. to convert it to ES5). Let's look at a full example
of calling that hello world wat; first, create the main JS file:

```javascript
// main.mjs
import { add } from "./hello_world.mjs";
console.log('the sum of 1 and 2 is:', add(1, 2));
```

The run this (note that you need a new enough Node.js with ES6 module
support):

```shell
$ bin/wasm2js test/hello_world.wat -o hello_world.mjs
$ node --experimental-modules main.mjs
the sum of 1 and 2 is: 3
```

Things keep to in mind with wasm2js's output:

 * You should run wasm2js with optimizations for release builds, using `-O`
   or another optimization level. That will optimize along the entire pipeline
   (wasm and JS). It won't do everything a JS minifer would, though, like
   minify whitespace, so you should still run a normal JS minifer afterwards.
 * It is not possible to match WebAssembly semantics 100% precisely with fast
   JavaScript code. For example, every load and store may trap, and to make
   JavaScript do the same we'd need to add checks everywhere, which would be
   large and slow. Instead, wasm2js assumes loads and stores do not trap, that
   int/float conversions do not trap, and so forth. There may also be slight
   differences in corner cases of conversions, like non-trapping float to int.

## Testing

```
./check.py
```

(or `python check.py`) will run `wasm-shell`, `wasm-opt`, etc. on the testcases in `test/`, and verify their outputs.

The `check.py` script supports some options:

```
./check.py [--interpreter=/path/to/interpreter] [TEST1] [TEST2]..
```

 * If an interpreter is provided, we run the output through it, checking for
   parse errors.
 * If tests are provided, we run exactly those. If none are provided, we run
   them all. To see what tests are available, run `./check.py --list-suites`.
 * Some tests require `emcc` or `nodejs` in the path. They will not run if the
   tool cannot be found, and you'll see a warning.
 * We have tests from upstream in `tests/spec`, in git submodules. Running
   `./check.py` should update those.

### Setting up dependencies

```
./third_party/setup.py [mozjs|v8|wabt|all]
```

(or `python third_party/setup.py`) installs required dependencies like the SpiderMonkey JS shell, the V8 JS shell
and WABT in `third_party/`. Other scripts automatically pick these up when installed.

### Fuzzing

```
./scripts/fuzz_opt.py [--binaryen-bin=build/bin]
```

(or `python scripts/fuzz_opt.py`) will run various fuzzing modes on random inputs with random passes until it finds
a possible bug. See [the wiki page](https://github.com/WebAssembly/binaryen/wiki/Fuzzing) for all the details.

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
[win32]: https://github.com/brakmic/bazaar/blob/master/webassembly/COMPILING_WIN32.md
[C API]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#c-api-1
[control flow graph]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#cfg-api
[JS_API]: https://github.com/WebAssembly/binaryen/wiki/binaryen.js-API
[compile_to_wasm]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#what-do-i-need-to-have-in-order-to-use-binaryen-to-compile-to-webassembly
[backend]: https://kripken.github.io/talks/binaryen.html#/9
[minification]: https://kripken.github.io/talks/binaryen.html#/2
[unreachable]: https://github.com/WebAssembly/binaryen/issues/903
[binaryen_ir]: https://github.com/WebAssembly/binaryen/issues/663
