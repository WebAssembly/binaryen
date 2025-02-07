;; RUN: not wasm-opt -all %s -S -o - 2>&1 | filecheck %s

;; CHECK: {{.*}}wasm-validator error{{.*}}function body type must match,{{.*}}

(module
 (type $function (func (param i64)))
 (type $cont (cont $function))
 (type $function_2 (func (param i32 (ref $cont))))
 (type $cont_2 (cont $function_2))
 (tag $tag)

 (func $switch (param $c (ref $cont_2)) (result i64)
  (switch $cont_2 $tag
   (i32.const 0)
   (local.get $c)
  )
 )
)
