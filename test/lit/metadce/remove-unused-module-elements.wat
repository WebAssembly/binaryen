;; RUN: wasm-metadce %s --graph-file %s.json -all -S -o - | filecheck %s

;; A testcase where after metadce removes things from the graph,
;; remove-unused-module-elements (which is run internally) manages to remove an
;; additional import. We should report that import is removed as well.

;; The export "used" is used, based on the graph file, while the other export
;; "unused" is not. Metadce itself can remove $unused. After that,
;; remove-unused-module-elements sees that no call_indirect exists that can
;; reach $A, even though it is in the table, and we can remove $A. Removing
;; $A then removes the import, which we should report.
(module
 (type $A (func))

 (import "module" "base" (func $import))

 (table $t 60 60 funcref)

 (elem $elem (table $t) (i32.const 0) func $A)

 (func $used (export "used")
  (drop
   (i32.const 42)
  )
 )

 (func $unused (export "unused")
  (call_indirect $t (type $A)
   (i32.const -1)
  )
 )

 (func $A (type $A)
  (call $import)
 )
)

;; CHECK: unused: export$unused
;; CHECK: unused: importId$import

