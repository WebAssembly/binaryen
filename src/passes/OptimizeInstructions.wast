
;; This file contains patterns for OptimizeInstructions. Basically, we use a DSL for the patterns,
;; and the DSL is just wasm itself, plus some functions with special meanings
;;
;; This file is converted into OptimizeInstructions.wast.processed by
;;    scripts/process_optimize_instructions.py
;; which makes it importable by C++. Then we just #include it there, avoiding the need to ship
;; a data file on the side.

(module
  ;; "expr" represents an arbitrary expression. The input is an id, so the same expression
  ;; can appear more than once. The type (i32 in i32.expr, etc.) is the return type, as this
  ;; needs to have the right type for where it is placed.
  (import $i32.expr "dsl" "i32.expr" (param i32) (result i32))
  (import $i64.expr "dsl" "i64.expr" (param i32) (result i64))
  (import $f32.expr "dsl" "f32.expr" (param i32) (result f32))
  (import $f64.expr "dsl" "f64.expr" (param i32) (result f64))
  (import $any.expr "dsl" "any.expr" (param i32) (result i32)) ;; ignorable return type

  ;; main function. each block here is a pattern pair of input => output
  (func $patterns
    (block
      ;; flip if-else arms to get rid of an eqz
      (if
        (i32.eqz
          (call_import $i32.expr (i32.const 0))
        )
        (call_import $any.expr (i32.const 1))
        (call_import $any.expr (i32.const 2))
      )
      (if
        (call_import $i32.expr (i32.const 0))
        (call_import $any.expr (i32.const 2))
        (call_import $any.expr (i32.const 1))
      )
    )
    ;; De Morgans Laws
    (block
      (i32.eqz (i32.eq (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.ne (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.ne (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.eq (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.lt_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.ge_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.lt_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.ge_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.le_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.gt_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.le_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.gt_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.gt_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.le_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.gt_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.le_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.ge_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.lt_s (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i32.ge_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1))))
      (i32.lt_u (call_import $i32.expr (i32.const 0)) (call_import $i32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.eq (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.ne (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.ne (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.eq (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.lt_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.ge_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.lt_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.ge_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.le_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.gt_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.le_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.gt_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.gt_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.le_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.gt_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.le_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.ge_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.lt_s (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (i64.ge_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1))))
      (i64.lt_u (call_import $i64.expr (i32.const 0)) (call_import $i64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f32.eq (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1))))
      (f32.ne (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f32.ne (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1))))
      (f32.eq (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f32.lt (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1))))
      (f32.ge (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f32.le (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1))))
      (f32.gt (call_import $f32.expr (i32.const 0)) (call_import $f32.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f64.eq (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1))))
      (f64.ne (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f64.ne (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1))))
      (f64.eq (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f64.lt (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1))))
      (f64.ge (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1)))
    )
    (block
      (i32.eqz (f64.le (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1))))
      (f64.gt (call_import $f64.expr (i32.const 0)) (call_import $f64.expr (i32.const 1)))
    )
  )
)

