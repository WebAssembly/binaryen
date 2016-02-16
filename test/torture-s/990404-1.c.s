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
	i32.gt_s	$push40=, $0, $pop41
	tee_local	$push39=, $13=, $pop40
	i32.select	$0=, $0, $pop42, $pop39
	i32.const	$push38=, 0
	i32.load	$2=, x+8($pop38):p2align=3
	i32.gt_s	$push37=, $1, $0
	tee_local	$push36=, $12=, $pop37
	i32.select	$0=, $1, $0, $pop36
	i32.const	$push35=, 0
	i32.load	$1=, x+12($pop35)
	i32.gt_s	$push34=, $2, $0
	tee_local	$push33=, $11=, $pop34
	i32.select	$0=, $2, $0, $pop33
	i32.const	$push32=, 0
	i32.load	$2=, x+16($pop32):p2align=4
	i32.gt_s	$push31=, $1, $0
	tee_local	$push30=, $10=, $pop31
	i32.select	$0=, $1, $0, $pop30
	i32.const	$push29=, 0
	i32.load	$1=, x+20($pop29)
	i32.gt_s	$push28=, $2, $0
	tee_local	$push27=, $9=, $pop28
	i32.select	$0=, $2, $0, $pop27
	i32.const	$push26=, 0
	i32.load	$2=, x+24($pop26):p2align=3
	i32.gt_s	$push25=, $1, $0
	tee_local	$push24=, $8=, $pop25
	i32.select	$0=, $1, $0, $pop24
	i32.const	$push23=, 0
	i32.load	$1=, x+28($pop23)
	i32.gt_s	$push22=, $2, $0
	tee_local	$push21=, $7=, $pop22
	i32.select	$0=, $2, $0, $pop21
	i32.const	$push20=, 0
	i32.load	$2=, x+32($pop20):p2align=4
	i32.const	$push19=, 0
	i32.load	$3=, x+36($pop19)
	i32.gt_s	$push18=, $1, $0
	tee_local	$push17=, $6=, $pop18
	i32.select	$0=, $1, $0, $pop17
	i32.gt_s	$push16=, $2, $0
	tee_local	$push15=, $1=, $pop16
	i32.select	$0=, $2, $0, $pop15
	i32.gt_s	$push14=, $3, $0
	tee_local	$push13=, $2=, $pop14
	i32.select	$push9=, $3, $0, $pop13
	i32.const	$push59=, 0
	i32.eq  	$push60=, $pop9, $pop59
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
	i32.select	$push0=, $pop49, $5, $13
	i32.select	$push1=, $pop50, $pop0, $12
	i32.select	$push2=, $pop51, $pop1, $11
	i32.select	$push3=, $pop52, $pop2, $10
	i32.select	$push4=, $pop53, $pop3, $9
	i32.select	$push5=, $pop54, $pop4, $8
	i32.select	$push6=, $pop55, $pop5, $7
	i32.select	$push7=, $pop56, $pop6, $6
	i32.select	$push8=, $pop57, $pop7, $1
	i32.select	$5=, $pop58, $pop8, $2
	i32.const	$push48=, 2
	i32.shl 	$push10=, $5, $pop48
	i32.const	$push47=, 0
	i32.store	$discard=, x($pop10), $pop47
	i32.const	$push46=, 1
	i32.add 	$4=, $4, $pop46
	i32.const	$push45=, 10
	i32.lt_s	$push11=, $4, $pop45
	br_if   	0, $pop11       # 0: up to label1
# BB#3:                                 # %if.then11
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end15
	end_block                       # label0:
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
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
