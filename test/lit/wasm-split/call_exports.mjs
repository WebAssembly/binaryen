// Instantiates an instrumented module, calls the given exports, then collects
// its wasm-split profile and writes it to a given file.
//
// Usage:
//
//  node call_exports.mjs <module> <profile> <export>*

import * as fs from 'fs';

let wasm = process.argv[2];
let outFile = process.argv[3];

// Create the Wasm instance
let { _, instance } = await WebAssembly.instantiate(fs.readFileSync(wasm));

// Call the specified exports
for (let i = 4; i < process.argv.length; i++) {
  console.log('calling', process.argv[i]);
  instance.exports[process.argv[i]]();
}

// Create and read the profile
let profileSize = instance.exports['__write_profile'](0, 2**32 - 1);
let profileData = Buffer.from(instance.exports.memory.buffer, 0, profileSize);
fs.writeFileSync(outFile, profileData);
