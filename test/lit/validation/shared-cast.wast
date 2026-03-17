;; RUN: not wasm-opt %s --all-features 2>&1 | filecheck %s

(module
  (type $shared (shared (struct)))
  (type $unshared (struct))

  (func $shared-to-unshared (param $s (ref $shared))
    ;; CHECK: [wasm-validator error in function shared-to-unshared] unexpected false: unreachable instruction must have unreachable child
    (drop
      (ref.cast (ref $unshared)
        (local.get $s)
      )
    )
  )

  (func $unshared-to-shared (param $u (ref $unshared))
    ;; CHECK: [wasm-validator error in function unshared-to-shared] unexpected false: unreachable instruction must have unreachable child
    (drop
      (ref.cast (ref $shared)
        (local.get $u)
      )
    )
  )

  (func $br_on_shared-to-unshared (param $s (ref $shared))
    (block $l (result (ref $unshared))
      ;; CHECK: [wasm-validator error in function br_on_shared-to-unshared] unexpected false: unreachable instruction must have unreachable child
      (drop
        (br_on_cast $l (ref $shared) (ref $unshared)
          (local.get $s)
        )
      )
      (unreachable)
    )
  )
)
