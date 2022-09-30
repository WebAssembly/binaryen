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

;; --instrument cannot be used with --symbolmap
;; RUN: not wasm-split %s --instrument --symbolmap 2>&1 \
;; RUN:   | filecheck %s --check-prefix INSTRUMENT-SYMBOLMAP

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
;; RUN:   | filecheck %s --check-prefix SPLIT-OUT

;; --instrument is required to use --profile-export
;; RUN: not wasm-split %s --profile-export=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix SPLIT-PROFILE-EXPORT

;; --secondary-memory-name cannot be used with Split mode
;; RUN: not wasm-split %s --secondary-memory-name=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix SPLIT-SECONDARY-MEMORY-NAME

;; -S cannot be used with --merge-profiles
;; RUN: not wasm-split %s --merge-profiles -S 2>&1 \
;; RUN:   | filecheck %s --check-prefix MERGE-EMIT-TEXT

;; -g cannot be used with --merge-profiles
;; RUN: not wasm-split %s --merge-profiles -g 2>&1 \
;; RUN:   | filecheck %s --check-prefix MERGE-DEBUGINFO

;; --profile cannot be used with --keep-funcs
;; RUN: not wasm-split %s --profile=foo --keep-funcs=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix PROFILE-KEEP

;; --profile cannot be used with --split-funcs
;; RUN: not wasm-split %s --profile=foo --split-funcs=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix PROFILE-SPLIT

;; --keep-funcs cannot be used with --split-funcs
;; RUN: not wasm-split %s  --keep-funcs=foo --split-funcs=foo 2>&1 \
;; RUN:   | filecheck %s --check-prefix KEEP-SPLIT

;; INSTRUMENT-PROFILE: error: Option --profile cannot be used in instrument mode.

;; INSTRUMENT-OUT1: error: Option --primary-output cannot be used in instrument mode.

;; INSTRUMENT-OUT2: error: Option --secondary-output cannot be used in instrument mode.

;; INSTRUMENT-SYMBOLMAP: error: Option --symbolmap cannot be used in instrument mode.

;; INSTRUMENT-PLACEHOLDER-NS: error: Option --placeholder-namespace cannot be used in instrument mode.

;; INSTRUMENT-EXPORT-PREFIX: error: Option --export-prefix cannot be used in instrument mode.

;; INSTRUMENT-KEEP-FUNCS: error: Option --keep-funcs cannot be used in instrument mode.

;; INSTRUMENT-SPLIT-FUNCS: error: Option --split-funcs cannot be used in instrument mode.

;; SPLIT-OUT: error: Option --output cannot be used in split mode.

;; SPLIT-PROFILE-EXPORT: error: Option --profile-export cannot be used in split mode.

;; SPLIT-SECONDARY-MEMORY-NAME: error: Option --secondary-memory-name cannot be used in split mode.

;; MERGE-EMIT-TEXT: error: Option --emit-text cannot be used in merge-profiles mode.

;; MERGE-DEBUGINFO: error: Option --debuginfo cannot be used in merge-profiles mode.

;; PROFILE-KEEP: error: Cannot use both --profile and --keep-funcs.

;; PROFILE-SPLIT: error: Cannot use both --profile and --split-funcs.

;; KEEP-SPLIT: error: Cannot use both --keep-funcs and --split-funcs.

(module)
