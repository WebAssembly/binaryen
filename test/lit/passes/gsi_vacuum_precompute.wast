;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-opt --nominal --gsi --vacuum --precompute -all -S -o - | filecheck %s

;; Test a common pattern in j2wasm where itables are differentiated by type, but
;; vtables are not. For example, the vtable might be "hashable" and provide a
;; method "getHash()" which all itables implement by an instance of that vtable.
;; Despite all those vtables having the same type, we can infer things because
;; those vtables are created as part of the immutable itables in global vars.
;; The specific optimizations used to achieve that are:
;;
;;  * --gsi : Infers that a reference to a particular itable type must be a
;;            global.get of the single itable defined using that type (since no
;;            other object of that type is ever created).
;;  * --vacuum : Cleans up some dropped stuff to enable the subsequent pass.
;;  * --precompute : Represents immutable globals in a way that we can start
;;                   from a global.get of an itable, get a vtable, and get a
;;                   field in the vtable, and we end up optimizing to produce
;;                   the final value in that vtable.

(module
 (type $itable1 (struct_subtype (field (ref $vtable)) data))
 (type $itable2 (struct_subtype (field (ref $vtable)) data))
 (type $vtable (struct_subtype (field funcref) data))

 ;; Two $vtable instances are created, in separate enclosing objects.

 (global $itable1 (ref $itable1) (struct.new $itable1
  (struct.new $vtable
   (ref.func $func1)
  )
 ))

 (global $itable2 (ref $itable2) (struct.new $itable2
  (struct.new $vtable
   (ref.func $func2)
  )
 ))

 (func $test-A (export "test-A") (param $ref (ref $itable1)) (result funcref)
  (struct.get $vtable 0    ;; this is a reference to $func1
   (struct.get $itable1 0  ;; this is the sub-object in the global $itable1
    (local.get $ref)       ;; this can be inferred to be the global $itable1
   )
  )
 )

 (func $test-B (export "test-B") (param $ref (ref $itable2)) (result funcref)
  (struct.get $vtable 0    ;; this is a reference to $func2
   (struct.get $itable2 0  ;; this is the sub-object in the global $itable2
    (local.get $ref)       ;; this can be inferred to be the global $itable2
   )
  )
 )

 (func $func1)

 (func $func2)
)

