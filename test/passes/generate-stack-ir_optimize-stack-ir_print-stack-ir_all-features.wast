(module
  (event $e0 (attr 0) (param i32))

  (func $eh
    (try
      (do
        (throw $e0 (i32.const 0))
      )
      (catch $e0
        (drop (pop i32))
      )
      (catch_all
        (rethrow 0)
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
