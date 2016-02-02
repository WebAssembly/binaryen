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
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $5
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %entry
	i32.ne  	$push2=, $2, $6
	br_if   	$pop2, 0        # 0: down to label0
# BB#3:                                 # %entry
	i32.ne  	$push3=, $3, $7
	br_if   	$pop3, 0        # 0: down to label0
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
	i32.const	$push7=, 0
	i32.const	$push125=, 0
	i32.load	$push3=, j+12($pop125)
	tee_local	$push124=, $12=, $pop3
	i32.const	$push123=, 0
	i32.load	$push1=, i+12($pop123)
	tee_local	$push122=, $11=, $pop1
	i32.add 	$push6=, $pop124, $pop122
	i32.store	$4=, k+12($pop7), $pop6
	i32.const	$push121=, 0
	i32.load	$1=, i+4($pop121)
	i32.const	$push120=, 0
	i32.load	$0=, i($pop120):p2align=4
	i32.const	$push119=, 0
	i32.load	$3=, j+4($pop119)
	i32.const	$push118=, 0
	i32.load	$2=, j($pop118):p2align=4
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load	$push2=, j+8($pop116):p2align=3
	tee_local	$push115=, $10=, $pop2
	i32.const	$push114=, 0
	i32.load	$push0=, i+8($pop114):p2align=3
	tee_local	$push113=, $9=, $pop0
	i32.add 	$push5=, $pop115, $pop113
	i32.store	$5=, k+8($pop117):p2align=3, $pop5
	i32.const	$push112=, 0
	i32.add 	$push4=, $3, $1
	i32.store	$6=, k+4($pop112), $pop4
	i32.const	$push111=, 0
	i32.add 	$push8=, $2, $0
	i32.store	$7=, k($pop111):p2align=4, $pop8
	i32.const	$push110=, 0
	i32.store	$8=, res+12($pop110), $4
	i32.const	$push109=, 0
	i32.store	$discard=, res+8($pop109):p2align=3, $5
	i32.const	$push108=, 0
	i32.store	$4=, res+4($pop108), $6
	block
	i32.const	$push107=, 0
	i32.store	$push9=, res($pop107):p2align=4, $7
	i32.const	$push10=, 160
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push12=, 113
	i32.ne  	$push13=, $4, $pop12
	br_if   	$pop13, 0       # 0: down to label1
# BB#2:                                 # %entry
	i32.const	$push14=, 170
	i32.ne  	$push15=, $5, $pop14
	br_if   	$pop15, 0       # 0: down to label1
# BB#3:                                 # %entry
	i32.const	$push16=, 230
	i32.ne  	$push17=, $8, $pop16
	br_if   	$pop17, 0       # 0: down to label1
# BB#4:                                 # %verify.exit
	i32.const	$push22=, 0
	i32.mul 	$push21=, $2, $0
	i32.store	$4=, k($pop22):p2align=4, $pop21
	i32.const	$push132=, 0
	i32.mul 	$push18=, $3, $1
	i32.store	$5=, k+4($pop132), $pop18
	i32.const	$push131=, 0
	i32.mul 	$push19=, $10, $9
	i32.store	$6=, k+8($pop131):p2align=3, $pop19
	i32.const	$push130=, 0
	i32.mul 	$push20=, $12, $11
	i32.store	$7=, k+12($pop130), $pop20
	i32.const	$push129=, 0
	i32.store	$discard=, res($pop129):p2align=4, $4
	i32.const	$push128=, 0
	i32.store	$discard=, res+4($pop128), $5
	i32.const	$push127=, 0
	i32.store	$discard=, res+8($pop127):p2align=3, $6
	i32.const	$push126=, 0
	i32.store	$discard=, res+12($pop126), $7
	block
	i32.const	$push23=, 1500
	i32.ne  	$push24=, $4, $pop23
	br_if   	$pop24, 0       # 0: down to label2
# BB#5:                                 # %verify.exit
	i32.const	$push25=, 1300
	i32.ne  	$push26=, $5, $pop25
	br_if   	$pop26, 0       # 0: down to label2
# BB#6:                                 # %verify.exit
	i32.const	$push27=, 3000
	i32.ne  	$push28=, $6, $pop27
	br_if   	$pop28, 0       # 0: down to label2
# BB#7:                                 # %verify.exit
	i32.const	$push29=, 6000
	i32.ne  	$push30=, $7, $pop29
	br_if   	$pop30, 0       # 0: down to label2
# BB#8:                                 # %verify.exit9
	i32.div_s	$4=, $11, $12
	i32.div_s	$5=, $9, $10
	i32.div_s	$6=, $1, $3
	i32.const	$push32=, 0
	i32.div_s	$push31=, $0, $2
	i32.store	$7=, k($pop32):p2align=4, $pop31
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
	block
	i32.const	$push33=, 15
	i32.ne  	$push34=, $7, $pop33
	br_if   	$pop34, 0       # 0: down to label3
# BB#9:                                 # %verify.exit9
	i32.const	$push140=, 7
	i32.ne  	$push35=, $6, $pop140
	br_if   	$pop35, 0       # 0: down to label3
# BB#10:                                # %verify.exit9
	i32.const	$push141=, 7
	i32.ne  	$push36=, $5, $pop141
	br_if   	$pop36, 0       # 0: down to label3
# BB#11:                                # %verify.exit9
	i32.const	$push37=, 6
	i32.ne  	$push38=, $4, $pop37
	br_if   	$pop38, 0       # 0: down to label3
# BB#12:                                # %verify.exit18
	i32.const	$push43=, 0
	i32.and 	$push42=, $2, $0
	i32.store	$4=, k($pop43):p2align=4, $pop42
	i32.const	$push148=, 0
	i32.and 	$push39=, $3, $1
	i32.store	$5=, k+4($pop148), $pop39
	i32.const	$push147=, 0
	i32.and 	$push40=, $10, $9
	i32.store	$6=, k+8($pop147):p2align=3, $pop40
	i32.const	$push146=, 0
	i32.and 	$push41=, $12, $11
	i32.store	$7=, k+12($pop146), $pop41
	i32.const	$push145=, 0
	i32.store	$discard=, res($pop145):p2align=4, $4
	i32.const	$push144=, 0
	i32.store	$discard=, res+4($pop144), $5
	i32.const	$push143=, 0
	i32.store	$discard=, res+8($pop143):p2align=3, $6
	i32.const	$push142=, 0
	i32.store	$discard=, res+12($pop142), $7
	block
	i32.const	$push44=, 2
	i32.ne  	$push45=, $4, $pop44
	br_if   	$pop45, 0       # 0: down to label4
# BB#13:                                # %verify.exit18
	i32.const	$push46=, 4
	i32.ne  	$push47=, $5, $pop46
	br_if   	$pop47, 0       # 0: down to label4
# BB#14:                                # %verify.exit18
	i32.const	$push48=, 20
	i32.ne  	$push49=, $6, $pop48
	br_if   	$pop49, 0       # 0: down to label4
# BB#15:                                # %verify.exit18
	i32.const	$push50=, 8
	i32.ne  	$push51=, $7, $pop50
	br_if   	$pop51, 0       # 0: down to label4
# BB#16:                                # %verify.exit27
	i32.const	$push56=, 0
	i32.or  	$push55=, $2, $0
	i32.store	$4=, k($pop56):p2align=4, $pop55
	i32.const	$push155=, 0
	i32.or  	$push52=, $3, $1
	i32.store	$5=, k+4($pop155), $pop52
	i32.const	$push154=, 0
	i32.or  	$push53=, $10, $9
	i32.store	$6=, k+8($pop154):p2align=3, $pop53
	i32.const	$push153=, 0
	i32.or  	$push54=, $12, $11
	i32.store	$7=, k+12($pop153), $pop54
	i32.const	$push152=, 0
	i32.store	$discard=, res($pop152):p2align=4, $4
	i32.const	$push151=, 0
	i32.store	$discard=, res+4($pop151), $5
	i32.const	$push150=, 0
	i32.store	$discard=, res+8($pop150):p2align=3, $6
	i32.const	$push149=, 0
	i32.store	$discard=, res+12($pop149), $7
	block
	i32.const	$push57=, 158
	i32.ne  	$push58=, $4, $pop57
	br_if   	$pop58, 0       # 0: down to label5
# BB#17:                                # %verify.exit27
	i32.const	$push59=, 109
	i32.ne  	$push60=, $5, $pop59
	br_if   	$pop60, 0       # 0: down to label5
# BB#18:                                # %verify.exit27
	i32.const	$push61=, 150
	i32.ne  	$push62=, $6, $pop61
	br_if   	$pop62, 0       # 0: down to label5
# BB#19:                                # %verify.exit27
	i32.const	$push63=, 222
	i32.ne  	$push64=, $7, $pop63
	br_if   	$pop64, 0       # 0: down to label5
# BB#20:                                # %verify.exit36
	i32.const	$push69=, 0
	i32.xor 	$push68=, $0, $2
	i32.store	$2=, k($pop69):p2align=4, $pop68
	i32.const	$push162=, 0
	i32.xor 	$push65=, $1, $3
	i32.store	$3=, k+4($pop162), $pop65
	i32.const	$push161=, 0
	i32.xor 	$push66=, $9, $10
	i32.store	$4=, k+8($pop161):p2align=3, $pop66
	i32.const	$push160=, 0
	i32.xor 	$push67=, $11, $12
	i32.store	$5=, k+12($pop160), $pop67
	i32.const	$push159=, 0
	i32.store	$discard=, res($pop159):p2align=4, $2
	i32.const	$push158=, 0
	i32.store	$discard=, res+4($pop158), $3
	i32.const	$push157=, 0
	i32.store	$discard=, res+8($pop157):p2align=3, $4
	i32.const	$push156=, 0
	i32.store	$discard=, res+12($pop156), $5
	block
	i32.const	$push70=, 156
	i32.ne  	$push71=, $2, $pop70
	br_if   	$pop71, 0       # 0: down to label6
# BB#21:                                # %verify.exit36
	i32.const	$push72=, 105
	i32.ne  	$push73=, $3, $pop72
	br_if   	$pop73, 0       # 0: down to label6
# BB#22:                                # %verify.exit36
	i32.const	$push74=, 130
	i32.ne  	$push75=, $4, $pop74
	br_if   	$pop75, 0       # 0: down to label6
# BB#23:                                # %verify.exit36
	i32.const	$push76=, 214
	i32.ne  	$push77=, $5, $pop76
	br_if   	$pop77, 0       # 0: down to label6
# BB#24:                                # %verify.exit45
	i32.const	$push81=, 0
	i32.const	$push173=, 0
	i32.sub 	$push82=, $pop173, $0
	i32.store	$3=, k($pop81):p2align=4, $pop82
	i32.const	$push172=, 0
	i32.const	$push171=, 0
	i32.sub 	$push78=, $pop171, $1
	i32.store	$2=, k+4($pop172), $pop78
	i32.const	$push170=, 0
	i32.const	$push169=, 0
	i32.sub 	$push79=, $pop169, $9
	i32.store	$4=, k+8($pop170):p2align=3, $pop79
	i32.const	$push168=, 0
	i32.const	$push167=, 0
	i32.sub 	$push80=, $pop167, $11
	i32.store	$5=, k+12($pop168), $pop80
	i32.const	$push166=, 0
	i32.store	$discard=, res($pop166):p2align=4, $3
	i32.const	$push165=, 0
	i32.store	$discard=, res+4($pop165), $2
	i32.const	$push164=, 0
	i32.store	$discard=, res+8($pop164):p2align=3, $4
	i32.const	$push163=, 0
	i32.store	$discard=, res+12($pop163), $5
	block
	i32.const	$push83=, -150
	i32.ne  	$push84=, $3, $pop83
	br_if   	$pop84, 0       # 0: down to label7
# BB#25:                                # %verify.exit45
	i32.const	$push85=, -100
	i32.ne  	$push86=, $2, $pop85
	br_if   	$pop86, 0       # 0: down to label7
# BB#26:                                # %verify.exit45
	i32.const	$push87=, -150
	i32.ne  	$push88=, $4, $pop87
	br_if   	$pop88, 0       # 0: down to label7
# BB#27:                                # %verify.exit45
	i32.const	$push89=, -200
	i32.ne  	$push90=, $5, $pop89
	br_if   	$pop90, 0       # 0: down to label7
# BB#28:                                # %verify.exit54
	i32.const	$push96=, 0
	i32.const	$push183=, 0
	i32.const	$push94=, -1
	i32.xor 	$push95=, $0, $pop94
	i32.store	$push97=, k($pop183):p2align=4, $pop95
	i32.store	$discard=, res($pop96):p2align=4, $pop97
	i32.const	$push182=, 0
	i32.const	$push181=, -1
	i32.xor 	$push91=, $1, $pop181
	i32.store	$1=, k+4($pop182), $pop91
	i32.const	$push180=, 0
	i32.const	$push179=, -1
	i32.xor 	$push92=, $9, $pop179
	i32.store	$3=, k+8($pop180):p2align=3, $pop92
	i32.const	$push178=, 0
	i32.const	$push177=, -1
	i32.xor 	$push93=, $11, $pop177
	i32.store	$2=, k+12($pop178), $pop93
	i32.const	$push176=, 0
	i32.store	$discard=, res+4($pop176), $1
	i32.const	$push175=, 0
	i32.store	$discard=, res+8($pop175):p2align=3, $3
	i32.const	$push174=, 0
	i32.store	$discard=, res+12($pop174), $2
	block
	i32.const	$push98=, 150
	i32.ne  	$push99=, $0, $pop98
	br_if   	$pop99, 0       # 0: down to label8
# BB#29:                                # %verify.exit54
	i32.const	$push100=, -101
	i32.ne  	$push101=, $1, $pop100
	br_if   	$pop101, 0      # 0: down to label8
# BB#30:                                # %verify.exit54
	i32.const	$push102=, -151
	i32.ne  	$push103=, $3, $pop102
	br_if   	$pop103, 0      # 0: down to label8
# BB#31:                                # %verify.exit54
	i32.const	$push104=, -201
	i32.ne  	$push105=, $2, $pop104
	br_if   	$pop105, 0      # 0: down to label8
# BB#32:                                # %verify.exit63
	i32.const	$push106=, 0
	call    	exit@FUNCTION, $pop106
	unreachable
.LBB1_33:                               # %if.then.i62
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then.i53
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then.i44
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then.i35
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then.i26
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then.i17
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then.i8
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then.i
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
