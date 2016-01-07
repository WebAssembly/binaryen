	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060412-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %while.body.preheader
	i32.const	$0=, t+328
.LBB0_1:                                  # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, -1
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, -4
	i32.add 	$0=, $0, $pop1
	i32.const	$push2=, t+4
	i32.gt_u	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_1
.LBB0_2:                                  # %if.end5
	i32.const	$0=, 0
	i32.store	$push4=, t+4($0), $0
	return  	$pop4
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	t,@object               # @t
	.bss
	.globl	t
	.align	2
t:
	.zero	332
	.size	t, 332


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
