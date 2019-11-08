(module
  (memory $0 (shared 23 256))
  (func (export "atomic-fence")
    (atomic.fence)
  )
)

(assert_return (invoke "atomic-fence"))
