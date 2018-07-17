// Create a module to work on
var module = new Binaryen.Module();

// Set a memory of initially one page, maximum 100 pages
module.setMemory(1, 100);

// Create a function type for  i32 (i32)  (i.e., return i32, get an i32 param)
var ii = module.addFunctionType('i', Binaryen.i32, [Binaryen.i32]);

var body = module.block(
  null,
  [
    // if the current memory size is too small, grow it
    module.if(
      module.i32.lt_u(
        module.i32.mul(
          module.current_memory(),
          module.i32.const(65536)
        ),
        module.get_local(0, Binaryen.i32)
      ),
      module.drop(
        module.grow_memory(
          module.i32.sub(
            module.i32.div_u(
              module.i32.add(
                module.get_local(0, Binaryen.i32),
                module.i32.const(65535)
              ),
              module.i32.const(65536)
            ),
            module.current_memory()
          )
        )
      )
    ),
    // first, clear memory
    module.set_local(1, module.i32.const(0)),
    module.loop('clear', module.block(null, [
      module.i32.store8(0, 1,
        module.get_local(1, Binaryen.i32),
        module.i32.const(0)
      ),
      module.set_local(1, module.i32.add(
        module.get_local(1, Binaryen.i32),
        module.i32.const(1)
      )),
      module.br_if('clear', module.i32.eq(
        module.get_local(1, Binaryen.i32),
        module.get_local(0, Binaryen.i32)
      ))
    ])),
    // perform the sieve TODO
    // calculate how many primes there are
    module.return(module.get_local(0, Binaryen.i32))
  ],
  Binaryen.none
);

// Create the add function
// Note: no additional local variables (that's the [])
module.addFunction('sieve', ii, [Binaryen.i32], body);

// Export the function, so we can call it later (for simplicity we
// export it as the same name as it has internally)
module.addFunctionExport('sieve', 'sieve');

if (!module.validate()) throw 'did not validate :(';

// Print out the text
console.log(module.emitText());

// Optimize the module! This removes the 'return', since the
// output of the add can just fall through
module.optimize();

// Print out the optimized module's text
console.log('optimized:\n\n' + module.emitText());

