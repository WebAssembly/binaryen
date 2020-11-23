;; RUN: wasm-split %s --export-prefix='%' -o1 %t.none.1.wasm -o2 %t.none.2.wasm -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-NONE
;; RUN: wasm-dis %t.none.1.wasm | filecheck %s --check-prefix KEEP-NONE-PRIMARY
;; RUN: wasm-dis %t.none.2.wasm | filecheck %s --check-prefix KEEP-NONE-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm --keep-funcs=foo -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-FOO
;; RUN: wasm-dis %t.foo.1.wasm | filecheck %s --check-prefix KEEP-FOO-PRIMARY
;; RUN: wasm-dis %t.foo.2.wasm | filecheck %s --check-prefix KEEP-FOO-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm --keep-funcs=bar -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BAR
;; RUN: wasm-dis %t.bar.1.wasm | filecheck %s --check-prefix KEEP-BAR-PRIMARY
;; RUN: wasm-dis %t.bar.2.wasm | filecheck %s --check-prefix KEEP-BAR-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -o1 %t.both.1.wasm -o2 %t.both.2.wasm --keep-funcs=foo,bar -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BOTH
;; RUN: wasm-dis %t.both.1.wasm | filecheck %s --check-prefix KEEP-BOTH-PRIMARY
;; RUN: wasm-dis %t.both.2.wasm | filecheck %s --check-prefix KEEP-BOTH-SECONDARY

(module
 (table $table 1 1 funcref)
 (elem (i32.const 0) $foo)
 (func $foo (param i32) (result i32)
  (call $bar (i32.const 0))
 )
 (func $bar (param i32) (result i32)
  (call $foo (i32.const 1))
 )
)

;; KEEP-NONE: warning: not keeping any functions in the primary module

;; KEEP-NONE-PRIMARY:      (module
;; KEEP-NONE-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-NONE-PRIMARY-NEXT:  (import "placeholder" "0" (func $fimport$0 (param i32) (result i32)))
;; KEEP-NONE-PRIMARY-NEXT:  (table $0 1 1 funcref)
;; KEEP-NONE-PRIMARY-NEXT:  (elem (i32.const 0) $fimport$0)
;; KEEP-NONE-PRIMARY-NEXT:  (export "%table" (table $0))
;; KEEP-NONE-PRIMARY-NEXT: )

;; KEEP-NONE-SECONDARY:      (module
;; KEEP-NONE-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-NONE-SECONDARY-NEXT:  (import "primary" "%table" (table $timport$0 1 1 funcref))
;; KEEP-NONE-SECONDARY-NEXT:  (elem (i32.const 0) $1)
;; KEEP-NONE-SECONDARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-NONE-SECONDARY-NEXT:   (call $1
;; KEEP-NONE-SECONDARY-NEXT:    (i32.const 1)
;; KEEP-NONE-SECONDARY-NEXT:   )
;; KEEP-NONE-SECONDARY-NEXT:  )
;; KEEP-NONE-SECONDARY-NEXT:  (func $1 (param $0 i32) (result i32)
;; KEEP-NONE-SECONDARY-NEXT:   (call $0
;; KEEP-NONE-SECONDARY-NEXT:    (i32.const 0)
;; KEEP-NONE-SECONDARY-NEXT:   )
;; KEEP-NONE-SECONDARY-NEXT:  )
;; KEEP-NONE-SECONDARY-NEXT: )

;; KEEP-FOO: Keeping functions: foo{{$}}
;; KEEP-FOO-NEXT: Splitting out functions: bar{{$}}

;; KEEP-FOO-PRIMARY:      (module
;; KEEP-FOO-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-FOO-PRIMARY-NEXT:  (import "placeholder" "1" (func $fimport$0 (param i32) (result i32)))
;; KEEP-FOO-PRIMARY-NEXT:  (table $0 2 2 funcref)
;; KEEP-FOO-PRIMARY-NEXT:  (elem (i32.const 0) $0 $fimport$0)
;; KEEP-FOO-PRIMARY-NEXT:  (export "%foo" (func $0))
;; KEEP-FOO-PRIMARY-NEXT:  (export "%table" (table $0))
;; KEEP-FOO-PRIMARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-FOO-PRIMARY-NEXT:   (call_indirect (type $i32_=>_i32)
;; KEEP-FOO-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-FOO-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-FOO-PRIMARY-NEXT:   )
;; KEEP-FOO-PRIMARY-NEXT:  )
;; KEEP-FOO-PRIMARY-NEXT: )

;; KEEP-FOO-SECONDARY:      (module
;; KEEP-FOO-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-FOO-SECONDARY-NEXT:  (import "primary" "%table" (table $timport$0 2 2 funcref))
;; KEEP-FOO-SECONDARY-NEXT:  (elem (i32.const 1) $0)
;; KEEP-FOO-SECONDARY-NEXT:  (import "primary" "%foo" (func $fimport$0 (param i32) (result i32)))
;; KEEP-FOO-SECONDARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-FOO-SECONDARY-NEXT:   (call $fimport$0
;; KEEP-FOO-SECONDARY-NEXT:    (i32.const 1)
;; KEEP-FOO-SECONDARY-NEXT:   )
;; KEEP-FOO-SECONDARY-NEXT:  )
;; KEEP-FOO-SECONDARY-NEXT: )

;; KEEP-BAR: Keeping functions: bar{{$}}
;; KEEP-BAR-NEXT: Splitting out functions: foo{{$}}

;; KEEP-BAR-PRIMARY:      (module
;; KEEP-BAR-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BAR-PRIMARY-NEXT:  (import "placeholder" "0" (func $fimport$0 (param i32) (result i32)))
;; KEEP-BAR-PRIMARY-NEXT:  (table $0 1 1 funcref)
;; KEEP-BAR-PRIMARY-NEXT:  (elem (i32.const 0) $fimport$0)
;; KEEP-BAR-PRIMARY-NEXT:  (export "%bar" (func $0))
;; KEEP-BAR-PRIMARY-NEXT:  (export "%table" (table $0))
;; KEEP-BAR-PRIMARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-BAR-PRIMARY-NEXT:   (call_indirect (type $i32_=>_i32)
;; KEEP-BAR-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-BAR-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-BAR-PRIMARY-NEXT:   )
;; KEEP-BAR-PRIMARY-NEXT:  )
;; KEEP-BAR-PRIMARY-NEXT: )

;; KEEP-BAR-SECONDARY:      (module
;; KEEP-BAR-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BAR-SECONDARY-NEXT:  (import "primary" "%table" (table $timport$0 1 1 funcref))
;; KEEP-BAR-SECONDARY-NEXT:  (elem (i32.const 0) $0)
;; KEEP-BAR-SECONDARY-NEXT:  (import "primary" "%bar" (func $fimport$0 (param i32) (result i32)))
;; KEEP-BAR-SECONDARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-BAR-SECONDARY-NEXT:   (call $fimport$0
;; KEEP-BAR-SECONDARY-NEXT:    (i32.const 0)
;; KEEP-BAR-SECONDARY-NEXT:   )
;; KEEP-BAR-SECONDARY-NEXT:  )
;; KEEP-BAR-SECONDARY-NEXT: )

;; KEEP-BOTH: warning: not splitting any functions out to the secondary module
;; KEEP-BOTH-NEXT: Keeping functions: bar, foo{{$}}
;; KEEP-BOTH-NEXT: Splitting out functions:{{$}}

;; KEEP-BOTH-PRIMARY:      (module
;; KEEP-BOTH-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BOTH-PRIMARY-NEXT:  (table $0 1 1 funcref)
;; KEEP-BOTH-PRIMARY-NEXT:  (elem (i32.const 0) $0)
;; KEEP-BOTH-PRIMARY-NEXT:  (export "%table" (table $0))
;; KEEP-BOTH-PRIMARY-NEXT:  (func $0 (param $0 i32) (result i32)
;; KEEP-BOTH-PRIMARY-NEXT:   (call $1
;; KEEP-BOTH-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-BOTH-PRIMARY-NEXT:   )
;; KEEP-BOTH-PRIMARY-NEXT:  )
;; KEEP-BOTH-PRIMARY-NEXT:  (func $1 (param $0 i32) (result i32)
;; KEEP-BOTH-PRIMARY-NEXT:   (call $0
;; KEEP-BOTH-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-BOTH-PRIMARY-NEXT:   )
;; KEEP-BOTH-PRIMARY-NEXT:  )
;; KEEP-BOTH-PRIMARY-NEXT: )

;; KEEP-BOTH-SECONDARY:      (module
;; KEEP-BOTH-SECONDARY-NEXT:  (import "primary" "%table" (table $timport$0 1 1 funcref))
;; KEEP-BOTH-SECONDARY-NEXT: )
