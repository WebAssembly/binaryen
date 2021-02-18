(module
 (event $event$0 (attr 0) (param i32))
 (func $0
  (try $label$9 ;; needed due to a rethrow
   (do
   )
   (catch $event$0
    (try $label$8 ;; needed due to a delegate
     (do
      (try $label$6 ;; this one is not needed
       (do
        (rethrow $label$9)
       )
       (delegate $label$8)
      )
     )
     (catch $event$0
      (drop
       (pop i32)
      )
     )
    )
   )
  )
 )
)
