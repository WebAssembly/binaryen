;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-as %s -all -g -o %t.wasm
;; RUN: wasm-dis %t.wasm -o - | filecheck %s

(module
  ;; CHECK:      (import "env" "memory" (memory $importedMemory 1 1))

  ;; CHECK:      (memory $memory1 1 500)
  (memory $memory1 1 500)
  ;; CHECK:      (memory $memory2 1 800)
  (memory $memory2 1 800)
  ;; CHECK:      (memory $memory3 1 400)
  (memory $memory3 1 400)
  ;; CHECK:      (data $data1 (memory $memory1) (i32.const 0) "abcd")
  (data $data1 (memory $memory1) (i32.const 0) "a" "" "bcd")
  ;; CHECK:      (data $data2 (memory $memory2) (i32.const 9) "w")
  (data $data2 (memory $memory2) (i32.const 9) "w")
  (import "env" "memory" (memory $importedMemory 1 1))
  ;; CHECK:      (func $memory.fill
  ;; CHECK-NEXT:  (memory.fill $memory2
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $memory.fill
    (memory.fill 1
      (i32.const 0)
      (i32.const 1)
      (i32.const 2)
    )
  )
  ;; CHECK:      (func $memory.copy
  ;; CHECK-NEXT:  (memory.copy $memory2 $memory3
  ;; CHECK-NEXT:   (i32.const 512)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 12)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $memory.copy
    (memory.copy 1 2
      (i32.const 512)
      (i32.const 0)
      (i32.const 12)
    )
  )
  ;; CHECK:      (func $memory.init
  ;; CHECK-NEXT:  (memory.init $memory1 $data1
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 45)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $memory.init
    (memory.init 0 0
      (i32.const 0)
      (i32.const 0)
      (i32.const 45)
    )
  )
  ;; CHECK:      (func $memory.grow (result i32)
  ;; CHECK-NEXT:  (memory.grow $memory3
  ;; CHECK-NEXT:   (i32.const 10)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $memory.grow (result i32)
    (memory.grow 2
	  (i32.const 10)
    )
  )
  ;; CHECK:      (func $memory.size (result i32)
  ;; CHECK-NEXT:  (memory.size $memory3)
  ;; CHECK-NEXT: )
  (func $memory.size (result i32)
    (memory.size 2)
  )
  ;; CHECK:      (func $loads
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load $memory1
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load $memory3
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load16_s $memory2
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load16_s $memory2
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load8_s $memory3
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load8_s $memory3
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load16_u $memory1
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load16_u $memory1
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load8_u $memory2
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load8_u $memory2
  ;; CHECK-NEXT:    (i32.const 12)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $loads
    (drop (i32.load 0 (i32.const 12)))
    (drop (i32.load $memory3 (i32.const 12)))
    (drop (i32.load16_s 1 (i32.const 12)))
    (drop (i32.load16_s $memory2 (i32.const 12)))
    (drop (i32.load8_s 2 (i32.const 12)))
    (drop (i32.load8_s $memory3 (i32.const 12)))
    (drop (i32.load16_u 0 (i32.const 12)))
    (drop (i32.load16_u $memory1 (i32.const 12)))
    (drop (i32.load8_u 1 (i32.const 12)))
    (drop (i32.load8_u $memory2 (i32.const 12)))
  )
  ;; CHECK:      (func $stores
  ;; CHECK-NEXT:  (i32.store $memory1
  ;; CHECK-NEXT:   (i32.const 12)
  ;; CHECK-NEXT:   (i32.const 115)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store $memory1
  ;; CHECK-NEXT:   (i32.const 12)
  ;; CHECK-NEXT:   (i32.const 115)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store16 $memory2
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:   (i32.const 31353)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store16 $importedMemory
  ;; CHECK-NEXT:   (i32.const 20)
  ;; CHECK-NEXT:   (i32.const 31353)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store8 $memory3
  ;; CHECK-NEXT:   (i32.const 23)
  ;; CHECK-NEXT:   (i32.const 120)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.store8 $memory3
  ;; CHECK-NEXT:   (i32.const 23)
  ;; CHECK-NEXT:   (i32.const 120)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $stores
    (i32.store 0 (i32.const 12) (i32.const 115))
    (i32.store $memory1 (i32.const 12) (i32.const 115))
	(i32.store16 1 (i32.const 20) (i32.const 31353))
	(i32.store16 $importedMemory (i32.const 20) (i32.const 31353))
    (i32.store8 2 (i32.const 23) (i32.const 120))
    (i32.store8 $memory3 (i32.const 23) (i32.const 120))
  )
)

