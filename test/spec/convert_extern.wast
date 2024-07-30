(module
 (func $shared-null (export "shared-null") (result (ref null (shared any)))
  ;; The shared null here should remain shared as we internalize it.
  (any.convert_extern
   (ref.null (shared noextern))
  )
 )

 (func $shared-null-rev (export "shared-null-rev") (result (ref null (shared extern)))
  ;; As before, but the reverse conversion.
  (extern.convert_any
   (ref.null (shared any))
  )
 )
)

(assert_return (invoke "shared-null") (ref.null (shared any)))
(assert_return (invoke "shared-null-rev") (ref.null (shared extern)))

