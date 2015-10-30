function () {
  "use asm";

  var t = global.NaN, u = global.Infinity;

  function big_negative() {
    var temp = 0.0;
    temp = +-2147483648;
    temp = -2147483648.0;
    temp = -21474836480.0;
  }
  function importedDoubles() {
    var temp = 0.0;
    temp = t + u + (-u) + (-t);
  }

  return { big_negative: big_negative };
}

