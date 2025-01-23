;; NOTE: These assertions have been manually generated because of the assertion
;; at the end (update_lit_checks.py ignores the features section because it's
;; not semantically part of the module.)

;; RUN: wasm-opt --enable-bulk-memory %s --llvm-memory-copy-fill-lowering --emit-target-features -S -o - | filecheck %s

(module
 (memory 0)
 ;; CHECK:      (type $0 (func (param i32 i32 i32)))

 ;; CHECK:      (memory $0 0)

 ;; CHECK:      (func $memcpy (param $dst i32) (param $src i32) (param $size i32)
 ;; CHECK-NEXT:  (call $__memory_copy
 ;; CHECK-NEXT:   (local.get $dst)
 ;; CHECK-NEXT:   (local.get $src)
 ;; CHECK-NEXT:   (local.get $size)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $memcpy (param $dst i32) (param $src i32) (param $size i32)
  (memory.copy (local.get $dst) (local.get $src) (local.get $size))
 )
 ;; CHECK:      (func $memfill (param $dst i32) (param $val i32) (param $size i32)
 ;; CHECK-NEXT:  (call $__memory_fill
 ;; CHECK-NEXT:   (local.get $dst)
 ;; CHECK-NEXT:   (local.get $val)
 ;; CHECK-NEXT:   (local.get $size)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $memfill (param $dst i32) (param $val i32) (param $size i32)
  (memory.fill (local.get $dst) (local.get $val) (local.get $size))
 )
)
;; CHECK:      (func $__memory_copy (param $dst i32) (param $src i32) (param $size i32)
;; CHECK-NEXT:  (local $start i32)
;; CHECK-NEXT:  (local $end i32)
;; CHECK-NEXT:  (local $step i32)
;; CHECK-NEXT:  (local $i i32)
;; CHECK-NEXT:  (local.set $end
;; CHECK-NEXT:   (i32.mul
;; CHECK-NEXT:    (memory.size)
;; CHECK-NEXT:    (i32.const 65536)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.or
;; CHECK-NEXT:    (i32.gt_u
;; CHECK-NEXT:     (i32.add
;; CHECK-NEXT:      (local.get $dst)
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (local.get $end)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.gt_u
;; CHECK-NEXT:     (i32.add
;; CHECK-NEXT:      (local.get $src)
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (local.get $end)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (unreachable)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.lt_u
;; CHECK-NEXT:    (local.get $src)
;; CHECK-NEXT:    (local.get $dst)
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (local.set $start
;; CHECK-NEXT:     (i32.sub
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:      (i32.const 1)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $end
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $step
;; CHECK-NEXT:     (i32.const -1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (else
;; CHECK-NEXT:    (local.set $start
;; CHECK-NEXT:     (i32.const 0)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $end
;; CHECK-NEXT:     (local.get $size)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $step
;; CHECK-NEXT:     (i32.const 1)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (local.set $i
;; CHECK-NEXT:   (local.get $start)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (block $out
;; CHECK-NEXT:   (loop $copy
;; CHECK-NEXT:    (br_if $out
;; CHECK-NEXT:     (i32.eq
;; CHECK-NEXT:      (local.get $i)
;; CHECK-NEXT:      (local.get $end)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.store8
;; CHECK-NEXT:     (i32.add
;; CHECK-NEXT:      (local.get $dst)
;; CHECK-NEXT:      (local.get $i)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (i32.load8_u
;; CHECK-NEXT:      (i32.add
;; CHECK-NEXT:       (local.get $src)
;; CHECK-NEXT:       (local.get $i)
;; CHECK-NEXT:      )
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $i
;; CHECK-NEXT:     (i32.add
;; CHECK-NEXT:      (local.get $i)
;; CHECK-NEXT:      (local.get $step)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (br $copy)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

;; CHECK:      (func $__memory_fill (param $dst i32) (param $val i32) (param $size i32)
;; CHECK-NEXT:  (if
;; CHECK-NEXT:   (i32.gt_u
;; CHECK-NEXT:    (i32.add
;; CHECK-NEXT:     (local.get $dst)
;; CHECK-NEXT:     (local.get $size)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.mul
;; CHECK-NEXT:     (memory.size)
;; CHECK-NEXT:     (i32.const 65536)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (then
;; CHECK-NEXT:    (unreachable)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (block $out
;; CHECK-NEXT:   (loop $copy
;; CHECK-NEXT:    (br_if $out
;; CHECK-NEXT:     (i32.eqz
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (local.set $size
;; CHECK-NEXT:     (i32.sub
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:      (i32.const 1)
;; CHECK-NEXT:     )
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (i32.store8
;; CHECK-NEXT:     (i32.add
;; CHECK-NEXT:      (local.get $dst)
;; CHECK-NEXT:      (local.get $size)
;; CHECK-NEXT:     )
;; CHECK-NEXT:     (local.get $val)
;; CHECK-NEXT:    )
;; CHECK-NEXT:    (br $copy)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
;; CHECK-NEXT: ;; features section: mutable-globals, sign-ext
