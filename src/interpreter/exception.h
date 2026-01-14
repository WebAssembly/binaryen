#ifndef wasm_interpreter_exception_h
#define wasm_interpreter_exception_h

namespace wasm {

// An exception emitted when exit() is called.
struct ExitException {};

// An exception emitted when a wasm trap occurs.
struct TrapException {};

// An exception emitted when a host limitation is hit. (These are not wasm traps
// as they are not in the spec; for example, the spec has no limit on how much
// GC memory may be allocated, but hosts have limits.)
struct HostLimitException {};

} // namespace wasm

#endif // wasm_interpreter_exception_h
