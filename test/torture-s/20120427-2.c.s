	.text
	.file	"20120427-2.c"
	.section	.text.sreal_compare,"ax",@progbits
	.hidden	sreal_compare           # -- Begin function sreal_compare
	.globl	sreal_compare
	.type	sreal_compare,@function
sreal_compare:                          # @sreal_compare
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$3=, 4($1)
	i32.load	$2=, 4($0)
	i32.const	$4=, 1
	block   	
	i32.gt_s	$push0=, $2, $3
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$4=, -1
	i32.lt_s	$push1=, $2, $3
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %if.end6
	i32.load	$3=, 0($1)
	i32.load	$2=, 0($0)
	i32.const	$4=, 1
	i32.gt_u	$push2=, $2, $3
	br_if   	0, $pop2        # 0: down to label0
# %bb.3:                                # %if.end10
	i32.const	$push5=, -1
	i32.const	$push4=, 0
	i32.lt_u	$push3=, $2, $3
	i32.select	$4=, $pop5, $pop4, $pop3
.LBB0_4:                                # %return
	end_block                       # label0:
	copy_local	$push6=, $4
                                        # fallthrough-return: $pop6
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
# %bb.0:                                # %land.lhs.true.1
	i32.const	$push0=, 0
	i32.load	$1=, a+12($pop0)
	i32.const	$push56=, 0
	i32.load	$0=, a+4($pop56)
	block   	
	i32.gt_s	$push1=, $0, $1
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.end.i.1
	block   	
	i32.lt_s	$push2=, $0, $1
	br_if   	0, $pop2        # 0: down to label2
# %bb.2:                                # %if.end6.i.1
	i32.const	$push3=, 0
	i32.load	$push5=, a($pop3)
	i32.const	$push57=, 0
	i32.load	$push4=, a+8($pop57)
	i32.ge_u	$push6=, $pop5, $pop4
	br_if   	1, $pop6        # 1: down to label1
.LBB1_3:                                # %land.lhs.true.2
	end_block                       # label2:
	i32.const	$push7=, 0
	i32.load	$1=, a+20($pop7)
	i32.const	$push58=, 0
	i32.load	$0=, a+4($pop58)
	i32.gt_s	$push8=, $0, $1
	br_if   	0, $pop8        # 0: down to label1
# %bb.4:                                # %if.end.i.2
	block   	
	i32.lt_s	$push9=, $0, $1
	br_if   	0, $pop9        # 0: down to label3
# %bb.5:                                # %if.end6.i.2
	i32.const	$push10=, 0
	i32.load	$push12=, a($pop10)
	i32.const	$push59=, 0
	i32.load	$push11=, a+16($pop59)
	i32.ge_u	$push13=, $pop12, $pop11
	br_if   	1, $pop13       # 1: down to label1
.LBB1_6:                                # %land.lhs.true16.190
	end_block                       # label3:
	i32.const	$push61=, 0
	i32.load	$1=, a+4($pop61)
	i32.const	$push60=, 0
	i32.load	$0=, a+12($pop60)
	block   	
	i32.gt_s	$push14=, $0, $1
	br_if   	0, $pop14       # 0: down to label4
# %bb.7:                                # %if.end.i45.192
	i32.lt_s	$push15=, $0, $1
	br_if   	1, $pop15       # 1: down to label1
# %bb.8:                                # %if.end6.i49.194
	i32.const	$push16=, 0
	i32.load	$push18=, a+8($pop16)
	i32.const	$push62=, 0
	i32.load	$push17=, a($pop62)
	i32.le_u	$push19=, $pop18, $pop17
	br_if   	1, $pop19       # 1: down to label1
.LBB1_9:                                # %land.lhs.true.2.1
	end_block                       # label4:
	i32.const	$push64=, 0
	i32.load	$1=, a+20($pop64)
	i32.const	$push63=, 0
	i32.load	$0=, a+12($pop63)
	i32.gt_s	$push20=, $0, $1
	br_if   	0, $pop20       # 0: down to label1
# %bb.10:                               # %if.end.i.2.1
	block   	
	i32.lt_s	$push21=, $0, $1
	br_if   	0, $pop21       # 0: down to label5
# %bb.11:                               # %if.end6.i.2.1
	i32.const	$push22=, 0
	i32.load	$push24=, a+8($pop22)
	i32.const	$push65=, 0
	i32.load	$push23=, a+16($pop65)
	i32.ge_u	$push25=, $pop24, $pop23
	br_if   	1, $pop25       # 1: down to label1
.LBB1_12:                               # %land.lhs.true16.2109
	end_block                       # label5:
	i32.const	$push67=, 0
	i32.load	$1=, a+4($pop67)
	i32.const	$push66=, 0
	i32.load	$0=, a+20($pop66)
	block   	
	i32.gt_s	$push26=, $0, $1
	br_if   	0, $pop26       # 0: down to label6
# %bb.13:                               # %if.end.i45.2111
	i32.lt_s	$push27=, $0, $1
	br_if   	1, $pop27       # 1: down to label1
# %bb.14:                               # %if.end6.i49.2113
	i32.const	$push28=, 0
	i32.load	$push30=, a+16($pop28)
	i32.const	$push68=, 0
	i32.load	$push29=, a($pop68)
	i32.le_u	$push31=, $pop30, $pop29
	br_if   	1, $pop31       # 1: down to label1
.LBB1_15:                               # %land.lhs.true16.1.2
	end_block                       # label6:
	i32.const	$push70=, 0
	i32.load	$1=, a+12($pop70)
	i32.const	$push69=, 0
	i32.load	$0=, a+20($pop69)
	block   	
	i32.gt_s	$push32=, $0, $1
	br_if   	0, $pop32       # 0: down to label7
# %bb.16:                               # %if.end.i45.1.2
	i32.lt_s	$push33=, $0, $1
	br_if   	1, $pop33       # 1: down to label1
# %bb.17:                               # %if.end6.i49.1.2
	i32.const	$push34=, 0
	i32.load	$push36=, a+16($pop34)
	i32.const	$push71=, 0
	i32.load	$push35=, a+8($pop71)
	i32.le_u	$push37=, $pop36, $pop35
	br_if   	1, $pop37       # 1: down to label1
.LBB1_18:                               # %land.lhs.true16.3
	end_block                       # label7:
	i32.const	$push73=, 0
	i32.load	$1=, a+4($pop73)
	i32.const	$push72=, 0
	i32.load	$0=, a+28($pop72)
	block   	
	i32.gt_s	$push38=, $0, $1
	br_if   	0, $pop38       # 0: down to label8
# %bb.19:                               # %if.end.i45.3
	i32.lt_s	$push39=, $0, $1
	br_if   	1, $pop39       # 1: down to label1
# %bb.20:                               # %if.end6.i49.3
	i32.const	$push40=, 0
	i32.load	$push42=, a+24($pop40)
	i32.const	$push74=, 0
	i32.load	$push41=, a($pop74)
	i32.le_u	$push43=, $pop42, $pop41
	br_if   	1, $pop43       # 1: down to label1
.LBB1_21:                               # %land.lhs.true16.1.3
	end_block                       # label8:
	i32.const	$push76=, 0
	i32.load	$1=, a+12($pop76)
	i32.const	$push75=, 0
	i32.load	$0=, a+28($pop75)
	block   	
	i32.gt_s	$push44=, $0, $1
	br_if   	0, $pop44       # 0: down to label9
# %bb.22:                               # %if.end.i45.1.3
	i32.lt_s	$push45=, $0, $1
	br_if   	1, $pop45       # 1: down to label1
# %bb.23:                               # %if.end6.i49.1.3
	i32.const	$push46=, 0
	i32.load	$push48=, a+24($pop46)
	i32.const	$push77=, 0
	i32.load	$push47=, a+8($pop77)
	i32.le_u	$push49=, $pop48, $pop47
	br_if   	1, $pop49       # 1: down to label1
.LBB1_24:                               # %land.lhs.true16.2.3
	end_block                       # label9:
	i32.const	$push79=, 0
	i32.load	$1=, a+20($pop79)
	i32.const	$push78=, 0
	i32.load	$0=, a+28($pop78)
	block   	
	i32.gt_s	$push50=, $0, $1
	br_if   	0, $pop50       # 0: down to label10
# %bb.25:                               # %if.end.i45.2.3
	i32.lt_s	$push51=, $0, $1
	br_if   	1, $pop51       # 1: down to label1
# %bb.26:                               # %if.end6.i49.2.3
	i32.const	$push52=, 0
	i32.load	$push54=, a+24($pop52)
	i32.const	$push80=, 0
	i32.load	$push53=, a+16($pop80)
	i32.le_u	$push55=, $pop54, $pop53
	br_if   	1, $pop55       # 1: down to label1
.LBB1_27:                               # %for.inc.2.3
	end_block                       # label10:
	i32.const	$push81=, 0
	return  	$pop81
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
