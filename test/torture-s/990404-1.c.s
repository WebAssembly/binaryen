	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, -1
                                        # implicit-def: %vreg119
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i32.const	$push82=, 0
	i32.load	$push81=, x+36($pop82)
	tee_local	$push80=, $10=, $pop81
	i32.const	$push79=, 0
	i32.load	$push78=, x+32($pop79)
	tee_local	$push77=, $9=, $pop78
	i32.const	$push76=, 0
	i32.load	$push75=, x+28($pop76)
	tee_local	$push74=, $8=, $pop75
	i32.const	$push73=, 0
	i32.load	$push72=, x+24($pop73)
	tee_local	$push71=, $7=, $pop72
	i32.const	$push70=, 0
	i32.load	$push69=, x+20($pop70)
	tee_local	$push68=, $6=, $pop69
	i32.const	$push67=, 0
	i32.load	$push66=, x+16($pop67)
	tee_local	$push65=, $5=, $pop66
	i32.const	$push64=, 0
	i32.load	$push63=, x+12($pop64)
	tee_local	$push62=, $4=, $pop63
	i32.const	$push61=, 0
	i32.load	$push60=, x+8($pop61)
	tee_local	$push59=, $3=, $pop60
	i32.const	$push58=, 0
	i32.load	$push57=, x+4($pop58)
	tee_local	$push56=, $2=, $pop57
	i32.const	$push55=, 0
	i32.load	$push54=, x($pop55)
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.gt_s	$push50=, $0, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.select	$push48=, $pop53, $pop52, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.gt_s	$push46=, $2, $0
	tee_local	$push45=, $0=, $pop46
	i32.select	$push44=, $pop56, $pop47, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.gt_s	$push42=, $3, $2
	tee_local	$push41=, $2=, $pop42
	i32.select	$push40=, $pop59, $pop43, $pop41
	tee_local	$push39=, $3=, $pop40
	i32.gt_s	$push38=, $4, $3
	tee_local	$push37=, $3=, $pop38
	i32.select	$push36=, $pop62, $pop39, $pop37
	tee_local	$push35=, $4=, $pop36
	i32.gt_s	$push34=, $5, $4
	tee_local	$push33=, $4=, $pop34
	i32.select	$push32=, $pop65, $pop35, $pop33
	tee_local	$push31=, $5=, $pop32
	i32.gt_s	$push30=, $6, $5
	tee_local	$push29=, $5=, $pop30
	i32.select	$push28=, $pop68, $pop31, $pop29
	tee_local	$push27=, $6=, $pop28
	i32.gt_s	$push26=, $7, $6
	tee_local	$push25=, $6=, $pop26
	i32.select	$push24=, $pop71, $pop27, $pop25
	tee_local	$push23=, $7=, $pop24
	i32.gt_s	$push22=, $8, $7
	tee_local	$push21=, $7=, $pop22
	i32.select	$push20=, $pop74, $pop23, $pop21
	tee_local	$push19=, $8=, $pop20
	i32.gt_s	$push18=, $9, $8
	tee_local	$push17=, $8=, $pop18
	i32.select	$push16=, $pop77, $pop19, $pop17
	tee_local	$push15=, $9=, $pop16
	i32.gt_s	$push14=, $10, $9
	tee_local	$push13=, $10=, $pop14
	i32.select	$push9=, $pop80, $pop15, $pop13
	i32.eqz 	$push101=, $pop9
	br_if   	2, $pop101      # 2: down to label0
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push100=, 9
	i32.const	$push99=, 8
	i32.const	$push98=, 7
	i32.const	$push97=, 6
	i32.const	$push96=, 5
	i32.const	$push95=, 4
	i32.const	$push94=, 3
	i32.const	$push93=, 2
	i32.const	$push92=, 1
	i32.const	$push91=, 0
	i32.select	$push0=, $pop91, $12, $1
	i32.select	$push1=, $pop92, $pop0, $0
	i32.select	$push2=, $pop93, $pop1, $2
	i32.select	$push3=, $pop94, $pop2, $3
	i32.select	$push4=, $pop95, $pop3, $4
	i32.select	$push5=, $pop96, $pop4, $5
	i32.select	$push6=, $pop97, $pop5, $6
	i32.select	$push7=, $pop98, $pop6, $7
	i32.select	$push8=, $pop99, $pop7, $8
	i32.select	$push90=, $pop100, $pop8, $10
	tee_local	$push89=, $12=, $pop90
	i32.const	$push88=, 2
	i32.shl 	$push10=, $pop89, $pop88
	i32.const	$push87=, 0
	i32.store	$drop=, x($pop10), $pop87
	i32.const	$push86=, 1
	i32.add 	$push85=, $11, $pop86
	tee_local	$push84=, $11=, $pop85
	i32.const	$push83=, 10
	i32.lt_s	$push11=, $pop84, $pop83
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
	.functype	abort, void
	.functype	exit, void, i32
