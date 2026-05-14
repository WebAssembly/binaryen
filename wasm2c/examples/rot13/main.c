/* Entry point for the rot13 example.
 *
 * This example shows how you can fulfill wasm module imports in your C
 * program, and access linear memory.
 *
 * The program reads arguments from the command line, and [rot13] encodes them,
 * e.g.:
 *
 * ```
 * $ rot13 foo bar
 * foo -> sbb
 * bar -> one
 * ```
 *
 * [rot13]: https://en.wikipedia.org/wiki/ROT13
 */
#include <stdio.h>
#include <stdlib.h>

#include "rot13.h"

/* Define structure to hold the imports */
struct w2c_host {
  wasm_rt_memory_t memory;
  char* input;
};

/* Accessor to access the memory member of the host */
wasm_rt_memory_t* w2c_host_mem(struct w2c_host* instance) {
  return &instance->memory;
}

int main(int argc, char** argv) {
  /* Make sure there is at least one command-line argument. */
  if (argc < 2) {
    printf("Invalid argument. Expected '%s WORD...'\n", argv[0]);
    return 1;
  }
  /* Initialize the Wasm runtime. */
  wasm_rt_init();

  /* Create a structure to store the memory and current string, allocating 1
     page of Wasm memory (64 KiB) that the rot13 module instance will import. */
  struct w2c_host host;
  wasm_rt_allocate_memory(&host.memory, 1, 1, false, WASM_DEFAULT_PAGE_SIZE);

  // Construct an instance of the `rot13` module, which imports from the host.
  w2c_rot13 rot13;
  wasm2c_rot13_instantiate(&rot13, &host);

  /* Call `rot13` on each argument. */
  while (argc > 1) {
    /* Move to next arg. Do this first, so the program name is skipped. */
    argc--;
    argv++;

    host.input = argv[0];
    w2c_rot13_rot13(&rot13);
  }

  /* Free the rot13 module. */
  wasm2c_rot13_free(&rot13);

  /* Free the Wasm runtime state. */
  wasm_rt_free();

  return 0;
}

/* Fill the wasm buffer with the input to be rot13'd.
 *
 * params:
 *   instance: An instance of the w2c_host structure
 *   ptr: The wasm memory address of the buffer to fill data.
 *   size: The size of the buffer in wasm memory.
 * result:
 *   The number of bytes filled into the buffer. (Must be <= size).
 */
u32 w2c_host_fill_buf(struct w2c_host* instance, u32 ptr, u32 size) {
  for (size_t i = 0; i < size; ++i) {
    if (instance->input[i] == 0) {
      return i;
    }
    instance->memory.data[ptr + i] = instance->input[i];
  }
  return size;
}

/* Called when the wasm buffer has been rot13'd.
 *
 * params:
 *   w2c_host: An instance of the w2c_host structure
 *   ptr: The wasm memory address of the buffer.
 *   size: The size of the buffer in wasm memory.
 */
void w2c_host_buf_done(struct w2c_host* instance, u32 ptr, u32 size) {
  /* The output buffer is not necessarily null-terminated, so use the %*.s
   * printf format to limit the number of characters printed. */
  printf("%s -> %.*s\n", instance->input, (int)size,
         &instance->memory.data[ptr]);
}
