(module $Mem
  (memory (export "shared") 1 1 shared)
)

(thread $T2
  (assert_unlinkable
    (module (memory (import "mem" "shared") 1 1 shared))
    "unknown import"
  )
)

(wait $T2)

(thread $T4 (shared (module $Mem))
  (assert_unlinkable
    (module (memory (import "mem" "shared") 1 1 shared))
    "unknown import"
  )
)

(wait $T4)
