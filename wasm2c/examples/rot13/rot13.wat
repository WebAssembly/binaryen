(import "host" "mem" (memory $mem 1))
(import "host" "fill_buf" (func $fill_buf (param i32 i32) (result i32)))
(import "host" "buf_done" (func $buf_done (param i32 i32)))

(func $rot13c (param $c i32) (result i32)
  (local $uc i32)

  ;; No change if < 'A'.
  (if (i32.lt_u (local.get $c) (i32.const 65))
    (then (return (local.get $c))))

  ;; Clear 5th bit of c, to force uppercase. 0xdf = 0b11011111
  (local.set $uc (i32.and (local.get $c) (i32.const 0xdf)))

  ;; In range ['A', 'M'] return |c| + 13.
  (if (i32.le_u (local.get $uc) (i32.const 77))
    (then (return (i32.add (local.get $c) (i32.const 13)))))

  ;; In range ['N', 'Z'] return |c| - 13.
  (if (i32.le_u (local.get $uc) (i32.const 90))
    (then (return (i32.sub (local.get $c) (i32.const 13)))))

  ;; No change for everything else.
  (return (local.get $c))
)

(func (export "rot13")
  (local $size i32)
  (local $i i32)

  ;; Ask host to fill memory [0, 1024) with data.
  (call $fill_buf (i32.const 0) (i32.const 1024))

  ;; The host returns the size filled.
  (local.set $size)

  ;; Loop over all bytes and rot13 them.
  (block $exit
    (loop $top
      ;; if (i >= size) break
      (if (i32.ge_u (local.get $i) (local.get $size)) (then (br $exit)))

      ;; mem[i] = rot13c(mem[i])
      (i32.store8
        (local.get $i)
        (call $rot13c
          (i32.load8_u (local.get $i))))

      ;; i++
      (local.set $i (i32.add (local.get $i) (i32.const 1)))
      (br $top)
    )
  )

  (call $buf_done (i32.const 0) (local.get $size))
)
