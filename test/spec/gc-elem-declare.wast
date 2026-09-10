;; Binary spec test for declarative element segments with GC reftypes.
;; Before the fix, parsing this module failed with "invalid tag index".
;; See https://github.com/WebAssembly/binaryen/issues/8540

(module binary "\00asm\01\00\00\00\01\1b\01N\06^w\00P\00_\00^r\01P\00`\01~\00^}\01P\00^{\01\03\03\02\03\03\09\0f\03\07c\02\00\07c\03\01\d0\03\0b\07q\00\0a\07\02\02\00\0b\02\00\0b")
