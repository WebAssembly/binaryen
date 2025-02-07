;; RUN: not wasm-opt -all --precompute %s -S -o - 2>&1 | grep -o unimplemented | filecheck %s

;; CHECK: unimplemented
(module
 (type $function (func))
 (type $cont (cont $function))
 (type $function_2 (func (param i32)))
 (type $cont_2 (cont $function_2))
 (tag $tag)
 (type $function_3 (func (param (ref $cont))))
 (type $cont_3 (cont $function_3))

 (func $cont_new (param $f (ref $function)) (result (ref $cont))
  (cont.new $cont (local.get $f))
 )

 (func $cont_bind (param $c (ref $cont_2)) (result (ref $cont))
  (cont.bind $cont_2 $cont
   (i32.const 0)
   (local.get $c)
  )
 )

 (func $suspend
  (suspend $tag)
 )

 (func $resume (param $c (ref $cont)) (result (ref $cont))
  (block $handle_effect (result (ref $cont))
   (resume $cont (on $tag $handle_effect)
    (local.get $c)
   )
   (local.get $c)
  )
 )

 (func $resume_throw (param $c (ref $cont)) (result (ref $cont))
  (block $handle_effect (result (ref $cont))
   (resume_throw $cont $tag (on $tag $handle_effect)
    (local.get $c)
   )
   (local.get $c)
  )
 )

 (func $switch (param $c (ref $cont_3))
  (switch $cont_3 $tag
   (local.get $c)
  )
 )
)
