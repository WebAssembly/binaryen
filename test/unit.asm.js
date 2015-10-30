function () {
  "use asm";

  var t = global.NaN, u = global.Infinity;

  function big_negative() {
    var temp = 0.0;
    temp = +-2147483648;
    temp = -2147483648.0;
    temp = -21474836480.0;
    temp = 0.039625;
    temp = -0.039625;
  }
  function importedDoubles() {
    var temp = 0.0;
    temp = t + u + (-u) + (-t);
  }

  function z() {
  }
  function w() {
  }

  var FUNCTION_TABLE_a = [ z, big_negative, z, z ];
  var FUNCTION_TABLE_b = [ w, w, importedDoubles, w ];

  return { big_negative: big_negative };
}

