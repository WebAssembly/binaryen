;; Module demonstrating use of a host-installed callback function.

;; The type of the callback function. The type ID can be looked up outside the module by calling
;; wasm2c_[modname]_get_func_type(1, 0, WASM_RT_I32) (indicating 1 param, 0 results, param type is i32).
(type $print_type (func (param i32)))

;; An indirect function table to hold the callback function
(table $table 1 funcref)

;; A memory holding the string to be printed
(memory (export "memory") (data "Hello, world.\00"))

;; Allow the host to set the callback function
(func (export "set_print_function") (param funcref)
      (table.set $table (i32.const 0) (local.get 0)))

;; Call the callback function with the location of "Hello, world."
(func (export "say_hello")
      (call_indirect (type $print_type) (i32.const 0) (i32.const 0)))
