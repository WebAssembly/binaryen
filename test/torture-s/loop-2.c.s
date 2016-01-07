	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, a
	block   	.LBB0_2
	i32.const	$push5=, 0
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, .LBB0_2
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.const	$push0=, -2
	i32.add 	$push1=, $2, $pop0
	i32.store	$discard=, 0($1), $pop1
	i32.const	$push2=, 1
	i32.add 	$2=, $2, $pop2
	i32.const	$push3=, 4
	i32.add 	$1=, $1, $pop3
	i32.ne  	$push4=, $0, $2
	br_if   	$pop4, .LBB0_1
.LBB0_2:                                  # %for.end
	return  	$2
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, -2
	i32.store	$discard=, a($0), $pop0
	i32.const	$push1=, -1
	i32.store	$discard=, a+4($0), $pop1
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.zero	8
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
