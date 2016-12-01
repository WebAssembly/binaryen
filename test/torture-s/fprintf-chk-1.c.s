	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/fprintf-chk-1.c"
	.section	.text.__fprintf_chk,"ax",@progbits
	.hidden	__fprintf_chk
	.globl	__fprintf_chk
	.type	__fprintf_chk,@function
__fprintf_chk:                          # @__fprintf_chk
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push11=, $pop3, $pop4
	tee_local	$push10=, $4=, $pop11
	i32.store	__stack_pointer($pop5), $pop10
	block   	
	i32.const	$push9=, 0
	i32.load	$push0=, should_optimize($pop9)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push1=, 1
	i32.store	should_optimize($pop12), $pop1
	i32.store	12($4), $3
	i32.call	$3=, vfprintf@FUNCTION, $0, $2, $3
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $4, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	return  	$3
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push57=, 0
	i32.const	$push54=, 0
	i32.load	$push55=, __stack_pointer($pop54)
	i32.const	$push56=, 224
	i32.sub 	$push95=, $pop55, $pop56
	tee_local	$push94=, $1=, $pop95
	i32.store	__stack_pointer($pop57), $pop94
	i32.const	$push93=, 0
	i32.const	$push0=, 1
	i32.store	should_optimize($pop93), $pop0
	i32.const	$push92=, 0
	i32.load	$push91=, stdout($pop92)
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, .L.str
	i32.const	$push88=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $pop90, $1, $pop89, $pop88
	block   	
	i32.const	$push87=, 0
	i32.load	$push1=, should_optimize($pop87)
	i32.eqz 	$push200=, $pop1
	br_if   	0, $pop200      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push99=, 0
	i32.const	$push98=, 0
	i32.store	should_optimize($pop99), $pop98
	i32.const	$push97=, .L.str
	i32.const	$push96=, 0
	i32.call	$push2=, __fprintf_chk@FUNCTION, $0, $1, $pop97, $pop96
	i32.const	$push3=, 5
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push100=, 0
	i32.load	$push5=, should_optimize($pop100)
	i32.eqz 	$push201=, $pop5
	br_if   	0, $pop201      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push104=, 0
	i32.const	$push6=, 1
	i32.store	should_optimize($pop104), $pop6
	i32.const	$push103=, .L.str.1
	i32.const	$push102=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop103, $pop102
	i32.const	$push101=, 0
	i32.load	$push7=, should_optimize($pop101)
	i32.eqz 	$push202=, $pop7
	br_if   	0, $pop202      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push108=, 0
	i32.const	$push107=, 0
	i32.store	should_optimize($pop108), $pop107
	i32.const	$push106=, .L.str.1
	i32.const	$push105=, 0
	i32.call	$push8=, __fprintf_chk@FUNCTION, $0, $1, $pop106, $pop105
	i32.const	$push9=, 6
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.const	$push109=, 0
	i32.load	$push11=, should_optimize($pop109)
	i32.eqz 	$push203=, $pop11
	br_if   	0, $pop203      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push114=, 0
	i32.const	$push113=, 1
	i32.store	should_optimize($pop114), $pop113
	i32.const	$push112=, .L.str.2
	i32.const	$push111=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop112, $pop111
	i32.const	$push110=, 0
	i32.load	$push12=, should_optimize($pop110)
	i32.eqz 	$push204=, $pop12
	br_if   	0, $pop204      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.store	should_optimize($pop119), $pop118
	i32.const	$push117=, .L.str.2
	i32.const	$push116=, 0
	i32.call	$push13=, __fprintf_chk@FUNCTION, $0, $1, $pop117, $pop116
	i32.const	$push115=, 1
	i32.ne  	$push14=, $pop13, $pop115
	br_if   	0, $pop14       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push120=, 0
	i32.load	$push15=, should_optimize($pop120)
	i32.eqz 	$push205=, $pop15
	br_if   	0, $pop205      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push124=, 0
	i32.const	$push16=, 1
	i32.store	should_optimize($pop124), $pop16
	i32.const	$push123=, .L.str.3
	i32.const	$push122=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop123, $pop122
	i32.const	$push121=, 0
	i32.load	$push17=, should_optimize($pop121)
	i32.eqz 	$push206=, $pop17
	br_if   	0, $pop206      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.store	should_optimize($pop128), $pop127
	i32.const	$push126=, .L.str.3
	i32.const	$push125=, 0
	i32.call	$push18=, __fprintf_chk@FUNCTION, $0, $1, $pop126, $pop125
	br_if   	0, $pop18       # 0: down to label1
# BB#11:                                # %if.end36
	i32.const	$push129=, 0
	i32.load	$push19=, should_optimize($pop129)
	i32.eqz 	$push207=, $pop19
	br_if   	0, $pop207      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push133=, 0
	i32.const	$push20=, 1
	i32.store	should_optimize($pop133), $pop20
	i32.const	$push132=, .L.str
	i32.store	208($1), $pop132
	i32.const	$push131=, .L.str.4
	i32.const	$push61=, 208
	i32.add 	$push62=, $1, $pop61
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop131, $pop62
	i32.const	$push130=, 0
	i32.load	$push21=, should_optimize($pop130)
	i32.eqz 	$push208=, $pop21
	br_if   	0, $pop208      # 0: down to label1
# BB#13:                                # %if.end43
	i32.const	$push137=, .L.str
	i32.store	192($1), $pop137
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.store	should_optimize($pop136), $pop135
	i32.const	$push134=, .L.str.4
	i32.const	$push63=, 192
	i32.add 	$push64=, $1, $pop63
	i32.call	$push22=, __fprintf_chk@FUNCTION, $0, $1, $pop134, $pop64
	i32.const	$push23=, 5
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push138=, 0
	i32.load	$push25=, should_optimize($pop138)
	i32.eqz 	$push209=, $pop25
	br_if   	0, $pop209      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push142=, 0
	i32.const	$push26=, 1
	i32.store	should_optimize($pop142), $pop26
	i32.const	$push141=, .L.str.1
	i32.store	176($1), $pop141
	i32.const	$push140=, .L.str.4
	i32.const	$push65=, 176
	i32.add 	$push66=, $1, $pop65
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop140, $pop66
	i32.const	$push139=, 0
	i32.load	$push27=, should_optimize($pop139)
	i32.eqz 	$push210=, $pop27
	br_if   	0, $pop210      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push146=, .L.str.1
	i32.store	160($1), $pop146
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.store	should_optimize($pop145), $pop144
	i32.const	$push143=, .L.str.4
	i32.const	$push67=, 160
	i32.add 	$push68=, $1, $pop67
	i32.call	$push28=, __fprintf_chk@FUNCTION, $0, $1, $pop143, $pop68
	i32.const	$push29=, 6
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#17:                                # %if.end58
	i32.const	$push147=, 0
	i32.load	$push31=, should_optimize($pop147)
	i32.eqz 	$push211=, $pop31
	br_if   	0, $pop211      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push152=, 0
	i32.const	$push151=, 1
	i32.store	should_optimize($pop152), $pop151
	i32.const	$push150=, .L.str.2
	i32.store	144($1), $pop150
	i32.const	$push149=, .L.str.4
	i32.const	$push69=, 144
	i32.add 	$push70=, $1, $pop69
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop149, $pop70
	i32.const	$push148=, 0
	i32.load	$push32=, should_optimize($pop148)
	i32.eqz 	$push212=, $pop32
	br_if   	0, $pop212      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push157=, .L.str.2
	i32.store	128($1), $pop157
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.store	should_optimize($pop156), $pop155
	i32.const	$push154=, .L.str.4
	i32.const	$push71=, 128
	i32.add 	$push72=, $1, $pop71
	i32.call	$push33=, __fprintf_chk@FUNCTION, $0, $1, $pop154, $pop72
	i32.const	$push153=, 1
	i32.ne  	$push34=, $pop33, $pop153
	br_if   	0, $pop34       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push158=, 0
	i32.load	$push35=, should_optimize($pop158)
	i32.eqz 	$push213=, $pop35
	br_if   	0, $pop213      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push162=, 0
	i32.const	$push36=, 1
	i32.store	should_optimize($pop162), $pop36
	i32.const	$push161=, .L.str.3
	i32.store	112($1), $pop161
	i32.const	$push160=, .L.str.4
	i32.const	$push73=, 112
	i32.add 	$push74=, $1, $pop73
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop160, $pop74
	i32.const	$push159=, 0
	i32.load	$push37=, should_optimize($pop159)
	i32.eqz 	$push214=, $pop37
	br_if   	0, $pop214      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push166=, .L.str.3
	i32.store	96($1), $pop166
	i32.const	$push165=, 0
	i32.const	$push164=, 0
	i32.store	should_optimize($pop165), $pop164
	i32.const	$push163=, .L.str.4
	i32.const	$push75=, 96
	i32.add 	$push76=, $1, $pop75
	i32.call	$push38=, __fprintf_chk@FUNCTION, $0, $1, $pop163, $pop76
	br_if   	0, $pop38       # 0: down to label1
# BB#23:                                # %if.end80
	i32.const	$push167=, 0
	i32.load	$push39=, should_optimize($pop167)
	i32.eqz 	$push215=, $pop39
	br_if   	0, $pop215      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push172=, 0
	i32.const	$push171=, 1
	i32.store	should_optimize($pop172), $pop171
	i32.const	$push170=, 120
	i32.store	80($1), $pop170
	i32.const	$push169=, .L.str.5
	i32.const	$push77=, 80
	i32.add 	$push78=, $1, $pop77
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop169, $pop78
	i32.const	$push168=, 0
	i32.load	$push40=, should_optimize($pop168)
	i32.eqz 	$push216=, $pop40
	br_if   	0, $pop216      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push177=, 120
	i32.store	64($1), $pop177
	i32.const	$push176=, 0
	i32.const	$push175=, 0
	i32.store	should_optimize($pop176), $pop175
	i32.const	$push174=, .L.str.5
	i32.const	$push79=, 64
	i32.add 	$push80=, $1, $pop79
	i32.call	$push41=, __fprintf_chk@FUNCTION, $0, $1, $pop174, $pop80
	i32.const	$push173=, 1
	i32.ne  	$push42=, $pop41, $pop173
	br_if   	0, $pop42       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push178=, 0
	i32.load	$push43=, should_optimize($pop178)
	i32.eqz 	$push217=, $pop43
	br_if   	0, $pop217      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push183=, .L.str.1
	i32.store	48($1), $pop183
	i32.const	$push182=, 0
	i32.const	$push181=, 0
	i32.store	should_optimize($pop182), $pop181
	i32.const	$push180=, .L.str.6
	i32.const	$push81=, 48
	i32.add 	$push82=, $1, $pop81
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop180, $pop82
	i32.const	$push179=, 0
	i32.load	$push44=, should_optimize($pop179)
	i32.eqz 	$push218=, $pop44
	br_if   	0, $pop218      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push187=, .L.str.1
	i32.store	32($1), $pop187
	i32.const	$push186=, 0
	i32.const	$push185=, 0
	i32.store	should_optimize($pop186), $pop185
	i32.const	$push184=, .L.str.6
	i32.const	$push83=, 32
	i32.add 	$push84=, $1, $pop83
	i32.call	$push45=, __fprintf_chk@FUNCTION, $0, $1, $pop184, $pop84
	i32.const	$push46=, 7
	i32.ne  	$push47=, $pop45, $pop46
	br_if   	0, $pop47       # 0: down to label1
# BB#29:                                # %if.end102
	i32.const	$push188=, 0
	i32.load	$push48=, should_optimize($pop188)
	i32.eqz 	$push219=, $pop48
	br_if   	0, $pop219      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push193=, 0
	i32.store	16($1), $pop193
	i32.const	$push192=, 0
	i32.const	$push191=, 0
	i32.store	should_optimize($pop192), $pop191
	i32.const	$push190=, .L.str.7
	i32.const	$push85=, 16
	i32.add 	$push86=, $1, $pop85
	i32.call	$drop=, __fprintf_chk@FUNCTION, $0, $1, $pop190, $pop86
	i32.const	$push189=, 0
	i32.load	$push49=, should_optimize($pop189)
	i32.eqz 	$push220=, $pop49
	br_if   	0, $pop220      # 0: down to label1
# BB#31:                                # %if.end109
	i32.const	$push197=, 0
	i32.store	0($1), $pop197
	i32.const	$push196=, 0
	i32.const	$push195=, 0
	i32.store	should_optimize($pop196), $pop195
	i32.const	$push194=, .L.str.7
	i32.call	$push50=, __fprintf_chk@FUNCTION, $0, $1, $pop194, $1
	i32.const	$push51=, 2
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	0, $pop52       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push198=, 0
	i32.load	$push53=, should_optimize($pop198)
	i32.eqz 	$push221=, $pop53
	br_if   	0, $pop221      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push60=, 0
	i32.const	$push58=, 224
	i32.add 	$push59=, $1, $pop58
	i32.store	__stack_pointer($pop60), $pop59
	i32.const	$push199=, 0
	return  	$pop199
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	vfprintf, i32, i32, i32, i32
	.import_global	stdout
