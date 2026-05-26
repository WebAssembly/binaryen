;; Module for demonstrating multi-threaded runtime

(func (export "multiplyby3") (param i32) (result i32) (i32.mul (local.get 0) (i32.const 3)))

(func $stackoverflow (export "stackoverflow")
      (call $stackoverflow))
