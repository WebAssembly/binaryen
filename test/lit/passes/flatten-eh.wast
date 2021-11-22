;; RUN: wasm-opt %s --flatten -all -S -o - | filecheck %s

(module
  (tag $e-i32 (param i32))
  (tag $e-f32 (param f32))

  ;; Basic try-catch test
  (func $try_catch (local $x i32)
    (try
      (do
        (throw $e-i32 (i32.const 0))
      )
      (catch $e-i32
        (drop
          (pop i32)
        )
      )
      (catch $e-f32
        (drop
          (pop f32)
        )
      )
    )
  )

  ;; After --flatten, a block is created within 'catch', which makes the pops'
  ;; location invalid. This tests whether 'EHUtils::handleBlockNestedPops' fixes
  ;; that correctly after --flatten.
  (func $try_catch_br
    (block $l0
      (try
        (do)
        (catch $e-i32
          (drop
            (pop i32)
          )
          (br $l0)
        )
        (catch $e-f32
          (drop
            (pop f32)
          )
          (br $l0)
        )
      )
    )
  )
)
