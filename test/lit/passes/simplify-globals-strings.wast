;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; We do not "inline" strings from globals, as that might cause more
;; allocations to happen. TODO if VMs optimize that, remove this

;; RUN: foreach %s %t wasm-opt --simplify-globals -all -S -o - | filecheck %s

;; Also test with -O3 --gufa to see that no other pass does this kind of thing,
;; as extra coverage.

;; RUN: foreach %s %t wasm-opt -O3 --gufa         -all -S -o - | filecheck %s --check-prefix=O3GUF

(module
  ;; CHECK:      (type $0 (func (result anyref)))

  ;; CHECK:      (global $string stringref (string.const "one"))
  ;; O3GUF:      (type $0 (func (result anyref)))

  ;; O3GUF:      (global $string (ref string) (string.const "one"))
  (global $string stringref (string.const "one"))

  ;; CHECK:      (global $string-mut (mut stringref) (string.const "two"))
  ;; O3GUF:      (global $string-mut (mut (ref string)) (string.const "two"))
  (global $string-mut (mut stringref) (string.const "two"))

  ;; CHECK:      (export "global" (func $global))
  ;; O3GUF:      (export "global" (func $global))
  (export "global" (func $global))

  ;; CHECK:      (export "written" (func $written))
  ;; O3GUF:      (export "written" (func $written))
  (export "written" (func $written))

  ;; CHECK:      (func $global (type $0) (result anyref)
  ;; CHECK-NEXT:  (global.get $string)
  ;; CHECK-NEXT: )
  ;; O3GUF:      (func $global (type $0) (result anyref)
  ;; O3GUF-NEXT:  (global.get $string)
  ;; O3GUF-NEXT: )
  (func $global (result anyref)
    ;; This should not turn into "one".
    (global.get $string)
  )

  ;; CHECK:      (func $written (type $0) (result anyref)
  ;; CHECK-NEXT:  (global.set $string-mut
  ;; CHECK-NEXT:   (string.const "three")
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (global.get $string-mut)
  ;; CHECK-NEXT: )
  ;; O3GUF:      (func $written (type $0) (result anyref)
  ;; O3GUF-NEXT:  (global.set $string-mut
  ;; O3GUF-NEXT:   (string.const "three")
  ;; O3GUF-NEXT:  )
  ;; O3GUF-NEXT:  (global.get $string-mut)
  ;; O3GUF-NEXT: )
  (func $written (result anyref)
    (global.set $string-mut
      (string.const "three")
    )
    ;; This should not turn into "three".
    (global.get $string-mut)
  )
)
