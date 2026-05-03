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

## How to Contribute
Make sure you have Git and Node (and NPM) installed on your machine, and have already cloned the **WebAssembly/binaryen** repo.

From the repo’s root:
```zsh
$ cd ./ts/
$ npm ci
$ npm run build
```

File Inventory:
- `README.md`: *you are here*

- `{.editorconfig,.gitignore}`: standard repo files

- `package{,-lock}.json`: Node package & npm registry details

- `node_modules/` *(gitignored)*: npm dependencies

- `tsconfig.json`: TypeScript configuration

- `eslint.config.js`: JS/TS coding style conventions

- `typedoc.config.js`: documentation generator configuration

- `src/`: human-written source code

	- `binaryen.ts`: the entrypoint; exports everything available to consumers

	- `-pre.d.ts`: artifacts provided by Emscripten

	- `{lib,utils}.ts`: internal tools

	- `{constants,globals}.ts`: top-level exported globals

	- `-deprecations.ts`: everything deprecated, all in one place

	- `classes/`: all the modular code

		- `{TypeBuilder,ExpressionRunner,Relooper}.ts`: Binaryen tools

		- `module/`: Module and related classes

		- `expression/`: Expression info classes, and source for WASM expression generation

	- `services/`: namespace-like, stateless classes

- `dist/` *(gitignored)*: output of **tsc**; this gets published to npm for consumers

- `docs/`: documentation

	- `out/` *(gitignored)*: output of **typedoc**; gitignored
