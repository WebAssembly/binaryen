(module
  (import "first" "forward" (func $first.forward))

  (import "first" "reverse" (func $first.reverse))

  (import "second" "forward" (func $second.forward))

  (import "second" "reverse" (func $second.reverse))

  (func $forward (export "forward")
    (drop
      (i32.const 3)
    )
    (call $first.forward)
  )

  (func $reverse (export "reverse")
    (drop
      (i32.const -3)
    )
    (call $second.reverse)
  )
)

