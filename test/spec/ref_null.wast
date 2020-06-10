(module
  (func (export "externref") (result externref) (ref.null))
  (func (export "funcref") (result funcref) (ref.null))
  (func (export "nullref") (result nullref) (ref.null))

  (global externref (ref.null))
  (global funcref (ref.null))
  (global nullref (ref.null))
)

(assert_return (invoke "externref") (ref.null))
(assert_return (invoke "funcref") (ref.null))
(assert_return (invoke "nullref") (ref.null))
