(module
  ;; an imported tag that isn't accessed doesn't stop us from optimizing
  (import "import" "tag" (tag $imported))
  (global $g (mut i32) (i32.const 0))
  (func $setg (export "setg")
    (drop (i32.const 1))
    (global.set $g
      (i32.add (i32.const 1) (i32.const 2))
    )
  )

  (func $keepalive (export "keepalive") (result i32)
    ;; Keep the global alive so we can see its value.
    (global.get $g)
  )
)
