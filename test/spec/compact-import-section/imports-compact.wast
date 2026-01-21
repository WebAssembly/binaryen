;; Auxiliary module to import from

(module
  (func (export "func->11i") (result i32) (i32.const 11))
  (func (export "func->22f") (result f32) (f32.const 22))
  (global (export "global->1") i32 (i32.const 1))
  (global (export "global->20") i32 (i32.const 20))
  (global (export "global->300") i32 (i32.const 300))
  (global (export "global->4000") i32 (i32.const 4000))
)
(register "test")


;; Basic behavior

(module
  (import "test"
    (item "func->11i" (func (result i32)))
    (item "func->22f" (func (result f32)))
  )
  (import "test"
    (item "global->1")
    (item "global->20")
    (item "global->300")
    (item "global->4000")
    (global i32)
  )

  (global i32 (i32.const 50000))

  (func (export "sum1") (result i32)
    (local i32)

    call 0
    (i32.trunc_f32_s (call 1))
    i32.add
  )
  (func (export "sum2") (result i32)
    (local i32)

    global.get 0
    global.get 1
    global.get 2
    global.get 3
    i32.add
    i32.add
    i32.add
  )

  ;; Tests that indices were tracked correctly
  (func (export "sum3") (result i32)
    call 2 ;; sum1
    call 3 ;; sum2
    i32.add

    global.get 4
    i32.add
  )
)

(assert_return (invoke "sum1") (i32.const 33))
(assert_return (invoke "sum2") (i32.const 4321))
(assert_return (invoke "sum3") (i32.const 54354))

(module (import "test" (item "func->11i" (func (result i32)))))
(assert_unlinkable
  (module (import "test" (item "unknown" (func (result i32)))))
  "unknown import"
)
(assert_unlinkable
  (module (import "test" (item "func->11i" (func (result i32))) (item "unknown" (func (result i32)))))
  "unknown import"
)

(module (import "test" (item "func->11i") (func (result i32))))
(assert_unlinkable
  (module (import "test" (item "unknown") (func (result i32))))
  "unknown import"
)
(assert_unlinkable
  (module (import "test" (item "func->11i") (item "unknown") (func (result i32))))
  "unknown import"
)

(assert_unlinkable
  (module (import "test" (item "func->11i" (func))))
  "incompatible import type"
)
(assert_unlinkable
  (module (import "test" (item "func->11i" (func (result i32))) (item "func->22f" (func))))
  "incompatible import type"
)

(assert_unlinkable
  (module (import "test" (item "func->11i") (item "func->22f") (func (result i32))))
  "incompatible import type"
)


;; Identifiers

(module
  (import "test" "func->11i" (func $f11i (result i32)))
  (import "test"
    (item "global->1" (global $g1 i32))
    (item "global->20" (global $g20 i32))
  )
  ;; Shared-type form does not allow identifiers

  (func (export "sum") (result i32)
    call $f11i
    global.get $g1
    global.get $g20
    i32.add
    i32.add
  )
)

(assert_return (invoke "sum") (i32.const 32))

(assert_malformed
  (module quote "(import \"test\" (item \"foo\") (func $foo))")
  "identifier not allowed"
)
