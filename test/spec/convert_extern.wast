(module
 (func $shared-null (export "shared-null") (result (ref null (shared any)))
  ;; The shared null here should remain shared as we internalize it.
  (any.convert_extern
   (ref.null (shared noextern))
  )
 )
)

(assert_return (invoke "shared-null") (ref.null (shared any)))

