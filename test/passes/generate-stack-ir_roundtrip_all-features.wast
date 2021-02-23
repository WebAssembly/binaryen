(module
 (event $event (attr 0) (param i32))
 (func $delegate-child
  (try
   (do
    (try
     (do)
     (catch $event
      (drop
       (pop i32)
      )
      (try
       (do)
       (delegate 2)
      )
     )
    )
   )
   (catch $event
    (drop
     (pop i32)
    )
   )
  )
 )
)

