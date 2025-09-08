# Copyright 2024 WebAssembly Community Group participants
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os


# Tests that the fuzzers should not operate on.
unfuzzable = [
    # Float16 is still experimental.
    'f16.wast',
    # TODO: fuzzer and interpreter support for strings
    'strings.wast',
    'simplify-locals-strings.wast',
    'string-lowering-instructions.wast',
    # TODO: fuzzer and interpreter support for extern conversions
    'extern-conversions.wast',
    # ignore DWARF because it is incompatible with multivalue atm
    'zlib.wasm',
    'cubescript.wasm',
    'class_with_dwarf_noprint.wasm',
    'fib2_dwarf.wasm',
    'fib_nonzero-low-pc_dwarf.wasm',
    'inlined_to_start_dwarf.wasm',
    'fannkuch3_manyopts_dwarf.wasm',
    'fib2_emptylocspan_dwarf.wasm',
    'fannkuch3_dwarf.wasm',
    'dwarf-local-order.wasm',
    'strip-producers.wasm',
    'multi_unit_abbrev_noprint.wasm',
    'reverse_dwarf_abbrevs.wasm',
    'print_g.wasm',
    'print_g_strip-dwarf.wasm',
    'fannkuch0_dwarf.wasm',
    'dwarfdump_roundtrip_dwarfdump.wasm',
    'dwarfdump.wasm',
    'fannkuch3_dwarf.wasm',
    'dwarf-local-order.wasm',
    'dwarf_unit_with_no_abbrevs_noprint.wasm',
    'strip-debug.wasm',
    'multi_line_table_dwarf.wasm',
    'dwarf_with_exceptions.wasm',
    'strip-dwarf.wasm',
    'ignore_missing_func_dwarf.wasm',
    'print.wasm',
    # ignore linking section as it causes us to warn about it not being fully
    # supported
    'strip-target-features.wasm',
    # TODO fuzzer support for multimemory
    'multi-memories-atomics64.wast',
    'multi-memories-basics.wast',
    'multi-memories-simd.wast',
    'multi-memories-atomics64.wasm',
    'multi-memories-basics.wasm',
    'multi-memories-simd.wasm',
    'multi-memories_size.wast',
    # TODO: fuzzer support for internalize/externalize
    'optimize-instructions-gc-extern.wast',
    'gufa-extern.wast',
    # the fuzzer does not support imported memories
    'multi-memory-lowering-import.wast',
    'multi-memory-lowering-import-error.wast',
    # the fuzzer does not support struct RMW ops
    'gc-atomics.wast',
    'gc-atomics-null-refs.wast',
    'shared-structs.wast',
    'heap2local-rmw.wast',
    'optimize-instructions-struct-rmw.wast',
    'gto-removals-rmw.wast',
    'type-refining-rmw.wast',
    'type-ssa-exact-rmw.wast',
    'cfp-rmw.wast',
    # contains too many segments to run in a wasm VM
    'limit-segments_disable-bulk-memory.wast',
    # https://github.com/WebAssembly/binaryen/issues/7176
    'names.wast',
    # huge amount of locals that make it extremely slow
    'too_much_for_liveness.wasm',
    # has (ref extern) imports, which the fuzzer cannot create values for when
    # it removes unknown imports
    'string-lifting.wast',
    'string-lifting-custom-module.wast',
    # TODO: fuzzer support for remaining stack switching instructions: switch,
    #       cont.bind
    'cont.wast',
    'precompute-stack-switching.wast',
    'coalesce-locals-stack-switching.wast',
    'stack_switching_switch_2.wast',
    'stack_switching_switch.wast',
    'unsubtyping-stack-switching.wast',
    # TODO: fix split_wast() on tricky escaping situations like a string ending
    #       in \\" (the " is not escaped - there is an escaped \ before it)
    'string-lifting-section.wast',
    # TODO: fuzzer support for uninhabitable imported globals
    'exact-references.wast',
    # We do not have full suppor for these imports in all parts of the fuzzer.
    'instrument-branch-hints.wast',
    # Contains a subtype chain that exceeds depth limits.
    'reorder-types-real.wast',
]


def is_fuzzable(name):
    name = os.path.basename(name)

    # It makes no sense to fuzz things that check validation errors.
    if '.fail.' in name:
        return False

    return name not in unfuzzable
