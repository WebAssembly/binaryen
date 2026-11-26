;; Test that casts without GC is a validation error.

;; RUN: not wasm-opt %s --enable-reference-types --enable-strings 2>&1 | filecheck %s

;; CHECK: [wasm-validator error in function cast-func] unexpected false: ref.cast requires gc [--enable-gc]
;; CHECK: [wasm-validator error in function cast-nullfunc] unexpected false: ref.cast requires gc [--enable-gc]
;; CHECK: [wasm-validator error in function cast-extern] unexpected false: ref.cast requires gc [--enable-gc]
;; CHECK-NOT: ref.cast requires gc

(module
  (func $cast-func (param $x funcref) (result funcref)
    (ref.cast funcref
      (local.get $x)
    )
  )

  (func $cast-nullfunc (param $x funcref) (result nullfuncref)
    (ref.cast nullfuncref
      (local.get $x)
    )
  )

  (func $cast-extern (param $x externref) (result (ref extern))
    (ref.cast (ref extern)
      (local.get $x)
    )
  )

  ;; GC is disabled; nullexternref == externref
  (func $cast-nullexternref (param $x externref) (result nullexternref)
    (ref.cast nullexternref
      (local.get $x)
    )
  )
)
