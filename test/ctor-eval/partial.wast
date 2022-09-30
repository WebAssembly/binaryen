(module
  (import "import" "import" (func $import))

  (memory 256 256)
  (data (i32.const 10) "_________________")

  (export "test1" $test1)

  ;; Use the function in an additional export. We should still get the same
  ;; results if we call this one, so it should point to identical contents as
  ;; earlier
  (export "keepalive" $test1)

  (func $test1
    ;; A safe store, should alter memory
    (i32.store8 (i32.const 12) (i32.const 115))

    ;; A call to an import, which prevents evalling.
    (call $import)

    ;; Another safe store, but the import call before us will stop our evalling.
    ;; As a result we will only partially eval this function, applying only
    ;; the first store.
    ;;
    ;; After optimization, the test1 export will point to a function that does
    ;; not have the first store anymore. It will contain just the call to the
    ;; import and then this second store.
    (i32.store8 (i32.const 13) (i32.const 114))
  )
)
