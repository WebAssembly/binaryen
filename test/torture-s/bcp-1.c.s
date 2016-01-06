	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/bcp-1.c"
	.globl	bad0
	.type	bad0,@function
bad0:                                   # @bad0
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end0:
	.size	bad0, func_end0-bad0

	.globl	bad1
	.type	bad1,@function
bad1:                                   # @bad1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	bad1, func_end1-bad1

	.globl	bad2
	.type	bad2,@function
bad2:                                   # @bad2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	bad2, func_end2-bad2

	.globl	bad3
	.type	bad3,@function
bad3:                                   # @bad3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end3:
	.size	bad3, func_end3-bad3

	.globl	bad4
	.type	bad4,@function
bad4:                                   # @bad4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end4:
	.size	bad4, func_end4-bad4

	.globl	bad5
	.type	bad5,@function
bad5:                                   # @bad5
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end5:
	.size	bad5, func_end5-bad5

	.globl	bad6
	.type	bad6,@function
bad6:                                   # @bad6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end6:
	.size	bad6, func_end6-bad6

	.globl	bad7
	.type	bad7,@function
bad7:                                   # @bad7
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end7:
	.size	bad7, func_end7-bad7

	.globl	bad8
	.type	bad8,@function
bad8:                                   # @bad8
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end8:
	.size	bad8, func_end8-bad8

	.globl	bad9
	.type	bad9,@function
bad9:                                   # @bad9
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end9:
	.size	bad9, func_end9-bad9

	.globl	bad10
	.type	bad10,@function
bad10:                                  # @bad10
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end10:
	.size	bad10, func_end10-bad10

	.globl	good0
	.type	good0,@function
good0:                                  # @good0
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end11:
	.size	good0, func_end11-good0

	.globl	good1
	.type	good1,@function
good1:                                  # @good1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end12:
	.size	good1, func_end12-good1

	.globl	good2
	.type	good2,@function
good2:                                  # @good2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end13:
	.size	good2, func_end13-good2

	.globl	opt0
	.type	opt0,@function
opt0:                                   # @opt0
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end14:
	.size	opt0, func_end14-opt0

	.globl	opt1
	.type	opt1,@function
opt1:                                   # @opt1
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end15:
	.size	opt1, func_end15-opt1

	.globl	opt2
	.type	opt2,@function
opt2:                                   # @opt2
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end16:
	.size	opt2, func_end16-opt2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB17_22
	i32.load	$push0=, bad_t0($0)
	i32.call_indirect	$push1=, $pop0
	br_if   	$pop1, BB17_22
# BB#1:                                 # %for.cond
	i32.load	$push2=, bad_t0+4($0)
	i32.call_indirect	$push3=, $pop2
	br_if   	$pop3, BB17_22
# BB#2:                                 # %for.cond.1
	i32.load	$push4=, bad_t0+8($0)
	i32.call_indirect	$push5=, $pop4
	br_if   	$pop5, BB17_22
# BB#3:                                 # %for.cond.2
	i32.load	$push6=, bad_t0+12($0)
	i32.call_indirect	$push7=, $pop6
	br_if   	$pop7, BB17_22
# BB#4:                                 # %for.cond.3
	i32.load	$push8=, bad_t0+16($0)
	i32.call_indirect	$push9=, $pop8
	br_if   	$pop9, BB17_22
# BB#5:                                 # %for.cond.4
	i32.load	$push10=, bad_t0+20($0)
	i32.call_indirect	$push11=, $pop10
	br_if   	$pop11, BB17_22
# BB#6:                                 # %for.cond.5
	i32.load	$1=, bad_t1($0)
	i32.const	$2=, 1
	block   	BB17_21
	i32.call_indirect	$push12=, $1, $2
	br_if   	$pop12, BB17_21
# BB#7:                                 # %for.cond1
	i32.load	$push13=, bad_t1+4($0)
	i32.call_indirect	$push14=, $pop13, $2
	br_if   	$pop14, BB17_21
# BB#8:                                 # %for.cond1.1
	i32.load	$push15=, bad_t1+8($0)
	i32.call_indirect	$push16=, $pop15, $2
	br_if   	$pop16, BB17_21
# BB#9:                                 # %for.cond1.2
	i32.load	$1=, bad_t2($0)
	i32.const	$2=, .str
	block   	BB17_20
	i32.call_indirect	$push17=, $1, $2
	br_if   	$pop17, BB17_20
# BB#10:                                # %for.cond12
	i32.load	$push18=, bad_t2+4($0)
	i32.call_indirect	$push19=, $pop18, $2
	br_if   	$pop19, BB17_20
# BB#11:                                # %for.cond12.1
	block   	BB17_19
	i32.load	$push20=, good_t0($0)
	i32.call_indirect	$push21=, $pop20
	i32.const	$push32=, 0
	i32.eq  	$push33=, $pop21, $pop32
	br_if   	$pop33, BB17_19
# BB#12:                                # %for.cond23
	i32.load	$push22=, good_t0+4($0)
	i32.call_indirect	$push23=, $pop22
	i32.const	$push34=, 0
	i32.eq  	$push35=, $pop23, $pop34
	br_if   	$pop35, BB17_19
# BB#13:                                # %for.cond23.1
	i32.load	$push24=, good_t0+8($0)
	i32.call_indirect	$push25=, $pop24
	i32.const	$push36=, 0
	i32.eq  	$push37=, $pop25, $pop36
	br_if   	$pop37, BB17_19
# BB#14:                                # %for.cond23.2
	block   	BB17_18
	i32.load	$push26=, opt_t0($0)
	i32.call_indirect	$push27=, $pop26
	i32.const	$push38=, 0
	i32.eq  	$push39=, $pop27, $pop38
	br_if   	$pop39, BB17_18
# BB#15:                                # %for.cond34
	i32.load	$push28=, opt_t0+4($0)
	i32.call_indirect	$push29=, $pop28
	i32.const	$push40=, 0
	i32.eq  	$push41=, $pop29, $pop40
	br_if   	$pop41, BB17_18
# BB#16:                                # %for.cond34.1
	i32.load	$push30=, opt_t0+8($0)
	i32.call_indirect	$push31=, $pop30
	i32.const	$push42=, 0
	i32.eq  	$push43=, $pop31, $pop42
	br_if   	$pop43, BB17_18
# BB#17:                                # %for.cond34.2
	call    	exit, $0
	unreachable
BB17_18:                                # %if.then40
	call    	abort
	unreachable
BB17_19:                                # %if.then29
	call    	abort
	unreachable
BB17_20:                                # %if.then18
	call    	abort
	unreachable
BB17_21:                                # %if.then7
	call    	abort
	unreachable
BB17_22:                                # %if.then
	call    	abort
	unreachable
func_end17:
	.size	main, func_end17-main

	.type	bad_t0,@object          # @bad_t0
	.data
	.globl	bad_t0
	.align	4
bad_t0:
	.int32	bad0
	.int32	bad1
	.int32	bad5
	.int32	bad7
	.int32	bad8
	.int32	bad10
	.size	bad_t0, 24

	.type	bad_t1,@object          # @bad_t1
	.globl	bad_t1
	.align	2
bad_t1:
	.int32	bad2
	.int32	bad3
	.int32	bad6
	.size	bad_t1, 12

	.type	bad_t2,@object          # @bad_t2
	.globl	bad_t2
	.align	2
bad_t2:
	.int32	bad4
	.int32	bad9
	.size	bad_t2, 8

	.type	good_t0,@object         # @good_t0
	.globl	good_t0
	.align	2
good_t0:
	.int32	good0
	.int32	good1
	.int32	good2
	.size	good_t0, 12

	.type	opt_t0,@object          # @opt_t0
	.globl	opt_t0
	.align	2
opt_t0:
	.int32	opt0
	.int32	opt1
	.int32	opt2
	.size	opt_t0, 12

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"hi"
	.size	.str, 3

	.type	global,@object          # @global
	.bss
	.globl	global
	.align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
