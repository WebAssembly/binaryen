;; RUN: foreach %s %t wasm-opt --nominal --signature-refining --gto --roundtrip -all -S -o - | filecheck %s

(module
 ;; The type $A should not be emitted at all (see below).
 ;; CHECK-NOT: (type $A
 (type $A (struct_subtype (field (mut (ref null $A))) data))

 ;; CHECK:      (type $ref|none|_=>_none (func_subtype (param (ref none)) func))

 ;; CHECK:      (type $funcref_i32_=>_none (func_subtype (param funcref i32) func))

 ;; CHECK:      (func $struct.get (type $ref|none|_=>_none) (param $0 (ref none))
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

 ;; CHECK:      (func $caller (type $funcref_i32_=>_none) (param $0 funcref) (param $1 i32)
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
