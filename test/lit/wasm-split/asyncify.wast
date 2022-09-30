;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.1.wasm -o2 %t.2.wasm --keep-funcs=foo --asyncify
;; RUN: wasm-dis %t.1.wasm | filecheck %s --check-prefix PRIMARY
;; RUN: wasm-dis %t.2.wasm | filecheck %s --check-prefix SECONDARY

;; Check that the --asyncify option instruments the primary module but not the
;; secondary module.

(module
 (func $foo (param i32) (result i32)
  (call $bar (i32.const 0))
 )
 (func $bar (param i32) (result i32)
  (call $foo (i32.const 1))
 )
)

;; PRIMARY:      (module
;; PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; PRIMARY-NEXT:  (type $i32_=>_none (func (param i32)))
;; PRIMARY-NEXT:  (type $none_=>_none (func))
;; PRIMARY-NEXT:  (type $none_=>_i32 (func (result i32)))
;; PRIMARY-NEXT:  (import "placeholder" "0" (func $placeholder_0 (param i32) (result i32)))
;; PRIMARY-NEXT:  (global $global$0 (mut i32) (i32.const 0))
;; PRIMARY-NEXT:  (global $global$1 (mut i32) (i32.const 0))
;; PRIMARY-NEXT:  (memory $0 1 1)
;; PRIMARY-NEXT:  (table $0 1 funcref)
;; PRIMARY-NEXT:  (elem (i32.const 0) $placeholder_0)
;; PRIMARY-NEXT:  (export "%foo" (func $foo))
;; PRIMARY-NEXT:  (export "%table" (table $0))
;; PRIMARY-NEXT:  (export "asyncify_start_unwind" (func $asyncify_start_unwind))
;; PRIMARY-NEXT:  (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
;; PRIMARY-NEXT:  (export "asyncify_start_rewind" (func $asyncify_start_rewind))
;; PRIMARY-NEXT:  (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
;; PRIMARY-NEXT:  (export "asyncify_get_state" (func $asyncify_get_state))
;; PRIMARY-NEXT:  (func $foo (param $0 i32) (result i32)
;; PRIMARY-NEXT:   (local $1 i32)
;; PRIMARY-NEXT:   (if
;; PRIMARY-NEXT:    (i32.eq
;; PRIMARY-NEXT:     (global.get $global$0)
;; PRIMARY-NEXT:     (i32.const 2)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:    (block
;; PRIMARY-NEXT:     (i32.store
;; PRIMARY-NEXT:      (global.get $global$1)
;; PRIMARY-NEXT:      (i32.sub
;; PRIMARY-NEXT:       (i32.load
;; PRIMARY-NEXT:        (global.get $global$1)
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:       (i32.const 4)
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:     (local.set $0
;; PRIMARY-NEXT:      (i32.load
;; PRIMARY-NEXT:       (i32.load
;; PRIMARY-NEXT:        (global.get $global$1)
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (local.set $1
;; PRIMARY-NEXT:    (block $label$2 (result i32)
;; PRIMARY-NEXT:     (if
;; PRIMARY-NEXT:      (i32.eqz
;; PRIMARY-NEXT:       (select
;; PRIMARY-NEXT:        (if (result i32)
;; PRIMARY-NEXT:         (i32.eq
;; PRIMARY-NEXT:          (global.get $global$0)
;; PRIMARY-NEXT:          (i32.const 2)
;; PRIMARY-NEXT:         )
;; PRIMARY-NEXT:         (block (result i32)
;; PRIMARY-NEXT:          (i32.store
;; PRIMARY-NEXT:           (global.get $global$1)
;; PRIMARY-NEXT:           (i32.sub
;; PRIMARY-NEXT:            (i32.load
;; PRIMARY-NEXT:             (global.get $global$1)
;; PRIMARY-NEXT:            )
;; PRIMARY-NEXT:            (i32.const 4)
;; PRIMARY-NEXT:           )
;; PRIMARY-NEXT:          )
;; PRIMARY-NEXT:          (i32.load
;; PRIMARY-NEXT:           (i32.load
;; PRIMARY-NEXT:            (global.get $global$1)
;; PRIMARY-NEXT:           )
;; PRIMARY-NEXT:          )
;; PRIMARY-NEXT:         )
;; PRIMARY-NEXT:         (local.get $1)
;; PRIMARY-NEXT:        )
;; PRIMARY-NEXT:        (i32.const 0)
;; PRIMARY-NEXT:        (global.get $global$0)
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:      (block
;; PRIMARY-NEXT:       (local.set $1
;; PRIMARY-NEXT:        (call_indirect (type $i32_=>_i32)
;; PRIMARY-NEXT:         (i32.const 0)
;; PRIMARY-NEXT:         (i32.const 0)
;; PRIMARY-NEXT:        )
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:       (drop
;; PRIMARY-NEXT:        (br_if $label$2
;; PRIMARY-NEXT:         (i32.const 0)
;; PRIMARY-NEXT:         (i32.eq
;; PRIMARY-NEXT:          (global.get $global$0)
;; PRIMARY-NEXT:          (i32.const 1)
;; PRIMARY-NEXT:         )
;; PRIMARY-NEXT:        )
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:       (local.set $0
;; PRIMARY-NEXT:        (local.get $1)
;; PRIMARY-NEXT:       )
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:     (if
;; PRIMARY-NEXT:      (i32.eqz
;; PRIMARY-NEXT:       (global.get $global$0)
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:      (return
;; PRIMARY-NEXT:       (local.get $0)
;; PRIMARY-NEXT:      )
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:     (unreachable)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (i32.store
;; PRIMARY-NEXT:    (i32.load
;; PRIMARY-NEXT:     (global.get $global$1)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:    (local.get $1)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (i32.store
;; PRIMARY-NEXT:    (global.get $global$1)
;; PRIMARY-NEXT:    (i32.add
;; PRIMARY-NEXT:     (i32.load
;; PRIMARY-NEXT:      (global.get $global$1)
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:     (i32.const 4)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (i32.store
;; PRIMARY-NEXT:    (i32.load
;; PRIMARY-NEXT:     (global.get $global$1)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:    (local.get $0)
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (i32.store
;; PRIMARY-NEXT:    (global.get $global$1)
;; PRIMARY-NEXT:    (i32.add
;; PRIMARY-NEXT:     (i32.load
;; PRIMARY-NEXT:      (global.get $global$1)
;; PRIMARY-NEXT:     )
;; PRIMARY-NEXT:     (i32.const 4)
;; PRIMARY-NEXT:    )
;; PRIMARY-NEXT:   )
;; PRIMARY-NEXT:   (i32.const 0)
;; PRIMARY-NEXT:  )
;; PRIMARY:       (func $asyncify_start_unwind (param $0 i32)
;; PRIMARY:       (func $asyncify_stop_unwind
;; PRIMARY:       (func $asyncify_start_rewind (param $0 i32)
;; PRIMARY:       (func $asyncify_stop_rewind
;; PRIMARY:       (func $asyncify_get_state (result i32)
;; PRIMARY:      )

;; SECONDARY:      (module
;; SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; SECONDARY-NEXT:  (import "primary" "%table" (table $timport$0 1 funcref))
;; SECONDARY-NEXT:  (import "primary" "%foo" (func $foo (param i32) (result i32)))
;; SECONDARY-NEXT:  (elem (i32.const 0) $bar)
;; SECONDARY-NEXT:  (func $bar (param $0 i32) (result i32)
;; SECONDARY-NEXT:   (call $foo
;; SECONDARY-NEXT:    (i32.const 1)
;; SECONDARY-NEXT:   )
;; SECONDARY-NEXT:  )
;; SECONDARY-NEXT: )
