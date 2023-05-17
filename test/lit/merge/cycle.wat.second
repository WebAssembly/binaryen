(module
  (import "first" "forward" (func $first.forward))

  (import "first" "reverse" (func $first.reverse))

  (import "third" "forward" (func $third.forward))

  (import "third" "reverse" (func $third.reverse))

  (func $forward (export "forward")
    (drop
      (i32.const 2)
    )
    (call $third.forward)
  )

  (func $reverse (export "reverse")
    (drop
      (i32.const -2)
    )
    (call $first.reverse)
  )
)

