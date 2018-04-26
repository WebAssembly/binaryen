	.text
	.file	"960321-1.c"
	.section	.text.acc_a,"ax",@progbits
	.hidden	acc_a                   # -- Begin function acc_a
	.globl	acc_a
	.type	acc_a,@function
acc_a:                                  # @acc_a
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, a-2000000000
	i32.add 	$push1=, $0, $pop0
	i32.load8_s	$push2=, 0($pop1)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	acc_a, .Lfunc_end0-acc_a
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load8_u	$push0=, a($pop3)
	i32.const	$push1=, 100
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.asciz	"deadbeef\000"
	.size	a, 10


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
