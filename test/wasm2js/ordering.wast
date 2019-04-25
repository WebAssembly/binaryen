(module
 (type $0 (func (param i32) (result i32)))
 (import "env" "table" (table $timport$9 7 funcref))
 (elem (i32.const 1) $foo $bar $baz)
 (export "main" (func $main))
 (func $main
  (drop
   (call_indirect (type $0)
    (i32.const 1)
    (call $foo (i32.const 2))
   )
  )
  (drop
   (call_indirect (type $0)
    (call $foo (i32.const 3))
    (i32.const 4)
   )
  )
  (drop
   (call_indirect (type $0)
    (call $foo (i32.const 5))
    (call $bar (i32.const 6))
   )
  )
  (drop
   (call_indirect (type $0)
    (i32.const 7)
    (i32.const 8)
   )
  )
  (drop (call $baz
   (select
    (i32.const 9)
    (i32.const 10)
    (i32.const 11)
   )
  ))
  (drop (call $baz
   (select
    (call $foo (i32.const 12))
    (i32.const 13)
    (i32.const 14)
   )
  ))
  (drop (call $baz
   (select
    (i32.const 15)
    (call $foo (i32.const 16))
    (i32.const 17)
   )
  ))
  (drop (call $baz
   (select
    (i32.const 18)
    (i32.const 19)
    (call $foo (i32.const 20))
   )
  ))
  (drop (call $baz
   (select
    (call $foo (i32.const 21))
    (i32.const 22)
    (call $foo (i32.const 23))
   )
  ))
  (drop (call $baz
   (select
    (i32.const 24)
    (call $foo (i32.const 25))
    (call $foo (i32.const 26))
   )
  ))
  (drop (call $baz
   (select
    (call $foo (i32.const 27))
    (call $foo (i32.const 28))
    (i32.const 29)
   )
  ))
  (drop (call $baz
   (select
    (call $foo (i32.const 30))
    (call $foo (i32.const 31))
    (call $foo (i32.const 32))
   )
  ))
 )
 (func $foo (param i32) (result i32)
  (i32.const 1)
 )
 (func $bar (param i32) (result i32)
  (i32.const 2)
 )
 (func $baz (param i32) (result i32)
  (i32.const 3)
 )
)

