;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: wasm-opt %s --remove-unused-names --optimize-instructions --all-features -S -o - | filecheck %s
;; remove-unused-names is to allow fallthrough computations to work on blocks

(module
 ;; CHECK:      (type $i32_i32_=>_none (func (param i32 i32)))
 (type $i32_i32_=>_none (func (param i32 i32)))

 ;; CHECK:      (type $none_=>_i32 (func (result i32)))
 (type $none_=>_i32 (func (result i32)))

 ;; CHECK:      (type $none_=>_none (func))
 (type $none_=>_none (func))

 ;; CHECK:      (type $3 (func (param i32)))

 ;; CHECK:      (type $struct_=>_none (func (param (ref struct))))
 (type $struct_=>_none (func (param (ref struct))))

 ;; CHECK:      (type $5 (func (param i32 i32 i32 (ref $i32_i32_=>_none))))

 ;; CHECK:      (table $table-1 10 (ref null $i32_i32_=>_none))
 (table $table-1 10 (ref null $i32_i32_=>_none))
 ;; CHECK:      (elem $elem-1 (table $table-1) (i32.const 0) (ref null $i32_i32_=>_none) (ref.func $foo))
 (elem $elem-1 (table $table-1) (i32.const 0) (ref null $i32_i32_=>_none)
  (ref.func $foo))

 ;; CHECK:      (elem declare func $bar $fallthrough-no-params $fallthrough-non-nullable $return-nothing)

 ;; CHECK:      (func $foo (type $i32_i32_=>_none) (param $0 i32) (param $1 i32)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $foo (param i32) (param i32)
  (unreachable)
 )

 ;; CHECK:      (func $bar (type $i32_i32_=>_none) (param $0 i32) (param $1 i32)
 ;; CHECK-NEXT:  (unreachable)
 ;; CHECK-NEXT: )
 (func $bar (param i32) (param i32)
  (unreachable)
 )

 ;; CHECK:      (func $call_ref-to-direct (type $i32_i32_=>_none) (param $x i32) (param $y i32)
 ;; CHECK-NEXT:  (call $foo
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (local.get $y)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call_ref-to-direct (param $x i32) (param $y i32)
  ;; This call_ref should become a direct call.
  (call_ref $i32_i32_=>_none
   (local.get $x)
   (local.get $y)
   (ref.func $foo)
  )
 )

 ;; CHECK:      (func $fallthrough (type $3) (param $x i32)
 ;; CHECK-NEXT:  (local $1 i32)
 ;; CHECK-NEXT:  (call $foo
 ;; CHECK-NEXT:   (local.tee $x
 ;; CHECK-NEXT:    (i32.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (block (result i32)
 ;; CHECK-NEXT:    (local.set $1
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (block (result (ref $i32_i32_=>_none))
 ;; CHECK-NEXT:      (local.set $x
 ;; CHECK-NEXT:       (i32.const 2)
 ;; CHECK-NEXT:      )
 ;; CHECK-NEXT:      (ref.func $foo)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (local.get $1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $fallthrough (param $x i32)
  ;; This call_ref should become a direct call, even though it doesn't have a
  ;; simple ref.func as the target - we need to look into the fallthrough, and
  ;; handle things with locals.
  (call_ref $i32_i32_=>_none
   ;; Write to $x before the block, and write to it in the block; we should not
   ;; reorder these things as the side effects could alter what value appears
   ;; in the get of $x. (There is a risk of reordering here if we naively moved
   ;; the call target (the block) to before the first parameter (the tee).
   ;; Instead, we append it after the second param (the get) which keeps the
   ;; ordering as it was.)
   (local.tee $x
    (i32.const 1)
   )
   (local.get $x)
   (block (result (ref $i32_i32_=>_none))
    (local.set $x
     (i32.const 2)
    )
    (ref.func $foo)
   )
  )
 )

 ;; CHECK:      (func $fallthrough-no-params (type $none_=>_i32) (result i32)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (block (result (ref $none_=>_i32))
 ;; CHECK-NEXT:    (nop)
 ;; CHECK-NEXT:    (ref.func $fallthrough-no-params)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call $fallthrough-no-params)
 ;; CHECK-NEXT: )
 (func $fallthrough-no-params (result i32)
  ;; A fallthrough appears here, but there are no operands so this is easier to
  ;; optimize: we can just drop the call_ref's target before the call.
  (call_ref $none_=>_i32
   (block (result (ref $none_=>_i32))
    (nop)
    (ref.func $fallthrough-no-params)
   )
  )
 )

 ;; CHECK:      (func $fallthrough-non-nullable (type $struct_=>_none) (param $x (ref struct))
 ;; CHECK-NEXT:  (local $1 structref)
 ;; CHECK-NEXT:  (call $fallthrough-non-nullable
 ;; CHECK-NEXT:   (block (result (ref struct))
 ;; CHECK-NEXT:    (local.set $1
 ;; CHECK-NEXT:     (local.get $x)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (drop
 ;; CHECK-NEXT:     (block (result (ref $struct_=>_none))
 ;; CHECK-NEXT:      (nop)
 ;; CHECK-NEXT:      (ref.func $fallthrough-non-nullable)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (ref.as_non_null
 ;; CHECK-NEXT:     (local.get $1)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $fallthrough-non-nullable (param $x (ref struct))
  ;; A fallthrough appears here, and in addition the last operand is non-
  ;; nullable, which means we must be careful when we create a temp local for
  ;; it: the local should be nullable, and gets of it should use a
  ;; ref.as_non_null so that we validate.
  (call_ref $struct_=>_none
   (local.get $x)
   (block (result (ref $struct_=>_none))
    (nop)
    (ref.func $fallthrough-non-nullable)
   )
  )
 )

 ;; CHECK:      (func $fallthrough-bad-type (type $none_=>_i32) (result i32)
 ;; CHECK-NEXT:  (block ;; (replaces unreachable CallRef we can't emit)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (block (result (ref nofunc))
 ;; CHECK-NEXT:     (drop
 ;; CHECK-NEXT:      (ref.func $return-nothing)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:     (unreachable)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $fallthrough-bad-type (result i32)
  ;; A fallthrough appears here, and we cast the function type to something else
  ;; in a way that is bad: the actual target function has a different return
  ;; type than the cast type. The cast will definitely fail, and we should not
  ;; emit non-validating code here, which would happen if we replace the
  ;; call_ref that returns nothing with a call that returns an i32. In fact, we
  ;; end up optimizing the cast into an unreachable.
  (call_ref $none_=>_i32
   (ref.cast (ref $none_=>_i32)
    (ref.func $return-nothing)
   )
  )
 )

 ;; Helper function for the above test.
 ;; CHECK:      (func $return-nothing (type $none_=>_none)
 ;; CHECK-NEXT:  (nop)
 ;; CHECK-NEXT: )
 (func $return-nothing)

 ;; CHECK:      (func $fallthrough-unreachable (type $none_=>_none)
 ;; CHECK-NEXT:  (call_ref $i32_i32_=>_none
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:   (block (result (ref $i32_i32_=>_none))
 ;; CHECK-NEXT:    (nop)
 ;; CHECK-NEXT:    (ref.func $foo)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $fallthrough-unreachable
  ;; If the call is not reached, do not optimize it.
  (call_ref $i32_i32_=>_none
   (unreachable)
   (unreachable)
   (block (result (ref $i32_i32_=>_none))
    (nop)
    (ref.func $foo)
   )
  )
 )

 ;; CHECK:      (func $ignore-unreachable (type $none_=>_none)
 ;; CHECK-NEXT:  (block ;; (replaces unreachable CallRef we can't emit)
 ;; CHECK-NEXT:   (drop
 ;; CHECK-NEXT:    (unreachable)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (unreachable)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $ignore-unreachable
  ;; Ignore an unreachable call_ref target entirely.
  (call_ref $i32_i32_=>_none
   (unreachable)
  )
 )

 ;; CHECK:      (func $call-table-get (type $3) (param $x i32)
 ;; CHECK-NEXT:  (call_indirect $table-1 (type $i32_i32_=>_none)
 ;; CHECK-NEXT:   (i32.const 1)
 ;; CHECK-NEXT:   (i32.const 2)
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call-table-get (param $x i32)
  (call_ref $i32_i32_=>_none
   (i32.const 1)
   (i32.const 2)
   (table.get $table-1
    (local.get $x)
   )
  )
 )

 ;; CHECK:      (func $call_ref-to-select (type $5) (param $x i32) (param $y i32) (param $z i32) (param $f (ref $i32_i32_=>_none))
 ;; CHECK-NEXT:  (local $4 i32)
 ;; CHECK-NEXT:  (local $5 i32)
 ;; CHECK-NEXT:  (block
 ;; CHECK-NEXT:   (local.set $4
 ;; CHECK-NEXT:    (local.get $x)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (local.set $5
 ;; CHECK-NEXT:    (local.get $y)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (if
 ;; CHECK-NEXT:    (local.get $z)
 ;; CHECK-NEXT:    (then
 ;; CHECK-NEXT:     (call $foo
 ;; CHECK-NEXT:      (local.get $4)
 ;; CHECK-NEXT:      (local.get $5)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:    (else
 ;; CHECK-NEXT:     (call $bar
 ;; CHECK-NEXT:      (local.get $4)
 ;; CHECK-NEXT:      (local.get $5)
 ;; CHECK-NEXT:     )
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (call_ref $i32_i32_=>_none
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:   (local.get $y)
 ;; CHECK-NEXT:   (select (result (ref $i32_i32_=>_none))
 ;; CHECK-NEXT:    (local.get $f)
 ;; CHECK-NEXT:    (ref.func $bar)
 ;; CHECK-NEXT:    (local.get $z)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $call_ref-to-select (param $x i32) (param $y i32) (param $z i32) (param $f (ref $i32_i32_=>_none))
  ;; This call_ref should become an if over two direct calls.
  (call_ref $i32_i32_=>_none
   (local.get $x)
   (local.get $y)
   (select
    (ref.func $foo)
    (ref.func $bar)
    (local.get $z)
   )
  )

  ;; But here one arm is not constant, so we do not optimize.
  (call_ref $i32_i32_=>_none
   (local.get $x)
   (local.get $y)
   (select
    (local.get $f)
    (ref.func $bar)
    (local.get $z)
   )
  )
 )

 ;; CHECK:      (func $return_call_ref-to-select (type $i32_i32_=>_none) (param $x i32) (param $y i32)
 ;; CHECK-NEXT:  (local $2 i32)
 ;; CHECK-NEXT:  (local $3 i32)
 ;; CHECK-NEXT:  (local.set $2
 ;; CHECK-NEXT:   (local.get $x)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (local.set $3
 ;; CHECK-NEXT:   (local.get $y)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (if
 ;; CHECK-NEXT:   (call $get-i32)
 ;; CHECK-NEXT:   (then
 ;; CHECK-NEXT:    (return_call $foo
 ;; CHECK-NEXT:     (local.get $2)
 ;; CHECK-NEXT:     (local.get $3)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (else
 ;; CHECK-NEXT:    (return_call $bar
 ;; CHECK-NEXT:     (local.get $2)
 ;; CHECK-NEXT:     (local.get $3)
 ;; CHECK-NEXT:    )
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $return_call_ref-to-select (param $x i32) (param $y i32)
  ;; As above, but with a return call. We optimize this too, and turn a
  ;; return_call_ref over a select into an if over return_calls.
  (return_call_ref $i32_i32_=>_none
   (local.get $x)
   (local.get $y)
   (select
    (ref.func $foo)
    (ref.func $bar)
    (call $get-i32)
   )
  )
 )

 ;; CHECK:      (func $get-i32 (type $none_=>_i32) (result i32)
 ;; CHECK-NEXT:  (i32.const 42)
 ;; CHECK-NEXT: )
 (func $get-i32 (result i32)
  ;; Helper for the above.
  (i32.const 42)
 )
)
