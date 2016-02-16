	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-1.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.ne  	$push0=, $0, $4
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	0, $pop2        # 0: down to label0
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %if.end
	return
.LBB0_5:                                # %if.then
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push125=, 0
	i32.load	$push124=, j+12($pop125)
	tee_local	$push123=, $12=, $pop124
	i32.const	$push122=, 0
	i32.load	$push121=, i+12($pop122)
	tee_local	$push120=, $11=, $pop121
	i32.add 	$push2=, $pop123, $pop120
	i32.store	$4=, k+12($pop3), $pop2
	i32.const	$push119=, 0
	i32.load	$1=, i+4($pop119)
	i32.const	$push118=, 0
	i32.load	$0=, i($pop118):p2align=4
	i32.const	$push117=, 0
	i32.load	$3=, j+4($pop117)
	i32.const	$push116=, 0
	i32.load	$2=, j($pop116):p2align=4
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.load	$push113=, j+8($pop114):p2align=3
	tee_local	$push112=, $10=, $pop113
	i32.const	$push111=, 0
	i32.load	$push110=, i+8($pop111):p2align=3
	tee_local	$push109=, $9=, $pop110
	i32.add 	$push1=, $pop112, $pop109
	i32.store	$5=, k+8($pop115):p2align=3, $pop1
	i32.const	$push108=, 0
	i32.add 	$push0=, $3, $1
	i32.store	$6=, k+4($pop108), $pop0
	i32.const	$push107=, 0
	i32.add 	$push4=, $2, $0
	i32.store	$7=, k($pop107):p2align=4, $pop4
	i32.const	$push106=, 0
	i32.store	$8=, res+12($pop106), $4
	i32.const	$push105=, 0
	i32.store	$discard=, res+8($pop105):p2align=3, $5
	i32.const	$push104=, 0
	i32.store	$4=, res+4($pop104), $6
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push103=, 0
	i32.store	$push5=, res($pop103):p2align=4, $7
	i32.const	$push6=, 160
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label8
# BB#1:                                 # %entry
	i32.const	$push8=, 113
	i32.ne  	$push9=, $4, $pop8
	br_if   	0, $pop9        # 0: down to label8
# BB#2:                                 # %entry
	i32.const	$push10=, 170
	i32.ne  	$push11=, $5, $pop10
	br_if   	0, $pop11       # 0: down to label8
# BB#3:                                 # %entry
	i32.const	$push12=, 230
	i32.ne  	$push13=, $8, $pop12
	br_if   	0, $pop13       # 0: down to label8
# BB#4:                                 # %verify.exit
	i32.const	$push18=, 0
	i32.mul 	$push17=, $2, $0
	i32.store	$4=, k($pop18):p2align=4, $pop17
	i32.const	$push132=, 0
	i32.mul 	$push14=, $3, $1
	i32.store	$5=, k+4($pop132), $pop14
	i32.const	$push131=, 0
	i32.mul 	$push15=, $10, $9
	i32.store	$6=, k+8($pop131):p2align=3, $pop15
	i32.const	$push130=, 0
	i32.mul 	$push16=, $12, $11
	i32.store	$7=, k+12($pop130), $pop16
	i32.const	$push129=, 0
	i32.store	$discard=, res($pop129):p2align=4, $4
	i32.const	$push128=, 0
	i32.store	$discard=, res+4($pop128), $5
	i32.const	$push127=, 0
	i32.store	$discard=, res+8($pop127):p2align=3, $6
	i32.const	$push126=, 0
	i32.store	$discard=, res+12($pop126), $7
	i32.const	$push19=, 1500
	i32.ne  	$push20=, $4, $pop19
	br_if   	1, $pop20       # 1: down to label7
# BB#5:                                 # %verify.exit
	i32.const	$push21=, 1300
	i32.ne  	$push22=, $5, $pop21
	br_if   	1, $pop22       # 1: down to label7
# BB#6:                                 # %verify.exit
	i32.const	$push23=, 3000
	i32.ne  	$push24=, $6, $pop23
	br_if   	1, $pop24       # 1: down to label7
# BB#7:                                 # %verify.exit
	i32.const	$push25=, 6000
	i32.ne  	$push26=, $7, $pop25
	br_if   	1, $pop26       # 1: down to label7
# BB#8:                                 # %verify.exit9
	i32.div_s	$4=, $11, $12
	i32.div_s	$5=, $9, $10
	i32.div_s	$6=, $1, $3
	i32.const	$push28=, 0
	i32.div_s	$push27=, $0, $2
	i32.store	$7=, k($pop28):p2align=4, $pop27
	i32.const	$push139=, 0
	i32.store	$discard=, k+4($pop139), $6
	i32.const	$push138=, 0
	i32.store	$discard=, k+8($pop138):p2align=3, $5
	i32.const	$push137=, 0
	i32.store	$discard=, k+12($pop137), $4
	i32.const	$push136=, 0
	i32.store	$discard=, res($pop136):p2align=4, $7
	i32.const	$push135=, 0
	i32.store	$discard=, res+4($pop135), $6
	i32.const	$push134=, 0
	i32.store	$discard=, res+8($pop134):p2align=3, $5
	i32.const	$push133=, 0
	i32.store	$discard=, res+12($pop133), $4
	i32.const	$push29=, 15
	i32.ne  	$push30=, $7, $pop29
	br_if   	2, $pop30       # 2: down to label6
# BB#9:                                 # %verify.exit9
	i32.const	$push140=, 7
	i32.ne  	$push31=, $6, $pop140
	br_if   	2, $pop31       # 2: down to label6
# BB#10:                                # %verify.exit9
	i32.const	$push141=, 7
	i32.ne  	$push32=, $5, $pop141
	br_if   	2, $pop32       # 2: down to label6
# BB#11:                                # %verify.exit9
	i32.const	$push33=, 6
	i32.ne  	$push34=, $4, $pop33
	br_if   	2, $pop34       # 2: down to label6
# BB#12:                                # %verify.exit18
	i32.const	$push39=, 0
	i32.and 	$push38=, $2, $0
	i32.store	$4=, k($pop39):p2align=4, $pop38
	i32.const	$push148=, 0
	i32.and 	$push35=, $3, $1
	i32.store	$5=, k+4($pop148), $pop35
	i32.const	$push147=, 0
	i32.and 	$push36=, $10, $9
	i32.store	$6=, k+8($pop147):p2align=3, $pop36
	i32.const	$push146=, 0
	i32.and 	$push37=, $12, $11
	i32.store	$7=, k+12($pop146), $pop37
	i32.const	$push145=, 0
	i32.store	$discard=, res($pop145):p2align=4, $4
	i32.const	$push144=, 0
	i32.store	$discard=, res+4($pop144), $5
	i32.const	$push143=, 0
	i32.store	$discard=, res+8($pop143):p2align=3, $6
	i32.const	$push142=, 0
	i32.store	$discard=, res+12($pop142), $7
	i32.const	$push40=, 2
	i32.ne  	$push41=, $4, $pop40
	br_if   	3, $pop41       # 3: down to label5
# BB#13:                                # %verify.exit18
	i32.const	$push42=, 4
	i32.ne  	$push43=, $5, $pop42
	br_if   	3, $pop43       # 3: down to label5
# BB#14:                                # %verify.exit18
	i32.const	$push44=, 20
	i32.ne  	$push45=, $6, $pop44
	br_if   	3, $pop45       # 3: down to label5
# BB#15:                                # %verify.exit18
	i32.const	$push46=, 8
	i32.ne  	$push47=, $7, $pop46
	br_if   	3, $pop47       # 3: down to label5
# BB#16:                                # %verify.exit27
	i32.const	$push52=, 0
	i32.or  	$push51=, $2, $0
	i32.store	$4=, k($pop52):p2align=4, $pop51
	i32.const	$push155=, 0
	i32.or  	$push48=, $3, $1
	i32.store	$5=, k+4($pop155), $pop48
	i32.const	$push154=, 0
	i32.or  	$push49=, $10, $9
	i32.store	$6=, k+8($pop154):p2align=3, $pop49
	i32.const	$push153=, 0
	i32.or  	$push50=, $12, $11
	i32.store	$7=, k+12($pop153), $pop50
	i32.const	$push152=, 0
	i32.store	$discard=, res($pop152):p2align=4, $4
	i32.const	$push151=, 0
	i32.store	$discard=, res+4($pop151), $5
	i32.const	$push150=, 0
	i32.store	$discard=, res+8($pop150):p2align=3, $6
	i32.const	$push149=, 0
	i32.store	$discard=, res+12($pop149), $7
	i32.const	$push53=, 158
	i32.ne  	$push54=, $4, $pop53
	br_if   	4, $pop54       # 4: down to label4
# BB#17:                                # %verify.exit27
	i32.const	$push55=, 109
	i32.ne  	$push56=, $5, $pop55
	br_if   	4, $pop56       # 4: down to label4
# BB#18:                                # %verify.exit27
	i32.const	$push57=, 150
	i32.ne  	$push58=, $6, $pop57
	br_if   	4, $pop58       # 4: down to label4
# BB#19:                                # %verify.exit27
	i32.const	$push59=, 222
	i32.ne  	$push60=, $7, $pop59
	br_if   	4, $pop60       # 4: down to label4
# BB#20:                                # %verify.exit36
	i32.const	$push65=, 0
	i32.xor 	$push64=, $0, $2
	i32.store	$2=, k($pop65):p2align=4, $pop64
	i32.const	$push162=, 0
	i32.xor 	$push61=, $1, $3
	i32.store	$3=, k+4($pop162), $pop61
	i32.const	$push161=, 0
	i32.xor 	$push62=, $9, $10
	i32.store	$4=, k+8($pop161):p2align=3, $pop62
	i32.const	$push160=, 0
	i32.xor 	$push63=, $11, $12
	i32.store	$5=, k+12($pop160), $pop63
	i32.const	$push159=, 0
	i32.store	$discard=, res($pop159):p2align=4, $2
	i32.const	$push158=, 0
	i32.store	$discard=, res+4($pop158), $3
	i32.const	$push157=, 0
	i32.store	$discard=, res+8($pop157):p2align=3, $4
	i32.const	$push156=, 0
	i32.store	$discard=, res+12($pop156), $5
	i32.const	$push66=, 156
	i32.ne  	$push67=, $2, $pop66
	br_if   	5, $pop67       # 5: down to label3
# BB#21:                                # %verify.exit36
	i32.const	$push68=, 105
	i32.ne  	$push69=, $3, $pop68
	br_if   	5, $pop69       # 5: down to label3
# BB#22:                                # %verify.exit36
	i32.const	$push70=, 130
	i32.ne  	$push71=, $4, $pop70
	br_if   	5, $pop71       # 5: down to label3
# BB#23:                                # %verify.exit36
	i32.const	$push72=, 214
	i32.ne  	$push73=, $5, $pop72
	br_if   	5, $pop73       # 5: down to label3
# BB#24:                                # %verify.exit45
	i32.const	$push77=, 0
	i32.const	$push173=, 0
	i32.sub 	$push78=, $pop173, $0
	i32.store	$3=, k($pop77):p2align=4, $pop78
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.sub 	$push74=, $pop171, $1
	i32.store	$2=, k+4($pop172), $pop74
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.sub 	$push75=, $pop169, $9
	i32.store	$4=, k+8($pop170):p2align=3, $pop75
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.sub 	$push76=, $pop167, $11
	i32.store	$5=, k+12($pop168), $pop76
	i32.const	$push166=, 0
	i32.store	$discard=, res($pop166):p2align=4, $3
	i32.const	$push165=, 0
	i32.store	$discard=, res+4($pop165), $2
	i32.const	$push164=, 0
	i32.store	$discard=, res+8($pop164):p2align=3, $4
	i32.const	$push163=, 0
	i32.store	$discard=, res+12($pop163), $5
	i32.const	$push79=, -150
	i32.ne  	$push80=, $3, $pop79
	br_if   	6, $pop80       # 6: down to label2
# BB#25:                                # %verify.exit45
	i32.const	$push81=, -100
	i32.ne  	$push82=, $2, $pop81
	br_if   	6, $pop82       # 6: down to label2
# BB#26:                                # %verify.exit45
	i32.const	$push83=, -150
	i32.ne  	$push84=, $4, $pop83
	br_if   	6, $pop84       # 6: down to label2
# BB#27:                                # %verify.exit45
	i32.const	$push85=, -200
	i32.ne  	$push86=, $5, $pop85
	br_if   	6, $pop86       # 6: down to label2
# BB#28:                                # %verify.exit54
	i32.const	$push92=, 0
	i32.const	$push183=, 0
	i32.const	$push90=, -1
	i32.xor 	$push91=, $0, $pop90
	i32.store	$push93=, k($pop183):p2align=4, $pop91
	i32.store	$discard=, res($pop92):p2align=4, $pop93
	i32.const	$push182=, 0
	i32.const	$push181=, -1
	i32.xor 	$push87=, $1, $pop181
	i32.store	$1=, k+4($pop182), $pop87
	i32.const	$push180=, 0
	i32.const	$push179=, -1
	i32.xor 	$push88=, $9, $pop179
	i32.store	$3=, k+8($pop180):p2align=3, $pop88
	i32.const	$push178=, 0
	i32.const	$push177=, -1
	i32.xor 	$push89=, $11, $pop177
	i32.store	$2=, k+12($pop178), $pop89
	i32.const	$push176=, 0
	i32.store	$discard=, res+4($pop176), $1
	i32.const	$push175=, 0
	i32.store	$discard=, res+8($pop175):p2align=3, $3
	i32.const	$push174=, 0
	i32.store	$discard=, res+12($pop174), $2
	i32.const	$push94=, 150
	i32.ne  	$push95=, $0, $pop94
	br_if   	7, $pop95       # 7: down to label1
# BB#29:                                # %verify.exit54
	i32.const	$push96=, -101
	i32.ne  	$push97=, $1, $pop96
	br_if   	7, $pop97       # 7: down to label1
# BB#30:                                # %verify.exit54
	i32.const	$push98=, -151
	i32.ne  	$push99=, $3, $pop98
	br_if   	7, $pop99       # 7: down to label1
# BB#31:                                # %verify.exit54
	i32.const	$push100=, -201
	i32.ne  	$push101=, $2, $pop100
	br_if   	7, $pop101      # 7: down to label1
# BB#32:                                # %verify.exit63
	i32.const	$push102=, 0
	call    	exit@FUNCTION, $pop102
	unreachable
.LBB1_33:                               # %if.then.i
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then.i8
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then.i17
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then.i26
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then.i35
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then.i44
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then.i53
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then.i62
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
	.p2align	4
i:
	.int32	150                     # 0x96
	.int32	100                     # 0x64
	.int32	150                     # 0x96
	.int32	200                     # 0xc8
	.size	i, 16

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	4
j:
	.int32	10                      # 0xa
	.int32	13                      # 0xd
	.int32	20                      # 0x14
	.int32	30                      # 0x1e
	.size	j, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	4
k:
	.skip	16
	.size	k, 16

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.p2align	4
res:
	.skip	16
	.size	res, 16


	.ident	"clang version 3.9.0 "
