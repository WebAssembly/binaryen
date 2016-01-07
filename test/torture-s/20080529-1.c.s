	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080529-1.c"
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	f32.const	$push0=, 0x0p0
	f32.eq  	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
