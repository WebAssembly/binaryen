	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/packed-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, t+2
	i32.const	$push0=, 2
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 0
	i32.store16	$0=, 0($pop2), $pop3
	i32.store16	$push4=, t+2($0), $0
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.align	1
t:
	.skip	6
	.size	t, 6


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
