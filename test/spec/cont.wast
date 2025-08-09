;; Unhandled tags & guards

(module
  (tag $exn)
  (tag $e1)
  (tag $e2)

  (type $f1 (func))
  (type $k1 (cont $f1))

  (func $f1 (export "unhandled-1")
    (suspend $e1)
  )

  (func (export "unhandled-2")
    (resume $k1 (cont.new $k1 (ref.func $f1)))
  )

  (func (export "unhandled-3")
    (block $h (result (ref $k1))
      (resume $k1 (on $e2 $h) (cont.new $k1 (ref.func $f1)))
      (unreachable)
    )
    (drop)
  )

  (func (export "handled")
    (block $h (result (ref $k1))
      (resume $k1 (on $e1 $h) (cont.new $k1 (ref.func $f1)))
      (unreachable)
    )
    (drop)
  )

  (elem declare func $f2)
  (func $f2
    (throw $exn)
  )

  (func (export "uncaught-1")
    (block $h (result (ref $k1))
      (resume $k1 (on $e1 $h) (cont.new $k1 (ref.func $f2)))
      (unreachable)
    )
    (drop)
  )

  (func (export "uncaught-2")
    (block $h (result (ref $k1))
      (resume $k1 (on $e1 $h) (cont.new $k1 (ref.func $f1)))
      (unreachable)
    )
    (resume_throw $k1 $exn)
  )

  (elem declare func $f3)
  (func $f3
    (call $f4)
  )
  (func $f4
    (suspend $e1)
  )

  (func (export "uncaught-3")
    (block $h (result (ref $k1))
      (resume $k1 (on $e1 $h) (cont.new $k1 (ref.func $f3)))
      (unreachable)
    )
    (resume_throw $k1 $exn)
  )

  (elem declare func $r0 $r1)
  (func $r0)
  (func $r1 (suspend $e1) (suspend $e1))

  (func $nl1 (param $k (ref $k1))
    (resume $k1 (local.get $k))
    (resume $k1 (local.get $k))
  )
  (func $nl2 (param $k (ref $k1))
    (block $h (result (ref $k1))
      (resume $k1 (on $e1 $h) (local.get $k))
      (unreachable)
    )
    (resume $k1 (local.get $k))
    (unreachable)
  )
  (func $nl3 (param $k (ref $k1))
    (local $k' (ref null $k1))
    (block $h1 (result (ref $k1))
      (resume $k1 (on $e1 $h1) (local.get $k))
      (unreachable)
    )
    (local.set $k')
    (block $h2 (result (ref $k1))
      (resume $k1 (on $e1 $h2) (local.get $k'))
      (unreachable)
    )
    (resume $k1 (local.get $k'))
    (unreachable)
  )
  (func $nl4 (param $k (ref $k1))
    (drop (cont.bind $k1 $k1 (local.get $k)))
    (resume $k1 (local.get $k))
  )

  (func (export "non-linear-1")
    (call $nl1 (cont.new $k1 (ref.func $r0)))
  )
  (func (export "non-linear-2")
    (call $nl2 (cont.new $k1 (ref.func $r1)))
  )
  (func (export "non-linear-3")
    (call $nl3 (cont.new $k1 (ref.func $r1)))
  )
  (func (export "non-linear-4")
    (call $nl4 (cont.new $k1 (ref.func $r1)))
  )
)

(assert_suspension (invoke "unhandled-1") "unhandled")
(assert_suspension (invoke "unhandled-2") "unhandled")
(assert_suspension (invoke "unhandled-3") "unhandled")
(assert_return (invoke "handled"))

(assert_exception (invoke "uncaught-1"))
;; TODO: resume_throw (assert_exception (invoke "uncaught-2"))
;; TODO: resume_throw (assert_exception (invoke "uncaught-3"))

(assert_trap (invoke "non-linear-1") "continuation already consumed")
(assert_trap (invoke "non-linear-2") "continuation already consumed")
(assert_trap (invoke "non-linear-3") "continuation already consumed")
(assert_trap (invoke "non-linear-4") "continuation already consumed")

(assert_invalid
  (module
    (type $ft (func))
    (func
      (cont.new $ft (ref.null $ft))
      (drop)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (func
      (resume $ft (ref.null $ct))
      (unreachable)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (tag $exn)
    (func
      (resume_throw $ft $exn (ref.null $ct))
      (unreachable)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (func
      (cont.bind $ft $ct (ref.null $ct))
      (unreachable)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (func
      (cont.bind $ct $ft (ref.null $ct))
      (unreachable)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (tag $foo)
    (func
      (block $on_foo (result (ref $ft))
        (resume $ct (on $foo $on_foo) (ref.null $ct))
        (unreachable)
      )
      (drop)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ft (func))
    (type $ct (cont $ft))
    (tag $foo)
    (func
      (block $on_foo (result (ref $ct) (ref $ft))
        (resume $ct (on $foo $on_foo) (ref.null $ct))
        (unreachable)
      )
      (drop)
      (drop)))
  "non-continuation type 0")

(assert_invalid
  (module
    (type $ct (cont $ct)))
  "non-function type 0")

(assert_invalid
  (module
    (rec
      (type $s0 (struct (field (ref 0) (ref 1) (ref $s0) (ref $s1))))
      (type $s1 (struct (field (ref 0) (ref 1) (ref $s0) (ref $s1))))
    )
    (type $ct (cont $s0)))
  "non-function type 0")

(module
  (rec
    (type $f1 (func (param (ref $f2))))
    (type $f2 (func (param (ref $f1))))
  )
  (type $c1 (cont $f1))
  (type $c2 (cont $f2))
)

;; Simple state example

(module $state
  (tag $get (result i32))
  (tag $set (param i32) (result i32))

  (type $f (func (param i32) (result i32)))
  (type $k (cont $f))

  (func $runner (param $s i32) (param $k (ref $k)) (result i32)
    (loop $loop
      (block $on_get (result (ref $k))
        (block $on_set (result i32 (ref $k))
          (resume $k (on $get $on_get) (on $set $on_set)
            (local.get $s) (local.get $k)
          )
          (return)
        )
        ;; on set
        (local.set $k)
        (local.set $s)
        (br $loop)
      )
      ;; on get
      (local.set $k)
      (br $loop)
    )
    (unreachable)
  )

  (func $f (param i32) (result i32)
    (drop (suspend $set (i32.const 7)))
    (i32.add
      (suspend $get)
      (i32.mul
        (i32.const 2)
        (i32.add
          (suspend $set (i32.const 3))
          (suspend $get)
        )
      )
    )
  )

  (elem declare func $f)
  (func (export "run") (result i32)
    (call $runner (i32.const 0) (cont.new $k (ref.func $f)))
  )
)

(assert_return (invoke "run") (i32.const 19))

;; Simple generator example

(module $generator
  (type $gen (func (param i64)))
  (type $geny (func (param i32)))
  (type $cont0 (cont $gen))
  (type $cont (cont $geny))

  (tag $yield (param i64) (result i32))

  ;; Hook for logging purposes
  (global $hook (export "hook") (mut (ref $gen)) (ref.func $dummy))
  (func $dummy (param i64))

  (func $gen (export "start") (param $i i64)
    (loop $l
      (br_if 1 (suspend $yield (local.get $i)))
      (call_ref $gen (local.get $i) (global.get $hook))
      (local.set $i (i64.add (local.get $i) (i64.const 1)))
      (br $l)
    )
  )

  (elem declare func $gen)

  (func (export "sum") (param $i i64) (param $j i64) (result i64)
    (local $sum i64)
    (local $n i64)
    (local $k (ref null $cont))
    (local.get $i)
    (cont.new $cont0 (ref.func $gen))
    (block $on_first_yield (param i64 (ref $cont0)) (result i64 (ref $cont))
      (resume $cont0 (on $yield $on_first_yield))
      (unreachable)
    )
    (loop $on_yield (param i64) (param (ref $cont))
      (local.set $k)
      (local.set $n)
      (local.set $sum (i64.add (local.get $sum) (local.get $n)))
      (i64.eq (local.get $n) (local.get $j))
      (local.get $k)
      (resume $cont (on $yield $on_yield))
    )
    (return (local.get $sum))
  )
)

(register "generator")

(assert_return (invoke "sum" (i64.const 0) (i64.const 0)) (i64.const 0))
(assert_return (invoke "sum" (i64.const 2) (i64.const 2)) (i64.const 2))
(assert_return (invoke "sum" (i64.const 0) (i64.const 3)) (i64.const 6))
(assert_return (invoke "sum" (i64.const 1) (i64.const 10)) (i64.const 55))
(assert_return (invoke "sum" (i64.const 100) (i64.const 2000)) (i64.const 1_996_050))



;; Simple scheduler example

(module $scheduler
  (type $proc (func))
  (type $cont (cont $proc))

  (tag $yield (export "yield"))
  (tag $spawn (export "spawn") (param (ref $cont)))

  ;; Table as simple queue (keeping it simple, no ring buffer)
  (table $queue 0 (ref null $cont))
  (global $qdelta i32 (i32.const 10))
  (global $qback (mut i32) (i32.const 0))
  (global $qfront (mut i32) (i32.const 0))

  (func $queue-empty (result i32)
    (i32.eq (global.get $qfront) (global.get $qback))
  )

  (func $dequeue (result (ref null $cont))
    (local $i i32)
    (if (call $queue-empty)
      (then (return (ref.null $cont)))
    )
    (local.set $i (global.get $qfront))
    (global.set $qfront (i32.add (local.get $i) (i32.const 1)))
    (table.get $queue (local.get $i))
  )

  (func $enqueue (param $k (ref $cont))
    ;; Check if queue is full
    (if (i32.eq (global.get $qback) (table.size $queue))
      (then
        ;; Check if there is enough space in the front to compact
        (if (i32.lt_u (global.get $qfront) (global.get $qdelta))
          (then
            ;; Space is below threshold, grow table instead
            (drop (table.grow $queue (ref.null $cont) (global.get $qdelta)))
          )
          (else
            ;; Enough space, move entries up to head of table
            (global.set $qback (i32.sub (global.get $qback) (global.get $qfront)))
            (table.copy $queue $queue
              (i32.const 0)         ;; dest = new front = 0
              (global.get $qfront)  ;; src = old front
              (global.get $qback)   ;; len = new back = old back - old front
            )
            (table.fill $queue      ;; null out old entries to avoid leaks
              (global.get $qback)   ;; start = new back
              (ref.null $cont)      ;; init value
              (global.get $qfront)  ;; len = old front = old front - new front
            )
            (global.set $qfront (i32.const 0))
          )
        )
      )
    )
    (table.set $queue (global.get $qback) (local.get $k))
    (global.set $qback (i32.add (global.get $qback) (i32.const 1)))
  )

  (func $scheduler (export "scheduler") (param $main (ref $cont))
    (call $enqueue (local.get $main))
    (loop $l
      (if (call $queue-empty) (then (return)))
      (block $on_yield (result (ref $cont))
        (block $on_spawn (result (ref $cont) (ref $cont))
          (resume $cont (on $yield $on_yield) (on $spawn $on_spawn)
            (call $dequeue)
          )
          (br $l)  ;; thread terminated
        )
        ;; on $spawn, proc and cont on stack
        (call $enqueue)             ;; continuation of old thread
        (call $enqueue)             ;; new thread
        (br $l)
      )
      ;; on $yield, cont on stack
      (call $enqueue)
      (br $l)
    )
  )
)

(register "scheduler")

(module
  (type $proc (func))
  (type $pproc (func (param i32))) ;; parameterised proc
  (type $cont (cont $proc))
  (type $pcont (cont $pproc)) ;; parameterised continuation proc
  (tag $yield (import "scheduler" "yield"))
  (tag $spawn (import "scheduler" "spawn") (param (ref $cont)))
  (func $scheduler (import "scheduler" "scheduler") (param $main (ref $cont)))

  (func $log (import "spectest" "print_i32") (param i32))

  (global $width (mut i32) (i32.const 0))
  (global $depth (mut i32) (i32.const 0))

  (elem declare func $main $thread1 $thread2 $thread3)

  (func $main
    (call $log (i32.const 0))
    (suspend $spawn (cont.new $cont (ref.func $thread1)))
    (call $log (i32.const 1))
    (suspend $spawn (cont.bind $pcont $cont (global.get $depth) (cont.new $pcont (ref.func $thread2))))
    (call $log (i32.const 2))
    (suspend $spawn (cont.new $cont (ref.func $thread3)))
    (call $log (i32.const 3))
  )

  (func $thread1
    (call $log (i32.const 10))
    (suspend $yield)
    (call $log (i32.const 11))
    (suspend $yield)
    (call $log (i32.const 12))
    (suspend $yield)
    (call $log (i32.const 13))
  )

  (func $thread2 (param $d i32)
    (local $w i32)
    (local.set $w (global.get $width))
    (call $log (i32.const 20))
    (br_if 0 (i32.eqz (local.get $d)))
    (call $log (i32.const 21))
    (loop $l
      (if (local.get $w)
        (then
          (call $log (i32.const 22))
          (suspend $yield)
          (call $log (i32.const 23))
          (suspend $spawn
            (cont.bind $pcont $cont
              (i32.sub (local.get $d) (i32.const 1))
              (cont.new $pcont (ref.func $thread2))
            )
          )
          (call $log (i32.const 24))
          (local.set $w (i32.sub (local.get $w) (i32.const 1)))
          (br $l)
        )
      )
    )
    (call $log (i32.const 25))
  )

  (func $thread3
    (call $log (i32.const 30))
    (suspend $yield)
    (call $log (i32.const 31))
    (suspend $yield)
    (call $log (i32.const 32))
  )

  (func (export "run") (param $width i32) (param $depth i32)
    (global.set $depth (local.get $depth))
    (global.set $width (local.get $width))
    (call $log (i32.const -1))
    (call $scheduler (cont.new $cont (ref.func $main)))
    (call $log (i32.const -2))
  )
)

(assert_return (invoke "run" (i32.const 0) (i32.const 0)))
(assert_return (invoke "run" (i32.const 0) (i32.const 1)))
(assert_return (invoke "run" (i32.const 1) (i32.const 0)))
(assert_return (invoke "run" (i32.const 1) (i32.const 1)))
(assert_return (invoke "run" (i32.const 3) (i32.const 4)))

;; Nested example: generator in a thread

(module $concurrent-generator
  (func $log (import "spectest" "print_i64") (param i64))

  (tag $syield (import "scheduler" "yield"))
  (tag $spawn (import "scheduler" "spawn") (param (ref $cont)))
  (func $scheduler (import "scheduler" "scheduler") (param $main (ref $cont)))

  (type $ghook (func (param i64)))
  (func $gsum (import "generator" "sum") (param i64 i64) (result i64))
  (global $ghook (import "generator" "hook") (mut (ref $ghook)))

  (global $result (mut i64) (i64.const 0))
  (global $done (mut i32) (i32.const 0))

  (elem declare func $main $bg-thread $syield)

  (func $syield (param $i i64)
    (call $log (local.get $i))
    (suspend $syield)
  )

  (func $bg-thread
    (call $log (i64.const -10))
    (loop $l
      (call $log (i64.const -11))
      (suspend $syield)
      (br_if $l (i32.eqz (global.get $done)))
    )
    (call $log (i64.const -12))
  )

  (func $main (param $i i64) (param $j i64)
    (suspend $spawn (cont.new $cont (ref.func $bg-thread)))
    (global.set $ghook (ref.func $syield))
    (global.set $result (call $gsum (local.get $i) (local.get $j)))
    (global.set $done (i32.const 1))
  )

  (type $proc (func))
  (type $pproc (func (param i64 i64)))
  (type $cont (cont $proc))
  (type $pcont (cont $pproc))
  (func (export "sum") (param $i i64) (param $j i64) (result i64)
    (call $log (i64.const -1))
    (call $scheduler
      (cont.bind $pcont $cont (local.get $i) (local.get $j) (cont.new $pcont (ref.func $main)))
    )
    (call $log (i64.const -2))
    (global.get $result)
  )
)

(assert_return (invoke "sum" (i64.const 10) (i64.const 20)) (i64.const 165))

