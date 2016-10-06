	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021010-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push19=, 0
	i32.load16_s	$push18=, global_bounds+2($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.const	$push16=, 0
	i32.load16_s	$push15=, global_saveRect+2($pop16)
	tee_local	$push14=, $1=, $pop15
	i32.gt_s	$push2=, $1, $0
	i32.select	$push3=, $pop17, $pop14, $pop2
	i32.const	$push13=, 0
	i32.load16_s	$push12=, global_bounds($pop13)
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, 0
	i32.load16_s	$push9=, global_saveRect($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.lt_s	$push0=, $1, $0
	i32.select	$push1=, $pop11, $pop8, $pop0
	i32.sub 	$push4=, $pop3, $pop1
	i32.const	$push7=, 0
	i32.load	$push5=, expectedwidth($pop7)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %if.end26
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
.LBB0_2:                                # %if.then25
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
