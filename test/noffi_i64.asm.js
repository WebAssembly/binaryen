function(global, env, buffer) {
  "use asm";
  var importll=env._importll;

  function add(a,b) {
      a = i64(a);
      b = i64(b);
      var c = i64();
      c = i64_add(b,a);
      return (i64(c));
  }
  function main() {
      (i64(importll(i64_const(2,0))));
      return 0;
  }

  return {
      _add: add,
      _main: main };
}
;
