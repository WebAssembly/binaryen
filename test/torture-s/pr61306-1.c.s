	.text
	.file	"pr61306-1.c"
	.section	.text.fake_bswap32,"ax",@progbits
	.hidden	fake_bswap32            # -- Begin function fake_bswap32
	.globl	fake_bswap32
	.type	fake_bswap32,@function
fake_bswap32:                           # @fake_bswap32
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 24
	i32.shr_s	$push2=, $0, $pop0
	i32.const	$push14=, 24
	i32.shl 	$push1=, $0, $pop14
	i32.or  	$push3=, $pop2, $pop1
	i32.const	$push4=, 8
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push6=, 16711680
	i32.and 	$push7=, $pop5, $pop6
	i32.or  	$push8=, $pop3, $pop7
	i32.const	$push13=, 8
	i32.shr_u	$push9=, $0, $pop13
	i32.const	$push10=, 65280
	i32.and 	$push11=, $pop9, $pop10
	i32.or  	$push12=, $pop8, $pop11
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	fake_bswap32, .Lfunc_end0-fake_bswap32
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, -2023406815
	i32.call	$push1=, fake_bswap32@FUNCTION, $pop0
	i32.const	$push2=, -121
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
