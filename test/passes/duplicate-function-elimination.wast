(module
  (func $erase
    (nop)
  )
  (func $other
    (nop)
  )
)
(module
  (func $keep2
    (i32.const 0)
  )
  (func $other
    (nop)
  )
)
(module
  (func $erase
    (i32.const 0)
  )
  (func $other
    (i32.const 0)
  )
)
(module
  (func $keep2
    (i32.const 0)
  )
  (func $other
    (i32.const 1)
  )
)
(module
  (export "keep2" $keep2)
  (export "other" $other)
  (start $other)
  (table $keep2 $other $caller)
  (func $keep2
    (nop)
  )
  (func $other
    (nop)
  )
  (func $caller
    (call $keep2)
    (call $other)
  )
)
(module
  (func $keep2-after-two-passes
    (nop)
  )
  (func $other
    (nop)
  )
  (func $keep-caller
    (call $keep2-after-two-passes)
  )
  (func $other-caller
    (call $other)
  )
)
(module
  (func $keep-4
    (nop)
  )
  (func $other
    (unreachable)
  )
  (func $keep-caller
    (call $keep-4)
  )
  (func $other-caller
    (call $other)
  )
)
(module
  (type T (func (result i32)))
  (type S (func (result i32)))
  (func $keep4-similar-but-func-sig-differs
    (i32.const 0)
  )
  (func $other1 (param $i i32)
    (i32.const 0)
  )
  (func $other2 (type $T) (result i32)
    (i32.const 0)
  )
  (func $other3 (type $S) (result i32)
    (i32.const 0)
  )
)
(module
  (type S (func (result i32)))
  (func $keep2-similar-but-func-sig-differs (param $i i32)
    (i32.const 0)
  )
  (func $other1 (param $i i32)
    (i32.const 0)
  )
  (func $other2 (type $S) (result i32)
    (i32.const 0)
  )
  (func $other3 (type $S) (result i32)
    (i32.const 0)
  )
)
;; hashing tests for expressions
(module
  (func $keep2
    (nop)
  )
  (func $other
    (nop)
    (nop)
  )
)
(module
  (func $erase
    (block)
  )
  (func $other
    (block)
  )
)
(module
  (func $keep2
    (block)
  )
  (func $other
    (block (nop))
  )
)
(module
  (func $erase
    (block (nop))
  )
  (func $other
    (block (nop))
  )
)
(module
  (func $keep2
    (block (nop))
  )
  (func $other
    (block (nop) (unreachable))
  )
)
(module
  (func $keep2
    (block (nop))
  )
  (func $other
    (block (unreachable))
  )
)
(module
  (func $erase-since-block-names-do-not-matter
    (block $foo)
  )
  (func $other
    (block $bar)
  )
)
(module
  (func $erase-since-block-names-do-not-matter
    (block $foo
      (br $foo)
      (br_table $foo $foo (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br $bar)
      (br_table $bar $bar (i32.const 0))
    )
  )
)
(module
  (func $keep2
    (block $foo
      (br $foo (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br $bar (i32.const 1))
    )
  )
)
(module
  (func $keep2
    (block $foo
      (br_if $foo (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br_if $bar (i32.const 1))
    )
  )
)
(module
  (func $erase
    (block $foo
      (br_if $foo (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br_if $bar (i32.const 0))
    )
  )
)
(module
  (func $keep2
    (block $foo
      (br_table $foo $foo (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br_table $bar $bar (i32.const 1))
    )
  )
)
(module
  (func $erase
    (loop $foo $bar)
  )
  (func $other
    (loop $sfo $sjc)
  )
)
(module
  (func $keep2
    (block $foo
      (br_table $foo $foo (i32.const 0) (i32.const 0))
    )
  )
  (func $other
    (block $bar
      (br_table $bar $bar (i32.const 0) (i32.const 1))
    )
  )
)
(module
  (func $keep2
    (block $foo
      (block $bar
        (br_table $foo $bar (i32.const 0))
      )
    )
  )
  (func $other
    (block $bar
      (block $foo
        (br_table $bar $foo (i32.const 0))
      )
    )
  )
)
(module
  (func $erase
    (block $foo
      (block $bar
        (br_table $foo $bar (i32.const 0))
      )
    )
  )
  (func $other
    (block $bar
      (block $foo
        (br_table $foo $bar (i32.const 0))
      )
    )
  )
)
(module
  (func $erase
    (call $erase)
  )
  (func $other
    (call $erase)
  )
)
(module
  (func $keep2-but-in-theory-we-could-erase ;; TODO FIXME
    (call $keep2-but-in-theory-we-could-erase)
  )
  (func $other
    (call $other)
  )
)
(module
  (import $i "env" "i")
  (import $i "env" "j")
  (func $erase
    (call_import $i)
  )
  (func $other
    (call_import $i)
  )
)
(module
  (import $i "env" "i")
  (import $j "env" "j")
  (func $keep2
    (call_import $i)
  )
  (func $other
    (call_import $j)
  )
)
(module
  (type T (func))
  (table $erase $other)
  (func $erase
    (call_indirect $T (i32.const 0))
  )
  (func $other
    (call_indirect $T (i32.const 0))
  )
)
(module
  (type T (func))
  (table $keep2 $other)
  (func $keep2
    (call_indirect $T (i32.const 0))
  )
  (func $other
    (call_indirect $T (i32.const 1))
  )
)
(module
  (type T (func))
  (type S (func))
  (table $keep2 $other)
  (func $keep2
    (call_indirect $T (i32.const 0))
  )
  (func $other
    (call_indirect $S (i32.const 0))
  )
)
(module
  (func $erase-even-locals-with-different-names
    (local $i i32)
    (get_local $i)
  )
  (func $other
    (local $j i32)
    (get_local $j)
  )
)
(module
  (func $keep2
    (local $i i32)
    (get_local $i)
  )
  (func $other
    (local $j i64)
    (get_local $j)
  )
)
(module
  (func $erase-even-locals-with-different-names
    (local $i i32)
    (set_local $i (i32.const 0))
  )
  (func $other
    (local $j i32)
    (set_local $j (i32.const 0))
  )
)
(module
  (func $keep2
    (local $i i32)
    (set_local $i (i32.const 0))
  )
  (func $other
    (local $j i64)
    (set_local $j (i64.const 0))
  )
)
(module
  (func $keep2
    (local $i i32)
    (set_local $i (i32.const 0))
  )
  (func $other
    (local $j i32)
    (set_local $j (i32.const 1))
  )
)
(module
  (memory 10)
  (func $erase
    (i32.load (i32.const 0))
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
  (func $other
    (i32.load (i32.const 0))
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.load16_s align=2 offset=3 (i32.const 0))
  )
  (func $other
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.load8_s offset=3 (i32.const 0))
  )
  (func $other
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.load8_s align=2 (i32.const 0))
  )
  (func $other
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
  (func $other
    (i32.load8_s align=2 offset=3 (i32.const 1))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.load8_u align=2 offset=3 (i32.const 0))
  )
  (func $other
    (i32.load8_s align=2 offset=3 (i32.const 0))
  )
)

(module
  (memory 10)
  (func $erase
    (i32.store (i32.const 0) (i32.const 100))
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store (i32.const 0) (i32.const 100))
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.store16 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.store8 offset=3 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.store8 align=2 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store8 align=2 offset=3 (i32.const 1) (i32.const 100))
  )
)
(module
  (memory 10)
  (func $keep2
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 100))
  )
  (func $other
    (i32.store8 align=2 offset=3 (i32.const 0) (i32.const 101))
  )
)
(module
  (func $keep2
    (i32.const 0)
  )
  (func $other
    (i64.const 0)
  )
)
(module
  (func $keep2
    (i32.const 0)
  )
  (func $other
    (f32.const 0)
  )
)
(module
  (func $keep2
    (i32.const 0)
  )
  (func $other
    (f64.const 0)
  )
)
(module
  (func $keep2
    (i64.const 0)
  )
  (func $other
    (i64.const 1)
  )
)
(module
  (func $keep2
    (f32.const 0.1)
  )
  (func $other
    (f32.const -0.1)
  )
)
(module
  (func $keep2
    (f64.const 0.1)
  )
  (func $other
    (f64.const 0.2)
  )
)
(module
  (func $erase
    (f32.abs (f32.const 0))
  )
  (func $other
    (f32.abs (f32.const 0))
  )
)
(module
  (func $keep2
    (f32.abs (f32.const 0))
  )
  (func $other
    (f32.abs (f32.const 1))
  )
)
(module
  (func $keep2
    (f32.abs (f32.const 0))
  )
  (func $other
    (f32.neg (f32.const 0))
  )
)
(module
  (func $erase
    (f32.add (f32.const 0) (f32.const 0))
  )
  (func $other
    (f32.add (f32.const 0) (f32.const 0))
  )
)
(module
  (func $keep2
    (f32.add (f32.const 0) (f32.const 0))
  )
  (func $other
    (f32.add (f32.const 0) (f32.const 1))
  )
)
(module
  (func $keep2
    (f32.add (f32.const 0) (f32.const 0))
  )
  (func $other
    (f32.add (f32.const 1) (f32.const 0))
  )
)
(module
  (func $keep2
    (f32.add (f32.const 0) (f32.const 0))
  )
  (func $other
    (f32.sub (f32.const 0) (f32.const 0))
  )
)
(module
  (func $erase
    (select (i32.const 0) (i32.const 0) (i32.const 0))
  )
  (func $other
    (select (i32.const 0) (i32.const 0) (i32.const 0))
  )
)
(module
  (func $keep
    (select (i32.const 0) (i32.const 0) (i32.const 0))
  )
  (func $other
    (select (i32.const 1) (i32.const 0) (i32.const 0))
  )
)
(module
  (func $keep
    (select (i32.const 0) (i32.const 0) (i32.const 0))
  )
  (func $other
    (select (i32.const 0) (i32.const 2) (i32.const 0))
  )
)
(module
  (func $keep
    (select (i32.const 0) (i32.const 0) (i32.const 0))
  )
  (func $other
    (select (i32.const 0) (i32.const 0) (i32.const 3))
  )
)
(module
  (func $erase
    (return)
  )
  (func $other
    (return)
  )
)
(module
  (func $erase (result i32)
    (return (i32.const 0))
  )
  (func $other (result i32)
    (return (i32.const 0))
  )
)
(module
  (func $keep (result i32)
    (return (i32.const 0))
  )
  (func $other (result i32)
    (return (i32.const 1))
  )
)
(module
  (func $erase
    (current_memory)
  )
  (func $other
    (current_memory)
  )
)
(module
  (func $erase
    (grow_memory (i32.const 10))
  )
  (func $other
    (grow_memory (i32.const 10))
  )
)
(module
  (func $keep
    (grow_memory (i32.const 10))
  )
  (func $other
    (grow_memory (i32.const 11))
  )
)
(module
  (func $keep
    (current_memory)
  )
  (func $other
    (grow_memory (i32.const 10))
  )
)

