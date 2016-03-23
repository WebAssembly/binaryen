	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-chk-1.c"
	.section	.text.__printf_chk,"ax",@progbits
	.hidden	__printf_chk
	.globl	__printf_chk
	.type	__printf_chk,@function
__printf_chk:                           # @__printf_chk
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 16
	i32.sub 	$3=, $pop9, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $3
	block
	i32.const	$push5=, 0
	i32.load	$push0=, should_optimize($pop5)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop7), $pop1
	i32.const	$push6=, 0
	i32.load	$push3=, stdout($pop6)
	i32.store	$push2=, 12($3), $2
	i32.call	$push4=, vfprintf@FUNCTION, $pop3, $1, $pop2
	i32.const	$push14=, __stack_pointer
	i32.const	$push12=, 16
	i32.add 	$push13=, $3, $pop12
	i32.store	$discard=, 0($pop14), $pop13
	return  	$pop4
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push142=, __stack_pointer
	i32.load	$push143=, 0($pop142)
	i32.const	$push144=, 224
	i32.sub 	$2=, $pop143, $pop144
	i32.const	$push145=, __stack_pointer
	i32.store	$discard=, 0($pop145), $2
	i32.const	$push77=, .L.str
	i32.const	$push0=, 0
	i32.const	$push76=, 0
	i32.store	$push75=, should_optimize($pop0), $pop76
	tee_local	$push74=, $1=, $pop75
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop77, $pop74
	block
	i32.load	$push1=, should_optimize($1)
	i32.const	$push175=, 0
	i32.eq  	$push176=, $pop1, $pop175
	br_if   	0, $pop176      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push78=, .L.str
	i32.store	$push2=, should_optimize($1), $1
	i32.call	$push3=, __printf_chk@FUNCTION, $1, $pop78, $pop2
	i32.const	$push4=, 5
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push79=, 0
	i32.load	$push6=, should_optimize($pop79)
	i32.const	$push177=, 0
	i32.eq  	$push178=, $pop6, $pop177
	br_if   	0, $pop178      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push83=, 0
	i32.const	$push7=, 1
	i32.store	$discard=, should_optimize($pop83), $pop7
	i32.const	$push82=, .L.str.1
	i32.const	$push81=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop82, $pop81
	i32.const	$push80=, 0
	i32.load	$push8=, should_optimize($pop80)
	i32.const	$push179=, 0
	i32.eq  	$push180=, $pop8, $pop179
	br_if   	0, $pop180      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push87=, .L.str.1
	i32.const	$push9=, 0
	i32.const	$push86=, 0
	i32.store	$push85=, should_optimize($pop9), $pop86
	tee_local	$push84=, $1=, $pop85
	i32.call	$push10=, __printf_chk@FUNCTION, $1, $pop87, $pop84
	i32.const	$push11=, 6
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push13=, should_optimize($1)
	i32.const	$push181=, 0
	i32.eq  	$push182=, $pop13, $pop181
	br_if   	0, $pop182      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push91=, 0
	i32.const	$push14=, 1
	i32.store	$1=, should_optimize($pop91), $pop14
	i32.const	$push90=, .L.str.2
	i32.const	$push89=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop90, $pop89
	i32.const	$push88=, 0
	i32.load	$push15=, should_optimize($pop88)
	i32.const	$push183=, 0
	i32.eq  	$push184=, $pop15, $pop183
	br_if   	0, $pop184      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push94=, .L.str.2
	i32.const	$push93=, 0
	i32.const	$push92=, 0
	i32.store	$push16=, should_optimize($pop93), $pop92
	i32.call	$push17=, __printf_chk@FUNCTION, $1, $pop94, $pop16
	i32.ne  	$push18=, $pop17, $1
	br_if   	0, $pop18       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push95=, 0
	i32.load	$push19=, should_optimize($pop95)
	i32.const	$push185=, 0
	i32.eq  	$push186=, $pop19, $pop185
	br_if   	0, $pop186      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push99=, 0
	i32.const	$push20=, 1
	i32.store	$discard=, should_optimize($pop99), $pop20
	i32.const	$push98=, .L.str.3
	i32.const	$push97=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop98, $pop97
	i32.const	$push96=, 0
	i32.load	$push21=, should_optimize($pop96)
	i32.const	$push187=, 0
	i32.eq  	$push188=, $pop21, $pop187
	br_if   	0, $pop188      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push103=, .L.str.3
	i32.const	$push22=, 0
	i32.const	$push102=, 0
	i32.store	$push101=, should_optimize($pop22), $pop102
	tee_local	$push100=, $1=, $pop101
	i32.call	$push23=, __printf_chk@FUNCTION, $1, $pop103, $pop100
	br_if   	0, $pop23       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push24=, should_optimize($1)
	i32.const	$push189=, 0
	i32.eq  	$push190=, $pop24, $pop189
	br_if   	0, $pop190      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push25=, 0
	i32.const	$push105=, 0
	i32.store	$1=, should_optimize($pop25), $pop105
	i32.const	$push26=, .L.str
	i32.store	$0=, 208($2):p2align=4, $pop26
	i32.const	$push104=, .L.str.4
	i32.const	$push149=, 208
	i32.add 	$push150=, $2, $pop149
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop104, $pop150
	i32.load	$push27=, should_optimize($1)
	i32.const	$push191=, 0
	i32.eq  	$push192=, $pop27, $pop191
	br_if   	0, $pop192      # 0: down to label1
# BB#13:                                # %if.end43
	i32.store	$discard=, should_optimize($1), $1
	i32.store	$discard=, 192($2):p2align=4, $0
	i32.const	$push106=, .L.str.4
	i32.const	$push151=, 192
	i32.add 	$push152=, $2, $pop151
	i32.call	$push28=, __printf_chk@FUNCTION, $1, $pop106, $pop152
	i32.const	$push29=, 5
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push107=, 0
	i32.load	$push31=, should_optimize($pop107)
	i32.const	$push193=, 0
	i32.eq  	$push194=, $pop31, $pop193
	br_if   	0, $pop194      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push110=, 0
	i32.const	$push32=, 1
	i32.store	$discard=, should_optimize($pop110), $pop32
	i32.const	$push33=, .L.str.1
	i32.store	$1=, 176($2):p2align=4, $pop33
	i32.const	$push109=, .L.str.4
	i32.const	$push153=, 176
	i32.add 	$push154=, $2, $pop153
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop109, $pop154
	i32.const	$push108=, 0
	i32.load	$push34=, should_optimize($pop108)
	i32.const	$push195=, 0
	i32.eq  	$push196=, $pop34, $pop195
	br_if   	0, $pop196      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push35=, 0
	i32.const	$push112=, 0
	i32.store	$0=, should_optimize($pop35), $pop112
	i32.store	$discard=, 160($2):p2align=4, $1
	i32.const	$push111=, .L.str.4
	i32.const	$push155=, 160
	i32.add 	$push156=, $2, $pop155
	i32.call	$push36=, __printf_chk@FUNCTION, $1, $pop111, $pop156
	i32.const	$push37=, 6
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push39=, should_optimize($0)
	i32.const	$push197=, 0
	i32.eq  	$push198=, $pop39, $pop197
	br_if   	0, $pop198      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push115=, 0
	i32.const	$push40=, 1
	i32.store	$1=, should_optimize($pop115), $pop40
	i32.const	$push41=, .L.str.2
	i32.store	$0=, 144($2):p2align=4, $pop41
	i32.const	$push114=, .L.str.4
	i32.const	$push157=, 144
	i32.add 	$push158=, $2, $pop157
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop114, $pop158
	i32.const	$push113=, 0
	i32.load	$push42=, should_optimize($pop113)
	i32.const	$push199=, 0
	i32.eq  	$push200=, $pop42, $pop199
	br_if   	0, $pop200      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.store	$discard=, should_optimize($pop118), $pop117
	i32.store	$discard=, 128($2):p2align=4, $0
	i32.const	$push116=, .L.str.4
	i32.const	$push159=, 128
	i32.add 	$push160=, $2, $pop159
	i32.call	$push43=, __printf_chk@FUNCTION, $1, $pop116, $pop160
	i32.ne  	$push44=, $pop43, $1
	br_if   	0, $pop44       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push119=, 0
	i32.load	$push45=, should_optimize($pop119)
	i32.const	$push201=, 0
	i32.eq  	$push202=, $pop45, $pop201
	br_if   	0, $pop202      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push122=, 0
	i32.const	$push46=, 1
	i32.store	$discard=, should_optimize($pop122), $pop46
	i32.const	$push47=, .L.str.3
	i32.store	$1=, 112($2):p2align=4, $pop47
	i32.const	$push121=, .L.str.4
	i32.const	$push161=, 112
	i32.add 	$push162=, $2, $pop161
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop121, $pop162
	i32.const	$push120=, 0
	i32.load	$push48=, should_optimize($pop120)
	i32.const	$push203=, 0
	i32.eq  	$push204=, $pop48, $pop203
	br_if   	0, $pop204      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push49=, 0
	i32.const	$push124=, 0
	i32.store	$0=, should_optimize($pop49), $pop124
	i32.store	$discard=, 96($2):p2align=4, $1
	i32.const	$push123=, .L.str.4
	i32.const	$push163=, 96
	i32.add 	$push164=, $2, $pop163
	i32.call	$push50=, __printf_chk@FUNCTION, $1, $pop123, $pop164
	br_if   	0, $pop50       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push51=, should_optimize($0)
	i32.const	$push205=, 0
	i32.eq  	$push206=, $pop51, $pop205
	br_if   	0, $pop206      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push127=, 0
	i32.const	$push52=, 1
	i32.store	$1=, should_optimize($pop127), $pop52
	i32.const	$push53=, 120
	i32.store	$0=, 80($2):p2align=4, $pop53
	i32.const	$push126=, .L.str.5
	i32.const	$push165=, 80
	i32.add 	$push166=, $2, $pop165
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop126, $pop166
	i32.const	$push125=, 0
	i32.load	$push54=, should_optimize($pop125)
	i32.const	$push207=, 0
	i32.eq  	$push208=, $pop54, $pop207
	br_if   	0, $pop208      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.store	$discard=, should_optimize($pop130), $pop129
	i32.store	$discard=, 64($2):p2align=4, $0
	i32.const	$push128=, .L.str.5
	i32.const	$push167=, 64
	i32.add 	$push168=, $2, $pop167
	i32.call	$push55=, __printf_chk@FUNCTION, $1, $pop128, $pop168
	i32.ne  	$push56=, $pop55, $1
	br_if   	0, $pop56       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push131=, 0
	i32.load	$push57=, should_optimize($pop131)
	i32.const	$push209=, 0
	i32.eq  	$push210=, $pop57, $pop209
	br_if   	0, $pop210      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push134=, 0
	i32.const	$push58=, 1
	i32.store	$discard=, should_optimize($pop134), $pop58
	i32.const	$push59=, .L.str.1
	i32.store	$1=, 48($2):p2align=4, $pop59
	i32.const	$push133=, .L.str.6
	i32.const	$push169=, 48
	i32.add 	$push170=, $2, $pop169
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop133, $pop170
	i32.const	$push132=, 0
	i32.load	$push60=, should_optimize($pop132)
	i32.const	$push211=, 0
	i32.eq  	$push212=, $pop60, $pop211
	br_if   	0, $pop212      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push61=, 0
	i32.const	$push136=, 0
	i32.store	$0=, should_optimize($pop61), $pop136
	i32.store	$discard=, 32($2):p2align=4, $1
	i32.const	$push135=, .L.str.6
	i32.const	$push171=, 32
	i32.add 	$push172=, $2, $pop171
	i32.call	$push62=, __printf_chk@FUNCTION, $1, $pop135, $pop172
	i32.const	$push63=, 7
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	0, $pop64       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push65=, should_optimize($0)
	i32.const	$push213=, 0
	i32.eq  	$push214=, $pop65, $pop213
	br_if   	0, $pop214      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push66=, 0
	i32.const	$push138=, 0
	i32.store	$push67=, should_optimize($pop66), $pop138
	i32.store	$1=, 16($2):p2align=4, $pop67
	i32.const	$push137=, .L.str.7
	i32.const	$push173=, 16
	i32.add 	$push174=, $2, $pop173
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop137, $pop174
	i32.load	$push68=, should_optimize($1)
	i32.const	$push215=, 0
	i32.eq  	$push216=, $pop68, $pop215
	br_if   	0, $pop216      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push69=, should_optimize($1), $1
	i32.store	$discard=, 0($2):p2align=4, $pop69
	i32.const	$push139=, .L.str.7
	i32.call	$push70=, __printf_chk@FUNCTION, $1, $pop139, $2
	i32.const	$push71=, 2
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push140=, 0
	i32.load	$push73=, should_optimize($pop140)
	i32.const	$push217=, 0
	i32.eq  	$push218=, $pop73, $pop217
	br_if   	0, $pop218      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push141=, 0
	i32.const	$push148=, __stack_pointer
	i32.const	$push146=, 224
	i32.add 	$push147=, $2, $pop146
	i32.store	$discard=, 0($pop148), $pop147
	return  	$pop141
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
