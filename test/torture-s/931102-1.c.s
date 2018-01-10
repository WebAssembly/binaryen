	.text
	.file	"931102-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	block   	
	i32.const	$push3=, 1
	i32.and 	$push1=, $0, $pop3
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %while.body.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push6=, 2
	i32.and 	$1=, $0, $pop6
	i32.const	$push5=, 24
	i32.shl 	$push2=, $0, $pop5
	i32.const	$push4=, 25
	i32.shr_s	$push0=, $pop2, $pop4
	copy_local	$0=, $pop0
	i32.eqz 	$push8=, $1
	br_if   	0, $pop8        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
	copy_local	$push9=, $2
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
