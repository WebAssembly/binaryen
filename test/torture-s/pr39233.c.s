	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39233.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_3
	i32.const	$push0=, 0
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 7
	i32.ge_s	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %if.end
	return
.LBB0_3:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	call    	foo, $pop0
	i32.const	$push1=, 5
	call    	foo, $pop1
	i32.const	$push2=, 4
	call    	foo, $pop2
	i32.const	$push3=, 3
	call    	foo, $pop3
	i32.const	$push4=, 2
	call    	foo, $pop4
	i32.const	$push5=, 1
	call    	foo, $pop5
	i32.const	$0=, 0
	call    	foo, $0
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
