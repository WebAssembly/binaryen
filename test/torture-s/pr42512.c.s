	.text
	.file	"pr42512.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load16_u	$2=, g_3($pop0)
	i32.const	$1=, -1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push8=, 255
	i32.add 	$push1=, $1, $pop8
	i32.const	$push7=, 255
	i32.and 	$0=, $pop1, $pop7
	i32.const	$push6=, 65535
	i32.and 	$push2=, $2, $pop6
	i32.or  	$2=, $1, $pop2
	copy_local	$1=, $0
	br_if   	0, $0           # 0: up to label0
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push10=, 0
	i32.store16	g_3($pop10), $2
	block   	
	i32.const	$push3=, 65535
	i32.and 	$push4=, $2, $pop3
	i32.const	$push9=, 65535
	i32.ne  	$push5=, $pop4, $pop9
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	g_3                     # @g_3
	.type	g_3,@object
	.section	.bss.g_3,"aw",@nobits
	.globl	g_3
	.p2align	1
g_3:
	.int16	0                       # 0x0
	.size	g_3, 2


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
