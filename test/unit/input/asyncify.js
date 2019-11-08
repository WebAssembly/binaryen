
function assert(x, y) {
  if (!x) throw (y || 'assertion failed') + '\n' + new Error().stack;
}

var fs = require('fs');

function sleepTests() {
  console.log('\nsleep tests\n\n');

  // Get and compile the wasm.

  var binary = fs.readFileSync('a.wasm');

  var module = new WebAssembly.Module(binary);

  var DATA_ADDR = 4;

  var sleeps = 0;

  var sleeping = false;

  var instance = new WebAssembly.Instance(module, {
    env: {
      sleep: function() {
        logMemory();
        if (!sleeping) {
          // We are called in order to start a sleep/unwind.
          console.log('sleep...');
          sleeps++;
          sleeping = true;
          // Unwinding.
          // Fill in the data structure. The first value has the stack location,
          // which for simplicity we can start right after the data structure itself.
          view[DATA_ADDR >> 2] = DATA_ADDR + 8;
          // The end of the stack will not be reached here anyhow.
          view[DATA_ADDR + 4 >> 2] = 1024;
          exports.asyncify_start_unwind(DATA_ADDR);
        } else {
          // We are called as part of a resume/rewind. Stop sleeping.
          console.log('resume...');
          exports.asyncify_stop_rewind();
          // The stack should have been all used up, and so returned to the original state.
          assert(view[DATA_ADDR >> 2] == DATA_ADDR + 8);
          assert(view[DATA_ADDR + 4 >> 2] == 1024);
          sleeping = false;
        }
        logMemory();
      },
      tunnel: function(x) {
        console.log('tunneling, sleep == ' + sleeping);
        return exports.end_tunnel(x);
      }
    }
  });

  var exports = instance.exports;
  var view = new Int32Array(exports.memory.buffer);

  function logMemory() {
    // Log the relevant memory locations for debugging purposes.
    console.log('memory: ', view[0 >> 2], view[4 >> 2], view[8 >> 2], view[12 >> 2], view[16 >> 2], view[20 >> 2], view[24 >> 2]);
  }

  function runTest(name, expectedSleeps, expectedResult, params) {
    params = params || [];

    console.log('\n==== testing ' + name + ' ====');

    sleeps = 0;

    logMemory();

    // Run until the sleep.
    var result = exports[name].apply(null, params);
    logMemory();

    if (expectedSleeps > 0) {
      assert(!result, 'results during sleep are meaningless, just 0');
      exports.asyncify_stop_unwind();

      for (var i = 0; i < expectedSleeps - 1; i++) {
        console.log('rewind, run until the next sleep');
        exports.asyncify_start_rewind(DATA_ADDR);
        result = exports[name](); // no need for params on later times
        assert(!result, 'results during sleep are meaningless, just 0');
        logMemory();
        exports.asyncify_stop_unwind();
      }

      console.log('rewind and run til the end.');
      exports.asyncify_start_rewind(DATA_ADDR);
      result = exports[name]();
    }

    console.log('final result: ' + result);
    assert(result == expectedResult, 'bad final result');
    logMemory();

    assert(sleeps == expectedSleeps, 'expectedSleeps');
  }

  //================
  // Tests
  //================

  // A minimal single sleep.
  runTest('minimal', 1, 21);

  // Two sleeps.
  runTest('repeat', 2, 42);

  // A value in a local is preserved across a sleep.
  runTest('local', 1, 10);

  // A local with more operations done on it.
  runTest('local2', 1, 22);

  // A local with more operations done on it.
  runTest('params', 1, 18);
  runTest('params', 1, 21, [1, 2]);

  // Calls to multiple other functions, only one of whom
  // sleeps, and keep locals and globals valid throughout.
  runTest('deeper', 0, 27, [0]);
  runTest('deeper', 1,  3, [1]);

  // A recursive factorial, that sleeps on each iteration
  // above 1.
  runTest('factorial-recursive', 0,   1, [1]);
  runTest('factorial-recursive', 1,   2, [2]);
  runTest('factorial-recursive', 2,   6, [3]);
  runTest('factorial-recursive', 3,  24, [4]);
  runTest('factorial-recursive', 4, 120, [5]);

  // A looping factorial, that sleeps on each iteration
  // above 1.
  runTest('factorial-loop', 0,   1, [1]);
  runTest('factorial-loop', 1,   2, [2]);
  runTest('factorial-loop', 2,   6, [3]);
  runTest('factorial-loop', 3,  24, [4]);
  runTest('factorial-loop', 4, 120, [5]);

  // Test calling into JS in the middle (which can work if
  // the JS just forwards the call and has no side effects or
  // state of its own that needs to be saved).
  runTest('do_tunnel', 2, 72, [1]);

  // Test indirect function calls.
  runTest('call_indirect', 3, 432, [1, 2]);

  // Test indirect function calls.
  runTest('if_else', 3, 1460, [1, 1000]);
  runTest('if_else', 3, 2520, [2, 2000]);
}

function coroutineTests() {
  console.log('\ncoroutine tests\n\n');

  // Get and compile the wasm.

  var binary = fs.readFileSync('b.wasm');

  var module = new WebAssembly.Module(binary);

  // Create a coroutine, for a specific export to
  // call, and whose unwind/rewind data is in
  // a specific range.
  function Coroutine(name, dataStart, dataEnd) {
    this.name = name;
    this.start = function() {
      exports[name]();
    };
    this.startUnwind = function() {
      // Initialize the data.
      view[dataStart >> 2] = dataStart + 8;
      view[dataStart + 4 >> 2] = dataEnd;
      exports.asyncify_start_unwind(dataStart);
      // (With C etc. coroutines we would also have
      // a C stack to pause and resume here.)
    };
    this.stopUnwind = function() {
      exports.asyncify_stop_unwind();
    };
    this.startRewind = function() {
      exports.asyncify_start_rewind(dataStart);
      exports[name]();
    };
    this.stopRewind = function() {
      exports.asyncify_stop_rewind();
    };
  }

  var Runtime = {
    coroutines: [
      new Coroutine('linear',      1000, 2000),
      new Coroutine('exponential', 2000, 3000),
      new Coroutine('weird',       3000, 4000)
    ],
    active: null,
    rewinding: false,
    run: function(iters) {
      Runtime.coroutines.forEach(function(coroutine) {
        console.log('starting ' + coroutine.name);
        Runtime.active = coroutine;
        coroutine.start();
        coroutine.stopUnwind();
        Runtime.active = null;
      });
      for (var i = 0; i < iters; i++) {
        Runtime.coroutines.forEach(function(coroutine) {
          console.log('resuming ' + coroutine.name);
          Runtime.active = coroutine;
          Runtime.rewinding = true;
          coroutine.startRewind();
          Runtime.active = null;
        });
      }
    },
    values: [],
    yield: function(value) {
      console.log('yield reached', Runtime.rewinding, value); 
      var coroutine = Runtime.active;
      if (Runtime.rewinding) {
        coroutine.stopRewind();
        Runtime.rewinding = false;
      } else {
        Runtime.values.push(value);
        coroutine.startUnwind();
        console.log('pausing ' + coroutine.name);
      }
    },
  };

  var instance = new WebAssembly.Instance(module, {
    env: {
      yield: Runtime.yield
    }
  });

  var exports = instance.exports;
  var view = new Int32Array(exports.memory.buffer);

  Runtime.run(4);
  console.log(Runtime.values);
  assert(JSON.stringify(Runtime.values) === JSON.stringify([
     0,  1,    42,
    10,  2,  1337,
    20,  4,     0,
    30,  8, -1000,
    40, 16,    42
  ]), 'check yielded values')
}

function stackOverflowAssertTests() {
  console.log('\nstack overflow assertion tests\n\n');

  // Get and compile the wasm.

  var binary = fs.readFileSync('c.wasm');

  var module = new WebAssembly.Module(binary);

  var DATA_ADDR = 4;

  var instance = new WebAssembly.Instance(module, {
    env: {
      sleep: function() {
        console.log('sleep...');
        exports.asyncify_start_unwind(DATA_ADDR);
        view[DATA_ADDR >> 2] = DATA_ADDR + 8;
        // The end of the stack will be reached as the stack is tiny.
        view[DATA_ADDR + 4 >> 2] = view[DATA_ADDR >> 2] + 1;
      }
    }
  });

  var exports = instance.exports;
  var view = new Int32Array(exports.memory.buffer);
  exports.many_locals();
  assert(view[DATA_ADDR >> 2] > view[DATA_ADDR + 4 >> 2], 'should have wrote past the end of the stack');
  // All API calls should now fail, since we wrote past the end of the
  // stack
  var fails = 0;
  ['asyncify_stop_unwind', 'asyncify_start_rewind', 'asyncify_stop_rewind', 'asyncify_start_unwind'].forEach(function(name) {
    try {
      exports[name](DATA_ADDR);
      console.log('no fail on', name);
    } catch (e) {
      console.log('expected fail on', name);
      fails++;
    }
  });
  assert(fails == 4, 'all 4 should have failed');
}

// Main

sleepTests();
coroutineTests();
stackOverflowAssertTests();

console.log('\ntests completed successfully');

