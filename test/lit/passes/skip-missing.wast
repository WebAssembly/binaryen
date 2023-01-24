;; We should warn on a pass called "waka" not having been run and skipped.

;; RUN: wasm-opt %s -O1 --skip-pass=waka 2>&1 | filecheck %s

;; CHECK: warning: --waka was requested to be skipped, but it was not found in the passes that were run.

(module
)
