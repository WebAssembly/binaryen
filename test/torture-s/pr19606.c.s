	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19606.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 1
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 5
	i32.rem_u	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load8_s	$0=, a($1)
	block   	.LBB2_4
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push2=, 2147483646
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB2_4
# BB#1:                                 # %if.end
	block   	.LBB2_3
	i32.const	$push4=, 5
	i32.rem_u	$push5=, $0, $pop4
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB2_3
# BB#2:                                 # %if.end7
	call    	exit, $1
	unreachable
.LBB2_3:                                  # %if.then6
	call    	abort
	unreachable
.LBB2_4:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	a,@object               # @a
	.data
	.globl	a
a:
	.int8	252                     # 0xfc
	.size	a, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
