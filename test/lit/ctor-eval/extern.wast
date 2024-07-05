;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-ctor-eval %s --ctors=test1,test2,test3 --kept-exports=test1,test2,test3 --quiet -all -S -o - | filecheck %s

(module
 ;; CHECK:      (type $array (array (mut i8)))
 (type $array (array (mut i8)))

 ;; CHECK:      (type $struct (struct (field externref)))
 (type $struct (struct (field externref)))

 (export "test1" (func $test1))
 (export "test2" (func $test2))
 (export "test3" (func $test3))

 (func $test1 (result externref)
  ;; This will remain almost the same, even though we eval it, since the
  ;; serialization of an externalized i31 is what is written here. But the add
  ;; will be evalled out.
  (extern.convert_any
   (ref.i31
    (i32.add
     (i32.const 41)
     (i32.const 1)
    )
   )
  )
 )

 (func $test2 (result externref)
  ;; This will be evalled into an externalization of a global.get.
  (extern.convert_any
   (array.new_fixed $array 3
    (i32.const 1)
    (i32.const 2)
    (i32.const 3)
   )
  )
 )

 (func $test3 (result anyref)
  ;; This will add a global that contains an externalization operation.
  (struct.new $struct
   (extern.convert_any
    (ref.i31
     (i32.const 1)
    )
   )
  )
 )
)

;; CHECK:      (type $2 (func (result externref)))

;; CHECK:      (type $3 (func (result anyref)))

;; CHECK:      (global $ctor-eval$global (ref $array) (array.new_fixed $array 3
;; CHECK-NEXT:  (i32.const 1)
;; CHECK-NEXT:  (i32.const 2)
;; CHECK-NEXT:  (i32.const 3)
;; CHECK-NEXT: ))

;; CHECK:      (global $ctor-eval$global_1 (ref $struct) (struct.new $struct
;; CHECK-NEXT:  (extern.convert_any
;; CHECK-NEXT:   (ref.i31
;; CHECK-NEXT:    (i32.const 1)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: ))

;; CHECK:      (export "test1" (func $test1_3))

;; CHECK:      (export "test2" (func $test2_4))

;; CHECK:      (export "test3" (func $test3_5))

;; CHECK:      (func $test1_3 (type $2) (result externref)
;; CHECK-NEXT:  (extern.convert_any
;; CHECK-NEXT:   (ref.i31
;; CHECK-NEXT:    (i32.const 42)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $test2_4 (type $2) (result externref)
;; CHECK-NEXT:  (extern.convert_any
;; CHECK-NEXT:   (global.get $ctor-eval$global)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $test3_5 (type $3) (result anyref)
;; CHECK-NEXT:  (global.get $ctor-eval$global_1)
;; CHECK-NEXT: )
