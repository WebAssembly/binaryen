(module
  (memory 100 100)
  (func $basics
    (local $x i32)
    (local $y i32)
    (drop
      (i32.add (i32.const 1) (i32.const 2))
    )
    (drop
      (i32.add (i32.const 1) (i32.const 2))
    )
    (if (i32.const 0) (nop))
    (drop ;; we can't do this yet, non-linear
      (i32.add (i32.const 1) (i32.const 2))
    )
    (drop
      (i32.add (get_local $x) (get_local $y))
    )
    (drop
      (i32.add (get_local $x) (get_local $y))
    )
    (drop
      (i32.add (get_local $x) (get_local $y))
    )
    (call $basics) ;; side effects, but no matter for our locals
    (drop
      (i32.add (get_local $x) (get_local $y))
    )
    (set_local $x (i32.const 100))
    (drop ;; x was changed!
      (i32.add (get_local $x) (get_local $y))
    )
  )
  (func $recursive1
    (local $x i32)
    (local $y i32)
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 2)
        (i32.const 3)
      )
    )
  )
  (func $recursive2
    (local $x i32)
    (local $y i32)
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 2)
        (i32.const 3)
      )
    )
    (drop
      (i32.add
        (i32.const 1)
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
  )
  (func $self
    (local $x i32)
    (local $y i32)
    (drop
      (i32.add
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
        (i32.add
          (i32.const 2)
          (i32.const 3)
        )
      )
    )
    (drop
      (i32.add
        (i32.const 2)
        (i32.const 3)
      )
    )
  )
  (func $loads
    (drop
      (i32.load (i32.const 10))
    )
    (drop
      (i32.load (i32.const 10)) ;; implicit traps, sad
    )
  )
  (func $8 (param $var$0 i32) (result i32)
    (local $var$1 i32)
    (local $var$2 i32)
    (local $var$3 i32)
    (block $label$0 (result i32)
      (i32.store
        (tee_local $var$2
          (i32.add
            (get_local $var$1)
            (i32.const 4)
          )
        )
        (i32.and
          (i32.load
            (get_local $var$2)
          )
          (i32.xor
            (tee_local $var$2
              (i32.const 74)
            )
            (i32.const -1)
          )
        )
      )
      (i32.store
        (tee_local $var$1
          (i32.add
            (get_local $var$1)
            (i32.const 4)
          )
        )
        (i32.or
          (i32.load
            (get_local $var$1)
          )
          (i32.and
            (get_local $var$2)
            (i32.const 8)
          )
        )
      )
      (i32.const 0)
    )
  )
  (func $loop1 (param $x i32) (param $y i32) (result i32)
    (set_local $x (get_local $y))
    (set_local $y (get_local $x))
    (set_local $x (get_local $y))
    (set_local $y (get_local $x))
    (return (get_local $y))
  )
  (func $loop2 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (set_local $x (get_local $y))
    (set_local $y (get_local $z))
    (set_local $z (get_local $x))
    (set_local $x (get_local $y))
    (set_local $y (get_local $z))
    (set_local $z (get_local $x))
    (return (get_local $x))
  )
  (func $loop3 (param $x i32) (param $y i32) (param $z i32) (result i32)
    (set_local $x (get_local $y))
    (set_local $y (get_local $z))
    (set_local $z (get_local $y))
    (set_local $y (get_local $z))
    (set_local $z (get_local $y))
    (return (get_local $y))
  )
  (func $handle-removing (param $var$0 f64) (param $var$1 f64) (param $var$2 i32) (result f32)
   (set_local $var$2
    (select
     (tee_local $var$2
      (i32.const 32767)
     )
     (tee_local $var$2
      (i32.const 1024)
     )
     (i32.const -2147483648)
    )
   )
   (f32.const 1)
  )
)
;; a testcase that fails if we don't handle equivalent local canonicalization properly
(module
 (type $0 (func))
 (type $1 (func (param i32 f64) (result i32)))
 (type $2 (func (param i64 f32 i32)))
 (global $global$0 (mut i32) (i32.const 10))
 (table 23 23 anyfunc)
 (export "func_1_invoker" (func $1))
 (export "func_6" (func $2))
 (func $0 (; 0 ;) (type $2) (param $var$0 i64) (param $var$1 f32) (param $var$2 i32)
  (if
   (block $label$1 (result i32)
    (drop
     (br_if $label$1
      (i32.const 0)
      (br_if $label$1
       (i32.const 128)
       (i32.const 0)
      )
     )
    )
    (i32.const -14051)
   )
   (set_global $global$0
    (i32.const 0)
   )
  )
 )
 (func $1 (; 1 ;) (type $0)
  (call $0
   (i64.const 1125899906842624)
   (f32.const -nan:0x7fc91a)
   (i32.const -46)
  )
 )
 (func $2 (; 2 ;) (type $1) (param $var$0 i32) (param $var$1 f64) (result i32)
  (if
   (get_global $global$0)
   (unreachable)
  )
  (i32.const 0)
 )
)
(module
 (import "env" "out" (func $out (param i32)))
 (func $each-pass-must-clear (param $var$0 i32)
  (call $out
   (i32.eqz
    (get_local $var$0)
   )
  )
  (call $out
   (i32.eqz
    (get_local $var$0)
   )
  )
 )
)

