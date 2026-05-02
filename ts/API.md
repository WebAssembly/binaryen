# API Documentation
Please note that the Binaryen API is evolving fast.
Definitions and documentation provided by the C++ codebase don’t always immediately find their way here into TypeScript.
If you rely on Binaryen.TS and spot an issue, please consider sending a PR our way. Thank you!

### Contents
- [Top-Level Symbols](#top-level-symbols)
- [Module Manipulation](#module-manipulation)
- [Expression Construction](#expression-construction)
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
	- `Module#x`:               [create expressions](#expression-construction)
	- `Module#tags`:            **Tag** manipulation
	- `Module#globals`:         **Global** manipulation
	- `Module#memories`:        **Memory** manipulation
	- `Module#tables`:          **Table** manipulation
	- `Module#functions`:       **Function** manipulation
	- `Module#dataSegments`:    **Data Segment** manipulation
	- `Module#elementSegments`: **Element Segment** manipulation
	- `Module#imports`:         **Import** manipulation
	- `Module#exports`:         **Export** manipulation



## Expression Construction
Each of these methods returns an `ExpressionRef`.

### Parametric Instructions
- `Module#x.nop()`
- `Module#x.unreachable()`
- `Module#x.drop(value: ExpressionRef)`
- `Module#x.select(ifTrue: ExpressionRef, ifFalse: ExpressionRef)`

### Control Instructions
- `Module#x.block(name: string | null, children: readonly ExpressionRef[], resultType?: Type)`
- `Module#x.loop(name: string, body: ExpressionRef)`
- TODO: `Module#x.if()`
- `Module#x.br(label: string, condition?: ExpressionRef, value?: ExpressionRef)`
- `Module#x.br_if(label: string, condition: ExpressionRef, value?: ExpressionRef)`

### Variable Instructions
- `Module#x.local.get(index: number, typ: Type)`
- `Module#x.local.set(index: number, value: ExpressionRef)`
- `Module#x.local.tee(index: number, value: ExpressionRef, typ: Type)`
- TODO: `Module#x.global.get()`
- TODO: `Module#x.global.set()`

### Table Instructions
### Memory Instructions
### Reference Instructions
### Aggregate Instructions
### Numeric Instructions
### Vector Instructions
### Atomic Instructions
### String Instructions



## ⚠️ Deprecations, Renames, and Moves
### Enums and Types
Enum names have been singularized.
- `ExpressionIds` &rarr; `ExpressionId`
- `SideEffects`   &rarr; `SideEffect`
- `ExternalKinds` &rarr; `ExternalKind`
- `Features`      &rarr; `Feature`
- `Operations`    &rarr; `Operation`

`*Info` types have been merged with their respective classes in the `Module` namespace.
- `TagInfo`            &rarr; `Module.Tag`
- `GlobalInfo`         &rarr; `Module.Global`
- `MemoryInfo`         &rarr; `Module.Memory`
- `TableInfo`          &rarr; `Module.Table`
- `FunctionInfo`       &rarr; `Module.Function`
- `ElementSegmentInfo` &rarr; `Module.ElementSegment`
- `ExportInfo`         &rarr; `Module.Export`

`ExpressionInfo` and related types are now classes without the `Info` suffix:
- `ExpressionInfo` &rarr; `Expression`
- `BlockInfo`      &rarr; `Block`
- `LoopInfo`       &rarr; `Loop`
- `IfInfo`         &rarr; `If`
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
