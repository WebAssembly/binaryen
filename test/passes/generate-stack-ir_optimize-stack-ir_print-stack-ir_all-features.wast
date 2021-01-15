(module
  (event $e0 (attr 0) (param i32))

  (func $eh
    (try
      (do
        (throw $e0 (i32.const 0))
      )
      (catch $e0
        (drop (pop i32))
        (rethrow 0)
      )
    )
  )
)
