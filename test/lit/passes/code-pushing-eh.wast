;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --code-pushing -all -S -o - | filecheck %s

;; The tests in this file test EffectAnalyzer, which is used by CodePushing.

(module
  ;; CHECK:      (tag $e (param i32))
  (tag $e (param i32))

  ;; CHECK:      (func $cannot-push-past-call (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (call $cannot-push-past-call)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br_if $out
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cannot-push-past-call
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because the call below can throw.
      (local.set $x (i32.const 1))
      (call $cannot-push-past-call)
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $cannot-push-past-throw (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (throw $e
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br_if $out
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cannot-push-past-throw
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because there is 'throw' below.
      ;; This pass only pushes past conditional control flow atm.
      (local.set $x (i32.const 1))
      (throw $e (i32.const 0))
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $can-push-past-try_table (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (block $tryend
  ;; CHECK-NEXT:    (block $catch
  ;; CHECK-NEXT:     (try_table (catch_all $catch)
  ;; CHECK-NEXT:      (throw $e
  ;; CHECK-NEXT:       (i32.const 0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (br $tryend)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br_if $out
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $can-push-past-try_table
    (local $x i32)
    (block $out
      ;; This local.set can be pushed down, because the 'throw' below is going
      ;; to be caught by the inner catch_all.
      (local.set $x (i32.const 1))
      (block $tryend
        (block $catch
          (try_table (catch_all $catch)
            (throw $e (i32.const 0))
          )
          (br $tryend)
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $foo (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $foo)

  ;; CHECK:      (func $cannot-push-past-try_table (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block $tryend
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (block $catch (result i32)
  ;; CHECK-NEXT:      (try_table (catch $e $catch)
  ;; CHECK-NEXT:       (call $foo)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (br $tryend)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br_if $out
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cannot-push-past-try_table
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because the exception thrown by
      ;; 'call $foo' below may not be caught by 'catch $e'.
      (local.set $x (i32.const 1))
      (block $tryend
        (drop
          (block $catch (result i32)
            (try_table (catch $e $catch)
              (call $foo)
            )
            (br $tryend)
          )
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $cannot-push-past-throw_ref-within-catch (type $0)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block $tryend
  ;; CHECK-NEXT:    (throw_ref
  ;; CHECK-NEXT:     (block $catch (result exnref)
  ;; CHECK-NEXT:      (try_table (catch_all_ref $catch)
  ;; CHECK-NEXT:       (throw $e
  ;; CHECK-NEXT:        (i32.const 0)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:      (br $tryend)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (br_if $out
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cannot-push-past-throw_ref-within-catch
    (local $x i32)
    (block $out
      ;; This local.set cannot be pushed down, because there is 'throw_ref'
      ;; within the catch handler.
      (local.set $x (i32.const 1))
      (block $tryend
        (throw_ref
          (block $catch (result exnref)
            (try_table (catch_all_ref $catch)
              (throw $e (i32.const 0))
            )
            (br $tryend)
          )
        )
      )
      (drop (i32.const 1))
      (br_if $out (i32.const 2))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $can-push-past-conditional-throw (type $1) (param $param i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (if
  ;; CHECK-NEXT:    (local.get $param)
  ;; CHECK-NEXT:    (then
  ;; CHECK-NEXT:     (throw $e
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $can-push-past-conditional-throw (param $param i32)
    (local $x i32)
    (block $block
      ;; We can push past an if containing a throw. The if is conditional
      ;; control flow, which is what we look for in this optimization, and a
      ;; throw is like a break - it will jump out of the current block - so we
      ;; can push the set past it, as the set is only needed in this block.
      (local.set $x (i32.const 1))
      (if
        (local.get $param)
        (then
          (throw $e (i32.const 0))
        )
      )
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $cannot-push-past-conditional-throw-extra-use (type $1) (param $param i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (block $block
  ;; CHECK-NEXT:   (local.set $x
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (if
  ;; CHECK-NEXT:    (local.get $param)
  ;; CHECK-NEXT:    (then
  ;; CHECK-NEXT:     (throw $e
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $cannot-push-past-conditional-throw-extra-use (param $param i32)
    (local $x i32)
    ;; As above, but now there is another local.get outside of the block. That
    ;; means the local.set cannot be pushed to a place it might not execute.
    (block $block
      (local.set $x (i32.const 1))
      (if
        (local.get $param)
        (then
          (throw $e (i32.const 0))
        )
      )
      (drop (local.get $x))
    )
    (drop (local.get $x))
  )
)
