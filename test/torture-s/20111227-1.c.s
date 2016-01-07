	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111227-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, -1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load16_u	$0=, 0($0)
	block   	.LBB1_3
	block   	.LBB1_2
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.then
	call    	bar, $0
	br      	.LBB1_3
.LBB1_2:                                  # %if.else
	i32.const	$1=, 16
	i32.shl 	$push1=, $0, $1
	i32.shr_s	$push0=, $pop1, $1
	call    	bar, $pop0
.LBB1_3:                                  # %if.end
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, v
	call    	foo, $pop0, $0
	return  	$0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	v,@object               # @v
	.data
	.globl	v
	.align	1
v:
	.int16	65535                   # 0xffff
	.size	v, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
