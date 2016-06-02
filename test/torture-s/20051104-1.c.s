	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051104-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push1=, .L.str
	i32.store	$drop=, s+4($pop2), $pop1
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.store	$push0=, s($pop4), $pop3
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	8
	.size	s, 8

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.skip	1
	.size	.L.str, 1


	.ident	"clang version 3.9.0 "
