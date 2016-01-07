	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47237.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.call	$0=, __builtin_apply_args
	i32.const	$push0=, foo
	i32.const	$push1=, 16
	i32.call	$discard=, __builtin_apply, $pop0, $0, $pop1
	i32.const	$push2=, 0
	return  	$pop2
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 5
	i32.ne  	$push1=, $0, $pop0
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
