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
 (func $globals
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
 (func $import_globals
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
 (func $globals_offset
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
 (func $import_globals_offset
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
)
;; METADATA: { "asmConsts": {},"staticBump": 24, "initializers": [] }
