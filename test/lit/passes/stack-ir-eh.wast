;; RUN: wasm-opt %s --generate-stack-ir --optimize-stack-ir --print-stack-ir \
;; RUN:   -all -S -o - | filecheck %s

(module
  (tag $e0 (param i32))

  ;; CHECK:      (func $eh
  ;; CHECK-NEXT:  try $l0
  ;; CHECK-NEXT:   i32.const 0
  ;; CHECK-NEXT:   throw $e0
  ;; CHECK-NEXT:  catch $e0
  ;; CHECK-NEXT:
  ;; CHECK-NEXT:   drop
  ;; CHECK-NEXT:  catch_all
  ;; CHECK-NEXT:   rethrow $l0
  ;; CHECK-NEXT:  end
  ;; CHECK-NEXT:  try $l00
  ;; CHECK-NEXT:   try $try
  ;; CHECK-NEXT:    i32.const 0
  ;; CHECK-NEXT:    throw $e0
  ;; CHECK-NEXT:   delegate $l00
  ;; CHECK-NEXT:   unreachable
  ;; CHECK-NEXT:  catch_all
  ;; CHECK-NEXT:   nop
  ;; CHECK-NEXT:  end
  ;; CHECK-NEXT:  try $l01
  ;; CHECK-NEXT:   nop
  ;; CHECK-NEXT:  delegate 0
  ;; CHECK-NEXT: )
  (func $eh
    (try $l0
      (do
        (throw $e0 (i32.const 0))
      )
      (catch $e0
        (drop (pop i32))
      )
      (catch_all
        (rethrow $l0)
      )
    )

    (try $l0
      (do
        (try
          (do
            (throw $e0 (i32.const 0))
          )
          (delegate $l0)
        )
      )
      (catch_all)
    )

    (try $l0
      (do)
      (delegate 0) ;; delegate to caller
    )
  )
)
