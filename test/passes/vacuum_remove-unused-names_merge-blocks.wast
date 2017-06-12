(module
  ;; vacuum and remove-unused names leave us with a return at the top, and then
  ;; merge-blocks wants to move the first line of the block into an outer block
  ;; that then becomes the fallthrough of the function, so it must be properly typed.
  ;; and here the new last element is a return, with unreachable type, bad for a block
  ;; in that position
  (func $return-block (param $x i32) (result i32)
    (return
      (block (result i32)
        (set_local $x (get_local $x))
        (get_local $x)
      )
    )
  )
)

