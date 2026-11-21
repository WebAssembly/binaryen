;; Test that scratch locals created by IRBuilder cannot be accessed by index or name.

;; RUN: foreach %s %t not wasm-opt -all 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}: error: local index out of bounds
(module
  (func (result i32)
    ;; local.set by index cannot access the scratch local created for the block
    ;; parameter.
    i32.const 10
    block (param i32) (result i32)
      i32.const 99
      local.set 0
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local index out of bounds
(module
  (func (result i32)
    ;; Same, but with local.get.
    i32.const 10
    block (param i32) (result i32)
      local.get 0
      drop
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local index out of bounds
(module
  (func (result i32)
    ;; Same, but with local.tee.
    i32.const 10
    block (param i32) (result i32)
      i32.const 99
      local.tee 0
      drop
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local $scratch does not exist
(module
  (func (result i32)
    ;; local.set by name cannot access the scratch local named $scratch.
    i32.const 10
    block (param i32) (result i32)
      i32.const 99
      local.set $scratch
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local $scratch does not exist
(module
  (func (result i32)
    ;; Same, but with local.get.
    i32.const 10
    block (param i32) (result i32)
      local.get $scratch
      drop
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local $scratch_1 does not exist
(module
  (func (result i32)
    ;; When the user declares $scratch (local 0), IRBuilder's scratch local ($scratch_1)
    ;; still cannot be accessed by name.
    (local $scratch i32)
    i32.const 10
    block (param i32) (result i32)
      i32.const 99
      local.set $scratch_1
    end
  )
)

;; CHECK: Fatal: {{.*}}: error: local index out of bounds
(module
  (func (result i32)
    ;; When the user declares $scratch (local 0), IRBuilder's scratch local (local 1)
    ;; still cannot be accessed by index.
    (local $scratch i32)
    i32.const 10
    block (param i32) (result i32)
      i32.const 99
      local.set 1
    end
  )
)
