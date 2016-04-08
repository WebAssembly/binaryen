(module
  (memory 256 256)
  (import $waka "env" "waka")
  (import $waka_int "env" "waka_int" (result i32))
  (func $b0-yes (param $i1 i32)
    (local $x i32)
    (local $y i32)
    (local $a i32)
    (local $b i32)
    (set_local $x (i32.const 5))
    (get_local $x)
    (block
      (set_local $x (i32.const 7))
      (get_local $x)
    )
    (set_local $x (i32.const 11))
    (get_local $x)
    (set_local $x (i32.const 9))
    (get_local $y)
    (block
      (set_local $x (i32.const 8))
      (get_local $y)
    )
    (set_local $x (i32.const 11))
    (get_local $y)
    (set_local $x (i32.const 17))
    (get_local $x)
    (get_local $x)
    (get_local $x)
    (get_local $x)
    (get_local $x)
    (get_local $x)
    (block
      (set_local $a (i32.const 1))
      (set_local $b (i32.const 2))
      (get_local $a)
      (get_local $b)
      (set_local $a (i32.const 3))
      (set_local $b (i32.const 4))
      (set_local $a (i32.const 5))
      (set_local $b (i32.const 6))
      (get_local $b)
      (get_local $a)
      (set_local $a (i32.const 7))
      (set_local $b (i32.const 8))
      (set_local $a (i32.const 9))
      (set_local $b (i32.const 10))
      (call_import $waka)
      (get_local $a)
      (get_local $b)
      (set_local $a (i32.const 11))
      (set_local $b (i32.const 12))
      (set_local $a (i32.const 13))
      (set_local $b (i32.const 14))
      (i32.load
        (i32.const 24)
      )
      (get_local $a)
      (get_local $b)
      (set_local $a (i32.const 15))
      (set_local $b (i32.const 16))
      (set_local $a (i32.const 17))
      (set_local $b (i32.const 18))
      (i32.store
        (i32.const 48)
        (i32.const 96)
      )
      (get_local $a)
      (get_local $b)
    )
    (block
      (set_local $a (call_import $waka_int))
      (get_local $a) ;; yes
      (call_import $waka)

      (set_local $a (call_import $waka_int))
      (call_import $waka)
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (call_import $waka_int))
      (i32.load (i32.const 1))
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (call_import $waka_int))
      (i32.store (i32.const 1) (i32.const 2))
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (i32.load (i32.const 100)))
      (get_local $a) ;; yes
      (call_import $waka)

      (set_local $a (i32.load (i32.const 101)))
      (i32.load (i32.const 1))
      (get_local $a) ;; yes
      (call_import $waka)

      (set_local $a (i32.load (i32.const 102)))
      (call_import $waka)
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (i32.load (i32.const 103)))
      (i32.store (i32.const 1) (i32.const 2))
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (i32.store (i32.const 104) (i32.const 105)))
      (get_local $a) ;; yes
      (call_import $waka)

      (set_local $a (i32.store (i32.const 106) (i32.const 107)))
      (call_import $waka)
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (i32.store (i32.const 108) (i32.const 109)))
      (i32.load (i32.const 1))
      (get_local $a) ;; no
      (call_import $waka)

      (set_local $a (i32.store (i32.const 110) (i32.const 111)))
      (i32.store (i32.const 1) (i32.const 2))
      (get_local $a) ;; no
      (call_import $waka)
    )
    (block $out-of-block
      (set_local $a (i32.const 1337))
      (block $b
        (block $c
          (br $b)
        )
        (set_local $a (i32.const 9876))
      )
      (get_local $a)
    )
    (block $loopey
      (set_local $a (i32.const 1337))
      (loop
        (get_local $a)
        (set_local $a (i32.const 9876))
      )
      (get_local $a)
    )
  )
)

