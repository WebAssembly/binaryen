function () {
  "use asm";
  function big_negative() {
    var temp = 0.0;
    temp = +-2147483648;
    temp = -2147483648.0;
    temp = -21474836480.0;
  }
  return { big_negative: big_negative };
}

