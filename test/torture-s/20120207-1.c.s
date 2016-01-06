	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120207-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .str
	i32.add 	$push1=, $pop0, $0
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.load8_s	$push4=, 0($pop3)
	return  	$pop4
func_end0:
	.size	test, func_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push0=, 2
	i32.call	$push1=, test, $pop0
	i32.const	$push2=, 255
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 49
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.16,"aMS",@progbits,1
	.align	4
.str:
	.asciz	"0123456789"
	.size	.str, 11


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
