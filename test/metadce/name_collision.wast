(module
  ;; This export is given the name "func$other" in the graph.text file, which
  ;; collides with the internal name we give the function. A unique name should
  ;; be generated for the function in the stdout that mentions it is unused,
  ;; specifically we see
  ;;
  ;;  unused: func$other$0
  ;;
  ;; (the $0 suffix keeps it unique).
  (export "test" (func $test))

  ;; This function is used by the export.
  (func $test)

  ;; This function is not used.
  (func $other)
)
