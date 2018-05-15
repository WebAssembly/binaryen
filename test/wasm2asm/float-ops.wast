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

  ;; comparisons
  (func (export "f32.eq") (param $0 f32) (param $1 f32) (result i32)
    (f32.eq (get_local $0) (get_local $1)))

  (func (export "f32.ne") (param $0 f32) (param $1 f32) (result i32)
    (f32.ne (get_local $0) (get_local $1)))

  (func (export "f32.ge") (param $0 f32) (param $1 f32) (result i32)
    (f32.ge (get_local $0) (get_local $1)))

  (func (export "f32.gt") (param $0 f32) (param $1 f32) (result i32)
    (f32.gt (get_local $0) (get_local $1)))

  (func (export "f32.le") (param $0 f32) (param $1 f32) (result i32)
    (f32.le (get_local $0) (get_local $1)))

  (func (export "f32.lt") (param $0 f32) (param $1 f32) (result i32)
    (f32.lt (get_local $0) (get_local $1)))

  (func (export "f64.eq") (param $0 f64) (param $1 f64) (result i32)
    (f64.eq (get_local $0) (get_local $1)))

  (func (export "f64.ne") (param $0 f64) (param $1 f64) (result i32)
    (f64.ne (get_local $0) (get_local $1)))

  (func (export "f64.ge") (param $0 f64) (param $1 f64) (result i32)
    (f64.ge (get_local $0) (get_local $1)))

  (func (export "f64.gt") (param $0 f64) (param $1 f64) (result i32)
    (f64.gt (get_local $0) (get_local $1)))

  (func (export "f64.le") (param $0 f64) (param $1 f64) (result i32)
    (f64.le (get_local $0) (get_local $1)))

  (func (export "f64.lt") (param $0 f64) (param $1 f64) (result i32)
    (f64.lt (get_local $0) (get_local $1)))

  ;; min/max
  (func (export "f32.min") (param $0 f32) (param $1 f32) (result f32)
    (f32.min (get_local $0) (get_local $1)))

  (func (export "f32.max") (param $0 f32) (param $1 f32) (result f32)
    (f32.max (get_local $0) (get_local $1)))

  (func (export "f64.min") (param $0 f64) (param $1 f64) (result f64)
    (f64.min (get_local $0) (get_local $1)))

  (func (export "f64.max") (param $0 f64) (param $1 f64) (result f64)
    (f64.max (get_local $0) (get_local $1)))

  ;; promotion/demotion
  (func (export "f64.promote") (param $0 f32) (result f64)
    (f64.promote/f32 (get_local $0)))

  (func (export "f32.demote") (param $0 f64) (result f32)
    (f32.demote/f64 (get_local $0)))

  ;; floor/ceil
  (func (export "f32.floor") (param $0 f32) (result f32)
    (f32.floor (get_local $0)))

  (func (export "f32.ceil") (param $0 f32) (result f32)
    (f32.ceil (get_local $0)))

  (func (export "f64.floor") (param $0 f64) (result f64)
    (f64.floor (get_local $0)))

  (func (export "f64.ceil") (param $0 f64) (result f64)
    (f64.ceil (get_local $0)))

  ;; sqrt
  (func (export "f32.sqrt") (param $0 f32) (result f32)
    (f32.sqrt (get_local $0)))

  (func (export "f64.sqrt") (param $0 f64) (result f64)
    (f64.sqrt (get_local $0)))

  ;; copysign
 (func $copysign64 (param $0 f64) (param $1 f64) (result f64)
   (f64.copysign (get_local $0) (get_local $1)))
 (func $copysign32 (param $0 f32) (param $1 f32) (result f32)
   (f32.copysign (get_local $0) (get_local $1)))
)
