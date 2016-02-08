	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, -1
                                        # implicit-def: %vreg64
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push44=, 0
	i32.load	$0=, x($pop44):p2align=4
	i32.const	$push43=, 0
	i32.load	$1=, x+4($pop43)
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.gt_s	$push0=, $0, $pop41
	tee_local	$push40=, $13=, $pop0
	i32.select	$0=, $0, $pop42, $pop40
	i32.const	$push39=, 0
	i32.load	$2=, x+8($pop39):p2align=3
	i32.gt_s	$push2=, $1, $0
	tee_local	$push38=, $12=, $pop2
	i32.select	$0=, $1, $0, $pop38
	i32.const	$push37=, 0
	i32.load	$1=, x+12($pop37)
	i32.gt_s	$push4=, $2, $0
	tee_local	$push36=, $11=, $pop4
	i32.select	$0=, $2, $0, $pop36
	i32.const	$push35=, 0
	i32.load	$2=, x+16($pop35):p2align=4
	i32.gt_s	$push6=, $1, $0
	tee_local	$push34=, $10=, $pop6
	i32.select	$0=, $1, $0, $pop34
	i32.const	$push33=, 0
	i32.load	$1=, x+20($pop33)
	i32.gt_s	$push8=, $2, $0
	tee_local	$push32=, $9=, $pop8
	i32.select	$0=, $2, $0, $pop32
	i32.const	$push31=, 0
	i32.load	$2=, x+24($pop31):p2align=3
	i32.gt_s	$push10=, $1, $0
	tee_local	$push30=, $8=, $pop10
	i32.select	$0=, $1, $0, $pop30
	i32.const	$push29=, 0
	i32.load	$1=, x+28($pop29)
	i32.gt_s	$push12=, $2, $0
	tee_local	$push28=, $7=, $pop12
	i32.select	$0=, $2, $0, $pop28
	i32.const	$push27=, 0
	i32.load	$2=, x+32($pop27):p2align=4
	i32.const	$push26=, 0
	i32.load	$3=, x+36($pop26)
	i32.gt_s	$push14=, $1, $0
	tee_local	$push25=, $6=, $pop14
	i32.select	$0=, $1, $0, $pop25
	i32.gt_s	$push16=, $2, $0
	tee_local	$push24=, $1=, $pop16
	i32.select	$0=, $2, $0, $pop24
	i32.gt_s	$push18=, $3, $0
	tee_local	$push23=, $2=, $pop18
	i32.select	$push19=, $3, $0, $pop23
	i32.const	$push59=, 0
	i32.eq  	$push60=, $pop19, $pop59
	br_if   	2, $pop60       # 2: down to label0
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push58=, 9
	i32.const	$push57=, 8
	i32.const	$push56=, 7
	i32.const	$push55=, 6
	i32.const	$push54=, 5
	i32.const	$push53=, 4
	i32.const	$push52=, 3
	i32.const	$push51=, 2
	i32.const	$push50=, 1
	i32.const	$push49=, 0
	i32.select	$push1=, $pop49, $5, $13
	i32.select	$push3=, $pop50, $pop1, $12
	i32.select	$push5=, $pop51, $pop3, $11
	i32.select	$push7=, $pop52, $pop5, $10
	i32.select	$push9=, $pop53, $pop7, $9
	i32.select	$push11=, $pop54, $pop9, $8
	i32.select	$push13=, $pop55, $pop11, $7
	i32.select	$push15=, $pop56, $pop13, $6
	i32.select	$push17=, $pop57, $pop15, $1
	i32.select	$5=, $pop58, $pop17, $2
	i32.const	$push48=, 2
	i32.shl 	$push20=, $5, $pop48
	i32.const	$push47=, 0
	i32.store	$discard=, x($pop20), $pop47
	i32.const	$push46=, 1
	i32.add 	$4=, $4, $pop46
	i32.const	$push45=, 10
	i32.lt_s	$push21=, $4, $pop45
	br_if   	0, $pop21       # 0: up to label1
# BB#3:                                 # %if.then11
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end15
	end_block                       # label0:
	i32.const	$push22=, 0
	call    	exit@FUNCTION, $pop22
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 3.9.0 "
