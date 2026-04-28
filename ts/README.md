# Binaryen.TS
Binaryen API ported to TypeScript for use in the browser and in Node.JS.

## How To Use
```zsh
$ npm install binaryen.ts
```
```ts
import * as binaryen from "binaryen.ts";

const mod: binaryen.Module = new binaryen.Module();

mod.addFunction("add", binaryen.createType([binaryen.i32, binaryen.i32]), binaryen.i32, [binaryen.i32], (() => {
	const param0: binaryen.ExpressionRef = mod.local.get(0, binaryen.i32);
	const param1: binaryen.ExpressionRef = mod.local.get(1, binaryen.i32);
	const result: binaryen.ExpressionRef = mod.i32.add(param0, param1);
	return mod.block(null, [
		mod.local.set(2, result),
		mod.local.get(2, binaryen.i32),
	], binaryen.i32);
})());
mod.addFunctionExport("add", "add");
mod.optimize();
if (!mod.validate()) {
	throw new Error("Invalid WebAssembly module.");
}

const textData = mod.emitText();
const wasmData = mod.emitBinary() as Uint8Array<ArrayBuffer>;
const compiled = new WebAssembly.Module(wasmData);
const instance = new WebAssembly.Instance(compiled, {});

console.log(instance.exports.add(41, 1)); // 42
```
