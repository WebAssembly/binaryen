	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/compare-3.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.globl	all_tests
	.type	all_tests,@function
all_tests:                              # @all_tests
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end6:
	.size	all_tests, .Lfunc_end6-all_tests

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end7:
	.size	main, .Lfunc_end7-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
