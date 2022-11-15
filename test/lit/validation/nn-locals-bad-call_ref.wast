;; Test for validation of non-nullable locals

;; RUN: not wasm-opt -all --enable-gc-nn-locals %s 2>&1 | filecheck %s

;; CHECK: non-nullable local must not read null

(module
  (tag $tag (param i32))
  (type $void (func))
  (func $func
    (local $0 (ref any))
    (try
      (do
        (call_ref $void
          (ref.func $func)
        )
      )
      (catch $tag
        (drop
          (pop (i32))
        )
        ;; The path to here is from a possible exception thrown in the call_ref.
        ;; This is a regression test for call_ref not being seen as possibly
        ;; throwing. We should see a validation error here, as the local.get is
        ;; of a null default, and it *is* reachable thanks to the call_ref.
        (drop
          (local.get $0)
        )
      )
    )
  )
)
