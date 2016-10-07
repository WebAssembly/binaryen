	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-chk-1.c"
	.section	.text.__printf_chk,"ax",@progbits
	.hidden	__printf_chk
	.globl	__printf_chk
	.type	__printf_chk,@function
__printf_chk:                           # @__printf_chk
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push11=, $pop3, $pop4
	tee_local	$push10=, $3=, $pop11
	i32.store	__stack_pointer($pop5), $pop10
	block   	
	i32.const	$push9=, 0
	i32.load	$push0=, should_optimize($pop9)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push1=, 1
	i32.store	should_optimize($pop12), $pop1
	i32.store	12($3), $2
	i32.call	$2=, vprintf@FUNCTION, $1, $2
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	return  	$2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__printf_chk, .Lfunc_end0-__printf_chk

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push56=, 0
	i32.const	$push53=, 0
	i32.load	$push54=, __stack_pointer($pop53)
	i32.const	$push55=, 224
	i32.sub 	$push92=, $pop54, $pop55
	tee_local	$push91=, $0=, $pop92
	i32.store	__stack_pointer($pop56), $pop91
	i32.const	$push90=, 0
	i32.const	$push89=, 0
	i32.store	should_optimize($pop90), $pop89
	i32.const	$push88=, .L.str
	i32.const	$push87=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop88, $pop87
	block   	
	i32.const	$push86=, 0
	i32.load	$push0=, should_optimize($pop86)
	i32.eqz 	$push197=, $pop0
	br_if   	0, $pop197      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push96=, 0
	i32.const	$push95=, 0
	i32.store	should_optimize($pop96), $pop95
	i32.const	$push94=, .L.str
	i32.const	$push93=, 0
	i32.call	$push1=, __printf_chk@FUNCTION, $0, $pop94, $pop93
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push97=, 0
	i32.load	$push4=, should_optimize($pop97)
	i32.eqz 	$push198=, $pop4
	br_if   	0, $pop198      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push101=, 0
	i32.const	$push5=, 1
	i32.store	should_optimize($pop101), $pop5
	i32.const	$push100=, .L.str.1
	i32.const	$push99=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop100, $pop99
	i32.const	$push98=, 0
	i32.load	$push6=, should_optimize($pop98)
	i32.eqz 	$push199=, $pop6
	br_if   	0, $pop199      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.store	should_optimize($pop105), $pop104
	i32.const	$push103=, .L.str.1
	i32.const	$push102=, 0
	i32.call	$push7=, __printf_chk@FUNCTION, $0, $pop103, $pop102
	i32.const	$push8=, 6
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#5:                                 # %if.end14
	i32.const	$push106=, 0
	i32.load	$push10=, should_optimize($pop106)
	i32.eqz 	$push200=, $pop10
	br_if   	0, $pop200      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push111=, 0
	i32.const	$push110=, 1
	i32.store	should_optimize($pop111), $pop110
	i32.const	$push109=, .L.str.2
	i32.const	$push108=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop109, $pop108
	i32.const	$push107=, 0
	i32.load	$push11=, should_optimize($pop107)
	i32.eqz 	$push201=, $pop11
	br_if   	0, $pop201      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push116=, 0
	i32.const	$push115=, 0
	i32.store	should_optimize($pop116), $pop115
	i32.const	$push114=, .L.str.2
	i32.const	$push113=, 0
	i32.call	$push12=, __printf_chk@FUNCTION, $0, $pop114, $pop113
	i32.const	$push112=, 1
	i32.ne  	$push13=, $pop12, $pop112
	br_if   	0, $pop13       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push117=, 0
	i32.load	$push14=, should_optimize($pop117)
	i32.eqz 	$push202=, $pop14
	br_if   	0, $pop202      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push121=, 0
	i32.const	$push15=, 1
	i32.store	should_optimize($pop121), $pop15
	i32.const	$push120=, .L.str.3
	i32.const	$push119=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop120, $pop119
	i32.const	$push118=, 0
	i32.load	$push16=, should_optimize($pop118)
	i32.eqz 	$push203=, $pop16
	br_if   	0, $pop203      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.store	should_optimize($pop125), $pop124
	i32.const	$push123=, .L.str.3
	i32.const	$push122=, 0
	i32.call	$push17=, __printf_chk@FUNCTION, $0, $pop123, $pop122
	br_if   	0, $pop17       # 0: down to label1
# BB#11:                                # %if.end36
	i32.const	$push126=, 0
	i32.load	$push18=, should_optimize($pop126)
	i32.eqz 	$push204=, $pop18
	br_if   	0, $pop204      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push131=, .L.str
	i32.store	208($0), $pop131
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.store	should_optimize($pop130), $pop129
	i32.const	$push128=, .L.str.4
	i32.const	$push60=, 208
	i32.add 	$push61=, $0, $pop60
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop128, $pop61
	i32.const	$push127=, 0
	i32.load	$push19=, should_optimize($pop127)
	i32.eqz 	$push205=, $pop19
	br_if   	0, $pop205      # 0: down to label1
# BB#13:                                # %if.end43
	i32.const	$push135=, .L.str
	i32.store	192($0), $pop135
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i32.store	should_optimize($pop134), $pop133
	i32.const	$push132=, .L.str.4
	i32.const	$push62=, 192
	i32.add 	$push63=, $0, $pop62
	i32.call	$push20=, __printf_chk@FUNCTION, $0, $pop132, $pop63
	i32.const	$push21=, 5
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push136=, 0
	i32.load	$push23=, should_optimize($pop136)
	i32.eqz 	$push206=, $pop23
	br_if   	0, $pop206      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push140=, 0
	i32.const	$push24=, 1
	i32.store	should_optimize($pop140), $pop24
	i32.const	$push139=, .L.str.1
	i32.store	176($0), $pop139
	i32.const	$push138=, .L.str.4
	i32.const	$push64=, 176
	i32.add 	$push65=, $0, $pop64
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop138, $pop65
	i32.const	$push137=, 0
	i32.load	$push25=, should_optimize($pop137)
	i32.eqz 	$push207=, $pop25
	br_if   	0, $pop207      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push144=, .L.str.1
	i32.store	160($0), $pop144
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.store	should_optimize($pop143), $pop142
	i32.const	$push141=, .L.str.4
	i32.const	$push66=, 160
	i32.add 	$push67=, $0, $pop66
	i32.call	$push26=, __printf_chk@FUNCTION, $0, $pop141, $pop67
	i32.const	$push27=, 6
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label1
# BB#17:                                # %if.end58
	i32.const	$push145=, 0
	i32.load	$push29=, should_optimize($pop145)
	i32.eqz 	$push208=, $pop29
	br_if   	0, $pop208      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push150=, 0
	i32.const	$push149=, 1
	i32.store	should_optimize($pop150), $pop149
	i32.const	$push148=, .L.str.2
	i32.store	144($0), $pop148
	i32.const	$push147=, .L.str.4
	i32.const	$push68=, 144
	i32.add 	$push69=, $0, $pop68
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop147, $pop69
	i32.const	$push146=, 0
	i32.load	$push30=, should_optimize($pop146)
	i32.eqz 	$push209=, $pop30
	br_if   	0, $pop209      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push155=, .L.str.2
	i32.store	128($0), $pop155
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.store	should_optimize($pop154), $pop153
	i32.const	$push152=, .L.str.4
	i32.const	$push70=, 128
	i32.add 	$push71=, $0, $pop70
	i32.call	$push31=, __printf_chk@FUNCTION, $0, $pop152, $pop71
	i32.const	$push151=, 1
	i32.ne  	$push32=, $pop31, $pop151
	br_if   	0, $pop32       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push156=, 0
	i32.load	$push33=, should_optimize($pop156)
	i32.eqz 	$push210=, $pop33
	br_if   	0, $pop210      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push160=, 0
	i32.const	$push34=, 1
	i32.store	should_optimize($pop160), $pop34
	i32.const	$push159=, .L.str.3
	i32.store	112($0), $pop159
	i32.const	$push158=, .L.str.4
	i32.const	$push72=, 112
	i32.add 	$push73=, $0, $pop72
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop158, $pop73
	i32.const	$push157=, 0
	i32.load	$push35=, should_optimize($pop157)
	i32.eqz 	$push211=, $pop35
	br_if   	0, $pop211      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push164=, .L.str.3
	i32.store	96($0), $pop164
	i32.const	$push163=, 0
	i32.const	$push162=, 0
	i32.store	should_optimize($pop163), $pop162
	i32.const	$push161=, .L.str.4
	i32.const	$push74=, 96
	i32.add 	$push75=, $0, $pop74
	i32.call	$push36=, __printf_chk@FUNCTION, $0, $pop161, $pop75
	br_if   	0, $pop36       # 0: down to label1
# BB#23:                                # %if.end80
	i32.const	$push165=, 0
	i32.load	$push37=, should_optimize($pop165)
	i32.eqz 	$push212=, $pop37
	br_if   	0, $pop212      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push170=, 0
	i32.const	$push169=, 1
	i32.store	should_optimize($pop170), $pop169
	i32.const	$push168=, 120
	i32.store	80($0), $pop168
	i32.const	$push167=, .L.str.5
	i32.const	$push76=, 80
	i32.add 	$push77=, $0, $pop76
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop167, $pop77
	i32.const	$push166=, 0
	i32.load	$push38=, should_optimize($pop166)
	i32.eqz 	$push213=, $pop38
	br_if   	0, $pop213      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push175=, 120
	i32.store	64($0), $pop175
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.store	should_optimize($pop174), $pop173
	i32.const	$push172=, .L.str.5
	i32.const	$push78=, 64
	i32.add 	$push79=, $0, $pop78
	i32.call	$push39=, __printf_chk@FUNCTION, $0, $pop172, $pop79
	i32.const	$push171=, 1
	i32.ne  	$push40=, $pop39, $pop171
	br_if   	0, $pop40       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push176=, 0
	i32.load	$push41=, should_optimize($pop176)
	i32.eqz 	$push214=, $pop41
	br_if   	0, $pop214      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push180=, 0
	i32.const	$push42=, 1
	i32.store	should_optimize($pop180), $pop42
	i32.const	$push179=, .L.str.1
	i32.store	48($0), $pop179
	i32.const	$push178=, .L.str.6
	i32.const	$push80=, 48
	i32.add 	$push81=, $0, $pop80
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop178, $pop81
	i32.const	$push177=, 0
	i32.load	$push43=, should_optimize($pop177)
	i32.eqz 	$push215=, $pop43
	br_if   	0, $pop215      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push184=, .L.str.1
	i32.store	32($0), $pop184
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.store	should_optimize($pop183), $pop182
	i32.const	$push181=, .L.str.6
	i32.const	$push82=, 32
	i32.add 	$push83=, $0, $pop82
	i32.call	$push44=, __printf_chk@FUNCTION, $0, $pop181, $pop83
	i32.const	$push45=, 7
	i32.ne  	$push46=, $pop44, $pop45
	br_if   	0, $pop46       # 0: down to label1
# BB#29:                                # %if.end102
	i32.const	$push185=, 0
	i32.load	$push47=, should_optimize($pop185)
	i32.eqz 	$push216=, $pop47
	br_if   	0, $pop216      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push190=, 0
	i32.store	16($0), $pop190
	i32.const	$push189=, 0
	i32.const	$push188=, 0
	i32.store	should_optimize($pop189), $pop188
	i32.const	$push187=, .L.str.7
	i32.const	$push84=, 16
	i32.add 	$push85=, $0, $pop84
	i32.call	$drop=, __printf_chk@FUNCTION, $0, $pop187, $pop85
	i32.const	$push186=, 0
	i32.load	$push48=, should_optimize($pop186)
	i32.eqz 	$push217=, $pop48
	br_if   	0, $pop217      # 0: down to label1
# BB#31:                                # %if.end109
	i32.const	$push194=, 0
	i32.store	0($0), $pop194
	i32.const	$push193=, 0
	i32.const	$push192=, 0
	i32.store	should_optimize($pop193), $pop192
	i32.const	$push191=, .L.str.7
	i32.call	$push49=, __printf_chk@FUNCTION, $0, $pop191, $0
	i32.const	$push50=, 2
	i32.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push195=, 0
	i32.load	$push52=, should_optimize($pop195)
	i32.eqz 	$push218=, $pop52
	br_if   	0, $pop218      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push59=, 0
	i32.const	$push57=, 224
	i32.add 	$push58=, $0, $pop57
	i32.store	__stack_pointer($pop59), $pop58
	i32.const	$push196=, 0
	return  	$pop196
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	vprintf, i32, i32, i32
