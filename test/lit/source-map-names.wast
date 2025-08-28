;; RUN: wasm-opt %s --remove-unused-module-elements -o %t.wasm -osm %t.map
;; RUN: wasm-dis %t.wasm --source-map %t.map | filecheck %s --check-prefix OUT-WAST
;; RUN: cat %t.map | filecheck %s --check-prefix OUT-MAP

;; After --remove-unused-module-elements, the output source map's 'names' field
;; should NOT contain 'unused'

;; OUT-MAP: "names":["used"]

(module
  (export "used" (func $used))

  (func $unused
    ;;@ src.cpp:1:1:unused
    (nop)
  )

  (func $used
    ;; OUT-WAST:      ;;@ src.cpp:2:1:used
    ;; OUT-WAST-NEXT: (nop)
    ;;@ src.cpp:2:1:used
    (nop)
  )
)
