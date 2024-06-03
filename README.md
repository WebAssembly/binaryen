[![CI](https://github.com/WebAssembly/binaryen/workflows/CI/badge.svg?branch=main&event=push)](https://github.com/WebAssembly/binaryen/actions?query=workflow%3ACI)

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
   itself. One specific area of focus is on WebAssembly-specific optimizations
   (that general-purpose compilers might not do), which you can think of as
   wasm [minification], similar to minification for JavaScript, CSS, etc., all
   of which are language-specific.

Toolchains using Binaryen as a **component** (typically running `wasm-opt`) include:

  * [`Emscripten`](http://emscripten.org) (C/C++)
  * [`wasm-pack`](https://github.com/rustwasm/wasm-pack) (Rust)
  * [`J2CL`](https://j2cl.io/) (Java; [`J2Wasm`](https://github.com/google/j2cl/tree/master/samples/wasm))
  * [`Kotlin`](https://kotl.in/wasmgc) (Kotlin/Wasm)
  * [`Dart`](https://flutter.dev/wasm) (Flutter)

For more on how some of those work, see the toolchain architecture parts of
the [V8 WasmGC porting blogpost](https://v8.dev/blog/wasm-gc-porting).

Compilers using Binaryen as a **library** include:

 * [`AssemblyScript`](https://github.com/AssemblyScript/assemblyscript) which compiles a variant of TypeScript to WebAssembly
 * [`wasm2js`](https://github.com/WebAssembly/binaryen/blob/main/src/wasm2js.h) which compiles WebAssembly to JS
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
     but not in WebAssembly. Experiments show that better support for
     multivalue could enable useful but small code size savings of 1-3%, so it
     has not been worth changing the core IR structure to support it better.
   * Block input values (currently only supported in `catch` blocks in the
     exception handling feature) are represented as `pop` subexpressions.
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
 * Reference Types
  * The wasm text and binary formats require that a function whose address is
    taken by `ref.func` must be either in the table, or declared via an
    `(elem declare func $..)`. Binaryen will emit that data when necessary, but
    it does not represent it in IR. That is, IR can be worked on without needing
    to think about declaring function references.
  * Binaryen IR allows non-nullable locals in the form that the wasm spec does,
    (which was historically nicknamed "1a"), in which a `local.get` must be
    structurally dominated by a `local.set` in order to validate (that ensures
    we do not read the default value of null). Despite being aligned with the
    wasm spec, there are some minor details that you may notice:
    * A nameless `Block` in Binaryen IR does not interfere with validation.
      Nameless blocks are never emitted into the binary format (we just emit
      their contents), so we ignore them for purposes of non-nullable locals. As
      a result, if you read wasm text emitted by Binaryen then you may see what
      seems to be code that should not validate per the spec (and may not
      validate in wasm text parsers), but that difference will not exist in the
      binary format (binaries emitted by Binaryen will always work everywhere,
      aside for bugs of course).
    * The Binaryen pass runner will automatically fix up validation after each
      pass (finding things that do not validate and fixing them up, usually by
      demoting a local to be nullable). As a result you do not need to worry
      much about this when writing Binaryen passes. For more details see the
      `requiresNonNullableLocalFixups()` hook in `pass.h` and the
      `LocalStructuralDominance` class.
  * `br_if` output types are more refined in Binaryen IR: they have the type of
    the value, when a value flows in. In the wasm spec the type is that of the
    branch target, which may be less refined. Using the more refined type here
    ensures that we optimize in the best way possible, using all the type
    information, but it does mean that some roundtripping operations may look a
    little different. In particular, when we emit a `br_if` whose type is more
    refined in Binaryen IR then we emit a cast right after it, so that the
    output has the right type in the wasm spec. That may cause a few bytes of
    extra size in rare cases (we avoid this overhead in the common case where
    the `br_if` value is unused).
 * Strings
   * Binaryen allows string views (`stringview_wtf16` etc.) to be cast using
     `ref.cast`. This simplifies the IR, as it allows `ref.cast` to always be
     used in all places (and it is lowered to `ref.as_non_null` where possible
     in the optimizer). The stringref spec does not seem to allow this though,
     and to fix that the binary writer will replace `ref.cast` that casts a
     string view to a non-nullable type to `ref.as_non_null`. A `ref.cast` of a
     string view that is a no-op is skipped entirely.

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

### Intrinsics

Binaryen intrinsic functions look like calls to imports, e.g.,

```wat
(import "binaryen-intrinsics" "foo" (func $foo))
```

Implementing them that way allows them to be read and written by other tools,
and it avoids confusing errors on a binary format error that could happen in
those tools if we had a custom binary format extension.

An intrinsic method may be optimized away by the optimizer. If it is not, it
must be **lowered** before shipping the wasm, as otherwise it will look like a
call to an import that does not exist (and VMs will show an error on not having
a proper value for that import). That final lowering is *not* done
automatically. A user of intrinsics must run the pass for that explicitly,
because the tools do not know when the user intends to finish optimizing, as the
user may have a pipeline of multiple optimization steps, or may be doing local
experimentation, or fuzzing/reducing, etc. Only the user knows when the final
optimization happens before the wasm is "final" and ready to be shipped. Note
that, in general, some additional optimizations may be possible after the final
lowering, and so a useful pattern is to optimize once normally with intrinsics,
then lower them away, then optimize after that, e.g.:

```bash
wasm-opt input.wasm -o output.wasm -O --intrinsic-lowering -O
```

Each intrinsic defines its semantics, which includes what the optimizer is
allowed to do with it and what the final lowering will turn it to. See
[intrinsics.h](https://github.com/WebAssembly/binaryen/blob/main/src/ir/intrinsics.h)
for the detailed definitions. A quick summary appears here:

* `call.without.effects`: Similar to a `call_ref` in that it receives
  parameters, and a reference to a function to call, and calls that function
  with those parameters, except that the optimizer can assume the call has no
  side effects, and may be able to optimize it out (if it does not have a
  result that is used, generally).

## Tools

This repository contains code that builds the following tools in `bin/` (see the [building instructions](#building)):

 * **`wasm-opt`**: Loads WebAssembly and runs Binaryen IR passes on it.
 * **`wasm-as`**: Assembles WebAssembly in text format (currently S-Expression
   format) into binary format (going through Binaryen IR).
 * **`wasm-dis`**: Un-assembles WebAssembly in binary format into text format
   (going through Binaryen IR).
 * **`wasm2js`**: A WebAssembly-to-JS compiler. This is used by Emscripten to
   generate JavaScript as an alternative to WebAssembly.
 * **`wasm-reduce`**: A testcase reducer for WebAssembly files. Given a wasm file
   that is interesting for some reason (say, it crashes a specific VM),
   wasm-reduce can find a smaller wasm file that has the same property, which is
   often easier to debug. See the
   [docs](https://github.com/WebAssembly/binaryen/wiki/Fuzzing#reducing)
   for more details.
 * **`wasm-shell`**: A shell that can load and interpret WebAssembly code. It can
   also run the spec test suite.
 * **`wasm-emscripten-finalize`**: Takes a wasm binary produced by llvm+lld and
   performs emscripten-specific passes over it.
 * **`wasm-ctor-eval`**: A tool that can execute functions (or parts of functions)
   at compile time.
 * **`wasm-merge`**: Merges multiple wasm files into a single file, connecting
   corresponding imports to exports as it does so. Like a bundler for JS, but
   for wasm.
 * **`wasm-metadce`**: A tool to remove parts of Wasm files in a flexible way
   that depends on how the module is used.
 * **`binaryen.js`**: A standalone JavaScript library that exposes Binaryen methods for [creating and optimizing Wasm modules](https://github.com/WebAssembly/binaryen/blob/main/test/binaryen.js/hello-world.js). For builds, see [binaryen.js on npm](https://www.npmjs.com/package/binaryen) (or download it directly from [GitHub](https://raw.githubusercontent.com/AssemblyScript/binaryen.js/master/index.js) or [unpkg](https://unpkg.com/binaryen@latest/index.js)). Minimal requirements: Node.js v15.8 or Chrome v75 or Firefox v78.

All of the Binaryen tools are deterministic, that is, given the same inputs you should always get the same outputs. (If you see a case that behaves otherwise, please file an issue.)

Usage instructions for each are below.

## Binaryen Optimizations

Binaryen contains
[a lot of optimization passes](https://github.com/WebAssembly/binaryen/tree/main/src/passes)
to make WebAssembly smaller and faster. You can run the Binaryen optimizer by
using ``wasm-opt``, but also they can be run while using other tools, like
``wasm2js`` and ``wasm-metadce``.

* The default optimization pipeline is set up by functions like
  [`addDefaultFunctionOptimizationPasses`](https://github.com/WebAssembly/binaryen/blob/369b8bdd3d9d49e4d9e0edf62e14881c14d9e352/src/passes/pass.cpp#L396).
* There are various
  [pass options](https://github.com/WebAssembly/binaryen/blob/369b8bdd3d9d49e4d9e0edf62e14881c14d9e352/src/pass.h#L85)
  that you can set, to adjust the optimization and shrink levels, whether to
  ignore unlikely traps, inlining heuristics, fast-math, and so forth. See
  ``wasm-opt --help`` for how to set them and other details.

See each optimization pass for details of what it does, but here is a quick
overview of some of the relevant ones:

* **CoalesceLocals** - Key "register allocation" pass. Does a live range
  analysis and then reuses locals in order to minimize their number, as well as
  to remove copies between them.
* **CodeFolding** - Avoids duplicate code by merging it (e.g. if two `if` arms
  have some shared instructions at their end).
* **CodePushing** - "Pushes" code forward past branch operations, potentially
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
* **MinifyImportsAndExports** - Minifies them to "a", "b", etc.
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
* **RemoveUnsedBrs** - Key "minor control flow optimizations" pass, including
  jump threading and various transforms that can get rid of a `br` or `br_table`
  (like turning a `block` with a `br` in the middle into an `if` when possible).
* **RemoveUnusedModuleElements** - "Global DCE", an LTO pass that removes
  imports, functions, globals, etc., when they are not used.
* **ReorderFunctions** - Put more-called functions first, potentially allowing
  the LEB emitted to call them to be smaller (in a very large program).
* **ReorderLocals** - Put more-used locals first, potentially allowing the LEB
  emitted to use them to be smaller (in a very large function). After the
  sorting, it also removes locals not used at all.
* **SimplifyGlobals** - Optimizes globals in various ways, for example,
  coalescing them, removing mutability from a global never modified, applying a
  constant value from an immutable global, etc.
* **SimplifyLocals** - Key "`local.get/set/tee`" optimization pass, doing things
  like replacing a set and a get with moving the set’s value to the get (and
  creating a tee) where possible. Also creates `block/if/loop` return values
  instead of using a local to pass the value.
* **Vacuum** - Key "remove silly unneeded code" pass, doing things like removing
  an `if` arm that has no contents, a drop of a constant value with no side
  effects, a `block` with a single child, etc.

"LTO" in the above means an optimization is Link Time Optimization-like in that
it works across multiple functions, but in a sense Binaryen is always "LTO" as
it usually is run on the final linked wasm.

Advanced optimization techniques in the Binaryen optimizer include
[SSAification](https://github.com/WebAssembly/binaryen/blob/main/src/passes/SSAify.cpp),
[Flat IR](https://github.com/WebAssembly/binaryen/blob/main/src/ir/flat.h), and
[Stack/Poppy IR](https://github.com/WebAssembly/binaryen/blob/main/src/ir/stack-utils.h).

See the
[Optimizer Cookbook wiki page](https://github.com/WebAssembly/binaryen/wiki/Optimizer-Cookbook)
for more on how to use the optimizer effectively.

Binaryen also contains various passes that do other things than optimizations,
like
[legalization for JavaScript](https://github.com/WebAssembly/binaryen/blob/main/src/passes/LegalizeJSInterface.cpp),
[Asyncify](https://github.com/WebAssembly/binaryen/blob/main/src/passes/Asyncify.cpp),
etc.

## Building

Binaryen uses git submodules (at time of writing just for gtest), so before you build you will have to initialize the submodules:

```bash
git submodule init
git submodule update
```

After that you can build with CMake:

```bash
cmake . && make
```

A C++17 compiler is required. On macOS, you need to install `cmake`, for example, via `brew install cmake`. Note that you can also use `ninja` as your generator: `cmake -G Ninja . && ninja`.

To avoid the gtest dependency, you can pass `-DBUILD_TESTS=OFF` to cmake.

Binaryen.js can be built using Emscripten, which can be installed via [the SDK](http://kripken.github.io/emscripten-site/docs/getting_started/downloads.html).

- Building for Node.js:
  ```bash
  emcmake cmake . && emmake make binaryen_js
  ```
- Building for the browser:
  ```bash
  emcmake cmake -DBUILD_FOR_BROWSER=ON . && emmake make
  ```

### Visual C++

1. Using the Microsoft Visual Studio Installer, install the "Visual C++ tools for CMake" component.

1. Generate the projects:

   ```bash
   mkdir build
   cd build
   "%VISUAL_STUDIO_ROOT%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" ..
   ```

   Substitute VISUAL_STUDIO_ROOT with the path to your Visual Studio
   installation. In case you are using the Visual Studio Build Tools, the path
   will be "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools".

1. From the Developer Command Prompt, build the desired projects:

   ```bash
   msbuild binaryen.vcxproj
   ```

   CMake generates a project named "ALL_BUILD.vcxproj" for conveniently building all the projects.

## Releases

Builds are distributed by the various toolchains that use Binaryen, like
Emscripten, `wasm-pack`, etc. There are also official releases on GitHub:

https://github.com/WebAssembly/binaryen/releases

Currently builds of the following platforms are included:

 * `Linux-x86_64`
 * `Linux-arm64`
 * `MacOS-x86_64`
 * `MacOS-arm64`
 * `Windows-x86_64`
 * `Node.js` (experimental): A port of `wasm-opt` to JavaScript+WebAssembly.
   Run `node wasm-opt.js` as a drop-in replacement for a native build of
   `wasm-opt`, on any platform that Node.js runs on. Requires Node.js 18+ (for
   Wasm EH and Wasm Threads). (Note that this build may also run in Deno, Bun,
   or other JavaScript+WebAssembly environments, but is tested only on Node.js.)

## Running

### wasm-opt

Run

```bash
bin/wasm-opt [.wasm or .wat file] [options] [passes, see --help] [--help]
```

The wasm optimizer receives WebAssembly as input, and can run transformation
passes on it, as well as print it (before and/or after the transformations). For
example, try

```bash
bin/wasm-opt test/lit/passes/name-types.wast -all -S -o -
```

That will output one of the test cases in the test suite. To run a
transformation pass on it, try

```bash
bin/wasm-opt test/lit/passes/name-types.wast --name-types -all -S -o -
```

The `name-types` pass ensures each type has a name and renames exceptionally long type names. You can see
the change the transformation causes by comparing the output of the two commands.

It's easy to add your own transformation passes to the shell, just add `.cpp`
files into `src/passes`, and rebuild the shell. For example code, take a look at
the [`name-types` pass](https://github.com/WebAssembly/binaryen/blob/main/src/passes/NameTypes.cpp).

Some more notes:

 * See `bin/wasm-opt --help` for the full list of options and passes.
 * Passing `--debug` will emit some debugging info. Individual debug channels
   (defined in the source code via `#define DEBUG_TYPE xxx`) can be enabled by
   passing them as list of comma-separated strings. For example: `bin/wasm-opt
   --debug=binary`. These debug channels can also be enabled via the
   `BINARYEN_DEBUG` environment variable.

### wasm2js

Run

```bash
bin/wasm2js [input.wasm file]
```

This will print out JavaScript to the console.

For example, try

```bash
bin/wasm2js test/hello_world.wat
```

That output contains

```js
 function add(x, y) {
  x = x | 0;
  y = y | 0;
  return x + y | 0 | 0;
 }
```

as a translation of

```wat
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

```js
// main.mjs
import { add } from "./hello_world.mjs";
console.log('the sum of 1 and 2 is:', add(1, 2));
```

The run this (note that you need a new enough Node.js with ES6 module
support):

```bash
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

### wasm-ctor-eval

`wasm-ctor-eval` executes functions, or parts of them, at compile time.
After doing so it serializes the runtime state into the wasm, which is like
taking a "snapshot". When the wasm is later loaded and run in a VM, it will
continue execution from that point, without re-doing the work that was already
executed.

For example, consider this small program:

```wat
(module
 ;; A global variable that begins at 0.
 (global $global (mut i32) (i32.const 0))

 (import "import" "import" (func $import))

 (func "main"
  ;; Set the global to 1.
  (global.set $global
   (i32.const 1))

  ;; Call the imported function. This *cannot* be executed at
  ;; compile time.
  (call $import)

  ;; We will never get to this point, since we stop at the
  ;; import.
  (global.set $global
   (i32.const 2))
 )
)
```

We can evaluate part of it at compile time like this:

```bash
wasm-ctor-eval input.wat --ctors=main -S -o -
```

This tells it that there is a single function that we want to execute ("ctor"
is short for "global constructor", a name that comes from code that is executed
before a program's entry point) and then to print it as text to `stdout`. The
result is this:

```bash
trying to eval main
  ...partial evalling successful, but stopping since could not eval: call import: import.import
  ...stopping
(module
 (type $none_=>_none (func))
 (import "import" "import" (func $import))
 (global $global (mut i32) (i32.const 1))
 (export "main" (func $0_0))
 (func $0_0
  (call $import)
  (global.set $global
   (i32.const 2)
  )
 )
)
```

The logging shows us managing to eval part of `main()`, but not all of it, as
expected: We can eval the first `global.get`, but then we stop at the call to
the imported function (because we don't know what that function will be when the
wasm is actually run in a VM later). Note how in the output wasm the global's
value has been updated from 0 to 1, and that the first `global.get` has been
removed: the wasm is now in a state that, when we run it in a VM, will seamlessly
continue to run from the point at which `wasm-ctor-eval` stopped.

In this tiny example we just saved a small amount of work. How much work can be
saved depends on your program. (It can help to do pure computation up front, and
leave calls to imports to as late as possible.)

Note that `wasm-ctor-eval`'s name is related to global constructor functions,
as mentioned earlier, but there is no limitation on what you can execute here.
Any export from the wasm can be executed, if its contents are suitable. For
example, in Emscripten `wasm-ctor-eval` is even run on `main()` when possible.

### wasm-merge

`wasm-merge` combines wasm files together. For example, imagine you have a
project that uses wasm files from multiple toolchains. Then it can be helpful to
merge them all into a single wasm file before shipping, since in a single wasm
file the calls between the modules become just normal calls inside a module,
which allows them to be inlined, dead code eliminated, and so forth, potentially
improving speed and size.

`wasm-merge` operates on normal wasm files. It differs from `wasm-ld` in that
respect, as `wasm-ld` operates on wasm *object* files. `wasm-merge` can help
in multi-toolchain situations where at least one of the toolchains does not use
wasm object files.

For example, imagine we have these two wasm files:

```wat
;; a.wasm
(module
  (import "second" "bar" (func $second.bar))

  (export "main" (func $func))

  (func $func
    (call $second.bar)
  )
)
```

```wat
;; b.wasm
(module
  (import "outside" "log" (func $log (param i32)))

  (export "bar" (func $func))

  (func $func
    (call $log
      (i32.const 42)
    )
  )
)
```

The filenames on your local drive are `a.wasm` and `b.wasm`, but for merging /
bundling purposes let's say that the first is known as `"first"` and the second
as `"second"`. That is, we want the first module's import of `"second.bar"` to
call the function `$func` in the second module. Here is a wasm-merge command for
that:

```bash
wasm-merge a.wasm first b.wasm second -o output.wasm
```

We give it the first wasm file, then its name, and then the second wasm file
and then its name. The merged output is this:

```wat
(module
  (import "outside" "log" (func $log (param i32)))

  (export "main" (func $func))
  (export "bar" (func $func_2))

  (func $func
    (call $func_2)
  )

  (func $func_2
    (call $log
      (i32.const 42)
    )
  )
)
```

`wasm-merge` combined the two files into one, merging their functions, imports,
etc., all while fixing up name conflicts and connecting corresponding imports to
exports. In particular, note how `$func` calls `$func_2`, which is exactly what
we wanted: `$func_2` is the function from the second module (renamed to avoid a
name collision).

Note that the wasm output in this example could benefit from additional
optimization. First, the call to `$func_2` can now be easily inlined, so we can
run `wasm-opt -O3` to do that for us. Also, we may not need all the imports and
exports, for which we can run
[wasm-metadce](https://github.com/WebAssembly/binaryen/wiki/Pruning-unneeded-code-in-wasm-files-with-wasm-metadce#example-pruning-exports).
A good workflow could be to run `wasm-merge`, then `wasm-metadce`, then finish
with `wasm-opt`.

`wasm-merge` is kind of like a bundler for wasm files, in the sense of a "JS
bundler" but for wasm. That is, with the wasm files above, imagine that we had
this JS code to instantiate and connect them at runtime:

```js
// Compile the first module.
var first = await fetch("a.wasm");
first = new WebAssembly.Module(first);

// Compile the first module.
var second = await fetch("b.wasm");
second = new WebAssembly.Module(second);

// Instantiate the second, with a JS import.
second = new WebAssembly.Instance(second, {
  outside: {
    log: (value) => {
      console.log('value:', value);
    }
  }
});

// Instantiate the first, importing from the second.
first = new WebAssembly.Instance(first, {
  second: second.exports
});

// Call the main function.
first.exports.main();
```

What `wasm-merge` does is basically what that JS does: it hooks up imports to
exports, resolving names using the module names you provided. That is, by
running `wasm-merge` we are moving the work of connecting the modules from
runtime to compile time. As a result, after running `wasm-merge` we need a lot
less JS to get the same result:

```js
// Compile the single module.
var merged = await fetch("merged.wasm");
merged = new WebAssembly.Module(merged);

// Instantiate it with a JS import.
merged = new WebAssembly.Instance(merged, {
  outside: {
    log: (value) => {
      console.log('value:', value);
    }
  }
});

// Call the main function.
merged.exports.main();
```

We still need to fetch and compile the merged wasm, and to provide it the JS
import, but the work to connect two wasm modules is not needed any more.

#### Handling exports

By default `wasm-merge` errors if there are overlapping export names. That is,
`wasm-merge` will automatically handle overlapping function names and so forth,
because those are not externally visible (the code still behaves the same), but
if we renamed exports then the outside would need to be modified to expect the
new export names, and so we error instead on such name conflicts.

If you do want exports to be renamed, run `wasm-merge` with
`--rename-export-conflicts`. Later exports will have a suffix appended to them
to ensure they do not overlap with previous exports. The suffixes are
deterministic, so once you see what they are you can call them from the outside.

Another option is to use `--skip-export-conflicts` which will simply skip later
exports that have conflicting names. For example, this can be useful in the
case where the first module is the only one that interacts with the outside and
the later modules just interact with the first module.

#### Features

`wasm-merge` uses the multi-memory and multi-table features. That is, if
multiple input modules each have a memory then the output wasm will have several
memories, and will depend on the multi-memory feature, which means that older
wasm VMs might not be able to run the wasm. (As a workaround for such older VMs
you can run `wasm-opt --multi-memory-lowering` to lower multiple memories into a
single one.)

## Testing

```bash
./check.py
```

(or `python check.py`) will run `wasm-shell`, `wasm-opt`, etc. on the testcases in `test/`, and verify their outputs.

The `check.py` script supports some options:

```bash
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

Note that we are trying to gradually port the legacy wasm-opt tests to use `lit`
and `filecheck` as we modify them. For `passes` tests that output wast, this
can be done automatically with `scripts/port_passes_tests_to_lit.py` and for
non-`passes` tests that output wast, see
https://github.com/WebAssembly/binaryen/pull/4779 for an example of how to do a
simple manual port.

For lit tests the test expectations (the CHECK lines) can often be automatically
updated as changes are made to binaryen. See `scripts/update_lit_checks.py`.

Non-lit tests can also be automatically updated in most cases. See
`scripts/auto_update_tests.py`.

### Setting up dependencies

```bash
./third_party/setup.py [mozjs|v8|wabt|all]
```

(or `python third_party/setup.py`) installs required dependencies like the SpiderMonkey JS shell, the V8 JS shell
and WABT in `third_party/`. Other scripts automatically pick these up when installed.

Run `pip3 install -r requirements-dev.txt` to get the requirements for the `lit`
tests. Note that you need to have the location `pip` installs to in your `$PATH`
(on linux, `~/.local/bin`).

### Fuzzing

```bash
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

## Debug Info Support

### Source Maps

Binaryen can read and write source maps (see the `-ism` and `-osm` flags to
`wasm-opt`). It can also read and read source map annotations in the text
format, that is,

```wat
;;@ src.cpp:100:33
(i32.const 42)
```

That 42 constant is annotated as appearing in a file called `src.cpp` at line
`100` and column `33`. Source maps and text format annotations are
interchangeable, that is, they both lead to the same IR representation, so you
can start with an annotated wat and have Binaryen write that to a binary + a
source map file, or read a binary + source map file and print text which will
contain those annotations.

The IR representation of source map info is simple: in each function we have a
map of expressions to their locations. Optimization passes should update the
map as relevant. Often this "just works" because the optimizer tries to reuse
nodes when possible, so they keep the same debug info.

#### Shorthand notation

The text format annotations support a shorthand in which repeated annotations
are not necessary. For example, children are tagged with the debug info of the
parent, if they have no annotation of their own:

```wat
;;@ src.cpp:100:33
(i32.add
  (i32.const 41)      ;; This receives an annotation of src.cpp:100:33
  ;;@ src.cpp:111:44
  (i32.const 1)
)
```

The first const will have debug info identical to the parent, because it has
none specified, and generally such nesting indicates a "bundle" of instructions
that all implement the same source code.

Note that text printing will not emit such repeated annotations, which can be
confusing. To print out all the annotations, set `BINARYEN_PRINT_FULL=1` in the
environment. That will print this for the above `add`:

```wat
[i32] ;;@ src.cpp:100:33
(i32.add
 [i32] ;;@ src.cpp:100:33
 (i32.const 41)
 [i32] ;;@ src.cpp:111:44
 (i32.const 1)
)
```

(full print mode also adds a `[type]` for each expression, right before the
debug location).

The debug information is also propagated from an expression to its
next sibling:
```wat
;;@ src.cpp:100:33
(local.set $x
 (i32.const 0)
)
(local.set $y ;; This receives an annotation of src.cpp:100:33
 (i32.const 0)
)
```

You can prevent the propagation of debug info by explicitly mentioning
that an expression has not debug info using the annotation `;;@` with
nothing else:
```wat
;;@ src.cpp:100:33
(local.set $x
 ;;@
 (i32.const 0) ;; This does not receive any annotation
)
;;@
(local.set $y ;; This does not receive any annotation
 (i32.const 7)
)
```
This stops the propagatation to children and siblings as well. So,
expression `(i32.const 7)` does not have any debug info either.

There is no shorthand in the binary format. That is, roundtripping (writing and
reading) through a binary + source map should not change which expressions have
debug info on them or the contents of that info.

#### Implementation Details

The [source maps format](https://sourcemaps.info/spec.html) defines a mapping
using *segments*, that is, if a segment starts at binary offset 10 then it
applies to all instructions at that offset and until another segment begins (or
the end of the input is reached). Binaryen's IR represents a mapping from
expressions to locations, as mentioned, so we need to map to and from the
segment-based format when writing and reading source maps.

That is mostly straightforward, but one thing we need to do is to handle the
lack of debug info in between things that have it. If we have `A B C` where `B`
lacks debug info, then just emitting a segment for `A` and `C` would lead `A`'s
segment to also cover `B`, since in source maps segments do not have a size -
rather they end when a new segment begins. To avoid `B` getting smeared in this
manner, we emit a source maps entry to `B` of size 1, which just marks the
binary offset it has, and without the later 3 fields of the source file, line
number, and column. (This appears to be the intent of the source maps spec, and
works in browsers and tools.)

### DWARF

Binaryen also has optional support for DWARF. This primarily just tracks the
locations of expressions and rewrites the DWARF's locations accordingly; it does
not handle things like re-indexing of locals, and so passes that might break
DWARF are disabled by default. As a result, this mode is not suitable for a
fully optimized release build, but it can be useful for local debugging.

## FAQ

* Why the weird name for the project?

Binaryen's name was inspired by *Emscripten*'s: Emscripten's name
[suggests](https://en.wikipedia.org/wiki/Lisa_the_Iconoclast#Embiggen_and_cromulent)
it converts something into a **script** - specifically *JavaScript* - and
Binaryen's suggests it converts something into a **binary** - specifically
*WebAssembly*. Binaryen began as Emscripten's WebAssembly generation and
optimization tool, so the name fit as it moved Emscripten from something that
emitted the text-based format JavaScript (as it did from its early days) to the
binary format WebAssembly (which it has done since WebAssembly launched).

"Binaryen" is pronounced [in the same manner](https://www.makinggameofthrones.com/production-diary/2011/2/11/official-pronunciation-guide-for-game-of-thrones.html#:~:text=Targaryen%20%2D%20AIR%2Deez-,Tar%2DGAIR%2Dee%2Din,-Alliser%20Thorne%20%2D%20AL)
as
"[Targaryen](https://en.wikipedia.org/wiki/List_of_A_Song_of_Ice_and_Fire_characters#House_Targaryen)".

* Does it compile under Windows and/or Visual Studio?

Yes, it does. Here's a step-by-step [tutorial][win32] on how to compile it
under **Windows 10 x64** with with **CMake** and **Visual Studio 2015**.
However, Visual Studio 2017 may now be required. Help would be appreciated on
Windows and OS X as most of the core devs are on Linux.

[compiling to WebAssembly]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen
[win32]: https://github.com/brakmic/bazaar/blob/master/webassembly/COMPILING_WIN32.md
[C API]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#c-api
[control flow graph]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#cfg-api
[JS_API]: https://github.com/WebAssembly/binaryen/wiki/binaryen.js-API
[compile_to_wasm]: https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#what-do-i-need-to-have-in-order-to-use-binaryen-to-compile-to-webassembly
[backend]: https://kripken.github.io/talks/binaryen.html#/9
[minification]: https://kripken.github.io/talks/binaryen.html#/2
[unreachable]: https://github.com/WebAssembly/binaryen/issues/903
[binaryen_ir]: https://github.com/WebAssembly/binaryen/issues/663
