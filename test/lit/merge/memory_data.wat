;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-merge %s first %s.second second --rename-export-conflicts -all -S -o - | filecheck %s

;; Test we rename memories and data segments properly at the module scope.
;; Memory $bar has a name collision, and both of the element segments' names.
;; This test verifies that data segments refer to the right tables even after
;; such name changes.

(module
  ;; CHECK:      (import "import" "mem" (memory $imported 10000))

  ;; CHECK:      (memory $foo 1)
  (memory $foo 1)

  ;; CHECK:      (memory $bar 10)
  (memory $bar 10)

  (memory $shared 10)

  ;; CHECK:      (memory $other 100)

  ;; CHECK:      (memory $bar_3 1000)

  ;; CHECK:      (data $a (offset (i32.const 0)) "a")
  (data $a (memory $foo) (i32.const 0) "a")

  ;; CHECK:      (data $b (memory $bar) (offset (i32.const 0)) "b")
  (data $b (memory $bar) (i32.const 0) "b")

  ;; CHECK:      (data $a_2 (memory $other) (offset (i32.const 0)) "a2")

  ;; CHECK:      (data $b_2 (memory $bar_3) (offset (i32.const 0)) "b2")

  ;; CHECK:      (export "keepalive" (memory $foo))
  (export "keepalive" (memory $foo))

  ;; CHECK:      (export "keepalive1" (memory $bar))
  (export "keepalive1" (memory $bar))

)
;; CHECK:      (export "keepalive_2" (memory $other))

;; CHECK:      (export "keepalive1_3" (memory $bar_3))

;; CHECK:      (export "keepalive2" (memory $imported))
