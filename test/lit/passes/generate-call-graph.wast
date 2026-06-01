;; RUN: foreach %s %t wasm-opt --print-call-graph | filecheck %s
;; RUN: foreach %s %t wasm-opt --print-call-graph --closed-world | filecheck %s --check-prefix CLOSED

(module
  (type $sig (func))
  (table 1 1 funcref)
  (elem (i32.const 0) $D)

  (func $A
    (call $B)
    (call_indirect (type $sig) (i32.const 0))
  )
  (func $B (call $C))
  (func $C)
  (func $D (type $sig))
)
;; CHECK:      digraph CallGraph {
;; CHECK-NEXT:   "A" [kind="function"];
;; CHECK-NEXT:   "B" [kind="function"];
;; CHECK-NEXT:   "C" [kind="function"];
;; CHECK-NEXT:   "D" [kind="function"];
;; CHECK-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CHECK-NEXT:   "B" -> "C" [style="solid", color="black", kind="direct"];
;; CHECK-NEXT: }

;; CLOSED:      digraph CallGraph {
;; CLOSED-NEXT:   "(type $func.0 (func))" [kind="type"];
;; CLOSED-NEXT:   "A" [kind="function"];
;; CLOSED-NEXT:   "B" [kind="function"];
;; CLOSED-NEXT:   "C" [kind="function"];
;; CLOSED-NEXT:   "D" [kind="function"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "A" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "B" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "C" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "(type $func.0 (func))" -> "D" [style="dashed", color="green", kind="implementation"];
;; CLOSED-NEXT:   "A" -> "(type $func.0 (func))" [style="dotted", color="black", kind="indirect"];
;; CLOSED-NEXT:   "A" -> "B" [style="solid", color="black", kind="direct"];
;; CLOSED-NEXT:   "B" -> "C" [style="solid", color="black", kind="direct"];
;; CLOSED-NEXT: }
