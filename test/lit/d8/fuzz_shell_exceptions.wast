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

  (func $throwing-jstag-null (export "throwing-jstag-null")
    ;; Throwing JSTag leads to the JS side receiving the externref as a JS
    ;; value. A null must be handled properly while doing so, without error, and
    ;; be logged as a null.
    (throw $imported-js-tag
      (ref.null noextern)
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
;; CHECK: [fuzz-exec] calling throwing-jstag-null
;; CHECK: exception thrown: null



