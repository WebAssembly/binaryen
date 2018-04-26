(module
 (type $FUNCSIG$i (func (result i32)))
 (type $FUNCSIG$v (func))
 (type $FUNCSIG$iiii (func (param i32 i32 i32) (result i32)))
 (import "env" "block_tail_dup" (func $block_tail_dup))
 (import "env" "def" (func $def (result i32)))
 (import "env" "memcpy" (func $memcpy (param i32 i32 i32) (result i32)))
 (import "env" "memmove" (func $memmove (param i32 i32 i32) (result i32)))
 (import "env" "memset" (func $memset (param i32 i32 i32) (result i32)))
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 4) "\10\04\00\00")
 (export "copy_yes" (func $copy_yes))
 (export "copy_no" (func $copy_no))
 (export "move_yes" (func $move_yes))
 (export "move_no" (func $move_no))
 (export "set_yes" (func $set_yes))
 (export "set_no" (func $set_no))
 (export "frame_index" (func $frame_index))
 (export "drop_result" (func $drop_result))
 (export "tail_dup_to_reuse_result" (func $tail_dup_to_reuse_result))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $copy_yes (; 5 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (call $memcpy
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
 )
 (func $copy_no (; 6 ;) (param $0 i32) (param $1 i32) (param $2 i32)
  (drop
   (call $memcpy
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
  (return)
 )
 (func $move_yes (; 7 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (call $memmove
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
 )
 (func $move_no (; 8 ;) (param $0 i32) (param $1 i32) (param $2 i32)
  (drop
   (call $memmove
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
  (return)
 )
 (func $set_yes (; 9 ;) (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (return
   (call $memset
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
 )
 (func $set_no (; 10 ;) (param $0 i32) (param $1 i32) (param $2 i32)
  (drop
   (call $memset
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
  (return)
 )
 (func $frame_index (; 11 ;)
  (local $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $0
    (i32.sub
     (i32.load offset=4
      (i32.const 0)
     )
     (i32.const 4096)
    )
   )
  )
  (drop
   (call $memset
    (i32.add
     (get_local $0)
     (i32.const 2048)
    )
    (i32.const 0)
    (i32.const 1024)
   )
  )
  (i32.store offset=4
   (i32.const 0)
   (i32.add
    (call $memset
     (get_local $0)
     (i32.const 0)
     (i32.const 1024)
    )
    (i32.const 4096)
   )
  )
  (return)
 )
 (func $drop_result (; 12 ;) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (result i32)
  (block $label$0
   (block $label$1
    (block $label$2
     (br_if $label$2
      (i32.eqz
       (get_local $3)
      )
     )
     (set_local $0
      (call $def)
     )
     (br $label$1)
    )
    (br_if $label$0
     (i32.eqz
      (get_local $4)
     )
    )
   )
   (call $block_tail_dup)
   (return
    (get_local $0)
   )
  )
  (drop
   (call $memset
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
  (call $block_tail_dup)
  (return
   (get_local $0)
  )
 )
 (func $tail_dup_to_reuse_result (; 13 ;) (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (result i32)
  (block $label$0
   (block $label$1
    (block $label$2
     (br_if $label$2
      (i32.eqz
       (get_local $3)
      )
     )
     (set_local $0
      (call $def)
     )
     (br $label$1)
    )
    (br_if $label$0
     (i32.eqz
      (get_local $4)
     )
    )
   )
   (return
    (get_local $0)
   )
  )
  (return
   (call $memset
    (get_local $0)
    (get_local $1)
    (get_local $2)
   )
  )
 )
 (func $stackSave (; 14 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 15 ;) (param $0 i32) (result i32)
  (local $1 i32)
  (i32.store offset=4
   (i32.const 0)
   (tee_local $1
    (i32.and
     (i32.sub
      (i32.load offset=4
       (i32.const 0)
      )
      (get_local $0)
     )
     (i32.const -16)
    )
   )
  )
  (get_local $1)
 )
 (func $stackRestore (; 16 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 1040, "initializers": [], "declares": ["block_tail_dup","def","memcpy","memmove","memset"], "externs": [], "implementedFunctions": ["_copy_yes","_copy_no","_move_yes","_move_no","_set_yes","_set_no","_frame_index","_drop_result","_tail_dup_to_reuse_result","_stackSave","_stackAlloc","_stackRestore"], "exports": ["copy_yes","copy_no","move_yes","move_no","set_yes","set_no","frame_index","drop_result","tail_dup_to_reuse_result","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
