	.text
	.file	"20021010-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push11=, 0
	i32.load16_s	$0=, global_bounds($pop11)
	i32.const	$push10=, 0
	i32.load16_s	$1=, global_saveRect($pop10)
	i32.const	$push9=, 0
	i32.load16_s	$2=, global_bounds+2($pop9)
	i32.const	$push8=, 0
	i32.load16_s	$3=, global_saveRect+2($pop8)
	block   	
	i32.gt_s	$push2=, $3, $2
	i32.select	$push3=, $2, $3, $pop2
	i32.lt_s	$push0=, $1, $0
	i32.select	$push1=, $0, $1, $pop0
	i32.sub 	$push4=, $pop3, $pop1
	i32.const	$push7=, 0
	i32.load	$push5=, expectedwidth($pop7)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end26
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB0_2:                                # %if.then25
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	expectedwidth           # @expectedwidth
	.type	expectedwidth,@object
	.section	.data.expectedwidth,"aw",@progbits
	.globl	expectedwidth
	.p2align	2
expectedwidth:
	.int32	50                      # 0x32
	.size	expectedwidth, 4

	.hidden	global_vramPtr          # @global_vramPtr
	.type	global_vramPtr,@object
	.section	.data.global_vramPtr,"aw",@progbits
	.globl	global_vramPtr
	.p2align	2
global_vramPtr:
	.int32	40960
	.size	global_vramPtr, 4

	.hidden	global_bounds           # @global_bounds
	.type	global_bounds,@object
	.section	.data.global_bounds,"aw",@progbits
	.globl	global_bounds
	.p2align	1
global_bounds:
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.size	global_bounds, 8

	.hidden	global_saveRect         # @global_saveRect
	.type	global_saveRect,@object
	.section	.data.global_saveRect,"aw",@progbits
	.globl	global_saveRect
	.p2align	1
global_saveRect:
	.int16	75                      # 0x4b
	.int16	175                     # 0xaf
	.int16	75                      # 0x4b
	.int16	175                     # 0xaf
	.size	global_saveRect, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
