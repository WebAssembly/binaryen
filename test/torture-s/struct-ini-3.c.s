	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ini-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	result                  # @result
	.type	result,@object
	.section	.data.result,"aw",@progbits
	.globl	result
	.p2align	2
result:
	.int8	255                     # 0xff
	.int8	15                      # 0xf
	.skip	2
	.size	result, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
