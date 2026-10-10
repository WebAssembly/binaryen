;; RUN: wasm-as %s --all-features -o %t.wasm
;; RUN: wasm-dis %t.wasm --all-features -o - | filecheck %s --check-prefix=FALLBACK
;; RUN: wasm-as %s --all-features -g -o %t.names.wasm
;; RUN: wasm-dis %t.names.wasm --all-features -o - | filecheck %s --check-prefix=EXPLICIT

;; Without a name section, use import and export names for internal names.
;; Explicit names from a name section continue to take priority.

(module
 (type $tag_type (func))
 (import "env" "import_func" (func $internal_import_func))
 (import "other" "import_func" (func $internal_second_import_func))
 (import "env" "import_table" (table $internal_import_table 1 funcref))
 (import "env" "import_memory" (memory $internal_import_memory 1))
 (import "env" "import_global" (global $internal_import_global i32))
 (import "env" "import_tag" (tag $internal_import_tag (type $tag_type)))
 (func $internal_export_func
  (export "export_func")
  (export "second_export_func")
 )
 (table $internal_export_table (export "export_table") 1 funcref)
 (memory $internal_export_memory
  (export "export_memory")
  (export "second_export_memory") 1)
 (memory $internal_colliding_memory (export "import_memory") 1)
 (global $internal_export_global (export "export_global") i32 (i32.const 0))
 (tag $internal_export_tag (export "export_tag") (type $tag_type))
)

;; FALLBACK:      (import "env" "import_memory" (memory $import_memory
;; FALLBACK:      (import "env" "import_table" (table $import_table
;; FALLBACK:      (import "env" "import_global" (global $import_global
;; FALLBACK:      (import "env" "import_func" (func $import_func
;; FALLBACK:      (import "other" "import_func" (func $import_func_1
;; FALLBACK:      (import "env" "import_tag" (tag $import_tag
;; FALLBACK:      (global $export_global
;; FALLBACK:      (memory $export_memory
;; FALLBACK:      (memory $import_memory_2
;; FALLBACK:      (table $export_table
;; FALLBACK:      (tag $export_tag
;; FALLBACK:      (export "export_func" (func $export_func))
;; FALLBACK:      (export "second_export_func" (func $export_func))
;; FALLBACK:      (export "export_table" (table $export_table))
;; FALLBACK:      (export "export_memory" (memory $export_memory))
;; FALLBACK:      (export "second_export_memory" (memory $export_memory))
;; FALLBACK:      (export "import_memory" (memory $import_memory_2))
;; FALLBACK:      (export "export_global" (global $export_global))
;; FALLBACK:      (export "export_tag" (tag $export_tag))
;; FALLBACK:      (func $export_func

;; EXPLICIT:      (import "env" "import_memory" (memory $internal_import_memory
;; EXPLICIT:      (import "env" "import_table" (table $internal_import_table
;; EXPLICIT:      (import "env" "import_global" (global $internal_import_global
;; EXPLICIT:      (import "env" "import_func" (func $internal_import_func
;; EXPLICIT:      (import "other" "import_func" (func $internal_second_import_func
;; EXPLICIT:      (import "env" "import_tag" (tag $internal_import_tag
;; EXPLICIT:      (global $internal_export_global
;; EXPLICIT:      (memory $internal_export_memory
;; EXPLICIT:      (memory $internal_colliding_memory
;; EXPLICIT:      (table $internal_export_table
;; EXPLICIT:      (tag $internal_export_tag
;; EXPLICIT:      (export "export_func" (func $internal_export_func))
;; EXPLICIT:      (export "second_export_func" (func $internal_export_func))
;; EXPLICIT:      (export "export_table" (table $internal_export_table))
;; EXPLICIT:      (export "export_memory" (memory $internal_export_memory))
;; EXPLICIT:      (export "second_export_memory" (memory $internal_export_memory))
;; EXPLICIT:      (export "import_memory" (memory $internal_colliding_memory))
;; EXPLICIT:      (export "export_global" (global $internal_export_global))
;; EXPLICIT:      (export "export_tag" (tag $internal_export_tag))
