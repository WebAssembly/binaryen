(module
  (func (export "externref") (result externref) (ref.null extern))
  (func (export "funcref") (result funcref) (ref.null func))
  (func (export "anyref") (result anyref) (ref.null any))
  (func (export "eqref") (result eqref) (ref.null eq))

  (global externref (ref.null extern))
  (global funcref (ref.null func))
  (global anyref (ref.null any))
  (global eqref (ref.null eq))
)

(assert_return (invoke "externref") (ref.null extern))
(assert_return (invoke "funcref") (ref.null func))
(assert_return (invoke "anyref") (ref.null any))
(assert_return (invoke "eqref") (ref.null eq))
