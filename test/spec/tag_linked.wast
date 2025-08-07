;; Test that we can properly use a tag from an imported module. The export name
;; and the internal names all differ, to make sure we properly identify the tag.

(module
  (tag $suspend)

  (export "suspendey" (tag $suspend))
  (export "suspender" (func $suspender))

  (func $suspender
    (suspend $suspend)
  )
)

(register "first")

(module
  (type $func (func))
  (type $cont (cont $func))

  (tag $imported-suspend (import "first" "suspendey"))

  (import "first" "suspender" (func $suspender))

  (tag $suspend) ;; name overlap

  (func (export "run") (result i32)
    (drop
      (block $internal (result (ref $cont))
        (block $imported (result (ref $cont))
          (resume $cont (on $imported-suspend $imported) (on $suspend $internal)
            (cont.new $cont (ref.func $suspender))
          )
          (unreachable)
        )
        (return (i32.const 42))
      )
      (return (i32.const 1337))
    )
    (unreachable)
  )
)

(assert_return (invoke "run") (i32.const 42))

