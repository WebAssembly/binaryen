(module
 (type $func (func))
 (type $cont (cont $func))

 (tag $tag (type $func))

 (export "run_invoker" (func $main))

 (func $main
  ;; A continuation is created, it suspends, and we handle that. There is
  ;; nothing to optimize or change here.
  (drop
   (block $block (result (ref $cont))
    (resume $cont (on $tag $block)
     (cont.new $cont
      (ref.func $cont)
     )
    )
    (return)
   )
  )
 )

 (func $cont
  (suspend $tag)
 )
)

