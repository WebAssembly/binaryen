;; TODO: Autogenerate these checks! The current script cannot handle `rec`.

;; RUN: wasm-opt %s -all --hybrid -S -o - | filecheck %s --check-prefix HYBRID
;; RUN: wasm-opt %s -all --hybrid --roundtrip -S -o - | filecheck %s --check-prefix HYBRID
;; RUN: wasm-opt %s -all --nominal -S -o - | filecheck %s --check-prefix NOMINAL

(module

;; HYBRID:      (rec
;; HYBRID-NEXT:  (type $super-struct (struct_subtype (field i32) data))
;; HYBRID-NEXT:  (type $sub-struct (struct_subtype (field i32) (field i64) $super-struct))
;; HYBRID-NEXT: )

;; HYBRID:      (rec
;; HYBRID-NEXT:   (type $super-array (array_subtype (ref $super-struct) data))
;; HYBRID-NEXT:   (type $sub-array (array_subtype (ref $sub-struct) $super-array))
;; HYBRID-NEXT: )

;; NOMINAL-NOT: rec

;; NOMINAL:      (type $super-struct (struct_subtype (field i32) data))
;; NOMINAL-NEXT: (type $sub-struct (struct_subtype (field i32) (field i64) $super-struct))

;; NOMINAL:      (type $super-array (array_subtype (ref $super-struct) data))
;; NOMINAL-NEXT: (type $sub-array (array_subtype (ref $sub-struct) $super-array))

  (rec
    (type $super-struct (struct i32))
    (type $sub-struct (struct_subtype i32 i64 $super-struct))
  )

  (rec
    (type $super-array (array (ref $super-struct)))
    (type $sub-array (array_subtype (ref $sub-struct) $super-array))
  )

  (func $make-super-struct (result (ref $super-struct))
    (call $make-sub-struct)
  )

  (func $make-sub-struct (result (ref $sub-struct))
    (unreachable)
  )

  (func $make-super-array (result (ref $super-array))
    (call $make-sub-array)
  )

  (func $make-sub-array (result (ref $sub-array))
    (unreachable)
  )
)
