;; RUN: wasm-opt %s -all --closed-world --preserve-type-order \
;; RUN:     --signature-refining --gto --remove-unused-types --roundtrip -S -o - | filecheck %s

;; Check that type $A is not included in the final binary after the signature
;; refining optimization and an additional --remove-unused-types pass.

(module
 ;; The type $A should not be emitted at all (see below).
 ;; CHECK-NOT: (type $A
 (type $A (struct (field (mut (ref null $A)))))

 ;; CHECK:      (type $0 (func (param (ref none))))

 ;; CHECK:      (type $1 (func (param funcref i32)))

 ;; CHECK:      (func $struct.get (type $0) (param $0 (ref none))
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (local.get $0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $struct.get (param $0 (ref $A))
  ;; This function is always called with a null, so the parameter type will be
  ;; refined to that. After doing so, the struct.get will be reading from a
  ;; null type, and we should avoid erroring on that in --gto which scans all
  ;; the heap types and updates them. Likewise, we should not error during
  ;; roundtrip which also scans heap types.
  (drop
   (struct.get $A 0
    (local.get $0)
   )
  )
 )

 ;; CHECK:      (func $caller (type $1) (param $0 funcref) (param $1 i32)
 ;; CHECK-NEXT:  (call $struct.get
 ;; CHECK-NEXT:   (ref.as_non_null
 ;; CHECK-NEXT:    (ref.null none)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $caller (param $0 funcref) (param $1 i32)
  (call $struct.get
   (ref.as_non_null
    (ref.null none)
   )
  )
 )
)
