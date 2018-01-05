	.text
	.file	"pr23047.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 31
	i32.shr_s	$1=, $0, $pop0
	block   	
	i32.add 	$push1=, $0, $1
	i32.xor 	$push2=, $pop1, $1
	i32.const	$push3=, -1
	i32.gt_s	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.then
	return
.LBB0_2:                                # %if.end
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -2147483648
	call    	f@FUNCTION, $pop0
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
