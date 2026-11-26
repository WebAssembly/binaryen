// # Deprecations # //



import * as util from "node:util";
import * as expressions from "./classes/expression/index.ts";
import {
	Feature,
	Module,
} from "./classes/module/Module.ts";
import {
	type ElementSegmentRef,
	type ExportRef,
	ExpressionId,
	type ExpressionRef,
	ExternalKind,
	type FunctionRef,
	type GlobalRef,
	SideEffect,
	type TableRef,
	type TagRef,
} from "./constants.ts";
import {
	settings,
} from "./services/SettingsService.ts";



/** @deprecated The `ExpressionIds` enum has been renamed to {@link ExpressionId}. */
export const ExpressionIds = ExpressionId;
/** @deprecated The `SideEffects` enum has been renamed to {@link SideEffect}. */
export const SideEffects = SideEffect;
/** @deprecated The `ExternalKinds` enum has been renamed to {@link ExternalKind}. */
export const ExternalKinds = ExternalKind;
/** @deprecated The `Features` enum has been renamed to {@link Feature}. */
export const Features = Feature;



/** @deprecated The `TagInfo` object type is now called {@link Module.Tag}. */
export type TagInfo = Module.Tag;
/** @deprecated The `GlobalInfo` object type is now called {@link Module.Global}. */
export type GlobalInfo = Module.Global;
/** @deprecated The `MemoryInfo` object type is now called {@link Module.Memory}*/
export type MemoryInfo = Module.Memory;
/** @deprecated The `TableInfo` object type is now called {@link Module.Table}. */
export type TableInfo = Module.Table;
/** @deprecated The `FunctionInfo` object type is now called {@link Module.Function}. */
export type FunctionInfo = Module.Function;
// type `DataSegmentInfo` never existed
/** @deprecated The `ElementSegmentInfo` object type is now called {@link Module.ElementSegment}. */
export type ElementSegmentInfo = Module.ElementSegment;
// type `ImportInfo` never existed
/** @deprecated The `ExportInfo` object type is now called {@link Module.Export}. */
export type ExportInfo = Module.Export;



/** @deprecated The `ExpressionInfo` object type is now called {@link expressions.Expression}. */
export type ExpressionInfo = expressions.Expression;
/** @deprecated The `DropInfo` object type is now called {@link expressions.Drop}. */
export type DropInfo = expressions.Drop;
/** @deprecated The `SelectInfo` object type is now called {@link expressions.Select}. */
export type SelectInfo = expressions.Select;
/** @deprecated The `BlockInfo` object type is now called {@link expressions.Block}. */
export type BlockInfo = expressions.Block;
/** @deprecated The `LoopInfo` object type is now called {@link expressions.Loop}. */
export type LoopInfo = expressions.Loop;
/** @deprecated The `IfInfo` object type is now called {@link expressions.If}. */
export type IfInfo = expressions.If;
/** @deprecated The `BreakInfo` object type is now called {@link expressions.Break}. */
export type BreakInfo = expressions.Break;
/** @deprecated The `SwitchInfo` object type is now called {@link expressions.Switch}. */
export type SwitchInfo = expressions.Switch;
/** @deprecated The `BrOnInfo` object type is now called {@link expressions.BrOn}. */
export type BrOnInfo = expressions.BrOn;
/** @deprecated The `CallInfo` object type is now called {@link expressions.Call}. */
export type CallInfo = expressions.Call;
/** @deprecated The `CallRefInfo` object type is now called {@link expressions.CallRef}. */
export type CallRefInfo = expressions.CallRef;
/** @deprecated The `CallIndirectInfo` object type is now called {@link expressions.CallIndirect}. */
export type CallIndirectInfo = expressions.CallIndirect;
/** @deprecated The `ReturnInfo` object type is now called {@link expressions.Return}. */
export type ReturnInfo = expressions.Return;
/** @deprecated The `ThrowInfo` object type is now called {@link expressions.Throw}. */
export type ThrowInfo = expressions.Throw;
/** @deprecated The `RethrowInfo` object type is now called {@link expressions.Rethrow}. */
export type RethrowInfo = expressions.Rethrow;
/** @deprecated The `ThrowRefInfo` object type is now called {@link expressions.ThrowRef}. */
export type ThrowRefInfo = expressions.ThrowRef;
/** @deprecated The `TryInfo` object type is now called {@link expressions.Try}. */
export type TryInfo = expressions.Try;
/** @deprecated The `TryTableInfo` object type is now called {@link expressions.TryTable}. */
export type TryTableInfo = expressions.TryTable;
/** @deprecated The `LocalGetInfo` object type is now called {@link expressions.LocalGet}. */
export type LocalGetInfo = expressions.LocalGet;
/** @deprecated The `LocalSetInfo` object type is now called {@link expressions.LocalSet}. */
export type LocalSetInfo = expressions.LocalSet;
/** @deprecated The `GlobalGetInfo` object type is now called {@link expressions.GlobalGet}. */
export type GlobalGetInfo = expressions.GlobalGet;
/** @deprecated The `GlobalSetInfo` object type is now called {@link expressions.GlobalSet}. */
export type GlobalSetInfo = expressions.GlobalSet;
/** @deprecated The `TableGetInfo` object type is now called {@link expressions.TableGet}. */
export type TableGetInfo = expressions.TableGet;
/** @deprecated The `TableSetInfo` object type is now called {@link expressions.TableSet}. */
export type TableSetInfo = expressions.TableSet;
/** @deprecated The `TableSizeInfo` object type is now called {@link expressions.TableSize}. */
export type TableSizeInfo = expressions.TableSize;
/** @deprecated The `TableGrowInfo` object type is now called {@link expressions.TableGrow}. */
export type TableGrowInfo = expressions.TableGrow;
/** @deprecated The `LoadInfo` object type is now called {@link expressions.Load}. */
export type LoadInfo = expressions.Load;
/** @deprecated The `StoreInfo` object type is now called {@link expressions.Store}. */
export type StoreInfo = expressions.Store;
/** @deprecated The `SIMDLoadInfo` object type is now called {@link expressions.SIMDLoad}. */
export type SIMDLoadInfo = expressions.SIMDLoad;
/** @deprecated The `SIMDLoadStoreLaneInfo` object type is now called {@link expressions.SIMDLoadStoreLane}. */
export type SIMDLoadStoreLaneInfo = expressions.SIMDLoadStoreLane;
/** @deprecated The `MemorySizeInfo` object type is now called {@link expressions.MemorySize}. */
export type MemorySizeInfo = expressions.MemorySize;
/** @deprecated The `MemoryGrowInfo` object type is now called {@link expressions.MemoryGrow}. */
export type MemoryGrowInfo = expressions.MemoryGrow;
/** @deprecated The `MemoryFillInfo` object type is now called {@link expressions.MemoryFill}. */
export type MemoryFillInfo = expressions.MemoryFill;
/** @deprecated The `MemoryCopyInfo` object type is now called {@link expressions.MemoryCopy}. */
export type MemoryCopyInfo = expressions.MemoryCopy;
/** @deprecated The `MemoryInitInfo` object type is now called {@link expressions.MemoryInit}. */
export type MemoryInitInfo = expressions.MemoryInit;
/** @deprecated The `DataDropInfo` object type is now called {@link expressions.DataDrop}. */
export type DataDropInfo = expressions.DataDrop;
/** @deprecated The `RefFuncInfo` object type is now called {@link expressions.RefFunc}. */
export type RefFuncInfo = expressions.RefFunc;
/** @deprecated The `RefIsNullInfo` object type is now called {@link expressions.RefIsNull}. */
export type RefIsNullInfo = expressions.RefIsNull;
/** @deprecated The `RefAsInfo` object type is now called {@link expressions.RefAs}. */
export type RefAsInfo = expressions.RefAs;
/** @deprecated The `RefEqInfo` object type is now called {@link expressions.RefEq}. */
export type RefEqInfo = expressions.RefEq;
/** @deprecated The `RefTestInfo` object type is now called {@link expressions.RefTest}. */
export type RefTestInfo = expressions.RefTest;
/** @deprecated The `RefCastInfo` object type is now called {@link expressions.RefCast}. */
export type RefCastInfo = expressions.RefCast;
/** @deprecated The `RefI31Info` object type is now called {@link expressions.RefI31}. */
export type RefI31Info = expressions.RefI31;
/** @deprecated The `I31GetInfo` object type is now called {@link expressions.I31Get}. */
export type I31GetInfo = expressions.I31Get;
/** @deprecated The `TupleMakeInfo` object type is now called {@link expressions.TupleMake}. */
export type TupleMakeInfo = expressions.TupleMake;
/** @deprecated The `TupleExtractInfo` object type is now called {@link expressions.TupleExtract}. */
export type TupleExtractInfo = expressions.TupleExtract;
/** @deprecated The `StructNewInfo` object type is now called {@link expressions.StructNew}. */
export type StructNewInfo = expressions.StructNew;
/** @deprecated The `StructGetInfo` object type is now called {@link expressions.StructGet}. */
export type StructGetInfo = expressions.StructGet;
/** @deprecated The `StructSetInfo` object type is now called {@link expressions.StructSet}. */
export type StructSetInfo = expressions.StructSet;
/** @deprecated The `StructWaitInfo` object type is now called {@link expressions.StructWait}. */
export type StructWaitInfo = expressions.StructWait;
/** @deprecated The `WaitqueueNewInfo` object type is now called {@link expressions.WaitqueueNew}. */
export type WaitqueueNewInfo = expressions.WaitqueueNew;
/** @deprecated The `WaitqueueNotifyInfo` object type is now called {@link expressions.WaitqueueNotify}. */
export type WaitqueueNotifyInfo = expressions.WaitqueueNotify;
/** @deprecated The `PublishInfo` object type is now called {@link expressions.Publish}. */
export type PublishInfo = expressions.Publish;
/** @deprecated The `ArrayNewInfo` object type is now called {@link expressions.ArrayNew}. */
export type ArrayNewInfo = expressions.ArrayNew;
/** @deprecated The `ArrayNewFixedInfo` object type is now called {@link expressions.ArrayNewFixed}. */
export type ArrayNewFixedInfo = expressions.ArrayNewFixed;
/** @deprecated The `ArrayNewDataInfo` object type is now called {@link expressions.ArrayNewData}. */
export type ArrayNewDataInfo = expressions.ArrayNewData;
/** @deprecated The `ArrayNewElemInfo` object type is now called {@link expressions.ArrayNewElem}. */
export type ArrayNewElemInfo = expressions.ArrayNewElem;
/** @deprecated The `ArrayGetInfo` object type is now called {@link expressions.ArrayGet}. */
export type ArrayGetInfo = expressions.ArrayGet;
/** @deprecated The `ArraySetInfo` object type is now called {@link expressions.ArraySet}. */
export type ArraySetInfo = expressions.ArraySet;
/** @deprecated The `ArrayLenInfo` object type is now called {@link expressions.ArrayLen}. */
export type ArrayLenInfo = expressions.ArrayLen;
/** @deprecated The `ArrayFillInfo` object type is now called {@link expressions.ArrayFill}. */
export type ArrayFillInfo = expressions.ArrayFill;
/** @deprecated The `ArrayCopyInfo` object type is now called {@link expressions.ArrayCopy}. */
export type ArrayCopyInfo = expressions.ArrayCopy;
/** @deprecated The `ArrayInitDataInfo` object type is now called {@link expressions.ArrayInitData}. */
export type ArrayInitDataInfo = expressions.ArrayInitData;
/** @deprecated The `ArrayInitElemInfo` object type is now called {@link expressions.ArrayInitElem}. */
export type ArrayInitElemInfo = expressions.ArrayInitElem;
/** @deprecated The `ConstInfo` object type is now called {@link expressions.Const}. */
export type ConstInfo = expressions.Const;
/** @deprecated The `UnaryInfo` object type is now called {@link expressions.Unary}. */
export type UnaryInfo = expressions.Unary;
/** @deprecated The `BinaryInfo` object type is now called {@link expressions.Binary}. */
export type BinaryInfo = expressions.Binary;
/** @deprecated The `SIMDTernaryInfo` object type is now called {@link expressions.SIMDTernary}. */
export type SIMDTernaryInfo = expressions.SIMDTernary;
/** @deprecated The `SIMDShiftInfo` object type is now called {@link expressions.SIMDShift}. */
export type SIMDShiftInfo = expressions.SIMDShift;
/** @deprecated The `SIMDShuffleInfo` object type is now called {@link expressions.SIMDShuffle}. */
export type SIMDShuffleInfo = expressions.SIMDShuffle;
/** @deprecated The `SIMDExtractInfo` object type is now called {@link expressions.SIMDExtract}. */
export type SIMDExtractInfo = expressions.SIMDExtract;
/** @deprecated The `SIMDReplaceInfo` object type is now called {@link expressions.SIMDReplace}. */
export type SIMDReplaceInfo = expressions.SIMDReplace;
/** @deprecated The `AtomicRMWInfo` object type is now called {@link expressions.AtomicRMW}. */
export type AtomicRMWInfo = expressions.AtomicRMW;
/** @deprecated The `AtomicCmpxchgInfo` object type is now called {@link expressions.AtomicCmpxchg}. */
export type AtomicCmpxchgInfo = expressions.AtomicCmpxchg;
/** @deprecated The `AtomicWaitInfo` object type is now called {@link expressions.AtomicWait}. */
export type AtomicWaitInfo = expressions.AtomicWait;
/** @deprecated The `AtomicNotifyInfo` object type is now called {@link expressions.AtomicNotify}. */
export type AtomicNotifyInfo = expressions.AtomicNotify;
/** @deprecated The `AtomicFenceInfo` object type is now called {@link expressions.AtomicFence}. */
export type AtomicFenceInfo = expressions.AtomicFence;
/** @deprecated The `StringNewInfo` object type is now called {@link expressions.StringNew}. */
export type StringNewInfo = expressions.StringNew;
/** @deprecated The `StringConstInfo` object type is now called {@link expressions.StringConst}. */
export type StringConstInfo = expressions.StringConst;
/** @deprecated The `StringMeasureInfo` object type is now called {@link expressions.StringMeasure}. */
export type StringMeasureInfo = expressions.StringMeasure;
/** @deprecated The `StringEncodeInfo` object type is now called {@link expressions.StringEncode}. */
export type StringEncodeInfo = expressions.StringEncode;
/** @deprecated The `StringConcatInfo` object type is now called {@link expressions.StringConcat}. */
export type StringConcatInfo = expressions.StringConcat;
/** @deprecated The `StringEqInfo` object type is now called {@link expressions.StringEq}. */
export type StringEqInfo = expressions.StringEq;
/** @deprecated The `StringWTF16GetInfo` object type is now called {@link expressions.StringWTF16Get}. */
export type StringWTF16GetInfo = expressions.StringWTF16Get;
/** @deprecated The `StringSliceWTFInfo` object type is now called {@link expressions.StringSliceWTF}. */
export type StringSliceWTFInfo = expressions.StringSliceWTF;
/** @deprecated The `WideIntAddSubInfo` object type is now called {@link expressions.WideIntAddSub}. */
export type WideIntAddSubInfo = expressions.WideIntAddSub;
/** @deprecated The `WideIntMulInfo` object type is now called {@link expressions.WideIntMul}. */
export type WideIntMulInfo = expressions.WideIntMul;



/** @deprecated The `Drop` class now lives under the `expressions` namespace. Use {@link expressions.Drop}. */
export const Drop = expressions.Drop;
/** @deprecated The `Select` class now lives under the `expressions` namespace. Use {@link expressions.Select}. */
export const Select = expressions.Select;
/** @deprecated The `Block` class now lives under the `expressions` namespace. Use {@link expressions.Block}. */
export const Block = expressions.Block;
/** @deprecated The `Loop` class now lives under the `expressions` namespace. Use {@link expressions.Loop}. */
export const Loop = expressions.Loop;
/** @deprecated The `If` class now lives under the `expressions` namespace. Use {@link expressions.If}. */
export const If = expressions.If;
/** @deprecated The `Break` class now lives under the `expressions` namespace. Use {@link expressions.Break}. */
export const Break = expressions.Break;
/** @deprecated The `Switch` class now lives under the `expressions` namespace. Use {@link expressions.Switch}. */
export const Switch = expressions.Switch;
/** @deprecated The `BrOn` class now lives under the `expressions` namespace. Use {@link expressions.BrOn}. */
export const BrOn = expressions.BrOn;
/** @deprecated The `Call` class now lives under the `expressions` namespace. Use {@link expressions.Call}. */
export const Call = expressions.Call;
/** @deprecated The `CallRef` class now lives under the `expressions` namespace. Use {@link expressions.CallRef}. */
export const CallRef = expressions.CallRef;
/** @deprecated The `CallIndirect` class now lives under the `expressions` namespace. Use {@link expressions.CallIndirect}. */
export const CallIndirect = expressions.CallIndirect;
/** @deprecated The `Return` class now lives under the `expressions` namespace. Use {@link expressions.Return}. */
export const Return = expressions.Return;
/** @deprecated The `Throw` class now lives under the `expressions` namespace. Use {@link expressions.Throw}. */
export const Throw = expressions.Throw;
/** @deprecated The `Rethrow` class now lives under the `expressions` namespace. Use {@link expressions.Rethrow}. */
export const Rethrow = expressions.Rethrow;
/** @deprecated The `Try` class now lives under the `expressions` namespace. Use {@link expressions.Try}. */
export const Try = expressions.Try;
/** @deprecated The `LocalGet` class now lives under the `expressions` namespace. Use {@link expressions.LocalGet}. */
export const LocalGet = expressions.LocalGet;
/** @deprecated The `LocalSet` class now lives under the `expressions` namespace. Use {@link expressions.LocalSet}. */
export const LocalSet = expressions.LocalSet;
/** @deprecated The `GlobalGet` class now lives under the `expressions` namespace. Use {@link expressions.GlobalGet}. */
export const GlobalGet = expressions.GlobalGet;
/** @deprecated The `GlobalSet` class now lives under the `expressions` namespace. Use {@link expressions.GlobalSet}. */
export const GlobalSet = expressions.GlobalSet;
/** @deprecated The `TableGet` class now lives under the `expressions` namespace. Use {@link expressions.TableGet}. */
export const TableGet = expressions.TableGet;
/** @deprecated The `TableSet` class now lives under the `expressions` namespace. Use {@link expressions.TableSet}. */
export const TableSet = expressions.TableSet;
/** @deprecated The `TableSize` class now lives under the `expressions` namespace. Use {@link expressions.TableSize}. */
export const TableSize = expressions.TableSize;
/** @deprecated The `TableGrow` class now lives under the `expressions` namespace. Use {@link expressions.TableGrow}. */
export const TableGrow = expressions.TableGrow;
/** @deprecated The `Load` class now lives under the `expressions` namespace. Use {@link expressions.Load}. */
export const Load = expressions.Load;
/** @deprecated The `Store` class now lives under the `expressions` namespace. Use {@link expressions.Store}. */
export const Store = expressions.Store;
/** @deprecated The `SIMDLoad` class now lives under the `expressions` namespace. Use {@link expressions.SIMDLoad}. */
export const SIMDLoad = expressions.SIMDLoad;
/** @deprecated The `SIMDLoadStoreLane` class now lives under the `expressions` namespace. Use {@link expressions.SIMDLoadStoreLane}. */
export const SIMDLoadStoreLane = expressions.SIMDLoadStoreLane;
/** @deprecated The `MemorySize` class now lives under the `expressions` namespace. Use {@link expressions.MemorySize}. */
export const MemorySize = expressions.MemorySize;
/** @deprecated The `MemoryGrow` class now lives under the `expressions` namespace. Use {@link expressions.MemoryGrow}. */
export const MemoryGrow = expressions.MemoryGrow;
/** @deprecated The `MemoryFill` class now lives under the `expressions` namespace. Use {@link expressions.MemoryFill}. */
export const MemoryFill = expressions.MemoryFill;
/** @deprecated The `MemoryCopy` class now lives under the `expressions` namespace. Use {@link expressions.MemoryCopy}. */
export const MemoryCopy = expressions.MemoryCopy;
/** @deprecated The `MemoryInit` class now lives under the `expressions` namespace. Use {@link expressions.MemoryInit}. */
export const MemoryInit = expressions.MemoryInit;
/** @deprecated The `DataDrop` class now lives under the `expressions` namespace. Use {@link expressions.DataDrop}. */
export const DataDrop = expressions.DataDrop;
/** @deprecated The `RefFunc` class now lives under the `expressions` namespace. Use {@link expressions.RefFunc}. */
export const RefFunc = expressions.RefFunc;
/** @deprecated The `RefIsNull` class now lives under the `expressions` namespace. Use {@link expressions.RefIsNull}. */
export const RefIsNull = expressions.RefIsNull;
/** @deprecated The `RefAs` class now lives under the `expressions` namespace. Use {@link expressions.RefAs}. */
export const RefAs = expressions.RefAs;
/** @deprecated The `RefEq` class now lives under the `expressions` namespace. Use {@link expressions.RefEq}. */
export const RefEq = expressions.RefEq;
/** @deprecated The `RefTest` class now lives under the `expressions` namespace. Use {@link expressions.RefTest}. */
export const RefTest = expressions.RefTest;
/** @deprecated The `RefCast` class now lives under the `expressions` namespace. Use {@link expressions.RefCast}. */
export const RefCast = expressions.RefCast;
/** @deprecated The `RefI31` class now lives under the `expressions` namespace. Use {@link expressions.RefI31}. */
export const RefI31 = expressions.RefI31;
/** @deprecated The `I31Get` class now lives under the `expressions` namespace. Use {@link expressions.I31Get}. */
export const I31Get = expressions.I31Get;
/** @deprecated The `TupleMake` class now lives under the `expressions` namespace. Use {@link expressions.TupleMake}. */
export const TupleMake = expressions.TupleMake;
/** @deprecated The `TupleExtract` class now lives under the `expressions` namespace. Use {@link expressions.TupleExtract}. */
export const TupleExtract = expressions.TupleExtract;
/** @deprecated The `StructNew` class now lives under the `expressions` namespace. Use {@link expressions.StructNew}. */
export const StructNew = expressions.StructNew;
/** @deprecated The `StructGet` class now lives under the `expressions` namespace. Use {@link expressions.StructGet}. */
export const StructGet = expressions.StructGet;
/** @deprecated The `StructSet` class now lives under the `expressions` namespace. Use {@link expressions.StructSet}. */
export const StructSet = expressions.StructSet;
/** @deprecated The `ArrayNew` class now lives under the `expressions` namespace. Use {@link expressions.ArrayNew}. */
export const ArrayNew = expressions.ArrayNew;
/** @deprecated The `ArrayNewFixed` class now lives under the `expressions` namespace. Use {@link expressions.ArrayNewFixed}. */
export const ArrayNewFixed = expressions.ArrayNewFixed;
/** @deprecated The `ArrayNewData` class now lives under the `expressions` namespace. Use {@link expressions.ArrayNewData}. */
export const ArrayNewData = expressions.ArrayNewData;
/** @deprecated The `ArrayNewElem` class now lives under the `expressions` namespace. Use {@link expressions.ArrayNewElem}. */
export const ArrayNewElem = expressions.ArrayNewElem;
/** @deprecated The `ArrayGet` class now lives under the `expressions` namespace. Use {@link expressions.ArrayGet}. */
export const ArrayGet = expressions.ArrayGet;
/** @deprecated The `ArraySet` class now lives under the `expressions` namespace. Use {@link expressions.ArraySet}. */
export const ArraySet = expressions.ArraySet;
/** @deprecated The `ArrayLen` class now lives under the `expressions` namespace. Use {@link expressions.ArrayLen}. */
export const ArrayLen = expressions.ArrayLen;
/** @deprecated The `ArrayFill` class now lives under the `expressions` namespace. Use {@link expressions.ArrayFill}. */
export const ArrayFill = expressions.ArrayFill;
/** @deprecated The `ArrayCopy` class now lives under the `expressions` namespace. Use {@link expressions.ArrayCopy}. */
export const ArrayCopy = expressions.ArrayCopy;
/** @deprecated The `ArrayInitData` class now lives under the `expressions` namespace. Use {@link expressions.ArrayInitData}. */
export const ArrayInitData = expressions.ArrayInitData;
/** @deprecated The `ArrayInitElem` class now lives under the `expressions` namespace. Use {@link expressions.ArrayInitElem}. */
export const ArrayInitElem = expressions.ArrayInitElem;
/** @deprecated The `Const` class now lives under the `expressions` namespace. Use {@link expressions.Const}. */
export const Const = expressions.Const;
/** @deprecated The `Unary` class now lives under the `expressions` namespace. Use {@link expressions.Unary}. */
export const Unary = expressions.Unary;
/** @deprecated The `Binary` class now lives under the `expressions` namespace. Use {@link expressions.Binary}. */
export const Binary = expressions.Binary;
/** @deprecated The `SIMDTernary` class now lives under the `expressions` namespace. Use {@link expressions.SIMDTernary}. */
export const SIMDTernary = expressions.SIMDTernary;
/** @deprecated The `SIMDShift` class now lives under the `expressions` namespace. Use {@link expressions.SIMDShift}. */
export const SIMDShift = expressions.SIMDShift;
/** @deprecated The `SIMDShuffle` class now lives under the `expressions` namespace. Use {@link expressions.SIMDShuffle}. */
export const SIMDShuffle = expressions.SIMDShuffle;
/** @deprecated The `SIMDExtract` class now lives under the `expressions` namespace. Use {@link expressions.SIMDExtract}. */
export const SIMDExtract = expressions.SIMDExtract;
/** @deprecated The `SIMDReplace` class now lives under the `expressions` namespace. Use {@link expressions.SIMDReplace}. */
export const SIMDReplace = expressions.SIMDReplace;
/** @deprecated The `AtomicRMW` class now lives under the `expressions` namespace. Use {@link expressions.AtomicRMW}. */
export const AtomicRMW = expressions.AtomicRMW;
/** @deprecated The `AtomicCmpxchg` class now lives under the `expressions` namespace. Use {@link expressions.AtomicCmpxchg}. */
export const AtomicCmpxchg = expressions.AtomicCmpxchg;
/** @deprecated The `AtomicWait` class now lives under the `expressions` namespace. Use {@link expressions.AtomicWait}. */
export const AtomicWait = expressions.AtomicWait;
/** @deprecated The `AtomicNotify` class now lives under the `expressions` namespace. Use {@link expressions.AtomicNotify}. */
export const AtomicNotify = expressions.AtomicNotify;
/** @deprecated The `AtomicFence` class now lives under the `expressions` namespace. Use {@link expressions.AtomicFence}. */
export const AtomicFence = expressions.AtomicFence;
/** @deprecated The `StringNew` class now lives under the `expressions` namespace. Use {@link expressions.StringNew}. */
export const StringNew = expressions.StringNew;
/** @deprecated The `StringConst` class now lives under the `expressions` namespace. Use {@link expressions.StringConst}. */
export const StringConst = expressions.StringConst;
/** @deprecated The `StringMeasure` class now lives under the `expressions` namespace. Use {@link expressions.StringMeasure}. */
export const StringMeasure = expressions.StringMeasure;
/** @deprecated The `StringEncode` class now lives under the `expressions` namespace. Use {@link expressions.StringEncode}. */
export const StringEncode = expressions.StringEncode;
/** @deprecated The `StringConcat` class now lives under the `expressions` namespace. Use {@link expressions.StringConcat}. */
export const StringConcat = expressions.StringConcat;
/** @deprecated The `StringEq` class now lives under the `expressions` namespace. Use {@link expressions.StringEq}. */
export const StringEq = expressions.StringEq;
/** @deprecated The `StringWTF16Get` class now lives under the `expressions` namespace. Use {@link expressions.StringWTF16Get}. */
export const StringWTF16Get = expressions.StringWTF16Get;
/** @deprecated The `StringSliceWTF` class now lives under the `expressions` namespace. Use {@link expressions.StringSliceWTF}. */
export const StringSliceWTF = expressions.StringSliceWTF;
/** @deprecated The `WideIntAddSub` class now lives under the `expressions` namespace. Use {@link expressions.WideIntAddSub}. */
export const WideIntAddSub = expressions.WideIntAddSub;
/** @deprecated The `WideIntMul` class now lives under the `expressions` namespace. Use {@link expressions.WideIntMul}. */
export const WideIntMul = expressions.WideIntMul;



/** @deprecated The `Function` class now lives under the `Module` namespace. Use {@link Module.Function}. */
export const Function = Module.Function;
/** @deprecated The `Table` class now lives under the `Module` namespace. Use {@link Module.Table}. */
export const Table = Module.Table;



/** @deprecated Use {@link Module#getSideEffects} instead. */
export const getSideEffects = util.deprecate(
	(expr: ExpressionRef, mod: Module) => mod.getSideEffects(expr),
	"Global function `getSideEffects(expr, mod)` is deprecated; use `mod.getSideEffects(expr)` instead.",
);



/** @deprecated Use {@link Module.Tag | `new Module.Tag(tagref)`} instead. */
export const getTagInfo = util.deprecate(
	(tag: TagRef) => new Module.Tag(tag),
	"Global function `getTagInfo` is deprecated; use `new Module.Tag(tagref)` instead.",
);
/** @deprecated Use {@link Module.Global | `new Module.Global(globalref)`} instead. */
export const getGlobalInfo = util.deprecate(
	(global: GlobalRef) => new Module.Global(global),
	"Global function `getGlobalInfo` is deprecated; use `new Module.Global(globalref)` instead.",
);
// function `getMemoryInfo` always existed in `Module`
/** @deprecated Use {@link Module.Table | `new Module.Table(tableref)`} instead. */
export const getTableInfo = util.deprecate(
	(table: TableRef) => new Module.Table(table),
	"Global function `getTableInfo` is deprecated; use `new Module.Table(tableref)` instead.",
);
/** @deprecated Use {@link Module.Function | `new Module.Function(funcref)`} instead. */
export const getFunctionInfo = util.deprecate(
	(func: FunctionRef) => new Module.Function(func),
	"Global function `getFunctionInfo` is deprecated; use `new Module.Function(funcref)` instead.",
);
// function `getDataSegmentInfo` always existed in `Module`
/** @deprecated Use {@link Module.ElementSegment | `new Module.ElementSegment(segmentref)`} instead. */
export const getElementSegmentInfo = util.deprecate(
	(segment: ElementSegmentRef) => new Module.ElementSegment(segment),
	"Global function `getElementSegmentInfo` is deprecated; use `new Module.ElementSegment(segmentref)` instead.",
);
// no function `getImportInfo` ever existed
/** @deprecated Use {@link Module.Export | `new Module.Export(exportref)`} instead. */
export const getExportInfo = util.deprecate(
	(xport: ExportRef) => new Module.Export(xport),
	"Global function `getExportInfo` is deprecated; use `new Module.Export(exportref)` instead.",
);



/** @deprecated Use {@link settings.optimizeLevel} instead. */
export const getOptimizeLevel = util.deprecate(
	() => settings.optimizeLevel,
	"Global function `getOptimizeLevel` is deprecated; use `settings.optimizeLevel` instead.",
);
/** @deprecated Use {@link settings.optimizeLevel} instead. */
export const setOptimizeLevel = util.deprecate(
	(level: number) => { settings.optimizeLevel = level; },
	"Global function `setOptimizeLevel` is deprecated; use `settings.optimizeLevel = level` instead.",
);
/** @deprecated Use {@link settings.shrinkLevel} instead. */
export const getShrinkLevel = util.deprecate(
	() => settings.shrinkLevel,
	"Global function `getShrinkLevel` is deprecated; use `settings.shrinkLevel` instead.",
);
/** @deprecated Use {@link settings.shrinkLevel} instead. */
export const setShrinkLevel = util.deprecate(
	(level: number) => { settings.shrinkLevel = level; },
	"Global function `setShrinkLevel` is deprecated; use `settings.shrinkLevel = level` instead.",
);
/** @deprecated Use {@link settings.debugInfo} instead. */
export const getDebugInfo = util.deprecate(
	() => settings.debugInfo,
	"Global function `getDebugInfo` is deprecated; use `settings.debugInfo` instead.",
);
/** @deprecated Use {@link settings.debugInfo} instead. */
export const setDebugInfo = util.deprecate(
	(enabled: boolean) => { settings.debugInfo = enabled; },
	"Global function `setDebugInfo` is deprecated; use `settings.debugInfo = enabled` instead.",
);
/** @deprecated Use {@link settings.trapsNeverHappen} instead. */
export const getTrapsNeverHappen = util.deprecate(
	() => settings.trapsNeverHappen,
	"Global function `getTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen` instead.",
);
/** @deprecated Use {@link settings.trapsNeverHappen} instead. */
export const setTrapsNeverHappen = util.deprecate(
	(enabled: boolean) => { settings.trapsNeverHappen = enabled; },
	"Global function `setTrapsNeverHappen` is deprecated; use `settings.trapsNeverHappen = enabled` instead.",
);
/** @deprecated Use {@link settings.closedWorld} instead. */
export const getClosedWorld = util.deprecate(
	() => settings.closedWorld,
	"Global function `getClosedWorld` is deprecated; use `settings.closedWorld` instead.",
);
/** @deprecated Use {@link settings.closedWorld} instead. */
export const setClosedWorld = util.deprecate(
	(enabled: boolean) => { settings.closedWorld = enabled; },
	"Global function `setClosedWorld` is deprecated; use `settings.closedWorld = enabled` instead.",
);
/** @deprecated Use {@link settings.lowMemoryUnused} instead. */
export const getLowMemoryUnused = util.deprecate(
	() => settings.lowMemoryUnused,
	"Global function `getLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused` instead.",
);
/** @deprecated Use {@link settings.lowMemoryUnused} instead. */
export const setLowMemoryUnused = util.deprecate(
	(enabled: boolean) => { settings.lowMemoryUnused = enabled; },
	"Global function `setLowMemoryUnused` is deprecated; use `settings.lowMemoryUnused = enabled` instead.",
);
/** @deprecated Use {@link settings.zeroFilledMemory} instead. */
export const getZeroFilledMemory = util.deprecate(
	() => settings.zeroFilledMemory,
	"Global function `getZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory` instead.",
);
/** @deprecated Use {@link settings.zeroFilledMemory} instead. */
export const setZeroFilledMemory = util.deprecate(
	(enabled: boolean) => { settings.zeroFilledMemory = enabled; },
	"Global function `setZeroFilledMemory` is deprecated; use `settings.zeroFilledMemory = enabled` instead.",
);
/** @deprecated Use {@link settings.fastMath} instead. */
export const getFastMath = util.deprecate(
	() => settings.fastMath,
	"Global function `getFastMath` is deprecated; use `settings.fastMath` instead.",
);
/** @deprecated Use {@link settings.fastMath} instead. */
export const setFastMath = util.deprecate(
	(enabled: boolean) => { settings.fastMath = enabled; },
	"Global function `setFastMath` is deprecated; use `settings.fastMath = enabled` instead.",
);
/** @deprecated Use {@link settings.generateStackIR} instead. */
export const getGenerateStackIR = util.deprecate(
	() => settings.generateStackIR,
	"Global function `getGenerateStackIR` is deprecated; use `settings.generateStackIR` instead.",
);
/** @deprecated Use {@link settings.generateStackIR} instead. */
export const setGenerateStackIR = util.deprecate(
	(enabled: boolean) => { settings.generateStackIR = enabled; },
	"Global function `setGenerateStackIR` is deprecated; use `settings.generateStackIR = enabled` instead.",
);
/** @deprecated Use {@link settings.optimizeStackIR} instead. */
export const getOptimizeStackIR = util.deprecate(
	() => settings.optimizeStackIR,
	"Global function `getOptimizeStackIR` is deprecated; use `settings.optimizeStackIR` instead.",
);
/** @deprecated Use {@link settings.optimizeStackIR} instead. */
export const setOptimizeStackIR = util.deprecate(
	(enabled: boolean) => { settings.optimizeStackIR = enabled; },
	"Global function `setOptimizeStackIR` is deprecated; use `settings.optimizeStackIR = enabled` instead.",
);
/** @deprecated Use {@link settings.alwaysInlineMaxSize} instead. */
export const getAlwaysInlineMaxSize = util.deprecate(
	() => settings.alwaysInlineMaxSize,
	"Global function `getAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize` instead.",
);
/** @deprecated Use {@link settings.alwaysInlineMaxSize} instead. */
export const setAlwaysInlineMaxSize = util.deprecate(
	(size: number) => { settings.alwaysInlineMaxSize = size; },
	"Global function `setAlwaysInlineMaxSize` is deprecated; use `settings.alwaysInlineMaxSize = size` instead.",
);
/** @deprecated Use {@link settings.flexibleInlineMaxSize} instead. */
export const getFlexibleInlineMaxSize = util.deprecate(
	() => settings.flexibleInlineMaxSize,
	"Global function `getFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize` instead.",
);
/** @deprecated Use {@link settings.flexibleInlineMaxSize} instead. */
export const setFlexibleInlineMaxSize = util.deprecate(
	(size: number) => { settings.flexibleInlineMaxSize = size; },
	"Global function `setFlexibleInlineMaxSize` is deprecated; use `settings.flexibleInlineMaxSize = size` instead.",
);
/** @deprecated Use {@link settings.oneCallerInlineMaxSize} instead. */
export const getOneCallerInlineMaxSize = util.deprecate(
	() => settings.oneCallerInlineMaxSize,
	"Global function `getOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize` instead.",
);
/** @deprecated Use {@link settings.oneCallerInlineMaxSize} instead. */
export const setOneCallerInlineMaxSize = util.deprecate(
	(size: number) => { settings.oneCallerInlineMaxSize = size; },
	"Global function `setOneCallerInlineMaxSize` is deprecated; use `settings.oneCallerInlineMaxSize = size` instead.",
);
/** @deprecated Use {@link settings.allowInliningFunctionsWithLoops} instead. */
export const getAllowInliningFunctionsWithLoops = util.deprecate(
	() => settings.allowInliningFunctionsWithLoops,
	"Global function `getAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops` instead.",
);
/** @deprecated Use {@link settings.allowInliningFunctionsWithLoops} instead. */
export const setAllowInliningFunctionsWithLoops = util.deprecate(
	(enabled: boolean) => { settings.allowInliningFunctionsWithLoops = enabled; },
	"Global function `setAllowInliningFunctionsWithLoops` is deprecated; use `settings.allowInliningFunctionsWithLoops = enabled` instead.",
);



/** @deprecated Use {@link settings.getPassArgument} instead. */
export const getPassArgument = util.deprecate(
	(key: string) => settings.getPassArgument(key),
	"Global function `getPassArgument` is deprecated; use `settings.getPassArgument(key)` instead.",
);
/** @deprecated Use {@link settings.setPassArgument} instead. */
export const setPassArgument = util.deprecate(
	(key: string, value?: string) => settings.setPassArgument(key, value),
	"Global function `setPassArgument` is deprecated; use `settings.setPassArgument(key, value)` instead.",
);
/** @deprecated Use {@link settings.clearPassArguments} instead. */
export const clearPassArguments = util.deprecate(
	() => settings.clearPassArguments(),
	"Global function `clearPassArguments` is deprecated; use `settings.clearPassArguments()` instead.",
);
/** @deprecated Use {@link settings.hasPassToSkip} instead. */
export const hasPassToSkip = util.deprecate(
	(pass: string) => settings.hasPassToSkip(pass),
	"Global function `hasPassToSkip` is deprecated; use `settings.hasPassToSkip(pass)` instead.",
);
/** @deprecated Use {@link settings.addPassToSkip} instead. */
export const addPassToSkip = util.deprecate(
	(pass: string) => settings.addPassToSkip(pass),
	"Global function `addPassToSkip` is deprecated; use `settings.addPassToSkip(pass)` instead.",
);
/** @deprecated Use {@link settings.clearPassesToSkip} instead. */
export const clearPassesToSkip = util.deprecate(
	() => settings.clearPassesToSkip(),
	"Global function `clearPassesToSkip` is deprecated; use `settings.clearPassesToSkip()` instead.",
);
