(module
 (import "env" "memory" (memory $0 1))
 (table 0 anyfunc)
 (data (i32.const 16) "hE?\8ds\0e7\db[g\8f\955it\c4k\0b\e2\ef\bcld\e0\fd\8c\9e\86&~\d8\94\89+\c8\a4\c2\f2\fb\12\1cej\d99\b7\b3W\c6w\af\ae\caM>\92ub\96\84\b6\b0N\ec;q\11\f7\bf\e31\e6\a7\90\fc\03\e4\aa\d7\cc- \15\83DH\80r\fa\01X\eb:_\00A\cd\e9o`n\ac(\ad\ba0\dcyS#\f4$\"\82\7f}\8e\f6\93L\'\bb\bdZ\ed4\18\f3\c0\cf\ff\a3\f8\07\05\9c\d3\0f\a0\06m%\\\f9^B<\e7\b1\17\98]\0c\dd\c5\f5p\e5\fezJ\ab,F\a5@\08R\85!\b8\1a\ce\d5\04\nI\a6\d1\9f\8a\c9\a9|\97\9aG\be8Y\8b\c1\1b\d4\ea\b9\19\14\9b\9163\d0\1d\d2\df=C\1f\0dc\e1\c7QUv\02\b5aK\b4\tV\c3x\e8\a1\1e\81\de/{\da\d6Pf\10T\f0)\88\16\ee\a8\9d\f1\cbO*\b2\99\132\87.\a2")
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $stackSave (; 0 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 1 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 2 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 272, "initializers": [], "declares": [], "externs": [], "implementedFunctions": ["_stackSave","_stackAlloc","_stackRestore"], "exports": ["stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
