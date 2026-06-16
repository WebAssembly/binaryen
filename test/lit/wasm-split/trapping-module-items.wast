;; RUN: wasm-split %s -all -g -o1 %t.1.wasm -o2 %t.2.wasm --split-funcs=split
;; RUN: wasm-dis -all %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-split %s -all -g -o1 %t.tnh.1.wasm -o2 %t.tnh.2.wasm --split-funcs=split --traps-never-happen
;; RUN: wasm-dis -all %t.tnh.1.wasm | filecheck %s --check-prefix PRIMARY-TNH

;; These unused global and table should NOT be removed by wasm-split because
;; their initializer contains a side effect (a trap due to a null descriptor).
;; However, if we pass --traps-never-happen, we assume traps never occur, so the
;; global will be considered to have no side effects and will be removed.
(module
 (rec
  (type $struct (descriptor $desc) (struct))
  (type $desc (describes $struct) (struct))
 )
 ;; PRIMARY:         (global $trapping-global (ref $struct)
 ;; PRIMARY-TNH-NOT: (global $trapping-global (ref $struct)
 (global $trapping-global (ref $struct)
  (struct.new_desc $struct
   (ref.null none)
  )
 )

 ;; PRIMARY:         (global $null-desc nullref
 ;; PRIMARY-TNH-NOT: (global $null-desc nullref
 (global $null-desc (ref null none)
  (ref.null none)
 )

 ;; PRIMARY:         (global $trapping-global-init-global-get (ref $struct)
 ;; PRIMARY-TNH-NOT: (global $trapping-global-init-global-get (ref $struct)
 (global $trapping-global-init-global-get (ref $struct)
  (struct.new_desc $struct
   (global.get $null-desc)
  )
 )

 ;; PRIMARY:         (table $trapping-table 1 1 (ref $struct)
 ;; PRIMARY-TNH-NOT: (table $trapping-table 1 1 (ref $struct)
 (table $trapping-table 1 1 (ref $struct)
  (struct.new_desc $struct
   (ref.null none)
  )
 )

 (func $split)
)
