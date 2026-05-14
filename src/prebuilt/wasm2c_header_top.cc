const char* s_header_top = R"w2c_template(#include <stdint.h>
)w2c_template"
R"w2c_template(
#ifndef WASM_RT_CORE_TYPES_DEFINED
)w2c_template"
R"w2c_template(#define WASM_RT_CORE_TYPES_DEFINED
)w2c_template"
R"w2c_template(typedef uint8_t u8;
)w2c_template"
R"w2c_template(typedef int8_t s8;
)w2c_template"
R"w2c_template(typedef uint16_t u16;
)w2c_template"
R"w2c_template(typedef int16_t s16;
)w2c_template"
R"w2c_template(typedef uint32_t u32;
)w2c_template"
R"w2c_template(typedef int32_t s32;
)w2c_template"
R"w2c_template(typedef uint64_t u64;
)w2c_template"
R"w2c_template(typedef int64_t s64;
)w2c_template"
R"w2c_template(typedef float f32;
)w2c_template"
R"w2c_template(typedef double f64;
)w2c_template"
R"w2c_template(#endif
)w2c_template"
R"w2c_template(
#ifdef __cplusplus
)w2c_template"
R"w2c_template(extern "C" {
)w2c_template"
R"w2c_template(#endif
)w2c_template"
;
