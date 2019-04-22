;; Passive segment syntax
(module
  (memory 1)
  (data passive "foo"))

;; memory.fill
(module
  (memory 1)

  (func (export "fill") (param i32 i32 i32)
    (memory.fill
      (local.get 0)
      (local.get 1)
      (local.get 2)))

  (func (export "load8_u") (param i32) (result i32)
    (i32.load8_u (local.get 0)))
)

;; Basic fill test.
(invoke "fill" (i32.const 1) (i32.const 0xff) (i32.const 3))
(assert_return (invoke "load8_u" (i32.const 0)) (i32.const 0))
(assert_return (invoke "load8_u" (i32.const 1)) (i32.const 0xff))
(assert_return (invoke "load8_u" (i32.const 2)) (i32.const 0xff))
(assert_return (invoke "load8_u" (i32.const 3)) (i32.const 0xff))
(assert_return (invoke "load8_u" (i32.const 4)) (i32.const 0))

;; Fill value is stored as a byte.
(invoke "fill" (i32.const 0) (i32.const 0xbbaa) (i32.const 2))
(assert_return (invoke "load8_u" (i32.const 0)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 1)) (i32.const 0xaa))

;; Fill all of memory
(invoke "fill" (i32.const 0) (i32.const 0) (i32.const 0x10000))

;; Out-of-bounds writes trap, but all previous writes succeed.
(assert_trap (invoke "fill" (i32.const 0xff00) (i32.const 1) (i32.const 0x101))
    "out of bounds memory access")
(assert_return (invoke "load8_u" (i32.const 0xff00)) (i32.const 1))
(assert_return (invoke "load8_u" (i32.const 0xffff)) (i32.const 1))

;; Succeed when writing 0 bytes at the end of the region.
(invoke "fill" (i32.const 0x10000) (i32.const 0) (i32.const 0))

;; Fail on out-of-bounds when writing 0 bytes outside of memory.
(assert_trap (invoke "fill" (i32.const 0x10001) (i32.const 0) (i32.const 0))
    "out of bounds memory access")


;; memory.copy
(module
  (memory 1 1)
  (data (i32.const 0) "\aa\bb\cc\dd")

  (func (export "copy") (param i32 i32 i32)
    (memory.copy
      (local.get 0)
      (local.get 1)
      (local.get 2)))

  (func (export "load8_u") (param i32) (result i32)
    (i32.load8_u (local.get 0)))
)

;; Non-overlapping copy.
(invoke "copy" (i32.const 10) (i32.const 0) (i32.const 4))

(assert_return (invoke "load8_u" (i32.const 9)) (i32.const 0))
(assert_return (invoke "load8_u" (i32.const 10)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 11)) (i32.const 0xbb))
(assert_return (invoke "load8_u" (i32.const 12)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 13)) (i32.const 0xdd))
(assert_return (invoke "load8_u" (i32.const 14)) (i32.const 0))

;; Overlap, source > dest
(invoke "copy" (i32.const 8) (i32.const 10) (i32.const 4))
(assert_return (invoke "load8_u" (i32.const 8)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 9)) (i32.const 0xbb))
(assert_return (invoke "load8_u" (i32.const 10)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 11)) (i32.const 0xdd))
(assert_return (invoke "load8_u" (i32.const 12)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 13)) (i32.const 0xdd))

;; Overlap, source < dest
(invoke "copy" (i32.const 10) (i32.const 7) (i32.const 6))
(assert_return (invoke "load8_u" (i32.const 10)) (i32.const 0))
(assert_return (invoke "load8_u" (i32.const 11)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 12)) (i32.const 0xbb))
(assert_return (invoke "load8_u" (i32.const 13)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 14)) (i32.const 0xdd))
(assert_return (invoke "load8_u" (i32.const 15)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 16)) (i32.const 0))

;; Overlap, source < dest but size is out of bounds
(assert_trap (invoke "copy" (i32.const 13) (i32.const 11) (i32.const -1)))
(assert_return (invoke "load8_u" (i32.const 10)) (i32.const 0))
(assert_return (invoke "load8_u" (i32.const 11)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 12)) (i32.const 0xbb))
(assert_return (invoke "load8_u" (i32.const 13)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 14)) (i32.const 0xdd))
(assert_return (invoke "load8_u" (i32.const 15)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 16)) (i32.const 0))

;; Copy ending at memory limit is ok.
(invoke "copy" (i32.const 0xff00) (i32.const 0) (i32.const 0x100))
(invoke "copy" (i32.const 0xfe00) (i32.const 0xff00) (i32.const 0x100))

;; Out-of-bounds writes trap, but all previous writes succeed.
(assert_trap (invoke "copy" (i32.const 0xfffe) (i32.const 0) (i32.const 3))
    "out of bounds memory access")
(assert_return (invoke "load8_u" (i32.const 0xfffe)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 0xffff)) (i32.const 0xbb))

;; Succeed when copying 0 bytes at the end of the region.
(invoke "copy" (i32.const 0x10000) (i32.const 0) (i32.const 0))
(invoke "copy" (i32.const 0) (i32.const 0x10000) (i32.const 0))

;; Fail on out-of-bounds when copying 0 bytes outside of memory.
(assert_trap (invoke "copy" (i32.const 0x10001) (i32.const 0) (i32.const 0))
    "out of bounds memory access")
(assert_trap (invoke "copy" (i32.const 0) (i32.const 0x10001) (i32.const 0))
    "out of bounds memory access")

;; memory.init
(module
  (memory 1)
  (data passive "\aa\bb\cc\dd")

  (func (export "init") (param i32 i32 i32)
    (memory.init 0
      (local.get 0)
      (local.get 1)
      (local.get 2)))

  (func (export "load8_u") (param i32) (result i32)
    (i32.load8_u (local.get 0)))
)

(invoke "init" (i32.const 0) (i32.const 1) (i32.const 2))
(assert_return (invoke "load8_u" (i32.const 0)) (i32.const 0xbb))
(assert_return (invoke "load8_u" (i32.const 1)) (i32.const 0xcc))
(assert_return (invoke "load8_u" (i32.const 2)) (i32.const 0))

;; Init ending at memory limit and segment limit is ok.
(invoke "init" (i32.const 0xfffc) (i32.const 0) (i32.const 4))

;; Out-of-bounds writes trap, but all previous writes succeed.
(assert_trap (invoke "init" (i32.const 0xfffe) (i32.const 0) (i32.const 3))
    "out of bounds memory access")
(assert_return (invoke "load8_u" (i32.const 0xfffe)) (i32.const 0xaa))
(assert_return (invoke "load8_u" (i32.const 0xffff)) (i32.const 0xbb))

;; Succeed when writing 0 bytes at the end of either region.
(invoke "init" (i32.const 0x10000) (i32.const 0) (i32.const 0))
(invoke "init" (i32.const 0) (i32.const 4) (i32.const 0))

;; Fail on out-of-bounds when writing 0 bytes outside of memory or segment.
(assert_trap (invoke "init" (i32.const 0x10001) (i32.const 0) (i32.const 0))
    "out of bounds memory access")
(assert_trap (invoke "init" (i32.const 0) (i32.const 5) (i32.const 0))
    "out of bounds memory access")

;; data.drop
(module
  (memory 1)
  (data passive "")
  (data (i32.const 0) "")

  (func (export "drop_passive") (data.drop 0))
  (func (export "init_passive")
    (memory.init 0 (i32.const 0) (i32.const 0) (i32.const 0)))

  (func (export "drop_active") (data.drop 1))
  (func (export "init_active")
    (memory.init 1 (i32.const 0) (i32.const 0) (i32.const 0)))
)

(invoke "init_passive")
(invoke "drop_passive")
(assert_trap (invoke "drop_passive") "data segment dropped")
(assert_trap (invoke "init_passive") "data segment dropped")
(assert_trap (invoke "drop_active") "data segment dropped")
(assert_trap (invoke "init_active") "data segment dropped")
