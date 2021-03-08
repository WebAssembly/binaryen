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
       ;; the binary writer must properly handle this delegate which is the
       ;; child of other try's, and not get confused by their information on the
       ;; stack (this is a regression test for us properly ending the scope with
       ;; a delegate and popping the relevant stack).
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

