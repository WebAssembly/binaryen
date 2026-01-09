
(module
  (func $test (param i32) (result i32)
    ;;@ waka:100:1
    (i32.const 42)
  )
)

;; 1. Generate a binary with a source map and url.
;;
;; RUN: wasm-opt %s -g -o %t.wasm -osm %t.wasm.map -osu=one
;; RUN: wasm-dis %t.wasm | filecheck %s --check-prefix=ONE

;; ONE:  ;; custom section "sourceMappingURL", size 4


;; 2. Round-trip that binary, again using -osu. This should not end up with two
;; sourceMappingURL sections (one could arrive from the flag, and one from the
;; existing custom section, if we copy it). Note the length increases, from
;; "one\0" (4) to "swap\0" (5), as we swap the URL.
;;
;; RUN: wasm-opt %t.wasm -o %t.wasm2 -ism %t.wasm.map -osm %t.wasm.map2 -osu=swap
;; RUN: wasm-dis %t.wasm2 | filecheck %s --check-prefix=SWAP

;; Look for a wrong section both before and after the correct one.

;; SWAP-NOT:  ;; custom section "sourceMappingURL", size 4
;; SWAP:  ;; custom section "sourceMappingURL", size 5
;; SWAP-NOT:  ;; custom section "sourceMappingURL"


;; 3. Round-trip without -osu. Now we just copy the old URL.
;;
;; RUN: wasm-opt %t.wasm2 -o %t.wasm3 -ism %t.wasm.map2 -osm %t.wasm.map3
;; RUN: wasm-dis %t.wasm3 | filecheck %s --check-prefix=ROUND

;; ROUND:  ;; custom section "sourceMappingURL", size 5

