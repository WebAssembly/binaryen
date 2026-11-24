;; RUN: wasm2js %s -O --enable-bulk-memory | filecheck %s
;; RUN: wasm-opt %s --optimize-instructions --enable-bulk-memory -S -o - | filecheck %s --check-prefix=OPT

(module
 (memory 1 1)

 (func $fill_1 (export "fill_1") (param $d i32)
  ;; 1-byte fills have natural alignment and i32 type, so they still lower to
  ;; a byte store in wasm2js -O.
  (memory.fill
   (local.get $d)
   (i32.const 42)
   (i32.const 1)
  )
 )

 (func $fill_4 (export "fill_4") (param $d i32)
  ;; Multi-byte fills must not lower to align=1 stores in wasm2js -O.
  (memory.fill
   (local.get $d)
   (i32.const 0)
   (i32.const 4)
  )
 )

 (func $fill_8 (export "fill_8") (param $d i32)
  ;; 8-byte fills must not lower to align=1 i64 stores in wasm2js -O.
  (memory.fill
   (local.get $d)
   (i32.const 0)
   (i32.const 8)
  )
 )

 (func $copy_1 (export "copy_1") (param $d i32) (param $s i32)
  ;; 1-byte copies still lower to byte load/store in wasm2js -O.
  (memory.copy
   (local.get $d)
   (local.get $s)
   (i32.const 1)
  )
 )

 (func $copy_4 (export "copy_4") (param $d i32) (param $s i32)
  ;; Multi-byte copies must not lower to align=1 loads/stores in wasm2js -O.
  (memory.copy
   (local.get $d)
   (local.get $s)
   (i32.const 4)
  )
 )

 (func $copy_8 (export "copy_8") (param $d i32) (param $s i32)
  ;; 8-byte copies must not lower to align=1 i64 loads/stores in wasm2js -O.
  (memory.copy
   (local.get $d)
   (local.get $s)
   (i32.const 8)
  )
 )
)

;; CHECK-LABEL: function fill_1($0) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   HEAP8[$0 | 0] = 42;
;; CHECK-NEXT:  }

;; CHECK-LABEL: function fill_4($0) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   wasm2js_memory_fill($0, 0, 4);
;; CHECK-NEXT:  }

;; CHECK-LABEL: function fill_8($0) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   wasm2js_memory_fill($0, 0, 8);
;; CHECK-NEXT:  }

;; CHECK-LABEL: function copy_1($0, $1) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   $1 = $1 | 0;
;; CHECK-NEXT:   HEAP8[$0 | 0] = HEAPU8[$1 | 0];
;; CHECK-NEXT:  }

;; CHECK-LABEL: function copy_4($0, $1) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   $1 = $1 | 0;
;; CHECK-NEXT:   wasm2js_memory_copy($0, $1, 4);
;; CHECK-NEXT:  }

;; CHECK-LABEL: function copy_8($0, $1) {
;; CHECK-NEXT:   $0 = $0 | 0;
;; CHECK-NEXT:   $1 = $1 | 0;
;; CHECK-NEXT:   wasm2js_memory_copy($0, $1, 8);
;; CHECK-NEXT:  }

;; OPT-LABEL: (func $fill_1 (param $d i32)
;; OPT-NEXT:   (i32.store8
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i32.const 42)
;; OPT-NEXT:   )
;; OPT-NEXT:  )

;; OPT-LABEL: (func $fill_4 (param $d i32)
;; OPT-NEXT:   (i32.store align=1
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i32.const 0)
;; OPT-NEXT:   )
;; OPT-NEXT:  )

;; OPT-LABEL: (func $fill_8 (param $d i32)
;; OPT-NEXT:   (i64.store align=1
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i64.const 0)
;; OPT-NEXT:   )
;; OPT-NEXT:  )

;; OPT-LABEL: (func $copy_1 (param $d i32) (param $s i32)
;; OPT-NEXT:   (i32.store8
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i32.load8_u
;; OPT-NEXT:     (local.get $s)
;; OPT-NEXT:    )
;; OPT-NEXT:   )
;; OPT-NEXT:  )

;; OPT-LABEL: (func $copy_4 (param $d i32) (param $s i32)
;; OPT-NEXT:   (i32.store align=1
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i32.load align=1
;; OPT-NEXT:     (local.get $s)
;; OPT-NEXT:    )
;; OPT-NEXT:   )
;; OPT-NEXT:  )

;; OPT-LABEL: (func $copy_8 (param $d i32) (param $s i32)
;; OPT-NEXT:   (i64.store align=1
;; OPT-NEXT:    (local.get $d)
;; OPT-NEXT:    (i64.load align=1
;; OPT-NEXT:     (local.get $s)
;; OPT-NEXT:    )
;; OPT-NEXT:   )
;; OPT-NEXT:  )
