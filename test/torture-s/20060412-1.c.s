	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060412-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end5
	i32.const	$push3=, t+8
	i32.const	$push2=, 255
	i32.const	$push1=, 324
	i32.call	$drop=, memset@FUNCTION, $pop3, $pop2, $pop1
	i32.const	$push4=, 0
	i32.const	$push5=, 0
	i32.store	$push0=, t+4($pop4), $pop5
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.skip	332
	.size	t, 332


	.ident	"clang version 3.9.0 "
