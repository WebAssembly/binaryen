/* this file is not part of the build. Its purpose only to enable local compilation of the binaryen.ts file.
This is done by running: tsc --target ES2020 --module ES2022 --declaration --declarationMap binaryen.ts
Compilation of a target creates the real binary_raw.js file in the build dir */
var Binaryen_raw = {};
export default Binaryen_raw;