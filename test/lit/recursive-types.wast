;; Test a trivial recursive type works properly

;; RUN: wasm-opt %s -all -S -o - | filecheck %s

;; TODO: Store function signatures as the originally parsed HeapTypes rather
;; than directly as Signatures so that self-referential function signatures are
;; not emitted twice. This happens because collectHeapTypes has to reconstruct a
;; HeapType from each function's signature, but self-referential HeapTypes
;; aren't canonicalized when they are parsed.

;; CHECK:      (module
;; CHECK-NEXT:   (type $t (func (param (ref null $t)) (result (ref null $t))))
;; CHECK-NEXT:   (type $s (func (param (ref null $s)) (result (ref null $s))))
;; CHECK-NEXT:   (type $ref?|$t|_=>_ref?|$t| (func (param (ref null $t)) (result (ref null $t))))
;; CHECK-NEXT:   (type $ref?|$s|_=>_ref?|$s| (func (param (ref null $s)) (result (ref null $s))))
;; CHECK-NEXT:   (func $foo (param $0 (ref null $t)) (result (ref null $t))
;; CHECK-NEXT:     (unreachable)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (func $bar (param $0 (ref null $s)) (result (ref null $s))
;; CHECK-NEXT:     (unreachable)
;; CHECK-NEXT:   )

(module
  (type $t (func (param (ref null $t)) (result (ref null $t))))
  (type $s (func (param (ref null $s)) (result (ref null $s))))
  (func $foo (type $t)
    (unreachable)
  )
  (func $bar (type $s)
    (unreachable)
  )
)
