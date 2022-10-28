(module
  (tag $e-i32 (param i32))
  (tag $e-i64 (param i64))
  (tag $e-i32-i64 (param i32 i64))
  (tag $e-eqref (param (ref null eq)))
  (tag $e-empty)

  (func $foo)
  (func $bar)

  (func $eh-test (local $x (i32 i64))
    ;; Simple try-catch
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
    )

    ;; try-catch with multivalue tag
    (try
      (do
        (throw $e-i32-i64 (i32.const 0) (i64.const 0))
      )
      (catch $e-i32-i64
        (local.set $x (pop i32 i64))
        (drop
          (tuple.extract 0
            (local.get $x)
          )
        )
      )
    )

    ;; Try with a block label
    (try $l1
      (do
        (br $l1)
      )
      (catch $e-i32
        (drop (pop i32))
        (br $l1)
      )
    )

    ;; Empty try body
    (try
      (do)
      (catch $e-i32
        (drop (pop i32))
      )
    )

    ;; Multiple instructions within try and catch bodies
    (try
      (do
        (call $foo)
        (call $bar)
      )
      (catch $e-i32
        (drop (pop i32))
        (call $foo)
        (call $bar)
      )
    )

    ;; Multiple catch clauses
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
      (catch $e-i64
        (drop (pop i64))
      )
    )

    ;; Single catch-all clause
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch_all)
    )

    ;; catch and catch-all clauses together
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop (pop i32))
      )
      (catch $e-i64
        (drop (pop i64))
      )
      (catch_all
        (call $foo)
        (call $bar)
      )
    )

    ;; nested try-catch
    (try
      (do
        (try
          (do
            (throw $e-i32 (i32.const 0))
          )
          (catch $e-i32
            (drop (pop i32))
          )
          (catch_all)
        )
      )
      (catch $e-i32
        (drop (pop i32))
      )
      (catch_all
        (try
          (do
            (throw $e-i32 (i32.const 0))
          )
          (catch $e-i32
            (drop (pop i32))
          )
          (catch_all)
        )
      )
    )

    ;; try without catch or delegate
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
    )
  )

  (func $delegate-test
    ;; Inner delegates target an outer catch
    (try $l0
      (do
        (try
          (do
            (call $foo)
          )
          (delegate $l0) ;; by label
        )
        (try
          (do
            (call $foo)
          )
          (delegate 0) ;; by depth
        )
      )
      (catch_all)
    )

    ;; When there are both a branch and a delegate that target the same try
    ;; label. Because binaryen only allows blocks and loops to be targetted by
    ;; branches, we wrap the try with a block and make branches that block
    ;; instead, resulting in the br and delegate target different labels in the
    ;; output.
    (try $l0
      (do
        (try
          (do
            (br_if $l0 (i32.const 1))
          )
          (delegate $l0) ;; by label
        )
        (try
          (do
            (br_if $l0 (i32.const 1))
          )
          (delegate 0) ;; by depth
        )
      )
      (catch_all)
    )

    ;; The inner delegate targets the outer delegate, which in turn targets the
    ;; caller.
    (try $l0
      (do
        (try
          (do
            (call $foo)
          )
          (delegate $l0)
        )
      )
      (delegate 0)
    )

    ;; 'catch' body can be empty when the tag's type is none.
    (try
      (do)
      (catch $e-empty)
    )
  )

  (func $rethrow-test
    ;; Simple try-catch-rethrow
    (try $l0
      (do
        (call $foo)
      )
      (catch $e-i32
        (drop (pop i32))
        (rethrow $l0) ;; by label
      )
      (catch_all
        (rethrow 0) ;; by depth
      )
    )

    ;; When there are both a branch and a rethrow that target the same try
    ;; label. Because binaryen only allows blocks and loops to be targetted by
    ;; branches, we wrap the try with a block and make branches that block
    ;; instead, resulting in the br and rethrow target different labels in the
    ;; output.
    (try $l0
      (do
        (call $foo)
      )
      (catch $e-i32
        (drop (pop i32))
        (rethrow $l0)
      )
      (catch_all
        (br $l0)
      )
    )

    ;; One more level deep
    (try $l0
      (do
        (call $foo)
      )
      (catch_all
        (try
          (do
            (call $foo)
          )
          (catch $e-i32
            (drop (pop i32))
            (rethrow $l0) ;; by label
          )
          (catch_all
            (rethrow 1) ;; by depth
          )
        )
      )
    )

    ;; Interleaving block
    (try $l0
      (do
        (call $foo)
      )
      (catch_all
        (try
          (do
            (call $foo)
          )
          (catch $e-i32
            (drop (pop i32))
            (block $b0
              (rethrow $l0) ;; by label
            )
          )
          (catch_all
            (block $b1
              (rethrow 2) ;; by depth
            )
          )
        )
      )
    )

    ;; Within nested try, but rather in 'try' part and not 'catch'
    (try $l0
      (do
        (call $foo)
      )
      (catch_all
        (try
          (do
            (rethrow $l0) ;; by label
          )
          (catch_all)
        )
      )
    )
    (try $l0
      (do
        (call $foo)
      )
      (catch_all
        (try
          (do
            (rethrow 1) ;; by depth
          )
          (catch_all)
        )
      )
    )
  )

  (func $pop-test
    (try
      (do)
      (catch $e-i32
        (throw $e-i32
          (if (result i32)
            ;; pop is within an if condition, so this is OK.
            (pop i32)
            (i32.const 0)
            (i32.const 3)
          )
        )
      )
    )

    (try
      (do)
      (catch $e-eqref
        (drop
          (pop anyref) ;; pop can be supertype
        )
      )
    )
  )

  (func $catchless-try-with-inner-delegate
    (try $label$0
      (do
        (try
          (do
            (throw $e-i32
              (i32.const 0)
            )
          )
          (delegate $label$0)
        )
      )
    )
  )

  ;; When 'delegate' is next to a nested block, make sure its delegate argument
  ;; is parsed correctly.
  (func $nested-block-and-try
    (block $l0
      (block $l1)
      (try
        (do)
        (delegate 1) ;; to caller
      )
    )
    (nop)
  )
)
