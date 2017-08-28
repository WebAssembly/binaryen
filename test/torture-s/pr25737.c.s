	.text
	.file	"pr25737.c"
	.section	.text.time_enqueue,"ax",@progbits
	.hidden	time_enqueue            # -- Begin function time_enqueue
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function
	.type	Timer_Queue,@object     # @Timer_Queue
	.section	.bss.Timer_Queue,"aw",@nobits
	.p2align	2
Timer_Queue:
	.skip	4
	.size	Timer_Queue, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
