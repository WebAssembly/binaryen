	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020328-1.c"
	.section	.text.func,"ax",@progbits
	.hidden	func
	.globl	func
	.type	func,@function
func:                                   # @func
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end0:
	.size	func, .Lfunc_end0-func

	.section	.text.testit,"ax",@progbits
	.hidden	testit
	.globl	testit
	.type	testit,@function
testit:                                 # @testit
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 20
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	testit, .Lfunc_end1-testit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
