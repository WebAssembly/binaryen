This document describes changes between tagged Binaryen versions.

To browse or download snapshots of old tagged versions, visit
https://github.com/WebAssembly/binaryen/releases.

Not all changes are documented here. In particular, new features, user-oriented
fixes, options, command-line parameters, usage changes, deprecations,
significant internal modifications and optimizations etc. generally deserve a
mention. To examine the full set of changes between versions, visit the link to
full changeset diff at the end of each section.

Current Trunk
-------------

### BREAKING CHANGES

- `BinaryenSetFunctionTable` in the C API no longer accepts an array of functions, instead it accepts an array of function names, `const char** funcNames`. Previously, you could not include imported functions because they are of type `BinaryenImportRef` instead of `BinaryenFunctionRef`. [#1650](https://github.com/WebAssembly/binaryen/pull/1650)
