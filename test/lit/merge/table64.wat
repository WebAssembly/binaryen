;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-merge %s first %s.second second --rename-export-conflicts -all -S -o - | filecheck %s

;; An empty module. The interesting part is in the second module.
(module
)
