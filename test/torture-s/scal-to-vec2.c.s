	.text
	.file	"scal-to-vec2.c"
	.section	.text.vlng,"ax",@progbits
	.hidden	vlng                    # -- Begin function vlng
	.globl	vlng
	.type	vlng,@function
vlng:                                   # @vlng
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	i32.const	$push114=, 0
	i32.load	$push113=, __stack_pointer($pop114)
	i32.const	$push115=, 48
	i32.sub 	$3=, $pop113, $pop115
	i32.const	$push116=, 0
	i32.store	__stack_pointer($pop116), $3
	i32.const	$push129=, 7
	i32.store8	47($3), $pop129
	i32.const	$push14=, 1541
	i32.store16	45($3):p2align=0, $pop14
	i32.store8	40($3), $0
	i32.const	$push15=, 67305985
	i32.store	41($3):p2align=0, $pop15
	i32.const	$push128=, 7
	i32.store8	39($3), $pop128
	i32.const	$push127=, 1541
	i32.store16	37($3):p2align=0, $pop127
	i32.store8	32($3), $0
	i32.const	$push126=, 67305985
	i32.store	33($3):p2align=0, $pop126
	i32.const	$push125=, 7
	i32.store16	30($3), $pop125
	i32.const	$push16=, 393221
	i32.store	26($3):p2align=1, $pop16
	i32.store16	16($3), $0
	i64.const	$push17=, 1125912791875585
	i64.store	18($3):p2align=1, $pop17
	i32.const	$push124=, 3
	i32.store	12($3), $pop124
	i64.const	$push18=, 8589934593
	i64.store	4($3):p2align=2, $pop18
	i32.store	0($3), $0
	i32.const	$push19=, 42
	i32.add 	$2=, $0, $pop19
	block   	
	i32.const	$push20=, 24
	i32.shl 	$push23=, $0, $pop20
	i32.const	$push123=, 24
	i32.shr_s	$push24=, $pop23, $pop123
	i32.const	$push122=, 42
	i32.add 	$push25=, $pop24, $pop122
	i32.const	$push121=, 24
	i32.shl 	$push21=, $2, $pop121
	i32.const	$push120=, 24
	i32.shr_s	$push22=, $pop21, $pop120
	i32.ne  	$push26=, $pop25, $pop22
	br_if   	0, $pop26       # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push131=, 43
	i32.const	$push130=, 43
	i32.ne  	$push30=, $pop131, $pop130
	br_if   	0, $pop30       # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push133=, 44
	i32.const	$push132=, 44
	i32.ne  	$push31=, $pop133, $pop132
	br_if   	0, $pop31       # 0: down to label0
# %bb.3:                                # %entry
	i32.const	$push135=, 45
	i32.const	$push134=, 45
	i32.ne  	$push32=, $pop135, $pop134
	br_if   	0, $pop32       # 0: down to label0
# %bb.4:                                # %entry
	i32.const	$push137=, 46
	i32.const	$push136=, 46
	i32.ne  	$push33=, $pop137, $pop136
	br_if   	0, $pop33       # 0: down to label0
# %bb.5:                                # %entry
	i32.const	$push139=, 47
	i32.const	$push138=, 47
	i32.ne  	$push34=, $pop139, $pop138
	br_if   	0, $pop34       # 0: down to label0
# %bb.6:                                # %entry
	i32.const	$push141=, 48
	i32.const	$push140=, 48
	i32.ne  	$push35=, $pop141, $pop140
	br_if   	0, $pop35       # 0: down to label0
# %bb.7:                                # %entry
	i32.const	$push143=, 49
	i32.const	$push142=, 49
	i32.ne  	$push36=, $pop143, $pop142
	br_if   	0, $pop36       # 0: down to label0
# %bb.8:                                # %for.cond.7
	i32.const	$push37=, 24
	i32.shl 	$push38=, $0, $pop37
	i32.const	$push146=, 24
	i32.shr_s	$push39=, $pop38, $pop146
	i32.const	$push40=, 42
	i32.add 	$push41=, $pop39, $pop40
	i32.const	$push145=, 24
	i32.shl 	$push42=, $2, $pop145
	i32.const	$push144=, 24
	i32.shr_s	$push43=, $pop42, $pop144
	i32.ne  	$push44=, $pop41, $pop43
	br_if   	0, $pop44       # 0: down to label0
# %bb.9:                                # %for.cond.7
	i32.const	$push147=, 43
	i32.const	$push45=, 43
	i32.ne  	$push46=, $pop147, $pop45
	br_if   	0, $pop46       # 0: down to label0
# %bb.10:                               # %for.cond.7
	i32.const	$push148=, 44
	i32.const	$push47=, 44
	i32.ne  	$push48=, $pop148, $pop47
	br_if   	0, $pop48       # 0: down to label0
# %bb.11:                               # %for.cond.7
	i32.const	$push149=, 45
	i32.const	$push49=, 45
	i32.ne  	$push50=, $pop149, $pop49
	br_if   	0, $pop50       # 0: down to label0
# %bb.12:                               # %for.cond.11
	i32.load8_s	$push51=, 44($3)
	i32.const	$push151=, 42
	i32.add 	$push52=, $pop51, $pop151
	i32.const	$push150=, 46
	i32.ne  	$push53=, $pop52, $pop150
	br_if   	0, $pop53       # 0: down to label0
# %bb.13:                               # %for.cond.12
	i32.load8_s	$push54=, 45($3)
	i32.const	$push153=, 42
	i32.add 	$push55=, $pop54, $pop153
	i32.const	$push152=, 47
	i32.ne  	$push56=, $pop55, $pop152
	br_if   	0, $pop56       # 0: down to label0
# %bb.14:                               # %for.cond.13
	i32.load8_s	$push57=, 46($3)
	i32.const	$push155=, 42
	i32.add 	$push58=, $pop57, $pop155
	i32.const	$push154=, 48
	i32.ne  	$push59=, $pop58, $pop154
	br_if   	0, $pop59       # 0: down to label0
# %bb.15:                               # %for.cond.14
	i32.load8_s	$push60=, 47($3)
	i32.const	$push157=, 42
	i32.add 	$push61=, $pop60, $pop157
	i32.const	$push156=, 49
	i32.ne  	$push62=, $pop61, $pop156
	br_if   	0, $pop62       # 0: down to label0
# %bb.16:                               # %for.cond.15
	i32.const	$push27=, 65535
	i32.and 	$push28=, $0, $pop27
	i32.const	$push29=, 65536
	i32.or  	$push3=, $pop28, $pop29
	i32.const	$push64=, 16
	i32.shl 	$push67=, $pop3, $pop64
	i32.const	$push162=, 16
	i32.shr_s	$push68=, $pop67, $pop162
	i32.const	$push161=, 42
	i32.add 	$push69=, $pop68, $pop161
	i32.const	$push160=, 42
	i32.add 	$push7=, $0, $pop160
	i32.const	$push159=, 16
	i32.shl 	$push65=, $pop7, $pop159
	i32.const	$push158=, 16
	i32.shr_s	$push66=, $pop65, $pop158
	i32.ne  	$push70=, $pop69, $pop66
	br_if   	0, $pop70       # 0: down to label0
# %bb.17:                               # %for.cond.15
	i32.const	$push164=, 1
	i32.const	$push163=, 42
	i32.or  	$push63=, $pop164, $pop163
	i32.const	$push71=, 43
	i32.ne  	$push72=, $pop63, $pop71
	br_if   	0, $pop72       # 0: down to label0
# %bb.18:                               # %for.cond.15
	i32.const	$push166=, 2
	i32.const	$push165=, 42
	i32.add 	$push8=, $pop166, $pop165
	i32.const	$push73=, 44
	i32.ne  	$push74=, $pop8, $pop73
	br_if   	0, $pop74       # 0: down to label0
# %bb.19:                               # %for.cond.15
	i32.const	$push168=, 3
	i32.const	$push167=, 42
	i32.add 	$push9=, $pop168, $pop167
	i32.const	$push75=, 45
	i32.ne  	$push76=, $pop9, $pop75
	br_if   	0, $pop76       # 0: down to label0
# %bb.20:                               # %for.cond.15
	i32.const	$push0=, 4
	i32.const	$push169=, 42
	i32.add 	$push10=, $pop0, $pop169
	i32.const	$push77=, 46
	i32.ne  	$push78=, $pop10, $pop77
	br_if   	0, $pop78       # 0: down to label0
# %bb.21:                               # %for.cond.15
	i32.const	$push1=, 5
	i32.const	$push170=, 42
	i32.add 	$push11=, $pop1, $pop170
	i32.const	$push79=, 47
	i32.ne  	$push80=, $pop11, $pop79
	br_if   	0, $pop80       # 0: down to label0
# %bb.22:                               # %for.cond47.5
	i32.load16_s	$push81=, 28($3)
	i32.const	$push172=, 42
	i32.add 	$push82=, $pop81, $pop172
	i32.const	$push2=, 6
	i32.const	$push171=, 42
	i32.add 	$push12=, $pop2, $pop171
	i32.ne  	$push83=, $pop82, $pop12
	br_if   	0, $pop83       # 0: down to label0
# %bb.23:                               # %for.cond47.6
	i32.load16_s	$push84=, 30($3)
	i32.const	$push175=, 42
	i32.add 	$push85=, $pop84, $pop175
	i32.const	$push174=, 7
	i32.const	$push173=, 42
	i32.add 	$push13=, $pop174, $pop173
	i32.ne  	$push86=, $pop85, $pop13
	br_if   	0, $pop86       # 0: down to label0
# %bb.24:                               # %for.cond74.7
	i32.const	$push176=, 43
	i32.mul 	$2=, $0, $pop176
	i32.ne  	$push87=, $2, $2
	br_if   	0, $pop87       # 0: down to label0
# %bb.25:                               # %for.cond74.7
	i32.const	$push179=, 1
	i32.const	$push178=, 43
	i32.mul 	$push4=, $pop179, $pop178
	i32.const	$push177=, 43
	i32.ne  	$push88=, $pop4, $pop177
	br_if   	0, $pop88       # 0: down to label0
# %bb.26:                               # %for.cond74.7
	i32.const	$push181=, 2
	i32.const	$push180=, 43
	i32.mul 	$push5=, $pop181, $pop180
	i32.const	$push89=, 86
	i32.ne  	$push90=, $pop5, $pop89
	br_if   	0, $pop90       # 0: down to label0
# %bb.27:                               # %for.cond99.2
	i32.load	$2=, 12($3)
	i32.const	$push183=, 3
	i32.const	$push182=, 43
	i32.mul 	$push6=, $pop183, $pop182
	i32.const	$push91=, 43
	i32.mul 	$push92=, $2, $pop91
	i32.ne  	$push93=, $pop6, $pop92
	br_if   	0, $pop93       # 0: down to label0
# %bb.28:                               # %for.cond99.3
	i32.load	$push99=, 0($3)
	i32.const	$push185=, 42
	i32.mul 	$push100=, $pop99, $pop185
	i32.const	$push184=, 42
	i32.mul 	$push98=, $0, $pop184
	i32.ne  	$push101=, $pop100, $pop98
	br_if   	0, $pop101      # 0: down to label0
# %bb.29:                               # %for.cond99.3
	i32.const	$push188=, 1
	i32.const	$push187=, 42
	i32.mul 	$push94=, $pop188, $pop187
	i32.const	$push186=, 42
	i32.ne  	$push102=, $pop94, $pop186
	br_if   	0, $pop102      # 0: down to label0
# %bb.30:                               # %for.cond99.3
	i32.const	$push190=, 2
	i32.const	$push189=, 42
	i32.mul 	$push95=, $pop190, $pop189
	i32.const	$push103=, 84
	i32.ne  	$push104=, $pop95, $pop103
	br_if   	0, $pop104      # 0: down to label0
# %bb.31:                               # %for.cond99.3
	i32.const	$push193=, 3
	i32.const	$push192=, 42
	i32.mul 	$push96=, $pop193, $pop192
	i32.const	$push191=, 42
	i32.mul 	$push97=, $2, $pop191
	i32.ne  	$push105=, $pop96, $pop97
	br_if   	0, $pop105      # 0: down to label0
# %bb.32:                               # %for.cond148.3
	i32.const	$push194=, 42
	i32.mul 	$2=, $0, $pop194
	i32.ne  	$push107=, $2, $2
	br_if   	0, $pop107      # 0: down to label0
# %bb.33:                               # %for.cond148.3
	i32.const	$push197=, 1
	i32.const	$push196=, 42
	i32.mul 	$push106=, $pop197, $pop196
	i32.const	$push195=, 42
	i32.ne  	$push108=, $pop106, $pop195
	br_if   	0, $pop108      # 0: down to label0
# %bb.34:                               # %for.cond172.1
	i32.const	$push198=, 43
	i32.mul 	$0=, $0, $pop198
	i32.ne  	$push110=, $0, $0
	br_if   	0, $pop110      # 0: down to label0
# %bb.35:                               # %for.cond172.1
	i32.const	$push201=, 1
	i32.const	$push200=, 43
	i32.mul 	$push109=, $pop201, $pop200
	i32.const	$push199=, 43
	i32.ne  	$push111=, $pop109, $pop199
	br_if   	0, $pop111      # 0: down to label0
# %bb.36:                               # %for.cond244.1
	i32.const	$push119=, 0
	i32.const	$push117=, 48
	i32.add 	$push118=, $3, $pop117
	i32.store	__stack_pointer($pop119), $pop118
	i32.const	$push112=, 0
	return  	$pop112
.LBB4_37:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
