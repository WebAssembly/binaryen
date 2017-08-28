	.text
	.file	"pr23135.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify                  # -- Begin function verify
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
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push100=, 0
	i32.const	$push99=, 0
	i32.load	$push98=, j+4($pop99)
	tee_local	$push97=, $5=, $pop98
	i32.const	$push96=, 0
	i32.load	$push95=, i+4($pop96)
	tee_local	$push94=, $1=, $pop95
	i32.add 	$push93=, $pop97, $pop94
	tee_local	$push92=, $7=, $pop93
	i32.store	res+4($pop100), $pop92
	i32.const	$push91=, 0
	i32.const	$push90=, 0
	i32.load	$push89=, j($pop90)
	tee_local	$push88=, $4=, $pop89
	i32.const	$push87=, 0
	i32.load	$push86=, i($pop87)
	tee_local	$push85=, $0=, $pop86
	i32.add 	$push84=, $pop88, $pop85
	tee_local	$push83=, $6=, $pop84
	i32.store	res($pop91), $pop83
	block   	
	i32.const	$push0=, 160
	i32.ne  	$push1=, $6, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 113
	i32.ne  	$push3=, $7, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push4=, 0
	i32.mul 	$push105=, $4, $0
	tee_local	$push104=, $8=, $pop105
	i32.store	res($pop4), $pop104
	i32.const	$push103=, 0
	i32.mul 	$push102=, $5, $1
	tee_local	$push101=, $9=, $pop102
	i32.store	res+4($pop103), $pop101
	i32.const	$push5=, 1500
	i32.ne  	$push6=, $8, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#3:                                 # %verify.exit
	i32.const	$push7=, 1300
	i32.ne  	$push8=, $9, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#4:                                 # %verify.exit48
	i32.const	$push9=, 0
	i32.div_s	$push110=, $0, $4
	tee_local	$push109=, $10=, $pop110
	i32.store	res($pop9), $pop109
	i32.const	$push108=, 0
	i32.div_s	$push107=, $1, $5
	tee_local	$push106=, $11=, $pop107
	i32.store	res+4($pop108), $pop106
	i32.const	$push10=, 15
	i32.ne  	$push11=, $10, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#5:                                 # %verify.exit48
	i32.const	$push12=, 7
	i32.ne  	$push13=, $11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#6:                                 # %verify.exit54
	i32.const	$push14=, 0
	i32.and 	$push115=, $4, $0
	tee_local	$push114=, $12=, $pop115
	i32.store	res($pop14), $pop114
	i32.const	$push113=, 0
	i32.and 	$push112=, $5, $1
	tee_local	$push111=, $13=, $pop112
	i32.store	res+4($pop113), $pop111
	i32.const	$push15=, 2
	i32.ne  	$push16=, $12, $pop15
	br_if   	0, $pop16       # 0: down to label1
# BB#7:                                 # %verify.exit54
	i32.const	$push17=, 4
	i32.ne  	$push18=, $13, $pop17
	br_if   	0, $pop18       # 0: down to label1
# BB#8:                                 # %verify.exit60
	i32.const	$push19=, 0
	i32.or  	$push120=, $4, $0
	tee_local	$push119=, $14=, $pop120
	i32.store	res($pop19), $pop119
	i32.const	$push118=, 0
	i32.or  	$push117=, $5, $1
	tee_local	$push116=, $15=, $pop117
	i32.store	res+4($pop118), $pop116
	i32.const	$push20=, 158
	i32.ne  	$push21=, $14, $pop20
	br_if   	0, $pop21       # 0: down to label1
# BB#9:                                 # %verify.exit60
	i32.const	$push22=, 109
	i32.ne  	$push23=, $15, $pop22
	br_if   	0, $pop23       # 0: down to label1
# BB#10:                                # %verify.exit66
	i32.const	$push24=, 0
	i32.xor 	$push125=, $4, $0
	tee_local	$push124=, $4=, $pop125
	i32.store	res($pop24), $pop124
	i32.const	$push123=, 0
	i32.xor 	$push122=, $5, $1
	tee_local	$push121=, $5=, $pop122
	i32.store	res+4($pop123), $pop121
	i32.const	$push25=, 156
	i32.ne  	$push26=, $4, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#11:                                # %verify.exit66
	i32.const	$push27=, 105
	i32.ne  	$push28=, $5, $pop27
	br_if   	0, $pop28       # 0: down to label1
# BB#12:                                # %verify.exit72
	i32.const	$push29=, 0
	i32.const	$push132=, 0
	i32.sub 	$push131=, $pop132, $0
	tee_local	$push130=, $2=, $pop131
	i32.store	res($pop29), $pop130
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.sub 	$push127=, $pop128, $1
	tee_local	$push126=, $3=, $pop127
	i32.store	res+4($pop129), $pop126
	i32.const	$push30=, -150
	i32.ne  	$push31=, $2, $pop30
	br_if   	0, $pop31       # 0: down to label1
# BB#13:                                # %verify.exit72
	i32.const	$push32=, -100
	i32.ne  	$push33=, $3, $pop32
	br_if   	0, $pop33       # 0: down to label1
# BB#14:                                # %verify.exit78
	i32.const	$push35=, 0
	i32.const	$push34=, -1
	i32.xor 	$push138=, $0, $pop34
	tee_local	$push137=, $16=, $pop138
	i32.store	res($pop35), $pop137
	i32.const	$push136=, 0
	i32.const	$push135=, -1
	i32.xor 	$push134=, $1, $pop135
	tee_local	$push133=, $17=, $pop134
	i32.store	res+4($pop136), $pop133
	i32.const	$push36=, 150
	i32.ne  	$push37=, $0, $pop36
	br_if   	0, $pop37       # 0: down to label1
# BB#15:                                # %verify.exit78
	i32.const	$push38=, -101
	i32.ne  	$push39=, $17, $pop38
	br_if   	0, $pop39       # 0: down to label1
# BB#16:                                # %verify.exit84
	i32.const	$push45=, 0
	i32.sub 	$push40=, $16, $0
	i32.add 	$push41=, $pop40, $8
	i32.add 	$push42=, $pop41, $6
	i32.add 	$push43=, $pop42, $12
	i32.add 	$push44=, $pop43, $14
	i32.add 	$push145=, $pop44, $4
	tee_local	$push144=, $0=, $pop145
	i32.store	res($pop45), $pop144
	i32.const	$push143=, 0
	i32.store	k($pop143), $0
	i32.const	$push142=, 0
	i32.sub 	$push46=, $17, $1
	i32.add 	$push47=, $pop46, $9
	i32.add 	$push48=, $pop47, $7
	i32.add 	$push49=, $pop48, $13
	i32.add 	$push50=, $pop49, $15
	i32.add 	$push141=, $pop50, $5
	tee_local	$push140=, $1=, $pop141
	i32.store	res+4($pop142), $pop140
	i32.const	$push139=, 0
	i32.store	k+4($pop139), $1
	i32.const	$push51=, 1675
	i32.ne  	$push52=, $0, $pop51
	br_if   	0, $pop52       # 0: down to label1
# BB#17:                                # %verify.exit84
	i32.const	$push53=, 1430
	i32.ne  	$push54=, $1, $pop53
	br_if   	0, $pop54       # 0: down to label1
# BB#18:                                # %verify.exit90
	i32.const	$push60=, 0
	i32.mul 	$push55=, $16, $2
	i32.mul 	$push56=, $pop55, $8
	i32.mul 	$push57=, $pop56, $6
	i32.mul 	$push58=, $pop57, $12
	i32.mul 	$push59=, $pop58, $14
	i32.mul 	$push152=, $pop59, $4
	tee_local	$push151=, $0=, $pop152
	i32.store	res($pop60), $pop151
	i32.const	$push150=, 0
	i32.store	k($pop150), $0
	i32.const	$push149=, 0
	i32.mul 	$push61=, $17, $3
	i32.mul 	$push62=, $pop61, $9
	i32.mul 	$push63=, $pop62, $7
	i32.mul 	$push64=, $pop63, $13
	i32.mul 	$push65=, $pop64, $15
	i32.mul 	$push148=, $pop65, $5
	tee_local	$push147=, $1=, $pop148
	i32.store	res+4($pop149), $pop147
	i32.const	$push146=, 0
	i32.store	k+4($pop146), $1
	i32.const	$push66=, 1456467968
	i32.ne  	$push67=, $0, $pop66
	br_if   	0, $pop67       # 0: down to label1
# BB#19:                                # %verify.exit90
	i32.const	$push68=, -1579586240
	i32.ne  	$push69=, $1, $pop68
	br_if   	0, $pop69       # 0: down to label1
# BB#20:                                # %verify.exit96
	i32.const	$push160=, 0
	i32.div_s	$push70=, $6, $8
	i32.div_s	$push71=, $pop70, $10
	i32.div_s	$push72=, $pop71, $12
	i32.div_s	$push73=, $pop72, $14
	i32.div_s	$push74=, $pop73, $4
	i32.div_s	$push75=, $pop74, $2
	i32.div_s	$push159=, $pop75, $16
	tee_local	$push158=, $6=, $pop159
	i32.store	res($pop160), $pop158
	i32.const	$push157=, 0
	i32.store	k($pop157), $6
	i32.const	$push156=, 0
	i32.div_s	$push76=, $7, $9
	i32.div_s	$push77=, $pop76, $11
	i32.div_s	$push78=, $pop77, $13
	i32.div_s	$push79=, $pop78, $15
	i32.div_s	$push80=, $pop79, $5
	i32.div_s	$push81=, $pop80, $3
	i32.div_s	$push155=, $pop81, $17
	tee_local	$push154=, $0=, $pop155
	i32.store	res+4($pop156), $pop154
	i32.const	$push153=, 0
	i32.store	k+4($pop153), $0
	i32.or  	$push82=, $0, $6
	br_if   	0, $pop82       # 0: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push161=, 0
	call    	exit@FUNCTION, $pop161
	unreachable
.LBB1_22:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
