;; RUN: wasm-as %s -o %t-❤.wasm --source-map %t-🗺️.map
;; RUN: cat %t-🗺️.map | filecheck %s --check-prefix SOURCEMAP
;; RUN: wasm-opt %t-❤.wasm -o %t-🤬.wasm --emit-spec-wrapper %t-❤.js --input-source-map %t-🗺️.map --output-source-map %t-🗺️.out.map
;; RUN: cat %t-🗺️.out.map | filecheck %s --check-prefix SOURCEMAP
;; RUN: wasm-dis %t-🤬.wasm | filecheck %s --check-prefix MODULE

;; MODULE: i32.add
;; SOURCEMAP: src.cpp

(module
 (type $i32_i32_=>_i32 (func (param i32 i32) (result i32)))
 (memory $0 256 256)
 (export "add" (func $add))
 (func $add (; 0 ;) (param $0 i32) (param $1 i32) (result i32)
  (i32.add
  ;;@ src.cpp:10:1
   (local.get $0)
   (local.get $1)
  )
 )
)
