(module
 (type $0 (func (param i32 i32 i32 i32 i32 i32)))
 (import "env" "table" (table $timport$0 6 funcref))
 (func $0 (; 0 ;) (type $0) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (param $5 i32)
  (if
   (i32.ne
    (i32.const 0)
    (i32.const 48)
   )
   (block $label$2
    (br_if $label$2
     (i32.const 0)
    )
    (unreachable)
   )
   (unreachable)
  )
  (unreachable)
 )
)

