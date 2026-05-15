# Binaryen.TS
Binaryen API ported to TypeScript for use in the browser and in Node.JS.

## How To Use
```zsh
$ npm install binaryen.ts
```
```ts
import * as binaryen from "binaryen.ts";

const mod: binaryen.Module = new binaryen.Module();

mod.functions.add("add", binaryen.createType([binaryen.i32, binaryen.i32]), binaryen.i32, [binaryen.i32], (() => {
	const {block, local, i32} = mod.wasm;
	const param0: binaryen.ExpressionRef = local.get(0, binaryen.i32);
	const param1: binaryen.ExpressionRef = local.get(1, binaryen.i32);
	const result: binaryen.ExpressionRef = i32.add(param0, param1);
	return block(null, [
		local.set(2, result),
		local.get(2, binaryen.i32),
	], binaryen.i32);
})());
mod.exports.addFunction("add", "add");
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
Contributions are welcome!
Make sure you have [Git](https://git-scm.com/) and [Node (and NPM)](https://nodejs.org/) installed on your machine,
and have already cloned the **WebAssembly/binaryen** repo.

From the repo’s root:
```zsh
$ cd ./ts/
$ npm ci
$ npm run build
```

### Pipeline
#### Develop in TypeScript
The core of this project is written in [TS](https://www.typescriptlang.org/), best paired with a powerful editor and some nice extensions.
```zsh
$ npm run compile # emits javascript output to ./dist/
```
Don’t put anything important in `./dist/`, as it gets deleted and rebuilt each time.

Before committing, ensure only the best code quality by running [ESLint](https://eslint.org/).
```zsh
$ npm run lint # reports linter errors & warnings
$ npm run lint -- --fix # tries to auto-fix problems (some may need manual fixing)
```

Use [Conventional Commits](https://www.conventionalcommits.org/) commit message format.
Messages should be in the present tense / command tense.
```zsh
$ git commit -m "feat: add a new feature"
$ git commit -m "feat!: add a new breaking feature" # API consumers need to know about these
$ git commit -m "fix: fix a bug"
$ git commit -m "refactor: reorganize code"
$ git commit -m "lint: fix a coding style issue"
$ git commit -m "docs: update documentation"
$ git commit -m "test: add/update tests"
$ git commit -m "build: make a change related to the package build system"
```

#### Update Docs
Generated documentation is built with [TypeDoc](https://typedoc.org/), a tool that parses comments in the TS source files and produces beautiful HTML.

After developing and updating doc-comments, regenerate docs and view them locally in your browser.
```zsh
$ npm run docs # builds a static site to ../docs/binaryen.ts/
$ open ../docs/binaryen.ts/index.html
```
Don’t put anything important in `../docs/`.

Documentation is hosted online via GitHub Pages at <https://chharvey.github.io/binaryen/binaryen.ts/>,
and will be moved to <https://webassembly.github.io/binaryen/binaryen.ts/> once this fork is merged in.

Upon every release, public docs should be redeployed via updating the `gh-pages` branch. On that branch, the `../docs/` folder is checked in.
You need to switch to that branch, merge in your changes, rebuild the docs, then commit and push.
```zsh
$ git switch gh-pages
$ git merge --no-commit main
$ npm run docs
$ git add ../docs/binaryen.ts/
$ git merge --continue
$ git push
```

#### Run Tests
The test suite is still in progress, migrating from `../test/binaryen.js/`.
The new test suite uses the Node v26+ test runner.
```zsh
$ npm run test
```

#### Bundle
TypeScript only compiles the source files to `./dist/`.
After that we need a bundler to optimize and minify it into one giant JS file,
which will then get processed with Emscripten’s build so that it can be used by consumers.
This will look a lot like AssemblyScript’s build process.

TODO: more details

#### Build and Push
Before pushing, rebuild the entire project to catch any errors.
```zsh
$ npm run build

# if all goes well…

$ git push
```

#### Publish
TODO: this section

### File Inventory
- `README.md`: *you are here*

- `.editorconfig`, `.gitignore`: standard repo files

- `package{,-lock}.json`: Node package & npm registry details

- `node_modules/` *(gitignored)*: npm dependencies

- `tsconfig.json`: TypeScript configuration

- `eslint.config.js`: JS/TS coding style conventions

- `typedoc.config.js`: documentation generator configuration

- `build/` *(gitignored)*: output of **Emscripten**; this is imported by the `src/` library

- `src/`: human-written source code

	- `binaryen.ts`: the entrypoint; exports everything available to consumers

	- `-pre.ts`: artifacts provided by Emscripten

	- `{lib,utils}.ts`: internal tools

	- `{constants,globals}.ts`: top-level exported globals

	- `-deprecations.ts`: everything deprecated, all in one place

	- `classes/`: all the modular code

		- `{TypeBuilder,ExpressionRunner,Relooper}.ts`: Binaryen tools

		- `module/`: Module and related classes

		- `expression/`: Expression info classes, and source for WASM expression generation

	- `services/`: namespace-like, stateless classes

- `dist/` *(gitignored)*: output of **tsc**; this gets bundled and published to NPM for consumers

- `docs/`: documentation assets

- `../docs/binaryen.ts/` *(gitignored)*: output of **typedoc**; hosted online
