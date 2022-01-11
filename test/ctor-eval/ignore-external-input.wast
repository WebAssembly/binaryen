(module
  (import "wasi_snapshot_preview1" "environ_sizes_get" (func $wasi_environ_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "environ_get" (func $wasi_environ_get (param i32 i32) (result i32)))

  (import "wasi_snapshot_preview1" "args_sizes_get" (func $wasi_args_sizes_get (param i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "args_get" (func $wasi_args_get (param i32 i32) (result i32)))

  (import "wasi_snapshot_preview1" "something_else" (func $wasi_something_else (result i32)))

  (memory 256 256)
  (data (i32.const 0) "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") ;; the final 4 'a's will remain

  (func "test1"
    ;; This is ok to call: when ignoring external input we assume there is no
    ;; environment to read.
    (i32.store
      (i32.const 0) ;; the result (0) will be written to address 0
      (call $wasi_environ_sizes_get
        (i32.const 4) ;; count (0) will be written to address 4
        (i32.const 0)
      )
    )
    (i32.store
      (i32.const 8) ;; the result (0) will be written to address 8
      (call $wasi_environ_get
        (i32.const 0)
        (i32.const 0)
      )
    )
  )

  (func "test2"
    ;; This is also ok to call: when ignoring external input we assume there are
    ;; not args passed to main.
    (i32.store
      (i32.const 12) ;; the result (0) will be written to address 12
      (call $wasi_args_sizes_get
        (i32.const 16) ;; argc (0) will be written to address 16
        (i32.const 0)
      )
    )
    (i32.store
      (i32.const 20) ;; the result (0) will be written to address 20
      (call $wasi_args_get
        (i32.const 0)
        (i32.const 0)
      )
    )
  )

  (func "test2b" (param $x i32)
    ;; This is also ok to call: when ignoring external input we assume the
    ;; args are zeros.
    (i32.store
      (i32.const 24) ;; the result (0) will be written to address 24
      (local.get $x)
    )
  )

  (func "test3"
    ;; This is *not* ok to call, and we will *not* reach the final store after
    ;; this call. This function will not be evalled and will remain in the
    ;; output.
    (drop
      (call $wasi_something_else)
    )
    (i32.store
      (i32.const 28)
      (i32.const 100)
    )
  )
)
