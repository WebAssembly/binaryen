;; Interleaving stores
(module $Mem
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem)

(thread $T1 (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
      (i32.atomic.store acqrel (i32.const 4) (i32.const 2))
    )
  )
  (invoke "run")
)

(thread $T2 (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (i32.atomic.store acqrel (i32.const 4) (i32.const 3))
      (i32.atomic.store acqrel (i32.const 0) (i32.const 4))
    )
  )
  (invoke "run")
)

(wait $T1)
(wait $T2)

(module
  (memory (import "mem" "shared") 1 1 shared)
  (func (export "check") (result i32 i32)
    (i32.load (i32.const 0))
    (i32.load (i32.const 4))
  )
)

;; Nothing is synchronized so all 4 interleavings are possible.
;; 1, 3 is only possible with acqrel, while others are also possible with
;; seqcst.
(assert_return (invoke "check")
  (either (i32.const 1) (i32.const 4))
  (either (i32.const 2) (i32.const 3))
)

;; Critical section guarding an unordered memory access
(module $Mem
  (memory (export "shared") 1 1 shared)
  (global (export "flag") (mut i32) (i32.const 0))
  (global (export "payload") (mut i32) (i32.const 0))
)
(register "mem" $Mem)

(thread $writer (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; payload
      (i32.store (i32.const 4) (i32.const 42))
      ;; flag indicating that the payload was written
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $reader (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (global $flag (import "mem" "flag") (mut i32))
    (global $payload (import "mem" "payload") (mut i32))
    (func (export "run")
      (global.set $flag (i32.atomic.load acqrel (i32.const 0)))
      (global.set $payload (i32.load (i32.const 4)))
    )
  )
  (invoke "run")
)

(wait $writer)
(wait $reader)

(module
  (global $flag (import "mem" "flag") (mut i32))
  (global $payload (import "mem" "payload") (mut i32))
  (func (export "check") (result i32)
    ;; If the flag is set, the payload must be set
    ;; If the flag is unset, the payload may or may not be set.
    (i32.or
      (i32.eqz (global.get $flag))
      (i32.eq (global.get $payload) (i32.const 42))
    )
  )
)

(assert_return (invoke "check")
  (i32.const 1)
)

;; Similar to above, critical section guarding a flag
(module $Mem
  (memory (export "shared") 1 1 shared)
  (global (export "flag") (mut i32) (i32.const 0))
  (global (export "payload") (mut i32) (i32.const 0))
)
(register "mem" $Mem)

(thread $writer (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; payload
      (i32.store (i32.const 4) (i32.const 42))

      ;; Release barrier
      (atomic.fence acqrel)

      ;; flag indicating that the payload was written.
      ;; A relaxed ordering would be sufficient here but there's no such thing
      ;; at the moment.
      ;; In practice this and the fence together are redundant.
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $reader (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (global $flag (import "mem" "flag") (mut i32))
    (global $payload (import "mem" "payload") (mut i32))
    (func (export "run")
      ;; A relaxed ordering would be sufficient here but we don't have it.
      ;; In practice this and the fence together are redundant.
      (global.set $flag (i32.atomic.load acqrel (i32.const 0)))

      ;; Acquire barrier
      (atomic.fence acqrel)

      (global.set $payload (i32.load (i32.const 4)))
    )
  )
  (invoke "run")
)

(wait $writer)
(wait $reader)

(module
  (global $flag (import "mem" "flag") (mut i32))
  (global $payload (import "mem" "payload") (mut i32))
  (func (export "check") (result i32)
    ;; If the flag is set, the payload must be set
    ;; If the flag is unset, the payload may or may not be set.
    (i32.or
      (i32.eqz (global.get $flag))
      (i32.eq (global.get $payload) (i32.const 42))
    )
  )
)

(assert_return (invoke "check")
  (i32.const 1)
)

;; Spinlock
(module $Mem
  ;; Address 0 - lock
  ;; Address 4 - payload
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem)

;; Add 1 to the counter atomically
(thread $addOne (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    
    (func $lock
      (loop $spin
        (if (i32.eqz (i32.atomic.rmw.cmpxchg acqrel (i32.const 0) (i32.const 0) (i32.const 1)))
          (then (return))
        )
        (pause)
        (br $spin)
      )
    )
    
    (func $unlock
      (i32.atomic.store acqrel (i32.const 0) (i32.const 0))
    )

    (func (export "run")
      (call $lock)
      
      (i32.store (i32.const 4) 
        (i32.add (i32.load (i32.const 4)) (i32.const 1))
      )
      
      (call $unlock)
    )
  )
  (invoke "run")
)

;; Add 10 to the counter atomically
(thread $addTen (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    
    (func $lock
      (loop $spin
        (if (i32.eqz (i32.atomic.rmw.cmpxchg acqrel (i32.const 0) (i32.const 0) (i32.const 1)))
          (then (return))
        )
        (pause)
        (br $spin)
      )
    )
    
    (func $unlock
      (i32.atomic.store acqrel (i32.const 0) (i32.const 0))
    )

    (func (export "run")
      (call $lock)
      
      (i32.store (i32.const 4) 
        (i32.add (i32.load (i32.const 4)) (i32.const 10))
      )
      
      (call $unlock)
    )
  )
  (invoke "run")
)

(wait $addOne)
(wait $addTen)

(module
  (memory (import "mem" "shared") 1 1 shared)
  (func (export "check") (result i32) (result i32)
    (i32.load (i32.const 4))
    (i32.load (i32.const 0))
  )
)

;; $addTen added 10 and $addOne added 1 atomically.
;; The lock was left unlocked at the end.
(assert_return (invoke "check")
  (i32.const 11)
  (i32.const 0)
)

;; independent reads of independent writes
(module $Mem
  (memory (export "shared") 1 1 shared)
  (global (export "x1") (mut i32) (i32.const 0))
  (global (export "y1") (mut i32) (i32.const 0))
  (global (export "x2") (mut i32) (i32.const 0))
  (global (export "y2") (mut i32) (i32.const 0))
)
(register "mem" $Mem)

;; Set x = 1
(thread $writerX (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

;; Set y = 1
(thread $writerY (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      (i32.atomic.store acqrel (i32.const 4) (i32.const 1))
    )
  )
  (invoke "run")
)

;; Read x, then y
(thread $reader1 (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (global $x1 (import "mem" "x1") (mut i32))
    (global $y1 (import "mem" "y1") (mut i32))
    (func (export "run")
      (global.set $x1 (i32.atomic.load acqrel (i32.const 0)))
      (global.set $y1 (i32.atomic.load acqrel (i32.const 4)))
    )
  )
  (invoke "run")
)

;; Read y, then x
(thread $reader2 (shared (module $Mem))
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (global $x2 (import "mem" "x2") (mut i32))
    (global $y2 (import "mem" "y2") (mut i32))
    (func (export "run")
      (global.set $y2 (i32.atomic.load acqrel (i32.const 4)))
      (global.set $x2 (i32.atomic.load acqrel (i32.const 0)))
    )
  )
  (invoke "run")
)

(wait $writerX)
(wait $writerY)
(wait $reader1)
(wait $reader2)

(module
  (global $x1 (import "mem" "x1") (mut i32))
  (global $y1 (import "mem" "y1") (mut i32))
  (global $x2 (import "mem" "x2") (mut i32))
  (global $y2 (import "mem" "y2") (mut i32))
  (func (export "check") (result i32 i32 i32 i32)
    (global.get $x1)
    (global.get $y1)
    (global.get $y2)
    (global.get $x2)
  )
)

;; All 4 combinations are possible
;; Under seqcst, x1=1, y1=0, x2=0, y2=1 isn't possible.
(assert_return (invoke "check")
  (either (i32.const 0) (i32.const 1))
  (either (i32.const 0) (i32.const 1))
  (either (i32.const 0) (i32.const 1))
  (either (i32.const 0) (i32.const 1))
)
