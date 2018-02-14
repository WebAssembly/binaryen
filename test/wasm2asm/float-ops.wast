(module
  (func $dummy)

  (func (export "f32.add") (param $0 f32) (param $1 f32) (result f32)
    (f32.add (get_local $0) (get_local $1)))

  (func (export "f32.sub") (param $0 f32) (param $1 f32) (result f32)
    (f32.sub (get_local $0) (get_local $1)))

  (func (export "f32.mul") (param $0 f32) (param $1 f32) (result f32)
    (f32.mul (get_local $0) (get_local $1)))

  (func (export "f32.div") (param $0 f32) (param $1 f32) (result f32)
    (f32.div (get_local $0) (get_local $1)))

  (func (export "f64.add") (param $0 f64) (param $1 f64) (result f64)
    (f64.add (get_local $0) (get_local $1)))

  (func (export "f64.sub") (param $0 f64) (param $1 f64) (result f64)
    (f64.sub (get_local $0) (get_local $1)))

  (func (export "f64.mul") (param $0 f64) (param $1 f64) (result f64)
    (f64.mul (get_local $0) (get_local $1)))

  (func (export "f64.div") (param $0 f64) (param $1 f64) (result f64)
    (f64.div (get_local $0) (get_local $1)))
)
