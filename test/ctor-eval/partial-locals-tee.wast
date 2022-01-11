(module
  (import "import" "import" (func $import (param i32 i32)))

  (memory 256 256)
  (data (i32.const 10) "_________________")

  (export "test1" $test1)

  (func $test1
    (local $temp i32)

    ;; Increment $temp from 0 to 1, which we can eval.
    (local.set $temp
      (i32.add
        (local.get $temp)
        (i32.const 1)
      )
    )

    ;; A safe store that will be evalled and alter memory.
    (i32.store8 (i32.const 12) (i32.const 115))

    ;; A call to an import, which prevents evalling. We will stop here. The
    ;; 'tee' instruction should *not* have any effect, that is, we should not
    ;; partially eval this line in the block - we should eval none of it.
    ;; TODO: We should support such partial line evalling, with more careful
    ;;       management of locals.
    (call $import
      (local.get $temp) ;; The value sent here should be '1'.
      (local.tee $temp
        (i32.const 50)
      )
    )

    ;; A safe store that we never reach
    (i32.store8 (i32.const 13) (i32.const 115))
  )
)
