;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec -q -o /dev/null 2>&1 | filecheck %s

(module
  (type $array16 (array (mut i16)))

  (func "new_wtf16_array"
    (drop
      (string.new_wtf16_array
        (array.init_static $array16
          (i32.const 104) ;; h
          (i32.const 101) ;; e
          (i32.const 108) ;; l
          (i32.const 108) ;; l
          (i32.const 111) ;; o
        )
        (i32.const 0)
        (i32.const 4)
      )
    )
  )

  (func "const"
    (drop
      (string.const "hello")
    )
  )
)
