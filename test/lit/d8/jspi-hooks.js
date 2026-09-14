// Engine-level test harness for the jspi-hooks pass. Instantiates the wasm
// given on the command line with a JSPI host and logs the hook events the
// module reports through its "log" import as (event, id, error).
//
// The module is expected to implement the __jspi_enter/exit/suspend/resume
// exports itself (see jspi-hooks.wast) and to export stack_id.

const binary = readbuffer(arguments[0]);
const names = ['ENTER', 'EXIT', 'SUSPEND', 'RESUME'];
const events = [];
const rejectWith = new Error('boom');
let raw;
let exports;

const imports = {
  env: {
    log: (ev, id, error) => {
      events.push(`${names[ev]}#${id}${error ? ' err' : ''} sid=${raw.stack_id()}`);
    },
    susp: new WebAssembly.Suspending(async (x) => {
      if (x === 1) return 10;
      if (x === 2) throw rejectWith;
      return x;
    }),
    // A plain (non-suspending) import that synchronously re-enters a
    // promising export from inside a fiber.
    nested: (x) => {
      events.push(`nested-start sid=${raw.stack_id()}`);
      const p = exports.main(1);
      events.push(`nested-after sid=${raw.stack_id()} promise=${p instanceof Promise}`);
      return 99;
    },
  },
};

async function run(label, fn) {
  events.length = 0;
  let out;
  try {
    out = `result=${await fn()}`;
  } catch (e) {
    const kind = e instanceof WebAssembly.Exception ? 'WebAssembly.Exception' : e?.constructor?.name;
    out = `threw ${kind}${e === rejectWith ? ' (same object)' : ''}${e?.message ? ` "${e.message}"` : ''}`;
  }
  print(`${label}: ${out}`);
  print(`  ${events.join(' | ')}`);
  print(`  sid after: ${raw.stack_id()}`);
}

async function main() {
  const { instance } = await WebAssembly.instantiate(binary, imports);
  raw = instance.exports;
  exports = { main: WebAssembly.promising(raw.main) };

  await run('async success', () => exports.main(1));
  await run('rejected import', () => exports.main(2));
  await run('throwing inner (wasm tag)', () => exports.main(3));
  await run('sync completion, no import', () => exports.main(7));
  await run('nested promising from plain import', () => exports.main(5));
  await run('import via call_indirect', () => exports.main(6));
  await run('plain export calling main internally: no events', () => raw.plain(7));
  await run('suspending import outside any fiber (id 0)', () => raw.plain(4));
  await run('function pointer via dyncall trampoline', () => WebAssembly.promising(raw.__jspi_dyncall_ii)(0, 1));
  await run('concurrent fibers', async () => {
    const a = exports.main(1);
    const b = exports.main(1);
    return (await a) + (await b);
  });
}

main().catch((e) => { print(`harness error: ${e}\n${e.stack}`); });
