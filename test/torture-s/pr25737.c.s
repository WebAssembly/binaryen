	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr25737.c"
	.section	.text.time_enqueue,"ax",@progbits
	.hidden	time_enqueue
	.globl	time_enqueue
	.type	time_enqueue,@function
time_enqueue:                           # @time_enqueue
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.const	$push2=, 0
	i32.load	$push1=, Timer_Queue($pop2)
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	Timer_Queue($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	Timer_Queue,@object     # @Timer_Queue
	.section	.bss.Timer_Queue,"aw",@nobits
	.p2align	2
Timer_Queue:
	.skip	4
	.size	Timer_Queue, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
