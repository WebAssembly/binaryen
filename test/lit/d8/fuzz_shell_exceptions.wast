;; Test throwing from JS by calling the throw import.

(module
  (import "fuzzing-support" "throw" (func $throw (param i32)))

  ;; Verify that fuzz_shell.js provides these imports for the wasm.
  (import "fuzzing-support" "wasmtag" (tag $imported-wasm-tag (param i32)))
  (import "fuzzing-support" "jstag" (tag $imported-js-tag (param externref)))

  (func $throwing-js (export "throwing-js")
    ;; Telling JS to throw with arg 0 leads to a JS exception thrown.
    (call $throw
      (i32.const 0)
    )
  )

  (func $throwing-tag (export "throwing-tag")
    ;; A non-0 arg leads to a wasm Tag being thrown.
    (call $throw
      (i32.const 42)
    )
  )
)

;; Build to a binary wasm.
;;
;; RUN: wasm-opt %s -o %t.wasm -q -all

;; Run in node.
;;
;; RUN: v8 %S/../../../scripts/fuzz_shell.js -- %t.wasm | filecheck %s
;;
;; CHECK: [fuzz-exec] calling throwing-js
;; CHECK: exception thrown: Error: js exception
;; CHECK: [fuzz-exec] calling throwing-tag
;; CHECK: exception thrown: [object WebAssembly.Exception]



