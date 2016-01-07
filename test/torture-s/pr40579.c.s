	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40579.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	call    	foo, $0
	i32.const	$push0=, 1
	call    	foo, $pop0
	i32.const	$push1=, 2
	call    	foo, $pop1
	i32.const	$push2=, 3
	call    	foo, $pop2
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 4
	i32.ge_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
