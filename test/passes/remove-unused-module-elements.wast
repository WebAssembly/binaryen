(module
  (memory 0)
  (start $start)
  (type $0 (func))
  (type $0-dupe (func))
  (type $1 (func (param i32)))
  (type $1-dupe (func (param i32)))
  (type $2 (func (param i32) (result i32)))
  (type $2-dupe (func (param i32) (result i32)))
  (type $2-thrupe (func (param i32) (result i32)))
  (export "memory" (memory $0))
  (export "exported" $exported)
  (export "other1" $other1)
  (export "other2" $other2)
  (table 1 1 anyfunc)
  (elem (i32.const 0) $called_indirect)
  (func $start (type $0)
    (call $called0)
  )
  (func $called0 (type $0)
    (call $called1)
  )
  (func $called1 (type $0)
    (nop)
  )
  (func $called_indirect (type $0)
    (nop)
  )
  (func $exported (type $0-dupe)
    (call $called2)
  )
  (func $called2 (type $0-dupe)
    (call $called2)
    (call $called3)
  )
  (func $called3 (type $0-dupe)
    (call $called4)
  )
  (func $called4 (type $0-dupe)
    (call $called3)
  )
  (func $remove0 (type $0-dupe)
    (call $remove1)
  )
  (func $remove1 (type $0-dupe)
    (nop)
  )
  (func $remove2 (type $0-dupe)
    (call $remove2)
  )
  (func $remove3 (type $0)
    (call $remove4)
  )
  (func $remove4 (type $0)
    (call $remove3)
  )
  (func $other1 (param i32) (type $1)
    (call_indirect (type $0) (i32.const 0))
    (call_indirect (type $0) (i32.const 0))
    (call_indirect (type $0-dupe) (i32.const 0))
    (call_indirect (type $0-dupe) (i32.const 0))
    (call_indirect (type $1) (i32.const 0) (i32.const 0))
    (call_indirect (type $1-dupe) (i32.const 0) (i32.const 0))
    (drop (call_indirect (type $2) (i32.const 0) (i32.const 0)))
    (drop (call_indirect (type $2-dupe) (i32.const 0) (i32.const 0)))
    (drop (call_indirect (type $2-thrupe) (i32.const 0) (i32.const 0)))
  )
  (func $other2 (param i32) (type $1-dupe)
    (unreachable)
  )
)
(module ;; remove the table and memory
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
)
(module ;; also when not imported
  (memory 256)
  (table 1 anyfunc)
)
(module ;; but not when exported
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 1 anyfunc))
  (export "mem" (memory 0))
  (export "tab" (table 0))
)
(module ;; and not when there are segments
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 1 anyfunc))
  (data (i32.const 1) "hello, world!")
  (elem (i32.const 0) $waka)
  (func $waka)
)
(module ;; and not when used
  (type $0 (func))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (export "user" $user)
  (func $user
    (drop (i32.load (i32.const 0)))
    (call_indirect (type $0) (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 (shared 23 256))
  (export "user" $user)
  (func $user
    (i32.store (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 (shared 23 256))
  (export "user" $user)
  (func $user (result i32)
    (i32.atomic.rmw.add (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 (shared 23 256))
  (export "user" $user)
  (func $user (result i32)
    (i32.atomic.rmw8_u.cmpxchg (i32.const 0) (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 (shared 23 256))
  (export "user" $user)
  (func $user
    (local $0 i32)
    (local $1 i64)
    (drop
     (i32.wait
      (get_local $0)
      (get_local $0)
      (get_local $1)
     )
    )
  )
)
(module ;; more use checks
  (memory $0 (shared 23 256))
  (export "user" $user)
  (func $user (result i32)
    (wake (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 23 256)
  (export "user" $user)
  (func $user (result i32)
    (memory.grow (i32.const 0))
  )
)
(module ;; more use checks
  (import "env" "memory" (memory $0 256))
  (export "user" $user)
  (func $user (result i32)
    (memory.grow (i32.const 0))
  )
)
(module ;; more use checks
  (memory $0 23 256)
  (export "user" $user)
  (func $user (result i32)
    (memory.size)
  )
)
(module
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 anyfunc))
  (import "env" "memoryBase" (global $memoryBase i32)) ;; used in init
  (import "env" "tableBase" (global $tableBase i32)) ;; used in init
  (data (get_global $memoryBase) "hello, world!")
  (elem (get_global $tableBase) $waka)
  (func $waka) ;; used in table
)
(module ;; one is exported, and one->two->int global, whose init->imported
  (import "env" "imported" (global $imported i32))
  (import "env" "forgetme" (global $forgetme i32))
  (import "env" "_puts" (func $_puts (param i32) (result i32)))
  (import "env" "forget_puts" (func $forget_puts (param i32) (result i32)))
  (global $int (mut i32) (get_global $imported))
  (global $set (mut i32) (i32.const 100))
  (global $forget_global (mut i32) (i32.const 500))
  (global $exp_glob i32 (i32.const 600))
  (export "one" (func $one))
  (export "three" (func $three))
  (export "exp_glob" (global $exp_glob))
  (start $starter)
  (func $one (result i32)
    (call $two)
  )
  (func $two (result i32)
    (get_global $int)
  )
  (func $three
    (call $four)
  )
  (func $four
    (set_global $set (i32.const 200))
    (drop (call $_puts (i32.const 300)))
  )
  (func $forget_implemented
    (nop)
  )
  (func $starter
    (nop)
  )
)
(module ;; empty start being removed
  (start $starter)
  (func $starter
    (nop)
  )
)
(module ;; non-empty start being kept
  (start $starter)
  (func $starter
    (drop (i32.const 0))
  )
)
(module ;; the function and the table can be removed
 (type $0 (func (param f64) (result f64)))
 (table 6 6 anyfunc)
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (f64.const 1)
   (f64.const 0)
  )
 )
)
(module ;; the function uses the table, but all are removeable
 (type $0 (func (param f64) (result f64)))
 (table 6 6 anyfunc)
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (call_indirect (type $0) (f64.const 1) (i32.const 0))
   (f64.const 0)
  )
 )
)
(module ;; the table is imported - we can't remove it
 (type $0 (func (param f64) (result f64)))
 (import "env" "table" (table 6 6 anyfunc))
 (elem (i32.const 0) $0)
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (f64.const 1)
   (f64.const 0)
  )
 )
)

