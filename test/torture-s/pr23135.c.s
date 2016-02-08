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
	i32.const	$push17=, 0
	i32.load	$0=, i($pop17):p2align=3
	i32.const	$push110=, 0
	i32.load	$1=, j($pop110):p2align=3
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push1=, j+4($pop108)
	tee_local	$push107=, $17=, $pop1
	i32.const	$push106=, 0
	i32.load	$push0=, i+4($pop106)
	tee_local	$push105=, $16=, $pop0
	i32.add 	$push3=, $pop107, $pop105
	i32.store	$3=, res+4($pop109), $pop3
	block
	i32.const	$push104=, 0
	i32.add 	$push2=, $1, $0
	i32.store	$push18=, res($pop104):p2align=3, $pop2
	tee_local	$push103=, $15=, $pop18
	i32.const	$push19=, 160
	i32.ne  	$push20=, $pop103, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push21=, 113
	i32.ne  	$push22=, $3, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push23=, 0
	i32.mul 	$push4=, $1, $0
	i32.store	$4=, res($pop23):p2align=3, $pop4
	i32.const	$push111=, 0
	i32.mul 	$push5=, $17, $16
	i32.store	$5=, res+4($pop111), $pop5
	block
	i32.const	$push24=, 1500
	i32.ne  	$push25=, $4, $pop24
	br_if   	0, $pop25       # 0: down to label2
# BB#3:                                 # %verify.exit
	i32.const	$push26=, 1300
	i32.ne  	$push27=, $5, $pop26
	br_if   	0, $pop27       # 0: down to label2
# BB#4:                                 # %verify.exit48
	i32.div_s	$2=, $16, $17
	i32.const	$push28=, 0
	i32.div_s	$push6=, $0, $1
	i32.store	$6=, res($pop28):p2align=3, $pop6
	i32.const	$push112=, 0
	i32.store	$discard=, res+4($pop112), $2
	block
	i32.const	$push29=, 15
	i32.ne  	$push30=, $6, $pop29
	br_if   	0, $pop30       # 0: down to label3
# BB#5:                                 # %verify.exit48
	i32.const	$push31=, 7
	i32.ne  	$push32=, $2, $pop31
	br_if   	0, $pop32       # 0: down to label3
# BB#6:                                 # %verify.exit54
	i32.const	$push33=, 0
	i32.and 	$push7=, $1, $0
	i32.store	$7=, res($pop33):p2align=3, $pop7
	i32.const	$push113=, 0
	i32.and 	$push8=, $17, $16
	i32.store	$8=, res+4($pop113), $pop8
	block
	i32.const	$push34=, 2
	i32.ne  	$push35=, $7, $pop34
	br_if   	0, $pop35       # 0: down to label4
# BB#7:                                 # %verify.exit54
	i32.const	$push36=, 4
	i32.ne  	$push37=, $8, $pop36
	br_if   	0, $pop37       # 0: down to label4
# BB#8:                                 # %verify.exit60
	i32.const	$push38=, 0
	i32.or  	$push9=, $1, $0
	i32.store	$9=, res($pop38):p2align=3, $pop9
	i32.const	$push114=, 0
	i32.or  	$push10=, $17, $16
	i32.store	$10=, res+4($pop114), $pop10
	block
	i32.const	$push39=, 158
	i32.ne  	$push40=, $9, $pop39
	br_if   	0, $pop40       # 0: down to label5
# BB#9:                                 # %verify.exit60
	i32.const	$push41=, 109
	i32.ne  	$push42=, $10, $pop41
	br_if   	0, $pop42       # 0: down to label5
# BB#10:                                # %verify.exit66
	i32.const	$push43=, 0
	i32.xor 	$push11=, $0, $1
	i32.store	$1=, res($pop43):p2align=3, $pop11
	i32.const	$push115=, 0
	i32.xor 	$push12=, $16, $17
	i32.store	$17=, res+4($pop115), $pop12
	block
	i32.const	$push44=, 156
	i32.ne  	$push45=, $1, $pop44
	br_if   	0, $pop45       # 0: down to label6
# BB#11:                                # %verify.exit66
	i32.const	$push46=, 105
	i32.ne  	$push47=, $17, $pop46
	br_if   	0, $pop47       # 0: down to label6
# BB#12:                                # %verify.exit72
	i32.const	$push48=, 0
	i32.const	$push118=, 0
	i32.sub 	$push13=, $pop118, $0
	i32.store	$11=, res($pop48):p2align=3, $pop13
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.sub 	$push14=, $pop116, $16
	i32.store	$12=, res+4($pop117), $pop14
	block
	i32.const	$push49=, -150
	i32.ne  	$push50=, $11, $pop49
	br_if   	0, $pop50       # 0: down to label7
# BB#13:                                # %verify.exit72
	i32.const	$push51=, -100
	i32.ne  	$push52=, $12, $pop51
	br_if   	0, $pop52       # 0: down to label7
# BB#14:                                # %verify.exit78
	i32.const	$push54=, 0
	i32.const	$push53=, -1
	i32.xor 	$push15=, $0, $pop53
	i32.store	$13=, res($pop54):p2align=3, $pop15
	i32.const	$push120=, 0
	i32.const	$push119=, -1
	i32.xor 	$push16=, $16, $pop119
	i32.store	$14=, res+4($pop120), $pop16
	block
	i32.const	$push55=, 150
	i32.ne  	$push56=, $0, $pop55
	br_if   	0, $pop56       # 0: down to label8
# BB#15:                                # %verify.exit78
	i32.const	$push57=, -101
	i32.ne  	$push58=, $14, $pop57
	br_if   	0, $pop58       # 0: down to label8
# BB#16:                                # %verify.exit84
	i32.const	$push71=, 0
	i32.add 	$push60=, $4, $15
	i32.add 	$push63=, $pop60, $7
	i32.add 	$push64=, $pop63, $9
	i32.add 	$push67=, $pop64, $1
	i32.sub 	$push68=, $pop67, $0
	i32.add 	$push70=, $pop68, $13
	i32.store	$0=, k($pop71):p2align=3, $pop70
	i32.const	$push123=, 0
	i32.add 	$push61=, $5, $3
	i32.add 	$push62=, $pop61, $8
	i32.add 	$push65=, $pop62, $10
	i32.add 	$push66=, $pop65, $17
	i32.sub 	$push69=, $pop66, $16
	i32.add 	$push59=, $pop69, $14
	i32.store	$16=, k+4($pop123), $pop59
	i32.const	$push122=, 0
	i32.store	$discard=, res($pop122):p2align=3, $0
	i32.const	$push121=, 0
	i32.store	$discard=, res+4($pop121), $16
	block
	i32.const	$push72=, 1675
	i32.ne  	$push73=, $0, $pop72
	br_if   	0, $pop73       # 0: down to label9
# BB#17:                                # %verify.exit84
	i32.const	$push74=, 1430
	i32.ne  	$push75=, $16, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#18:                                # %verify.exit90
	i32.const	$push88=, 0
	i32.mul 	$push77=, $4, $15
	i32.mul 	$push80=, $pop77, $7
	i32.mul 	$push81=, $pop80, $9
	i32.mul 	$push84=, $pop81, $1
	i32.mul 	$push85=, $pop84, $11
	i32.mul 	$push87=, $pop85, $13
	i32.store	$0=, k($pop88):p2align=3, $pop87
	i32.const	$push126=, 0
	i32.mul 	$push78=, $5, $3
	i32.mul 	$push79=, $pop78, $8
	i32.mul 	$push82=, $pop79, $10
	i32.mul 	$push83=, $pop82, $17
	i32.mul 	$push86=, $pop83, $12
	i32.mul 	$push76=, $pop86, $14
	i32.store	$16=, k+4($pop126), $pop76
	i32.const	$push125=, 0
	i32.store	$discard=, res($pop125):p2align=3, $0
	i32.const	$push124=, 0
	i32.store	$discard=, res+4($pop124), $16
	block
	i32.const	$push89=, 1456467968
	i32.ne  	$push90=, $0, $pop89
	br_if   	0, $pop90       # 0: down to label10
# BB#19:                                # %verify.exit90
	i32.const	$push91=, -1579586240
	i32.ne  	$push92=, $16, $pop91
	br_if   	0, $pop92       # 0: down to label10
# BB#20:                                # %verify.exit96
	i32.div_s	$0=, $3, $5
	i32.div_s	$push93=, $15, $4
	i32.div_s	$16=, $pop93, $6
	i32.div_s	$push94=, $0, $2
	i32.div_s	$0=, $pop94, $8
	i32.div_s	$push95=, $16, $7
	i32.div_s	$16=, $pop95, $9
	i32.div_s	$push96=, $0, $10
	i32.div_s	$0=, $pop96, $17
	i32.div_s	$push97=, $16, $1
	i32.div_s	$1=, $pop97, $11
	i32.div_s	$push98=, $0, $12
	i32.div_s	$0=, $pop98, $14
	i32.const	$push130=, 0
	i32.div_s	$push99=, $1, $13
	i32.store	$1=, k($pop130):p2align=3, $pop99
	i32.const	$push129=, 0
	i32.store	$discard=, k+4($pop129), $0
	block
	i32.const	$push128=, 0
	i32.store	$push100=, res($pop128):p2align=3, $1
	i32.const	$push127=, 0
	i32.store	$push101=, res+4($pop127), $0
	i32.or  	$push102=, $pop100, $pop101
	br_if   	0, $pop102      # 0: down to label11
# BB#21:                                # %verify.exit102
	i32.const	$push131=, 0
	call    	exit@FUNCTION, $pop131
	unreachable
.LBB1_22:                               # %if.then.i101
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_23:                               # %if.then.i95
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_24:                               # %if.then.i89
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then.i83
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then.i77
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then.i71
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_28:                               # %if.then.i65
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_29:                               # %if.then.i59
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then.i53
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %if.then.i47
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_32:                               # %if.then.i
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
