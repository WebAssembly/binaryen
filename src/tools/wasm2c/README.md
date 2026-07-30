# wasm2c: Convert wasm files to C source and header

`wasm2c` takes a WebAssembly module and produces an equivalent C source and
header. Some examples:

```sh
# parse binary file test.wasm and write test.c and test.h
$ wasm2c test.wasm -o test.c

# parse test.wasm, write test.c and test.h, but ignore the debug names, if any
$ wasm2c test.wasm --no-debug-names -o test.c
```

The C code produced targets the C99 standard. If, however, the Wasm module uses
Wasm threads/atomics, the code produced targets the C11 standard.

## Tutorial: .wat -> .wasm -> .c

Let's look at a simple example of a factorial function.

```wasm
(memory $mem 1)
(func (export "fac") (param $x i32) (result i32)
  (if (result i32) (i32.eq (local.get $x) (i32.const 0))
    (then (i32.const 1))
    (else
      (i32.mul (local.get $x) (call 0 (i32.sub (local.get $x) (i32.const 1))))
    )
  )
)
```

Save this to `fac.wat`. We can convert this to a `.wasm` file by using the
`wat2wasm` tool:

```sh
$ wat2wasm fac.wat -o fac.wasm
```

We can then convert it to a C source and header by using the `wasm2c` tool:

```sh
$ wasm2c fac.wasm -o fac.c
```

This generates two files, `fac.c` and `fac.h`. We'll take a closer look at
these files below, but first let's show a simple example of how to use these
files.

## Using the generated module

To actually use our `fac` module, we'll use create a new file, `main.c`, that
include `fac.h`, initializes the module, and calls `fac`.

`wasm2c` generates a few C symbols based on the `fac.wasm` module.
The first is `w2c_fac`, a type that represents an instance of the
`fac` module. `wasm2c` generates functions that construct and free a
`w2c_fac` instance: `wasm2c_fac_instantiate` and
`wasm2c_fac_free`. Finally, `wasm2c` generates the exported `fac`
function itself (`w2c_fac_fac`), which acts on a `w2c_fac` instance.

All the exported symbols shared a common module ID (`fac`) which, by default, is
based on the name section in the module or the name of input file.  This prefix
can be overridden using the `-n/--module-name` command line flag.

```c
#include <stdio.h>
#include <stdlib.h>

#include "fac.h"

int main(int argc, char** argv) {
  /* Make sure there is at least one command-line argument. */
  if (argc < 2) {
    printf("Invalid argument. Expected '%s NUMBER'\n", argv[0]);
    return 1;
  }

  /* Convert the argument from a string to an int. We'll implicitly cast the int
  to a `u32`, which is what `fac` expects. */
  u32 x = atoi(argv[1]);

  /* Initialize the Wasm runtime. */
  wasm_rt_init();

  /* Declare an instance of the `fac` module. */
  w2c_fac fac;

  /* Construct the module instance. */
  wasm2c_fac_instantiate(&fac);

  /* Call `fac`, using the mangled name. */
  u32 result = w2c_fac_fac(&fac, x);

  /* Print the result. */
  printf("fac(%u) -> %u\n", x, result);

  /* Free the fac module. */
  wasm2c_fac_free(&fac);

  /* Free the Wasm runtime state. */
  wasm_rt_free();

  return 0;
}

```

## Compiling the wasm2c output

To compile the executable, we need to use `main.c` and the generated `fac.c`.
We'll also include `wasm-rt-impl.c` and `wasm-rt-mem-impl.c`, which have implementations of the various
`wasm_rt_*` functions used by `fac.c` and `fac.h`.

```sh
$ cc -o fac main.c fac.c wasm2c/wasm-rt-impl.c wasm2c/wasm-rt-mem-impl.c -Iwasm2c -lm
```

A note on compiling with optimization: wasm2c relies on certain
behavior from the C compiler to maintain conformance with the
WebAssembly specification, especially with regards to requirements to
convert "signaling" to "quiet" floating-point NaN values and for
infinite recursion to produce a trap. When compiling with optimization
(e.g. `-O2` or `-O3`), it's necessary to disable some optimizations to
preserve conformance. With GCC 11, adding the command-line arguments
`-fno-optimize-sibling-calls -frounding-math -fsignaling-nans` appears
to be sufficient. With clang 14, just `-fno-optimize-sibling-calls
-frounding-math` appears to be sufficient.

Now let's test it out!

```sh
$ ./fac 1
fac(1) -> 1
$ ./fac 5
fac(5) -> 120
$ ./fac 10
fac(10) -> 3628800
```

You can take a look at the all of these files in
[wasm2c/examples/fac](/wasm2c/examples/fac).

### Enabling extra sanity checks

Wasm2c provides a macro `WASM_RT_SANITY_CHECKS` that if defined enables
additional sanity checks in the produced Wasm2c code. Note that this may have a
high performance overhead, and is thus only recommended for debug builds.

### Enabling Segue (a Linux x86_64 target specific optimization)

Wasm2c can use the "Segue" optimization if allowed. The segue optimization uses
an x86 segment register to store the location of Wasm's linear memory, when
compiling a Wasm module with clang, running on x86_64 Linux, the macro
`WASM_RT_ALLOW_SEGUE` is defined, and the flag `-mfsgsbase` is passed to clang.
Segue is not used if

1. The Wasm module uses a more than a single unshared imported or exported
   memory
2. The wasm2c code is compiled with GCC. Segue requires intrinsics for
   (rd|wr)gsbase, "address namespaces" for accessing pointers, and support for
   memcpy on pointers with custom "address namespaces". GCC does not support the
   memcpy requirement.
3. The code is compiled for Windows as Windows doesn't restore the segment
   register on context switch.

The wasm2c generated code automatically sets the unused segment register (the
`%gs` register on x86_64 Linux) during the function calls into wasm2c generated
module, restores it after calls to external modules etc. Any host function
written in C would continue to work without changes as C code does not modify
the unused segment register `%gs` (See
[here](https://www.kernel.org/doc/html/next/x86/x86_64/fsgs.html) for details).
However, any host functions written in assembly that clobber the free segment
register must restore the value of this register prior to executing or returning
control to wasm2c generated code.

As an additional optimization, if the host program does not use the `%gs`
segment register for any other purpose (which is typically the case in most
programs), you can additionally allow wasm2c to unconditionally overwrite the
value of the `%gs` register without restoring the old value. This can be done
defining the macro `WASM_RT_SEGUE_FREE_SEGMENT`.

You can test the performance of the Segue optimization by running Dhrystone with
and without Segue:

```bash
cd wasm2c/benchmarks/segue && make
```

## Looking at the generated header, `fac.h`

The generated header file looks something like this:

```c
/* Automatically generated by wasm2c */
#ifndef FAC_H_GENERATED_
#define FAC_H_GENERATED_

...

#include "wasm-rt.h"

...
#ifndef WASM_RT_CORE_TYPES_DEFINED
#define WASM_RT_CORE_TYPES_DEFINED

...

#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct w2c_fac {
  char dummy_member;
} w2c_fac;

void wasm2c_fac_instantiate(w2c_fac*);
void wasm2c_fac_free(w2c_fac*);
wasm_rt_func_type_t wasm2c_fac_get_func_type(uint32_t param_count, uint32_t result_count, ...);

/* export: 'fac' */
u32 w2c_fac_fac(w2c_fac*, u32);

#ifdef __cplusplus
}
#endif

#endif  /* FAC_H_GENERATED_ */

```

Let's look at each section. The outer `#ifndef` is standard C
boilerplate for a header. This `WASM_RT_CORE_TYPES_DEFINED` section
contains a number of definitions required for all WebAssembly
modules. The `extern "C"` part makes sure to not mangle the symbols if
using this header in C++.

The included `wasm-rt.h` file also includes a number of relevant definitions.
First is the `wasm_rt_trap_t` enum, which is used to give the reason a trap
occurred.

```c
typedef enum {
  WASM_RT_TRAP_NONE,
  WASM_RT_TRAP_OOB,
  WASM_RT_TRAP_INT_OVERFLOW,
  WASM_RT_TRAP_DIV_BY_ZERO,
  WASM_RT_TRAP_INVALID_CONVERSION,
  WASM_RT_TRAP_UNREACHABLE,
  WASM_RT_TRAP_CALL_INDIRECT,
  WASM_RT_TRAP_UNCAUGHT_EXCEPTION,
  WASM_RT_TRAP_EXHAUSTION,
} wasm_rt_trap_t;
```

Next is the `wasm_rt_type_t` enum, which is used for specifying function
signatures. Six WebAssembly value types are included:

```c
typedef enum {
  WASM_RT_I32,
  WASM_RT_I64,
  WASM_RT_F32,
  WASM_RT_F64,
  WASM_RT_FUNCREF,
  WASM_RT_EXTERNREF,
} wasm_rt_type_t;

Next is `wasm_rt_function_ptr_t`, the function signature for a generic function
callback. Since a WebAssembly table can contain functions of any given
signature, it is necessary to convert them to a canonical form:

```c
typedef void (*wasm_rt_function_ptr_t)(void);
```

Next is the definition for a function reference (in WebAssembly 1.0,
this was the type of all table elements, but funcrefs can now also be
used as ordinary values, and tables can alternately be declared as
type externref). In this structure, `wasm_rt_func_type_t` is an opaque
256-bit ID that can be looked up via the `Z_[modname]_get_func_type`
function. (A demonstration of this can be found in the `callback`
example.) `module_instance` is the pointer to the function's
originating module instance, which will be passed in when the func is
called.

```c
typedef struct {
  wasm_rt_func_type_t func_type;
  wasm_rt_function_ptr_t func;
  void* module_instance;
} wasm_rt_funcref_t;

```

Next is the definition of a memory instance. The `data` field is a pointer to
`size` bytes of linear memory. The `size` field of `wasm_rt_memory_t` is the
current size of the memory instance in bytes, `pages` is the current
size in pages, and `page_size` contains the page size in bytes (65,536 by default).
`max_pages` is the maximum number of pages specified by the module or allowed
by the memory index type (`is64` is true for memories that can grow to 2^64 bytes;
`false` for memories limited to 2^32 bytes).

```c
typedef struct {
  uint8_t* data;
  uint32_t page_size;
  uint64_t pages, max_pages;
  uint64_t size;
  bool is64;
} wasm_rt_memory_t;
```

This is followed by the definition of a shared memory instance. This is similar
to a regular memory instance, but represents memory that can be used by multiple
Wasm instances, and thus enforces a minimum amount of memory order on
operations. The Shared memory definition has one additional member, `mem_lock`,
which is a lock that is used during memory grow operations for thread safety.

```c
typedef struct {
  _Atomic volatile uint8_t* data;
  uint64_t pages, max_pages;
  uint64_t size;
  bool is64;
  mtx_t mem_lock;
} wasm_rt_shared_memory_t;
```

Next is the definition of a table instance. The `data` field is a pointer to
`size` elements. Like a memory instance, `size` is the current size of a table,
and `max_size` is the maximum size of the table, or `0xffffffff` if there is no
limit.

```c
typedef struct {
  wasm_rt_funcref_t* data;
  uint32_t max_size;
  uint32_t size;
} wasm_rt_funcref_table_t;
```

## Symbols that must be defined by the embedder

Next in `wasm-rt.h` are a collection of function declarations that must be implemented by
the embedder (i.e. you) before this C source can be used.

A C implementation of these functions is defined in
[`wasm-rt-impl.h`](wasm-rt-impl.h) and [`wasm-rt-impl.c`](wasm-rt-impl.c).

```c
void wasm_rt_init(void);
bool wasm_rt_is_initialized(void);
void wasm_rt_free(void);
void wasm_rt_trap(wasm_rt_trap_t) __attribute__((noreturn));
const char* wasm_rt_strerror(wasm_rt_trap_t trap);
void wasm_rt_allocate_memory(wasm_rt_memory_t*, uint32_t initial_pages, uint32_t max_pages, bool is64, uint32_t page_size);
uint32_t wasm_rt_grow_memory(wasm_rt_memory_t*, uint32_t pages);
void wasm_rt_free_memory(wasm_rt_memory_t*);
void wasm_rt_allocate_memory_shared(wasm_rt_shared_memory_t*, uint32_t initial_pages, uint32_t max_pages, bool is64, uint32_t page_size);
uint32_t wasm_rt_grow_memory_shared(wasm_rt_shared_memory_t*, uint32_t pages);
void wasm_rt_free_memory_shared(wasm_rt_shared_memory_t*);
void wasm_rt_allocate_funcref_table(wasm_rt_table_t*, uint32_t elements, uint32_t max_elements);
void wasm_rt_allocate_externref_table(wasm_rt_externref_table_t*, uint32_t elements, uint32_t max_elements);
void wasm_rt_free_funcref_table(wasm_rt_table_t*);
void wasm_rt_free_externref_table(wasm_rt_table_t*);
uint32_t wasm_rt_call_stack_depth; /* on platforms that don't use the signal handler to detect exhaustion */
void wasm_rt_init_thread(void);
void wasm_rt_free_thread(void);
```

`wasm_rt_init` must be called by the embedder before anything else, to
initialize the runtime. `wasm_rt_free` frees any global
state. `wasm_rt_is_initialized` can be used to confirm that the
runtime has been initialized.

`wasm_rt_trap` is a function that is called when the module traps. Some possible
implementations are to throw a C++ exception, or to just abort the program
execution. The default runtime included in wasm2c unwinds the stack using
`longjmp`. The host can overide this call to `longjmp` by compiling the runtime
with `WASM_RT_TRAP_HANDLER` defined to the name of a trap handler function. The
handler function should be a function taking a `wasm_rt_trap_t` as a parameter
and returning `void`. e.g. `-DWASM_RT_TRAP_HANDLER=my_trap_handler`

`wasm_rt_allocate_memory` initializes a memory instance, and allocates
at least enough space for the given number of initial pages, each of
size `page_size` (which must be `WASM_DEFAULT_PAGE_SIZE`, equal to 64
KiB, unless using the custom-page-sizes feature). The memory must be
cleared to zero. The `is64` parameter indicates if the memory is
indexed with an i32 or i64 address.

`wasm_rt_grow_memory` must grow the given memory instance by the given number of
pages. If there isn't enough memory to do so, or the new page count would be
greater than the maximum page count, the function must fail by returning
`0xffffffff`. If the function succeeds, it must return the previous size of the
memory instance, in pages. The host can optionally be notified of failures by
compiling the runtime with `WASM_RT_GROW_FAILED_HANDLER` defined to the name of
a handler function.  The handler function should be a function taking no
arguments and returning `void` . e.g.
`-DWASM_RT_GROW_FAILED_HANDLER=my_growfail_handler`

`wasm_rt_free_memory` frees the memory instance.

`wasm_rt_allocate_memory_shared` initializes a memory instance that can be
shared by different Wasm threads. Its operation is otherwise similar to
`wasm_rt_allocate_memory`.

`wasm_rt_grow_memory_shared` must grow the given shared memory instance by the
given number of pages. It's operation is otherwise similar to
`wasm_rt_grow_memory`.

`wasm_rt_free_memory_shared` frees the shared memory instance.

`wasm_rt_allocate_funcref_table` and the similar `..._externref_table`
initialize a table instance of the given type, and allocate at least
enough space for the given number of initial elements. The elements
must be cleared to zero.

`wasm_rt_free_funcref_table` and `..._externref_table` free the table instance.

`wasm_rt_call_stack_depth` is the current stack call depth. Since this is
shared between modules, it must be defined only once, by the embedder.
It is only used on platforms that don't use the signal handler to detect
exhaustion.

`wasm_rt_init_thread` and `wasm_rt_free_thread` are used to initialize
and free the runtime state for a given thread (other than the one that
called `wasm_rt_init`). An example can be found in
`wasm2c/examples/threads`.

### Runtime support for exception handling

Several additional symbols must be defined if wasm2c is being run with support
for exceptions (`--enable-exceptions`). These are defined in
`wasm-rt-exceptions.h`. These symbols are:

```c
void wasm_rt_load_exception(const char* tag, uint32_t size, const void* values);
WASM_RT_NO_RETURN void wasm_rt_throw(void);
WASM_RT_UNWIND_TARGET
WASM_RT_UNWIND_TARGET* wasm_rt_get_unwind_target(void);
void wasm_rt_set_unwind_target(WASM_RT_UNWIND_TARGET* target);
uint32_t wasm_rt_exception_tag(void);
uint32_t wasm_rt_exception_size(void);
void* wasm_rt_exception(void);
wasm_rt_try(target)
```

A C implementation of these functions is also available in
[`wasm-rt-exceptions-impl.c`](wasm-rt-exceptions-impl.c).

`wasm_rt_load_exception` sets the active exception to a given tag, size, and contents.

`wasm_rt_throw` throws the active exception.

`WASM_RT_UNWIND_TARGET` is the type of an unwind target if an
exception is thrown and caught.

`wasm_rt_get_unwind_target` gets the current unwind target if an exception is thrown.

`wasm_rt_set_unwind_target` sets the unwind target if an exception is thrown.

Three functions provide access to the active exception:
`wasm_rt_exception_tag`, `wasm_rt_exception_size`, and
`wasm_rt_exception` return its tag, size, and contents, respectively.

`wasm_rt_try(target)` is a macro that captures the current calling
environment as an unwind target and stores it into `target`, which
must be of type `WASM_RT_UNWIND_TARGET`.

## Exported symbols

Finally, `fac.h` defines the module instance type (which in the case
of `fac` is essentially empty), and the exported symbols provided by
the module. In our example, the only function we exported was
`fac`.

`wasm2c_fac_instantiate(w2c_fac*)` creates an instance of
the module and must be called before the module instance can be
used. `wasm2c_fac_free(w2c_fac*)` frees the instance.
`wasm2c_fac_get_func_type` can be used to look up a function type ID
at runtime. It is a variadic function where the first two arguments
give the number of parameters and results, and the following arguments
are the types from the wasm_rt_type_t enum described above. The
`callback` example demonstrates using this to pass a host function to
a WebAssembly module dynamically at runtime.

```c
typedef struct w2c_fac {
  char dummy_member;
} w2c_fac;

void wasm2c_fac_instantiate(w2c_fac*);
void wasm2c_fac_free(w2c_fac*);
wasm_rt_func_type_t wasm2c_fac_get_func_type(uint32_t param_count, uint32_t result_count, ...);

/* export: 'fac' */
u32 w2c_fac_fac(w2c_fac*, u32);
```

## Handling other kinds of imports and exports of modules

Exported functions are handled by declaring a prefixed equivalent
function in the header. If a module imports a function, `wasm2c`
declares the function in the output header file, and the host function
is responsible for defining the function.

Exports of other kinds (globals, memories, tables) are handled
differently, since they are part of the module instance, and each
instance can have its own exports. For these cases, `wasm2c` provides
a function that takes in a module instance as argument, and returns
the corresponding export. For example, if `fac` exported a memory as
such:

```wasm
(export "mem" (memory $mem))
```

then `wasm2c` would declare the following function in the header:

```c
/* export: 'mem' */
wasm_rt_memory_t* w2c_fac_mem(w2c_fac* instance);

```

which would be defined as:
```c
/* export: 'mem' */
wasm_rt_memory_t* w2c_fac_mem(w2c_fac* instance) {
  return &instance->w2c_mem;
}
```

## A quick look at `fac.c`

The contents of `fac.c` are internals, but it is useful to see a little about
how it works.

The first few hundred lines define macros that are used to implement the
various WebAssembly instructions. Their implementations may be interesting to
the curious reader, but are out of scope for this document.

Following those definitions are various initialization functions (`init`, `free`,
`init_func_types`, `init_globals`, `init_memory`, `init_table`, and
`init_exports`.) In our example, most of these functions are empty, since the
module doesn't use any globals, memory or tables.

The most interesting part is the definition of the function `fac`:

```c
static u32 w2c_fac_fac_0(w2c_fac* instance, u32 var_p0) {
  FUNC_PROLOGUE;
  u32 var_i0, var_i1, var_i2;
  var_i0 = var_p0;
  var_i1 = 0u;
  var_i0 = var_i0 == var_i1;
  if (var_i0) {
    var_i0 = 1u;
  } else {
    var_i0 = var_p0;
    var_i1 = var_p0;
    var_i2 = 1u;
    var_i1 -= var_i2;
    var_i1 = w2c_fac_fac_0(instance, var_i1);
    var_i0 *= var_i1;
  }
  FUNC_EPILOGUE;
  return var_i0;
}
```

If you look at the original WebAssembly text in the flat format, you can see
that there is a 1-1 mapping in the output:

```wasm
(func $fac (param $x i32) (result i32)
  local.get $x
  i32.const 0
  i32.eq
  if (result i32)
    i32.const 1
  else
    local.get $x
    local.get $x
    i32.const 1
    i32.sub
    call 0
    i32.mul
  end)
```

This looks different than the factorial function above because it is using the
"flat format" instead of the "folded format". You can use `wat-desugar` to
convert between the two to be sure:

```sh
$ wat-desugar fac-flat.wat --fold -o fac-folded.wat
```

```wasm
(module
  (func (;0;) (param i32) (result i32)
    (if (result i32)  ;; label = @1
      (i32.eq
        (local.get 0)
        (i32.const 0))
      (then
        (i32.const 1))
      (else
        (i32.mul
          (local.get 0)
          (call 0
            (i32.sub
              (local.get 0)
              (i32.const 1)))))))
  (export "fac" (func 0))
  (type (;0;) (func (param i32) (result i32))))
```

The formatting is different and the variable and function names are gone, but
the structure is the same.

## Create multiple instances of a module

Since information about the execution context, such as memories, is encapsulated
in the module instance structure, and a pointer to the structure is being passed through 
function calls, multiple instances of the same module can be instantiated alongside
one another.

We can take a look at another version of the `main` function for a `rot13` example. By 
declaring two sets of context information, two instances of `rot13` can be instantiated 
in the same address space.

```c
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "rot13.h"

/* Define structure to hold the imports */
typedef struct w2c_host {
  wasm_rt_memory_t memory;
  char* input;
} w2c_host;

/* Accessor to access the memory member of the host */
wasm_rt_memory_t* w2c_host_mem(w2c_host* instance) {
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

  /* Create two `host` instances to store the memory and current string */
  w2c_host host_1, host_2;
  wasm_rt_allocate_memory(&host_1.memory, 1, 1, false, WASM_DEFAULT_PAGE_SIZE);
  wasm_rt_allocate_memory(&host_2.memory, 1, 1, false, WASM_DEFAULT_PAGE_SIZE);

  /* Construct the `rot13` module instances */
  w2c_rot13 rot13_1, rot13_2;
  wasm2c_rot13_instantiate(&rot13_1, &host_1);
  wasm2c_rot13_instantiate(&rot13_2, &host_2);

  /* Call `rot13` on the first two arguments. */
  assert(argc > 2);
  host_1.input = argv[1];
  w2c_rot13_rot13(&rot13_1);
  host_2.input = argv[2];
  w2c_rot13_rot13(&rot13_2);

  /* Free the rot13 instances. */
  wasm2c_rot13_free(&rot13_1);
  wasm2c_rot13_free(&rot13_2);

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
u32 w2c_host_fill_buf(w2c_host* instance, u32 ptr, u32 size) {
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
void w2c_host_buf_done(w2c_host* instance, u32 ptr, u32 size) {
  /* The output buffer is not necessarily null-terminated, so use the %*.s
   * printf format to limit the number of characters printed. */
  printf("%s -> %.*s\n", instance->input, (int)size, &instance->memory.data[ptr]);
}
```
