function asm(global, env, buffer) {
  "use asm";

  function missing(x, y) {
    x = x | 0;
    y = +y;
  }

  function extra(x, y) {
    x = x | 0;
    y = +y;
  }

  function mix(a) {
    a = a | 0;
  }

  function ex() {
    missing();
    missing(1);
    extra(1, +2, 3);
    extra(1, +2, 3, 4);
    mix();
    mix(1);
    mix(1, 2);
  }

  return { ex: ex };
}

