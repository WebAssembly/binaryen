;; The imported js string method here has the correct signature, but the wrong
;; type. We should error.

(module
  (type $array16 (array (mut i16)))

  ;; The type should be final!
  (type $bad (sub (func (param (ref null $array16) i32 i32) (result (ref extern)))))

  (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (type $bad)))

  (func $string.new.gc (param $ref (ref $array16))
    (drop
      (call $fromCharCodeArray
        (local.get $ref)
        (i32.const 7)
        (i32.const 8)
      )
    )
  )
)

;; RUN: not wasm-opt %s --string-lifting -all 2>&1 | filecheck %s
;; CHECK: Fatal: StringLifting: bad type for fromCharCodeArray: (type $func.0 (sub (func (param (ref null $array.0) i32 i32) (result (ref extern)))))
