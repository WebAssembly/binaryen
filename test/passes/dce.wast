(module
  (memory 10)
  (type $ii (func (param i32 i32)))
  (type $1 (func))
  (table 1 1 anyfunc)
  (elem (i32.const 0) $call-me)
  (global $x (mut i32) (i32.const 0))
  (func $call-me (type $ii) (param $0 i32) (param $1 i32)
    (nop)
  )
  (func $code-to-kill (type $1)
    (local $x i32)
    (block $out
      (br $out)
      (drop
        (i32.const 0)
      )
      (if
        (i32.const 1)
        (drop
          (i32.const 2)
        )
      )
      (br_table $out $out $out $out
        (i32.const 3)
      )
      (call $code-to-kill)
    )
    (if
      (i32.const 0)
      (block $out
        (unreachable)
        (drop
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 0)
      (block $out
        (return)
        (drop
          (i32.const 0)
        )
      )
    )
    (block $out
      (br_table $out $out $out $out
        (i32.const 4)
      )
      (drop
        (i32.const 0)
      )
    )
    (block $out
      (br_if $out
        (i32.const 3)
      )
      (drop
        (i32.const 0)
      )
    )
    (if
      (i32.const 0)
      (block $block4
        (if
          (i32.const 0)
          (block $out
            (unreachable)
            (drop
              (i32.const 0)
            )
          )
          (block $out
            (unreachable)
            (drop
              (i32.const 0)
            )
          )
        )
        (drop
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 0)
      (drop
        (block $out i32
          (br $out
            (unreachable)
          )
          (drop
            (i32.const 0)
          )
          (unreachable)
        )
      )
    )
    (if
      (i32.const 0)
      (drop
        (block $out i32
          (br_if $out
            (unreachable)
            (i32.const 0)
          )
          (drop
            (i32.const 0)
          )
          (unreachable)
        )
      )
    )
    (if
      (i32.const 0)
      (drop
        (block $out i32
          (br_if $out
            (unreachable)
            (unreachable)
          )
          (drop
            (i32.const 0)
          )
          (unreachable)
        )
      )
    )
    (block $out
      (block $in
        (br_if $out
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (if
      (i32.const 0)
      (block $block11
        (block $out
          (block $in
            (br_if $in
              (i32.const 1)
            )
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (block $out
      (block $in
        (br_table $out $in
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (block $out
      (block $in
        (br_table $in $out
          (i32.const 1)
        )
      )
      (unreachable)
    )
    (if
      (i32.const 0)
      (block $block13
        (block $out
          (block $in
            (br_table $in $in
              (i32.const 1)
            )
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (if
      (i32.const 0)
      (block $block15
        (drop
          (i32.const 10)
        )
        (drop
          (i32.const 42)
        )
        (unreachable)
        (return
          (unreachable)
        )
        (unreachable)
        (return)
      )
    )
    (if
      (i32.const 0)
      (loop $loop-in18
        (unreachable)
      )
    )
    (block $out
    (loop $in
      (br_if $out
        (i32.const 1)
      )
      (unreachable)
    )
    )
    (if
      (i32.const 0)
      (block $block20
        (loop $in
          (br_if $in
            (i32.const 1)
          )
          (unreachable)
        )
        (drop
          (i32.const 10)
        )
      )
    )
    (if
      (i32.const 1)
      (call $call-me
        (i32.const 123)
        (unreachable)
      )
    )
    (if
      (i32.const 2)
      (call $call-me
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const 3)
      (call $call-me
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const -1)
      (call_indirect $ii
        (i32.const 123)
        (i32.const 456)
        (unreachable)
      )
    )
    (if
      (i32.const -2)
      (call_indirect $ii
        (i32.const 139)
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const -3)
      (call_indirect $ii
        (i32.const 246)
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const -4)
      (call_indirect $ii
        (unreachable)
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 11)
      (set_local $x
        (unreachable)
      )
    )
    (if
      (i32.const 22)
      (drop
        (i32.load
          (unreachable)
        )
      )
    )
    (if
      (i32.const 33)
      (i32.store
        (i32.const 0)
        (unreachable)
      )
    )
    (if
      (i32.const 44)
      (i32.store
        (unreachable)
        (i32.const 0)
      )
    )
    (if
      (i32.const 55)
      (i32.store
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 66)
      (drop
        (i32.eqz
          (unreachable)
        )
      )
    )
    (if
      (i32.const 77)
      (drop
        (i32.add
          (unreachable)
          (i32.const 0)
        )
      )
    )
    (if
      (i32.const 88)
      (drop
        (i32.add
          (i32.const 0)
          (unreachable)
        )
      )
    )
    (if
      (i32.const 99)
      (i32.add
        (unreachable)
        (unreachable)
      )
    )
    (if
      (i32.const 100)
      (drop
        (select
          (i32.const 123)
          (i32.const 456)
          (unreachable)
        )
      )
    )
    (if
      (i32.const 101)
      (drop
        (select
          (i32.const 123)
          (unreachable)
          (i32.const 456)
        )
      )
    )
    (if
      (i32.const 102)
      (drop
        (select
          (unreachable)
          (i32.const 123)
          (i32.const 456)
        )
      )
    )
    (drop
      (i32.const 1337)
    )
  )
  (func $killer (type $1)
    (unreachable)
    (drop
      (i32.const 1000)
    )
  )
  (func $target (type $1)
    (drop
      (i32.const 2000)
    )
  )
  (func $typed-block-none-then-unreachable (result i32)
    (block $top-typed i32
      (block $switch$0 ;; this looks like it can be broken to, so it gets type 'none'
        (return
          (i32.const 0)
        )
        (br $switch$0) ;; this is not reachable, so dce cleans it up, changing $switch$0's type
      )
      (return ;; and this is cleaned up as well, leaving $top-typed in need of a type change
        (i32.const 1)
      )
    )
  )
  (func $typed-block-remove-br-changes-type (param $$$0 i32) (result i32)
    (block $switch$7
      (block $switch-default$10
        (block $switch-case$9
          (block $switch-case$8
            (br_table $switch-case$9 $switch-case$8 $switch-default$10
              (i32.const -1)
            )
          )
        )
        (return
          (get_local $$$0)
        )
        (br $switch$7)
      )
      (return
        (get_local $$$0)
      )
    )
    (return
      (i32.const 0)
    )
  )
  (func $global
    (unreachable)
    (drop (get_global $x))
    (set_global $x (i32.const 1))
  )
  (func $ret (result i32)
    (return
      (i32.const 0)
    )
    (nop)
    (i32.const 0)
  )
  (func $unreachable-br (result i32)
    (block $out i32
      (br $out
        (br $out (i32.const 0))
      )
    )
  )
  (func $unreachable-br-loop (result i32)
    (loop $out
      (br $out)
    )
  )
 (func $unreachable-block-ends-switch (result i32)
  (block $label$0 i32
   (block $label$3
    (nop)
    (br_table $label$3
     (unreachable)
    )
    (unreachable)
   )
   (i32.const 19)
  )
 )
 (func $unreachable-block-ends-br_if (type $1) (result i32)
  (block $label$0 i32
   (block $label$2
    (nop)
    (br_if $label$2
     (unreachable)
    )
    (unreachable)
   )
   (i32.const 19)
  )
 )
 (func $unreachable-brs-3 (result i32)
  (block $label$0 i32
   (br $label$0
    (grow_memory
     (br $label$0
      (i32.const 18)
     )
    )
   )
   (i32.const 21)
  )
 )
 (func $unreachable-brs-4 (param $var$0 i32) (result i32)
  (i32.add
   (i32.const 1)
   (block $label$0 i32
    (br $label$0
     (block $label$1 i32 ;; this block is declared i32, but we can see it is unreachable
      (drop
       (br_if $label$0
        (i32.const 4104)
        (unreachable)
       )
      )
      (i32.const 4)
     )
    )
    (i32.const 16)
   )
  )
 )
 (func $call-unreach (param $var$0 i64) (param $var$1 i64) (result i64)
  (local $2 i64)
  (if i64
   (i64.eqz
    (get_local $var$0)
   )
   (block $label$0 i64
    (get_local $var$1)
   )
   (block $label$1 i64
    (call $call-unreach
     (i64.sub
      (get_local $var$0)
      (i64.const 1)
     )
     (i64.mul
      (block i64
       (set_local $2
        (get_local $var$0)
       )
       (nop)
       (get_local $2)
      )
      (unreachable)
     )
    )
   )
  )
 )
)
