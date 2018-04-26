(module
 (import "env" "memory" (memory $0 1))
 (import "env" "imported_global" (global $imported_global i32))
 (table 0 anyfunc)
 (data (i32.const 12) "\11\00\00\00")
 (data (i32.const 16) "\0c\00\00\00")
 (data (i32.const 20) "\0e\00\00\00")
 (export "globals" (func $globals))
 (export "import_globals" (func $import_globals))
 (export "globals_offset" (func $globals_offset))
 (export "import_globals_offset" (func $import_globals_offset))
 (export "stackSave" (func $stackSave))
 (export "stackAlloc" (func $stackAlloc))
 (export "stackRestore" (func $stackRestore))
 (func $globals (; 0 ;)
  (i32.store offset=12
   (i32.const 0)
   (i32.const 7)
  )
  (drop
   (i32.load offset=12
    (i32.const 0)
   )
  )
  (drop
   (i32.const 12)
  )
 )
 (func $import_globals (; 1 ;)
  (i32.store
   (get_global $imported_global)
   (i32.const 7)
  )
  (drop
   (i32.load
    (get_global $imported_global)
   )
  )
  (drop
   (get_global $imported_global)
  )
 )
 (func $globals_offset (; 2 ;)
  (i32.store offset=24
   (i32.const 4)
   (i32.const 7)
  )
  (drop
   (i32.load offset=8
    (i32.const 8)
   )
  )
  (drop
   (i32.const 28)
  )
 )
 (func $import_globals_offset (; 3 ;)
  (i32.store offset=12
   (i32.add
    (i32.const 4)
    (get_global $imported_global)
   )
   (i32.const 7)
  )
  (drop
   (i32.load
    (i32.add
     (i32.const 8)
     (i32.add
      (i32.const -4)
      (get_global $imported_global)
     )
    )
   )
  )
  (drop
   (i32.add
    (i32.const 16)
    (get_global $imported_global)
   )
  )
 )
 (func $stackSave (; 4 ;) (result i32)
  (i32.load offset=4
   (i32.const 0)
  )
 )
 (func $stackAlloc (; 5 ;) (param $0 i32) (result i32)
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
 (func $stackRestore (; 6 ;) (param $0 i32)
  (i32.store offset=4
   (i32.const 0)
   (get_local $0)
  )
 )
)
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [], "declares": [], "externs": ["_imported_global"], "implementedFunctions": ["_globals","_import_globals","_globals_offset","_import_globals_offset","_stackSave","_stackAlloc","_stackRestore"], "exports": ["globals","import_globals","globals_offset","import_globals_offset","stackSave","stackAlloc","stackRestore"], "invokeFuncs": [] }
