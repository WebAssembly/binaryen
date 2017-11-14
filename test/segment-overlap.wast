(module
 (memory $0 10)
 (data (i32.const 100) "\ff\ff\ff\ff\ff\ff\ff\ff") ;; overlaps with the next
 (data (i32.const 104) "\00\00\00\00")
)

