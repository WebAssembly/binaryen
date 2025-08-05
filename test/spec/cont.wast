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
;; TODO: cont.bind (assert_trap (invoke "non-linear-4") "continuation already consumed")

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

