;; Tail-call conversion currently leaves exception-handling modules unchanged.

;; RUN: wasm-opt %s --tail-call --enable-tail-call --enable-exception-handling --enable-reference-types -S -o - | filecheck %s

(module
  (tag $exception)

  (func $callee
    (throw $exception)
  )

  ;; CHECK-LABEL: (func $caller
  ;; CHECK-NOT:   (return_call
  ;; CHECK:       (call $callee)
  ;; CHECK-NEXT: )
  (func $caller
    (block $catch
      (try_table (catch_all $catch)
        (call $callee)
      )
    )
  )
)