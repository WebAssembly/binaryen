;; Non-natural alignment on atomic memory ops is a parse error.

;; RUN: foreach %s %t not wasm-opt --enable-threads -o /dev/null 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (i32.atomic.load align=1 (i32.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func
    (i32.atomic.store align=2 (i32.const 0) (i32.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (i32.atomic.rmw.add align=1 (i32.const 0) (i32.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (i32.atomic.rmw.cmpxchg align=1 (i32.const 0) (i32.const 0) (i32.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (memory.atomic.wait32 align=1 (i32.const 0) (i32.const 0) (i64.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (memory.atomic.wait64 align=4 (i32.const 0) (i64.const 0) (i64.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i32)
    (memory.atomic.notify align=1 (i32.const 0) (i32.const 0)))
)

;; CHECK: Fatal: {{.*}}: error: atomic accesses must have natural alignment
(module
  (memory 1 1 shared)
  (func (result i64)
    (i64.atomic.load32_u align=8 (i32.const 0)))
)
