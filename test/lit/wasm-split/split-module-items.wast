;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=keep
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that
;; 1. Items only used in the primary module stay in the primary module
;; 2. Items only used in the secondary module are moved to the secondary module
;; 3. Items used in both modules are exported from the primary and imported from
;;    the secondary module

(module
 (memory $keep-memory 1 1)
 (global $keep-global i32 (i32.const 20))
 (table $keep-table 1 1 funcref)
 (tag $keep-tag (param i32))

 (memory $split-memory 1 1)
 (global $split-global i32 (i32.const 20))
 (table $split-table 1 1 funcref)
 (tag $split-tag (param i32))

 (memory $shared-memory 1 1)
 (global $shared-global i32 (i32.const 20))
 (table $shared-table 1 1 funcref)
 (tag $shared-tag (param i32))

 ;; PRIMARY:      (global $keep-global i32 (i32.const 20))
 ;; PRIMARY-NEXT: (global $shared-global i32 (i32.const 20))
 ;; PRIMARY-NEXT: (memory $keep-memory 1 1)
 ;; PRIMARY-NEXT: (memory $shared-memory 1 1)
 ;; PRIMARY-NEXT: (table $keep-table 1 1 funcref)
 ;; PRIMARY-NEXT: (table $shared-table 1 1 funcref)
 ;; PRIMARY-NEXT: (table $2 1 funcref)
 ;; PRIMARY:      (tag $keep-tag (type $1) (param i32))
 ;; PRIMARY-NEXT: (tag $shared-tag (type $1) (param i32))

 ;; PRIMARY:      (export "memory" (memory $shared-memory))
 ;; PRIMARY-NEXT: (export "table" (table $shared-table))
 ;; PRIMARY-NEXT: (export "global" (global $shared-global))
 ;; PRIMARY-NEXT: (export "tag" (tag $shared-tag))
 ;; PRIMARY-NEXT: (export "keep" (func $keep))
 ;; PRIMARY-NEXT: (export "table_5" (table $2))

 ;; SECONDARY:      (import "primary" "memory" (memory $shared-memory 1 1))
 ;; SECONDARY-NEXT: (import "primary" "table" (table $shared-table 1 1 funcref))
 ;; SECONDARY-NEXT: (import "primary" "table_5" (table $timport$1 1 funcref))
 ;; SECONDARY-NEXT: (import "primary" "global" (global $shared-global i32))
 ;; SECONDARY-NEXT: (import "primary" "keep" (func $keep (exact (param i32) (result i32))))
 ;; SECONDARY-NEXT: (import "primary" "tag" (tag $shared-tag (type $1) (param i32)))

 ;; SECONDARY:      (global $split-global i32 (i32.const 20))
 ;; SECONDARY-NEXT: (memory $split-memory 1 1)
 ;; SECONDARY-NEXT: (table $split-table 1 1 funcref)
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
  ;; Uses $split-table
  (drop
   (call_indirect $split-table (param i32) (result i32)
    (i32.const 0)
    (i32.const 0)
   )
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
