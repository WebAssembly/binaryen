/**
 * A collection of types and classes related to WASM module manipulation.
 *
 * Each class represents a component of a WASM module.
 * Additional interfaces for module manipulation are included.
 * @module MOD
 */



export {Tag, type ModuleTags} from "./Tag.ts";
export {Global, type ModuleGlobals} from "./Global.ts";
export {Memory, type ModuleMemories} from "./Memory.ts";
export {Table, type ModuleTables} from "./Table.ts";
export {Function, type ModuleFunctions} from "./Function.ts";
export {DataSegment, type ModuleDataSegments} from "./DataSegment.ts";
export {ElementSegment, type ModuleElementSegments} from "./ElementSegment.ts";
export {Import, type ModuleImports} from "./Import.ts";
export {Export, type ModuleExports} from "./Export.ts";
