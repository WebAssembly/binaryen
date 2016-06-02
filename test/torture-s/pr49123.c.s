	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49123.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load8_u	$push1=, s.0($pop5)
	i32.const	$push2=, 1
	i32.or  	$push3=, $pop1, $pop2
	i32.store8	$drop=, s.0($pop0), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	s.0,@object             # @s.0
	.lcomm	s.0,1,2

	.ident	"clang version 3.9.0 "
