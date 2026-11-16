;; RUN: not wasm-opt %s 2>&1 | filecheck %s

;; CHECK: Fatal: {{.*}}:5:27: error: expected type index or identifier

(module (func (block (type $))))
