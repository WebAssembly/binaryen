;; Test that funcions exported with __em_js are correctly removed
;; once they strings they return are extracted.

;; RUN: wasm-emscripten-finalize %s -S | filecheck %s

;; Both functions should be stripped from the binary
;; CHECK-NOT:  (func

;;      CHECK:  "emJsFuncs": {
;; CHECK-NEXT:    "bar": "more JS string dara",
;; CHECK-NEXT:    "foo": "some JS string"
;; CHECK-NEXT:  },

(module
 (memory 1 1)
 (data (i32.const 1024) "some JS string\00")
 (data (i32.const 2048) "more JS string dara\00")
 (export "__em_js__foo" (func $__em_js__foo))
 (export "__em_js__bar" (func $bar))
 ;; Name matches export name
 (func $__em_js__foo (result i32)
  (i32.const 1024)
 )
 ;; Name does not match export name
 (func $bar (result i32)
  (i32.const 2048)
 )
)
