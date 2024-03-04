;; RUN: wasm-opt %s -o %t.wasm -osm %t.map -g -q
;; RUN: wasm-opt %t.wasm -ism %t.map -q -o - -S | filecheck %s

;; RUN: wasm-opt %s --new-wat-parser -S -o - | filecheck %s

(module
  ;;@ src.cpp:0:1
  (func $foo (param $x i32) (param $y i32)
    ;;@ src.cpp:10:1
    (if
      ;;@ src.cpp:20:1
      (i32.add
        ;;@ src.cpp:30:1
        (local.get $x)
        ;;@ src.cpp:40:1
        (local.get $y)
      )
      ;; For the legacy parser
      ;;@ src.cpp:50:1
      (then
        ;; For the new parser
        ;;@ src.cpp:50:1
        (return)
      )
    )
    ;;@ src.cpp:60:1
    (call $foo
      ;;@ src.cpp:70:1
      (local.get $x)
      ;;@ src.cpp:80:1
      (local.get $y)
    )
    ;;@ src.cpp:90:1
  )
)

;; CHECK:       ;;@ src.cpp:0:1
;; CHECK-NEXT:  (func $foo (param $x i32) (param $y i32)
;; CHECK-NEXT:   ;;@ src.cpp:10:1
;; CHECK-NEXT:   (if
;; CHECK-NEXT:    ;;@ src.cpp:20:1
;; CHECK-NEXT:    (i32.add
;; CHECK-NEXT:     ;;@ src.cpp:30:1
;; CHECK-NEXT:     (local.get $x)
;; CHECK-NEXT:     ;;@ src.cpp:40:1
;; CHECK-NEXT:     (local.get $y)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (then
;; CHECK-NEXT:     ;;@ src.cpp:50:1
;; CHECK-NEXT:     (return)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   ;;@ src.cpp:60:1
;; CHECK-NEXT:   (call $foo
;; CHECK-NEXT:    ;;@ src.cpp:70:1
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:    ;;@ src.cpp:80:1
;; CHECK-NEXT:    (local.get $y)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   ;;@ src.cpp:90:1
;; CHECK-NEXT:  )
