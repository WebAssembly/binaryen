(module
  (type $i32_to_void (func (param i32)))
  (type $exnref_to_void (func (param exnref)))
  (type $void_to_void (func))

  (import "env" "maybe_suspend" (func $maybe_suspend (param i32)))
  (import "env" "log_caught_tag" (func $log_caught_tag (type $i32_to_void)))
  (import "env" "log_caught_exnref" (func $log_caught_exnref (type $exnref_to_void)))
  (import "env" "js_thrower" (func $js_thrower (type $void_to_void)))

  (tag $my_tag (param i32))

  (memory (export "memory") 10)

  (func $suspend_and_maybe_throw (param $p i32) (param $should_throw i32)
    (call $maybe_suspend (i32.const 999))
    (if (local.get $should_throw) (then (local.get $p) (throw $my_tag)))
  )

  (func (export "rethrow_for_js") (param $e exnref)
    local.get $e
    throw_ref
  )

  ;; Simple helper that just throws.
  (func $thrower (param $p i32)
    (throw $my_tag (local.get $p))
  )

  ;; Wasm Tagged Exceptions
  (func (export "test_wasm_exception") (param $p i32) (param $should_throw i32) (result i32)
    (block $catch_handler (result i32)
      (try_table
        (catch $my_tag 0)
        (call $suspend_and_maybe_throw (local.get $p) (local.get $should_throw))
        (return (i32.const -1))
      )
      (unreachable)
    )
    (call $log_caught_tag (i32.const 123))
    (return)
  )

  ;; Foreign JS Exceptions, loading/saving exnrefs
  (func (export "test_js_exception") (result i32)
    (local $ex exnref)
    (local.set $ex
      (block $catch_handler (result exnref)
        (try_table
          (catch_all_ref 0)
          (return (call $js_thrower (i32.const -1)))
        )
        unreachable
      )
    )

    (call $maybe_suspend (i32.const 555))
    (call $log_caught_exnref (local.get $ex))
    (return (i32.const -2))
  )

  ;; Suspend inside a catch handler
  (func (export "test_suspend_in_catch") (param $p i32) (result i32)
    (block $catch_handler (result i32)
      (try_table
        (catch $my_tag 0)
        (call $thrower (local.get $p))
        (unreachable)
      )
      (unreachable)
    )
    (call $maybe_suspend (i32.const 777))

    (i32.const 100)
    (return (i32.add))
  )
)