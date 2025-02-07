;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt -all --precompute %s -S -o - | filecheck %s

(module
 ;; CHECK:      (type $function (func))
 (type $function (func))
 ;; CHECK:      (type $cont (cont $function))
 (type $cont (cont $function))
 ;; CHECK:      (type $function_2 (func (param i32)))
 (type $function_2 (func (param i32)))
 ;; CHECK:      (type $cont_2 (cont $function_2))
 (type $cont_2 (cont $function_2))
 ;; CHECK:      (type $function_3 (func (param (ref $cont))))

 ;; CHECK:      (type $cont_3 (cont $function_3))

 ;; CHECK:      (tag $tag (type $function))
 (tag $tag)
 (type $function_3 (func (param (ref $cont))))
 (type $cont_3 (cont $function_3))

 ;; CHECK:      (func $cont_new (type $7) (param $f (ref $function)) (result (ref $cont))
 ;; CHECK-NEXT:  (cont.new $cont
 ;; CHECK-NEXT:   (local.get $f)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $cont_new (param $f (ref $function)) (result (ref $cont))
  (cont.new $cont (local.get $f))
 )

 ;; CHECK:      (func $cont_bind (type $8) (param $c (ref $cont_2)) (result (ref $cont))
 ;; CHECK-NEXT:  (cont.bind $cont_2 $cont
 ;; CHECK-NEXT:   (i32.const 0)
 ;; CHECK-NEXT:   (local.get $c)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $cont_bind (param $c (ref $cont_2)) (result (ref $cont))
  (cont.bind $cont_2 $cont
   (i32.const 0)
   (local.get $c)
  )
 )

 ;; CHECK:      (func $suspend (type $function)
 ;; CHECK-NEXT:  (suspend $tag)
 ;; CHECK-NEXT: )
 (func $suspend
  (suspend $tag)
 )

 ;; CHECK:      (func $resume (type $2) (param $c (ref $cont)) (result (ref $cont))
 ;; CHECK-NEXT:  (block $handle_effect (result (ref $cont))
 ;; CHECK-NEXT:   (resume $cont (on $tag $handle_effect)
 ;; CHECK-NEXT:    (local.get $c)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.get $c)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $resume (param $c (ref $cont)) (result (ref $cont))
  (block $handle_effect (result (ref $cont))
   (resume $cont (on $tag $handle_effect)
    (local.get $c)
   )
   (local.get $c)
  )
 )

 ;; CHECK:      (func $resume_throw (type $2) (param $c (ref $cont)) (result (ref $cont))
 ;; CHECK-NEXT:  (block $handle_effect (result (ref $cont))
 ;; CHECK-NEXT:   (resume_throw $cont $tag (on $tag $handle_effect)
 ;; CHECK-NEXT:    (local.get $c)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.get $c)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $resume_throw (param $c (ref $cont)) (result (ref $cont))
  (block $handle_effect (result (ref $cont))
   (resume_throw $cont $tag (on $tag $handle_effect)
    (local.get $c)
   )
   (local.get $c)
  )
 )

 ;; CHECK:      (func $switch (type $9) (param $c (ref $cont_3))
 ;; CHECK-NEXT:  (switch $cont_3 $tag
 ;; CHECK-NEXT:   (local.get $c)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $switch (param $c (ref $cont_3))
  (switch $cont_3 $tag
   (local.get $c)
  )
 )
)
