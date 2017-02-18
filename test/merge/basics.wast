(module
  (type $ii (func (param i32 i32)))
  (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (import "env" "some-func" (func $some-func))
  (import "env" "some-collide" (func $some-collide))
  (data (get_global $memoryBase) "hello, A!\n")
  (func $only-a
    (drop (i32.const 100))
    (call $only-a)
    (call_import $some-func)
    (call_import $some-collide)
    (call_indirect $ii
      (i32.const 123)
      (i32.const 456)
      (i32.const 789)
    )
  )
  (func $willCollide
    (drop (i32.const 200))
    (call $willCollide)
  )
)

