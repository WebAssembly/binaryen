;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s -all --nominal -S -o - | filecheck %s --check-prefix NOMINAL
;; RUN: wasm-opt %s -all --nominal --roundtrip -S -o - | filecheck %s --check-prefix NOMINAL
;; RUN: wasm-opt %s -all --hybrid -S -o - | filecheck %s --check-prefix NOMINAL
;; RUN: wasm-opt %s -all --hybrid --roundtrip -S -o - | filecheck %s --check-prefix NOMINAL
;; RUN: wasm-opt %s -all --structural -S -o - | filecheck %s --check-prefix EQUIREC
;; RUN: wasm-opt %s -all --structural --roundtrip -S -o - | filecheck %s --check-prefix EQUIREC

;; Note that --hybrid and --nominal have the same output, so they share the NOMINAL prefix.

(module

  ;; NOMINAL:      (type $super-struct (struct (field i32)))
  ;; EQUIREC:      (type $super-struct (struct (field i32)))
  (type $super-struct (struct i32))

  ;; NOMINAL:      (type $sub-struct (struct_subtype (field i32) (field i64) $super-struct))
  ;; EQUIREC:      (type $sub-struct (struct (field i32) (field i64)))
  (type $sub-struct (struct_subtype i32 i64 $super-struct))

  ;; NOMINAL:      (type $super-array (array (ref $super-struct)))
  ;; EQUIREC:      (type $super-array (array (ref $super-struct)))
  (type $super-array (array (ref $super-struct)))

  ;; NOMINAL:      (type $sub-array (array_subtype (ref $sub-struct) $super-array))
  ;; EQUIREC:      (type $sub-array (array (ref $sub-struct)))
  (type $sub-array (array_subtype (ref $sub-struct) $super-array))

  ;; TODO: signature types as well, once functions store their HeapTypes.

  ;; NOMINAL:      (func $make-super-struct (type $none_=>_ref|$super-struct|) (result (ref $super-struct))
  ;; NOMINAL-NEXT:  (call $make-sub-struct)
  ;; NOMINAL-NEXT: )
  ;; EQUIREC:      (func $make-super-struct (result (ref $super-struct))
  ;; EQUIREC-NEXT:  (call $make-sub-struct)
  ;; EQUIREC-NEXT: )
  (func $make-super-struct (result (ref $super-struct))
    (call $make-sub-struct)
  )

  ;; NOMINAL:      (func $make-sub-struct (type $none_=>_ref|$sub-struct|) (result (ref $sub-struct))
  ;; NOMINAL-NEXT:  (unreachable)
  ;; NOMINAL-NEXT: )
  ;; EQUIREC:      (func $make-sub-struct (result (ref $sub-struct))
  ;; EQUIREC-NEXT:  (unreachable)
  ;; EQUIREC-NEXT: )
  (func $make-sub-struct (result (ref $sub-struct))
    (unreachable)
  )

  ;; NOMINAL:      (func $make-super-array (type $none_=>_ref|$super-array|) (result (ref $super-array))
  ;; NOMINAL-NEXT:  (call $make-sub-array)
  ;; NOMINAL-NEXT: )
  ;; EQUIREC:      (func $make-super-array (result (ref $super-array))
  ;; EQUIREC-NEXT:  (call $make-sub-array)
  ;; EQUIREC-NEXT: )
  (func $make-super-array (result (ref $super-array))
    (call $make-sub-array)
  )

  ;; NOMINAL:      (func $make-sub-array (type $none_=>_ref|$sub-array|) (result (ref $sub-array))
  ;; NOMINAL-NEXT:  (unreachable)
  ;; NOMINAL-NEXT: )
  ;; EQUIREC:      (func $make-sub-array (result (ref $sub-array))
  ;; EQUIREC-NEXT:  (unreachable)
  ;; EQUIREC-NEXT: )
  (func $make-sub-array (result (ref $sub-array))
    (unreachable)
  )
)
