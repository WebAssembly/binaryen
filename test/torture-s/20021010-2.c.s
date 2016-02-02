	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021010-2.c"
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
	i32.load16_s	$push1=, global_saveRect+2($pop19)
	tee_local	$push18=, $1=, $pop1
	i32.const	$push17=, 0
	i32.load16_s	$push3=, global_bounds+2($pop17)
	tee_local	$push16=, $0=, $pop3
	i32.gt_s	$push6=, $pop18, $pop16
	i32.select	$push7=, $pop6, $0, $1
	i32.const	$push15=, 0
	i32.load16_s	$push0=, global_saveRect($pop15)
	tee_local	$push14=, $1=, $pop0
	i32.const	$push13=, 0
	i32.load16_s	$push2=, global_bounds($pop13)
	tee_local	$push12=, $0=, $pop2
	i32.lt_s	$push4=, $pop14, $pop12
	i32.select	$push5=, $pop4, $0, $1
	i32.sub 	$push8=, $pop7, $pop5
	i32.const	$push11=, 0
	i32.load	$push9=, expectedwidth($pop11)
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, 0       # 0: down to label0
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


	.ident	"clang version 3.9.0 "
