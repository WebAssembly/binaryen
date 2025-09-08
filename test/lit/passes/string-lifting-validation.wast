;; The imported js string method here has an error in its signature, which
;; should be reported.

(module
  (type $array16 (array (mut i16)))

  (import "wasm:js-string" "fromCharCodeArray" (func $fromCharCodeArray (param (ref null $array16) i32 i64) (result (ref extern))))

  (func $string.new.gc (param $ref (ref $array16))
    (drop
      (call $fromCharCodeArray
        (local.get $ref)
        (i32.const 7)
        (i64.const 8) ;; this i64 should be an i32 in the signature
      )
    )
  )
)

;; RUN: not wasm-opt %s --string-lifting -all 2>&1 | filecheck %s
;; CHECK: Fatal: StringLifting: bad type for fromCharCodeArray: (type $func.0 (func (param (ref null $array.0) i32 i64) (result (ref extern))))

