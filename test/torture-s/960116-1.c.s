	.text
	.file	"960116-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 1
	i32.and 	$push0=, $0, $pop3
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %land.lhs.true
	i32.load	$push1=, 0($0)
	i32.eqz 	$push5=, $pop1
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %return
	i32.const	$push4=, 1
	return  	$pop4
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
