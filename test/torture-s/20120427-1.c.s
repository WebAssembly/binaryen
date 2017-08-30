	.text
	.file	"20120427-1.c"
	.section	.text.sreal_compare,"ax",@progbits
	.hidden	sreal_compare           # -- Begin function sreal_compare
	.globl	sreal_compare
	.type	sreal_compare,@function
sreal_compare:                          # @sreal_compare
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 1
	block   	
	i32.load	$push9=, 4($0)
	tee_local	$push8=, $2=, $pop9
	i32.load	$push7=, 4($1)
	tee_local	$push6=, $3=, $pop7
	i32.gt_s	$push0=, $pop8, $pop6
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$4=, -1
	i32.lt_s	$push1=, $2, $3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end6
	i32.const	$4=, 1
	i32.load	$push13=, 0($0)
	tee_local	$push12=, $0=, $pop13
	i32.load	$push11=, 0($1)
	tee_local	$push10=, $1=, $pop11
	i32.gt_u	$push2=, $pop12, $pop10
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %if.end10
	i32.const	$push5=, -1
	i32.const	$push4=, 0
	i32.lt_u	$push3=, $0, $1
	i32.select	$4=, $pop5, $pop4, $pop3
.LBB0_4:                                # %return
	end_block                       # label0:
	copy_local	$push14=, $4
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end0:
	.size	sreal_compare, .Lfunc_end0-sreal_compare
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %land.lhs.true.1
	block   	
	i32.const	$push0=, 0
	i32.load	$push60=, a+4($pop0)
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 0
	i32.load	$push57=, a+12($pop58)
	tee_local	$push56=, $1=, $pop57
	i32.gt_s	$push1=, $pop59, $pop56
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.end.i.1
	block   	
	i32.lt_s	$push2=, $0, $1
	br_if   	0, $pop2        # 0: down to label2
# BB#2:                                 # %if.end6.i.1
	i32.const	$push3=, 0
	i32.load	$push5=, a($pop3)
	i32.const	$push61=, 0
	i32.load	$push4=, a+8($pop61)
	i32.ge_u	$push6=, $pop5, $pop4
	br_if   	1, $pop6        # 1: down to label1
.LBB1_3:                                # %land.lhs.true.2
	end_block                       # label2:
	i32.const	$push7=, 0
	i32.load	$push66=, a+4($pop7)
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 0
	i32.load	$push63=, a+20($pop64)
	tee_local	$push62=, $1=, $pop63
	i32.gt_s	$push8=, $pop65, $pop62
	br_if   	0, $pop8        # 0: down to label1
# BB#4:                                 # %if.end.i.2
	block   	
	i32.lt_s	$push9=, $0, $1
	br_if   	0, $pop9        # 0: down to label3
# BB#5:                                 # %if.end6.i.2
	i32.const	$push10=, 0
	i32.load	$push12=, a($pop10)
	i32.const	$push67=, 0
	i32.load	$push11=, a+16($pop67)
	i32.ge_u	$push13=, $pop12, $pop11
	br_if   	1, $pop13       # 1: down to label1
.LBB1_6:                                # %land.lhs.true16.190
	end_block                       # label3:
	block   	
	i32.const	$push73=, 0
	i32.load	$push72=, a+12($pop73)
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 0
	i32.load	$push69=, a+4($pop70)
	tee_local	$push68=, $1=, $pop69
	i32.gt_s	$push14=, $pop71, $pop68
	br_if   	0, $pop14       # 0: down to label4
# BB#7:                                 # %if.end.i45.192
	i32.lt_s	$push15=, $0, $1
	br_if   	1, $pop15       # 1: down to label1
# BB#8:                                 # %if.end6.i49.194
	i32.const	$push16=, 0
	i32.load	$push18=, a+8($pop16)
	i32.const	$push74=, 0
	i32.load	$push17=, a($pop74)
	i32.le_u	$push19=, $pop18, $pop17
	br_if   	1, $pop19       # 1: down to label1
.LBB1_9:                                # %land.lhs.true.2.1
	end_block                       # label4:
	i32.const	$push80=, 0
	i32.load	$push79=, a+12($pop80)
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 0
	i32.load	$push76=, a+20($pop77)
	tee_local	$push75=, $1=, $pop76
	i32.gt_s	$push20=, $pop78, $pop75
	br_if   	0, $pop20       # 0: down to label1
# BB#10:                                # %if.end.i.2.1
	block   	
	i32.lt_s	$push21=, $0, $1
	br_if   	0, $pop21       # 0: down to label5
# BB#11:                                # %if.end6.i.2.1
	i32.const	$push22=, 0
	i32.load	$push24=, a+8($pop22)
	i32.const	$push81=, 0
	i32.load	$push23=, a+16($pop81)
	i32.ge_u	$push25=, $pop24, $pop23
	br_if   	1, $pop25       # 1: down to label1
.LBB1_12:                               # %land.lhs.true16.2109
	end_block                       # label5:
	block   	
	i32.const	$push87=, 0
	i32.load	$push86=, a+20($pop87)
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 0
	i32.load	$push83=, a+4($pop84)
	tee_local	$push82=, $1=, $pop83
	i32.gt_s	$push26=, $pop85, $pop82
	br_if   	0, $pop26       # 0: down to label6
# BB#13:                                # %if.end.i45.2111
	i32.lt_s	$push27=, $0, $1
	br_if   	1, $pop27       # 1: down to label1
# BB#14:                                # %if.end6.i49.2113
	i32.const	$push28=, 0
	i32.load	$push30=, a+16($pop28)
	i32.const	$push88=, 0
	i32.load	$push29=, a($pop88)
	i32.le_u	$push31=, $pop30, $pop29
	br_if   	1, $pop31       # 1: down to label1
.LBB1_15:                               # %land.lhs.true16.1.2
	end_block                       # label6:
	block   	
	i32.const	$push94=, 0
	i32.load	$push93=, a+20($pop94)
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 0
	i32.load	$push90=, a+12($pop91)
	tee_local	$push89=, $1=, $pop90
	i32.gt_s	$push32=, $pop92, $pop89
	br_if   	0, $pop32       # 0: down to label7
# BB#16:                                # %if.end.i45.1.2
	i32.lt_s	$push33=, $0, $1
	br_if   	1, $pop33       # 1: down to label1
# BB#17:                                # %if.end6.i49.1.2
	i32.const	$push34=, 0
	i32.load	$push36=, a+16($pop34)
	i32.const	$push95=, 0
	i32.load	$push35=, a+8($pop95)
	i32.le_u	$push37=, $pop36, $pop35
	br_if   	1, $pop37       # 1: down to label1
.LBB1_18:                               # %land.lhs.true16.3
	end_block                       # label7:
	block   	
	i32.const	$push101=, 0
	i32.load	$push100=, a+28($pop101)
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 0
	i32.load	$push97=, a+4($pop98)
	tee_local	$push96=, $1=, $pop97
	i32.gt_s	$push38=, $pop99, $pop96
	br_if   	0, $pop38       # 0: down to label8
# BB#19:                                # %if.end.i45.3
	i32.lt_s	$push39=, $0, $1
	br_if   	1, $pop39       # 1: down to label1
# BB#20:                                # %if.end6.i49.3
	i32.const	$push40=, 0
	i32.load	$push42=, a+24($pop40)
	i32.const	$push102=, 0
	i32.load	$push41=, a($pop102)
	i32.le_u	$push43=, $pop42, $pop41
	br_if   	1, $pop43       # 1: down to label1
.LBB1_21:                               # %land.lhs.true16.1.3
	end_block                       # label8:
	block   	
	i32.const	$push108=, 0
	i32.load	$push107=, a+28($pop108)
	tee_local	$push106=, $0=, $pop107
	i32.const	$push105=, 0
	i32.load	$push104=, a+12($pop105)
	tee_local	$push103=, $1=, $pop104
	i32.gt_s	$push44=, $pop106, $pop103
	br_if   	0, $pop44       # 0: down to label9
# BB#22:                                # %if.end.i45.1.3
	i32.lt_s	$push45=, $0, $1
	br_if   	1, $pop45       # 1: down to label1
# BB#23:                                # %if.end6.i49.1.3
	i32.const	$push46=, 0
	i32.load	$push48=, a+24($pop46)
	i32.const	$push109=, 0
	i32.load	$push47=, a+8($pop109)
	i32.le_u	$push49=, $pop48, $pop47
	br_if   	1, $pop49       # 1: down to label1
.LBB1_24:                               # %land.lhs.true16.2.3
	end_block                       # label9:
	block   	
	i32.const	$push115=, 0
	i32.load	$push114=, a+28($pop115)
	tee_local	$push113=, $0=, $pop114
	i32.const	$push112=, 0
	i32.load	$push111=, a+20($pop112)
	tee_local	$push110=, $1=, $pop111
	i32.gt_s	$push50=, $pop113, $pop110
	br_if   	0, $pop50       # 0: down to label10
# BB#25:                                # %if.end.i45.2.3
	i32.lt_s	$push51=, $0, $1
	br_if   	1, $pop51       # 1: down to label1
# BB#26:                                # %if.end6.i49.2.3
	i32.const	$push52=, 0
	i32.load	$push54=, a+24($pop52)
	i32.const	$push116=, 0
	i32.load	$push53=, a+16($pop116)
	i32.le_u	$push55=, $pop54, $pop53
	br_if   	1, $pop55       # 1: down to label1
.LBB1_27:                               # %for.inc.2.3
	end_block                       # label10:
	i32.const	$push117=, 0
	return  	$pop117
.LBB1_28:                               # %if.then21
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	4
a:
	.skip	8
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	a, 32


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
