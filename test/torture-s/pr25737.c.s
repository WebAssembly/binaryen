	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr25737.c"
	.globl	time_enqueue
	.type	time_enqueue,@function
time_enqueue:                           # @time_enqueue
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	i32.load	$push2=, Timer_Queue($pop1)
	return  	$pop2
func_end0:
	.size	time_enqueue, func_end0-time_enqueue

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store	$push0=, Timer_Queue($0), $0
	return  	$pop0
func_end1:
	.size	main, func_end1-main

	.type	Timer_Queue,@object     # @Timer_Queue
	.lcomm	Timer_Queue,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
