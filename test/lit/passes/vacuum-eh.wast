;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --vacuum -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $void (func))
  (type $void (func))

  ;; CHECK:      (table $t 0 funcref)
  (table $t 0 funcref)

  ;; CHECK:      (tag $e (param i32))
  (tag $e (param i32))
  ;; CHECK:      (tag $e2 (param i32))
  (tag $e2 (param i32))

  ;; CHECK:      (func $try_table-test (type $void)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $try_table-test
    ;; When try_table body does not throw, the try_table can be replaced with
    ;; its body
    (block $tryend
      (drop
        (block $catch (result i32)
          (try_table (catch $e $catch)
            (drop (i32.const 0))
          )
          (br $tryend)
        )
      )
    )
  )

  ;; CHECK:      (func $inner-try_table-catch_all-test (type $2) (result i32)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (block $inner-catch
  ;; CHECK-NEXT:     (try_table (catch_all $inner-catch)
  ;; CHECK-NEXT:      (throw $e
  ;; CHECK-NEXT:       (i32.const 0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (return
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT: )
  (func $inner-try_table-catch_all-test (result i32)
    (local $0 i32)
    ;; The exception thrown in the inner try_table is caught by the inner
    ;; catch_all, so the outer try_table body does not throw and the outer
    ;; try_table can be removed
    (block $outer-tryend
      (drop
        (block $outer-catch (result i32)
          (try_table (catch $e $outer-catch)
            (block $inner-catch
              (try_table (catch_all $inner-catch)
                (throw $e (i32.const 0))
              )
              (unreachable)
            )
            (return (i32.const 1))
          )
          (br $outer-tryend)
        )
      )
    )
    (i32.const 2)
  )

  ;; CHECK:      (func $inner-try_table-catch-test (type $void)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (block $outer-tryend
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (block $outer-catch (result i32)
  ;; CHECK-NEXT:     (try_table (catch $e $outer-catch)
  ;; CHECK-NEXT:      (block $inner-tryend
  ;; CHECK-NEXT:       (drop
  ;; CHECK-NEXT:        (block $inner-catch (result i32)
  ;; CHECK-NEXT:         (try_table (catch $e $inner-catch)
  ;; CHECK-NEXT:          (throw $e2
  ;; CHECK-NEXT:           (i32.const 0)
  ;; CHECK-NEXT:          )
  ;; CHECK-NEXT:         )
  ;; CHECK-NEXT:        )
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:       (local.set $0
  ;; CHECK-NEXT:        (i32.const 1)
  ;; CHECK-NEXT:       )
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (br $outer-tryend)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $inner-try_table-catch-test (local $0 i32)
    ;; The exception thrown in the inner try_table will not be caught by the
    ;; inner catch, so the outer try_table cannot be removed.
    (block $outer-tryend
      (drop
        (block $outer-catch (result i32)
          (try_table (catch $e $outer-catch)
            (block $inner-tryend
              (drop
                (block $inner-catch (result i32)
                  (try_table (catch $e $inner-catch)
                    (throw $e2 (i32.const 0))
                  )
                  (br $inner-tryend)
                )
              )
              (local.set $0 (i32.const 1))
            )
          )
          (br $outer-tryend)
        )
      )
    )
  )

  ;; CHECK:      (func $br-in-catch (type $void)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $br-in-catch
    ;; When the try_table is removed, the removal of the implicit branch to the
    ;; catch target should be registered so that its type will be correctly
    ;; updated to unreachable.
    (drop
      (block $catch (result i32)
        (try_table (catch $e $catch)
          (unreachable)
        )
        (unreachable)
      )
    )
  )

  ;; CHECK:      (func $trivial-catch-all-of-throw (type $void)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch_all $catch)
  ;; CHECK-NEXT:    (throw $e
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block $catch0
  ;; CHECK-NEXT:   (try_table (catch_all $catch0)
  ;; CHECK-NEXT:    (if
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:     (then
  ;; CHECK-NEXT:      (throw $e
  ;; CHECK-NEXT:       (i32.const 0)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (else
  ;; CHECK-NEXT:      (unreachable)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $trivial-catch-all-of-throw (local $0 i32)
    ;; This try_table's body throws, but the catch_all catches it, so the entire
    ;; try_table could be optimized out. We do this for `try` but not yet for
    ;; `try_table`.
    (block $catch
      (try_table (catch_all $catch)
        (throw $e (i32.const 0))
      )
    )
    ;; Here we also have a possible trap, so we can't do it.
    (block $catch
      (try_table (catch_all $catch)
        (if
          (local.get $0)
          (then
            (throw $e (i32.const 0))
          )
          (else
            (unreachable)
          )
        )
      )
    )
  )

  ;; CHECK:      (func $throw (type $void)
  ;; CHECK-NEXT:  (throw $e
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $throw
    ;; Helper for the tail call tests below.
    (throw $e
      (i32.const 0)
    )
  )

  ;; CHECK:      (func $return-call-catch (type $void)
  ;; CHECK-NEXT:  (return_call $throw)
  ;; CHECK-NEXT: )
  (func $return-call-catch
    (block $catch
      (try_table (catch_all $catch)
        ;; This returns before it throws, so we can optimize out the surrounding
        ;; try_table.
        (return_call $throw)
      )
    )
  )

  ;; CHECK:      (func $return-call-indirect-catch (type $void)
  ;; CHECK-NEXT:  (return_call_indirect $t (type $void)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $return-call-indirect-catch
    (block $catch
      (try_table (catch_all $catch)
        ;; This returns before it throws, so we can optimize out the surrounding
        ;; try_table.
        (return_call_indirect
          (i32.const 0)
        )
      )
    )
  )

  ;; CHECK:      (func $return-call-ref-catch (type $void)
  ;; CHECK-NEXT:  (return_call_ref $void
  ;; CHECK-NEXT:   (ref.func $throw)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $return-call-ref-catch
    (block $catch
      (try_table (catch_all $catch)
        ;; This returns before it throws, so we can optimize out the surrounding
        ;; try_table.
        (return_call_ref $void
          (ref.func $throw)
        )
      )
    )
  )
)
