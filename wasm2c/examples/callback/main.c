#include <stdio.h>

#include "callback.h"

/*
 * The callback function. Prints the null-terminated string at the given
 * location in the instance's exported memory.
 */
void print(w2c_callback* instance, uint32_t ptr) {
  puts(w2c_callback_memory(instance)->data + ptr);
}

int main(int argc, char** argv) {
  /* Initialize the Wasm runtime. */
  wasm_rt_init();

  /* Instantiate the callback module. */
  w2c_callback inst;
  wasm2c_callback_instantiate(&inst);

  /*
   * Call the module's "set_print_function" function, which takes a funcref to
   * the callback. A funcref has three members: the function type (which can be
   * looked up with "Z_callback_get_func_type"), a pointer to the function, and
   * a module instance pointer that will be passed to the function when called.
   */
  wasm_rt_func_type_t fn_type =
      wasm2c_callback_get_func_type(1, 0, WASM_RT_I32);
  wasm_rt_funcref_t fn_ref = {
      fn_type, (wasm_rt_function_ptr_t)print, {NULL}, &inst};
  w2c_callback_set_print_function(&inst, fn_ref);

  /* "say_hello" uses the previously installed callback. */
  w2c_callback_say_hello(&inst);

  /* Free the module instance and the Wasm runtime state. */
  wasm2c_callback_free(&inst);
  wasm_rt_free();

  return 0;
}
