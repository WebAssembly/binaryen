;; RUN: foreach %s %t wasm-opt -all --print-call-graph | filecheck %s
;; RUN: foreach %s %t wasm-opt -all --print-call-graph --closed-world | filecheck %s --check-prefix CLOSED

(module
  (type $indirect-type (func (param i32)))

  (table 1 1 funcref)
  (elem $indirect-1 (i32.const 0))

  (func $indirect-1 (type $indirect-type) (param i32)
  )

  (func $indirect-2 (type $indirect-type) (param i32)
  )

  (func $A (param $ref (ref $indirect-type))
    (call_ref $indirect-type (i32.const 42) (local.get $ref))
    (call $B (local.get $ref))
  )

  (func $B (param $ref (ref $indirect-type))
    (call_indirect (type $indirect-type) (i32.const 0) (i32.const 0))
  )
)

;; CHECK:       digraph CallGraph {
;; CHECK-NEXT:   "A" [kind="function"];
;; CHECK-NEXT:   "B" [kind="function"];
;; CHECK-NEXT:   "indirect-1" [kind="function"];
;; CHECK-NEXT:   "indirect-2" [kind="function"];
;; CHECK-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CHECK-NEXT:  }

;; CLOSED:       digraph CallGraph {
;; CLOSED-NEXT:   "(type $func.0 (func (param (ref $func.1))))" [kind="type"];
;; CLOSED-NEXT:   "(type $func.0 (func (param i32)))" [kind="type"];
;; CLOSED-NEXT:   "A" [kind="function"];
;; CLOSED-NEXT:   "B" [kind="function"];
;; CLOSED-NEXT:   "indirect-1" [kind="function"];
;; CLOSED-NEXT:   "indirect-2" [kind="function"];
;; CLOSED-NEXT:   "(type $func.0 (func (param (ref $func.1))))" -> "A" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func (param (ref $func.1))))" -> "B" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func (param i32)))" -> "indirect-1" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func (param i32)))" -> "indirect-2" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "A" -> "(type $func.0 (func (param i32)))" [style="dotted", color="black", kind="indirect"];
;; CLOSED-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CLOSED-NEXT:   "B" -> "(type $func.0 (func (param i32)))" [style="dotted", color="black", kind="indirect"];
;; CLOSED-NEXT: }

;; Test cycles
(module
  (type $indirect-type (func (param i32)))
  (table 1 1 funcref)

  (func $A
    (call $B)
  )
  (func $B
    (call $A)
  )

  (func $A-indirect (type $indirect-type) (param $x i32)
    (call_indirect (type $indirect-type) (local.get $x) (i32.const 0))
  )
  (elem $A-indirect (i32.const 0))
)

;; CHECK:       digraph CallGraph {
;; CHECK-NEXT:   "A" [kind="function"];
;; CHECK-NEXT:   "A-indirect" [kind="function"];
;; CHECK-NEXT:   "B" [kind="function"];
;; CHECK-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CHECK-NEXT:   "B" -> "A" [style="solid", color="black", kind="direct"];
;; CHECK-NEXT:  }

;; CLOSED:       digraph CallGraph {
;; CLOSED-NEXT:   "(type $func.0 (func (param i32)))" [kind="type"];
;; CLOSED-NEXT:   "(type $func.0 (func))" [kind="type"];
;; CLOSED-NEXT:   "A" [kind="function"];
;; CLOSED-NEXT:   "A-indirect" [kind="function"];
;; CLOSED-NEXT:   "B" [kind="function"];
;; CLOSED-NEXT:   "(type $func.0 (func (param i32)))" -> "A-indirect" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "A" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "B" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CLOSED-NEXT:   "A-indirect" -> "(type $func.0 (func (param i32)))" [style="dotted", color="black", kind="indirect"];
;; CLOSED-NEXT:   "B" -> "A" [style="solid", color="black", kind="direct"];
;; CLOSED-NEXT:  }
