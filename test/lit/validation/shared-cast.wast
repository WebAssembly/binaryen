;; RUN: not wasm-opt %s --all-features 2>&1 | filecheck %s

(module
  (type $shared (shared (struct)))
  (type $unshared (struct))

  (func $test-shared-to-unshared (param $s (ref $shared))
    ;; CHECK: [wasm-validator error in function test-shared-to-unshared] any != (shared any): ref.test target type and ref type must have a common supertype
    (drop
      (ref.test (ref $unshared)
        (local.get $s)
      )
    )
  )

  (func $cast-shared-to-unshared (param $s (ref $shared))
    ;; CHECK: [wasm-validator error in function cast-shared-to-unshared] any != (shared any): ref.cast target type and ref type must have a common supertype
    (drop
      (ref.cast (ref $unshared)
        (local.get $s)
      )
    )
  )

  (func $br_on_shared-to-unshared (param $s (ref $shared))
    (block $l (result (ref $unshared))
      ;; CHECK: [wasm-validator error in function br_on_shared-to-unshared] any != (shared any): br_on_cast* target type and ref type must have a common supertype
      (drop
        (br_on_cast $l (ref $shared) (ref $unshared)
          (local.get $s)
        )
      )
      (unreachable)
    )
  )
)
