
;; RUN: wasm-opt %s -all --fuzz-exec-before --fuzz-exec-second=%s.second -q -o /dev/null 2>&1 | filecheck %s

;; The second module import a function of type $C as type $A, then casts to $A,
;; $B, $C. All those casts should succeed.

(module
 (rec
  (type $A (sub (func)))
  (type $B (sub $A (func)))
  (type $C (sub final $B (func)))
 )

 (func $C (export "func") (type $C)
 )
)

;; CHECK:      [fuzz-exec] calling func
;; CHECK-NEXT: [fuzz-exec] running second module
;; CHECK-NEXT: [fuzz-exec] calling cast-A
;; CHECK-NEXT: [fuzz-exec] calling cast-B
;; CHECK-NEXT: [fuzz-exec] calling cast-C

