;; Some instructions are shared-polymorphic and work with shared or unshared
;; references.
(module
  (func (drop (ref.eq (ref.null (shared none)) (ref.null (shared none)))))

  (func (param (ref null (shared i31))) (drop (i31.get_s (local.get 0))))
  (func (param (ref null (shared i31))) (drop (i31.get_u (local.get 0))))

  (func (param (ref null (shared array))) (drop (array.len (local.get 0))))

  (func (param (ref null (shared extern))) (result (ref null (shared any)))
    (any.convert_extern (local.get 0))
  )
  (func (param (ref (shared extern))) (result (ref (shared any)))
    (any.convert_extern (local.get 0))
  )
  (func (param (ref null (shared any))) (result (ref null (shared extern)))
    (extern.convert_any (local.get 0))
  )
  (func (param (ref (shared any))) (result (ref (shared extern)))
    (extern.convert_any (local.get 0))
  )
)
