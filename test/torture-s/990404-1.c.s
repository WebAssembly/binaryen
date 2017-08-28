	.text
	.file	"990404-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, -1
                                        # implicit-def: %vreg122
.LBB0_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push83=, 0
	i32.load	$push82=, x+36($pop83)
	tee_local	$push81=, $10=, $pop82
	i32.const	$push80=, 0
	i32.load	$push79=, x+32($pop80)
	tee_local	$push78=, $9=, $pop79
	i32.const	$push77=, 0
	i32.load	$push76=, x+28($pop77)
	tee_local	$push75=, $8=, $pop76
	i32.const	$push74=, 0
	i32.load	$push73=, x+24($pop74)
	tee_local	$push72=, $7=, $pop73
	i32.const	$push71=, 0
	i32.load	$push70=, x+20($pop71)
	tee_local	$push69=, $6=, $pop70
	i32.const	$push68=, 0
	i32.load	$push67=, x+16($pop68)
	tee_local	$push66=, $5=, $pop67
	i32.const	$push65=, 0
	i32.load	$push64=, x+12($pop65)
	tee_local	$push63=, $4=, $pop64
	i32.const	$push62=, 0
	i32.load	$push61=, x+8($pop62)
	tee_local	$push60=, $3=, $pop61
	i32.const	$push59=, 0
	i32.load	$push58=, x+4($pop59)
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, 0
	i32.load	$push55=, x($pop56)
	tee_local	$push54=, $0=, $pop55
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.gt_s	$push51=, $0, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.select	$push49=, $pop54, $pop53, $pop50
	tee_local	$push48=, $1=, $pop49
	i32.gt_s	$push47=, $2, $1
	tee_local	$push46=, $2=, $pop47
	i32.select	$push45=, $pop57, $pop48, $pop46
	tee_local	$push44=, $1=, $pop45
	i32.gt_s	$push43=, $3, $1
	tee_local	$push42=, $3=, $pop43
	i32.select	$push41=, $pop60, $pop44, $pop42
	tee_local	$push40=, $1=, $pop41
	i32.gt_s	$push39=, $4, $1
	tee_local	$push38=, $4=, $pop39
	i32.select	$push37=, $pop63, $pop40, $pop38
	tee_local	$push36=, $1=, $pop37
	i32.gt_s	$push35=, $5, $1
	tee_local	$push34=, $5=, $pop35
	i32.select	$push33=, $pop66, $pop36, $pop34
	tee_local	$push32=, $1=, $pop33
	i32.gt_s	$push31=, $6, $1
	tee_local	$push30=, $6=, $pop31
	i32.select	$push29=, $pop69, $pop32, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.gt_s	$push27=, $7, $1
	tee_local	$push26=, $7=, $pop27
	i32.select	$push25=, $pop72, $pop28, $pop26
	tee_local	$push24=, $1=, $pop25
	i32.gt_s	$push23=, $8, $1
	tee_local	$push22=, $8=, $pop23
	i32.select	$push21=, $pop75, $pop24, $pop22
	tee_local	$push20=, $1=, $pop21
	i32.gt_s	$push19=, $9, $1
	tee_local	$push18=, $9=, $pop19
	i32.select	$push17=, $pop78, $pop20, $pop18
	tee_local	$push16=, $1=, $pop17
	i32.gt_s	$push15=, $10, $1
	tee_local	$push14=, $10=, $pop15
	i32.select	$push9=, $pop81, $pop16, $pop14
	i32.eqz 	$push103=, $pop9
	br_if   	1, $pop103      # 1: down to label0
# BB#2:                                 # %if.end7
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push102=, 9
	i32.const	$push101=, 8
	i32.const	$push100=, 7
	i32.const	$push99=, 6
	i32.const	$push98=, 5
	i32.const	$push97=, 4
	i32.const	$push96=, 3
	i32.const	$push95=, 2
	i32.const	$push94=, 1
	i32.const	$push93=, 0
	i32.select	$push0=, $pop93, $12, $0
	i32.select	$push1=, $pop94, $pop0, $2
	i32.select	$push2=, $pop95, $pop1, $3
	i32.select	$push3=, $pop96, $pop2, $4
	i32.select	$push4=, $pop97, $pop3, $5
	i32.select	$push5=, $pop98, $pop4, $6
	i32.select	$push6=, $pop99, $pop5, $7
	i32.select	$push7=, $pop100, $pop6, $8
	i32.select	$push8=, $pop101, $pop7, $9
	i32.select	$push92=, $pop102, $pop8, $10
	tee_local	$push91=, $12=, $pop92
	i32.const	$push90=, 2
	i32.shl 	$push10=, $pop91, $pop90
	i32.const	$push89=, x
	i32.add 	$push11=, $pop10, $pop89
	i32.const	$push88=, 0
	i32.store	0($pop11), $pop88
	i32.const	$push87=, 1
	i32.add 	$push86=, $11, $pop87
	tee_local	$push85=, $11=, $pop86
	i32.const	$push84=, 10
	i32.lt_u	$push12=, $pop85, $pop84
	br_if   	0, $pop12       # 0: up to label1
# BB#3:                                 # %if.then11
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
