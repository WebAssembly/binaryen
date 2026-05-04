# API Overview
Please note that the Binaryen API is evolving fast.
Definitions and documentation provided by the C++ codebase don’t always immediately find their way here into TypeScript.
If you rely on Binaryen.TS and spot an issue, please consider sending a PR our way. Thank you!

### Contents
- [Top-Level Symbols](#top-level-symbols)
- [Module Manipulation](#module-manipulation)
- [Expression Building](#expression-building)
- [Expression Manipulation](#expression-manipulation)
- [Deprecations](#️-deprecations-renames-and-moves)



### Icon Legend
- ⛔️ Not yet supported, but listed here for completion.
- ❌ removed
- 🌱 new/experimental/proposed; not listed in WASM spec



## Top-Level Symbols
Import `binaryen` as a namespace:
```ts
import * as binaryen from "binaryen.ts";
```
or import ES module components individually:
```ts
import {type Type, type ExpressionRef, i32} from "binaryen.ts";
```


### TypeScript Types
- `Type`: a WASM type; the type of the constants named `i32`, `i64`, etc.
- `HeapType`: a WASM heap type created in a `TypeBuilder`
- `PackedType`: an allowed type of a struct or array field; one of three constants: `notPacked`, `i8`, `i16`
- `ExpressionRef`: an expression, e.g. the type of `i32.const()`
- module component ref types:
	- `TagRef`
	- `GlobalRef`
	- ~~`MemoryRef`~~ ⛔️
	- `TableRef`
	- `FunctionRef`
	- `DataSegmentRef`
	- `ElementSegmentRef`
	- ~~`ImportRef`~~ ⛔️
	- `ExportRef`


### Constants
- `unreachable`: type of an unreachable instruction (stack effect *[t\*] -> [t\*]*)
- `none`: void type (stack effect *[t\*] -> []*); not to be confused with WASM’s heap type called *none*
- `auto`: special type used in `Module#x.block()` exclusively; automatically detects a block’s result type based on its contents
>
- `i32`: 32-bit integer
- `i64`: 64-bit integer
- `f32`: 32-bit float
- `f64`: 64-bit float
- `v128`: 128-bit vector (SIMD)
>
- `anyref`:         *(ref null any)*
- `eqref`:          *(ref null eq)*
- `i31ref`:         *(ref null i31)*
- `structref`:      *(ref null struct)*
- `arrayref`:       *(ref null array)*
- `funcref`:        *(ref null func)*
- ~~`exnref`~~:     ⛔️ reserved for *(ref null exn)*
- `externref`:      *(ref null extern)*
- `nullref`:        *(ref null none)*
- `nullfuncref`:    *(ref null nofunc)*
- ~~`nullexnref`~~: ⛔️ reserved for *(ref null noexn)*
- `nullexternref`:  *(ref null noextern)*
- `stringref`:      🌱 planned for *(ref null string)*
>
- `notPacked` (`PackedType`): unaltered type in the struct/array field
- `i8` (`PackedType`): 8-bit integer
- `i16` (`PackedType`): 16-bit integer


### Enums
- `ExpressionId`: an enumeration of values returned by `getExpressionId()`
	- a slight misnomer, as these are not unique IDs per expression, but different IDs for the “kinds” of expression
- `SideEffect`: an enumeration of values returend by `getSideEffects()`
- `ExternalKind`: an enumeration of kinds of exports; serves as type of the `Module.Export#kind` field
- `MemoryOrder`: an enumeration of values used in atomic expression methods


### Global Bindings
Functions (see generated docs for descriptions):
- `emitText(expr: ExpressionRef): string`
- `readBinary(data: Uint8Array): Module`
- `readBinaryWithFeatures(data: Uint8Array, features: Feature): Module`
- `parseText(text: string): Module`
- `exit(status: number): void`
- `createType(types: readonly Type[]): Type`
- `expandType(typ: Type): Type[]`
- `getTypeFromHeapType(heapType: HeapType, nullable: boolean): Type`
- `getHeapType(typ: Type): HeapType`
- `getExpressionId(expr: ExpressionRef): ExpressionId`
- `getExpressionType(expr: ExpressionRef): Type`
- `getExpressionInfo(expr: ExpressionRef): Expression`
- `getSideEffects(expr: ExpressionRef, mod: Module): SideEffect`
- `copyExpression(expr: ExpressionRef, mod: Module): ExpressionRef`

Objects:
- `settings`: global settings manager; see `SettingsService` docs



## Module Manipulation
- Properties of `Module` as a namespace:
	- `new Module.Tag(ref: TagRef)`:                              an object containing information about a **Tag**
	- `new Module.Global(ref: GlobalRef)`:                        an object containing information about a **Global**
	- `new Module.Memory(mod: Module, name: string)`:             an object containing information about a **Memory**
	- `new Module.Table(ref: TableRef)`:                          an object containing information about a **Table**
	- `new Module.Function(ref: FunctionRef)`:                    an object containing information about a **Function**
	- `new Module.DataSegment(mod: Module, ref: DataSegmentRef)`: an object containing information about a **Data Segment**
	- `new Module.ElementSegment(ref: ElementSegmentRef)`:        an object containing information about an **Element Segment**
	- `new Module.Import()`:                                      an object containing information about an **Import** (🌱 empty for now)
	- `new Module.Export(ref: ExportRef)`:                        an object containing information about an **Export**

- Properties of `Module` instances (see full list of methods in generated docs):
	- `Module#x`:               [build expressions](#expression-building) (“x” for “expression”)
	- `Module#tags`:            **Tag** manipulation
	- `Module#globals`:         **Global** manipulation
	- `Module#memories`:        **Memory** manipulation
	- `Module#tables`:          **Table** manipulation
	- `Module#functions`:       **Function** manipulation
	- `Module#dataSegments`:    **Data Segment** manipulation
	- `Module#elementSegments`: **Element Segment** manipulation
	- `Module#imports`:         **Import** manipulation
	- `Module#exports`:         **Export** manipulation



## Expression Building
Each of these functions is bound to `Module#x` (of type `ExpressionBuilder`) and returns an `ExpressionRef`.
See the generated **ExpressionBuilder** docs for all available functions and details.

Note: For brevity, glob-like syntax `_{s,u}` is used to mean “`_s` and `_u`”.

- Parametric Instructions
	- `.nop()`
	- `.unreachable()`
	- `.drop()`
	- `.select()`
- conditionals, blocks, loops, and breaking (“branching”)
	- `.if()`
	- `.block()`
	- `.loop()`
	- `.br()`, `.br_if()`, `.br_table()`
	- `.br_on_null()`, `.br_on_non_null()`, `.br_on_cast()`, `.br_on_cast_fail()`
- function calls, returns, throws, and catching
	- `.call()`, `.call_ref()`, `.call_indirect()`
	- `.return()`, `.return_call()`, `.return_call_ref()`, `.return_call_indirect()`
	- `.throw()`, `.throw_ref()`, `.try_table()`
	- ~~`.catch()`, `.catch_ref()`, `.catch_all()`, `.catch_all_ref()`~~; ⛔️ not yet supported
- local and global variables
	- `.local.get()`
	- `.local.set()`
	- `.local.tee()`
	- `.global.get()`
	- `.global.set()`
- tables and memories
	- `.table.get()`, `.table.set()`, `.table.size()`, `.table.grow()`
	- `.memory.size()`, `.memory.grow()`, `.memory.fill()`, `.memory.copy()`, `.memory.init()`,
	- `.elem.drop()`, `.data.drop()`
- references
	- `.ref.func()`, `.ref.null()`, `.ref.is_null()`, `.ref.as_non_null()`, `.ref.eq()`, `.ref.test()`, `.ref.cast()`
	- `.ref.i31()`, `i31.get_{s,u}()`
	- ~~`.extern.convert_any()`, `.any.convert_extern()`~~; ⛔️ not yet supported
- structs and arrays
	- `.struct.new()`, `.struct.new_default()`
	- `.struct.get()`, `.struct.get_{s,u}()`
	- `.struct.set()`
	- `.array.new()`, `.array.new_default()`, `.array.new_fixed()`, `.array.new_data()`, `.array.new_elem()`
	- `.array.get()`, `.array.get_{s,u}()`
	- `.array.set()`
	- `.array.len()`
	- `.array.fill()`
	- `.array.copy()`
	- `.array.init_data()`, `.array.init_elem()`
- integers
	- `.{i32,i64}.const`
	- `.{i31,i32}.clz`, `.{i32,i64}.ctz`, `.{i32,i64}.popcnt`
	- `.{i32,i64}.extend8_s`, `.{i32,i64}.extend16_s`, `.i64.extend32_s`
	- `.{i31,i32}.add`, `.{i32,i64}.sub`, `.{i32,i64}.mul`, `.{i31,i32}.div_{s,u}`, `.{i32,i64}.rem_{s,u}`
	- `.{i31,i32}.and`, `.{i32,i64}.or`, `.{i32,i64}.xor`, `.{i31,i32}.shl`, `.{i31,i32}.shr{s,u}`, `.{i32,i64}.rotl`, `.{i32,i64}.rotr`
	- `.{i32,i64}.eqz`
	- `.{i32,i64}.eq`, `.{i32,i64}.ne`
	- `.{i32,i64}.lt_{s,u}`, `.{i32,i64}.gt_{s,u}`, `.{i32,i64}.le_{s,u}`, `.{i32,i64}.ge_{s,u}`
	- `.i32.wrap_i64()`, `.i64.extend_i32_{s,u}()`
	- `.i32.trunc_f32_{s,u}()`, `.i32.trunc_f64_{s,u}()`
	- `.i64.trunc_f32_{s,u}()`, `.i64.trunc_f64_{s,u}()`
	- `.i32.trunc_sat_f32_{s,u}()`, `.i32.trunc_sat_f64_{s,u}()`
	- `.i64.trunc_sat_f32_{s,u}()`, `.i64.trunc_sat_f64_{s,u}()`
	- `.i32.reinterpret_f32()`, `.i64.reinterpret_f64()`
- floats
	- `.{f32,f64}.const`
	- `.{f32,f64}.abs`, `.{f32,f64}.neg`, `.{f32,f64}.sqrt`, `.{f32,f64}.ceil`, `.{f32,f64}.floor`, `.{f32,f64}.trunc`, `.{f32,f64}.nearest`
	- `.{f32,f64}.add`, `.{f32,f64}.sub`, `.{f32,f64}.mul`, `.{f32,f64}.div`, `.{f32,f64}.min`, `.{f32,f64}.max`, `.{f32,f64}.copysign`
	- `.{f32,f64}.eq`, `.{f32,f64}.lt`, `.{f32,f64}.gt`, `.{f32,f64}.le`, `.{f32,f64}.ge`
	- `.{f32,f64}.convert_i32_s`, `.{f32,f64}.convert_i32_u`, `.{f32,f64}.convert_i64_s`, `.{f32,f64}.convert_i64_u`
	- `.f32.demote_f64`, `.f64.promote_f32`
- tuples 🌱 (Binaryen-specific)
	- `.tuple.make()`
	- `.tuple.extract()`



## Expression Manipulation
Expression info classes all live under the global `X` namespace (“X” for “Expression”).
They can be used to inspect and manipulate expressions.
See generated docs for fields, methods, and descriptions of each.

- `X.Expression` (root class)
- parametric instructions
	- `X.Drop`
	- `X.Select`
- control instructions
	- `X.Block`
	- `X.Loop`
	- `X.Break`
- variable instructions
	- `X.LocalGet`
	- `X.LocalSet`
- numeric instructions
	- `X.Const`



## ⚠️ Deprecations, Renames, and Moves
### Enums and Types
Enum names have been singularized.
- `ExpressionIds` &rarr; `ExpressionId`
- `SideEffects`   &rarr; `SideEffect`
- `ExternalKinds` &rarr; `ExternalKind`
- `Features`      &rarr; `Feature`

`*Info` types have been merged with their respective classes in the `Module` namespace.
- `TagInfo`            &rarr; `Module.Tag`
- `GlobalInfo`         &rarr; `Module.Global`
- `MemoryInfo`         &rarr; `Module.Memory`
- `TableInfo`          &rarr; `Module.Table`
- `FunctionInfo`       &rarr; `Module.Function`
- `ElementSegmentInfo` &rarr; `Module.ElementSegment`
- `ExportInfo`         &rarr; `Module.Export`

`ExpressionInfo` and related types are now classes in the `X` namespace:
- `ExpressionInfo` &rarr; `X.Expression`
- `BlockInfo`      &rarr; `X.Block`
- `LoopInfo`       &rarr; `X.Loop`
- `IfInfo`         &rarr; `X.If`
- etc.

~~`MemorySegmentInfo`~~ ❌ has been removed.


### Modules
Module components previously at the top level have been moved under the `Module` namespace.
- `Function` &rarr; `Module.Function`
- `Table`    &rarr; `Module.Table`

Most `get*Info()` functions have been replaced by their corresponding class constructors.
- `getTagInfo(tag)`                &rarr; `new Module.Tag(tag)`;
- `getGlobalInfo(global)`          &rarr; `new Module.Global(global)`
- `getTableInfo(table)`            &rarr; `new Module.Table(table)`
- `getFunctionInfo(func)`          &rarr; `new Module.Function(func)`
- `getElementSegmentInfo(segment)` &rarr; `new Module.ElementSegment(segment)`
- `getExportInfo(xport)`           &rarr; `new Module.Export(xport)`
>
- `Module#getMemoryInfo(name)` has not changed.
- `Module#getDataSegmentInfo(name)` has not changed.
- global `getExpressionInfo(expr)` has not changed.
- global ~~`getMemorySegmentInfo()`~~ ❌ has been removed.

Most of the `Module` class’s instance methods relating to module component manipulation have been moved.
- `Module#addTag()`      &rarr; `Module#tags.add()`
- `Module#setGlobal()`   &rarr; `Module#globals.set()`
- `Module#removeTable()` &rarr; `Module#tables.remove()`
- etc. Generally, the pattern is as follows (where `Thing` and `things` are component types (globals, tables, functions, etc.)):
	- `Module#addThing()`        &rarr; `Module#things.add()`
	- `Module#getThing()`        &rarr; `Module#things.get()`
	- `Module#getThingByIndex()` &rarr; `Module#things.getByIndex()`
	- `Module#getNumThings()`    &rarr; `Module#things.count()`
	- `Module#removeThing()`     &rarr; `Module#things.remove()`
	- `Module#addThingImport()`  &rarr; `Module#imports.addThing()`
	- `Module#addThingExport()`  &rarr; `Module#exports.addThing()`

Some of `Module`’s instance methods have been converted into getters/setters:
- `Module#getStart()`           &rarr; `Module#start`
- `Module#setStart()`           &rarr; `Module#start`
- `Module#getFeatures()`        &rarr; `Module#features`
- `Module#setFeatures()`        &rarr; `Module#features`

`Module#copyExpression(expr)` has been moved to the global function `copyExpression(expr, mod)` where it lives alongside `getExpressionInfo` et al.


### Expression Builders
Note: To improve readability, assume all methods written in this section are bound to an Expression Builder (an object returned by `Module#x`).

- `.break()`              &rarr; `.br()`
- `.switch()`             &rarr; `.br_table()`
- `.callIndirect()`       &rarr; `.call_indirect()`
- `.returnCall()`         &rarr; `.return_call()`
- `.returnCallIndirect()` &rarr; `.return_call_indirect()`
- `.rethrow()`            &rarr; `.throw_ref()`
- `.try()`                &rarr; `.try_table()`

`.{struct,array}.get()` no longer take the `isSigned` argument. For packed signed/unsigned types, use `.{struct,array}.get_{s,u}()` respectively.

- `.i32.wrap()`            &rarr; `.i32.wrap_i64()`
- `.i32.trunc_s.f32()`     &rarr; `.i32.trunc_f32_s()`
- `.i32.trunc_s.f64()`     &rarr; `.i32.trunc_f64_s()`
- `.i32.trunc_u.f32()`     &rarr; `.i32.trunc_f32_u()`
- `.i32.trunc_u.f64()`     &rarr; `.i32.trunc_f64_u()`
- `.i32.trunc_s_sat.f32()` &rarr; `.i32.trunc_sat_f32_s()`
- `.i32.trunc_s_sat.f64()` &rarr; `.i32.trunc_sat_f64_s()`
- `.i32.trunc_u_sat.f32()` &rarr; `.i32.trunc_sat_f32_u()`
- `.i32.trunc_u_sat.f64()` &rarr; `.i32.trunc_sat_f64_u()`
- `.reinterpret()`         &rarr; `.reinterpret_f32()`

- `.i64.extend_s()`        &rarr; `.i64.extend_i32_s()`
- `.i64.extend_u()`        &rarr; `.i64.extend_i32_u()`
- `.i64.trunc_s.f32()`     &rarr; `.i64.trunc_f32_s()`
- `.i64.trunc_s.f64()`     &rarr; `.i64.trunc_f64_s()`
- `.i64.trunc_u.f32()`     &rarr; `.i64.trunc_f32_u()`
- `.i64.trunc_u.f64()`     &rarr; `.i64.trunc_f64_u()`
- `.i64.trunc_s_sat.f32()` &rarr; `.i64.trunc_sat_f32_s()`
- `.i64.trunc_s_sat.f64()` &rarr; `.i64.trunc_sat_f64_s()`
- `.i64.trunc_u_sat.f32()` &rarr; `.i64.trunc_sat_f32_u()`
- `.i64.trunc_u_sat.f64()` &rarr; `.i64.trunc_sat_f64_u()`
- `.reinterpret()`         &rarr; `.reinterpret_f64()`

- `.f32.convert_s.i32()` &rarr; `.f32.convert_i32_s()`
- `.f32.convert_s.i64()` &rarr; `.f32.convert_i64_s()`
- `.f32.convert_u.i32()` &rarr; `.f32.convert_i32_u()`
- `.f32.convert_u.i64()` &rarr; `.f32.convert_i64_u()`
- `.f32.reinterpret()`   &rarr; `.f32.reinterpret_i32()`
- `.f32.demote()`        &rarr; `.f32.demote_f64()`

- `.f64.convert_s.i32()` &rarr; `.f64.convert_i32_s()`
- `.f64.convert_s.i64()` &rarr; `.f64.convert_i64_s()`
- `.f64.convert_u.i32()` &rarr; `.f64.convert_i32_u()`
- `.f64.convert_u.i64()` &rarr; `.f64.convert_i64_u()`
- `.f64.reinterpret()`   &rarr; `.f64.reinterpret_i64()`
- `.f64.promote()`       &rarr; `.f64.promote_f32()`


### Settings
All optimization pass settings have been moved to the global `settings` object.

- The functions starting with `get`/`set` with zero/one argument have been converted to getters/setters respectively.
	- `{get,set}OptimizeLevel()`                   &rarr; `settings.optimizeLevel`
	- `{get,set}ShrinkLevel()`                     &rarr; `settings.shrinkLevel`
	- `{get,set}DebugInfo()`                       &rarr; `settings.debugInfo`
	- `{get,set}TrapsNeverHappen()`                &rarr; `settings.trapsNeverHappen`
	- `{get,set}ClosedWorld()`                     &rarr; `settings.closedWorld`
	- `{get,set}LowMemoryUnused()`                 &rarr; `settings.lowMemoryUnused`
	- `{get,set}ZeroFilledMemory()`                &rarr; `settings.zeroFilledMemory`
	- `{get,set}FastMath()`                        &rarr; `settings.fastMath`
	- `{get,set}GenerateStackIR()`                 &rarr; `settings.generateStackIR`
	- `{get,set}OptimizeStackIR()`                 &rarr; `settings.optimizeStackIR`
	- `{get,set}AlwaysInlineMaxSize()`             &rarr; `settings.alwaysInlineMaxSize`
	- `{get,set}FlexibleInlineMaxSize()`           &rarr; `settings.flexibleInlineMaxSize`
	- `{get,set}OneCallerInlineMaxSize()`          &rarr; `settings.oneCallerInlineMaxSize`
	- `{get,set}AllowInliningFunctionsWithLoops()` &rarr; `settings.allowInliningFunctionsWithLoops`
- Other functions have only been moved.
	- `getPassArgument()`    &rarr; `settings.getPassArgument()`
	- `setPassArgument()`    &rarr; `settings.setPassArgument()`
	- `clearPassArguments()` &rarr; `settings.clearPassArguments()`
	- `hasPassToSkip()`      &rarr; `settings.hasPassToSkip()`
	- `addPassToSkip()`      &rarr; `settings.addPassToSkip()`
	- `clearPassesToSkip()`  &rarr; `settings.clearPassesToSkip()`
