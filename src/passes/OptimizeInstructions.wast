
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

  ;; TODO for now wasm is not that convenient for a DSL like this. Needs rethinking.

  (func $patterns
    (block
    )
  )
)

