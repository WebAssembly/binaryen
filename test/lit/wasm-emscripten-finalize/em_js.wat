;; Test that funcions exported with __em_js are correctly removed
;; once they strings they return are extracted.

;; RUN: wasm-emscripten-finalize %s -S | filecheck %s

;; All functions should be stripped from the binary, regardless
;; of internal name
;; CHECK-NOT: (global

;; The data section that contains only em_js strings should
;; be stripped (shrunk to zero size):
;; CHECK: (data (i32.const 1024) "some JS string data\00xxx")
;; CHECK: (data (i32.const 512) "")
;; CHECK: (data (i32.const 2048) "more JS string data\00yyy")

;;      CHECK:  "emJsFuncs": {
;; CHECK-NEXT:    "bar": "more JS string data",
;; CHECK-NEXT:    "baz": "Only em_js strings here",
;; CHECK-NEXT:    "foo": "some JS string data"
;; CHECK-NEXT:  },

(module
 (memory 1 1)
 (data (i32.const 1024) "some JS string data\00xxx")
 (data (i32.const 512) "Only em_js strings here\00")
 (data (i32.const 2048) "more JS string data\00yyy")
 (export "__em_js__foo" (global $__em_js__foo))
 (export "__em_js__bar" (global $bar))
 (export "__em_js__baz" (global $baz))
 ;; Name matches export name
 (global $__em_js__foo i32 (i32.const 1024))
 ;; Name does not match export name
 (global $bar i32 (i32.const 2048))
 (global $baz i32 (i32.const 512))
)
