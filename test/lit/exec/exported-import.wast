;; RUN: wasm-opt %s --fuzz-exec-before -q -o /dev/null 2>&1 | filecheck %s

;; Execute an import that is immediately exported. We should not error here, but
;; no other output is expected (as the import does nothing and is ignored).

(module
  (import "spectest" "nothing" (func $import))
  (export "__wasm_call_ctors" (func $import))
)

;; Note this file does not use automatic updating as that only works for
;; defined functions at the moment, and this module has none of those.

;; CHECK: [fuzz-exec] calling __wasm_call_ctors
