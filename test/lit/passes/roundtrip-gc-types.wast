;; RUN: wasm-opt %s -all --roundtrip -S -o - | filecheck %s

;; Regression test for an issue in which roundtripping failed to reproduce the
;; original types because type canonicalization was incorrect when the canonical
;; types already existed in the store.

;; CHECK:      (module
;; CHECK-NEXT:  (type $A (struct (field (ref $C))))
;; CHECK-NEXT:  (type $C (struct (field (mut (ref $B)))))
;; CHECK-NEXT:  (type $B (func (param (ref $A)) (result (ref $B))))
;; CHECK-NEXT:  (type $D (struct (field (ref $C)) (field (ref $A))))
;; CHECK-NEXT:  (global $g0 (rtt 0 $A) (rtt.canon $A))
;; CHECK-NEXT:  (global $g1 (rtt 1 $D) (rtt.sub $D
;; CHECK-NEXT:   (global.get $g0)
;; CHECK-NEXT:  ))
;; CHECK-NEXT: )

(module
 (type $A (struct (field (ref $C))))
 (type $B (func (param (ref $A)) (result (ref $B))))
 (type $C (struct (field (mut (ref $B)))))
 (type $D (struct (field (ref $C)) (field (ref $A))))
 (global $g0 (rtt 0 $A) (rtt.canon $A))
 (global $g1 (rtt 1 $D) (rtt.sub $D
  (global.get $g0)
 ))
)
