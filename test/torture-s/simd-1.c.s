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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push110=, 0
	i32.load	$push109=, j+12($pop110)
	tee_local	$push108=, $7=, $pop109
	i32.const	$push107=, 0
	i32.load	$push106=, i+12($pop107)
	tee_local	$push105=, $3=, $pop106
	i32.add 	$push104=, $pop108, $pop105
	tee_local	$push103=, $10=, $pop104
	i32.store	k+12($pop0), $pop103
	i32.const	$push102=, 0
	i32.const	$push101=, 0
	i32.load	$push100=, j+8($pop101)
	tee_local	$push99=, $6=, $pop100
	i32.const	$push98=, 0
	i32.load	$push97=, i+8($pop98)
	tee_local	$push96=, $2=, $pop97
	i32.add 	$push95=, $pop99, $pop96
	tee_local	$push94=, $9=, $pop95
	i32.store	k+8($pop102), $pop94
	i32.const	$push93=, 0
	i32.const	$push92=, 0
	i32.load	$push91=, j+4($pop92)
	tee_local	$push90=, $5=, $pop91
	i32.const	$push89=, 0
	i32.load	$push88=, i+4($pop89)
	tee_local	$push87=, $1=, $pop88
	i32.add 	$push86=, $pop90, $pop87
	tee_local	$push85=, $8=, $pop86
	i32.store	k+4($pop93), $pop85
	i32.const	$push84=, 0
	i32.const	$push83=, 0
	i32.load	$push82=, j($pop83)
	tee_local	$push81=, $4=, $pop82
	i32.const	$push80=, 0
	i32.load	$push79=, i($pop80)
	tee_local	$push78=, $0=, $pop79
	i32.add 	$push77=, $pop81, $pop78
	tee_local	$push76=, $11=, $pop77
	i32.store	k($pop84), $pop76
	i32.const	$push75=, 0
	i32.store	res+12($pop75), $10
	i32.const	$push74=, 0
	i32.store	res+8($pop74), $9
	i32.const	$push73=, 0
	i32.store	res+4($pop73), $8
	i32.const	$push72=, 0
	i32.store	res($pop72), $11
	block   	
	i32.const	$push1=, 160
	i32.ne  	$push2=, $11, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push3=, 113
	i32.ne  	$push4=, $8, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %entry
	i32.const	$push5=, 170
	i32.ne  	$push6=, $9, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#3:                                 # %entry
	i32.const	$push7=, 230
	i32.ne  	$push8=, $10, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#4:                                 # %verify.exit
	i32.const	$push9=, 0
	i32.mul 	$push125=, $4, $0
	tee_local	$push124=, $11=, $pop125
	i32.store	res($pop9), $pop124
	i32.const	$push123=, 0
	i32.store	k($pop123), $11
	i32.const	$push122=, 0
	i32.mul 	$push121=, $5, $1
	tee_local	$push120=, $8=, $pop121
	i32.store	res+4($pop122), $pop120
	i32.const	$push119=, 0
	i32.store	k+4($pop119), $8
	i32.const	$push118=, 0
	i32.mul 	$push117=, $6, $2
	tee_local	$push116=, $9=, $pop117
	i32.store	res+8($pop118), $pop116
	i32.const	$push115=, 0
	i32.store	k+8($pop115), $9
	i32.const	$push114=, 0
	i32.mul 	$push113=, $7, $3
	tee_local	$push112=, $10=, $pop113
	i32.store	res+12($pop114), $pop112
	i32.const	$push111=, 0
	i32.store	k+12($pop111), $10
	i32.const	$push10=, 1500
	i32.ne  	$push11=, $11, $pop10
	br_if   	0, $pop11       # 0: down to label1
# BB#5:                                 # %verify.exit
	i32.const	$push12=, 1300
	i32.ne  	$push13=, $8, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#6:                                 # %verify.exit
	i32.const	$push14=, 3000
	i32.ne  	$push15=, $9, $pop14
	br_if   	0, $pop15       # 0: down to label1
# BB#7:                                 # %verify.exit
	i32.const	$push16=, 6000
	i32.ne  	$push17=, $10, $pop16
	br_if   	0, $pop17       # 0: down to label1
# BB#8:                                 # %verify.exit9
	i32.const	$push18=, 0
	i32.div_s	$push140=, $0, $4
	tee_local	$push139=, $11=, $pop140
	i32.store	res($pop18), $pop139
	i32.const	$push138=, 0
	i32.store	k($pop138), $11
	i32.const	$push137=, 0
	i32.div_s	$push136=, $1, $5
	tee_local	$push135=, $8=, $pop136
	i32.store	res+4($pop137), $pop135
	i32.const	$push134=, 0
	i32.store	k+4($pop134), $8
	i32.const	$push133=, 0
	i32.div_s	$push132=, $2, $6
	tee_local	$push131=, $9=, $pop132
	i32.store	res+8($pop133), $pop131
	i32.const	$push130=, 0
	i32.store	k+8($pop130), $9
	i32.const	$push129=, 0
	i32.div_s	$push128=, $3, $7
	tee_local	$push127=, $10=, $pop128
	i32.store	res+12($pop129), $pop127
	i32.const	$push126=, 0
	i32.store	k+12($pop126), $10
	i32.const	$push19=, 15
	i32.ne  	$push20=, $11, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#9:                                 # %verify.exit9
	i32.const	$push141=, 7
	i32.ne  	$push21=, $8, $pop141
	br_if   	0, $pop21       # 0: down to label1
# BB#10:                                # %verify.exit9
	i32.const	$push142=, 7
	i32.ne  	$push22=, $9, $pop142
	br_if   	0, $pop22       # 0: down to label1
# BB#11:                                # %verify.exit9
	i32.const	$push23=, 6
	i32.ne  	$push24=, $10, $pop23
	br_if   	0, $pop24       # 0: down to label1
# BB#12:                                # %verify.exit18
	i32.const	$push25=, 0
	i32.and 	$push157=, $4, $0
	tee_local	$push156=, $11=, $pop157
	i32.store	res($pop25), $pop156
	i32.const	$push155=, 0
	i32.store	k($pop155), $11
	i32.const	$push154=, 0
	i32.and 	$push153=, $5, $1
	tee_local	$push152=, $8=, $pop153
	i32.store	res+4($pop154), $pop152
	i32.const	$push151=, 0
	i32.store	k+4($pop151), $8
	i32.const	$push150=, 0
	i32.and 	$push149=, $6, $2
	tee_local	$push148=, $9=, $pop149
	i32.store	res+8($pop150), $pop148
	i32.const	$push147=, 0
	i32.store	k+8($pop147), $9
	i32.const	$push146=, 0
	i32.and 	$push145=, $7, $3
	tee_local	$push144=, $10=, $pop145
	i32.store	res+12($pop146), $pop144
	i32.const	$push143=, 0
	i32.store	k+12($pop143), $10
	i32.const	$push26=, 2
	i32.ne  	$push27=, $11, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#13:                                # %verify.exit18
	i32.const	$push28=, 4
	i32.ne  	$push29=, $8, $pop28
	br_if   	0, $pop29       # 0: down to label1
# BB#14:                                # %verify.exit18
	i32.const	$push30=, 20
	i32.ne  	$push31=, $9, $pop30
	br_if   	0, $pop31       # 0: down to label1
# BB#15:                                # %verify.exit18
	i32.const	$push32=, 8
	i32.ne  	$push33=, $10, $pop32
	br_if   	0, $pop33       # 0: down to label1
# BB#16:                                # %verify.exit27
	i32.const	$push34=, 0
	i32.or  	$push172=, $4, $0
	tee_local	$push171=, $11=, $pop172
	i32.store	res($pop34), $pop171
	i32.const	$push170=, 0
	i32.store	k($pop170), $11
	i32.const	$push169=, 0
	i32.or  	$push168=, $5, $1
	tee_local	$push167=, $8=, $pop168
	i32.store	res+4($pop169), $pop167
	i32.const	$push166=, 0
	i32.store	k+4($pop166), $8
	i32.const	$push165=, 0
	i32.or  	$push164=, $6, $2
	tee_local	$push163=, $9=, $pop164
	i32.store	res+8($pop165), $pop163
	i32.const	$push162=, 0
	i32.store	k+8($pop162), $9
	i32.const	$push161=, 0
	i32.or  	$push160=, $7, $3
	tee_local	$push159=, $10=, $pop160
	i32.store	res+12($pop161), $pop159
	i32.const	$push158=, 0
	i32.store	k+12($pop158), $10
	i32.const	$push35=, 158
	i32.ne  	$push36=, $11, $pop35
	br_if   	0, $pop36       # 0: down to label1
# BB#17:                                # %verify.exit27
	i32.const	$push37=, 109
	i32.ne  	$push38=, $8, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#18:                                # %verify.exit27
	i32.const	$push39=, 150
	i32.ne  	$push40=, $9, $pop39
	br_if   	0, $pop40       # 0: down to label1
# BB#19:                                # %verify.exit27
	i32.const	$push41=, 222
	i32.ne  	$push42=, $10, $pop41
	br_if   	0, $pop42       # 0: down to label1
# BB#20:                                # %verify.exit36
	i32.const	$push43=, 0
	i32.xor 	$push187=, $0, $4
	tee_local	$push186=, $11=, $pop187
	i32.store	res($pop43), $pop186
	i32.const	$push185=, 0
	i32.store	k($pop185), $11
	i32.const	$push184=, 0
	i32.xor 	$push183=, $1, $5
	tee_local	$push182=, $8=, $pop183
	i32.store	res+4($pop184), $pop182
	i32.const	$push181=, 0
	i32.store	k+4($pop181), $8
	i32.const	$push180=, 0
	i32.xor 	$push179=, $2, $6
	tee_local	$push178=, $9=, $pop179
	i32.store	res+8($pop180), $pop178
	i32.const	$push177=, 0
	i32.store	k+8($pop177), $9
	i32.const	$push176=, 0
	i32.xor 	$push175=, $3, $7
	tee_local	$push174=, $10=, $pop175
	i32.store	res+12($pop176), $pop174
	i32.const	$push173=, 0
	i32.store	k+12($pop173), $10
	i32.const	$push44=, 156
	i32.ne  	$push45=, $11, $pop44
	br_if   	0, $pop45       # 0: down to label1
# BB#21:                                # %verify.exit36
	i32.const	$push46=, 105
	i32.ne  	$push47=, $8, $pop46
	br_if   	0, $pop47       # 0: down to label1
# BB#22:                                # %verify.exit36
	i32.const	$push48=, 130
	i32.ne  	$push49=, $9, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#23:                                # %verify.exit36
	i32.const	$push50=, 214
	i32.ne  	$push51=, $10, $pop50
	br_if   	0, $pop51       # 0: down to label1
# BB#24:                                # %verify.exit45
	i32.const	$push52=, 0
	i32.const	$push206=, 0
	i32.sub 	$push205=, $pop206, $0
	tee_local	$push204=, $11=, $pop205
	i32.store	res($pop52), $pop204
	i32.const	$push203=, 0
	i32.store	k($pop203), $11
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.sub 	$push200=, $pop201, $1
	tee_local	$push199=, $8=, $pop200
	i32.store	res+4($pop202), $pop199
	i32.const	$push198=, 0
	i32.store	k+4($pop198), $8
	i32.const	$push197=, 0
	i32.const	$push196=, 0
	i32.sub 	$push195=, $pop196, $2
	tee_local	$push194=, $9=, $pop195
	i32.store	res+8($pop197), $pop194
	i32.const	$push193=, 0
	i32.store	k+8($pop193), $9
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.sub 	$push190=, $pop191, $3
	tee_local	$push189=, $10=, $pop190
	i32.store	res+12($pop192), $pop189
	i32.const	$push188=, 0
	i32.store	k+12($pop188), $10
	i32.const	$push53=, -150
	i32.ne  	$push54=, $11, $pop53
	br_if   	0, $pop54       # 0: down to label1
# BB#25:                                # %verify.exit45
	i32.const	$push55=, -100
	i32.ne  	$push56=, $8, $pop55
	br_if   	0, $pop56       # 0: down to label1
# BB#26:                                # %verify.exit45
	i32.const	$push57=, -150
	i32.ne  	$push58=, $9, $pop57
	br_if   	0, $pop58       # 0: down to label1
# BB#27:                                # %verify.exit45
	i32.const	$push59=, -200
	i32.ne  	$push60=, $10, $pop59
	br_if   	0, $pop60       # 0: down to label1
# BB#28:                                # %verify.exit54
	i32.const	$push62=, 0
	i32.const	$push61=, -1
	i32.xor 	$push224=, $0, $pop61
	tee_local	$push223=, $11=, $pop224
	i32.store	res($pop62), $pop223
	i32.const	$push222=, 0
	i32.store	k($pop222), $11
	i32.const	$push221=, 0
	i32.const	$push220=, -1
	i32.xor 	$push219=, $1, $pop220
	tee_local	$push218=, $11=, $pop219
	i32.store	res+4($pop221), $pop218
	i32.const	$push217=, 0
	i32.store	k+4($pop217), $11
	i32.const	$push216=, 0
	i32.const	$push215=, -1
	i32.xor 	$push214=, $2, $pop215
	tee_local	$push213=, $8=, $pop214
	i32.store	res+8($pop216), $pop213
	i32.const	$push212=, 0
	i32.store	k+8($pop212), $8
	i32.const	$push211=, 0
	i32.const	$push210=, -1
	i32.xor 	$push209=, $3, $pop210
	tee_local	$push208=, $9=, $pop209
	i32.store	res+12($pop211), $pop208
	i32.const	$push207=, 0
	i32.store	k+12($pop207), $9
	i32.const	$push63=, 150
	i32.ne  	$push64=, $0, $pop63
	br_if   	0, $pop64       # 0: down to label1
# BB#29:                                # %verify.exit54
	i32.const	$push65=, -101
	i32.ne  	$push66=, $11, $pop65
	br_if   	0, $pop66       # 0: down to label1
# BB#30:                                # %verify.exit54
	i32.const	$push67=, -151
	i32.ne  	$push68=, $8, $pop67
	br_if   	0, $pop68       # 0: down to label1
# BB#31:                                # %verify.exit54
	i32.const	$push69=, -201
	i32.ne  	$push70=, $9, $pop69
	br_if   	0, $pop70       # 0: down to label1
# BB#32:                                # %verify.exit63
	i32.const	$push71=, 0
	call    	exit@FUNCTION, $pop71
	unreachable
.LBB1_33:                               # %if.then.i
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
