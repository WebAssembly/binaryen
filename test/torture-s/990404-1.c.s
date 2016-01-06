	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/990404-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$13=, -1
                                        # implicit-def: %vreg66
BB0_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	BB0_4
	loop    	BB0_3
	i32.const	$0=, 0
	i32.load	$1=, x($0)
	i32.load	$3=, x+4($0)
	i32.gt_s	$2=, $1, $0
	i32.select	$1=, $2, $1, $0
	i32.load	$5=, x+8($0)
	i32.gt_s	$4=, $3, $1
	i32.select	$1=, $4, $3, $1
	i32.load	$3=, x+12($0)
	i32.gt_s	$6=, $5, $1
	i32.select	$1=, $6, $5, $1
	i32.load	$5=, x+16($0)
	i32.gt_s	$7=, $3, $1
	i32.select	$1=, $7, $3, $1
	i32.load	$3=, x+20($0)
	i32.gt_s	$8=, $5, $1
	i32.select	$1=, $8, $5, $1
	i32.load	$5=, x+24($0)
	i32.gt_s	$9=, $3, $1
	i32.select	$1=, $9, $3, $1
	i32.load	$3=, x+28($0)
	i32.gt_s	$10=, $5, $1
	i32.select	$1=, $10, $5, $1
	i32.load	$5=, x+32($0)
	i32.gt_s	$11=, $3, $1
	i32.load	$12=, x+36($0)
	i32.select	$1=, $11, $3, $1
	i32.gt_s	$3=, $5, $1
	i32.select	$1=, $3, $5, $1
	i32.gt_s	$5=, $12, $1
	i32.select	$push16=, $5, $12, $1
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop16, $pop22
	br_if   	$pop23, BB0_4
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$1=, 1
	i32.const	$12=, 2
	i32.const	$push15=, 9
	i32.const	$push13=, 8
	i32.const	$push11=, 7
	i32.const	$push9=, 6
	i32.const	$push7=, 5
	i32.const	$push5=, 4
	i32.const	$push3=, 3
	i32.select	$push0=, $2, $0, $14
	i32.select	$push1=, $4, $1, $pop0
	i32.select	$push2=, $6, $12, $pop1
	i32.select	$push4=, $7, $pop3, $pop2
	i32.select	$push6=, $8, $pop5, $pop4
	i32.select	$push8=, $9, $pop7, $pop6
	i32.select	$push10=, $10, $pop9, $pop8
	i32.select	$push12=, $11, $pop11, $pop10
	i32.select	$push14=, $3, $pop13, $pop12
	i32.select	$14=, $5, $pop15, $pop14
	i32.const	$push18=, x
	i32.shl 	$push17=, $14, $12
	i32.add 	$push19=, $pop18, $pop17
	i32.store	$discard=, 0($pop19), $0
	i32.add 	$13=, $13, $1
	i32.const	$push20=, 10
	i32.lt_s	$push21=, $13, $pop20
	br_if   	$pop21, BB0_1
BB0_3:                                  # %if.then11
	call    	abort
	unreachable
BB0_4:                                  # %for.end15
	call    	exit, $0
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	x,@object               # @x
	.data
	.globl	x
	.align	4
x:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.size	x, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
