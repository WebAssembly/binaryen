	.text
	.file	"990404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$12=, -1
                                        # implicit-def: %122
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push25=, 0
	i32.load	$0=, x($pop25)
	i32.const	$push24=, 0
	i32.gt_s	$1=, $0, $pop24
	i32.const	$push23=, 0
	i32.select	$0=, $0, $pop23, $1
	i32.const	$push22=, 0
	i32.load	$2=, x+4($pop22)
	i32.gt_s	$3=, $2, $0
	i32.select	$0=, $2, $0, $3
	i32.const	$push21=, 0
	i32.load	$2=, x+8($pop21)
	i32.gt_s	$4=, $2, $0
	i32.select	$0=, $2, $0, $4
	i32.const	$push20=, 0
	i32.load	$2=, x+12($pop20)
	i32.gt_s	$5=, $2, $0
	i32.select	$0=, $2, $0, $5
	i32.const	$push19=, 0
	i32.load	$2=, x+16($pop19)
	i32.gt_s	$6=, $2, $0
	i32.select	$0=, $2, $0, $6
	i32.const	$push18=, 0
	i32.load	$2=, x+20($pop18)
	i32.gt_s	$7=, $2, $0
	i32.select	$0=, $2, $0, $7
	i32.const	$push17=, 0
	i32.load	$2=, x+24($pop17)
	i32.gt_s	$8=, $2, $0
	i32.select	$0=, $2, $0, $8
	i32.const	$push16=, 0
	i32.load	$2=, x+28($pop16)
	i32.gt_s	$9=, $2, $0
	i32.select	$0=, $2, $0, $9
	i32.const	$push15=, 0
	i32.load	$2=, x+32($pop15)
	i32.gt_s	$10=, $2, $0
	i32.select	$0=, $2, $0, $10
	i32.const	$push14=, 0
	i32.load	$2=, x+36($pop14)
	i32.gt_s	$11=, $2, $0
	i32.select	$push9=, $2, $0, $11
	i32.eqz 	$push41=, $pop9
	br_if   	1, $pop41       # 1: down to label0
# %bb.2:                                # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push40=, 9
	i32.const	$push39=, 8
	i32.const	$push38=, 7
	i32.const	$push37=, 6
	i32.const	$push36=, 5
	i32.const	$push35=, 4
	i32.const	$push34=, 3
	i32.const	$push33=, 2
	i32.const	$push32=, 1
	i32.const	$push31=, 0
	i32.select	$push0=, $pop31, $13, $1
	i32.select	$push1=, $pop32, $pop0, $3
	i32.select	$push2=, $pop33, $pop1, $4
	i32.select	$push3=, $pop34, $pop2, $5
	i32.select	$push4=, $pop35, $pop3, $6
	i32.select	$push5=, $pop36, $pop4, $7
	i32.select	$push6=, $pop37, $pop5, $8
	i32.select	$push7=, $pop38, $pop6, $9
	i32.select	$push8=, $pop39, $pop7, $10
	i32.select	$13=, $pop40, $pop8, $11
	i32.const	$push30=, 2
	i32.shl 	$push10=, $13, $pop30
	i32.const	$push29=, x
	i32.add 	$push11=, $pop10, $pop29
	i32.const	$push28=, 0
	i32.store	0($pop11), $pop28
	i32.const	$push27=, 1
	i32.add 	$12=, $12, $pop27
	i32.const	$push26=, 10
	i32.lt_u	$push12=, $12, $pop26
	br_if   	0, $pop12       # 0: up to label1
# %bb.3:                                # %if.then11
	end_loop
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end15
	end_block                       # label0:
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
