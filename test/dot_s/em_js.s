  .text
  .file "/tmp/tmpkxUaTH/a.out.bc"
  .globl  main
  .type main,@function
main:                                   # @main
  .result   i32
# BB#0:
  i32.const $push0=, 15
  i32.call      $push1=, foo@FUNCTION, $pop0
  return    $pop1
  .endfunc
.Lfunc_end0:
  .size main, .Lfunc_end0-main

  .globl  __em_js__foo
  .type __em_js__foo,@function
__em_js__foo:                                   # @__em_js__foo
  .result   i32
# BB#0:
  i32.const $push1=, .str
  .endfunc
.Lfunc_end0:
  .size __em_js__foo, .Lfunc_end0-__em_js__foo

  .type .str,@object            # @.str
  .data
.str:
  .asciz  "(int x)<::>{ Module.print(\"got x=\" + x); }"
  .size .str, 43

  .functype foo, i32, i32
