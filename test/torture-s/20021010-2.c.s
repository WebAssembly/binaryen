	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021010-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_s	$1=, global_saveRect($0)
	i32.load16_s	$3=, global_bounds($0)
	i32.load16_s	$2=, global_saveRect+2($0)
	i32.load16_s	$4=, global_bounds+2($0)
	block   	.LBB0_2
	i32.gt_s	$push2=, $2, $4
	i32.select	$push3=, $pop2, $4, $2
	i32.lt_s	$push0=, $1, $3
	i32.select	$push1=, $pop0, $3, $1
	i32.sub 	$push4=, $pop3, $pop1
	i32.load	$push5=, expectedwidth($0)
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB0_2
# BB#1:                                 # %if.end26
	call    	exit, $0
	unreachable
.LBB0_2:                                  # %if.then25
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	expectedwidth,@object   # @expectedwidth
	.data
	.globl	expectedwidth
	.align	2
expectedwidth:
	.int32	50                      # 0x32
	.size	expectedwidth, 4

	.type	global_vramPtr,@object  # @global_vramPtr
	.globl	global_vramPtr
	.align	2
global_vramPtr:
	.int32	40960
	.size	global_vramPtr, 4

	.type	global_bounds,@object   # @global_bounds
	.globl	global_bounds
	.align	1
global_bounds:
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.int16	100                     # 0x64
	.int16	150                     # 0x96
	.size	global_bounds, 8

	.type	global_saveRect,@object # @global_saveRect
	.globl	global_saveRect
	.align	1
global_saveRect:
	.int16	75                      # 0x4b
	.int16	175                     # 0xaf
	.int16	75                      # 0x4b
	.int16	175                     # 0xaf
	.size	global_saveRect, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
