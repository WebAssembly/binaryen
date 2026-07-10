;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that
;; 1. Items only used in the primary module stay in the primary module
;; 2. Items only used in the secondary module are moved to the secondary module
;; 3. Items used in both modules are exported from the primary and imported from
;;    the secondary module

(module
 (rec
  (type $struct (descriptor $desc) (struct))
  (type $desc (describes $struct) (struct))
 )
 (global $null-desc (ref null none) (ref.null none))

 (memory $keep-memory 1 1)
 ;; This is only used in the secondary module, but segments $keep-data2 can trap
 ;; so it is pinned to the primary, so this will be too.
 (memory $keep-memory2 1 1)
 (global $keep-global i32 (i32.const 20))
 (table $keep-table 1 1 funcref)
 ;; This is only used in the secondary module, but segments $keep-elem2 and
 ;; $keep-elem3 can trap so they are pinned to the primary, so this will be too.
 (table $keep-table2 1 1 (ref null $struct))
 (tag $keep-tag (param i32))
 (elem $keep-elem1 (table $keep-table) (i32.const 0) funcref (item (ref.null nofunc)))
 ;; The offset is out-of-bounds and will trap, so keep it in the primary
 (elem $keep-elem2 (table $keep-table2) (i32.const 10) (ref null $struct) (item (ref.null none)))
 ;; The data can trap, so keep it in the primary
 (elem $keep-elem3 (table $keep-table2) (i32.const 0) (ref $struct) (item (struct.new_desc $struct (global.get $null-desc))))
 (data $keep-data1 (memory $keep-memory) (i32.const 0) "a")
 ;; The offset is out-of-bounds and will trap, so keep it in the primary
 (data $keep-data2 (memory $keep-memory2) (i32.const 65536) "a")

 (memory $split-memory 1 1)
 (global $split-global i32 (i32.const 20))
 (table $split-table 1 1 funcref)
 (tag $split-tag (param i32))
 (elem $split-elem (table $split-table) (i32.const 0) funcref (item (ref.null nofunc)))
 (data $split-data (memory $split-memory) (i32.const 0) "a")

 (memory $shared-memory 1 1)
 (global $shared-global i32 (i32.const 20))
 (table $shared-table 1 1 funcref)
 (tag $shared-tag (param i32))
 (elem $shared-elem (table $shared-table) (i32.const 0) funcref (item (ref.null nofunc)))
 (data $shared-data (memory $shared-memory) (i32.const 0) "a")

 ;; PRIMARY:      (global $keep-global i32 (i32.const 20))
 ;; PRIMARY-NEXT: (global $shared-global i32 (i32.const 20))
 ;; PRIMARY-NEXT: (memory $keep-memory 1 1)
 ;; PRIMARY-NEXT: (memory $keep-memory2 1 1)
 ;; PRIMARY-NEXT: (memory $shared-memory 1 1)
 ;; PRIMARY-NEXT: (data $keep-data1 (i32.const 0) "a")
 ;; PRIMARY-NEXT: (data $keep-data2 (memory $keep-memory2) (i32.const 65536) "a")
 ;; PRIMARY-NEXT: (data $shared-data (memory $shared-memory) (i32.const 0) "a")
 ;; PRIMARY-NEXT: (table $keep-table 1 1 funcref)
 ;; PRIMARY-NEXT: (table $keep-table2 1 1 (ref null $struct))
 ;; PRIMARY-NEXT: (table $shared-table 1 1 funcref)
 ;; PRIMARY-NEXT: (table $3 1 funcref)
 ;; PRIMARY-NEXT: (elem $keep-elem1 (table $keep-table) (i32.const 0) funcref (item (ref.null nofunc)))
 ;; PRIMARY-NEXT: (elem $keep-elem2 (table $keep-table2) (i32.const 10) (ref null $struct) (item (ref.null none)))
 ;; PRIMARY-NEXT: (elem $keep-elem3 (table $keep-table2) (i32.const 0) (ref $struct) (item (struct.new_default_desc $struct
 ;; PRIMARY-NEXT:  (global.get $null-desc)
 ;; PRIMARY-NEXT: )))
 ;; PRIMARY-NEXT: (elem $shared-elem (table $shared-table) (i32.const 0) funcref (item (ref.null nofunc)))
 ;; PRIMARY:      (tag $keep-tag (type $3) (param i32))
 ;; PRIMARY-NEXT: (tag $shared-tag (type $3) (param i32))

 ;; PRIMARY:      (export "memory" (memory $keep-memory2))
 ;; PRIMARY-NEXT: (export "memory_1" (memory $shared-memory))
 ;; PRIMARY-NEXT: (export "table" (table $keep-table2))
 ;; PRIMARY-NEXT: (export "table_3" (table $shared-table))
 ;; PRIMARY-NEXT: (export "global" (global $shared-global))
 ;; PRIMARY-NEXT: (export "tag" (tag $shared-tag))
 ;; PRIMARY-NEXT: (export "keep" (func $keep))
 ;; PRIMARY-NEXT: (export "table_7" (table $3))

 ;; SECONDARY:      (import "primary" "memory" (memory $keep-memory2 1 1))
 ;; SECONDARY-NEXT: (import "primary" "memory_1" (memory $shared-memory 1 1))
 ;; SECONDARY-NEXT: (import "primary" "table" (table $keep-table2 1 1 (ref null $2)))
 ;; SECONDARY-NEXT: (import "primary" "table_3" (table $shared-table 1 1 funcref))
 ;; SECONDARY-NEXT: (import "primary" "table_7" (table $timport$2 1 funcref))
 ;; SECONDARY-NEXT: (import "primary" "global" (global $shared-global i32))
 ;; SECONDARY-NEXT: (import "primary" "keep" (func $keep (exact (param i32) (result i32))))
 ;; SECONDARY-NEXT: (import "primary" "tag" (tag $shared-tag (type $1) (param i32)))

 ;; SECONDARY:      (global $split-global i32 (i32.const 20))
 ;; SECONDARY-NEXT: (memory $split-memory 1 1)
 ;; SECONDARY-NEXT: (data $split-data (memory $split-memory) (i32.const 0) "a")
 ;; SECONDARY-NEXT: (table $split-table 1 1 funcref)
 ;; SECONDARY-NEXT: (elem $split-elem (table $split-table) (i32.const 0) funcref (item (ref.null nofunc)))
 ;; SECONDARY:      (tag $split-tag (type $1) (param i32))

 (func $keep (param i32) (result i32)
  (call $split (i32.const 0))
  ;; Uses $keep-memory
  (drop
   (i32.load $keep-memory
    (i32.const 24)
   )
  )
  ;; Uses $keep-table
  (drop
   (call_indirect $keep-table (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
  )
  ;; Uses $keep-global
  (drop
   (global.get $keep-global)
  )
  ;; Uses $keep-tag
  (try_table (catch $keep-tag 0)
   (throw $keep-tag (i32.const 0))
  )
  ;; Uses $shared-memory
  (drop
   (i32.load $shared-memory
    (i32.const 24)
   )
  )
  ;; Uses $shared-table
  (drop
   (call_indirect $shared-table (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
  )
  ;; Uses $shared-global
  (drop
   (global.get $shared-global)
  )
  ;; Uses $shared-tag
  (try_table (catch $shared-tag 0)
   (throw $shared-tag (i32.const 0))
  )
  (i32.const 0)
 )

 (func $split (param i32) (result i32)
  (call $keep (i32.const 1))
  ;; Uses $split-memory
  (drop
   (i32.load $split-memory
    (i32.const 24)
   )
  )
  ;; Uses $keep-memory2
  (drop
   (i32.load $keep-memory2
    (i32.const 24)
   )
  )
  ;; Uses $split-table
  (drop
   (call_indirect $split-table (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
  )
  ;; Uses $keep-table2
  (drop
   (table.get $keep-table2 (i32.const 0))
  )
  ;; Uses $split-global
  (drop
   (global.get $split-global)
  )
  ;; Uses $split-tag
  (try_table (catch $split-tag 0)
   (throw $split-tag (i32.const 0))
  )
  ;; Uses $shared-memory
  (drop
   (i32.load $shared-memory
    (i32.const 24)
   )
  )
  ;; Uses $shared-table
  (drop
   (call_indirect $shared-table (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
  )
  ;; Uses $shared-global
  (drop
   (global.get $shared-global)
  )
  ;; Uses $shared-tag
  (try_table (catch $shared-tag 0)
   (throw $shared-tag (i32.const 0))
  )
  (i32.const 0)
 )
)
