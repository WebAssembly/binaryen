;; RUN: not wasm-split %s --export-prefix='%' -g -o1 %t.none.1.wasm -o2 %t.none.2.wasm --keep-funcs=@failed-to-open.txt -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix FAILED-TO-OPEN

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.none.1.wasm -o2 %t.none.2.wasm -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-NONE
;; RUN: wasm-dis %t.none.1.wasm | filecheck %s --check-prefix KEEP-NONE-PRIMARY
;; RUN: wasm-dis %t.none.2.wasm | filecheck %s --check-prefix KEEP-NONE-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.none.1.wasm -o2 %t.none.2.wasm --keep-funcs=@%S/none.txt -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-NONE
;; RUN: wasm-dis %t.none.1.wasm | filecheck %s --check-prefix KEEP-NONE-PRIMARY
;; RUN: wasm-dis %t.none.2.wasm | filecheck %s --check-prefix KEEP-NONE-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm --keep-funcs=foo -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-FOO
;; RUN: wasm-dis %t.foo.1.wasm | filecheck %s --check-prefix KEEP-FOO-PRIMARY
;; RUN: wasm-dis %t.foo.2.wasm | filecheck %s --check-prefix KEEP-FOO-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.foo.1.wasm -o2 %t.foo.2.wasm --keep-funcs=@%S/foo.txt -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-FOO
;; RUN: wasm-dis %t.foo.1.wasm | filecheck %s --check-prefix KEEP-FOO-PRIMARY
;; RUN: wasm-dis %t.foo.2.wasm | filecheck %s --check-prefix KEEP-FOO-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm --keep-funcs=bar -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BAR
;; RUN: wasm-dis %t.bar.1.wasm | filecheck %s --check-prefix KEEP-BAR-PRIMARY
;; RUN: wasm-dis %t.bar.2.wasm | filecheck %s --check-prefix KEEP-BAR-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.bar.1.wasm -o2 %t.bar.2.wasm --keep-funcs=@%S/bar.txt -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BAR
;; RUN: wasm-dis %t.bar.1.wasm | filecheck %s --check-prefix KEEP-BAR-PRIMARY
;; RUN: wasm-dis %t.bar.2.wasm | filecheck %s --check-prefix KEEP-BAR-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.both.1.wasm -o2 %t.both.2.wasm --keep-funcs=foo,bar -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BOTH
;; RUN: wasm-dis %t.both.1.wasm | filecheck %s --check-prefix KEEP-BOTH-PRIMARY
;; RUN: wasm-dis %t.both.2.wasm | filecheck %s --check-prefix KEEP-BOTH-SECONDARY

;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.both.1.wasm -o2 %t.both.2.wasm --keep-funcs=@%S/both.txt -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-BOTH
;; RUN: wasm-dis %t.both.1.wasm | filecheck %s --check-prefix KEEP-BOTH-PRIMARY
;; RUN: wasm-dis %t.both.2.wasm | filecheck %s --check-prefix KEEP-BOTH-SECONDARY

;; Also check the inverse workflow using --keep-all and --split-funcs
;; RUN: wasm-split %s --export-prefix='%' -g -o1 %t.split-bar.1.wasm -o2 %t.split-bar.2.wasm --split-funcs=bar -v 2>&1 \
;; RUN:     | filecheck %s --check-prefix KEEP-FOO
;; RUN: wasm-dis %t.split-bar.1.wasm | filecheck %s --check-prefix KEEP-FOO-PRIMARY
;; RUN: wasm-dis %t.split-bar.2.wasm | filecheck %s --check-prefix KEEP-FOO-SECONDARY

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

;; FAILED-TO-OPEN: Failed opening 'failed-to-open.txt'

;; KEEP-NONE: warning: not keeping any functions in the primary module

;; KEEP-NONE-PRIMARY:      (module
;; KEEP-NONE-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-NONE-PRIMARY-NEXT:  (import "placeholder" "0" (func $placeholder_0 (param i32) (result i32)))
;; KEEP-NONE-PRIMARY-NEXT:  (table $table 1 1 funcref)
;; KEEP-NONE-PRIMARY-NEXT:  (elem (i32.const 0) $placeholder_0)
;; KEEP-NONE-PRIMARY-NEXT:  (export "%table" (table $table))
;; KEEP-NONE-PRIMARY-NEXT: )

;; KEEP-NONE-SECONDARY:      (module
;; KEEP-NONE-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-NONE-SECONDARY-NEXT:  (import "primary" "%table" (table $table 1 1 funcref))
;; KEEP-NONE-SECONDARY-NEXT:  (elem (i32.const 0) $foo)
;; KEEP-NONE-SECONDARY-NEXT:  (func $bar (param $0 i32) (result i32)
;; KEEP-NONE-SECONDARY-NEXT:   (call $foo
;; KEEP-NONE-SECONDARY-NEXT:    (i32.const 1)
;; KEEP-NONE-SECONDARY-NEXT:   )
;; KEEP-NONE-SECONDARY-NEXT:  )
;; KEEP-NONE-SECONDARY-NEXT:  (func $foo (param $0 i32) (result i32)
;; KEEP-NONE-SECONDARY-NEXT:   (call $bar
;; KEEP-NONE-SECONDARY-NEXT:    (i32.const 0)
;; KEEP-NONE-SECONDARY-NEXT:   )
;; KEEP-NONE-SECONDARY-NEXT:  )
;; KEEP-NONE-SECONDARY-NEXT: )

;; KEEP-FOO: Keeping functions: foo{{$}}
;; KEEP-FOO-NEXT: Splitting out functions: bar{{$}}

;; KEEP-FOO-PRIMARY:      (module
;; KEEP-FOO-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-FOO-PRIMARY-NEXT:  (import "placeholder" "1" (func $placeholder_1 (param i32) (result i32)))
;; KEEP-FOO-PRIMARY-NEXT:  (table $table 2 2 funcref)
;; KEEP-FOO-PRIMARY-NEXT:  (elem (i32.const 0) $foo $placeholder_1)
;; KEEP-FOO-PRIMARY-NEXT:  (export "%foo" (func $foo))
;; KEEP-FOO-PRIMARY-NEXT:  (export "%table" (table $table))
;; KEEP-FOO-PRIMARY-NEXT:  (func $foo (param $0 i32) (result i32)
;; KEEP-FOO-PRIMARY-NEXT:   (call_indirect (type $i32_=>_i32)
;; KEEP-FOO-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-FOO-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-FOO-PRIMARY-NEXT:   )
;; KEEP-FOO-PRIMARY-NEXT:  )
;; KEEP-FOO-PRIMARY-NEXT: )

;; KEEP-FOO-SECONDARY:      (module
;; KEEP-FOO-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-FOO-SECONDARY-NEXT:  (import "primary" "%table" (table $table 2 2 funcref))
;; KEEP-FOO-SECONDARY-NEXT:  (import "primary" "%foo" (func $foo (param i32) (result i32)))
;; KEEP-FOO-SECONDARY-NEXT:  (elem (i32.const 1) $bar)
;; KEEP-FOO-SECONDARY-NEXT:  (func $bar (param $0 i32) (result i32)
;; KEEP-FOO-SECONDARY-NEXT:   (call $foo
;; KEEP-FOO-SECONDARY-NEXT:    (i32.const 1)
;; KEEP-FOO-SECONDARY-NEXT:   )
;; KEEP-FOO-SECONDARY-NEXT:  )
;; KEEP-FOO-SECONDARY-NEXT: )

;; KEEP-BAR: Keeping functions: bar{{$}}
;; KEEP-BAR-NEXT: Splitting out functions: foo{{$}}

;; KEEP-BAR-PRIMARY:      (module
;; KEEP-BAR-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BAR-PRIMARY-NEXT:  (import "placeholder" "0" (func $placeholder_0 (param i32) (result i32)))
;; KEEP-BAR-PRIMARY-NEXT:  (table $table 1 1 funcref)
;; KEEP-BAR-PRIMARY-NEXT:  (elem (i32.const 0) $placeholder_0)
;; KEEP-BAR-PRIMARY-NEXT:  (export "%bar" (func $bar))
;; KEEP-BAR-PRIMARY-NEXT:  (export "%table" (table $table))
;; KEEP-BAR-PRIMARY-NEXT:  (func $bar (param $0 i32) (result i32)
;; KEEP-BAR-PRIMARY-NEXT:   (call_indirect (type $i32_=>_i32)
;; KEEP-BAR-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-BAR-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-BAR-PRIMARY-NEXT:   )
;; KEEP-BAR-PRIMARY-NEXT:  )
;; KEEP-BAR-PRIMARY-NEXT: )

;; KEEP-BAR-SECONDARY:      (module
;; KEEP-BAR-SECONDARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BAR-SECONDARY-NEXT:  (import "primary" "%table" (table $table 1 1 funcref))
;; KEEP-BAR-SECONDARY-NEXT:  (import "primary" "%bar" (func $bar (param i32) (result i32)))
;; KEEP-BAR-SECONDARY-NEXT:  (elem (i32.const 0) $foo)
;; KEEP-BAR-SECONDARY-NEXT:  (func $foo (param $0 i32) (result i32)
;; KEEP-BAR-SECONDARY-NEXT:   (call $bar
;; KEEP-BAR-SECONDARY-NEXT:    (i32.const 0)
;; KEEP-BAR-SECONDARY-NEXT:   )
;; KEEP-BAR-SECONDARY-NEXT:  )
;; KEEP-BAR-SECONDARY-NEXT: )

;; KEEP-BOTH: warning: not splitting any functions out to the secondary module
;; KEEP-BOTH-NEXT: Keeping functions: bar, foo{{$}}
;; KEEP-BOTH-NEXT: Splitting out functions: {{$}}

;; KEEP-BOTH-PRIMARY:      (module
;; KEEP-BOTH-PRIMARY-NEXT:  (type $i32_=>_i32 (func (param i32) (result i32)))
;; KEEP-BOTH-PRIMARY-NEXT:  (table $table 1 1 funcref)
;; KEEP-BOTH-PRIMARY-NEXT:  (elem (i32.const 0) $foo)
;; KEEP-BOTH-PRIMARY-NEXT:  (export "%table" (table $table))
;; KEEP-BOTH-PRIMARY-NEXT:  (func $foo (param $0 i32) (result i32)
;; KEEP-BOTH-PRIMARY-NEXT:   (call $bar
;; KEEP-BOTH-PRIMARY-NEXT:    (i32.const 0)
;; KEEP-BOTH-PRIMARY-NEXT:   )
;; KEEP-BOTH-PRIMARY-NEXT:  )
;; KEEP-BOTH-PRIMARY-NEXT:  (func $bar (param $0 i32) (result i32)
;; KEEP-BOTH-PRIMARY-NEXT:   (call $foo
;; KEEP-BOTH-PRIMARY-NEXT:    (i32.const 1)
;; KEEP-BOTH-PRIMARY-NEXT:   )
;; KEEP-BOTH-PRIMARY-NEXT:  )
;; KEEP-BOTH-PRIMARY-NEXT: )

;; KEEP-BOTH-SECONDARY:      (module
;; KEEP-BOTH-SECONDARY-NEXT:  (import "primary" "%table" (table $table 1 1 funcref))
;; KEEP-BOTH-SECONDARY-NEXT: )
