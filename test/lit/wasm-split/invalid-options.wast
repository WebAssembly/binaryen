;; Test that invalid command line option combinations are properly rejected with
;; helpful error messages.

;; --instrument cannot be used with --profile
;; RUN: not wasm-split %s --instrument --profile %t 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-PROFILE

;; --instrument cannot be used with -o1
;; RUN: not wasm-split %s --instrument -o1 %t 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-OUT1

;; --instrument cannot be used with -o2
;; RUN: not wasm-split %s --instrument -o2 %t 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-OUT2

;; --instrument cannot be used with --import-namespace
;; RUN: not wasm-split %s --instrument --import-namespace=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-IMPORT-NS

;; --instrument cannot be used with --placeholder-namespace
;; RUN: not wasm-split %s --instrument --placeholder-namespace=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-PLACEHOLDER-NS

;; --instrument cannot be used with --export-prefix
;; RUN: not wasm-split %s --instrument --export-prefix=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-EXPORT-PREFIX

;; --instrument cannot be used with --keep-funcs
;; RUN: not wasm-split %s --instrument --keep-funcs=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-KEEP-FUNCS

;; --instrument cannot be used with --split-funcs
;; RUN: not wasm-split %s --instrument --split-funcs=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-SPLIT-FUNCS

;; Split mode requires -o1 and -o2 rather than -o
;; RUN: not wasm-split %s -o %t 2>&1 \
;; RUN:   | filecheck %s --check-prefix NO-INSTRUMENT-OUT

;; --instrument is required to use --profile-export
;; RUN: not wasm-split %s --profile-export=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix NO-INSTRUMENT-PROFILE-EXPORT

;; INSTRUMENT-PROFILE: error: --profile cannot be used with --instrument

;; INSTRUMENT-OUT1: error: primary output cannot be used with --instrument

;; INSTRUMENT-OUT2: error: secondary output cannot be used with --instrument

;; INSTRUMENT-IMPORT-NS: error: --import-namespace cannot be used with --instrument

;; INSTRUMENT-PLACEHOLDER-NS: error: --placeholder-namespace cannot be used with --instrument

;; INSTRUMENT-EXPORT-PREFIX: error: --export-prefix cannot be used with --instrument

;; INSTRUMENT-KEEP-FUNCS: error: --keep-funcs cannot be used with --instrument

;; INSTRUMENT-SPLIT-FUNCS: error: --split-funcs cannot be used with --instrument

;; NO-INSTRUMENT-OUT: error: must provide separate primary and secondary output with -o1 and -o2

;; NO-INSTRUMENT-PROFILE-EXPORT: error: --profile-export must be used with --instrument

(module)
