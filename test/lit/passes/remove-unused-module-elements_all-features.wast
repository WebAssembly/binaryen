;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements --all-features -S -o - | filecheck %s

(module
  (memory 0)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32)))

  ;; CHECK:      (type $2 (func (param i32) (result i32)))

  ;; CHECK:      (memory $0 0)

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (elem $0 (i32.const 0) $called_indirect)

  ;; CHECK:      (export "memory" (memory $0))

  ;; CHECK:      (export "exported" (func $exported))

  ;; CHECK:      (export "other1" (func $other1))

  ;; CHECK:      (export "other2" (func $other2))

  ;; CHECK:      (start $start)
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
  (table 1 1 funcref)
  (elem (i32.const 0) $called_indirect)
  ;; CHECK:      (func $start (type $0)
  ;; CHECK-NEXT:  (call $called0)
  ;; CHECK-NEXT: )
  (func $start (type $0)
    (call $called0)
  )
  ;; CHECK:      (func $called0 (type $0)
  ;; CHECK-NEXT:  (call $called1)
  ;; CHECK-NEXT: )
  (func $called0 (type $0)
    (call $called1)
  )
  ;; CHECK:      (func $called1 (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $called1 (type $0)
    (nop)
  )
  ;; CHECK:      (func $called_indirect (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $called_indirect (type $0)
    (nop)
  )
  ;; CHECK:      (func $exported (type $0)
  ;; CHECK-NEXT:  (call $called2)
  ;; CHECK-NEXT: )
  (func $exported (type $0-dupe)
    (call $called2)
  )
  ;; CHECK:      (func $called2 (type $0)
  ;; CHECK-NEXT:  (call $called2)
  ;; CHECK-NEXT:  (call $called3)
  ;; CHECK-NEXT: )
  (func $called2 (type $0-dupe)
    (call $called2)
    (call $called3)
  )
  ;; CHECK:      (func $called3 (type $0)
  ;; CHECK-NEXT:  (call $called4)
  ;; CHECK-NEXT: )
  (func $called3 (type $0-dupe)
    (call $called4)
  )
  ;; CHECK:      (func $called4 (type $0)
  ;; CHECK-NEXT:  (call $called3)
  ;; CHECK-NEXT: )
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
  ;; CHECK:      (func $other1 (type $1) (param $0 i32)
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $1)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $1)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $other1 (type $1) (param i32)
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
  ;; CHECK:      (func $other2 (type $1) (param $0 i32)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $other2 (type $1-dupe) (param i32)
    (unreachable)
  )
)
(module ;; remove the table and memory
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
)
(module ;; remove all tables and the memory
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  (import "env" "table2" (table $1 1 2 funcref))
  (elem (table $1) (offset (i32.const 0)) func)
  (elem (table $1) (offset (i32.const 1)) func)
)
(module ;; remove the first table and memory, but not the second one
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "table2" (table $1 1 1 funcref))
  (import "env" "table2" (table $1 1 1 funcref))
  (elem (table $1) (offset (i32.const 0)) func)
  (elem (table $1) (offset (i32.const 0)) func $f)
  ;; CHECK:      (elem $1 (i32.const 0) $f)

  ;; CHECK:      (func $f (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $f)
)
(module ;; also when not imported
  (memory 256)
  (table 1 funcref)
)
(module ;; also with multiple tables
  (memory 256)
  (table $0 1 funcref)
  (table $1 1 funcref)
  (elem (table $1) (i32.const 0) func)
)
(module ;; but not when exported
  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 1 funcref))
  (export "mem" (memory 0))
  (export "tab" (table 0))
)
;; CHECK:      (import "env" "table" (table $timport$0 1 funcref))

;; CHECK:      (export "mem" (memory $0))

;; CHECK:      (export "tab" (table $timport$0))
(module ;; and not when there are segments
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 1 funcref))
  (data (i32.const 1) "hello, world!")
  (elem (i32.const 0) $waka)
  ;; CHECK:      (import "env" "table" (table $timport$0 1 funcref))

  ;; CHECK:      (data $0 (i32.const 1) "hello, world!")

  ;; CHECK:      (elem $0 (i32.const 0) $waka)

  ;; CHECK:      (func $waka (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $waka)
)
(module ;; and not when used
  ;; CHECK:      (type $0 (func))
  (type $0 (func))
  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  (export "user" $user)
  ;; CHECK:      (import "env" "table" (table $timport$0 0 funcref))

  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $timport$0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (drop (i32.load (i32.const 0)))
    (call_indirect (type $0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (i32.store (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.atomic.rmw.add
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (i32.atomic.rmw.add (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.atomic.rmw8.cmpxchg_u
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (i32.atomic.rmw8.cmpxchg_u (i32.const 0) (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i64)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.atomic.wait32
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (local $0 i32)
    (local $1 i64)
    (drop
     (memory.atomic.wait32
      (local.get $0)
      (local.get $0)
      (local.get $1)
     )
    )
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0) (result i32)
  ;; CHECK-NEXT:  (memory.atomic.notify
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (memory.atomic.notify (i32.const 0) (i32.const 0))
  )
)
(module ;; atomic.fence and data.drop do not use a memory, so should not keep the memory alive.
  (memory $0 (shared 1 1))
  (data "")
  (export "fake-user" $user)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (data $0 "")

  ;; CHECK:      (export "fake-user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (atomic.fence)
  ;; CHECK-NEXT:  (data.drop $0)
  ;; CHECK-NEXT: )
  (func $user
    (atomic.fence)
    (data.drop 0)
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "mem" (memory $0 256))
  (import "env" "mem" (memory $0 256))
  ;; CHECK:      (memory $1 23 256)
  (memory $1 23 256)
  (memory $unused 1 1)

  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.grow $0
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.grow $1
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (drop (memory.grow $0 (i32.const 0)))
    (drop (memory.grow $1 (i32.const 0)))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (memory $0 23 256)
  (memory $0 23 256)
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0) (result i32)
  ;; CHECK-NEXT:  (memory.size)
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (memory.size)
  )
)
(module ;; memory.copy should keep both memories alive
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (memory $0 1 1)
  (memory $0 1 1)
  ;; CHECK:      (memory $1 1 1)
  (memory $1 1 1)
  (memory $unused 1 1)
  (export "user" $user)
  ;; CHECK:      (export "user" (func $user))

  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (memory.copy $0 $1
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (memory.copy $0 $1
      (i32.const 0)
      (i32.const 0)
      (i32.const 0)
    )
  )
)
(module
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  ;; CHECK:      (import "env" "table" (table $timport$0 0 funcref))

  ;; CHECK:      (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "memoryBase" (global $memoryBase i32)) ;; used in init
  ;; CHECK:      (import "env" "tableBase" (global $tableBase i32))
  (import "env" "tableBase" (global $tableBase i32)) ;; used in init
  (data (global.get $memoryBase) "hello, world!")
  (elem (global.get $tableBase) $waka)
  ;; CHECK:      (data $0 (global.get $memoryBase) "hello, world!")

  ;; CHECK:      (elem $0 (global.get $tableBase) $waka)

  ;; CHECK:      (func $waka (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $waka) ;; used in table
)
(module ;; one is exported, and one->two->int global, whose init->imported
  ;; CHECK:      (type $0 (func (result i32)))

  ;; CHECK:      (type $1 (func))

  ;; CHECK:      (type $2 (func (param i32) (result i32)))

  ;; CHECK:      (import "env" "imported" (global $imported i32))
  (import "env" "imported" (global $imported i32))
  (import "env" "forgetme" (global $forgetme i32))
  ;; CHECK:      (import "env" "_puts" (func $_puts (type $2) (param i32) (result i32)))
  (import "env" "_puts" (func $_puts (param i32) (result i32)))
  (import "env" "forget_puts" (func $forget_puts (param i32) (result i32)))
  ;; CHECK:      (global $int (mut i32) (global.get $imported))
  (global $int (mut i32) (global.get $imported))
  ;; CHECK:      (global $set (mut i32) (i32.const 100))
  (global $set (mut i32) (i32.const 100))
  (global $forglobal.get (mut i32) (i32.const 500))
  ;; CHECK:      (global $exp_glob i32 (i32.const 600))
  (global $exp_glob i32 (i32.const 600))
  ;; CHECK:      (export "one" (func $one))
  (export "one" (func $one))
  ;; CHECK:      (export "three" (func $three))
  (export "three" (func $three))
  ;; CHECK:      (export "exp_glob" (global $exp_glob))
  (export "exp_glob" (global $exp_glob))
  (start $starter)
  ;; CHECK:      (func $one (type $0) (result i32)
  ;; CHECK-NEXT:  (call $two)
  ;; CHECK-NEXT: )
  (func $one (result i32)
    (call $two)
  )
  ;; CHECK:      (func $two (type $0) (result i32)
  ;; CHECK-NEXT:  (global.get $int)
  ;; CHECK-NEXT: )
  (func $two (result i32)
    (global.get $int)
  )
  ;; CHECK:      (func $three (type $1)
  ;; CHECK-NEXT:  (call $four)
  ;; CHECK-NEXT: )
  (func $three
    (call $four)
  )
  ;; CHECK:      (func $four (type $1)
  ;; CHECK-NEXT:  (global.set $set
  ;; CHECK-NEXT:   (i32.const 200)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $_puts
  ;; CHECK-NEXT:    (i32.const 300)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $four
    (global.set $set (i32.const 200))
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
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (start $starter)
  (start $starter)
  ;; CHECK:      (func $starter (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $starter
    (drop (i32.const 0))
  )
)
(module ;; imported start cannot be removed
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "env" "start" (func $start (type $0)))
  (import "env" "start" (func $start))
  ;; CHECK:      (start $start)
  (start $start)
)
(module ;; the function and the table can be removed
 (type $0 (func (param f64) (result f64)))
 (table 6 6 funcref)
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
 (table 6 6 funcref)
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
(module
 ;; We import two tables and have an active segment that writes to one of them.
 ;; We must keep that table and the segment, but we can remove the other table.
 ;; CHECK:      (type $0 (func (param f64) (result f64)))
 (type $0 (func (param f64) (result f64)))

 ;; CHECK:      (import "env" "written" (table $written 6 6 funcref))
 (import "env" "written" (table $written 6 6 funcref))

 (import "env" "unwritten" (table $unwritten 6 6 funcref))

 (table $defined-unused 6 6 funcref)

 ;; CHECK:      (table $defined-used 6 6 funcref)
 (table $defined-used 6 6 funcref)

 ;; CHECK:      (elem $active1 (table $written) (i32.const 0) func $0)
 (elem $active1 (table $written) (i32.const 0) $0)

 ;; This empty active segment doesn't keep the unwritten table alive.
 (elem $active2 (table $unwritten) (i32.const 0))

 (elem $active3 (table $defined-unused) (i32.const 0) $0)

 ;; CHECK:      (elem $active4 (table $defined-used) (i32.const 0) func $0)
 (elem $active4 (table $defined-used) (i32.const 0) $0)

 (elem $active5 (table $defined-used) (i32.const 0))
 ;; CHECK:      (func $0 (type $0) (param $var$0 f64) (result f64)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (table.get $defined-used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (if (result f64)
 ;; CHECK-NEXT:   (f64.eq
 ;; CHECK-NEXT:    (f64.const 1)
 ;; CHECK-NEXT:    (f64.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (f64.const 1)
 ;; CHECK-NEXT:   (f64.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (drop
   (table.get $defined-used
    (i32.const 0)
   )
  )
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
(module
 ;; The same thing works for memories with active segments.
 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (import "env" "written" (memory $written 1 1))
 (import "env" "written" (memory $written 1 1))

 (import "env" "unwritten" (memory $unwritten 1 1))

 (memory $defined-unused 1 1)

 ;; CHECK:      (memory $defined-used 1 1)
 (memory $defined-used 1 1)

 ;; CHECK:      (data $active1 (i32.const 0) "foobar")
 (data $active1 (memory $written) (i32.const 0) "foobar")

 (data $active2 (memory $unwritten) (i32.const 0) "")

 (data $active3 (memory $defined-unused) (i32.const 0) "hello")

 ;; CHECK:      (data $active4 (memory $defined-used) (i32.const 0) "hello")
 (data $active4 (memory $defined-used) (i32.const 0) "hello")

 (data $active5 (memory $defined-used) (i32.const 0) "")

 ;; CHECK:      (export "user" (func $user))

 ;; CHECK:      (func $user (type $0)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.load $defined-used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $user (export "user")
  (drop
   (i32.load $defined-used
    (i32.const 0)
   )
  )
 )
)
(module
 ;; Nothing should break if the unused segments precede the used segments.
 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (type $array (array funcref))
 (type $array (array funcref))

 (memory $mem 1 1)
 (table $tab 1 1 funcref)

 (data $unused "")
 (elem $unused func)

 ;; CHECK:      (data $used "")
 (data $used "")
 ;; CHECK:      (elem $used func)
 (elem $used func)

 ;; CHECK:      (export "user" (func $user))

 ;; CHECK:      (func $user (type $0)
 ;; CHECK-NEXT:  (data.drop $used)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (array.new_elem $array $used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $user (export "user")
  (data.drop 1)
  (drop
   (array.new_elem $array 1
    (i32.const 0)
    (i32.const 0)
    (i32.const 0)
   )
  )
 )
)
;; SIMD operations can keep memories alive
(module
 ;; CHECK:      (type $0 (func))

 ;; CHECK:      (memory $A 1 1)
 (memory $A 1 1)
 ;; CHECK:      (memory $B 1 1)
 (memory $B 1 1)
 (memory $C-unused 1 1)

 ;; CHECK:      (export "func" (func $func))

 ;; CHECK:      (func $func (type $0)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (v128.load64_splat $A
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (v128.load16_lane $B 0
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:    (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $func (export "func")
  (drop
   (v128.load64_splat $A
    (i32.const 0)
   )
  )
  (drop
   (v128.load16_lane $B 0
    (i32.const 0)
    (v128.const i32x4 0 0 0 0)
   )
  )
 )
)

(module
  ;; When we export a function that calls another, we can export the called
  ;; function, skipping the one in the middle. The exports of $middle and
  ;; $other-middle can be changed to their targets here.

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "a" "b" (func $import (type $0)))
  (import "a" "b" (func $import))

  ;; CHECK:      (export "export-import" (func $import))
  (export "export-import" (func $import))

  ;; CHECK:      (export "export-middle" (func $middle))
  (export "export-middle" (func $middle))

  ;; CHECK:      (export "export-other-middle" (func $other-middle))
  (export "export-other-middle" (func $other-middle))

  ;; CHECK:      (export "export-internal" (func $internal))
  (export "export-internal" (func $internal))

  ;; CHECK:      (func $middle (type $0)
  ;; CHECK-NEXT:  (call $import)
  ;; CHECK-NEXT: )
  (func $middle
    (call $import)
  )

  ;; CHECK:      (func $other-middle (type $0)
  ;; CHECK-NEXT:  (call $internal)
  ;; CHECK-NEXT: )
  (func $other-middle
    (call $internal)
  )

  ;; CHECK:      (func $internal (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $internal
  )
)

;; As above, but we do not do that optimization when it would change the
;; exported type.
(module
  (rec
    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $A (func))
    (type $A (func))
    ;; CHECK:       (type $B (func))
    (type $B (func))
  )

  ;; CHECK:      (import "a" "a" (func $import-A (type $A)))
  (import "a" "a" (func $import-A (type $A)))
  ;; CHECK:      (import "b" "b" (func $import-B (type $B)))
  (import "b" "b" (func $import-B (type $B)))

  ;; CHECK:      (export "export-import-A" (func $import-A))
  (export "export-import-A" (func $import-A))

  ;; CHECK:      (export "export-import-B" (func $import-B))
  (export "export-import-B" (func $import-B))

  ;; CHECK:      (export "export-middle-A-A" (func $middle-A-A))
  (export "export-middle-A-A" (func $middle-A-A))

  ;; CHECK:      (export "export-middle-A-B" (func $middle-A-B))
  (export "export-middle-A-B" (func $middle-A-B))

  ;; CHECK:      (export "export-middle-B-A" (func $middle-B-A))
  (export "export-middle-B-A" (func $middle-B-A))

  ;; CHECK:      (export "export-middle-B-B" (func $middle-B-B))
  (export "export-middle-B-B" (func $middle-B-B))

  ;; CHECK:      (func $middle-A-A (type $A)
  ;; CHECK-NEXT:  (call $import-A)
  ;; CHECK-NEXT: )
  (func $middle-A-A (type $A)
    (call $import-A)
  )

  ;; CHECK:      (func $middle-A-B (type $A)
  ;; CHECK-NEXT:  (call $import-B)
  ;; CHECK-NEXT: )
  (func $middle-A-B (type $A)
    (call $import-B)
  )

  ;; CHECK:      (func $middle-B-A (type $B)
  ;; CHECK-NEXT:  (call $import-A)
  ;; CHECK-NEXT: )
  (func $middle-B-A (type $B)
    (call $import-A)
  )

  ;; CHECK:      (func $middle-B-B (type $B)
  ;; CHECK-NEXT:  (call $import-B)
  ;; CHECK-NEXT: )
  (func $middle-B-B (type $B)
    (call $import-B)
  )
)

;; As above, but checking for parameters: It's ok to pass values through, but
;; not to do anything else.
(module
  ;; CHECK:      (type $0 (func (param i32)))

  ;; CHECK:      (import "a" "b" (func $import (type $0) (param i32)))
  (import "a" "b" (func $import (param i32)))

  ;; CHECK:      (export "export-import" (func $import))
  (export "export-import" (func $import))

  ;; CHECK:      (export "export-middle" (func $middle))
  (export "export-middle" (func $middle))

  ;; CHECK:      (export "export-middle-local" (func $middle-local))
  (export "export-middle-local" (func $middle-local))

  ;; CHECK:      (export "export-middle-other" (func $middle-other))
  (export "export-middle-other" (func $middle-other))

  ;; CHECK:      (export "export-middle-noncall" (func $middle-noncall))
  (export "export-middle-noncall" (func $middle-noncall))

  ;; CHECK:      (func $middle (type $0) (param $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (call $import
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle (param $x i32)
    ;; This extra local is not a problem.
    (local $y i32)
    (call $import
      (local.get $x)
    )
  )

  ;; CHECK:      (func $middle-local (type $0) (param $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (call $import
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle-local (param $x i32)
    (local $y i32)
    (call $import
      ;; Now we get the local instead of the param, so we cannot optimize.
      (local.get $y)
    )
  )

  ;; CHECK:      (func $middle-other (type $0) (param $x i32)
  ;; CHECK-NEXT:  (call $import
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle-other (param $x i32)
    (call $import
      ;; Something other than local.get, so we cannot optimize.
      (i32.const 1)
    )
  )

  ;; CHECK:      (func $middle-noncall (type $0) (param $x i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle-noncall (param $x i32)
    ;; Not even a call here.
    (drop
      (i32.const 1)
    )
  )
)

;; Function with two parameters: we can only optimize when the arguments are in
;; the right order.
;;
;; Also test with a return value.
(module
  ;; CHECK:      (type $0 (func (param i32 i32) (result f64)))

  ;; CHECK:      (import "a" "b" (func $import (type $0) (param i32 i32) (result f64)))
  (import "a" "b" (func $import (param i32) (param i32) (result f64)))

  ;; CHECK:      (export "export-middle-right" (func $middle-right))
  (export "export-middle-right" (func $middle-right))

  ;; CHECK:      (export "export-middle-wrong" (func $middle-wrong))
  (export "export-middle-wrong" (func $middle-wrong))

  ;; CHECK:      (func $middle-right (type $0) (param $x i32) (param $y i32) (result f64)
  ;; CHECK-NEXT:  (call $import
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle-right (param $x i32) (param $y i32) (result f64)
    (call $import
      (local.get $x)
      (local.get $y)
    )
  )

  ;; CHECK:      (func $middle-wrong (type $0) (param $x i32) (param $y i32) (result f64)
  ;; CHECK-NEXT:  (call $import
  ;; CHECK-NEXT:   (local.get $y)
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $middle-wrong (param $x i32) (param $y i32) (result f64)
    ;; The local.gets are reversed here, so we cannot optimize.
    (call $import
      (local.get $y)
      (local.get $x)
    )
  )
)

(module
  ;; As above, but with a return_call. We can optimize it like a call.

  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (import "a" "b" (func $import (type $0)))
  (import "a" "b" (func $import))

  ;; CHECK:      (export "export-middle" (func $middle))
  (export "export-middle" (func $middle))

  ;; CHECK:      (func $middle (type $0)
  ;; CHECK-NEXT:  (return_call $import)
  ;; CHECK-NEXT: )
  (func $middle
    (return_call $import)
  )
)
