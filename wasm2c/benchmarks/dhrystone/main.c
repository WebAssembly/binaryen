#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "uvwasi.h"

#include "dhrystone.h"

struct w2c_wasi__snapshot__preview1 {
  wasm_rt_memory_t* w2c_memory;
  uvwasi_t* uvwasi;
};

#define WASI_SUCCESS 0
#define WASI_BADF_ERROR 8

typedef uint32_t u32;
typedef uint64_t u64;

#if WABT_BIG_ENDIAN
#define MEM_ADDR(mem, addr, n) ((mem)->data_end - (addr) - (n))
#else
#define MEM_ADDR(mem, addr, n) &((mem)->data[addr])
#endif

#define MEM_ADDR_MEMOP(mem, addr, n) MEM_ADDR(mem, addr, n)

#define TRAP(x) (wasm_rt_trap(WASM_RT_TRAP_##x), 0)

#define RANGE_CHECK(mem, offset, len)     \
  if (offset + (uint64_t)len > mem->size) \
    TRAP(OOB);

static inline void memory_fill(wasm_rt_memory_t* mem, u32 d, u32 val, u32 n) {
  RANGE_CHECK(mem, d, n);
  memset(MEM_ADDR(mem, d, n), val, n);
}

#define MEMCHECK(mem, a, t) RANGE_CHECK(mem, a, sizeof(t))

#ifdef __GNUC__
#define FORCE_READ_INT(var) __asm__("" ::"r"(var));
#else
#define FORCE_READ_INT(var)
#endif

#define DEFINE_LOAD(name, t1, t2, t3, force_read)                  \
  static inline t3 name(wasm_rt_memory_t* mem, u64 addr) {         \
    MEMCHECK(mem, addr, t1);                                       \
    t1 result;                                                     \
    wasm_rt_memcpy(&result, MEM_ADDR_MEMOP(mem, addr, sizeof(t1)), \
                   sizeof(t1));                                    \
    force_read(result);                                            \
    return (t3)(t2)result;                                         \
  }

#define DEFINE_STORE(name, t1, t2)                                     \
  static inline void name(wasm_rt_memory_t* mem, u64 addr, t2 value) { \
    MEMCHECK(mem, addr, t1);                                           \
    t1 wrapped = (t1)value;                                            \
    wasm_rt_memcpy(MEM_ADDR_MEMOP(mem, addr, sizeof(t1)), &wrapped,    \
                   sizeof(t1));                                        \
  }

DEFINE_LOAD(i8_load, u8, u8, u8, FORCE_READ_INT)
DEFINE_LOAD(i16_load, u16, u16, u16, FORCE_READ_INT)
DEFINE_LOAD(i32_load, u32, u32, u32, FORCE_READ_INT)
DEFINE_LOAD(i64_load, u64, u64, u64, FORCE_READ_INT)
DEFINE_STORE(i8_store, u8, u8)
DEFINE_STORE(i16_store, u16, u16)
DEFINE_STORE(i32_store, u32, u32)
DEFINE_STORE(i64_store, u64, u64)

u32 w2c_wasi__snapshot__preview1_args_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b,
    u32 c) {
  return WASI_SUCCESS;
}
u32 w2c_wasi__snapshot__preview1_args_sizes_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 str_count,
    u32 buff_size) {
  i32_store(a->w2c_memory, str_count, 0);
  i32_store(a->w2c_memory, buff_size, 0);
  return WASI_SUCCESS;
}
u32 w2c_wasi__snapshot__preview1_fd_prestat_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b,
    u32 c) {
  return WASI_BADF_ERROR;
}

u32 w2c_wasi__snapshot__preview1_fd_write(
    struct w2c_wasi__snapshot__preview1* a,
    u32 fd,
    u32 iovs_offset,
    u32 iovs_len,
    u32 nwritten) {
  if (iovs_len > 32)
    return UVWASI_EINVAL;
  uvwasi_ciovec_t iovs[iovs_len];

  for (uvwasi_size_t i = 0; i < iovs_len; ++i) {
    u32 wasi_iovs_i = iovs_offset + i * sizeof(uvwasi_size_t[2]);
    u32 buf_loc = i32_load(a->w2c_memory, wasi_iovs_i);
    u32 buf_len = i32_load(a->w2c_memory, wasi_iovs_i + sizeof(uvwasi_size_t));
    iovs[i].buf = MEM_ADDR(a->w2c_memory, buf_loc, buf_len);
    iovs[i].buf_len = buf_len;
  }

  uvwasi_size_t num_written;
  uvwasi_errno_t ret =
      uvwasi_fd_write(a->uvwasi, fd, iovs, iovs_len, &num_written);
  i32_store(a->w2c_memory, nwritten, num_written);
  return ret;
}

uint32_t w2c_wasi__snapshot__preview1_fd_fdstat_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 fd,
    u32 stat) {
  uvwasi_fdstat_t uvstat;
  uvwasi_errno_t ret = uvwasi_fd_fdstat_get(a->uvwasi, fd, &uvstat);
  if (ret == UVWASI_ESUCCESS) {
    memory_fill(a->w2c_memory, stat, 0, 24);
    i8_store(a->w2c_memory, stat, uvstat.fs_filetype);
    i16_store(a->w2c_memory, stat + 2, uvstat.fs_flags);
    i64_store(a->w2c_memory, stat + 8, uvstat.fs_rights_base);
    i64_store(a->w2c_memory, stat + 16, uvstat.fs_rights_inheriting);
  }
  return ret;
}

u32 w2c_wasi__snapshot__preview1_clock_time_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 clk_id,
    u64 precision,
    u32 result) {
  uvwasi_timestamp_t t;
  uvwasi_errno_t ret = uvwasi_clock_time_get(a->uvwasi, clk_id, precision, &t);
  i64_store(a->w2c_memory, result, t);
  return ret;
}

u32 w2c_wasi__snapshot__preview1_clock_res_get(
    struct w2c_wasi__snapshot__preview1* a,
    u32 clk_id,
    u32 result) {
  uvwasi_timestamp_t t;
  uvwasi_errno_t ret = uvwasi_clock_res_get(a->uvwasi, clk_id, &t);
  i64_store(a->w2c_memory, result, t);
  return ret;
}

u32 w2c_wasi__snapshot__preview1_fd_seek(struct w2c_wasi__snapshot__preview1* a,
                                         u32 b,
                                         u64 c,
                                         u32 d,
                                         u32 e) {
  printf("fd_seek not implemented\n");
  abort();
}
u32 w2c_wasi__snapshot__preview1_fd_read(struct w2c_wasi__snapshot__preview1* a,
                                         u32 b,
                                         u32 c,
                                         u32 d,
                                         u32 e) {
  printf("fd_read not implemented\n");
  abort();
}
u32 w2c_wasi__snapshot__preview1_fd_close(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b) {
  printf("fd_close not implemented\n");
  abort();
}
u32 w2c_wasi__snapshot__preview1_fd_fdstat_set_flags(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b,
    u32 c) {
  printf("fd_fdstat_set_flags not implemented\n");
  abort();
}
u32 w2c_wasi__snapshot__preview1_fd_prestat_dir_name(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b,
    u32 c,
    u32 d) {
  printf("fd_prestat_dir_name not implemented\n");
  abort();
}
u32 w2c_wasi__snapshot__preview1_path_open(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b,
    u32 c,
    u32 d,
    u32 e,
    u32 f,
    u64 g,
    u64 h,
    u32 i,
    u32 end) {
  printf("path_open not implemented\n");
  abort();
}
void w2c_wasi__snapshot__preview1_proc_exit(
    struct w2c_wasi__snapshot__preview1* a,
    u32 b) {
  printf("proc_exit not implemented\n");
  abort();
}

int main(int argc, char const* argv[]) {
  w2c_dhrystone dhrystone;
  struct w2c_wasi__snapshot__preview1 wasi;
  uvwasi_t local_uvwasi_state;
  uvwasi_options_t init_options;

  // pass in standard descriptors
  init_options.in = 0;
  init_options.out = 1;
  init_options.err = 2;
  init_options.fd_table_size = 10;

  // pass in args and environement
  extern const char** environ;
  init_options.argc = argc;
  init_options.argv = argv;
  init_options.envp = (const char**)environ;

  // no sandboxing enforced, binary has access to everything user does
  init_options.preopenc = 2;
  init_options.preopens = calloc(2, sizeof(uvwasi_preopen_t));

  init_options.preopens[0].mapped_path = "/";
  init_options.preopens[0].real_path = "/";
  init_options.preopens[1].mapped_path = "./";
  init_options.preopens[1].real_path = ".";

  init_options.allocator = NULL;

  wasm_rt_init();
  uvwasi_errno_t ret = uvwasi_init(&local_uvwasi_state, &init_options);

  if (ret != UVWASI_ESUCCESS) {
    printf("uvwasi_init failed with error %d\n", ret);
    exit(1);
  }

  wasi.w2c_memory = &dhrystone.w2c_memory;
  wasi.uvwasi = &local_uvwasi_state,

  wasm2c_dhrystone_instantiate(&dhrystone, &wasi);

  w2c_dhrystone_0x5Fstart(&dhrystone);

  wasm2c_dhrystone_free(&dhrystone);

  uvwasi_destroy(&local_uvwasi_state);
  wasm_rt_free();

  return 0;
}
