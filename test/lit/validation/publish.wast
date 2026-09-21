;; RUN: not wasm-opt --enable-reference-types --enable-gc %s 2>&1 | filecheck %s --check-prefix=NO-SHARED
;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s --check-prefix=INVALID-TYPE

;; Tests feature and type validations for publish.
(module
  (type $struct (struct (field i32)))

  ;; NO-SHARED: publish requires shared-everything [--enable-shared-everything]
  (func $no-feature (param $x (ref $struct)) (result (ref $struct))
    (publish
      (local.get $x)
    )
  )

  ;; INVALID-TYPE: publish's argument should be a reference type
  (func $bad-arg (param $x i32) (result i32)
    (publish
      (local.get $x)
    )
  )
)
