load("@rules_python//python:defs.bzl", "py_binary")
load("@rules_license//rules:license.bzl", "license")

licenses(["notice"])

package(
    default_applicable_licenses = [":package_license"],
    default_visibility = ["//visibility:public"],
    features = ["-use_header_modules"],
)

license(
    name = "package_license",
    package_name = "binaryen",
)

exports_files(["LICENSE"])

BINARYEN_COPTS = [
    "-fexceptions",
]

cc_library(
    name = "binaryen_lib",
    srcs = glob(
        [
            "src/*.cpp",
            "src/**/*.cpp",
        ],
        exclude = [
            "src/tools/**",
            "src/support/suffix_tree.cpp",
            "src/support/suffix_tree_node.cpp",
        ],
    ) + [
        ":WasmIntrinsics.cpp",
    ],
    hdrs = glob(
        [
            "src/**/*.h",
        ],
        exclude = [
            "src/tools/**",
            "src/support/suffix_tree.h",
            "src/support/suffix_tree_node.h",
        ],
    ) + [":src/config.h"],
    copts = BINARYEN_COPTS,
    includes = ["src"],
    textual_hdrs = glob([
        "src/**/*.inc",
        "src/**/*.def",
    ]),
)

cc_binary(
    name = "wasm2js",
    srcs = [
        "src/tools/optimization-options.h",
        "src/tools/tool-options.h",
        "src/tools/wasm2js.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-as",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/tool-utils.h",
        "src/tools/wasm-as.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-ctor-eval",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-ctor-eval.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-dis",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-dis.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-emscripten-finalize",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-emscripten-finalize.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-metadce",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-metadce.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-opt",
    srcs = [
        "src/tools/execution-results.h",
        "src/tools/fuzzing.h",
        "src/tools/fuzzing/fuzzing.cpp",
        "src/tools/fuzzing/heap-types.cpp",
        "src/tools/fuzzing/heap-types.h",
        "src/tools/fuzzing/parameters.h",
        "src/tools/fuzzing/random.cpp",
        "src/tools/fuzzing/random.h",
        "src/tools/js-wrapper.h",
        "src/tools/optimization-options.h",
        "src/tools/spec-wrapper.h",
        "src/tools/tool-options.h",
        "src/tools/wasm-opt.cpp",
        "src/tools/wasm2c-wrapper.h",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    #    visibility = ["//third_party/emscripten:__subpackages__"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-reduce",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-reduce.cpp",
    ],
    copts = BINARYEN_COPTS + [
        "-Wno-unused-but-set-parameter",  # opt compiles
    ],
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-shell",
    srcs = [
        "src/tools/execution-results.h",
        "src/tools/wasm-shell.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

cc_binary(
    name = "wasm-split",
    srcs = [
        "src/tools/tool-options.h",
        "src/tools/wasm-split/instrumenter.cpp",
        "src/tools/wasm-split/instrumenter.h",
        "src/tools/wasm-split/split-options.cpp",
        "src/tools/wasm-split/split-options.h",
        "src/tools/wasm-split/wasm-split.cpp",
    ],
    copts = BINARYEN_COPTS,
    includes = ["src/tools"],
    deps = [":binaryen_lib"],
)

py_binary(
    name = "generate_intrinsics",
    srcs = ["generate_intrinsics.py"],
    python_version = "PY3",
    deps = ["@com_google_absl_py//absl:app"],
)

genrule(
    name = "wasm-intrinsics",
    srcs = [
        "src/passes/wasm-intrinsics.wat",
        "src/passes/WasmIntrinsics.cpp.in",
    ],
    outs = ["WasmIntrinsics.cpp"],
    cmd = "$(location :generate_intrinsics) $(SRCS) $(location :WasmIntrinsics.cpp)",
    tools = [":generate_intrinsics"],
)

# Constructs the version string in the form of:
# version <version number> (version_<version number>-<latest commit hash>)
# Ideally it would also include number of commits since the last version
# was cut, but we don't easily have access to that number.
# <version number> must contain only digits because emscripten will throw an
# error otherwise.
genrule(
    name = "config",
    srcs = [
        "METADATA",
        "config.h.in",
        "CMakeLists.txt",
    ],
    outs = ["src/config.h"],
    cmd = """VER=$$(grep \"project(\" $(location CMakeLists.txt) | cut -d \" \" -f 6 | sed \"s/)//\")
             HASH=$$(grep version $(location METADATA) | cut -d '\"' -f 2 | head -n 1)
             sed \"s/\\$${PROJECT_VERSION}/$${VER} (version_$${VER}-$${HASH})/\" $(location config.h.in) | sed 's/cmake//' > $(@D)/config.h""",
)
