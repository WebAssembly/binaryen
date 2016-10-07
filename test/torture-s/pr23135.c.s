	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23135.c"
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
	i32.const	$push0=, 0
	i32.const	$push100=, 0
	i32.load	$push99=, j+4($pop100)
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 0
	i32.load	$push96=, i+4($pop97)
	tee_local	$push95=, $1=, $pop96
	i32.add 	$push94=, $pop98, $pop95
	tee_local	$push93=, $5=, $pop94
	i32.store	res+4($pop0), $pop93
	i32.const	$push92=, 0
	i32.const	$push91=, 0
	i32.load	$push90=, j($pop91)
	tee_local	$push89=, $2=, $pop90
	i32.const	$push88=, 0
	i32.load	$push87=, i($pop88)
	tee_local	$push86=, $0=, $pop87
	i32.add 	$push85=, $pop89, $pop86
	tee_local	$push84=, $4=, $pop85
	i32.store	res($pop92), $pop84
	block   	
	i32.const	$push1=, 160
	i32.ne  	$push2=, $4, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push3=, 113
	i32.ne  	$push4=, $5, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push5=, 0
	i32.mul 	$push105=, $2, $0
	tee_local	$push104=, $6=, $pop105
	i32.store	res($pop5), $pop104
	i32.const	$push103=, 0
	i32.mul 	$push102=, $3, $1
	tee_local	$push101=, $7=, $pop102
	i32.store	res+4($pop103), $pop101
	i32.const	$push6=, 1500
	i32.ne  	$push7=, $6, $pop6
	br_if   	0, $pop7        # 0: down to label1
# BB#3:                                 # %verify.exit
	i32.const	$push8=, 1300
	i32.ne  	$push9=, $7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#4:                                 # %verify.exit48
	i32.const	$push10=, 0
	i32.div_s	$push110=, $0, $2
	tee_local	$push109=, $8=, $pop110
	i32.store	res($pop10), $pop109
	i32.const	$push108=, 0
	i32.div_s	$push107=, $1, $3
	tee_local	$push106=, $9=, $pop107
	i32.store	res+4($pop108), $pop106
	i32.const	$push11=, 15
	i32.ne  	$push12=, $8, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#5:                                 # %verify.exit48
	i32.const	$push13=, 7
	i32.ne  	$push14=, $9, $pop13
	br_if   	0, $pop14       # 0: down to label1
# BB#6:                                 # %verify.exit54
	i32.const	$push15=, 0
	i32.and 	$push115=, $2, $0
	tee_local	$push114=, $10=, $pop115
	i32.store	res($pop15), $pop114
	i32.const	$push113=, 0
	i32.and 	$push112=, $3, $1
	tee_local	$push111=, $11=, $pop112
	i32.store	res+4($pop113), $pop111
	i32.const	$push16=, 2
	i32.ne  	$push17=, $10, $pop16
	br_if   	0, $pop17       # 0: down to label1
# BB#7:                                 # %verify.exit54
	i32.const	$push18=, 4
	i32.ne  	$push19=, $11, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#8:                                 # %verify.exit60
	i32.const	$push20=, 0
	i32.or  	$push120=, $2, $0
	tee_local	$push119=, $12=, $pop120
	i32.store	res($pop20), $pop119
	i32.const	$push118=, 0
	i32.or  	$push117=, $3, $1
	tee_local	$push116=, $13=, $pop117
	i32.store	res+4($pop118), $pop116
	i32.const	$push21=, 158
	i32.ne  	$push22=, $12, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#9:                                 # %verify.exit60
	i32.const	$push23=, 109
	i32.ne  	$push24=, $13, $pop23
	br_if   	0, $pop24       # 0: down to label1
# BB#10:                                # %verify.exit66
	i32.const	$push25=, 0
	i32.xor 	$push125=, $0, $2
	tee_local	$push124=, $2=, $pop125
	i32.store	res($pop25), $pop124
	i32.const	$push123=, 0
	i32.xor 	$push122=, $1, $3
	tee_local	$push121=, $3=, $pop122
	i32.store	res+4($pop123), $pop121
	i32.const	$push26=, 156
	i32.ne  	$push27=, $2, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#11:                                # %verify.exit66
	i32.const	$push28=, 105
	i32.ne  	$push29=, $3, $pop28
	br_if   	0, $pop29       # 0: down to label1
# BB#12:                                # %verify.exit72
	i32.const	$push30=, 0
	i32.const	$push132=, 0
	i32.sub 	$push131=, $pop132, $0
	tee_local	$push130=, $14=, $pop131
	i32.store	res($pop30), $pop130
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.sub 	$push127=, $pop128, $1
	tee_local	$push126=, $15=, $pop127
	i32.store	res+4($pop129), $pop126
	i32.const	$push31=, -150
	i32.ne  	$push32=, $14, $pop31
	br_if   	0, $pop32       # 0: down to label1
# BB#13:                                # %verify.exit72
	i32.const	$push33=, -100
	i32.ne  	$push34=, $15, $pop33
	br_if   	0, $pop34       # 0: down to label1
# BB#14:                                # %verify.exit78
	i32.const	$push36=, 0
	i32.const	$push35=, -1
	i32.xor 	$push138=, $0, $pop35
	tee_local	$push137=, $16=, $pop138
	i32.store	res($pop36), $pop137
	i32.const	$push136=, 0
	i32.const	$push135=, -1
	i32.xor 	$push134=, $1, $pop135
	tee_local	$push133=, $17=, $pop134
	i32.store	res+4($pop136), $pop133
	i32.const	$push37=, 150
	i32.ne  	$push38=, $0, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#15:                                # %verify.exit78
	i32.const	$push39=, -101
	i32.ne  	$push40=, $17, $pop39
	br_if   	0, $pop40       # 0: down to label1
# BB#16:                                # %verify.exit84
	i32.const	$push46=, 0
	i32.add 	$push41=, $6, $4
	i32.add 	$push42=, $pop41, $10
	i32.add 	$push43=, $pop42, $12
	i32.add 	$push44=, $pop43, $2
	i32.sub 	$push45=, $pop44, $0
	i32.add 	$push145=, $pop45, $16
	tee_local	$push144=, $0=, $pop145
	i32.store	res($pop46), $pop144
	i32.const	$push143=, 0
	i32.store	k($pop143), $0
	i32.const	$push142=, 0
	i32.add 	$push47=, $7, $5
	i32.add 	$push48=, $pop47, $11
	i32.add 	$push49=, $pop48, $13
	i32.add 	$push50=, $pop49, $3
	i32.sub 	$push51=, $pop50, $1
	i32.add 	$push141=, $pop51, $17
	tee_local	$push140=, $1=, $pop141
	i32.store	res+4($pop142), $pop140
	i32.const	$push139=, 0
	i32.store	k+4($pop139), $1
	i32.const	$push52=, 1675
	i32.ne  	$push53=, $0, $pop52
	br_if   	0, $pop53       # 0: down to label1
# BB#17:                                # %verify.exit84
	i32.const	$push54=, 1430
	i32.ne  	$push55=, $1, $pop54
	br_if   	0, $pop55       # 0: down to label1
# BB#18:                                # %verify.exit90
	i32.const	$push61=, 0
	i32.mul 	$push56=, $6, $4
	i32.mul 	$push57=, $pop56, $10
	i32.mul 	$push58=, $pop57, $12
	i32.mul 	$push59=, $pop58, $2
	i32.mul 	$push60=, $pop59, $14
	i32.mul 	$push152=, $pop60, $16
	tee_local	$push151=, $0=, $pop152
	i32.store	res($pop61), $pop151
	i32.const	$push150=, 0
	i32.store	k($pop150), $0
	i32.const	$push149=, 0
	i32.mul 	$push62=, $7, $5
	i32.mul 	$push63=, $pop62, $11
	i32.mul 	$push64=, $pop63, $13
	i32.mul 	$push65=, $pop64, $3
	i32.mul 	$push66=, $pop65, $15
	i32.mul 	$push148=, $pop66, $17
	tee_local	$push147=, $1=, $pop148
	i32.store	res+4($pop149), $pop147
	i32.const	$push146=, 0
	i32.store	k+4($pop146), $1
	i32.const	$push67=, 1456467968
	i32.ne  	$push68=, $0, $pop67
	br_if   	0, $pop68       # 0: down to label1
# BB#19:                                # %verify.exit90
	i32.const	$push69=, -1579586240
	i32.ne  	$push70=, $1, $pop69
	br_if   	0, $pop70       # 0: down to label1
# BB#20:                                # %verify.exit96
	i32.const	$push160=, 0
	i32.div_s	$push71=, $4, $6
	i32.div_s	$push72=, $pop71, $8
	i32.div_s	$push73=, $pop72, $10
	i32.div_s	$push74=, $pop73, $12
	i32.div_s	$push75=, $pop74, $2
	i32.div_s	$push76=, $pop75, $14
	i32.div_s	$push159=, $pop76, $16
	tee_local	$push158=, $4=, $pop159
	i32.store	res($pop160), $pop158
	i32.const	$push157=, 0
	i32.store	k($pop157), $4
	i32.const	$push156=, 0
	i32.div_s	$push77=, $5, $7
	i32.div_s	$push78=, $pop77, $9
	i32.div_s	$push79=, $pop78, $11
	i32.div_s	$push80=, $pop79, $13
	i32.div_s	$push81=, $pop80, $3
	i32.div_s	$push82=, $pop81, $15
	i32.div_s	$push155=, $pop82, $17
	tee_local	$push154=, $0=, $pop155
	i32.store	res+4($pop156), $pop154
	i32.const	$push153=, 0
	i32.store	k+4($pop153), $0
	i32.or  	$push83=, $0, $4
	br_if   	0, $pop83       # 0: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push161=, 0
	call    	exit@FUNCTION, $pop161
	unreachable
.LBB1_22:                               # %if.then.i101
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
