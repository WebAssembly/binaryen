	.text
	.file	"cvt-1.c"
	.section	.text.g2,"ax",@progbits
	.hidden	g2                      # -- Begin function g2
	.globl	g2
	.type	g2,@function
g2:                                     # @g2
	.param  	f64
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.abs 	$push0=, $0
	f64.const	$push1=, 0x1p31
	f64.lt  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push3=, -2147483648
	return  	$pop3
.LBB0_2:                                # %entry
	end_block                       # label0:
	i32.trunc_s/f64	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	g2, .Lfunc_end0-g2
                                        # -- End function
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	f64
# %bb.0:                                # %if.end
	f64.convert_s/i32	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end6
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
