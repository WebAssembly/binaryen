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
	i32.const	$0=, -1
                                        # implicit-def: %vreg64
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push82=, 0
	i32.load	$push36=, x+36($pop82)
	tee_local	$push81=, $13=, $pop36
	i32.const	$push80=, 0
	i32.load	$push32=, x+32($pop80):p2align=4
	tee_local	$push79=, $12=, $pop32
	i32.const	$push78=, 0
	i32.load	$push28=, x+28($pop78)
	tee_local	$push77=, $11=, $pop28
	i32.const	$push76=, 0
	i32.load	$push24=, x+24($pop76):p2align=3
	tee_local	$push75=, $10=, $pop24
	i32.const	$push74=, 0
	i32.load	$push20=, x+20($pop74)
	tee_local	$push73=, $9=, $pop20
	i32.const	$push72=, 0
	i32.load	$push16=, x+16($pop72):p2align=4
	tee_local	$push71=, $8=, $pop16
	i32.const	$push70=, 0
	i32.load	$push12=, x+12($pop70)
	tee_local	$push69=, $7=, $pop12
	i32.const	$push68=, 0
	i32.load	$push8=, x+8($pop68):p2align=3
	tee_local	$push67=, $6=, $pop8
	i32.const	$push66=, 0
	i32.load	$push4=, x+4($pop66)
	tee_local	$push65=, $5=, $pop4
	i32.const	$push64=, 0
	i32.load	$push0=, x($pop64):p2align=4
	tee_local	$push63=, $4=, $pop0
	i32.const	$push62=, 0
	i32.gt_s	$push1=, $pop63, $pop62
	tee_local	$push61=, $3=, $pop1
	i32.const	$push60=, 0
	i32.select	$push3=, $pop61, $4, $pop60
	tee_local	$push59=, $4=, $pop3
	i32.gt_s	$push5=, $pop65, $pop59
	tee_local	$push58=, $2=, $pop5
	i32.select	$push7=, $pop58, $5, $4
	tee_local	$push57=, $5=, $pop7
	i32.gt_s	$push9=, $pop67, $pop57
	tee_local	$push56=, $4=, $pop9
	i32.select	$push11=, $pop56, $6, $5
	tee_local	$push55=, $6=, $pop11
	i32.gt_s	$push13=, $pop69, $pop55
	tee_local	$push54=, $5=, $pop13
	i32.select	$push15=, $pop54, $7, $6
	tee_local	$push53=, $7=, $pop15
	i32.gt_s	$push17=, $pop71, $pop53
	tee_local	$push52=, $6=, $pop17
	i32.select	$push19=, $pop52, $8, $7
	tee_local	$push51=, $8=, $pop19
	i32.gt_s	$push21=, $pop73, $pop51
	tee_local	$push50=, $7=, $pop21
	i32.select	$push23=, $pop50, $9, $8
	tee_local	$push49=, $9=, $pop23
	i32.gt_s	$push25=, $pop75, $pop49
	tee_local	$push48=, $8=, $pop25
	i32.select	$push27=, $pop48, $10, $9
	tee_local	$push47=, $10=, $pop27
	i32.gt_s	$push29=, $pop77, $pop47
	tee_local	$push46=, $9=, $pop29
	i32.select	$push31=, $pop46, $11, $10
	tee_local	$push45=, $11=, $pop31
	i32.gt_s	$push33=, $pop79, $pop45
	tee_local	$push44=, $10=, $pop33
	i32.select	$push35=, $pop44, $12, $11
	tee_local	$push43=, $12=, $pop35
	i32.gt_s	$push37=, $pop81, $pop43
	tee_local	$push42=, $11=, $pop37
	i32.select	$push38=, $pop42, $13, $12
	i32.const	$push97=, 0
	i32.eq  	$push98=, $pop38, $pop97
	br_if   	$pop98, 2       # 2: down to label0
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push96=, 9
	i32.const	$push95=, 8
	i32.const	$push94=, 7
	i32.const	$push93=, 6
	i32.const	$push92=, 5
	i32.const	$push91=, 4
	i32.const	$push90=, 3
	i32.const	$push89=, 2
	i32.const	$push88=, 1
	i32.const	$push87=, 0
	i32.select	$push2=, $3, $pop87, $1
	i32.select	$push6=, $2, $pop88, $pop2
	i32.select	$push10=, $4, $pop89, $pop6
	i32.select	$push14=, $5, $pop90, $pop10
	i32.select	$push18=, $6, $pop91, $pop14
	i32.select	$push22=, $7, $pop92, $pop18
	i32.select	$push26=, $8, $pop93, $pop22
	i32.select	$push30=, $9, $pop94, $pop26
	i32.select	$push34=, $10, $pop95, $pop30
	i32.select	$1=, $11, $pop96, $pop34
	i32.const	$push86=, 2
	i32.shl 	$push39=, $1, $pop86
	i32.const	$push85=, 0
	i32.store	$discard=, x($pop39), $pop85
	i32.const	$push84=, 1
	i32.add 	$0=, $0, $pop84
	i32.const	$push83=, 10
	i32.lt_s	$push40=, $0, $pop83
	br_if   	$pop40, 0       # 0: up to label1
# BB#3:                                 # %if.then11
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end15
	end_block                       # label0:
	i32.const	$push41=, 0
	call    	exit@FUNCTION, $pop41
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
