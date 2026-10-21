;; Interleaving stores
(module $Mem1
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem1)

(thread $T1 (shared (module $Mem1))
  (register "mem" $Mem1)
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; x =rel 1
      ;; y =rel 2
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
      (i32.atomic.store acqrel (i32.const 4) (i32.const 2))
    )
  )
  (invoke "run")
)

(thread $T2 (shared (module $Mem1))
  (register "mem" $Mem1)
  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; y =rel 3
      ;; x =rel 4
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
    ;; read x, y
    (i32.load (i32.const 0))
    (i32.load (i32.const 4))
  )
)

;; Nothing is synchronized so all 4 interleavings are possible.
;; x=1, y=3 is only possible with acqrel, while others are also possible with
;; seqcst.
(assert_return (invoke "check")
  (either (i32.const 1) (i32.const 4))
  (either (i32.const 2) (i32.const 3))
)

;; Critical section guarding an unordered memory access
(module $Mem2
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem2)

(thread $write (shared (module $Mem2))
  (register "mem" $Mem2)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; payload =un 42
      (i32.store (i32.const 4) (i32.const 42))
      ;; flag =rel 1 indicating that the payload was written
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $read (shared (module $Mem2))
  (register "mem" $Mem2)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; observed_flag =acq flag
      (i32.store (i32.const 8) (i32.atomic.load acqrel (i32.const 0)))

      ;; observed_payload =un payload
      (i32.store (i32.const 12) (i32.load (i32.const 4)))
    )
  )
  (invoke "run")
)

(wait $write)
(wait $read)

(module
  (memory (import "mem" "shared") 1 1 shared)
  (func (export "check") (result i32)
    ;; If the flag is set, the payload must be set
    ;; If the flag is unset, the payload may or may not be set.
    ;; !observed_flag || observed_payload == 42
    (i32.or
      (i32.eqz (i32.load (i32.const 8)))
      (i32.eq (i32.load (i32.const 12)) (i32.const 42))
    )
  )
)

(assert_return (invoke "check")
  (i32.const 1)
)

;; Similar to above, critical section guarding a flag
(module $Mem3
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem3)

(thread $write_flag (shared (module $Mem3))
  (register "mem" $Mem3)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; payload =un 42
      (i32.store (i32.const 4) (i32.const 42))

      ;; Release barrier
      (atomic.fence acqrel)

      ;; flag indicating that the payload was written.
      ;; A relaxed ordering would be sufficient here but there's no such thing
      ;; at the moment.
      ;; In practice this and the fence together are redundant.
      ;; flag =rel 1
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $read_flag (shared (module $Mem3))
  (register "mem" $Mem3)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; A relaxed ordering would be sufficient here but we don't have it.
      ;; In practice this and the fence together are redundant.
      ;; observed_flag =acq flag
      (i32.store (i32.const 8) (i32.atomic.load acqrel (i32.const 0)))

      ;; Acquire barrier
      (atomic.fence acqrel)

      ;; observed_payload =un payload
      (i32.store (i32.const 12) (i32.load (i32.const 4)))
    )
  )
  (invoke "run")
)

(wait $write_flag)
(wait $read_flag)

(module
  (memory (import "mem" "shared") 1 1 shared)
  (func (export "check") (result i32)
    ;; If the flag is set, the payload must be set
    ;; If the flag is unset, the payload may or may not be set.
    ;; !observed_flag || observed_payload == 42
    (i32.or
      (i32.eqz (i32.load (i32.const 8)))
      (i32.eq (i32.load (i32.const 12)) (i32.const 42))
    )
  )
)

(assert_return (invoke "check")
  (i32.const 1)
)

;; Spinlock
(module $Mem4
  ;; Address 0 - lock
  ;; Address 4 - payload
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem4)

;; Add 1 to the counter atomically
(thread $addOne (shared (module $Mem4))
  (register "mem" $Mem4)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    
    (func $lock
      (loop $spin
        ;; Try to swap 0 with 1 at the lock address 0
        (if (i32.eqz (i32.atomic.rmw.cmpxchg acqrel (i32.const 0) (i32.const 0) (i32.const 1)))
          (then (return))
        )
        (pause)
        (br $spin)
      )
    )
    
    (func $unlock
      ;; lock =rel 0
      (i32.atomic.store acqrel (i32.const 0) (i32.const 0))
    )

    (func (export "run")
      (call $lock)
      
      ;; payload +=un 1
      (i32.store (i32.const 4) 
        (i32.add (i32.load (i32.const 4)) (i32.const 1))
      )
      
      (call $unlock)
    )
  )
  (invoke "run")
)

;; Add 10 to the counter atomically
(thread $addTen (shared (module $Mem4))
  (register "mem" $Mem4)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    
    (func $lock
      (loop $spin
        ;; Try to swap 0 with 1 at the lock address 0
        (if (i32.eqz (i32.atomic.rmw.cmpxchg acqrel (i32.const 0) (i32.const 0) (i32.const 1)))
          (then (return))
        )
        (pause)
        (br $spin)
      )
    )
    
    (func $unlock
      ;; lock =rel 0
      (i32.atomic.store acqrel (i32.const 0) (i32.const 0))
    )

    (func (export "run")
      (call $lock)
      
      ;; payload +=un 10
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
    ;; read payload, lock
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
(module $Mem5
  (memory (export "shared") 1 1 shared)
)
(register "mem" $Mem5)

(thread $writeX (shared (module $Mem5))
  (register "mem" $Mem5)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; x =rel 1
      (i32.atomic.store acqrel (i32.const 0) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $writeY (shared (module $Mem5))
  (register "mem" $Mem5)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; y =rel 1
      (i32.atomic.store acqrel (i32.const 4) (i32.const 1))
    )
  )
  (invoke "run")
)

(thread $read1 (shared (module $Mem5))
  (register "mem" $Mem5)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; x1 =acq x
      ;; y1 =acq y
      (i32.store (i32.const 8) (i32.atomic.load acqrel (i32.const 0)))
      (i32.store (i32.const 12) (i32.atomic.load acqrel (i32.const 4)))
    )
  )
  (invoke "run")
)

(thread $read2 (shared (module $Mem5))
  (register "mem" $Mem5)

  (module
    (memory (import "mem" "shared") 1 1 shared)
    (func (export "run")
      ;; y2 =acq y
      ;; x2 =acq x
      (i32.store (i32.const 20) (i32.atomic.load acqrel (i32.const 4)))
      (i32.store (i32.const 16) (i32.atomic.load acqrel (i32.const 0)))
    )
  )
  (invoke "run")
)

(wait $writeX)
(wait $writeY)
(wait $read1)
(wait $read2)

(module
  (memory (import "mem" "shared") 1 1 shared)
  (func (export "check") (result i32 i32 i32 i32)
    ;; read x1, y1, x2, y2
    (i32.load (i32.const 8))
    (i32.load (i32.const 12))
    (i32.load (i32.const 16))
    (i32.load (i32.const 20))
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
