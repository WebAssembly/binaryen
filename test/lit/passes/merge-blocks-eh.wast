;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s -all --merge-blocks -all -S -o - | filecheck %s

(module
  ;; CHECK:      (import "a" "b" (func $import (type $0)))
  (import "a" "b" (func $import))

  ;; CHECK:      (tag $empty)
  (tag $empty)

  ;; CHECK:      (tag $i32 (param i32))
  (tag $i32 (param i32))

  ;; CHECK:      (func $drop-block-try_catch_all_ref (type $0)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch_all $catch)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_all_ref
    ;; This block is dropped, so the try_table's exnref value can be removed
    ;; by replacing catch_all_ref with catch_all.
    (drop
      (block $catch (result exnref)
        (try_table (catch_all_ref $catch)
          (call $import)
          (unreachable)
        )
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_ref (type $0)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch $empty $catch)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_ref
    ;; As above, but with catch_ref instead of catch_all_ref. We can still
    ;; optimize.
    (drop
      (block $catch (result exnref)
        (try_table (catch_ref $empty $catch)
          (call $import)
          (unreachable)
        )
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_multi (type $0)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch $empty $catch) (catch_all $catch)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_multi
    ;; As above, but with two catches, both of whom can be optimized.
    (drop
      (block $catch (result exnref)
        (try_table (catch_ref $empty $catch) (catch_all_ref $catch)
          (call $import)
          (unreachable)
        )
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_all_i32 (type $0)
  ;; CHECK-NEXT:  (tuple.drop 2
  ;; CHECK-NEXT:   (block $catch (type $1) (result i32 exnref)
  ;; CHECK-NEXT:    (try_table (catch_ref $i32 $catch)
  ;; CHECK-NEXT:     (call $import)
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_all_i32
    ;; Send a tag value + exnref. We don't handle this yet TODO
    (tuple.drop 2
      (block $catch (result i32 exnref)
        (try_table (catch_ref $i32 $catch)
          (call $import)
          (unreachable)
        )
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_multi_partial (type $0)
  ;; CHECK-NEXT:  (tuple.drop 2
  ;; CHECK-NEXT:   (block $outer (type $1) (result i32 exnref)
  ;; CHECK-NEXT:    (block $inner
  ;; CHECK-NEXT:     (try_table (catch_ref $i32 $outer) (catch_all $inner)
  ;; CHECK-NEXT:      (call $import)
  ;; CHECK-NEXT:      (unreachable)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_multi_partial
    ;; Two possible tags can be thrown and caught, and we can optimize one.
    (tuple.drop 2
      (block $outer (result i32 exnref)
        (drop
          (block $inner (result exnref)
            (try_table (catch_ref $i32 $outer) (catch_all_ref $inner)
              (call $import)
              (unreachable)
            )
          )
        )
        (unreachable)
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_all (type $0)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch_all $catch)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_all
    ;; Without _ref, there is nothing to optimize (and we should not error).
    (block $catch
      (try_table (catch_all $catch)
        (call $import)
        (unreachable)
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch (type $0)
  ;; CHECK-NEXT:  (block $catch
  ;; CHECK-NEXT:   (try_table (catch $empty $catch)
  ;; CHECK-NEXT:    (call $import)
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch
    ;; As above, without _all.
    (block $catch
      (try_table (catch $empty $catch)
        (call $import)
        (unreachable)
      )
    )
  )

  ;; CHECK:      (func $drop-block-try_catch_i32 (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $catch (result i32)
  ;; CHECK-NEXT:    (try_table (catch $i32 $catch)
  ;; CHECK-NEXT:     (call $import)
  ;; CHECK-NEXT:     (unreachable)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-block-try_catch_i32
    ;; Send an i32 without a ref. We can't optimize here, as we can't prevent
    ;; the i32 from being sent.
    (drop
      (block $catch (result i32)
        (try_table (catch $i32 $catch)
          (call $import)
          (unreachable)
        )
      )
    )
  )
)

