;; By default we error on an export name conflict.
;; (This is the same as export_options.wat, but a "not" test and a test with
;; automatic updates cannot be in the same file.)

;; RUN: not wasm-merge %s first %s.second second 2>&1 | filecheck %s
;; CHECK: Fatal: Export name conflict: func (consider --rename-export-conflicts or --skip-export-conflicts)

(module
  (func $func0 (export "func")
    ;; This export also appears in the second module.
    (drop
      (i32.const 0)
    )
  )
)
