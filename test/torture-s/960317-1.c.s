	.text
	.file	"960317-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push6=, -1
	i32.shl 	$0=, $pop6, $0
	block   	
	i32.const	$push5=, 0
	i32.sub 	$push0=, $pop5, $0
	i32.and 	$push1=, $pop0, $1
	i32.eqz 	$push10=, $pop1
	br_if   	0, $pop10       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push8=, -1
	i32.xor 	$push2=, $0, $pop8
	i32.and 	$push3=, $pop2, $1
	i32.const	$push7=, 0
	i32.ne  	$push4=, $pop3, $pop7
	return  	$pop4
.LBB0_2:                                # %cleanup
	end_block                       # label0:
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
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
