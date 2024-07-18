;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; Test optimization decisions while varying the minimum benefit percentage
;; parameter. Zero means any benefit, no matter how small, is worthwhile, while
;; higher values demand more benefit before doing any work.

;; RUN: foreach %s %t wasm-opt --monomorphize                                -all -S -o - | filecheck %s --check-prefix DEFAULT
;; RUN: foreach %s %t wasm-opt --monomorphize --monomorphize-min-benefit=0   -all -S -o - | filecheck %s --check-prefix ZERO___
;; RUN: foreach %s %t wasm-opt --monomorphize --monomorphize-min-benefit=33  -all -S -o - | filecheck %s --check-prefix THIRD__
;; RUN: foreach %s %t wasm-opt --monomorphize --monomorphize-min-benefit=66  -all -S -o - | filecheck %s --check-prefix 2THIRDS
;; RUN: foreach %s %t wasm-opt --monomorphize --monomorphize-min-benefit=100 -all -S -o - | filecheck %s --check-prefix HUNDRED

(module
  (import "a" "b" (func $import (param i32)))

  (func $target (param $a i32) (param $b i32) (param $c i32) (param $d i32) (param $e i32)
    ;; This function takes five parameters and uses each one to do some work. In
    ;; Each of the following identical calls, when we know one of the five
    ;; params, we can compute in full the value sent to the import.
    (call $import
      (i32.div_s
        (local.get $a)
        (i32.add
          (local.get $a)
          (i32.const 1)
        )
      )
    )
    (call $import
      (i32.div_s
        (local.get $b)
        (i32.add
          (local.get $b)
          (i32.const 1)
        )
      )
    )
    (call $import
      (i32.div_s
        (local.get $c)
        (i32.add
          (local.get $c)
          (i32.const 1)
        )
      )
    )
    (call $import
      (i32.div_s
        (local.get $d)
        (i32.add
          (local.get $d)
          (i32.const 1)
        )
      )
    )
    (call $import
      (i32.div_s
        (local.get $e)
        (i32.add
          (local.get $e)
          (i32.const 1)
        )
      )
    )
  )

  (func $calls (param $x i32)
    ;; Call the target with an increasing amount of non-constant params, 0-5.
    (call $target
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
    )
    (call $target
      (local.get $x)
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
    )
    (call $target
      (local.get $x)
      (local.get $x)
      (i32.const 42)
      (i32.const 42)
      (i32.const 42)
    )
    (call $target
      (local.get $x)
      (local.get $x)
      (local.get $x)
      (i32.const 42)
      (i32.const 42)
    )
    (call $target
      (local.get $x)
      (local.get $x)
      (local.get $x)
      (local.get $x)
      (i32.const 42)
    )
    (call $target
      (local.get $x)
      (local.get $x)
      (local.get $x)
      (local.get $x)
      (local.get $x)
    )
  )
)
