	.text
	.file	"scal-to-vec2.c"
	.section	.text.vlng,"ax",@progbits
	.hidden	vlng                    # -- Begin function vlng
	.globl	vlng
	.type	vlng,@function
vlng:                                   # @vlng
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 42
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	vlng, .Lfunc_end0-vlng
                                        # -- End function
	.section	.text.vint,"ax",@progbits
	.hidden	vint                    # -- Begin function vint
	.globl	vint
	.type	vint,@function
vint:                                   # @vint
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 43
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	vint, .Lfunc_end1-vint
                                        # -- End function
	.section	.text.vsrt,"ax",@progbits
	.hidden	vsrt                    # -- Begin function vsrt
	.globl	vsrt
	.type	vsrt,@function
vsrt:                                   # @vsrt
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 42
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	vsrt, .Lfunc_end2-vsrt
                                        # -- End function
	.section	.text.vchr,"ax",@progbits
	.hidden	vchr                    # -- Begin function vchr
	.globl	vchr
	.type	vchr,@function
vchr:                                   # @vchr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 42
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	vchr, .Lfunc_end3-vchr
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push108=, 0
	i32.const	$push106=, 0
	i32.load	$push105=, __stack_pointer($pop106)
	i32.const	$push107=, 48
	i32.sub 	$push143=, $pop105, $pop107
	tee_local	$push142=, $3=, $pop143
	i32.store	__stack_pointer($pop108), $pop142
	i32.const	$push141=, 7
	i32.store8	47($3), $pop141
	i32.const	$push140=, 6
	i32.store8	46($3), $pop140
	i32.const	$push139=, 5
	i32.store8	45($3), $pop139
	i32.const	$push138=, 4
	i32.store8	44($3), $pop138
	i32.const	$push137=, 3
	i32.store8	43($3), $pop137
	i32.const	$push136=, 2
	i32.store8	42($3), $pop136
	i32.const	$push135=, 1
	i32.store8	41($3), $pop135
	i32.store8	40($3), $0
	i32.const	$push134=, 7
	i32.store8	39($3), $pop134
	i32.const	$push133=, 6
	i32.store8	38($3), $pop133
	i32.const	$push132=, 5
	i32.store8	37($3), $pop132
	i32.const	$push131=, 4
	i32.store8	36($3), $pop131
	i32.const	$push130=, 3
	i32.store8	35($3), $pop130
	i32.const	$push129=, 2
	i32.store8	34($3), $pop129
	i32.const	$push128=, 1
	i32.store8	33($3), $pop128
	i32.store8	32($3), $0
	i32.const	$push127=, 7
	i32.store16	30($3), $pop127
	i32.const	$push126=, 6
	i32.store16	28($3), $pop126
	i32.const	$push125=, 5
	i32.store16	26($3), $pop125
	i32.const	$push124=, 4
	i32.store16	24($3), $pop124
	i32.const	$push123=, 3
	i32.store16	22($3), $pop123
	i32.const	$push122=, 2
	i32.store16	20($3), $pop122
	i32.const	$push121=, 1
	i32.store16	18($3), $pop121
	i32.store16	16($3), $0
	i32.const	$push120=, 3
	i32.store	12($3), $pop120
	i32.const	$push119=, 2
	i32.store	8($3), $pop119
	i32.const	$push118=, 1
	i32.store	4($3), $pop118
	i32.store	0($3), $0
	block   	
	i32.const	$push12=, 24
	i32.shl 	$push15=, $0, $pop12
	i32.const	$push117=, 24
	i32.shr_s	$push16=, $pop15, $pop117
	i32.const	$push11=, 42
	i32.add 	$push17=, $pop16, $pop11
	i32.const	$push116=, 42
	i32.add 	$push115=, $0, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 24
	i32.shl 	$push13=, $pop114, $pop113
	i32.const	$push112=, 24
	i32.shr_s	$push14=, $pop13, $pop112
	i32.ne  	$push18=, $pop17, $pop14
	br_if   	0, $pop18       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push145=, 43
	i32.const	$push144=, 43
	i32.ne  	$push22=, $pop145, $pop144
	br_if   	0, $pop22       # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push147=, 44
	i32.const	$push146=, 44
	i32.ne  	$push23=, $pop147, $pop146
	br_if   	0, $pop23       # 0: down to label0
# BB#3:                                 # %entry
	i32.const	$push149=, 45
	i32.const	$push148=, 45
	i32.ne  	$push24=, $pop149, $pop148
	br_if   	0, $pop24       # 0: down to label0
# BB#4:                                 # %entry
	i32.const	$push151=, 46
	i32.const	$push150=, 46
	i32.ne  	$push25=, $pop151, $pop150
	br_if   	0, $pop25       # 0: down to label0
# BB#5:                                 # %entry
	i32.const	$push153=, 47
	i32.const	$push152=, 47
	i32.ne  	$push26=, $pop153, $pop152
	br_if   	0, $pop26       # 0: down to label0
# BB#6:                                 # %entry
	i32.const	$push155=, 48
	i32.const	$push154=, 48
	i32.ne  	$push27=, $pop155, $pop154
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %entry
	i32.const	$push157=, 49
	i32.const	$push156=, 49
	i32.ne  	$push28=, $pop157, $pop156
	br_if   	0, $pop28       # 0: down to label0
# BB#8:                                 # %for.cond.7
	i32.const	$push29=, 24
	i32.shl 	$push30=, $0, $pop29
	i32.const	$push160=, 24
	i32.shr_s	$push31=, $pop30, $pop160
	i32.const	$push32=, 42
	i32.add 	$push33=, $pop31, $pop32
	i32.const	$push159=, 24
	i32.shl 	$push34=, $2, $pop159
	i32.const	$push158=, 24
	i32.shr_s	$push35=, $pop34, $pop158
	i32.ne  	$push36=, $pop33, $pop35
	br_if   	0, $pop36       # 0: down to label0
# BB#9:                                 # %for.cond.7
	i32.const	$push161=, 43
	i32.const	$push37=, 43
	i32.ne  	$push38=, $pop161, $pop37
	br_if   	0, $pop38       # 0: down to label0
# BB#10:                                # %for.cond.7
	i32.const	$push162=, 44
	i32.const	$push39=, 44
	i32.ne  	$push40=, $pop162, $pop39
	br_if   	0, $pop40       # 0: down to label0
# BB#11:                                # %for.cond.7
	i32.const	$push163=, 45
	i32.const	$push41=, 45
	i32.ne  	$push42=, $pop163, $pop41
	br_if   	0, $pop42       # 0: down to label0
# BB#12:                                # %for.cond.11
	i32.load8_s	$push43=, 44($3)
	i32.const	$push165=, 42
	i32.add 	$push44=, $pop43, $pop165
	i32.const	$push164=, 46
	i32.ne  	$push45=, $pop44, $pop164
	br_if   	0, $pop45       # 0: down to label0
# BB#13:                                # %for.cond.12
	i32.load8_s	$push46=, 45($3)
	i32.const	$push167=, 42
	i32.add 	$push47=, $pop46, $pop167
	i32.const	$push166=, 47
	i32.ne  	$push48=, $pop47, $pop166
	br_if   	0, $pop48       # 0: down to label0
# BB#14:                                # %for.cond.13
	i32.load8_s	$push49=, 46($3)
	i32.const	$push169=, 42
	i32.add 	$push50=, $pop49, $pop169
	i32.const	$push168=, 48
	i32.ne  	$push51=, $pop50, $pop168
	br_if   	0, $pop51       # 0: down to label0
# BB#15:                                # %for.cond.14
	i32.load8_s	$push52=, 47($3)
	i32.const	$push171=, 42
	i32.add 	$push53=, $pop52, $pop171
	i32.const	$push170=, 49
	i32.ne  	$push54=, $pop53, $pop170
	br_if   	0, $pop54       # 0: down to label0
# BB#16:                                # %for.cond.15
	i32.const	$push19=, 65535
	i32.and 	$push20=, $0, $pop19
	i32.const	$push21=, 65536
	i32.or  	$push0=, $pop20, $pop21
	i32.const	$push56=, 16
	i32.shl 	$push59=, $pop0, $pop56
	i32.const	$push176=, 16
	i32.shr_s	$push60=, $pop59, $pop176
	i32.const	$push175=, 42
	i32.add 	$push61=, $pop60, $pop175
	i32.const	$push174=, 42
	i32.add 	$push4=, $0, $pop174
	i32.const	$push173=, 16
	i32.shl 	$push57=, $pop4, $pop173
	i32.const	$push172=, 16
	i32.shr_s	$push58=, $pop57, $pop172
	i32.ne  	$push62=, $pop61, $pop58
	br_if   	0, $pop62       # 0: down to label0
# BB#17:                                # %for.cond.15
	i32.const	$push178=, 1
	i32.const	$push177=, 42
	i32.or  	$push55=, $pop178, $pop177
	i32.const	$push63=, 43
	i32.ne  	$push64=, $pop55, $pop63
	br_if   	0, $pop64       # 0: down to label0
# BB#18:                                # %for.cond.15
	i32.const	$push180=, 2
	i32.const	$push179=, 42
	i32.add 	$push5=, $pop180, $pop179
	i32.const	$push65=, 44
	i32.ne  	$push66=, $pop5, $pop65
	br_if   	0, $pop66       # 0: down to label0
# BB#19:                                # %for.cond.15
	i32.const	$push182=, 3
	i32.const	$push181=, 42
	i32.add 	$push6=, $pop182, $pop181
	i32.const	$push67=, 45
	i32.ne  	$push68=, $pop6, $pop67
	br_if   	0, $pop68       # 0: down to label0
# BB#20:                                # %for.cond.15
	i32.const	$push184=, 4
	i32.const	$push183=, 42
	i32.add 	$push7=, $pop184, $pop183
	i32.const	$push69=, 46
	i32.ne  	$push70=, $pop7, $pop69
	br_if   	0, $pop70       # 0: down to label0
# BB#21:                                # %for.cond.15
	i32.const	$push186=, 5
	i32.const	$push185=, 42
	i32.add 	$push8=, $pop186, $pop185
	i32.const	$push71=, 47
	i32.ne  	$push72=, $pop8, $pop71
	br_if   	0, $pop72       # 0: down to label0
# BB#22:                                # %for.cond47.5
	i32.load16_s	$push73=, 28($3)
	i32.const	$push189=, 42
	i32.add 	$push74=, $pop73, $pop189
	i32.const	$push188=, 6
	i32.const	$push187=, 42
	i32.add 	$push9=, $pop188, $pop187
	i32.ne  	$push75=, $pop74, $pop9
	br_if   	0, $pop75       # 0: down to label0
# BB#23:                                # %for.cond47.6
	i32.load16_s	$push76=, 30($3)
	i32.const	$push192=, 42
	i32.add 	$push77=, $pop76, $pop192
	i32.const	$push191=, 7
	i32.const	$push190=, 42
	i32.add 	$push10=, $pop191, $pop190
	i32.ne  	$push78=, $pop77, $pop10
	br_if   	0, $pop78       # 0: down to label0
# BB#24:                                # %for.cond74.7
	i32.const	$push195=, 43
	i32.mul 	$push194=, $0, $pop195
	tee_local	$push193=, $2=, $pop194
	i32.ne  	$push79=, $pop193, $2
	br_if   	0, $pop79       # 0: down to label0
# BB#25:                                # %for.cond74.7
	i32.const	$push198=, 1
	i32.const	$push197=, 43
	i32.mul 	$push1=, $pop198, $pop197
	i32.const	$push196=, 43
	i32.ne  	$push80=, $pop1, $pop196
	br_if   	0, $pop80       # 0: down to label0
# BB#26:                                # %for.cond74.7
	i32.const	$push200=, 2
	i32.const	$push199=, 43
	i32.mul 	$push2=, $pop200, $pop199
	i32.const	$push81=, 86
	i32.ne  	$push82=, $pop2, $pop81
	br_if   	0, $pop82       # 0: down to label0
# BB#27:                                # %for.cond99.2
	i32.const	$push204=, 3
	i32.const	$push203=, 43
	i32.mul 	$push3=, $pop204, $pop203
	i32.load	$push202=, 12($3)
	tee_local	$push201=, $2=, $pop202
	i32.const	$push83=, 43
	i32.mul 	$push84=, $pop201, $pop83
	i32.ne  	$push85=, $pop3, $pop84
	br_if   	0, $pop85       # 0: down to label0
# BB#28:                                # %for.cond99.3
	i32.load	$push91=, 0($3)
	i32.const	$push206=, 42
	i32.mul 	$push92=, $pop91, $pop206
	i32.const	$push205=, 42
	i32.mul 	$push90=, $0, $pop205
	i32.ne  	$push93=, $pop92, $pop90
	br_if   	0, $pop93       # 0: down to label0
# BB#29:                                # %for.cond99.3
	i32.const	$push209=, 1
	i32.const	$push208=, 42
	i32.mul 	$push86=, $pop209, $pop208
	i32.const	$push207=, 42
	i32.ne  	$push94=, $pop86, $pop207
	br_if   	0, $pop94       # 0: down to label0
# BB#30:                                # %for.cond99.3
	i32.const	$push211=, 2
	i32.const	$push210=, 42
	i32.mul 	$push87=, $pop211, $pop210
	i32.const	$push95=, 84
	i32.ne  	$push96=, $pop87, $pop95
	br_if   	0, $pop96       # 0: down to label0
# BB#31:                                # %for.cond99.3
	i32.const	$push214=, 3
	i32.const	$push213=, 42
	i32.mul 	$push88=, $pop214, $pop213
	i32.const	$push212=, 42
	i32.mul 	$push89=, $2, $pop212
	i32.ne  	$push97=, $pop88, $pop89
	br_if   	0, $pop97       # 0: down to label0
# BB#32:                                # %for.cond148.3
	i32.const	$push217=, 42
	i32.mul 	$push216=, $0, $pop217
	tee_local	$push215=, $2=, $pop216
	i32.ne  	$push99=, $pop215, $2
	br_if   	0, $pop99       # 0: down to label0
# BB#33:                                # %for.cond148.3
	i32.const	$push220=, 1
	i32.const	$push219=, 42
	i32.mul 	$push98=, $pop220, $pop219
	i32.const	$push218=, 42
	i32.ne  	$push100=, $pop98, $pop218
	br_if   	0, $pop100      # 0: down to label0
# BB#34:                                # %for.cond172.1
	i32.const	$push223=, 43
	i32.mul 	$push222=, $0, $pop223
	tee_local	$push221=, $0=, $pop222
	i32.ne  	$push102=, $pop221, $0
	br_if   	0, $pop102      # 0: down to label0
# BB#35:                                # %for.cond172.1
	i32.const	$push226=, 1
	i32.const	$push225=, 43
	i32.mul 	$push101=, $pop226, $pop225
	i32.const	$push224=, 43
	i32.ne  	$push103=, $pop101, $pop224
	br_if   	0, $pop103      # 0: down to label0
# BB#36:                                # %for.cond244.1
	i32.const	$push111=, 0
	i32.const	$push109=, 48
	i32.add 	$push110=, $3, $pop109
	i32.store	__stack_pointer($pop111), $pop110
	i32.const	$push104=, 0
	return  	$pop104
.LBB4_37:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
