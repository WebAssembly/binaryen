function test() {
  // Create a module to work on
  var module = new Binaryen.Module();

  // Set a memory of initially one page, maximum 100 pages
  module.setMemory(1, 100);

  var body = module.block(
    null,
    [
      // if the current memory size is too small, grow it
      module.if(
        module.i32.lt_u(
          module.i32.mul(
            module.memory.size(),
            module.i32.const(65536)
          ),
          module.local.get(0, Binaryen.i32)
        ),
        module.drop(
          module.memory.grow(
            module.i32.sub(
              module.i32.div_u(
                module.i32.add(
                  module.local.get(0, Binaryen.i32),
                  module.i32.const(65535)
                ),
                module.i32.const(65536)
              ),
              module.memory.size()
            )
          )
        )
      ),
      // first, clear memory
      module.local.set(1, module.i32.const(0)),
      module.loop('clear', module.block(null, [
        module.i32.store8(0, 1,
          module.local.get(1, Binaryen.i32),
          module.i32.const(0)
        ),
        module.local.set(1, module.i32.add(
          module.local.get(1, Binaryen.i32),
          module.i32.const(1)
        )),
        module.br_if('clear', module.i32.eq(
          module.local.get(1, Binaryen.i32),
          module.local.get(0, Binaryen.i32)
        ))
      ])),
      // perform the sieve TODO
      // calculate how many primes there are
      module.return(module.local.get(0, Binaryen.i32))
    ],
    Binaryen.none
  );

  // Create the add function
  // Note: no additional local variables (that's the [])
  module.addFunction('sieve', Binaryen.i32, Binaryen.i32, [Binaryen.i32], body);

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
}

Binaryen.ready.then(test);
