;; RUN: not wasm-opt -all -O3 %s -S -o - 2>&1 | filecheck %s

;; Fairly comprehensive test case

;; CHECK: unimplemented
(module
 (type $function_1 (func (param (ref eq) (ref eq)) (result (ref eq))))
 (type $closure (sub (struct (field (ref $function_1)))))
 (type $function_2 (func (param (ref eq) (ref eq) (ref eq)) (result (ref eq))))
 (type $closure_2 (struct (field (ref $function_2))))
 (type $handlers (struct (field $value (ref $closure)) (field $exn (ref $closure)) (field $effect (ref $closure_2))))
 (type $cont (cont $function_1))
 (type $fiber (struct (field $handlers (ref $handlers)) (field $cont (ref $cont))))
 (tag $exception (param (ref eq)))
 (tag $effect (param (ref eq)) (result (ref eq) (ref eq)))

 (func $resume (export "resume") (param $fiber (ref $fiber)) (param $f (ref $closure)) (param $v (ref eq)) (result (ref eq))
  (local $g (ref $closure_2))
  (local $res (ref eq))
  (local $exn (ref eq))
  (local $resume_res (tuple (ref eq) (ref $cont)))
  (local.set $exn
   (block $handle_exception (result (ref eq))
    (local.set $resume_res
     (block $handle_effect (result (ref eq) (ref $cont))
      (local.set $res
       (try_table (result (ref eq)) (catch $exception $handle_exception)
        (resume $cont (on $effect $handle_effect)
         (local.get $f)
         (local.get $v)
         (struct.get $fiber $cont
          (local.get $fiber)
         )
        )
       )
      )
      (return_call_ref $function_1
       (local.get $res)
       (local.tee $f
        (struct.get $handlers $value
         (struct.get $fiber $handlers
          (local.get $fiber)
         )
        )
       )
       (struct.get $closure 0
        (local.get $f)
       )
      )
     )
    )
    (return_call_ref $function_2
     (tuple.extract 2 0
      (local.get $resume_res)
     )
     (struct.new $fiber
      (struct.get $fiber $handlers
       (local.get $fiber)
      )
      (tuple.extract 2 1
       (local.get $resume_res)
      )
     )
     (local.tee $g
      (struct.get $handlers $effect
       (struct.get $fiber $handlers
        (local.get $fiber)
       )
      )
     )
     (struct.get $closure_2 0
      (local.get $g)
     )
    )
   )
  )
  (return_call_ref $function_1
   (local.get $exn)
   (local.tee $f
    (struct.get $handlers $exn
     (struct.get $fiber $handlers
      (local.get $fiber)
     )
    )
   )
   (struct.get $closure 0
    (local.get $f)
   )
  )
 )
)
