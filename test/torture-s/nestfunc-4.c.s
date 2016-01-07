	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/nestfunc-4.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %if.then
	i32.const	$0=, 0
	i32.load	$1=, level($0)
	i32.const	$2=, 499
	i32.gt_s	$push0=, $1, $2
	i32.select	$push1=, $pop0, $1, $2
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, level($0), $pop3
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, level($0)
	i32.const	$2=, 499
	i32.gt_s	$push0=, $1, $2
	i32.select	$push1=, $pop0, $1, $2
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$discard=, level($0), $pop3
	i32.const	$push4=, -42
	return  	$pop4
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, level($pop0)
	i32.const	$1=, -42
	block   	.LBB2_2
	i32.const	$push1=, 499
	i32.gt_s	$push2=, $0, $pop1
	br_if   	$pop2, .LBB2_2
# BB#1:                                 # %cond.false
	i32.call	$1=, foo
.LBB2_2:                                  # %cond.end
	i32.sub 	$push3=, $1, $0
	return  	$pop3
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.type	level,@object           # @level
	.bss
	.globl	level
	.align	2
level:
	.int32	0                       # 0x0
	.size	level, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
