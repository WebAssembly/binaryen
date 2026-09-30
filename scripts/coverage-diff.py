#!/usr/bin/env python3
# Copyright 2026 WebAssembly Community Group participants
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

"""Multi-metric differential test coverage reporter for Binaryen.

Intersects `git diff` hunks with Clang/LLVM source-based code coverage
(`llvm-cov export`) to report Line, Region, Branch, MC/DC, and Function
coverage specifically for the code modified in a change.
"""

import argparse
import glob
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass, field

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

CPP_EXTENSIONS = {'.c', '.cc', '.cpp', '.cxx', '.c++', '.h', '.hpp', '.inc'}

HUNK_RE = re.compile(r'^@@ -\d+(?:,\d+)? \+(\d+)(?:,(\d+))? @@')
UNREACHABLE_RE = re.compile(
    r'\b(WASM_UNREACHABLE|WASM_BUILTIN_UNREACHABLE|__builtin_unreachable)\b'
    r'|LCOV_EXCL_LINE|GCOVR_EXCL_LINE|COV_EXCL_LINE',
)
DEFAULT_LABEL_RE = re.compile(r'^\s*default\s*:\s*(//.*|/\*.*\*/)?$')

# CounterMappingRegion::RegionKind values in llvm-cov JSON export.
REGION_KIND_CODE = 0


@dataclass
class Segment:
    line: int
    col: int
    count: int
    has_count: bool
    is_region_entry: bool
    is_gap_region: bool


@dataclass
class LineStat:
    line: int
    mapped: bool
    count: int


@dataclass
class CodeRegion:
    line_start: int
    col_start: int
    line_end: int
    col_end: int
    count: int


@dataclass
class BranchRecord:
    line_start: int
    col_start: int
    line_end: int
    col_end: int
    true_count: int
    false_count: int


@dataclass
class MCDCRecord:
    line_start: int
    col_start: int
    line_end: int
    col_end: int
    conditions: list[bool]


@dataclass
class FunctionSpan:
    name: str
    demangled_name: str
    line_start: int
    line_end: int
    count: int


@dataclass
class MetricCounts:
    covered: int = 0
    total: int = 0

    def add(self, covered: int, total: int):
        self.covered += covered
        self.total += total

    @property
    def percent(self) -> float | None:
        if self.total == 0:
            return None
        return (self.covered * 100.0) / self.total

    def format_summary(self) -> str:
        if self.total == 0:
            return 'N/A (0 in diff)'
        return f'{self.covered} / {self.total} ({self.percent:.1f}%)'


@dataclass
class FileDiffCoverage:
    rel_path: str
    abs_path: str
    diff_lines: list[int]
    hunks: list[tuple[int, int]]
    lines: MetricCounts = field(default_factory=MetricCounts)
    regions: MetricCounts = field(default_factory=MetricCounts)
    branches: MetricCounts = field(default_factory=MetricCounts)
    mcdc: MetricCounts = field(default_factory=MetricCounts)
    functions: MetricCounts = field(default_factory=MetricCounts)
    non_executable_diff_lines: int = 0
    excluded_unreachable_lines: int = 0
    line_stats: dict[int, LineStat] = field(default_factory=dict)
    uncovered_functions: list[FunctionSpan] = field(default_factory=list)
    uncovered_lines: list[int] = field(default_factory=list)
    uncovered_subregions: list[CodeRegion] = field(default_factory=list)
    uncovered_branches: list[BranchRecord] = field(default_factory=list)
    uncovered_mcdc: list[MCDCRecord] = field(default_factory=list)
    in_coverage_map: bool = True


def find_llvm_tool(tool_name: str, explicit_path: str | None = None) -> str | None:
    if explicit_path:
        return explicit_path if shutil.which(explicit_path) or os.path.isfile(explicit_path) else None
    llvm_version = os.environ.get('LLVM_VERSION')
    if llvm_version:
        found = shutil.which(f'{tool_name}-{llvm_version}')
        if found:
            return found
    found = shutil.which(tool_name)
    if found:
        return found
    # Search PATH for versioned binaries (e.g. llvm-cov-22) and pick the newest.
    pattern = re.compile(rf'^{re.escape(tool_name)}-(\d+)$')
    versioned: list[tuple[int, str]] = []
    for path_dir in os.environ.get('PATH', '').split(os.pathsep):
        if not path_dir or not os.path.isdir(path_dir):
            continue
        try:
            for entry in os.listdir(path_dir):
                m = pattern.match(entry)
                if m:
                    full = os.path.join(path_dir, entry)
                    if os.path.isfile(full) and os.access(full, os.X_OK):
                        versioned.append((int(m.group(1)), full))
        except OSError:
            continue
    if versioned:
        versioned.sort(key=lambda item: item[0], reverse=True)
        return versioned[0][1]
    return None


def parse_cmake_cache(cache_path: str) -> dict[str, str]:
    entries: dict[str, str] = {}
    if not os.path.isfile(cache_path):
        return entries
    with open(cache_path, errors='replace') as f:
        for raw_line in f:
            line = raw_line.strip()
            if not line or line.startswith(('#', '//')):
                continue
            if ':' in line and '=' in line:
                key_type, val = line.split('=', 1)
                key = key_type.split(':', 1)[0]
                entries[key] = val
    return entries


def check_build_dir_coverage_config(build_dir: str) -> tuple[bool, str, dict[str, str]]:
    """Return (is_valid, reason, cmake_cache_dict)."""
    cache_path = os.path.join(build_dir, 'CMakeCache.txt')
    if not os.path.isfile(cache_path):
        return False, f"No CMakeCache.txt found in '{build_dir}'.", {}

    cache = parse_cmake_cache(cache_path)
    cxx = cache.get('CMAKE_CXX_COMPILER', '')
    build_type = cache.get('CMAKE_BUILD_TYPE', 'Release').upper()
    cxx_flags = ' '.join([
        cache.get('CMAKE_CXX_FLAGS', ''),
        cache.get(f'CMAKE_CXX_FLAGS_{build_type}', ''),
    ])
    c_flags = ' '.join([
        cache.get('CMAKE_C_FLAGS', ''),
        cache.get(f'CMAKE_C_FLAGS_{build_type}', ''),
    ])

    cxx_base = os.path.basename(cxx)
    if 'clang' not in cxx_base:
        return (
            False,
            f"Build in '{build_dir}' uses compiler '{cxx or 'unknown'}' instead of Clang "
            "(Clang is required for source-based coverage mapping).",
            cache,
        )

    required_flags = ('-fprofile-instr-generate', '-fcoverage-mapping')
    missing_cxx = [fl for fl in required_flags if fl not in cxx_flags]
    missing_c = [fl for fl in required_flags if fl not in c_flags]
    if missing_cxx or missing_c:
        return (
            False,
            f"Build in '{build_dir}' is missing coverage flags "
            f"({', '.join(required_flags)}) in CMAKE_C_FLAGS / CMAKE_CXX_FLAGS.",
            cache,
        )

    return True, 'OK', cache


def discover_build_dir(explicit_dir: str | None) -> tuple[str, bool, str, dict[str, str]]:
    """Find a coverage-configured build directory or report why candidates failed."""
    if explicit_dir:
        abs_dir = os.path.abspath(explicit_dir)
        ok, reason, cache = check_build_dir_coverage_config(abs_dir)
        return abs_dir, ok, reason, cache

    env_dir = os.environ.get('BINARYEN_BUILD_DIR')
    if env_dir:
        abs_dir = os.path.abspath(env_dir)
        ok, reason, cache = check_build_dir_coverage_config(abs_dir)
        return abs_dir, ok, reason, cache

    candidates = [
        os.path.join(REPO_ROOT, 'out', 'cov'),
        os.path.join(REPO_ROOT, 'build', 'cov'),
        os.path.join(REPO_ROOT, 'cov'),
        REPO_ROOT,
        os.path.join(REPO_ROOT, 'out', 'debug'),
        os.path.join(REPO_ROOT, 'build', 'debug'),
        os.path.join(REPO_ROOT, 'debug'),
        os.path.join(REPO_ROOT, 'out'),
        os.path.join(REPO_ROOT, 'build'),
    ]

    first_existing = None
    for cand in candidates:
        ok, reason, cache = check_build_dir_coverage_config(cand)
        if ok:
            return cand, True, reason, cache
        if first_existing is None and os.path.isfile(os.path.join(cand, 'CMakeCache.txt')):
            first_existing = (cand, False, reason, cache)

    if first_existing:
        return first_existing

    default_cov_dir = os.path.join(REPO_ROOT, 'out', 'cov')
    return default_cov_dir, False, f"No coverage build directory found (checked '{default_cov_dir}' and repo root).", {}


def print_setup_instructions(reason: str, suggested_build_dir: str = 'out/cov'):
    rel_build = os.path.relpath(os.path.abspath(suggested_build_dir), REPO_ROOT)
    if rel_build == '.':
        rel_build = 'out/cov'
    print(f'Error: Build is not configured for coverage reporting.\n  Reason: {reason}\n', file=sys.stderr)
    print(
        f"""To collect multi-metric diff coverage, configure a Clang coverage build:

  1. Configure CMake with Clang source-based coverage flags (e.g. in '{rel_build}'):
     cmake -S . -B {rel_build} -G Ninja \\
       -DCMAKE_BUILD_TYPE=Debug \\
       -DCMAKE_C_COMPILER=clang \\
       -DCMAKE_CXX_COMPILER=clang++ \\
       -DCMAKE_C_FLAGS="-fprofile-instr-generate -fcoverage-mapping -fcoverage-mcdc" \\
       -DCMAKE_CXX_FLAGS="-fprofile-instr-generate -fcoverage-mapping -fcoverage-mcdc"

  2. Build the targets exercised by your tests (e.g. wasm-opt, binaryen-lit, binaryen-unittests):
     ninja -C {rel_build} wasm-opt binaryen-lit binaryen-unittests

  3. Run this tool with your test(s) to collect profiles and report diff coverage in one step:
     ./scripts/coverage-diff.py -B {rel_build} --lit test/lit/passes/<your-test>.wast
     ./scripts/coverage-diff.py -B {rel_build} --gtest "*YourTest*"
     ./scripts/coverage-diff.py -B {rel_build} --run "{rel_build}/bin/wasm-opt ..."
""",
        file=sys.stderr,
    )


def print_missing_profile_instructions(build_dir: str):
    rel_build = os.path.relpath(build_dir, REPO_ROOT)
    bin_prefix = f'{rel_build}/bin' if rel_build != '.' else './bin'
    b_flag = f'-B {rel_build} ' if rel_build not in {'.', 'out/cov'} else ''
    print(
        f"Error: No coverage profile data (.profraw or .profdata) found in '{rel_build}'.\n",
        file=sys.stderr,
    )
    print(
        f"""Run tests through coverage-diff.py to automatically generate and merge profiles:

  # Run specific lit test(s):
  ./scripts/coverage-diff.py {b_flag}--lit test/lit/passes/<your-test>.wast

  # Run GTest unit tests (all or filtered):
  ./scripts/coverage-diff.py {b_flag}--gtest "*YourFilter*"

  # Run an arbitrary command:
  ./scripts/coverage-diff.py {b_flag}--run "{bin_prefix}/wasm-opt ..."

Or run tests manually with LLVM_PROFILE_FILE set, then re-run coverage-diff.py:
  LLVM_PROFILE_FILE="$(pwd)/{rel_build}/coverage/profraw/%p_%m.profraw" {bin_prefix}/binaryen-lit test/lit/...
  ./scripts/coverage-diff.py {b_flag.rstrip()}
""",
        file=sys.stderr,
    )


def find_object_file_for_source(build_dir: str, rel_path: str) -> str | None:
    """Locate the compiled .o file for a C/C++ source file in build_dir."""
    if rel_path.endswith(('.h', '.hpp', '.inc')):
        return None
    # 1. Standard libbinaryen object path: CMakeFiles/binaryen.dir/<rel_path>.o
    cand = os.path.join(build_dir, 'CMakeFiles', 'binaryen.dir', f'{rel_path}.o')
    if os.path.isfile(cand):
        return cand
    # 2. Subdirectory target object path: <dir>/CMakeFiles/*.dir/<basename>.o
    rel_dir = os.path.dirname(rel_path)
    base_name = os.path.basename(rel_path)
    matches = glob.glob(os.path.join(build_dir, rel_dir, 'CMakeFiles', '*.dir', f'{base_name}.o'))
    if not matches:
        matches = glob.glob(
            os.path.join(build_dir, 'src', 'tools', 'CMakeFiles', '*.dir', '**', f'{base_name}.o'),
            recursive=True,
        )
    return matches[0] if matches else None


def find_coverage_objects(
    build_dir: str,
    explicit_objects: list[str] | None,
    diff_rel_paths: list[str],
    used_gtest: bool,
) -> list[str]:
    if explicit_objects:
        return [os.path.abspath(obj) for obj in explicit_objects]

    # Fast path: if all modified files in the diff are .c/.cc/.cpp compilation units
    # with corresponding .o files in build_dir, pass those .o files directly to
    # llvm-cov export (~0.15s) instead of parsing all 300MB+ of libbinaryen.so (~12s).
    obj_files: list[str] = []
    all_have_obj = bool(diff_rel_paths)
    for rel_path in diff_rel_paths:
        obj_file = find_object_file_for_source(build_dir, rel_path)
        if obj_file:
            obj_files.append(obj_file)
        else:
            all_have_obj = False
            break
    if all_have_obj and obj_files:
        return obj_files

    objects: list[str] = []
    lib_dir = os.path.join(build_dir, 'lib')
    for lib_name in ('libbinaryen.so', 'libbinaryen.dylib'):
        lib_path = os.path.join(lib_dir, lib_name)
        if os.path.isfile(lib_path):
            objects.append(lib_path)

    bin_dir = os.path.join(build_dir, 'bin')
    needed_bins: set[str] = set()

    # If static build (no shared libbinaryen), we need at least wasm-opt / binaryen-unittests.
    if not objects:
        needed_bins.update(['wasm-opt', 'binaryen-unittests'])

    if used_gtest:
        needed_bins.add('binaryen-unittests')

    for rel_path in diff_rel_paths:
        parts = rel_path.replace('\\', '/').split('/')
        if len(parts) >= 3 and parts[0] == 'src' and parts[1] == 'tools':
            tool_entry = parts[2]
            if os.path.splitext(tool_entry)[1]:
                needed_bins.add(os.path.splitext(tool_entry)[0])
            else:
                needed_bins.add(tool_entry)
        elif len(parts) >= 2 and parts[0] == 'test' and parts[1] == 'gtest':
            needed_bins.add('binaryen-unittests')
        elif rel_path.endswith(('.h', '.hpp')):
            # Header changes might only be instantiated inside unit tests or tools.
            needed_bins.update(['wasm-opt', 'binaryen-unittests'])

    for bin_name in sorted(needed_bins):
        bin_path = os.path.join(bin_dir, bin_name)
        if os.path.isfile(bin_path) and os.access(bin_path, os.X_OK):
            objects.append(bin_path)

    # Fallback: if still empty, look for any executable in bin/
    if not objects and os.path.isdir(bin_dir):
        for entry in sorted(os.listdir(bin_dir)):
            if entry == 'binaryen-lit':
                continue
            full = os.path.join(bin_dir, entry)
            if os.path.isfile(full) and os.access(full, os.X_OK):
                objects.append(full)
                break

    return objects


def remove_file_quietly(path: str):
    try:
        os.remove(path)
    except OSError:
        pass


def clear_coverage_profiles(build_dir: str) -> int:
    """Remove all .profraw and .profdata files in build_dir and return count removed."""
    cov_dir = os.path.join(build_dir, 'coverage')
    patterns = [
        os.path.join(cov_dir, 'profraw', '*.profraw'),
        os.path.join(cov_dir, '*.profraw'),
        os.path.join(cov_dir, '*.profdata'),
        os.path.join(build_dir, '*.profraw'),
        os.path.join(build_dir, 'default.profdata'),
        os.path.join(build_dir, 'out', 'test', '**', '*.profraw'),
        os.path.join(REPO_ROOT, '*.profraw'),
    ]
    removed = 0
    seen: set[str] = set()
    for pat in patterns:
        for path in glob.glob(pat, recursive=True):
            if path not in seen and os.path.isfile(path):
                seen.add(path)
                try:
                    os.remove(path)
                    removed += 1
                except OSError:
                    pass
    return removed


def run_test_commands(
    build_dir: str,
    lit_tests: list[str] | None,
    gtest_filter: str | None,
    custom_cmds: list[str] | None,
    append_profiles: bool,
) -> tuple[str, list[str]]:
    """Execute requested tests with LLVM_PROFILE_FILE set and return profraw dir & list."""
    profraw_dir = os.path.join(build_dir, 'coverage', 'profraw')
    os.makedirs(profraw_dir, exist_ok=True)

    if not append_profiles:
        clear_coverage_profiles(build_dir)

    env = os.environ.copy()
    env['LLVM_PROFILE_FILE'] = os.path.join(profraw_dir, '%p_%m.profraw')
    bin_dir = os.path.join(build_dir, 'bin')
    env['PATH'] = f"{bin_dir}{os.pathsep}{env.get('PATH', '')}"

    commands: list[list[str] | str] = []
    if lit_tests:
        lit_script = os.path.join(bin_dir, 'binaryen-lit')
        if not os.path.isfile(lit_script):
            rel_build = os.path.relpath(build_dir, REPO_ROOT)
            print(
                f"Error: '{lit_script}' not found. Configure and build '{rel_build}' first.",
                file=sys.stderr,
            )
            sys.exit(2)
        commands.append([sys.executable, lit_script, '-vv', *lit_tests])

    if gtest_filter is not None:
        gtest_bin = os.path.join(bin_dir, 'binaryen-unittests')
        if not os.path.isfile(gtest_bin):
            rel_build = os.path.relpath(build_dir, REPO_ROOT)
            print(
                f"Error: '{gtest_bin}' not found. Build it with: ninja -C {rel_build} binaryen-unittests",
                file=sys.stderr,
            )
            sys.exit(2)
        cmd = [gtest_bin]
        if gtest_filter and gtest_filter != '*':
            cmd.append(f'--gtest_filter={gtest_filter}')
        commands.append(cmd)

    if custom_cmds:
        commands.extend(custom_cmds)

    for cmd in commands:
        if isinstance(cmd, list):
            display = shlex.join(cmd)
            res = subprocess.run(cmd, cwd=REPO_ROOT, env=env)
        else:
            display = cmd
            res = subprocess.run(cmd, cwd=REPO_ROOT, env=env, shell=True)
        if res.returncode != 0:
            print(f'Error: Test command failed (exit code {res.returncode}): {display}', file=sys.stderr)
            sys.exit(res.returncode)

    profraw_files = sorted(glob.glob(os.path.join(profraw_dir, '*.profraw')))
    return profraw_dir, profraw_files


def resolve_profdata(
    build_dir: str,
    llvm_profdata: str,
    explicit_profdata: str | None,
    profraw_files: list[str] | None,
    objects: list[str] | None = None,
) -> str | None:
    if explicit_profdata:
        return os.path.abspath(explicit_profdata) if os.path.isfile(explicit_profdata) else None

    cov_dir = os.path.join(build_dir, 'coverage')
    profdata_path = os.path.join(cov_dir, 'coverage.profdata')
    newest_obj_mtime = max(
        (os.path.getmtime(o) for o in (objects or []) if os.path.isfile(o)),
        default=0.0,
    )

    if profraw_files is None:
        # Search standard locations for existing .profraw files.
        search_patterns = [
            os.path.join(cov_dir, 'profraw', '*.profraw'),
            os.path.join(cov_dir, '*.profraw'),
            os.path.join(build_dir, '*.profraw'),
            os.path.join(build_dir, 'out', 'test', '**', '*.profraw'),
            os.path.join(REPO_ROOT, '*.profraw'),
        ]
        found: list[str] = []
        for pat in search_patterns:
            found.extend(glob.glob(pat, recursive=True))
        profraw_files = sorted(set(found))

    # Automatically discard any .profraw files recorded before the target objects were rebuilt.
    if profraw_files and newest_obj_mtime > 0:
        fresh_profraw: list[str] = []
        for p in profraw_files:
            if os.path.getmtime(p) < newest_obj_mtime:
                remove_file_quietly(p)
            else:
                fresh_profraw.append(p)
        if len(fresh_profraw) != len(profraw_files):
            remove_file_quietly(profdata_path)
        profraw_files = fresh_profraw

    if profraw_files:
        os.makedirs(cov_dir, exist_ok=True)
        need_merge = not os.path.isfile(profdata_path)
        if not need_merge:
            profdata_mtime = os.path.getmtime(profdata_path)
            need_merge = any(os.path.getmtime(p) > profdata_mtime for p in profraw_files)
        if need_merge:
            cmd = [llvm_profdata, 'merge', '-sparse', *profraw_files, '-o', profdata_path]
            res = subprocess.run(cmd, capture_output=True, text=True)
            if res.returncode != 0:
                print(f'Error merging profile data with {llvm_profdata}:\n{res.stderr}', file=sys.stderr)
                sys.exit(2)
        return profdata_path

    if os.path.isfile(profdata_path):
        if newest_obj_mtime > 0 and os.path.getmtime(profdata_path) < newest_obj_mtime:
            remove_file_quietly(profdata_path)
        else:
            return profdata_path
    root_profdata = os.path.join(build_dir, 'default.profdata')
    if os.path.isfile(root_profdata):
        if newest_obj_mtime > 0 and os.path.getmtime(root_profdata) < newest_obj_mtime:
            remove_file_quietly(root_profdata)
        else:
            return root_profdata
    return None


def get_git_diff_lines(
    base_ref: str | None,
    staged_only: bool,
) -> tuple[str, dict[str, tuple[list[int], list[tuple[int, int]]]]]:
    """Return (diff_description, {rel_path: (sorted_lines, [(start, count), ...])})."""
    if staged_only:
        diff_cmd = ['git', 'diff', '--cached', '-U0', '--no-color']
        desc = 'staged changes (git diff --cached)'
    elif base_ref:
        diff_cmd = ['git', 'diff', '-U0', '--no-color', base_ref]
        desc = f'changes vs {base_ref}'
    else:
        # Check if there are uncommitted C/C++ changes against HEAD first.
        status_res = subprocess.run(
            ['git', 'diff', '--name-only', 'HEAD'],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
        )
        has_uncommitted_cpp = any(
            os.path.splitext(p.strip())[1] in CPP_EXTENSIONS
            for p in status_res.stdout.splitlines()
            if p.strip()
        )
        if has_uncommitted_cpp:
            diff_cmd = ['git', 'diff', '-U0', '--no-color', 'HEAD']
            desc = 'uncommitted changes vs HEAD'
        else:
            # Fall back to merge-base with upstream or origin/main.
            upstream = '@{upstream}'
            mb_res = subprocess.run(
                ['git', 'merge-base', upstream, 'HEAD'],
                cwd=REPO_ROOT,
                capture_output=True,
                text=True,
            )
            if mb_res.returncode != 0:
                upstream = 'origin/main'
                mb_res = subprocess.run(
                    ['git', 'merge-base', upstream, 'HEAD'],
                    cwd=REPO_ROOT,
                    capture_output=True,
                    text=True,
                )
            if mb_res.returncode == 0 and mb_res.stdout.strip():
                merge_base = mb_res.stdout.strip()
                diff_cmd = ['git', 'diff', '-U0', '--no-color', merge_base]
                desc = f'branch changes vs {upstream} ({merge_base[:10]})'
            else:
                diff_cmd = ['git', 'diff', '-U0', '--no-color', 'HEAD~1']
                desc = 'changes vs HEAD~1'

    res = subprocess.run(diff_cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    if res.returncode != 0:
        print(f'Error running git diff:\n{res.stderr}', file=sys.stderr)
        sys.exit(2)

    file_diffs: dict[str, tuple[set[int], list[tuple[int, int]]]] = {}
    current_file: str | None = None

    for raw_line in res.stdout.splitlines():
        if raw_line.startswith('+++ b/'):
            rel_path = raw_line[6:].strip()
            ext = os.path.splitext(rel_path)[1]
            abs_path = os.path.join(REPO_ROOT, rel_path)
            if ext in CPP_EXTENSIONS and os.path.isfile(abs_path) and not rel_path.startswith('third_party/'):
                current_file = rel_path
                if current_file not in file_diffs:
                    file_diffs[current_file] = (set(), [])
            else:
                current_file = None
        elif raw_line.startswith('+++ /dev/null'):
            current_file = None
        elif current_file and raw_line.startswith('@@ '):
            m = HUNK_RE.match(raw_line)
            if m:
                start_line = int(m.group(1))
                count = int(m.group(2)) if m.group(2) is not None else 1
                if count > 0:
                    lines_set, hunks = file_diffs[current_file]
                    lines_set.update(range(start_line, start_line + count))
                    hunks.append((start_line, count))

    result = {
        rel: (sorted(lines_set), hunks)
        for rel, (lines_set, hunks) in sorted(file_diffs.items())
        if lines_set
    }
    return desc, result


def compute_line_stats(raw_segments: list[list]) -> dict[int, LineStat]:
    """Replicate llvm::coverage::LineCoverageIterator & LineCoverageStats."""
    if not raw_segments:
        return {}

    segments = [
        Segment(
            line=int(s[0]),
            col=int(s[1]),
            count=int(s[2]),
            has_count=bool(s[3]),
            is_region_entry=bool(s[4]),
            is_gap_region=bool(s[5]),
        )
        for s in raw_segments
    ]

    max_line = segments[-1].line
    seg_idx = 0
    num_segs = len(segments)
    wrapped_seg: Segment | None = None
    line_segs: list[Segment] = []
    stats: dict[int, LineStat] = {}

    def is_start_of_region(seg: Segment) -> bool:
        return not seg.is_gap_region and seg.has_count and seg.is_region_entry

    for line in range(1, max_line + 1):
        if seg_idx >= num_segs:
            break
        if line_segs:
            wrapped_seg = line_segs[-1]
        line_segs = []
        while seg_idx < num_segs and segments[seg_idx].line == line:
            line_segs.append(segments[seg_idx])
            seg_idx += 1

        min_region_count = sum(1 for s in line_segs if is_start_of_region(s))
        start_of_skipped = bool(line_segs) and not line_segs[0].has_count and line_segs[0].is_region_entry

        mapped = not start_of_skipped and (
            (wrapped_seg is not None and wrapped_seg.has_count) or (min_region_count > 0)
        )
        if not mapped:
            mapped = any(s.is_region_entry and s.has_count for s in line_segs)

        if not mapped:
            stats[line] = LineStat(line=line, mapped=False, count=0)
            continue

        exec_count = wrapped_seg.count if wrapped_seg is not None else 0
        if min_region_count > 0:
            for s in line_segs:
                if is_start_of_region(s):
                    exec_count = max(exec_count, s.count)

        stats[line] = LineStat(line=line, mapped=True, count=exec_count)

    return stats


def demangle_names(names: list[str]) -> dict[str, str]:
    if not names:
        return {}
    demangler = find_llvm_tool('llvm-cxxfilt') or shutil.which('c++filt')
    if not demangler:
        return {n: n for n in names}
    # Strip leading source filename prefix if present (e.g. "File.cpp:_Z...")
    stripped = [n.split(':', 1)[-1] if ':' in n and n.split(':', 1)[0].endswith(('.cpp', '.cc', '.c', '.h')) else n for n in names]
    res = subprocess.run(
        [demangler],
        input='\n'.join(stripped),
        capture_output=True,
        text=True,
    )
    if res.returncode != 0:
        return {n: n for n in names}
    out_lines = res.stdout.splitlines()
    if len(out_lines) != len(names):
        return {n: n for n in names}
    return dict(zip(names, [line.strip() for line in out_lines], strict=True))


def find_unreachable_lines(source_lines: list[str]) -> set[int]:
    """Identify 1-indexed lines with WASM_UNREACHABLE or exclusion markers."""
    unreachable: set[int] = set()
    for idx, text in enumerate(source_lines):
        line_no = idx + 1
        if UNREACHABLE_RE.search(text):
            unreachable.add(line_no)
            # Also exclude an immediately preceding standalone `default:` label.
            if idx > 0 and DEFAULT_LABEL_RE.match(source_lines[idx - 1]):
                unreachable.add(line_no - 1)
    return unreachable


def extract_snippet(source_lines: list[str], line_start: int, col_start: int, line_end: int, col_end: int) -> str:
    if line_start < 1 or line_start > len(source_lines):
        return ''
    if line_start == line_end:
        line_text = source_lines[line_start - 1]
        c_start = max(0, col_start - 1)
        c_end = max(c_start, col_end - 1) if col_end > col_start else len(line_text)
        snippet = line_text[c_start:c_end].strip()
        return snippet or line_text.strip()
    first_part = source_lines[line_start - 1][max(0, col_start - 1):].strip()
    return f'{first_part} ...'


def group_line_ranges(lines: list[int]) -> list[tuple[int, int]]:
    if not lines:
        return []
    sorted_lines = sorted(lines)
    ranges: list[tuple[int, int]] = []
    start = prev = sorted_lines[0]
    for ln in sorted_lines[1:]:
        if ln == prev + 1:
            prev = ln
        else:
            ranges.append((start, prev))
            start = prev = ln
    ranges.append((start, prev))
    return ranges


def populate_regions_and_functions(
    file_cov: FileDiffCoverage,
    func_entries: list[dict],
    demangled_map: dict[str, str],
    active_diff_lines: list[int],
    active_diff_set: set[int],
    unreachable_lines: set[int],
    include_system_macros: bool,
):
    region_counts: dict[tuple[int, int, int, int], int] = {}
    func_spans: dict[tuple[str, int, int], FunctionSpan] = {}

    executable_diff_lines = [
        ln for ln in active_diff_lines if file_cov.line_stats.get(ln) and file_cov.line_stats[ln].mapped
    ]

    for fn in func_entries:
        fn_regions = fn.get('regions', [])
        if not fn_regions:
            continue
        outer = fn_regions[0]
        f_start, f_end = int(outer[0]), int(outer[2])
        if any(f_start <= ln <= f_end for ln in executable_diff_lines):
            raw_name = fn['name']
            demangled = demangled_map.get(raw_name, raw_name)
            key = (demangled, f_start, f_end)
            if key not in func_spans:
                func_spans[key] = FunctionSpan(
                    name=raw_name,
                    demangled_name=demangled,
                    line_start=f_start,
                    line_end=f_end,
                    count=int(fn.get('count', 0)),
                )
            else:
                func_spans[key].count += int(fn.get('count', 0))

        for reg in fn_regions:
            r_lstart, r_cstart, r_lend, r_cend = int(reg[0]), int(reg[1]), int(reg[2]), int(reg[3])
            r_count, r_file_id, r_kind = int(reg[4]), int(reg[5]), int(reg[7])
            if r_kind != REGION_KIND_CODE or r_file_id != 0:
                continue
            if not include_system_macros and r_lstart == r_lend and r_cstart == r_cend:
                continue
            if r_lstart in unreachable_lines:
                continue
            r_key = (r_lstart, r_cstart, r_lend, r_cend)
            region_counts[r_key] = region_counts.get(r_key, 0) + r_count

    for span in sorted(func_spans.values(), key=lambda s: (s.line_start, s.demangled_name)):
        file_cov.functions.add(1 if span.count > 0 else 0, 1)
        if span.count == 0:
            file_cov.uncovered_functions.append(span)

    selected_regions: dict[tuple[int, int, int, int], int] = {}
    lines_with_starting_region: set[int] = set()
    for r_key, r_count in region_counts.items():
        if r_key[0] in active_diff_set:
            selected_regions[r_key] = r_count
            lines_with_starting_region.add(r_key[0])

    for ln in active_diff_lines:
        st = file_cov.line_stats.get(ln)
        if not (st and st.mapped) or ln in lines_with_starting_region:
            continue
        enclosing = [
            (r_key, r_count)
            for r_key, r_count in region_counts.items()
            if r_key[0] <= ln <= r_key[2]
        ]
        if enclosing:
            innermost_key, innermost_count = min(
                enclosing,
                key=lambda item: (item[0][2] - item[0][0], item[0][3] - item[0][1]),
            )
            selected_regions[innermost_key] = innermost_count

    uncovered_line_set = set(file_cov.uncovered_lines)
    for r_key in sorted(selected_regions):
        r_count = selected_regions[r_key]
        file_cov.regions.add(1 if r_count > 0 else 0, 1)
        r_lstart, r_cstart, r_lend, r_cend = r_key
        if r_count == 0 and r_lstart in active_diff_set and r_lstart not in uncovered_line_set:
            # Skip multi-line block regions (e.g. `{` at the end of `if (...) {`)
            # whose interior lines are already reported in uncovered_lines.
            if r_lstart < r_lend and any(
                ln in uncovered_line_set for ln in range(r_lstart + 1, r_lend + 1)
            ):
                continue
            file_cov.uncovered_subregions.append(
                CodeRegion(r_lstart, r_cstart, r_lend, r_cend, r_count),
            )


def format_span_loc(line_start: int, col_start: int, line_end: int, col_end: int) -> str:
    if line_start == line_end:
        return f'Line {line_start}:{col_start}-{col_end}'
    return f'Lines {line_start}:{col_start}-{line_end}:{col_end}'


def populate_branches_and_mcdc(
    file_cov: FileDiffCoverage,
    file_entry: dict,
    active_diff_set: set[int],
    unreachable_lines: set[int],
    include_system_macros: bool,
):
    branch_map: dict[tuple[int, int, int, int], list[int]] = {}
    for br in file_entry.get('branches', []):
        b_lstart, b_cstart, b_lend, b_cend = int(br[0]), int(br[1]), int(br[2]), int(br[3])
        b_true, b_false, b_file_id = int(br[4]), int(br[5]), int(br[6])
        if b_file_id != 0:
            continue
        if not include_system_macros and b_lstart == b_lend and b_cstart == b_cend:
            continue
        if b_lstart in unreachable_lines:
            continue
        if not any(ln in active_diff_set for ln in range(b_lstart, b_lend + 1)):
            continue
        b_key = (b_lstart, b_cstart, b_lend, b_cend)
        if b_key not in branch_map:
            branch_map[b_key] = [b_true, b_false]
        else:
            branch_map[b_key][0] += b_true
            branch_map[b_key][1] += b_false

    for b_key in sorted(branch_map):
        b_true, b_false = branch_map[b_key]
        cov_outcomes = (1 if b_true > 0 else 0) + (1 if b_false > 0 else 0)
        file_cov.branches.add(cov_outcomes, 2)
        if cov_outcomes < 2:
            file_cov.uncovered_branches.append(
                BranchRecord(b_key[0], b_key[1], b_key[2], b_key[3], b_true, b_false),
            )

    for mcdc in file_entry.get('mcdc_records', []):
        m_lstart, m_cstart, m_lend, m_cend = int(mcdc[0]), int(mcdc[1]), int(mcdc[2]), int(mcdc[3])
        m_file_id = int(mcdc[6])
        conditions = [bool(c) for c in mcdc[9]] if len(mcdc) > 9 and isinstance(mcdc[9], list) else []
        if m_file_id != 0 or not conditions or m_lstart in unreachable_lines:
            continue
        if not any(ln in active_diff_set for ln in range(m_lstart, m_lend + 1)):
            continue
        cov_conds = sum(1 for c in conditions if c)
        file_cov.mcdc.add(cov_conds, len(conditions))
        if cov_conds < len(conditions):
            file_cov.uncovered_mcdc.append(
                MCDCRecord(m_lstart, m_cstart, m_lend, m_cend, conditions),
            )


def analyze_coverage(
    cov_json: dict,
    file_diffs: dict[str, tuple[list[int], list[tuple[int, int]]]],
    include_unreachable: bool,
    include_system_macros: bool,
) -> list[FileDiffCoverage]:
    """Intersect llvm-cov export JSON with git diff line sets across all metrics."""
    files_by_realpath: dict[str, dict] = {}
    functions_by_realpath: dict[str, list[dict]] = {}

    for datum in cov_json.get('data', []):
        for file_entry in datum.get('files', []):
            rp = os.path.realpath(file_entry['filename'])
            files_by_realpath[rp] = file_entry
        for func_entry in datum.get('functions', []):
            filenames = func_entry.get('filenames', [])
            if filenames:
                rp = os.path.realpath(filenames[0])
                functions_by_realpath.setdefault(rp, []).append(func_entry)

    all_func_names = [fn['name'] for funcs in functions_by_realpath.values() for fn in funcs]
    demangled_map = demangle_names(list(set(all_func_names)))

    results: list[FileDiffCoverage] = []

    for rel_path, (diff_lines, hunks) in file_diffs.items():
        abs_path = os.path.realpath(os.path.join(REPO_ROOT, rel_path))
        try:
            with open(abs_path, errors='replace') as f:
                source_lines = [line.rstrip('\r\n') for line in f]
        except OSError:
            source_lines = []

        file_cov = FileDiffCoverage(
            rel_path=rel_path,
            abs_path=abs_path,
            diff_lines=diff_lines,
            hunks=hunks,
        )

        file_entry = files_by_realpath.get(abs_path)
        if not file_entry:
            file_cov.in_coverage_map = False
            results.append(file_cov)
            continue

        unreachable_lines = set() if include_unreachable else find_unreachable_lines(source_lines)
        diff_line_set = set(diff_lines)
        active_diff_lines = sorted(diff_line_set - unreachable_lines)
        file_cov.excluded_unreachable_lines = len(diff_line_set & unreachable_lines)
        active_diff_set = set(active_diff_lines)

        line_stats = compute_line_stats(file_entry.get('segments', []))
        file_cov.line_stats = line_stats
        for ln in active_diff_lines:
            st = line_stats.get(ln)
            if st and st.mapped:
                file_cov.lines.add(1 if st.count > 0 else 0, 1)
                if st.count == 0:
                    file_cov.uncovered_lines.append(ln)
            else:
                file_cov.non_executable_diff_lines += 1

        populate_regions_and_functions(
            file_cov=file_cov,
            func_entries=functions_by_realpath.get(abs_path, []),
            demangled_map=demangled_map,
            active_diff_lines=active_diff_lines,
            active_diff_set=active_diff_set,
            unreachable_lines=unreachable_lines,
            include_system_macros=include_system_macros,
        )
        populate_branches_and_mcdc(
            file_cov=file_cov,
            file_entry=file_entry,
            active_diff_set=active_diff_set,
            unreachable_lines=unreachable_lines,
            include_system_macros=include_system_macros,
        )
        results.append(file_cov)

    return results


def render_text_report(
    diff_desc: str,
    file_results: list[FileDiffCoverage],
    annotate: bool,
    context_lines: int,
):
    totals = {
        'lines': MetricCounts(),
        'regions': MetricCounts(),
        'branches': MetricCounts(),
        'mcdc': MetricCounts(),
        'functions': MetricCounts(),
    }
    total_excluded_unreachable = 0

    for fc in file_results:
        if not fc.in_coverage_map:
            continue
        totals['lines'].add(fc.lines.covered, fc.lines.total)
        totals['regions'].add(fc.regions.covered, fc.regions.total)
        totals['branches'].add(fc.branches.covered, fc.branches.total)
        totals['mcdc'].add(fc.mcdc.covered, fc.mcdc.total)
        totals['functions'].add(fc.functions.covered, fc.functions.total)
        total_excluded_unreachable += fc.excluded_unreachable_lines

    print(f'=== Diff Coverage Report ({diff_desc}) ===\n')
    print(f"  {'Metric':<12} {'Covered / Total':<22} {'Details'}")
    print(f"  {'-' * 12} {'-' * 22} {'-' * 34}")
    print(f"  {'Lines':<12} {totals['lines'].format_summary():<22} Executable lines in diff")
    print(f"  {'Regions':<12} {totals['regions'].format_summary():<22} Sub-line / block AST regions in diff")
    print(f"  {'Branches':<12} {totals['branches'].format_summary():<22} True/False branch outcomes in diff")
    if totals['mcdc'].total > 0:
        print(f"  {'MC/DC':<12} {totals['mcdc'].format_summary():<22} Condition independence pairs in diff")
    print(f"  {'Functions':<12} {totals['functions'].format_summary():<22} Modified functions called >= 1x")

    if total_excluded_unreachable > 0:
        print(f'\n  (Note: Excluded {total_excluded_unreachable} WASM_UNREACHABLE line(s); pass --include-unreachable to include)')

    if len(file_results) > 1:
        print('\n--- Per-File Summary ---')
        for fc in file_results:
            if not fc.in_coverage_map:
                print(f'  {fc.rel_path}: (not in coverage mapping - header/uncompiled)')
                continue
            if fc.lines.total == 0:
                print(f'  {fc.rel_path}: (only comments / non-executable lines changed in diff)')
                continue
            parts = [
                f'Lines: {fc.lines.format_summary()}',
                f'Regions: {fc.regions.format_summary()}',
                f'Branches: {fc.branches.format_summary()}',
            ]
            if fc.mcdc.total > 0:
                parts.append(f'MC/DC: {fc.mcdc.format_summary()}')
            print(f"  {fc.rel_path}\n    {', '.join(parts)}")

    # Print actionable gaps for each file
    any_gaps = False
    for fc in file_results:
        if not fc.in_coverage_map:
            continue
        has_file_gaps = bool(
            fc.uncovered_functions
            or fc.uncovered_lines
            or fc.uncovered_subregions
            or fc.uncovered_branches
            or fc.uncovered_mcdc,
        )
        if not has_file_gaps:
            continue

        if not any_gaps:
            print('\n=== Uncovered / Partially Covered Code in Diff ===')
            any_gaps = True

        try:
            with open(fc.abs_path, errors='replace') as f:
                source_lines = [line.rstrip('\r\n') for line in f]
        except OSError:
            source_lines = []

        print(f'\nFile: {fc.rel_path}')

        if fc.uncovered_functions:
            print('  Uncovered Functions (0 calls):')
            for fn in fc.uncovered_functions:
                print(f'    - Line {fn.line_start}-{fn.line_end}: {fn.demangled_name}')

        if fc.uncovered_lines:
            print('  Uncovered Executable Lines (0x):')
            for start, end in group_line_ranges(fc.uncovered_lines):
                loc = f'Line {start}' if start == end else f'Lines {start}-{end}'
                print(f'    - {loc}:')
                for ln in range(start, end + 1):
                    src = source_lines[ln - 1] if 1 <= ln <= len(source_lines) else ''
                    print(f'        {ln:5d} | {src}')

        if fc.uncovered_subregions:
            print('  Partially Covered Lines (Uncovered Sub-line Regions on Executed Lines):')
            for reg in fc.uncovered_subregions:
                snippet = extract_snippet(
                    source_lines, reg.line_start, reg.col_start, reg.line_end, reg.col_end,
                )
                loc = format_span_loc(reg.line_start, reg.col_start, reg.line_end, reg.col_end)
                full_line = source_lines[reg.line_start - 1].strip() if 1 <= reg.line_start <= len(source_lines) else ''
                context_suffix = f' (in `{full_line}`)' if reg.line_start == reg.line_end and full_line != snippet else ''
                print(
                    f'    - {loc} (0x): `{snippet}`{context_suffix}',
                )

        if fc.uncovered_branches:
            print('  Uncovered / One-Sided Branches:')
            for br in fc.uncovered_branches:
                snippet = extract_snippet(
                    source_lines, br.line_start, br.col_start, br.line_end, br.col_end,
                )
                loc = format_span_loc(br.line_start, br.col_start, br.line_end, br.col_end)
                if br.true_count == 0 and br.false_count == 0:
                    status = 'never reached (True: 0x, False: 0x)'
                elif br.true_count == 0:
                    status = f'missing TRUE branch (True: 0x, False: {br.false_count}x)'
                else:
                    status = f'missing FALSE branch (True: {br.true_count}x, False: 0x)'
                print(
                    f'    - {loc} `{snippet}` -> {status}',
                )

        if fc.uncovered_mcdc:
            print('  Uncovered MC/DC Condition Independence Pairs:')
            for rec in fc.uncovered_mcdc:
                snippet = extract_snippet(
                    source_lines, rec.line_start, rec.col_start, rec.line_end, rec.col_end,
                )
                loc = format_span_loc(rec.line_start, rec.col_start, rec.line_end, rec.col_end)
                missing_conds = [f'C{i + 1}' for i, cov in enumerate(rec.conditions) if not cov]
                print(
                    f"    - {loc} `{snippet}` -> "
                    f"missing independence pair for {', '.join(missing_conds)}",
                )

    if not any_gaps and totals['lines'].total > 0:
        print('\nAll executable lines, regions, and branches in the diff are 100% covered!')

    if annotate:
        print('\n=== Annotated Diff Hunks ===')
        for fc in file_results:
            if not fc.in_coverage_map:
                continue
            try:
                with open(fc.abs_path, errors='replace') as f:
                    source_lines = [line.rstrip('\r\n') for line in f]
            except OSError:
                continue
            print(f'\n--- {fc.rel_path} ---')
            diff_set = set(fc.diff_lines)
            branches_by_line: dict[int, list[BranchRecord]] = {}
            for br in fc.uncovered_branches:
                branches_by_line.setdefault(br.line_start, []).append(br)

            for start, count in fc.hunks:
                lo = max(1, start - context_lines)
                hi = min(len(source_lines), start + count - 1 + context_lines)
                print(f'@@ lines {lo}-{hi} @@')
                for ln in range(lo, hi + 1):
                    marker = '+' if ln in diff_set else ' '
                    st = fc.line_stats.get(ln)
                    if st and st.mapped:
                        cnt_str = f'{st.count:6d}x' if st.count > 0 else '  #####'
                    else:
                        cnt_str = '       '
                    print(f'{marker} {ln:5d} | {cnt_str} | {source_lines[ln - 1]}')
                    for br in branches_by_line.get(ln, []):
                        print(
                            f'        |         |   ^-- Branch ({br.line_start}:{br.col_start}): '
                            f'[True: {br.true_count}x, False: {br.false_count}x]',
                        )


def render_json_report(diff_desc: str, file_results: list[FileDiffCoverage]) -> str:
    totals = {
        'lines': MetricCounts(),
        'regions': MetricCounts(),
        'branches': MetricCounts(),
        'mcdc': MetricCounts(),
        'functions': MetricCounts(),
    }
    for fc in file_results:
        if not fc.in_coverage_map:
            continue
        totals['lines'].add(fc.lines.covered, fc.lines.total)
        totals['regions'].add(fc.regions.covered, fc.regions.total)
        totals['branches'].add(fc.branches.covered, fc.branches.total)
        totals['mcdc'].add(fc.mcdc.covered, fc.mcdc.total)
        totals['functions'].add(fc.functions.covered, fc.functions.total)

    payload = {
        'diff_target': diff_desc,
        'totals': {
            k: {'covered': v.covered, 'total': v.total, 'percent': v.percent}
            for k, v in totals.items()
        },
        'files': [
            {
                'file': fc.rel_path,
                'in_coverage_map': fc.in_coverage_map,
                'metrics': {
                    'lines': {'covered': fc.lines.covered, 'total': fc.lines.total, 'percent': fc.lines.percent},
                    'regions': {'covered': fc.regions.covered, 'total': fc.regions.total, 'percent': fc.regions.percent},
                    'branches': {'covered': fc.branches.covered, 'total': fc.branches.total, 'percent': fc.branches.percent},
                    'mcdc': {'covered': fc.mcdc.covered, 'total': fc.mcdc.total, 'percent': fc.mcdc.percent},
                    'functions': {'covered': fc.functions.covered, 'total': fc.functions.total, 'percent': fc.functions.percent},
                },
                'uncovered_functions': [
                    {'name': fn.demangled_name, 'line_start': fn.line_start, 'line_end': fn.line_end}
                    for fn in fc.uncovered_functions
                ],
                'uncovered_lines': fc.uncovered_lines,
                'uncovered_subregions': [
                    {
                        'line_start': r.line_start,
                        'col_start': r.col_start,
                        'line_end': r.line_end,
                        'col_end': r.col_end,
                    }
                    for r in fc.uncovered_subregions
                ],
                'uncovered_branches': [
                    {
                        'line_start': b.line_start,
                        'col_start': b.col_start,
                        'line_end': b.line_end,
                        'col_end': b.col_end,
                        'true_count': b.true_count,
                        'false_count': b.false_count,
                    }
                    for b in fc.uncovered_branches
                ],
            }
            for fc in file_results
        ],
    }
    return json.dumps(payload, indent=2)


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        'base',
        nargs='?',
        default=None,
        help='Git ref to diff against (default: HEAD if uncommitted changes exist, else merge-base with upstream)',
    )
    parser.add_argument(
        '--base',
        dest='base_flag',
        default=None,
        help='Git ref to diff against (overrides positional base)',
    )
    parser.add_argument(
        '--staged',
        action='store_true',
        help='Analyze only staged changes (git diff --cached)',
    )
    parser.add_argument(
        '-B',
        '--build-dir',
        default=None,
        help='CMake build directory configured with coverage flags (default: auto-detect out/cov, build/cov, .)',
    )
    parser.add_argument(
        '--lit',
        nargs='+',
        metavar='TEST',
        help='Run binaryen-lit on the specified test file(s)/directories to collect coverage',
    )
    parser.add_argument(
        '--gtest',
        nargs='?',
        const='*',
        default=None,
        metavar='FILTER',
        help='Run binaryen-unittests (optionally with --gtest_filter=FILTER) to collect coverage',
    )
    parser.add_argument(
        '--run',
        action='append',
        metavar='CMD',
        help='Run custom command(s) with LLVM_PROFILE_FILE set to collect coverage',
    )
    parser.add_argument(
        '--append',
        action='store_true',
        help='Keep existing .profraw files when running tests via --lit/--gtest/--run',
    )
    parser.add_argument(
        '--clear',
        action='store_true',
        help='Clear all collected .profraw and .profdata files in the build directory',
    )
    parser.add_argument(
        '--profdata',
        default=None,
        help='Explicit path to a merged .profdata file',
    )
    parser.add_argument(
        '--object',
        action='append',
        dest='objects',
        metavar='BIN',
        help='Explicit instrumented library/executable path(s) for llvm-cov (auto-detected by default)',
    )
    parser.add_argument(
        '-a',
        '--annotate',
        action='store_true',
        help='Print annotated diff hunks with per-line execution counts and branch counts',
    )
    parser.add_argument(
        '-C',
        '--context',
        type=int,
        default=2,
        help='Number of context lines around annotated diff hunks (default: 2)',
    )
    parser.add_argument(
        '--json',
        action='store_true',
        help='Emit coverage report as JSON',
    )
    parser.add_argument(
        '--include-unreachable',
        action='store_true',
        help='Include WASM_UNREACHABLE lines in coverage totals',
    )
    parser.add_argument(
        '--include-system-macros',
        action='store_true',
        help='Include 0-width system macro expansions (such as assert() internal branches)',
    )
    parser.add_argument(
        '--fail-under-lines',
        type=float,
        default=None,
        metavar='PCT',
        help='Exit with code 1 if diff line coverage percentage is below PCT',
    )
    parser.add_argument(
        '--fail-under-regions',
        type=float,
        default=None,
        metavar='PCT',
        help='Exit with code 1 if diff region coverage percentage is below PCT',
    )
    parser.add_argument(
        '--fail-under-branches',
        type=float,
        default=None,
        metavar='PCT',
        help='Exit with code 1 if diff branch coverage percentage is below PCT',
    )
    parser.add_argument(
        '--llvm-cov',
        default=None,
        help='Path to llvm-cov binary',
    )
    parser.add_argument(
        '--llvm-profdata',
        default=None,
        help='Path to llvm-profdata binary',
    )

    args = parser.parse_args()
    base_ref = args.base_flag or args.base

    # 1. Verify llvm-cov and llvm-profdata are installed.
    llvm_cov = find_llvm_tool('llvm-cov', args.llvm_cov)
    llvm_profdata = find_llvm_tool('llvm-profdata', args.llvm_profdata)
    if not llvm_cov or not llvm_profdata:
        missing = [name for name, path in [('llvm-cov', llvm_cov), ('llvm-profdata', llvm_profdata)] if not path]
        print(
            f"Error: Required LLVM coverage tool(s) not found in PATH: {', '.join(missing)}\n"
            'Install the llvm package (e.g. `sudo apt-get install llvm`) or pass --llvm-cov / --llvm-profdata.',
            file=sys.stderr,
        )
        sys.exit(2)

    # 2. Discover & validate the CMake build directory.
    build_dir, is_valid_config, reason, _cache = discover_build_dir(args.build_dir)
    if not is_valid_config:
        print_setup_instructions(reason, args.build_dir or 'out/cov')
        sys.exit(2)

    if args.clear:
        removed = clear_coverage_profiles(build_dir)
        rel_build = os.path.relpath(build_dir, REPO_ROOT)
        print(f"Cleared {removed} coverage profile file(s) from '{rel_build}'.")
        if not (args.lit or args.gtest is not None or args.run):
            sys.exit(0)

    # 3. Collect git diff hunks first so we know which files/binaries are involved.
    diff_desc, file_diffs = get_git_diff_lines(base_ref, args.staged)
    if not file_diffs:
        print(
            f'No modified C/C++ source files found in {diff_desc}.\n'
            '(Tip: pass a base ref such as `./scripts/coverage-diff.py origin/main` or `HEAD~1` to compare committed changes.)',
        )
        sys.exit(0)

    # 4. Run tests if --lit, --gtest, or --run was specified.
    profraw_files: list[str] | None = None
    if args.lit or args.gtest is not None or args.run:
        _profraw_dir, profraw_files = run_test_commands(
            build_dir=build_dir,
            lit_tests=args.lit,
            gtest_filter=args.gtest,
            custom_cmds=args.run,
            append_profiles=args.append,
        )

    # 5. Locate instrumented binary/library objects.
    objects = find_coverage_objects(
        build_dir=build_dir,
        explicit_objects=args.objects,
        diff_rel_paths=list(file_diffs.keys()),
        used_gtest=args.gtest is not None,
    )
    if not objects:
        rel_build = os.path.relpath(build_dir, REPO_ROOT)
        print(
            f"Error: No built libraries or executables found in '{rel_build}'.\n"
            f'Build your targets first, e.g.:\n  ninja -C {rel_build} wasm-opt binaryen-lit binaryen-unittests',
            file=sys.stderr,
        )
        sys.exit(2)

    # 6. Locate or merge .profdata (invalidating any profiles older than rebuilt objects).
    profdata_path = resolve_profdata(
        build_dir=build_dir,
        llvm_profdata=llvm_profdata,
        explicit_profdata=args.profdata,
        profraw_files=profraw_files,
        objects=objects,
    )
    if not profdata_path:
        print_missing_profile_instructions(build_dir)
        sys.exit(2)

    # 7. Run `llvm-cov export` restricted to the modified files in the diff.
    source_paths = [os.path.join(REPO_ROOT, rel) for rel in file_diffs]
    cov_cmd = [
        llvm_cov,
        'export',
        '--format=text',
        '--skip-expansions',
        f'--instr-profile={profdata_path}',
        objects[0],
        *[f'--object={obj}' for obj in objects[1:]],
        '--',
        *source_paths,
    ]
    cov_res = subprocess.run(cov_cmd, cwd=REPO_ROOT, capture_output=True, text=True)
    if cov_res.returncode != 0:
        rel_build = os.path.relpath(build_dir, REPO_ROOT)
        print(
            f'Error running llvm-cov export:\n{cov_res.stderr.strip()}\n',
            file=sys.stderr,
        )
        if 'No coverage data found' in cov_res.stderr or 'Failed to load coverage' in cov_res.stderr:
            print_setup_instructions(
                f"Binaries in '{rel_build}' do not contain LLVM coverage mapping sections.",
                rel_build,
            )
        sys.exit(2)

    cov_json = json.loads(cov_res.stdout)
    file_results = analyze_coverage(
        cov_json=cov_json,
        file_diffs=file_diffs,
        include_unreachable=args.include_unreachable,
        include_system_macros=args.include_system_macros,
    )

    if args.json:
        print(render_json_report(diff_desc, file_results))
    else:
        render_text_report(
            diff_desc=diff_desc,
            file_results=file_results,
            annotate=args.annotate,
            context_lines=args.context,
        )

    # 8. Check optional threshold gates.
    failed_gate = False
    for metric_name, threshold in [
        ('lines', args.fail_under_lines),
        ('regions', args.fail_under_regions),
        ('branches', args.fail_under_branches),
    ]:
        if threshold is None:
            continue
        agg = MetricCounts()
        for fc in file_results:
            if fc.in_coverage_map:
                m: MetricCounts = getattr(fc, metric_name)
                agg.add(m.covered, m.total)
        if agg.percent is not None and agg.percent < threshold:
            print(
                f'FAIL: Diff {metric_name} coverage ({agg.percent:.1f}%) is below threshold ({threshold:.1f}%).',
                file=sys.stderr,
            )
            failed_gate = True

    if failed_gate:
        sys.exit(1)


if __name__ == '__main__':
    main()
