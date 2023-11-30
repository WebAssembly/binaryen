(module
  ;; This export is given the name "func$test" in the graph.text file, which
  ;; collides with the internal name we give the function. A unique name should
  ;; be generated for the function.
  (export "test" (func $test))

  (func $test)
)
