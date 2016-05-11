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
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$4=, 0($pop6), $pop10
	block
	i32.const	$push11=, 0
	i32.load	$push1=, should_optimize($pop11)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, should_optimize($pop12), $pop2
	i32.store	$push0=, 12($4), $3
	i32.call	$0=, vfprintf@FUNCTION, $0, $2, $pop0
	i32.const	$push9=, __stack_pointer
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	$discard=, 0($pop9), $pop8
	return  	$0
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
	i32.const	$push83=, __stack_pointer
	i32.const	$push80=, __stack_pointer
	i32.load	$push81=, 0($pop80)
	i32.const	$push82=, 224
	i32.sub 	$push113=, $pop81, $pop82
	i32.store	$1=, 0($pop83), $pop113
	i32.const	$push118=, 0
	i32.const	$push3=, 1
	i32.store	$discard=, should_optimize($pop118), $pop3
	i32.const	$push117=, 0
	i32.load	$push4=, stdout($pop117)
	i32.const	$push116=, .L.str
	i32.const	$push115=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop4, $1, $pop116, $pop115
	block
	i32.const	$push114=, 0
	i32.load	$push5=, should_optimize($pop114)
	i32.const	$push212=, 0
	i32.eq  	$push213=, $pop5, $pop212
	br_if   	0, $pop213      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push123=, 0
	i32.const	$push122=, 0
	i32.store	$push121=, should_optimize($pop123), $pop122
	tee_local	$push120=, $0=, $pop121
	i32.load	$push6=, stdout($pop120)
	i32.const	$push119=, .L.str
	i32.call	$push7=, __fprintf_chk@FUNCTION, $pop6, $1, $pop119, $0
	i32.const	$push8=, 5
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push124=, 0
	i32.load	$push10=, should_optimize($pop124)
	i32.const	$push214=, 0
	i32.eq  	$push215=, $pop10, $pop214
	br_if   	0, $pop215      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push129=, 0
	i32.const	$push11=, 1
	i32.store	$discard=, should_optimize($pop129), $pop11
	i32.const	$push128=, 0
	i32.load	$push12=, stdout($pop128)
	i32.const	$push127=, .L.str.1
	i32.const	$push126=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop12, $1, $pop127, $pop126
	i32.const	$push125=, 0
	i32.load	$push13=, should_optimize($pop125)
	i32.const	$push216=, 0
	i32.eq  	$push217=, $pop13, $pop216
	br_if   	0, $pop217      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push14=, 0
	i32.const	$push133=, 0
	i32.store	$push132=, should_optimize($pop14), $pop133
	tee_local	$push131=, $0=, $pop132
	i32.load	$push15=, stdout($pop131)
	i32.const	$push130=, .L.str.1
	i32.call	$push16=, __fprintf_chk@FUNCTION, $pop15, $1, $pop130, $0
	i32.const	$push17=, 6
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push19=, should_optimize($0)
	i32.const	$push218=, 0
	i32.eq  	$push219=, $pop19, $pop218
	br_if   	0, $pop219      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push138=, 0
	i32.const	$push20=, 1
	i32.store	$0=, should_optimize($pop138), $pop20
	i32.const	$push137=, 0
	i32.load	$push21=, stdout($pop137)
	i32.const	$push136=, .L.str.2
	i32.const	$push135=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop21, $1, $pop136, $pop135
	i32.const	$push134=, 0
	i32.load	$push22=, should_optimize($pop134)
	i32.const	$push220=, 0
	i32.eq  	$push221=, $pop22, $pop220
	br_if   	0, $pop221      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.store	$push141=, should_optimize($pop143), $pop142
	tee_local	$push140=, $2=, $pop141
	i32.load	$push23=, stdout($pop140)
	i32.const	$push139=, .L.str.2
	i32.call	$push24=, __fprintf_chk@FUNCTION, $pop23, $1, $pop139, $2
	i32.ne  	$push25=, $pop24, $0
	br_if   	0, $pop25       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push144=, 0
	i32.load	$push26=, should_optimize($pop144)
	i32.const	$push222=, 0
	i32.eq  	$push223=, $pop26, $pop222
	br_if   	0, $pop223      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push149=, 0
	i32.const	$push27=, 1
	i32.store	$discard=, should_optimize($pop149), $pop27
	i32.const	$push148=, 0
	i32.load	$push28=, stdout($pop148)
	i32.const	$push147=, .L.str.3
	i32.const	$push146=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop28, $1, $pop147, $pop146
	i32.const	$push145=, 0
	i32.load	$push29=, should_optimize($pop145)
	i32.const	$push224=, 0
	i32.eq  	$push225=, $pop29, $pop224
	br_if   	0, $pop225      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push30=, 0
	i32.const	$push153=, 0
	i32.store	$push152=, should_optimize($pop30), $pop153
	tee_local	$push151=, $0=, $pop152
	i32.load	$push31=, stdout($pop151)
	i32.const	$push150=, .L.str.3
	i32.call	$push32=, __fprintf_chk@FUNCTION, $pop31, $1, $pop150, $0
	br_if   	0, $pop32       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push33=, should_optimize($0)
	i32.const	$push226=, 0
	i32.eq  	$push227=, $pop33, $pop226
	br_if   	0, $pop227      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push157=, 0
	i32.const	$push34=, 1
	i32.store	$discard=, should_optimize($pop157), $pop34
	i32.const	$push156=, 0
	i32.load	$0=, stdout($pop156)
	i32.const	$push35=, .L.str
	i32.store	$2=, 208($1), $pop35
	i32.const	$push155=, .L.str.4
	i32.const	$push87=, 208
	i32.add 	$push88=, $1, $pop87
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $1, $pop155, $pop88
	i32.const	$push154=, 0
	i32.load	$push36=, should_optimize($pop154)
	i32.const	$push228=, 0
	i32.eq  	$push229=, $pop36, $pop228
	br_if   	0, $pop229      # 0: down to label1
# BB#13:                                # %if.end43
	i32.const	$push160=, 0
	i32.const	$push159=, 0
	i32.store	$push0=, should_optimize($pop160), $pop159
	i32.load	$0=, stdout($pop0)
	i32.store	$discard=, 192($1), $2
	i32.const	$push158=, .L.str.4
	i32.const	$push89=, 192
	i32.add 	$push90=, $1, $pop89
	i32.call	$push37=, __fprintf_chk@FUNCTION, $0, $1, $pop158, $pop90
	i32.const	$push38=, 5
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push161=, 0
	i32.load	$push40=, should_optimize($pop161)
	i32.const	$push230=, 0
	i32.eq  	$push231=, $pop40, $pop230
	br_if   	0, $pop231      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push165=, 0
	i32.const	$push41=, 1
	i32.store	$discard=, should_optimize($pop165), $pop41
	i32.const	$push164=, 0
	i32.load	$0=, stdout($pop164)
	i32.const	$push42=, .L.str.1
	i32.store	$2=, 176($1), $pop42
	i32.const	$push163=, .L.str.4
	i32.const	$push91=, 176
	i32.add 	$push92=, $1, $pop91
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $1, $pop163, $pop92
	i32.const	$push162=, 0
	i32.load	$push43=, should_optimize($pop162)
	i32.const	$push232=, 0
	i32.eq  	$push233=, $pop43, $pop232
	br_if   	0, $pop233      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push44=, 0
	i32.const	$push169=, 0
	i32.store	$push168=, should_optimize($pop44), $pop169
	tee_local	$push167=, $3=, $pop168
	i32.load	$0=, stdout($pop167)
	i32.store	$discard=, 160($1), $2
	i32.const	$push166=, .L.str.4
	i32.const	$push93=, 160
	i32.add 	$push94=, $1, $pop93
	i32.call	$push45=, __fprintf_chk@FUNCTION, $0, $1, $pop166, $pop94
	i32.const	$push46=, 6
	i32.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push48=, should_optimize($3)
	i32.const	$push234=, 0
	i32.eq  	$push235=, $pop48, $pop234
	br_if   	0, $pop235      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push173=, 0
	i32.const	$push49=, 1
	i32.store	$0=, should_optimize($pop173), $pop49
	i32.const	$push172=, 0
	i32.load	$2=, stdout($pop172)
	i32.const	$push50=, .L.str.2
	i32.store	$3=, 144($1), $pop50
	i32.const	$push171=, .L.str.4
	i32.const	$push95=, 144
	i32.add 	$push96=, $1, $pop95
	i32.call	$discard=, __fprintf_chk@FUNCTION, $2, $1, $pop171, $pop96
	i32.const	$push170=, 0
	i32.load	$push51=, should_optimize($pop170)
	i32.const	$push236=, 0
	i32.eq  	$push237=, $pop51, $pop236
	br_if   	0, $pop237      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.store	$push1=, should_optimize($pop176), $pop175
	i32.load	$2=, stdout($pop1)
	i32.store	$discard=, 128($1), $3
	i32.const	$push174=, .L.str.4
	i32.const	$push97=, 128
	i32.add 	$push98=, $1, $pop97
	i32.call	$push52=, __fprintf_chk@FUNCTION, $2, $1, $pop174, $pop98
	i32.ne  	$push53=, $pop52, $0
	br_if   	0, $pop53       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push177=, 0
	i32.load	$push54=, should_optimize($pop177)
	i32.const	$push238=, 0
	i32.eq  	$push239=, $pop54, $pop238
	br_if   	0, $pop239      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push181=, 0
	i32.const	$push55=, 1
	i32.store	$discard=, should_optimize($pop181), $pop55
	i32.const	$push180=, 0
	i32.load	$0=, stdout($pop180)
	i32.const	$push56=, .L.str.3
	i32.store	$2=, 112($1), $pop56
	i32.const	$push179=, .L.str.4
	i32.const	$push99=, 112
	i32.add 	$push100=, $1, $pop99
	i32.call	$discard=, __fprintf_chk@FUNCTION, $0, $1, $pop179, $pop100
	i32.const	$push178=, 0
	i32.load	$push57=, should_optimize($pop178)
	i32.const	$push240=, 0
	i32.eq  	$push241=, $pop57, $pop240
	br_if   	0, $pop241      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push58=, 0
	i32.const	$push185=, 0
	i32.store	$push184=, should_optimize($pop58), $pop185
	tee_local	$push183=, $0=, $pop184
	i32.load	$3=, stdout($pop183)
	i32.store	$discard=, 96($1), $2
	i32.const	$push182=, .L.str.4
	i32.const	$push101=, 96
	i32.add 	$push102=, $1, $pop101
	i32.call	$push59=, __fprintf_chk@FUNCTION, $3, $1, $pop182, $pop102
	br_if   	0, $pop59       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push60=, should_optimize($0)
	i32.const	$push242=, 0
	i32.eq  	$push243=, $pop60, $pop242
	br_if   	0, $pop243      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push189=, 0
	i32.const	$push61=, 1
	i32.store	$0=, should_optimize($pop189), $pop61
	i32.const	$push188=, 0
	i32.load	$2=, stdout($pop188)
	i32.const	$push62=, 120
	i32.store	$3=, 80($1), $pop62
	i32.const	$push187=, .L.str.5
	i32.const	$push103=, 80
	i32.add 	$push104=, $1, $pop103
	i32.call	$discard=, __fprintf_chk@FUNCTION, $2, $1, $pop187, $pop104
	i32.const	$push186=, 0
	i32.load	$push63=, should_optimize($pop186)
	i32.const	$push244=, 0
	i32.eq  	$push245=, $pop63, $pop244
	br_if   	0, $pop245      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.store	$push2=, should_optimize($pop192), $pop191
	i32.load	$2=, stdout($pop2)
	i32.store	$discard=, 64($1), $3
	i32.const	$push190=, .L.str.5
	i32.const	$push105=, 64
	i32.add 	$push106=, $1, $pop105
	i32.call	$push64=, __fprintf_chk@FUNCTION, $2, $1, $pop190, $pop106
	i32.ne  	$push65=, $pop64, $0
	br_if   	0, $pop65       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push193=, 0
	i32.load	$push66=, should_optimize($pop193)
	i32.const	$push246=, 0
	i32.eq  	$push247=, $pop66, $pop246
	br_if   	0, $pop247      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push198=, 0
	i32.const	$push197=, 0
	i32.store	$push196=, should_optimize($pop198), $pop197
	tee_local	$push195=, $0=, $pop196
	i32.load	$2=, stdout($pop195)
	i32.const	$push67=, .L.str.1
	i32.store	$3=, 48($1), $pop67
	i32.const	$push194=, .L.str.6
	i32.const	$push107=, 48
	i32.add 	$push108=, $1, $pop107
	i32.call	$discard=, __fprintf_chk@FUNCTION, $2, $1, $pop194, $pop108
	i32.load	$push68=, should_optimize($0)
	i32.const	$push248=, 0
	i32.eq  	$push249=, $pop68, $pop248
	br_if   	0, $pop249      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push69=, 0
	i32.const	$push202=, 0
	i32.store	$push201=, should_optimize($pop69), $pop202
	tee_local	$push200=, $0=, $pop201
	i32.load	$2=, stdout($pop200)
	i32.store	$discard=, 32($1), $3
	i32.const	$push199=, .L.str.6
	i32.const	$push109=, 32
	i32.add 	$push110=, $1, $pop109
	i32.call	$push70=, __fprintf_chk@FUNCTION, $2, $1, $pop199, $pop110
	i32.const	$push71=, 7
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push73=, should_optimize($0)
	i32.const	$push250=, 0
	i32.eq  	$push251=, $pop73, $pop250
	br_if   	0, $pop251      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push74=, 0
	i32.const	$push206=, 0
	i32.store	$push205=, should_optimize($pop74), $pop206
	tee_local	$push204=, $0=, $pop205
	i32.load	$2=, stdout($pop204)
	i32.store	$discard=, 16($1), $0
	i32.const	$push203=, .L.str.7
	i32.const	$push111=, 16
	i32.add 	$push112=, $1, $pop111
	i32.call	$discard=, __fprintf_chk@FUNCTION, $2, $1, $pop203, $pop112
	i32.load	$push75=, should_optimize($0)
	i32.const	$push252=, 0
	i32.eq  	$push253=, $pop75, $pop252
	br_if   	0, $pop253      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push209=, should_optimize($0), $0
	tee_local	$push208=, $0=, $pop209
	i32.load	$2=, stdout($pop208)
	i32.store	$discard=, 0($1), $0
	i32.const	$push207=, .L.str.7
	i32.call	$push76=, __fprintf_chk@FUNCTION, $2, $1, $pop207, $1
	i32.const	$push77=, 2
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	0, $pop78       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push210=, 0
	i32.load	$push79=, should_optimize($pop210)
	i32.const	$push254=, 0
	i32.eq  	$push255=, $pop79, $pop254
	br_if   	0, $pop255      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push86=, __stack_pointer
	i32.const	$push84=, 224
	i32.add 	$push85=, $1, $pop84
	i32.store	$discard=, 0($pop86), $pop85
	i32.const	$push211=, 0
	return  	$pop211
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
