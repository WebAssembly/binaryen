;; This file checks no custom section added by --string-lowering-magic-imports if there
;; are is only valid string constants.

(module
  (func $consts
    (drop
      (string.const "foo")
    )
  )
)

;; The custom section should not exist with magic imports.
;;
;; RUN: wasm-opt %s --string-lowering-magic-imports -all -S -o - \
;; RUN:     | filecheck %s 
;;
;; Same behavior when using magic imports with asserts enabled.
;;
;; RUN: wasm-opt %s --string-lowering-magic-imports-assert -all -S -o - \
;; RUN:     | filecheck %s
;;
;; CHECK-NOT: custom section
