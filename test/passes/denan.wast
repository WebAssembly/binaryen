(module
  (global $global$1 (mut f32) (f32.const nan))
  (global $global$2 (mut f32) (f32.const 12.34))
  (func $foo32 (param $x f32) (result f32)
    (call $foo32 (local.get $x))
  )
  (func $foo64 (param $x f64) (result f64)
    (call $foo64 (local.get $x))
  )
  (func $various (param $x i32) (param $y f32) (param $z i64) (param $w f64)
  )
  (func $ignore-local.get (param $f f32) (param $d f64)
    (drop (local.get $f))
    (drop (local.get $d))
    (local.set $f (local.get $f))
    (local.set $d (local.get $d))
    (drop (local.get $f))
    (drop (local.get $d))
    (drop (f32.abs (local.get $f)))
    (drop (f64.abs (local.get $d)))
    (local.set $f (f32.abs (local.get $f)))
    (local.set $d (f64.abs (local.get $d)))
    (drop (local.get $f))
    (drop (local.get $d))
  )
  (func $tees (param $x f32) (result f32)
    (local.tee $x
      (local.tee $x
        (local.tee $x
          (local.tee $x
            (local.get $x))))))
  (func $select (param $x f32) (result f32)
    (select
      (local.get $x)
      (local.get $x)
      (i32.const 1)))
)
;; existing names should not be a problem
(module
  (func $deNan32)
  (func $deNan64)
  (func $foo32 (param $x f32) (result f32)
    (call $foo32 (local.get $x))
  )
  (func $foo64 (param $x f64) (result f64)
    (call $foo64 (local.get $x))
  )

)
