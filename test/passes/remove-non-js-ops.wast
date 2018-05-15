(module
 (func $copysign64 (param $0 f64) (param $1 f64) (result f64)
   (f64.copysign (get_local $0) (get_local $1)))
 (func $copysign32 (param $0 f32) (param $1 f32) (result f32)
   (f32.copysign (get_local $0) (get_local $1)))
)

