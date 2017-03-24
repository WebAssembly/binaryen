binaryen.js API
===============

Overview
--------

binaryen.js is a port of Binaryen to the Web, allowing you to generate WebAssembly using a JavaScript API. To get a feel for the API, see the "hello world" test at `test/binaryen.js/hello-world.js`, and other tests in that directory for more examples.

The API is documented in the rest of this document.

Types
-----

 * `Binaryen.none`: The none type.
 * `Binaryen.i32`: The i32 type.
 * `Binaryen.i64`: The i64 type.
 * `Binaryen.f32`: The f32 type.
 * `Binaryen.f64`: The f64 type.

Modules
-------

 * `Binaryen.Module()`: Constructor for a Binaryen WebAssembly module. You need to create one of these first.

`Module` instances have the following properties.

Module property operations:

  * `addFunctionType(name, resultType, paramTypes)`: Add a function type to the module, with a specified name, result type, and param types.
  * `addFunction(name, functionType, varTypes, body)`: Add a function, with a name, a function type, an array of local types, and a body.
  * `addImport(internalName, externalModuleName, externalBaseName, functionType)`: Add an import, with an internal name (used by other things in the module), an external module name (the module from which we import), an external base name (the name we import from that module), and a function type (for function imports).
  * `addExport(internalName, externalName)`: Add an export, with an internal name and an external name (the name the outside sees it exported as).
  * `setFunctionTable(funcs)`: Sets the function table to a array of functions.
  * `setMemory(initial, maximum, exportName, segments)`: Sets the memory to having an initial size, maximum size, optional export name, and array of data segments.
  * `setStart(start)`: Sets the start function (called when the module is instantiated) to a specified function.

Module operations:

  * `emitBinary()`: Returns a binary for the module, which you can then compile and run in the browser.
  * `emitText()`: Returns a text representation of the module, in s-expression format.
  * `validate()`: Validates the module, checking it for correctness.
  * `optimize()`: Optimize the module.
  * `autoDrop()`: Automatically inserts `drop` operations. This lets you not worry about dropping when creating your code.
  * `interpret()`: Run the module in the Binaryen interpreter (creates the module, and calls the start method). Useful for debugging.
  * `dispose()`: Cleans up the module. If the Binaryen object can be garbage-collected anyhow, you don't need to do this, but if it stays around - e.g. if you create multiple `Module`s over time - then you should call this once a `Module` is no longer needed. (As binaryen.js uses compiled C++ code, we can't just rely on normal garbage collection to clean things up internally.)

Type-prefixed expressions:

  * `i32`:
    * `i32.load(offset, align, ptr)`: Create a 32-bit load, with an offset, alignment, and pointer.
    * `i32.load8_s(offset, align, ptr)`: Create an 8-bit signed load, with an offset, alignment, and pointer.
    * `i32.load8_u(offset, align, ptr)`: Create an 8-bit unsigned load, with an offset, alignment, and pointer.
    * `i32.load16_s(offset, align, ptr)`: Create an 16-bit signed load, with an offset, alignment, and pointer.
    * `i32.load16_u(offset, align, ptr)`: Create an 16-bit unsigned load, with an offset, alignment, and pointer.
    * `i32.store(offset, align, ptr, value)`: Create a 32-bit store, with an offset, alignment, pointer, and value.
    * `i32.store8(offset, align, ptr, value)`: Create an 8-bit store, with an offset, alignment, pointer, and value.
    * `i32.store16(offset, align, ptr, value)`: Create a 16-bit store, with an offset, alignment, pointer, and value.
    * `i32.const(value)`: Create an `i32` constant of a specified value.
    * `i32.clz(value)`: Create a count-leading-zeros of a specified value.
    * `i32.ctz(value)`: Create a count-trailing-zeros of a specified value.
    * `i32.popcnt(value)`: Create a population-count (number of bits set) of a specified value.
    * `i32.eqz(value)`: Create an equal-zero of a specified value.
    * `i32.trunc_s.f32(value)`: Create a signed truncate of an `f32` to an `i32`.
    * `i32.trunc_s.f64(value)`: Create a signed truncate of an `f64` to an `i32`.
    * `i32.trunc_u.f32(value)`: Create an unsigned truncate of an `f32` to an `i32`.
    * `i32.trunc_u.f64(value)`: Create an unsigned truncate of an `f64` to an `i32`.
    * `i32.reinterpret(value)`: Create a reinterpret of an `f32` to an `i32`.
    * `i32.wrap(value)`: Create a wrap of an `i64` to an `i32`.
    * `i32.add(left, right)`: Create an add of two `i32`s.
    * `i32.sub(left, right)`: Create a subtract of two `i32`s.
    * `i32.mul(left, right)`: Create a multiply of two `i32`s.
    * `i32.div_s(left, right)`: Create a signed divide of two `i32`s.
    * `i32.div_u(left, right)`: Create an unsigned divide of two `i32`s.
    * `i32.rem_s(left, right)`: Create a signed remainder of two `i32`s.
    * `i32.rem_u(left, right)`: Create an unsigned remainder of two `i32`s.
    * `i32.and(left, right)`: Create an and of two `i32`s.
    * `i32.or(left, right)`: Create an or of two `i32`s.
    * `i32.xor(left, right)`: Create a xor of two `i32`s.
    * `i32.shl(left, right)`: Create a shift left on two `i32`s.
    * `i32.shr_u(left, right)`: Create an unsigned (logical) shift right on two `i32`s.
    * `i32.shr_s(left, right)`: Create a signed (arithmetic) shift right on two `i32`s.
    * `i32.rotl(left, right)`: Create a rotate-left on two `i32`s.
    * `i32.rotr(left, right)`: Create a rotate-right on two `i32`s.
    * `i32.eq(left, right)`: Create an equals on two `i32`s.
    * `i32.ne(left, right)`: Create a not-equals on two `i32`s.
    * `i32.lt_s(left, right)`: Create a signed less-than on two `i32`s.
    * `i32.lt_u(left, right)`: Create an unsigned less-than on two `i32`s.
    * `i32.le_s(left, right)`: Create a signed less-or-equal on two `i32`s.
    * `i32.le_u(left, right)`: Create an unsigned less-or-equal on two `i32`s.
    * `i32.gt_s(left, right)`: Create a signed greater-than on two `i32`s.
    * `i32.gt_u(left, right)`: Create an unsigned greater-than on two `i32`s.
    * `i32.ge_s(left, right)`: Create a signed greater-or-equal on two `i32`s.
    * `i32.ge_u(left, right)`: Create an unsigned greater-or-equal on two `i32`s.
  * `i64`:
    * `i64.load(offset, align, ptr)`: Create a 32-bit load, with an offset, alignment, and pointer.
    * `i64.load8_s(offset, align, ptr)`: Create an 8-bit signed load, with an offset, alignment, and pointer.
    * `i64.load8_u(offset, align, ptr)`: Create an 8-bit unsigned load, with an offset, alignment, and pointer.
    * `i64.load16_s(offset, align, ptr)`: Create an 16-bit signed load, with an offset, alignment, and pointer.
    * `i64.load16_u(offset, align, ptr)`: Create an 16-bit unsigned load, with an offset, alignment, and pointer.
    * `i64.load32_s(offset, align, ptr)`: Create a 32-bit signed load, with an offset, alignment, and pointer.
    * `i64.load32_u(offset, align, ptr)`: Create a 32-bit unsigned load, with an offset, alignment, and pointer.
    * `i64.store(offset, align, ptr, value)`: Create a 32-bit store, with an offset, alignment, pointer, and value.
    * `i64.store8(offset, align, ptr, value)`: Create an 8-bit store, with an offset, alignment, pointer, and value.
    * `i64.store16(offset, align, ptr, value)`: Create a 16-bit store, with an offset, alignment, pointer, and value.
    * `i64.store32(offset, align, ptr, value)`: Create a 32-bit store, with an offset, alignment, pointer, and value.
    * `i64.const(low, high)`: Create an `i64` constant of a specified value, provided as low and high 32 bits.
    * `i64.clz(value)`: Create a count-leading-zeros of a specified value.
    * `i64.ctz(value)`: Create a count-trailing-zeros of a specified value.
    * `i64.popcnt(value)`: Create a population-count (number of bits set) of a specified value.
    * `i64.eqz(value)`: Create an equal-zero of a specified value.
    * `i64.trunc_s.f32(value)`: Create a signed truncate of an `f32` to an `i64`.
    * `i64.trunc_s.f64(value)`: Create a signed truncate of an `f64` to an `i64`.
    * `i64.trunc_u.f32(value)`: Create an unsigned truncate of an `f32` to an `i64`.
    * `i64.trunc_u.f64(value)`: Create an unsigned truncate of an `f64` to an `i64`.
    * `i64.reinterpret(value)`: Create a reinterpret of an `f64` to an `i64`.
    * `i64.extend_s(value)`: Create a signed extend of an `i32` to an `i64`.
    * `i64.extend_u(value)`: Create an unsigned extend of an `i32` to an `i64`.
    * `i64.add(left, right)`: Create an add of two `i64`s.
    * `i64.sub(left, right)`: Create a subtract of two `i64`s.
    * `i64.mul(left, right)`: Create a multiply of two `i64`s.
    * `i64.div_s(left, right)`: Create a signed divide of two `i64`s.
    * `i64.div_u(left, right)`: Create an unsigned divide of two `i64`s.
    * `i64.rem_s(left, right)`: Create a signed remainder of two `i64`s.
    * `i64.rem_u(left, right)`: Create an unsigned remainder of two `i64`s.
    * `i64.and(left, right)`: Create an and of two `i64`s.
    * `i64.or(left, right)`: Create an or of two `i64`s.
    * `i64.xor(left, right)`: Create a xor of two `i64`s.
    * `i64.shl(left, right)`: Create a shift left on two `i64`s.
    * `i64.shr_u(left, right)`: Create an unsigned (logical) shift right on two `i64`s.
    * `i64.shr_s(left, right)`: Create a signed (arithmetic) shift right on two `i64`s.
    * `i64.rotl(left, right)`: Create a rotate-left on two `i64`s.
    * `i64.rotr(left, right)`: Create a rotate-right on two `i64`s.
    * `i64.eq(left, right)`: Create an equals on two `i64`s.
    * `i64.ne(left, right)`: Create a not-equals on two `i64`s.
    * `i64.lt_s(left, right)`: Create a signed less-than on two `i64`s.
    * `i64.lt_u(left, right)`: Create an unsigned less-than on two `i64`s.
    * `i64.le_s(left, right)`: Create a signed less-or-equal on two `i64`s.
    * `i64.le_u(left, right)`: Create an unsigned less-or-equal on two `i64`s.
    * `i64.gt_s(left, right)`: Create a signed greater-than on two `i64`s.
    * `i64.gt_u(left, right)`: Create an unsigned greater-than on two `i64`s.
    * `i64.ge_s(left, right)`: Create a signed greater-or-equal on two `i64`s.
    * `i64.ge_u(left, right)`: Create an unsigned greater-or-equal on two `i64`s.
  * `f32`:
    * `f32.load(offset, align, ptr)`: Create an `f32` load, with an offset, alignment, and pointer.
    * `f32.store(offset, align, ptr, value)`: Create an `f32` store, with an offset, alignment, pointer, and value.
    * `f32.const(value)`: Create an `f32` constant of a specified value.
    * `f32.const_bits(value)`: Create an `f32` constant of a specified value, reinterpreting the bits (this is useful for creating weird NaNs).
    * `f32.neg(value)`: Create a negation of an `f32`.
    * `f32.abs(value)`: Create a absolute value of an `f32`.
    * `f32.ceil(value)`: Create a ceil of an `f32`.
    * `f32.floor(value)`: Create a floor of an `f32`.
    * `f32.trunc(value)`: Create a truncate of an `f32`.
    * `f32.nearest(value)`: Create a nearest-value of an `f32`.
    * `f32.sqrt(value)`: Create a square-root of an `f32`.
    * `f32.reinterpret(value)`: Create a reinterpret of an `i32` to an `f32`.
    * `f32.convert_s.i32(value)`: Create a signed conversion of an `i32` to an `f32`.
    * `f32.convert_s.i64(value)`: Create a signed conversion of an `i64` to an `f32`.
    * `f32.convert_u.i32(value)`: Create an unsigned conversion of an `i32` to an `f32`.
    * `f32.convert_u.i64(value)`: Create an unsigned conversion of an `i64` to an `f32`.
    * `f32.demote(value)`: Create a demotion of an `f64` to an `f32`.
    * `f32.add(left, right)`: Create an add of two `f32`s.
    * `f32.sub(left, right)`: Create a subtract of two `f32`s.
    * `f32.mul(left, right)`: Create a multiply of two `f32`s.
    * `f32.div(left, right)`: Create a divide of two `f32`s.
    * `f32.copysign(left, right)`: Create a copysign (take magnitude of left, sign of right) of two `f32`s.
    * `f32.min(left, right)`: Create a minimum on two `f32`s.
    * `f32.max(left, right)`: Create a maximum on two `f32`s.
    * `f32.eq(left, right)`: Create an equals on two `f32`s.
    * `f32.ne(left, right)`: Create a not-equals on two `f32`s.
    * `f32.lt(left, right)`: Create a less-than on two `f32`s.
    * `f32.le(left, right)`: Create a less-or-equals on two `f32`s.
    * `f32.gt(left, right)`: Create a greater-than on two `f32`s.
    * `f32.ge(left, right)`: Create a greater-or-equals on two `f32`s.
  * `f64`:
    * `f64.load(offset, align, ptr)`: Create an `f64` load, with an offset, alignment, and pointer.
    * `f64.store(offset, align, ptr, value)`: Create an `f64` store, with an offset, alignment, pointer, and value.
    * `f64.const(value)`: Create an `f64` constant of a specified value.
    * `f64.const_bits(low, high)`: Create an `f64` constant of a specified value, reinterpreting the low and high 32 bits (this is useful for creating weird NaNs).
    * `f64.neg(value)`: Create a negation of an `f64`.
    * `f64.abs(value)`: Create a absolute value of an `f64`.
    * `f64.ceil(value)`: Create a ceil of an `f64`.
    * `f64.floor(value)`: Create a floor of an `f64`.
    * `f64.trunc(value)`: Create a truncate of an `f64`.
    * `f64.nearest(value)`: Create a nearest-value of an `f64`.
    * `f64.sqrt(value)`: Create a square-root of an `f64`.
    * `f64.reinterpret(value)`: Create a reinterpret of an `i32` to an `f64`.
    * `f64.convert_s.i32(value)`: Create a signed conversion of an `i32` to an `f64`.
    * `f64.convert_s.i64(value)`: Create a signed conversion of an `i64` to an `f64`.
    * `f64.convert_u.i32(value)`: Create an unsigned conversion of an `i32` to an `f64`.
    * `f64.convert_u.i64(value)`: Create an unsigned conversion of an `i64` to an `f64`.
    * `f64.promote(value)`: Create a promotion of an `f32` to an `f64`.
    * `f64.add(left, right)`: Create an add of two `f64`s.
    * `f64.sub(left, right)`: Create a subtract of two `f64`s.
    * `f64.mul(left, right)`: Create a multiply of two `f64`s.
    * `f64.div(left, right)`: Create a divide of two `f64`s.
    * `f64.copysign(left, right)`: Create a copysign (take magnitude of left, sign of right) of two `f64`s.
    * `f64.min(left, right)`: Create a minimum on two `f64`s.
    * `f64.max(left, right)`: Create a maximum on two `f64`s.
    * `f64.eq(left, right)`: Create an equals on two `f64`s.
    * `f64.ne(left, right)`: Create a not-equals on two `f64`s.
    * `f64.lt(left, right)`: Create a less-than on two `f64`s.
    * `f64.le(left, right)`: Create a less-or-equals on two `f64`s.
    * `f64.gt(left, right)`: Create a greater-than on two `f64`s.
    * `f64.ge(left, right)`: Create a greater-or-equals on two `f64`s.

Unprefixed expressions:

  * `block(label, children)`: Create a block (a list of instructions), with an optional label, and list of children.
  * `if(condition, ifTrue, ifFalse`: Create an if or if-else, with a condition, code to execute if true, and optional code to execute if false.
  * `loop(label, body)`: Create a loop, with an optional label, and body.
  * `break(label, condition, value)`: Create a break, to a label, and with an optional condition, and optional value.
  * `switch(labels, defaultLabel, condition, value)`: Create a switch (aka br_table), with a list of labels, a default label, a condition, and an optional value.
  * `call(name, operands, type)`: Create a call, to a function name, with operands, and having a specific return type (note that we must specify the return type here as we may not have created the function being called yet, and we may want to optimize this function before we do so, so the API requires that each function be independent of the others, which means that we can't depend on the definition of another function).
  * `call(name, operands, type)`: Similar to `call`, but calls an imported function.
  * `callIndirect(target, operands, type)`: Similar to `call`, but calls indirectly, i.e., via a function pointer, so an expression replaces the name as the called value.
  * `getLocal(index, type)`: Create a get_local, for the local at the specified index, and having a specific type (the type is required for the same reasons as in `call`).
  * `setLocal(index, value)`: Create a set_local, for the local at the specified index, and setting the specified value.
  * `teeLocal(index, value)`: Create a tee_local, for the local at the specified index, and setting the specified value.
  * `select(condition, ifTrue, ifFalse)`: Create a select operation, executing the condition, ifTrue, and ifFalse, and returning one of them based on the condition.
  * `drop(value)`: Create a drop of a value.
  * `return(value)`: Create a return with an optional value.
  * `nop()`: Create a nop (no-operation).
  * `unreachable()`: Create an unreachable (trap).

(now done with `Module`s, returning to the `Binaryen` object)

  * `Binaryen.readBinary(data)`: Reads a binary wasm module and returns a Binaryen `Module` object created from it.
  * `Binaryen.emitText(expression)`: Returns a text representation of an individual expression, in s-expression format. Because Binaryen expression do not depend on their function or module, you can do this at any time.
  * `setAPITracing(on)`: Sets whether API tracing is on. When on, this emits C API commands for everything you do. This can be very useful for filing bug reports.
  * `Binaryen.Relooper()`: Constructor for a Binaryen Relooper instance. This lets you provide an arbitrary CFG, and the Relooper will structure it for WebAssembly.

Relooper instances have the following methods:

  * `addBlock(code)`: Adds a new block to the CFG, containing the provided code (expression) as its body.
  * `addBranch(from, to, condition, code)`: Adds a branch from a block to another block, with a condition (or nothing, if this is the default branch to take from the origin - each block must have one such branch), and optional code to execute on the branch (useful for phis).
  * `addBlockWithSwitch(code, condition)`: Adds a new block, which ends with a switch/br_table, with provided code and condition (that determines where we go in the switch).
  * `addBranchForSwitch(from, to, indexes, code)`: Adds a branch from a block ending in a switch, to another block, using an array of indexes that determine where to go, and optional code to execute on the branch.
  * `renderAndDispose(entry, labelHelper, module)`: Renders and cleans up the Relooper instance. Call this after you have created all the blocks and branches, giving it the entry block (where control flow begins), a label helper variable (an index of a local we can use, necessary for irreducible control flow), and the module. This returns an expression - normal WebAssembly code - that you can use normally anywhere.

