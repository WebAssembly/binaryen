	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23135.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.ne  	$push0=, $0, $2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$0=, i($pop15):p2align=3
	i32.const	$push110=, 0
	i32.load	$1=, j($pop110):p2align=3
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push107=, j+4($pop108)
	tee_local	$push106=, $17=, $pop107
	i32.const	$push105=, 0
	i32.load	$push104=, i+4($pop105)
	tee_local	$push103=, $16=, $pop104
	i32.add 	$push1=, $pop106, $pop103
	i32.store	$3=, res+4($pop109), $pop1
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push102=, 0
	i32.add 	$push0=, $1, $0
	i32.store	$push101=, res($pop102):p2align=3, $pop0
	tee_local	$push100=, $15=, $pop101
	i32.const	$push16=, 160
	i32.ne  	$push17=, $pop100, $pop16
	br_if   	0, $pop17       # 0: down to label11
# BB#1:                                 # %entry
	i32.const	$push18=, 113
	i32.ne  	$push19=, $3, $pop18
	br_if   	0, $pop19       # 0: down to label11
# BB#2:                                 # %verify.exit
	i32.const	$push20=, 0
	i32.mul 	$push2=, $1, $0
	i32.store	$4=, res($pop20):p2align=3, $pop2
	i32.const	$push111=, 0
	i32.mul 	$push3=, $17, $16
	i32.store	$5=, res+4($pop111), $pop3
	i32.const	$push21=, 1500
	i32.ne  	$push22=, $4, $pop21
	br_if   	1, $pop22       # 1: down to label10
# BB#3:                                 # %verify.exit
	i32.const	$push23=, 1300
	i32.ne  	$push24=, $5, $pop23
	br_if   	1, $pop24       # 1: down to label10
# BB#4:                                 # %verify.exit48
	i32.div_s	$2=, $16, $17
	i32.const	$push25=, 0
	i32.div_s	$push4=, $0, $1
	i32.store	$6=, res($pop25):p2align=3, $pop4
	i32.const	$push112=, 0
	i32.store	$discard=, res+4($pop112), $2
	i32.const	$push26=, 15
	i32.ne  	$push27=, $6, $pop26
	br_if   	2, $pop27       # 2: down to label9
# BB#5:                                 # %verify.exit48
	i32.const	$push28=, 7
	i32.ne  	$push29=, $2, $pop28
	br_if   	2, $pop29       # 2: down to label9
# BB#6:                                 # %verify.exit54
	i32.const	$push30=, 0
	i32.and 	$push5=, $1, $0
	i32.store	$7=, res($pop30):p2align=3, $pop5
	i32.const	$push113=, 0
	i32.and 	$push6=, $17, $16
	i32.store	$8=, res+4($pop113), $pop6
	i32.const	$push31=, 2
	i32.ne  	$push32=, $7, $pop31
	br_if   	3, $pop32       # 3: down to label8
# BB#7:                                 # %verify.exit54
	i32.const	$push33=, 4
	i32.ne  	$push34=, $8, $pop33
	br_if   	3, $pop34       # 3: down to label8
# BB#8:                                 # %verify.exit60
	i32.const	$push35=, 0
	i32.or  	$push7=, $1, $0
	i32.store	$9=, res($pop35):p2align=3, $pop7
	i32.const	$push114=, 0
	i32.or  	$push8=, $17, $16
	i32.store	$10=, res+4($pop114), $pop8
	i32.const	$push36=, 158
	i32.ne  	$push37=, $9, $pop36
	br_if   	4, $pop37       # 4: down to label7
# BB#9:                                 # %verify.exit60
	i32.const	$push38=, 109
	i32.ne  	$push39=, $10, $pop38
	br_if   	4, $pop39       # 4: down to label7
# BB#10:                                # %verify.exit66
	i32.const	$push40=, 0
	i32.xor 	$push9=, $0, $1
	i32.store	$1=, res($pop40):p2align=3, $pop9
	i32.const	$push115=, 0
	i32.xor 	$push10=, $16, $17
	i32.store	$17=, res+4($pop115), $pop10
	i32.const	$push41=, 156
	i32.ne  	$push42=, $1, $pop41
	br_if   	5, $pop42       # 5: down to label6
# BB#11:                                # %verify.exit66
	i32.const	$push43=, 105
	i32.ne  	$push44=, $17, $pop43
	br_if   	5, $pop44       # 5: down to label6
# BB#12:                                # %verify.exit72
	i32.const	$push45=, 0
	i32.const	$push118=, 0
	i32.sub 	$push11=, $pop118, $0
	i32.store	$11=, res($pop45):p2align=3, $pop11
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.sub 	$push12=, $pop116, $16
	i32.store	$12=, res+4($pop117), $pop12
	i32.const	$push46=, -150
	i32.ne  	$push47=, $11, $pop46
	br_if   	6, $pop47       # 6: down to label5
# BB#13:                                # %verify.exit72
	i32.const	$push48=, -100
	i32.ne  	$push49=, $12, $pop48
	br_if   	6, $pop49       # 6: down to label5
# BB#14:                                # %verify.exit78
	i32.const	$push51=, 0
	i32.const	$push50=, -1
	i32.xor 	$push13=, $0, $pop50
	i32.store	$13=, res($pop51):p2align=3, $pop13
	i32.const	$push120=, 0
	i32.const	$push119=, -1
	i32.xor 	$push14=, $16, $pop119
	i32.store	$14=, res+4($pop120), $pop14
	i32.const	$push52=, 150
	i32.ne  	$push53=, $0, $pop52
	br_if   	7, $pop53       # 7: down to label4
# BB#15:                                # %verify.exit78
	i32.const	$push54=, -101
	i32.ne  	$push55=, $14, $pop54
	br_if   	7, $pop55       # 7: down to label4
# BB#16:                                # %verify.exit84
	i32.const	$push68=, 0
	i32.add 	$push57=, $4, $15
	i32.add 	$push60=, $pop57, $7
	i32.add 	$push61=, $pop60, $9
	i32.add 	$push64=, $pop61, $1
	i32.sub 	$push65=, $pop64, $0
	i32.add 	$push67=, $pop65, $13
	i32.store	$0=, k($pop68):p2align=3, $pop67
	i32.const	$push123=, 0
	i32.add 	$push58=, $5, $3
	i32.add 	$push59=, $pop58, $8
	i32.add 	$push62=, $pop59, $10
	i32.add 	$push63=, $pop62, $17
	i32.sub 	$push66=, $pop63, $16
	i32.add 	$push56=, $pop66, $14
	i32.store	$16=, k+4($pop123), $pop56
	i32.const	$push122=, 0
	i32.store	$discard=, res($pop122):p2align=3, $0
	i32.const	$push121=, 0
	i32.store	$discard=, res+4($pop121), $16
	i32.const	$push69=, 1675
	i32.ne  	$push70=, $0, $pop69
	br_if   	8, $pop70       # 8: down to label3
# BB#17:                                # %verify.exit84
	i32.const	$push71=, 1430
	i32.ne  	$push72=, $16, $pop71
	br_if   	8, $pop72       # 8: down to label3
# BB#18:                                # %verify.exit90
	i32.const	$push85=, 0
	i32.mul 	$push74=, $4, $15
	i32.mul 	$push77=, $pop74, $7
	i32.mul 	$push78=, $pop77, $9
	i32.mul 	$push81=, $pop78, $1
	i32.mul 	$push82=, $pop81, $11
	i32.mul 	$push84=, $pop82, $13
	i32.store	$0=, k($pop85):p2align=3, $pop84
	i32.const	$push126=, 0
	i32.mul 	$push75=, $5, $3
	i32.mul 	$push76=, $pop75, $8
	i32.mul 	$push79=, $pop76, $10
	i32.mul 	$push80=, $pop79, $17
	i32.mul 	$push83=, $pop80, $12
	i32.mul 	$push73=, $pop83, $14
	i32.store	$16=, k+4($pop126), $pop73
	i32.const	$push125=, 0
	i32.store	$discard=, res($pop125):p2align=3, $0
	i32.const	$push124=, 0
	i32.store	$discard=, res+4($pop124), $16
	i32.const	$push86=, 1456467968
	i32.ne  	$push87=, $0, $pop86
	br_if   	9, $pop87       # 9: down to label2
# BB#19:                                # %verify.exit90
	i32.const	$push88=, -1579586240
	i32.ne  	$push89=, $16, $pop88
	br_if   	9, $pop89       # 9: down to label2
# BB#20:                                # %verify.exit96
	i32.div_s	$0=, $3, $5
	i32.div_s	$push90=, $15, $4
	i32.div_s	$16=, $pop90, $6
	i32.div_s	$push91=, $0, $2
	i32.div_s	$0=, $pop91, $8
	i32.div_s	$push92=, $16, $7
	i32.div_s	$16=, $pop92, $9
	i32.div_s	$push93=, $0, $10
	i32.div_s	$0=, $pop93, $17
	i32.div_s	$push94=, $16, $1
	i32.div_s	$1=, $pop94, $11
	i32.div_s	$push95=, $0, $12
	i32.div_s	$0=, $pop95, $14
	i32.const	$push130=, 0
	i32.div_s	$push96=, $1, $13
	i32.store	$1=, k($pop130):p2align=3, $pop96
	i32.const	$push129=, 0
	i32.store	$discard=, k+4($pop129), $0
	i32.const	$push128=, 0
	i32.store	$push97=, res($pop128):p2align=3, $1
	i32.const	$push127=, 0
	i32.store	$push98=, res+4($pop127), $0
	i32.or  	$push99=, $pop97, $pop98
	br_if   	10, $pop99      # 10: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push131=, 0
	call    	exit@FUNCTION, $pop131
	unreachable
.LBB1_22:                               # %if.then.i
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_23:                               # %if.then.i47
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_24:                               # %if.then.i53
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then.i59
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then.i65
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then.i71
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_28:                               # %if.then.i77
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_29:                               # %if.then.i83
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then.i89
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %if.then.i95
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_32:                               # %if.then.i101
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	3
i:
	.int32	150                     # 0x96
	.int32	100                     # 0x64
	.size	i, 8

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	3
j:
	.int32	10                      # 0xa
	.int32	13                      # 0xd
	.size	j, 8

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.p2align	3
res:
	.skip	8
	.size	res, 8

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	3
k:
	.skip	8
	.size	k, 8


	.ident	"clang version 3.9.0 "
