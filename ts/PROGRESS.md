# Coverage Progress

Tracks the migration of JavaScript development to TypeScript.
This document is temporary and will be removed once the migration is complete.

Add to this checklist as the JS is updated; check when migrated to TS.

**Status key:**
- `[ ]` — not started
- `[~]` — in progress (`@contributor`)
- `[x]` — done



## Source Migration — `/src/js/binaryen.js-post.js`
### Constants and Enums
| Name                     | JS Loc   | TS Loc              | Code | API Overview | Tests |
| ------------------------ | -------- | ------------------- | ---- | ------------ | ----- |
| Types                    | line  32 | constants.ts        | [x] | [x] | [x] |
| `ExpressionIds`          | line  63 | constants.ts        | [x] | [x] | [x] |
| `ExternalKinds`          | line 152 | constants.ts        | [x] | [x] | [x] |
| `MemoryOrder`            | line 163 | constants.ts        | [x] | [x] | [x] |
| `Features`               | line 173 | Module.ts           | [x] | [x] | [x] |
| `Operations`             | line 204 | constants.ts        | [x] | [x] | [x] |
| `SideEffects`            | line 626 | constants.ts        | [x] | [x] | [x] |
| `ExpressionRunner.Flags` | line 649 | ExpressionRunner.ts | [x] | [x] | [x] |


### class `Module` — Expression Building
| Name                    | JS Loc    | TS Loc                | Code | API Overview | Tests |
| ----------------------- | --------- | --------------------- | ---- | ------------ | ----- |
| `block`                 | line  679 | generic.ts           | [x] | [x] | [ ] |
| `if`                    |           | generic.ts           | [x] | [x] | [ ] |
| `loop`                  |           | generic.ts           | [x] | [x] | [ ] |
| `br_if`                 |           | generic.ts           | [x] | [x] | [ ] |
| `switch`                |           | generic.ts           | [x] | [x] | [ ] |
| `call`                  |           | generic.ts           | [x] | [x] | [ ] |
| `callIndirect`          |           | generic.ts           | [x] | [x] | [ ] |
| `returnCall`            |           | generic.ts           | [x] | [x] | [ ] |
| `returnCallIndirect`    |           | generic.ts           | [x] | [x] | [ ] |
| `local`                 | line  725 | variable.ts          | [x] | [x] | [ ] |
| `global`                |           | variable.ts          | [x] | [x] | [ ] |
| `table`                 |           | table.ts             | [x] | [x] | [ ] |
| `memory`                |           | memory.ts            | [x] | [x] | [ ] |
| `memory.atomic`         | line  781 | memory.ts            | [x] | [x] | [ ] |
| `data`                  |           | memory.ts            | [x] | [x] | [ ] |
| `i32`                   | line  800 | i32.ts               | [x] | [x] | [ ] |
| `i32.atomic`            | line  963 | i32.ts               | [x] | [x] | [ ] |
| `i32.pop`               |           | Module.ts            | [x] | [x] | [ ] |
| `i64`                   | line 1078 | i64.ts               | [x] | [x] | [ ] |
| `i64.const` with bigint |           | i64.ts               | [x] | [x] | [ ] |
| `i64.atomic`            | line 1275 | i64.ts               | [x] | [x] | [ ] |
| `i64.pop`               |           | Module.ts            | [x] | [x] | [ ] |
| `f32`                   | line 1426 | f32.ts               | [x] | [x] | [ ] |
| `f32.const_bits`        |           | f32.ts               | [x] | [x] | [ ] |
| `f64`                   | line 1534 | f64.ts               | [x] | [x] | [ ] |
| `f64.const_bits`        |           | f64.ts               | [x] | [x] | [ ] |
| `v128`                  | line 1647 | v128.ts              | [x] | [x] | [ ] |
| `v128.pop`              |           | Module.ts            | [x] | [x] | [ ] |
| `i8x16`                 | line 1755 | i8x16.ts             | [x] | [x] | [ ] |
| `i16x8`                 | line 1869 | i16x8.ts             | [x] | [x] | [ ] |
| `i32x4`                 | line 2010 | i32x4.ts             | [x] | [x] | [ ] |
| `i64x2`                 | line 2139 | i64x2.ts             | [x] | [x] | [ ] |
| `f32x4`                 | line 2223 | f32x4.ts             | [x] | [x] | [ ] |
| `f64x2`                 | line 2307 | f64x2.ts             | [x] | [x] | [ ] |
| `funcref.pop`           | line 2391 | Module.ts            | [x] | [x] | [ ] |
| `externref.pop`         |           | Module.ts            | [x] | [x] | [ ] |
| `anyref.pop`            |           | Module.ts            | [x] | [x] | [ ] |
| `eqref.pop`             |           | Module.ts            | [x] | [x] | [ ] |
| `i31ref.pop`            |           | Module.ts            | [x] | [x] | [ ] |
| `structref.pop`         |           | Module.ts            | [x] | [x] | [ ] |
| `arrayref.pop`          |           | Module.ts            | [x] | [x] | [ ] |
| `stringref.pop`         |           | Module.ts            | [x] | [x] | [ ] |
| `ref`                   | line 2439 | refrence.ts          | [x] | [x] | [ ] |
| `select`                |           | generic.ts           | [x] | [x] | [ ] |
| `drop`                  |           | generic.ts           | [x] | [x] | [ ] |
| `return`                |           | generic.ts           | [x] | [x] | [ ] |
| `nop`                   |           | generic.ts           | [x] | [x] | [ ] |
| `unreachable`           |           | generic.ts           | [x] | [x] | [ ] |
| `atomic.fence`          |           | expressionBuilder.ts | [x] | [x] | [ ] |
| `try`                   |           | generic.ts           | [x] | [x] | [ ] |
| `throw`                 |           | generic.ts           | [x] | [x] | [ ] |
| `rethrow`               |           | generic.ts           | [x] | [x] | [ ] |
| `tuple`                 | line 2499 | aggregate.ts         | [x] | [x] | [ ] |
| `i31`                   |           | reference.ts         | [x] | [x] | [ ] |
| `call_ref`              |           | generic.ts           | [x] | [x] | [ ] |
| `return_call_ref`       |           | generic.ts           | [x] | [x] | [ ] |
| `any.convert_extern`    | line 2529 | expressionBuilder.ts | [ ] | [~] | [ ] |
| `extern.convert_any`    |           | expressionBuilder.ts | [ ] | [~] | [ ] |
| `br_on_null`            | line 2541 | generic.ts           | [x] | [x] | [ ] |
| `br_on_cast`            |           | generic.ts           | [x] | [x] | [ ] |
| `br_on_cast_fail`       |           | generic.ts           | [x] | [x] | [ ] |
| `struct`                | line 2557 | aggregate.ts         | [x] | [x] | [ ] |
| `array`                 |           | aggregate.ts         | [x] | [x] | [ ] |


### class `Module` — Module Operations
| Name                       | JS Loc    | TS Loc            | Code | API Overview | Tests |
| -------------------------- | --------- | ----------------- | ---- | ------------ | ----- |
| `addFunction`              | line 2616 | Function.ts       | [x] | [x] | [ ] |
| `getFunction`              |           | Function.ts       | [x] | [x] | [ ] |
| `removeFunction`           |           | Function.ts       | [x] | [x] | [ ] |
| `addGlobal`                |           | Global.ts         | [x] | [x] | [ ] |
| `getGlobal`                |           | Global.ts         | [x] | [x] | [ ] |
| `addTable`                 |           | Table.ts          | [x] | [x] | [ ] |
| `getTable`                 |           | Table.ts          | [x] | [x] | [ ] |
| `addActiveElementSegment`  |           | ElementSegment.ts | [x] | [x] | [ ] |
| `addPassiveElementSegment` |           | ElementSegment.ts | [x] | [x] | [ ] |
| `getElementSegment`        |           | ElementSegment.ts | [x] | [x] | [ ] |
| `getTableSegments`         |           | Table.ts          | [x] | [x] | [ ] |
| `removeGlobal`             |           | Global.ts         | [x] | [x] | [ ] |
| `removeTable`              |           | Table.ts          | [x] | [x] | [ ] |
| `removeElementSegment`     |           | ElementSegment.ts | [x] | [x] | [ ] |
| `addTag`                   |           | Tag.ts            | [x] | [x] | [ ] |
| `getTag`                   |           | Tag.ts            | [x] | [x] | [ ] |
| `removeTag`                |           | Tag.ts            | [x] | [x] | [ ] |
| `addFunctionImport`        |           | Import.ts         | [x] | [x] | [ ] |
| `addTableImport`           |           | Import.ts         | [x] | [x] | [ ] |
| `addMemoryImport`          |           | Import.ts         | [x] | [x] | [ ] |
| `addGlobalImport`          |           | Import.ts         | [x] | [x] | [ ] |
| `addTagImport`             |           | Import.ts         | [x] | [x] | [ ] |
| `addFunctionExport`        |           | Export.ts         | [x] | [x] | [ ] |
| `addTableExport`           |           | Export.ts         | [x] | [x] | [ ] |
| `addMemoryExport`          |           | Export.ts         | [x] | [x] | [ ] |
| `addGlobalExport`          |           | Export.ts         | [x] | [x] | [ ] |
| `addTagExport`             |           | Export.ts         | [x] | [x] | [ ] |
| `removeExport`             |           | Export.ts         | [x] | [x] | [ ] |
| `setMemory`                |           | Memory.ts         | [x] | [x] | [ ] |
| `hasMemory`                |           | Memory.ts         | [x] | [x] | [ ] |
| `getMemoryInfo`            |           | Module.ts         | [x] | [x] | [ ] |
| `getNumDataSegments`       |           | DataSegment.ts    | [x] | [x] | [ ] |
| `getDataSegmentByIndex`    |           | DataSegment.ts    | [x] | [x] | [ ] |
| `getDataSegmentInfo`       |           | DataSegment.ts    | [x] | [x] | [ ] |
| `setStart`                 |           | Module.ts         | [x] | [x] | [ ] |
| `getStart`                 |           | Module.ts         | [x] | [x] | [ ] |
| `getFeatures`              |           | Module.ts         | [x] | [x] | [ ] |
| `setFeatures`              |           | Module.ts         | [x] | [x] | [ ] |
| `setTypeName`              |           | Module.ts         | [x] | [x] | [ ] |
| `setFieldName`             |           | Module.ts         | [x] | [x] | [ ] |
| `addCustomSection`         |           | Module.ts         | [x] | [x] | [ ] |
| `getExport`                |           | Export.ts         | [x] | [x] | [ ] |
| `getNumExports`            |           | Export.ts         | [x] | [x] | [ ] |
| `getExportByIndex`         |           | Export.ts         | [x] | [x] | [ ] |
| `getNumFunctions`          |           | Function.ts       | [x] | [x] | [ ] |
| `getFunctionByIndex`       |           | Function.ts       | [x] | [x] | [ ] |
| `getNumGlobals`            |           | Global.ts         | [x] | [x] | [ ] |
| `getNumTables`             |           | Table.ts          | [x] | [x] | [ ] |
| `getNumElementSegments`    |           | ElementSegment.ts | [x] | [x] | [ ] |
| `getGlobalByIndex`         |           | Global.ts         | [x] | [x] | [ ] |
| `getTableByIndex`          |           | Table.ts          | [x] | [x] | [ ] |
| `getElementSegmentByIndex` |           | ElementSegment.ts | [x] | [x] | [ ] |


### class `Module` — Inspection & Debugging
| Name                   | JS Loc    | TS Loc     | Code | API Overview | Tests |
| ---------------------- | --------- | ---------- | ---- | ------------ | ----- |
| `emitText`             | line 2907 | Module.ts  | [x] | [x] | [ ] |
| `emitStackIR`          |           | Module.ts  | [x] | [x] | [ ] |
| `emitAsmjs`            |           | Module.ts  | [x] | [x] | [ ] |
| `validate`             |           | Module.ts  | [x] | [x] | [ ] |
| `optimize`             |           | Module.ts  | [x] | [x] | [ ] |
| `updateMaps`           |           | Module.ts  | [x] | [x] | [ ] |
| `optimizeFunction`     |           | Module.ts  | [x] | [x] | [ ] |
| `runPasses`            |           | Module.ts  | [x] | [x] | [ ] |
| `runPassesOnFunction`  |           | Module.ts  | [x] | [x] | [ ] |
| `dispose`              |           | Module.ts  | [x] | [x] | [ ] |
| `emitBinary`           |           | Module.ts  | [x] | [x] | [ ] |
| `interpret`            |           | Module.ts  | [x] | [x] | [ ] |
| `addDebugInfoFileName` |           | Module.ts  | [x] | [x] | [ ] |
| `getDebugInfoFileName` |           | Module.ts  | [x] | [x] | [ ] |
| `setDebugLocation`     |           | Module.ts  | [x] | [x] | [ ] |
| `copyExpression`       |           | Module.ts  | [x] | [x] | [ ] |


### class `TypeBuilder`
| Name                  | JS Loc    | TS Loc         | Code | API Overview | Tests |
| --------------------- | --------- | -------------- | ---- | ------------ | ----- |
| `TypeBulder`          | line 2999 | TypeBuilder.ts | [x] | [x] | [ ] |
| `getTypeFromHeapType` | line 3074 | globals.ts     | [x] | [x] | [ ] |
| `getHeapType`         | line 3079 | globals.ts     | [x] | [x] | [ ] |


### more classes
| Name               | JS Loc    | TS Loc              | Code | API Overview | Tests |
| ------------------ | --------- | ------------------- | ---- | ------------ | ----- |
| `Relooper`         | line 3085 | Relooper.ts         | [x] | [x] | [ ] |
| `ExpressionRunner` | line 3109 | ExpressionRunner.ts | [x] | [x] | [ ] |


### expression & component infos
| Name                    | JS Loc    | TS Loc            | Code | API Overview | Tests |
| ----------------------- | --------- | ----------------- | ---- | ------------ | ----- |
| `getExpressionId`       | line 3149 | globals.ts        | [x] | [x] | [ ] |
| `getExpressionType`     |           | globals.ts        | [x] | [x] | [ ] |
| `getExpressionInfo`     |           | globals.ts        | [x] | [x] | [ ] |
| `getSideEffects`        | line 3204 | Module.ts         | [x] | [x] | [ ] |
| `createType`            | line 3210 | global.ts         | [x] | [x] | [ ] |
| `expandType`            |           | global.ts         | [x] | [x] | [ ] |
| `getFunctionInfo`       | line 3228 | Function.ts       | [x] | [x] | [ ] |
| `getGlobalInfo`         |           | Function.ts       | [x] | [x] | [ ] |
| `getTableInfo`          |           | Table.ts          | [x] | [x] | [ ] |
| `getElementSegmentInfo` |           | ElementSegment.ts | [x] | [x] | [ ] |
| `getTagInfo`            |           | Tag.ts            | [x] | [x] | [ ] |
| `getExportInfo`         |           | Export.ts         | [x] | [x] | [ ] |


### more global functions & settings
| Name                                 | JS Loc    | TS Loc             | Code | API Overview | Tests |
| ------------------------------------ | --------- | ------------------ | ---- | ------------ | ----- |
| `emitText`                           | line 3307 | globals.ts         | [x] | [x] | [ ] |
| `readBinary`                         | line 3358 | globals.ts         | [x] | [x] | [ ] |
| `readBinaryWithFeatures`             |           | globals.ts         | [x] | [x] | [ ] |
| `parseText`                          |           | globals.ts         | [x] | [x] | [ ] |
| `getOptimizeLevel`                   | line 3384 | SettingsService.ts | [x] | [x] | [ ] |
| `setOptimizeLevel`                   |           | SettingsService.ts | [x] | [x] | [ ] |
| `getShrinkLevel`                     |           | SettingsService.ts | [x] | [x] | [ ] |
| `setShrinkLevel`                     |           | SettingsService.ts | [x] | [x] | [ ] |
| `getDebugInfo`                       |           | SettingsService.ts | [x] | [x] | [ ] |
| `setDebugInfo`                       |           | SettingsService.ts | [x] | [x] | [ ] |
| `getTrapsNeverHappen`                |           | SettingsService.ts | [x] | [x] | [ ] |
| `setTrapsNeverHappen`                |           | SettingsService.ts | [x] | [x] | [ ] |
| `getClosedWorld`                     |           | SettingsService.ts | [x] | [x] | [ ] |
| `setClosedWorld`                     |           | SettingsService.ts | [x] | [x] | [ ] |
| `getLowMemoryUnused`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `setLowMemoryUnused`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `getZeroFilledMemory`                |           | SettingsService.ts | [x] | [x] | [ ] |
| `setZeroFilledMemory`                |           | SettingsService.ts | [x] | [x] | [ ] |
| `getFastMath`                        |           | SettingsService.ts | [x] | [x] | [ ] |
| `setFastMath`                        |           | SettingsService.ts | [x] | [x] | [ ] |
| `getGenerateStackIR`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `setGenerateStackIR`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `getOptimizeStackIR`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `setOptimizeStackIR`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `getPassArgument`                    |           | SettingsService.ts | [x] | [x] | [ ] |
| `setPassArgument`                    |           | SettingsService.ts | [x] | [x] | [ ] |
| `clearPassArguments`                 |           | SettingsService.ts | [x] | [x] | [ ] |
| `hasPassToSkip`                      |           | SettingsService.ts | [x] | [x] | [ ] |
| `addPassToSkip`                      |           | SettingsService.ts | [x] | [x] | [ ] |
| `clearPassesToSkip`                  |           | SettingsService.ts | [x] | [x] | [ ] |
| `getAlwaysInlineMaxSize`             |           | SettingsService.ts | [x] | [x] | [ ] |
| `setAlwaysInlineMaxSize`             |           | SettingsService.ts | [x] | [x] | [ ] |
| `getFlexibleInlineMaxSize`           |           | SettingsService.ts | [x] | [x] | [ ] |
| `setFlexibleInlineMaxSize`           |           | SettingsService.ts | [x] | [x] | [ ] |
| `getOneCallerInlineMaxSize`          |           | SettingsService.ts | [x] | [x] | [ ] |
| `setOneCallerInlineMaxSize`          |           | SettingsService.ts | [x] | [x] | [ ] |
| `getAllowInliningFunctionsWithLoops` |           | SettingsService.ts | [x] | [x] | [ ] |
| `setAllowInliningFunctionsWithLoops` |           | SettingsService.ts | [x] | [x] | [ ] |


### Expression Wrappers
| Name                | JS Loc    | TS Loc          | Code | API Overview | Tests |
| ------------------- | --------- | --------------- | ---- | ------------ | ----- |
| `Expression`        | line 3645 | Expression.ts   | [x] | [x] | [ ] |
| `Block`             | line 3677 | blocks.ts       | [x] | [x] | [ ] |
| `If`                |           | blocks.ts       | [x] | [x] | [ ] |
| `Loop`              |           | blocks.ts       | [x] | [x] | [ ] |
| `Break`             |           | breaks.ts       | [x] | [x] | [ ] |
| `Switch`            |           | breaks.ts       | [x] | [x] | [ ] |
| `Call`              |           | calls.ts        | [x] | [x] | [ ] |
| `CallIndirect`      |           | calls.ts        | [x] | [x] | [ ] |
| `LocalGet`          |           | variables.ts    | [x] | [x] | [ ] |
| `LocalSet`          |           | variables.ts    | [x] | [x] | [ ] |
| `GlobalGet`         |           | variables.ts    | [x] | [x] | [ ] |
| `GlobalSet`         |           | variables.ts    | [x] | [x] | [ ] |
| `TableGet`          |           | tables.ts       | [x] | [x] | [ ] |
| `TableSet`          |           | tables.ts       | [x] | [x] | [ ] |
| `TableSize`         |           | tables.ts       | [x] | [x] | [ ] |
| `TableGrow`         |           | tables.ts       | [x] | [x] | [ ] |
| `MemorySize`        |           | memories.ts     | [x] | [x] | [ ] |
| `MemoryGrow`        |           | memories.ts     | [x] | [x] | [ ] |
| `Load`              |           | memories.ts     | [x] | [x] | [ ] |
| `Store`             |           | memories.ts     | [x] | [x] | [ ] |
| `Const`             |           | numerics.ts     | [x] | [x] | [ ] |
| `Unary`             |           | numerics.ts     | [x] | [x] | [ ] |
| `Binary`            |           | numerics.ts     | [x] | [x] | [ ] |
| `WideIntAddSub`     |           | numerics.ts     | [x] | [x] | [ ] |
| `WideIntMul`        |           | numerics.ts     | [x] | [x] | [ ] |
| `Select`            |           | parametrics.ts  | [x] | [x] | [ ] |
| `Drop`              |           | parametrics.ts  | [x] | [x] | [ ] |
| `Return`            |           | calls.ts        | [x] | [x] | [ ] |
| `AtomicRMW`         |           | atomics.ts      | [x] | [x] | [ ] |
| `AtomicCmpxchg`     |           | atomics.ts      | [x] | [x] | [ ] |
| `AtomicWait`        |           | atomics.ts      | [x] | [x] | [ ] |
| `AtomicNotify`      |           | atomics.ts      | [x] | [x] | [ ] |
| `AtomicFence`       |           | atomics.ts      | [x] | [x] | [ ] |
| `SIMDExtract`       |           | vectors.ts      | [x] | [x] | [ ] |
| `SIMDReplace`       |           | vectors.ts      | [x] | [x] | [ ] |
| `SIMDShuffle`       |           | vectors.ts      | [x] | [x] | [ ] |
| `SIMDTernary`       |           | vectors.ts      | [x] | [x] | [ ] |
| `SIMDShift`         |           | vectors.ts      | [x] | [x] | [ ] |
| `SIMDLoad`          |           | memories.ts     | [x] | [x] | [ ] |
| `SIMDLoadStoreLane` |           | memories.ts     | [x] | [x] | [ ] |
| `MemoryInit`        |           | memories.ts     | [x] | [x] | [ ] |
| `DataDrop`          |           | memories.ts     | [x] | [x] | [ ] |
| `MemoryCopy`        |           | memories.ts     | [x] | [x] | [ ] |
| `MemoryFill`        |           | memories.ts     | [x] | [x] | [ ] |
| `RefIsNull`         |           | references.ts   | [x] | [x] | [ ] |
| `RefAs`             |           | references.ts   | [x] | [x] | [ ] |
| `RefFunc`           |           | references.ts   | [x] | [x] | [ ] |
| `RefEq`             |           | references.ts   | [x] | [x] | [ ] |
| `RefTest`           |           | references.ts   | [x] | [x] | [ ] |
| `RefCast`           |           | references.ts   | [x] | [x] | [ ] |
| `BrOn`              |           | breaks.ts       | [x] | [x] | [ ] |
| `StructNew`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `StructGet`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `StructSet`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayNew`          |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayNewFixed`     |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayNewData`      |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayNewElem`      |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayGet`          |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArraySet`          |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayLen`          |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayFill`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayCopy`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayInitData`     |           | aggregates.ts   | [x] | [x] | [ ] |
| `ArrayInitElem`     |           | aggregates.ts   | [x] | [x] | [ ] |
| `Try`               |           | throws.ts       | [x] | [x] | [ ] |
| `Throw`             |           | throws.ts       | [x] | [x] | [ ] |
| `Rethrow`           |           | throws.ts       | [x] | [x] | [ ] |
| `TupleMake`         |           | aggregates.ts   | [x] | [x] | [ ] |
| `TupleExtract`      |           | aggregates.ts   | [x] | [x] | [ ] |
| `RefI31`            |           | references.ts   | [x] | [x] | [ ] |
| `I31Get`            |           | references.ts   | [x] | [x] | [ ] |
| `CallRef`           |           | calls.ts        | [x] | [x] | [ ] |


### Component Wrappers
| Name        | JS Loc    | TS Loc      | Code | API Overview | Tests |
| ----------- | --------- | ----------- | ---- | ------------ | ----- |
| `Function`  | line 5388 | Function.ts | [x] | [x] | [ ] |
| `Table`     | line 5445 | Table.ts    | [x] | [x] | [ ] |


### Additional
| Name    | JS Loc    | TS Loc      | Code | API Overview | Tests |
| ------- | --------- | ----------- | ---- | ------------ | ----- |
| `exit`  | line 5570 | globals.ts  | [x] | [x] | [ ] |



## Test Migration — `/test/binaryen.js/`
TODO
