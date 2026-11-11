;; Test that misplaced pop instructions result in the expected parse errors

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s
;; RUN: foreach %s %t not wasm-shell 2>&1 | filecheck %s

;; CHECK: 3:5: error: pop instructions may only appear at the beginning of catch blocks
(module
  (func $empty-stack
    (pop i32)
  )
)

;; CHECK: 4:5: error: pop instructions may only appear at the beginning of catch blocks
(module
  (func $non-pop-on-stack
    (i32.const 0)
    (pop i32)
  )
)

;; CHECK: 5:9: error: pop instructions may only appear at the beginning of catch blocks
(module
  (func $in-try-body
    (try
      (do
        (pop i32)
      )
      (catch_all)
    )
  )
)

;; CHECK: 6:9: error: pop instructions may only appear at the beginning of catch blocks
(module
  (func $in-catch-all
    (try
      (do)
      (catch_all
        (pop i32)
      )
    )
  )
)

;; CHECK: 7:9: error: cannot pop from empty tag
(module
  (tag $e)
  (func $empty-tag-catch
    (try
      (do)
      (catch $e
        (pop i32)
      )
    )
  )
)

;; CHECK: 8:9: error: pop instructions may only appear at the beginning of catch blocks
(module
  (tag $e (param i32))
  (func $after-inst-in-catch
    (try
      (do)
      (catch $e
        (nop)
        (pop i32)
      )
    )
  )
)

;; CHECK: 8:11: error: pop instructions may only appear at the beginning of catch blocks
(module
  (tag $e (param i32))
  (func $in-named-block
    (try
      (do)
      (catch $e
        (block $b
          (pop i32)
        )
      )
    )
  )
)

;; CHECK: 8:11: error: pop instructions may only appear at the beginning of catch blocks
(module
  (tag $e (param i32))
  (func $in-loop
    (try
      (do)
      (catch $e
        (loop
          (pop i32)
        )
      )
    )
  )
)

;; CHECK: 7:9: error: Expected pop of type i32
(module
  (tag $e (param i32))
  (func $wrong-type
    (try
      (do)
      (catch $e
        (pop i64)
      )
    )
  )
)

;; CHECK: 7:9: error: Expected pop of type anyref
(module
  (tag $e (param anyref))
  (func $subtype
    (try
      (do)
      (catch $e
        (pop eqref)
      )
    )
  )
)

;; CHECK: 7:9: error: Expected pop of type eqref
(module
  (tag $e (param eqref))
  (func $supertype
    (try
      (do)
      (catch $e
        (pop anyref)
      )
    )
  )
)

;; CHECK: 8:11: error: pop instructions may only appear at the beginning of catch blocks
(module
  (tag $e (param i64))
  (func $in-mismatched-param-block
    (try
      (do)
      (catch $e
        (block (param i32)
          (pop i64)
        )
      )
    )
  )
)

;; CHECK: local.set's value type must be correct
(module
  (tag $e (param i64))
  (func $implicit-mismatched-param-block
    (try
      (do)
      (catch $e
        (block (param i32)
          (drop)
        )
      )
    )
  )
)

;; CHECK: block with value and last element with value must match types
(module
  (tag $e (param eqref))
  (func $implicit-supertype-param-block (result eqref)
    (try (result eqref)
      (do
        (ref.null eq)
      )
      (catch $e
        (block (param anyref) (result eqref))
      )
    )
  )
)
