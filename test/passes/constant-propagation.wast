(module
  (memory 16777216 16777216)
  (export "add" $add)
  (func $add (param $x i32) (param $y i32) (result i32)

    (set_local $x (i32.const 1))
    (set_local $y (i32.const 2))
    (if_else
      (i32.const 0)
      (set_local $y (i32.const 3))
      (get_local $y) ;; (i32.const 2)
    )
    (i32.add
      (get_local $x) ;; (i32.const 1)
      (get_local $y) ;; Unchanged, can be either (i32.const 2) or (i32.const 3)
    )

    (set_local $x (i32.const 3))
    (if
      (get_local $x) ;; (i32.const 3)
      (block $b0
        (get_local $x) ;; (i32.const 3)
        (set_local $x (i32.const 4))
        (get_local $x) ;; (i32.const 4)
      )
    )
    (get_local $x) ;; Unchanged
    (if
      (set_local $x (i32.const 5))
      (get_local $x) ;; (i32.const 5)
    )
    (get_local $x) ;; (i32.const 5)

    (set_local $x (i32.const 1))
    (block $a
      (br_if (nop) $a)
      (set_local $x (i32.const 2))
      (br_if (nop) $a)
    )
    (get_local $x) ;; Unchanged, could be either 1 or 2.

    (set_local $x (i32.const 1))
    (block $a
      (br_if (nop) $a)
      (set_local $x (i32.const 1))
      (br_if (nop) $a)
    )
    (get_local $x) ;; (i32.const 1), since it's 1 along all paths.

    (loop $foo $bar
      (get_local $x) ;; (get_local $x)
      (br_if (i32.const 0) $bar)
      (set_local $x (i32.const 6))
      (get_local $x) ;; (i32.const 6)
      (br $foo)
    )

    (set_local $x (i32.const 1))
    (loop $foo $bar
      (get_local $x) ;; (i32.const 1)
      (set_local $x (i32.const 2))
      (br $foo)
      (set_local $x (i32.const 1))
      (br_if (nop) $bar)
      (set_local $x (i32.const 1))
      (br_if (nop) $bar)
    )
    (get_local $x) ;; (i32.const 1), since it's 1 along all paths.

    (set_local $x (i32.const 1))
    (tableswitch $foo (i64.const 0)
      (table (case $0) (case $1) (case $2) (case $3) (case $4)
             (case $5) (case $6) (case $7)) (case $default)
      (case $0 (set_local $x (i32.const 2)) (get_local $x) (br $foo))
      (case $1 (get_local $x)) ;; fallthrough
      (case $2 (get_local $x) (set_local $x (i32.const 3))) ;; fallthrough
      (case $3 (get_local $x)) ;; fallthrough
      (case $4 (get_local $x) (br $foo)) ;; break
      (case $default (get_local $x) (br $foo)) ;; break
    )
  )
)