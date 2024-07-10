;; Some instructions are shared-polymorphic and work with shared or unshared
;; references.
(module
  (func (drop (ref.eq (ref.null (shared none)) (ref.null (shared none)))))
  (func (drop (ref.eq (ref.null (shared none)) (ref.null none))))
  (func (drop (ref.eq (ref.null none) (ref.null (shared none)))))

  (func (param (ref null (shared i31))) (drop (i31.get_s (local.get 0))))
  (func (param (ref null (shared i31))) (drop (i31.get_u (local.get 0))))

  (func (param (ref null (shared array))) (drop (array.len (local.get 0))))
)
