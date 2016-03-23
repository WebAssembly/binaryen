	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-chk-1.c"
	.section	.text.__fprintf_chk,"ax",@progbits
	.hidden	__fprintf_chk
	.globl	__fprintf_chk
	.type	__fprintf_chk,@function
__fprintf_chk:                          # @__fprintf_chk
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, __stack_pointer
	i32.load	$push7=, 0($pop6)
	i32.const	$push8=, 16
	i32.sub 	$4=, $pop7, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $4
	block
	i32.const	$push4=, 0
	i32.load	$push0=, should_optimize($pop4)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop5), $pop1
	i32.store	$push2=, 12($4), $3
	i32.call	$push3=, vfprintf@FUNCTION, $0, $2, $pop2
	i32.const	$push12=, __stack_pointer
	i32.const	$push10=, 16
	i32.add 	$push11=, $4, $pop10
	i32.store	$discard=, 0($pop12), $pop11
	return  	$pop3
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__fprintf_chk, .Lfunc_end0-__fprintf_chk

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push178=, __stack_pointer
	i32.load	$push179=, 0($pop178)
	i32.const	$push180=, 224
	i32.sub 	$3=, $pop179, $pop180
	i32.const	$push181=, __stack_pointer
	i32.store	$discard=, 0($pop181), $3
	i32.const	$push84=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, should_optimize($pop84), $pop0
	i32.const	$push83=, 0
	i32.load	$push1=, stdout($pop83)
	i32.const	$push82=, .L.str
	i32.const	$push81=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop1, $0, $pop82, $pop81
	block
	i32.const	$push80=, 0
	i32.load	$push2=, should_optimize($pop80)
	i32.const	$push211=, 0
	i32.eq  	$push212=, $pop2, $pop211
	br_if   	0, $pop212      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.store	$push87=, should_optimize($pop89), $pop88
	tee_local	$push86=, $0=, $pop87
	i32.load	$push3=, stdout($pop86)
	i32.const	$push85=, .L.str
	i32.call	$push4=, __fprintf_chk@FUNCTION, $pop3, $0, $pop85, $0
	i32.const	$push5=, 5
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push90=, 0
	i32.load	$push7=, should_optimize($pop90)
	i32.const	$push213=, 0
	i32.eq  	$push214=, $pop7, $pop213
	br_if   	0, $pop214      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push95=, 0
	i32.const	$push8=, 1
	i32.store	$discard=, should_optimize($pop95), $pop8
	i32.const	$push94=, 0
	i32.load	$push9=, stdout($pop94)
	i32.const	$push93=, .L.str.1
	i32.const	$push92=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop9, $0, $pop93, $pop92
	i32.const	$push91=, 0
	i32.load	$push10=, should_optimize($pop91)
	i32.const	$push215=, 0
	i32.eq  	$push216=, $pop10, $pop215
	br_if   	0, $pop216      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push11=, 0
	i32.const	$push99=, 0
	i32.store	$push98=, should_optimize($pop11), $pop99
	tee_local	$push97=, $0=, $pop98
	i32.load	$push12=, stdout($pop97)
	i32.const	$push96=, .L.str.1
	i32.call	$push13=, __fprintf_chk@FUNCTION, $pop12, $0, $pop96, $0
	i32.const	$push14=, 6
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push16=, should_optimize($0)
	i32.const	$push217=, 0
	i32.eq  	$push218=, $pop16, $pop217
	br_if   	0, $pop218      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push104=, 0
	i32.const	$push17=, 1
	i32.store	$0=, should_optimize($pop104), $pop17
	i32.const	$push103=, 0
	i32.load	$push18=, stdout($pop103)
	i32.const	$push102=, .L.str.2
	i32.const	$push101=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop18, $0, $pop102, $pop101
	i32.const	$push100=, 0
	i32.load	$push19=, should_optimize($pop100)
	i32.const	$push219=, 0
	i32.eq  	$push220=, $pop19, $pop219
	br_if   	0, $pop220      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.store	$push107=, should_optimize($pop109), $pop108
	tee_local	$push106=, $1=, $pop107
	i32.load	$push20=, stdout($pop106)
	i32.const	$push105=, .L.str.2
	i32.call	$push21=, __fprintf_chk@FUNCTION, $pop20, $0, $pop105, $1
	i32.ne  	$push22=, $pop21, $0
	br_if   	0, $pop22       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push110=, 0
	i32.load	$push23=, should_optimize($pop110)
	i32.const	$push221=, 0
	i32.eq  	$push222=, $pop23, $pop221
	br_if   	0, $pop222      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push115=, 0
	i32.const	$push24=, 1
	i32.store	$discard=, should_optimize($pop115), $pop24
	i32.const	$push114=, 0
	i32.load	$push25=, stdout($pop114)
	i32.const	$push113=, .L.str.3
	i32.const	$push112=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop25, $0, $pop113, $pop112
	i32.const	$push111=, 0
	i32.load	$push26=, should_optimize($pop111)
	i32.const	$push223=, 0
	i32.eq  	$push224=, $pop26, $pop223
	br_if   	0, $pop224      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push27=, 0
	i32.const	$push119=, 0
	i32.store	$push118=, should_optimize($pop27), $pop119
	tee_local	$push117=, $0=, $pop118
	i32.load	$push28=, stdout($pop117)
	i32.const	$push116=, .L.str.3
	i32.call	$push29=, __fprintf_chk@FUNCTION, $pop28, $0, $pop116, $0
	br_if   	0, $pop29       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push30=, should_optimize($0)
	i32.const	$push225=, 0
	i32.eq  	$push226=, $pop30, $pop225
	br_if   	0, $pop226      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push123=, 0
	i32.const	$push31=, 1
	i32.store	$discard=, should_optimize($pop123), $pop31
	i32.const	$push122=, 0
	i32.load	$0=, stdout($pop122)
	i32.const	$push32=, .L.str
	i32.store	$1=, 208($3):p2align=4, $pop32
	i32.const	$push121=, .L.str.4
	i32.const	$push185=, 208
	i32.add 	$push186=, $3, $pop185
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop121, $pop186
	i32.const	$push120=, 0
	i32.load	$push33=, should_optimize($pop120)
	i32.const	$push227=, 0
	i32.eq  	$push228=, $pop33, $pop227
	br_if   	0, $pop228      # 0: down to label1
# BB#13:                                # %if.end43
	i32.const	$push126=, 0
	i32.const	$push125=, 0
	i32.store	$push34=, should_optimize($pop126), $pop125
	i32.load	$0=, stdout($pop34)
	i32.store	$discard=, 192($3):p2align=4, $1
	i32.const	$push124=, .L.str.4
	i32.const	$push187=, 192
	i32.add 	$push188=, $3, $pop187
	i32.call	$push35=, __fprintf_chk@FUNCTION, $0, $0, $pop124, $pop188
	i32.const	$push36=, 5
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	0, $pop37       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push127=, 0
	i32.load	$push38=, should_optimize($pop127)
	i32.const	$push229=, 0
	i32.eq  	$push230=, $pop38, $pop229
	br_if   	0, $pop230      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push131=, 0
	i32.const	$push39=, 1
	i32.store	$discard=, should_optimize($pop131), $pop39
	i32.const	$push130=, 0
	i32.load	$0=, stdout($pop130)
	i32.const	$push40=, .L.str.1
	i32.store	$1=, 176($3):p2align=4, $pop40
	i32.const	$push129=, .L.str.4
	i32.const	$push189=, 176
	i32.add 	$push190=, $3, $pop189
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop129, $pop190
	i32.const	$push128=, 0
	i32.load	$push41=, should_optimize($pop128)
	i32.const	$push231=, 0
	i32.eq  	$push232=, $pop41, $pop231
	br_if   	0, $pop232      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push42=, 0
	i32.const	$push135=, 0
	i32.store	$push134=, should_optimize($pop42), $pop135
	tee_local	$push133=, $2=, $pop134
	i32.load	$0=, stdout($pop133)
	i32.store	$discard=, 160($3):p2align=4, $1
	i32.const	$push132=, .L.str.4
	i32.const	$push191=, 160
	i32.add 	$push192=, $3, $pop191
	i32.call	$push43=, __fprintf_chk@FUNCTION, $0, $0, $pop132, $pop192
	i32.const	$push44=, 6
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	0, $pop45       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push46=, should_optimize($2)
	i32.const	$push233=, 0
	i32.eq  	$push234=, $pop46, $pop233
	br_if   	0, $pop234      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push139=, 0
	i32.const	$push47=, 1
	i32.store	$1=, should_optimize($pop139), $pop47
	i32.const	$push138=, 0
	i32.load	$0=, stdout($pop138)
	i32.const	$push48=, .L.str.2
	i32.store	$2=, 144($3):p2align=4, $pop48
	i32.const	$push137=, .L.str.4
	i32.const	$push193=, 144
	i32.add 	$push194=, $3, $pop193
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop137, $pop194
	i32.const	$push136=, 0
	i32.load	$push49=, should_optimize($pop136)
	i32.const	$push235=, 0
	i32.eq  	$push236=, $pop49, $pop235
	br_if   	0, $pop236      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push142=, 0
	i32.const	$push141=, 0
	i32.store	$push50=, should_optimize($pop142), $pop141
	i32.load	$0=, stdout($pop50)
	i32.store	$discard=, 128($3):p2align=4, $2
	i32.const	$push140=, .L.str.4
	i32.const	$push195=, 128
	i32.add 	$push196=, $3, $pop195
	i32.call	$push51=, __fprintf_chk@FUNCTION, $0, $0, $pop140, $pop196
	i32.ne  	$push52=, $pop51, $1
	br_if   	0, $pop52       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push143=, 0
	i32.load	$push53=, should_optimize($pop143)
	i32.const	$push237=, 0
	i32.eq  	$push238=, $pop53, $pop237
	br_if   	0, $pop238      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push147=, 0
	i32.const	$push54=, 1
	i32.store	$discard=, should_optimize($pop147), $pop54
	i32.const	$push146=, 0
	i32.load	$0=, stdout($pop146)
	i32.const	$push55=, .L.str.3
	i32.store	$1=, 112($3):p2align=4, $pop55
	i32.const	$push145=, .L.str.4
	i32.const	$push197=, 112
	i32.add 	$push198=, $3, $pop197
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop145, $pop198
	i32.const	$push144=, 0
	i32.load	$push56=, should_optimize($pop144)
	i32.const	$push239=, 0
	i32.eq  	$push240=, $pop56, $pop239
	br_if   	0, $pop240      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push57=, 0
	i32.const	$push151=, 0
	i32.store	$push150=, should_optimize($pop57), $pop151
	tee_local	$push149=, $2=, $pop150
	i32.load	$0=, stdout($pop149)
	i32.store	$discard=, 96($3):p2align=4, $1
	i32.const	$push148=, .L.str.4
	i32.const	$push199=, 96
	i32.add 	$push200=, $3, $pop199
	i32.call	$push58=, __fprintf_chk@FUNCTION, $0, $0, $pop148, $pop200
	br_if   	0, $pop58       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push59=, should_optimize($2)
	i32.const	$push241=, 0
	i32.eq  	$push242=, $pop59, $pop241
	br_if   	0, $pop242      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push155=, 0
	i32.const	$push60=, 1
	i32.store	$1=, should_optimize($pop155), $pop60
	i32.const	$push154=, 0
	i32.load	$0=, stdout($pop154)
	i32.const	$push61=, 120
	i32.store	$2=, 80($3):p2align=4, $pop61
	i32.const	$push153=, .L.str.5
	i32.const	$push201=, 80
	i32.add 	$push202=, $3, $pop201
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $0, $pop153, $pop202
	i32.const	$push152=, 0
	i32.load	$push62=, should_optimize($pop152)
	i32.const	$push243=, 0
	i32.eq  	$push244=, $pop62, $pop243
	br_if   	0, $pop244      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.store	$push63=, should_optimize($pop158), $pop157
	i32.load	$0=, stdout($pop63)
	i32.store	$discard=, 64($3):p2align=4, $2
	i32.const	$push156=, .L.str.5
	i32.const	$push203=, 64
	i32.add 	$push204=, $3, $pop203
	i32.call	$push64=, __fprintf_chk@FUNCTION, $0, $0, $pop156, $pop204
	i32.ne  	$push65=, $pop64, $1
	br_if   	0, $pop65       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push159=, 0
	i32.load	$push66=, should_optimize($pop159)
	i32.const	$push245=, 0
	i32.eq  	$push246=, $pop66, $pop245
	br_if   	0, $pop246      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.store	$push162=, should_optimize($pop164), $pop163
	tee_local	$push161=, $0=, $pop162
	i32.load	$1=, stdout($pop161)
	i32.const	$push67=, .L.str.1
	i32.store	$2=, 48($3):p2align=4, $pop67
	i32.const	$push160=, .L.str.6
	i32.const	$push205=, 48
	i32.add 	$push206=, $3, $pop205
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop160, $pop206
	i32.load	$push68=, should_optimize($0)
	i32.const	$push247=, 0
	i32.eq  	$push248=, $pop68, $pop247
	br_if   	0, $pop248      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push69=, 0
	i32.const	$push168=, 0
	i32.store	$push167=, should_optimize($pop69), $pop168
	tee_local	$push166=, $1=, $pop167
	i32.load	$0=, stdout($pop166)
	i32.store	$discard=, 32($3):p2align=4, $2
	i32.const	$push165=, .L.str.6
	i32.const	$push207=, 32
	i32.add 	$push208=, $3, $pop207
	i32.call	$push70=, __fprintf_chk@FUNCTION, $0, $0, $pop165, $pop208
	i32.const	$push71=, 7
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push73=, should_optimize($1)
	i32.const	$push249=, 0
	i32.eq  	$push250=, $pop73, $pop249
	br_if   	0, $pop250      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push74=, 0
	i32.const	$push172=, 0
	i32.store	$push171=, should_optimize($pop74), $pop172
	tee_local	$push170=, $0=, $pop171
	i32.load	$1=, stdout($pop170)
	i32.store	$discard=, 16($3):p2align=4, $0
	i32.const	$push169=, .L.str.7
	i32.const	$push209=, 16
	i32.add 	$push210=, $3, $pop209
	i32.call	$discard=, __fprintf_chk@FUNCTION, $1, $0, $pop169, $pop210
	i32.load	$push75=, should_optimize($0)
	i32.const	$push251=, 0
	i32.eq  	$push252=, $pop75, $pop251
	br_if   	0, $pop252      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push175=, should_optimize($0), $0
	tee_local	$push174=, $0=, $pop175
	i32.load	$1=, stdout($pop174)
	i32.store	$discard=, 0($3):p2align=4, $0
	i32.const	$push173=, .L.str.7
	i32.call	$push76=, __fprintf_chk@FUNCTION, $1, $0, $pop173, $3
	i32.const	$push77=, 2
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	0, $pop78       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push176=, 0
	i32.load	$push79=, should_optimize($pop176)
	i32.const	$push253=, 0
	i32.eq  	$push254=, $pop79, $pop253
	br_if   	0, $pop254      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push177=, 0
	i32.const	$push184=, __stack_pointer
	i32.const	$push182=, 224
	i32.add 	$push183=, $3, $pop182
	i32.store	$discard=, 0($pop184), $pop183
	return  	$pop177
.LBB1_34:                               # %if.then115
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	should_optimize         # @should_optimize
	.type	should_optimize,@object
	.section	.bss.should_optimize,"aw",@nobits
	.globl	should_optimize
	.p2align	2
should_optimize:
	.int32	0                       # 0x0
	.size	should_optimize, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 3.9.0 "
