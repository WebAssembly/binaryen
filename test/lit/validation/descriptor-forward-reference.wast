;; RUN: not wasm-opt -all %s 2>&1 | filecheck %s

(module
  ;; These types should be in the same rec group!
  ;; CHECK: invalid type: Descriptor clause is a forward reference
  (type $Default (descriptor $Default.desc) (struct (field i32)))
  (type $Default.desc (describes $Default) (struct (field (ref extern))))
)
