(module
  (import "wasi_snapshot_preview1" "environ_sizes_get" (func $wasi_environ_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "args_sizes_get" (func $wasi_args_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "something_else" (func $wasi_something_else (result i32)))

  (memory 256 256)
  (data (i32.const 10) "aaaaaaaaaaaaaaaaaaa")

  (func "test1"
    ;; This is ok to call: when ignoring external input we assume there is no
    ;; environment to read.
    (drop
      (call $wasi_environ_sizes_get
        (i32.const 0)
        (i32.const 0)
      )
    )
    ;; Do a write to prove we executed.
    (i32.store8
      (i32.const 0)
      (i32.const 100)
    )
  )

  (func "test2"
    ;; This is also ok to call: when ignoring external input we assume there are
    ;; not args passed to main.
    ;; Do a write to prove we executed, and to show the result, which should be
    ;; 0.
    (i32.store8
      (i32.const 4) ;; the result is written to address 4
      (call $wasi_args_sizes_get
        (i32.const 8) ;; argc will be written to address 8
        (i32.const 12)
      )
    )
  )

  (func "test3"
    ;; This is *not* ok to call, and we will not reach the final store.
    (drop
      (call $wasi_something_else)
    )
    (i32.store8
      (i32.const 16)
      (i32.const 100)
    )
  )
)
