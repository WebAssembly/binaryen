;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --remove-unused-brs -all -S --shrink-level=0 -o - | filecheck %s --check-prefix=SHRINK_0
;; RUN: wasm-opt %s --remove-unused-brs -all -S --shrink-level=1 -o - | filecheck %s --check-prefix=SHRINK_1
;; RUN: wasm-opt %s --remove-unused-brs -all -S --shrink-level=2 -o - | filecheck %s --check-prefix=SHRINK_2


(module
  ;; SHRINK_0:      (func $selectify-division (type $0) (param $x i32) (result i32)
  ;; SHRINK_0-NEXT:  (if (result i32)
  ;; SHRINK_0-NEXT:   (i32.eq
  ;; SHRINK_0-NEXT:    (local.get $x)
  ;; SHRINK_0-NEXT:    (i32.const 53498923)
  ;; SHRINK_0-NEXT:   )
  ;; SHRINK_0-NEXT:   (i32.div_s
  ;; SHRINK_0-NEXT:    (local.get $x)
  ;; SHRINK_0-NEXT:    (i32.const 13)
  ;; SHRINK_0-NEXT:   )
  ;; SHRINK_0-NEXT:   (local.get $x)
  ;; SHRINK_0-NEXT:  )
  ;; SHRINK_0-NEXT: )
  ;; SHRINK_1:      (func $selectify-division (type $0) (param $x i32) (result i32)
  ;; SHRINK_1-NEXT:  (select
  ;; SHRINK_1-NEXT:   (i32.div_s
  ;; SHRINK_1-NEXT:    (local.get $x)
  ;; SHRINK_1-NEXT:    (i32.const 13)
  ;; SHRINK_1-NEXT:   )
  ;; SHRINK_1-NEXT:   (local.get $x)
  ;; SHRINK_1-NEXT:   (i32.eq
  ;; SHRINK_1-NEXT:    (local.get $x)
  ;; SHRINK_1-NEXT:    (i32.const 53498923)
  ;; SHRINK_1-NEXT:   )
  ;; SHRINK_1-NEXT:  )
  ;; SHRINK_1-NEXT: )
  ;; SHRINK_2:      (func $selectify-division (type $0) (param $x i32) (result i32)
  ;; SHRINK_2-NEXT:  (select
  ;; SHRINK_2-NEXT:   (i32.div_s
  ;; SHRINK_2-NEXT:    (local.get $x)
  ;; SHRINK_2-NEXT:    (i32.const 13)
  ;; SHRINK_2-NEXT:   )
  ;; SHRINK_2-NEXT:   (local.get $x)
  ;; SHRINK_2-NEXT:   (i32.eq
  ;; SHRINK_2-NEXT:    (local.get $x)
  ;; SHRINK_2-NEXT:    (i32.const 53498923)
  ;; SHRINK_2-NEXT:   )
  ;; SHRINK_2-NEXT:  )
  ;; SHRINK_2-NEXT: )
  (func $selectify-division (param $x i32) (result i32)
    ;; See #5983: this if, if turned into a select, becomes almost 5x slower.
    ;; We only want to selectify here when the shrink level is 1 or 2.
    (if (result i32)
      (i32.eq
        (local.get $x)
        (i32.const 53498923)
      )
      (i32.div_s
        (local.get $x)
        (i32.const 13)
      )
      (local.get $x)
    )
  )

  ;; SHRINK_0:      (func $selectify-division2 (type $0) (param $x i32) (result i32)
  ;; SHRINK_0-NEXT:  (if (result i32)
  ;; SHRINK_0-NEXT:   (i32.eq
  ;; SHRINK_0-NEXT:    (local.get $x)
  ;; SHRINK_0-NEXT:    (i32.const 53498923)
  ;; SHRINK_0-NEXT:   )
  ;; SHRINK_0-NEXT:   (i32.div_s
  ;; SHRINK_0-NEXT:    (i32.div_s
  ;; SHRINK_0-NEXT:     (local.get $x)
  ;; SHRINK_0-NEXT:     (i32.const 13)
  ;; SHRINK_0-NEXT:    )
  ;; SHRINK_0-NEXT:    (i32.const 13)
  ;; SHRINK_0-NEXT:   )
  ;; SHRINK_0-NEXT:   (local.get $x)
  ;; SHRINK_0-NEXT:  )
  ;; SHRINK_0-NEXT: )
  ;; SHRINK_1:      (func $selectify-division2 (type $0) (param $x i32) (result i32)
  ;; SHRINK_1-NEXT:  (if (result i32)
  ;; SHRINK_1-NEXT:   (i32.eq
  ;; SHRINK_1-NEXT:    (local.get $x)
  ;; SHRINK_1-NEXT:    (i32.const 53498923)
  ;; SHRINK_1-NEXT:   )
  ;; SHRINK_1-NEXT:   (i32.div_s
  ;; SHRINK_1-NEXT:    (i32.div_s
  ;; SHRINK_1-NEXT:     (local.get $x)
  ;; SHRINK_1-NEXT:     (i32.const 13)
  ;; SHRINK_1-NEXT:    )
  ;; SHRINK_1-NEXT:    (i32.const 13)
  ;; SHRINK_1-NEXT:   )
  ;; SHRINK_1-NEXT:   (local.get $x)
  ;; SHRINK_1-NEXT:  )
  ;; SHRINK_1-NEXT: )
  ;; SHRINK_2:      (func $selectify-division2 (type $0) (param $x i32) (result i32)
  ;; SHRINK_2-NEXT:  (select
  ;; SHRINK_2-NEXT:   (i32.div_s
  ;; SHRINK_2-NEXT:    (i32.div_s
  ;; SHRINK_2-NEXT:     (local.get $x)
  ;; SHRINK_2-NEXT:     (i32.const 13)
  ;; SHRINK_2-NEXT:    )
  ;; SHRINK_2-NEXT:    (i32.const 13)
  ;; SHRINK_2-NEXT:   )
  ;; SHRINK_2-NEXT:   (local.get $x)
  ;; SHRINK_2-NEXT:   (i32.eq
  ;; SHRINK_2-NEXT:    (local.get $x)
  ;; SHRINK_2-NEXT:    (i32.const 53498923)
  ;; SHRINK_2-NEXT:   )
  ;; SHRINK_2-NEXT:  )
  ;; SHRINK_2-NEXT: )
  (func $selectify-division2 (param $x i32) (result i32)
    ;; As above, but now only with a shrink level of 2 should we selectify, as
    ;; there are two divisions.
    (if (result i32)
      (i32.eq
        (local.get $x)
        (i32.const 53498923)
      )
      (i32.div_s
        (i32.div_s
          (local.get $x)
          (i32.const 13)
        )
        (i32.const 13)
      )
      (local.get $x)
    )
  )
)
