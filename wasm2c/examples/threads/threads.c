#include <pthread.h>
#include <stdio.h>

#include "sample.h"
#include "wasm-rt-exceptions.h"
#include "wasm-rt-impl.h"

#define NUM_THREADS 1024

void* do_thread(void* arg);

/**
 * Example demonstrating use of the wasm2c runtime in multithreaded code.
 *
 * The program calls wasm_rt_init() on startup, and each new thread calls
 * wasm_rt_init_thread() before instantiating a Wasm module. The sample
 * module is designed to trap with stack exhaustion; this example tests
 * that each thread can successfully catch the trap (in its own altstack)
 * independently.
 */

int main(int argc, char** argv) {
  pthread_t threads[NUM_THREADS];
  int arguments[NUM_THREADS];

  /* Initialize the Wasm runtime. */
  wasm_rt_init();

  /* Create and launch threads running the `do_thread` function. */
  for (int i = 0; i < NUM_THREADS; ++i) {
    arguments[i] = i;
    if (pthread_create(&threads[i], NULL, do_thread, &arguments[i])) {
      perror("pthread_create");
      exit(EXIT_FAILURE);
    }
  }

  /* Join each thread. */
  for (int i = 0; i < NUM_THREADS; ++i) {
    void* retval;
    if (pthread_join(threads[i], &retval)) {
      perror("pthread_join");
      exit(EXIT_FAILURE);
    }

    /* Verify returned value is as expected */
    if ((retval != &arguments[i]) || (arguments[i] != 3 * i)) {
      fprintf(stderr, "Unexpected return value from thread.\n");
      exit(EXIT_FAILURE);
    }
  }

  /* Free the Wasm runtime's state. */
  wasm_rt_free();

  printf("%d/%d threads trapped successfully.\n", NUM_THREADS, NUM_THREADS);

  return EXIT_SUCCESS;
}

void* do_thread(void* arg) {
  int param;
  memcpy(&param, arg, sizeof(int));

  /* Initialize the per-thread context for the Wasm runtime (in
     practice, this allocates and installs an alternate stack for
     catching segfaults caused by stack exhaustion or out-of-bounds
     memory access). */
  wasm_rt_init_thread();

  /* Instantiate the Wasm module. */
  w2c_sample inst;
  wasm2c_sample_instantiate(&inst);

  /* Expect a stack-exhaustion trap. (N.B. in a pthreads-created stack, Linux's
     segfault for stack overflow appears the same as one for memory OOB. This is
     similar to the behavior of macOS when exhausting a non-pthreads stack. */
  wasm_rt_trap_t code = wasm_rt_impl_try();
  if (code != 0) {
    if (code == WASM_RT_TRAP_OOB || code == WASM_RT_TRAP_EXHAUSTION) {
      /* Trap arrived as expected. Now call the "real" function. */
      int returnval = w2c_sample_multiplyby3(&inst, param);
      memcpy(arg, &returnval, sizeof(int));

      /* Free the module instance. */
      wasm2c_sample_free(&inst);

      /* Free the per-thread runtime context. */
      wasm_rt_free_thread();

      return arg;
    } else {
      fprintf(stderr, "Expected OOB or exhaustion trap but got %s\n",
              wasm_rt_strerror(code));
      return NULL;
    }
  }

  /* Call the stack-overflow function. Expect a trap back to above. */
  w2c_sample_stackoverflow(&inst);

  /* If no trap... */
  fprintf(stderr, "Expected trap but did not get one\n");
  return NULL;
}
