;; RUN: wasm-opt %s -o %t.wasm -osm %t.map -g -q
;; RUN: wasm-opt %t.wasm -ism %t.map -q -o - -S | filecheck %s

(module
  (func $foo (param $x i32) (param $y i32)
    ;;@ src.cpp:1:1
    (if
      (i32.add
        (local.get $x)
        ;;@ src.cpp:2:1
        (local.get $y)
      )
      ;;@ src.cpp:3:1
      (return)
    )
    ;;@ src.cpp:1:1
    (block
      ;;@ src.cpp:4:1
      (drop
        (i32.add
          (local.get $x)
          ;;@ src.cpp:5:1
          (local.get $y)
        )
      )
      (drop
        (i32.sub
          (local.get $x)
          (local.get $y)
        )
      )
    )
    (drop
      (i32.mul
        (local.get $x)
        ;;@ src.cpp:6:1
        (local.get $y)
      )
    )
    (return)
  )
)

;; CHECK:  (func $foo (param $x i32) (param $y i32)
;; CHECK-NEXT:  ;;@ src.cpp:1:1
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:    ;;@ src.cpp:2:1
;; CHECK-NEXT:    (local.get $y)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   ;;@ src.cpp:3:1
;; CHECK-NEXT:   (return)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  ;;@ src.cpp:4:1
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.add
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:    ;;@ src.cpp:5:1
;; CHECK-NEXT:    (local.get $y)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  ;;@ src.cpp:4:1
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.sub
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:    (local.get $y)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  ;;@ src.cpp:1:1
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (i32.mul
;; CHECK-NEXT:    (local.get $x)
;; CHECK-NEXT:    ;;@ src.cpp:6:1
;; CHECK-NEXT:    (local.get $y)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  ;;@ src.cpp:1:1
;; CHECK-NEXT:  (return)
;; CHECK-NEXT: )
;; CHECK-NEXT:)