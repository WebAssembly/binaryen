	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr25737.c"
	.section	.text.time_enqueue,"ax",@progbits
	.hidden	time_enqueue
	.globl	time_enqueue
	.type	time_enqueue,@function
time_enqueue:                           # @time_enqueue
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.store	$push0=, 0($0), $pop1
	i32.load	$push2=, Timer_Queue($pop0)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	time_enqueue, .Lfunc_end0-time_enqueue

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store	$push0=, Timer_Queue($pop1), $pop2
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	Timer_Queue,@object     # @Timer_Queue
	.lcomm	Timer_Queue,4,2

	.ident	"clang version 3.9.0 "
