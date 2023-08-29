;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.

;; RUN: wasm-opt %s -g -o %s.wasm -osm %s.wasm.map
;; RUN: wasm-opt %s.wasm -ism %s.wasm.map -S -o - | filecheck %s

;; Verify that writing to a source map and reading it back does not "smear"
;; debug info across adjacent instructions. The debug info in the output should
;; be identical to the input.

(module
  ;; CHECK:      (func $test (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $test
  ;; CHECK-NEXT:    ;;@ waka:100:1
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  ;;@ waka:200:2
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT: )
  (func $test (param i32) (result i32)
    ;; This drop has on debug info, and should stay that way. Specifically the
    ;; instruction right before it in the binary (the const 1) should not
    ;; smear its debug info on it. And the drop is between an instruction that
    ;; has debug info (the const 1) and another (the i32.const 2): we should not
    ;; receive the debug info of either. (This is a regression test for a bug
    ;; that only happens in that state: removing the debug info either before or
    ;; after would avoid the bug.)
    (drop
      (call $test
        ;;@ waka:100:1
        (i32.const 1)
      )
    )
    ;;@ waka:200:2
    (i32.const 2)
  )

  ;; CHECK:      (func $same-later (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $test
  ;; CHECK-NEXT:    ;;@ waka:100:1
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  ;;@ waka:100:1
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT: )
  (func $same-later (param i32) (result i32)
    ;; As the first, but now the later debug info is also 100:1.
    (drop
      (call $test
        ;;@ waka:100:1
        (i32.const 1)
      )
    )
    ;;@ waka:100:1
    (i32.const 2)
  )

  ;; CHECK:      (func $more-before (param $0 i32) (result i32)
  ;; CHECK-NEXT:  ;;@ waka:50:5
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  ;;@ waka:50:5
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $test
  ;; CHECK-NEXT:    ;;@ waka:100:1
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  ;;@ waka:200:2
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT: )
  (func $more-before (param i32) (result i32)
    ;; As the first, but now there is more debug info before the 100:1 (the
    ;; very first debug info in a function has special handling, so we test it
    ;; more carefully).
    ;;
    ;; The s-parser actually smears 50:5 on the drop and call after it, so the
    ;; output here looks incorrect. This may be a bug there, TODO
    ;;@ waka:50:5
    (nop)
    (drop
      (call $test
        ;;@ waka:100:1
        (i32.const 1)
      )
    )
    ;;@ waka:200:2
    (i32.const 2)
  )

  ;; CHECK:      (func $nothing-before (param $0 i32) (result i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $test
  ;; CHECK-NEXT:    ;;@ waka:100:1
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  ;;@ waka:200:2
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT: )
  (func $nothing-before (param i32) (result i32)
    ;; As before, but no debug info on the nop before us (so the first
    ;; instruction in the function no longer has a debug annotation).
    (nop)
    (drop
      (call $test
        ;;@ waka:100:1
        (i32.const 1)
      )
    )
    ;;@ waka:200:2
    (i32.const 2)
  )
)
