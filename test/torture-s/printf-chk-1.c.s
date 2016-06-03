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
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$3=, __stack_pointer($pop6), $pop10
	block
	i32.const	$push11=, 0
	i32.load	$push1=, should_optimize($pop11)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push2=, 1
	i32.store	$drop=, should_optimize($pop12), $pop2
	i32.store	$push0=, 12($3), $2
	i32.call	$1=, vprintf@FUNCTION, $1, $pop0
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
	return  	$1
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
	i32.const	$push75=, 0
	i32.const	$push72=, 0
	i32.load	$push73=, __stack_pointer($pop72)
	i32.const	$push74=, 224
	i32.sub 	$push105=, $pop73, $pop74
	i32.store	$2=, __stack_pointer($pop75), $pop105
	i32.const	$push109=, .L.str
	i32.const	$push2=, 0
	i32.const	$push108=, 0
	i32.store	$push107=, should_optimize($pop2), $pop108
	tee_local	$push106=, $0=, $pop107
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop109, $pop106
	block
	i32.load	$push3=, should_optimize($0)
	i32.eqz 	$push177=, $pop3
	br_if   	0, $pop177      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push110=, .L.str
	i32.store	$push0=, should_optimize($0), $0
	i32.call	$push4=, __printf_chk@FUNCTION, $2, $pop110, $pop0
	i32.const	$push5=, 5
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push111=, 0
	i32.load	$push7=, should_optimize($pop111)
	i32.eqz 	$push178=, $pop7
	br_if   	0, $pop178      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push115=, 0
	i32.const	$push8=, 1
	i32.store	$drop=, should_optimize($pop115), $pop8
	i32.const	$push114=, .L.str.1
	i32.const	$push113=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop114, $pop113
	i32.const	$push112=, 0
	i32.load	$push9=, should_optimize($pop112)
	i32.eqz 	$push179=, $pop9
	br_if   	0, $pop179      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push119=, .L.str.1
	i32.const	$push10=, 0
	i32.const	$push118=, 0
	i32.store	$push117=, should_optimize($pop10), $pop118
	tee_local	$push116=, $0=, $pop117
	i32.call	$push11=, __printf_chk@FUNCTION, $2, $pop119, $pop116
	i32.const	$push12=, 6
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push14=, should_optimize($0)
	i32.eqz 	$push180=, $pop14
	br_if   	0, $pop180      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push123=, 0
	i32.const	$push15=, 1
	i32.store	$0=, should_optimize($pop123), $pop15
	i32.const	$push122=, .L.str.2
	i32.const	$push121=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop122, $pop121
	i32.const	$push120=, 0
	i32.load	$push16=, should_optimize($pop120)
	i32.eqz 	$push181=, $pop16
	br_if   	0, $pop181      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push126=, .L.str.2
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.store	$push1=, should_optimize($pop125), $pop124
	i32.call	$push17=, __printf_chk@FUNCTION, $2, $pop126, $pop1
	i32.ne  	$push18=, $pop17, $0
	br_if   	0, $pop18       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push127=, 0
	i32.load	$push19=, should_optimize($pop127)
	i32.eqz 	$push182=, $pop19
	br_if   	0, $pop182      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push131=, 0
	i32.const	$push20=, 1
	i32.store	$drop=, should_optimize($pop131), $pop20
	i32.const	$push130=, .L.str.3
	i32.const	$push129=, 0
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop130, $pop129
	i32.const	$push128=, 0
	i32.load	$push21=, should_optimize($pop128)
	i32.eqz 	$push183=, $pop21
	br_if   	0, $pop183      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push135=, .L.str.3
	i32.const	$push22=, 0
	i32.const	$push134=, 0
	i32.store	$push133=, should_optimize($pop22), $pop134
	tee_local	$push132=, $0=, $pop133
	i32.call	$push23=, __printf_chk@FUNCTION, $2, $pop135, $pop132
	br_if   	0, $pop23       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push24=, should_optimize($0)
	i32.eqz 	$push184=, $pop24
	br_if   	0, $pop184      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push25=, .L.str
	i32.store	$1=, 208($2), $pop25
	i32.const	$push26=, 0
	i32.const	$push137=, 0
	i32.store	$0=, should_optimize($pop26), $pop137
	i32.const	$push136=, .L.str.4
	i32.const	$push79=, 208
	i32.add 	$push80=, $2, $pop79
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop136, $pop80
	i32.load	$push27=, should_optimize($0)
	i32.eqz 	$push185=, $pop27
	br_if   	0, $pop185      # 0: down to label1
# BB#13:                                # %if.end43
	i32.store	$drop=, 192($2), $1
	i32.store	$drop=, should_optimize($0), $0
	i32.const	$push138=, .L.str.4
	i32.const	$push81=, 192
	i32.add 	$push82=, $2, $pop81
	i32.call	$push28=, __printf_chk@FUNCTION, $2, $pop138, $pop82
	i32.const	$push29=, 5
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push139=, 0
	i32.load	$push31=, should_optimize($pop139)
	i32.eqz 	$push186=, $pop31
	br_if   	0, $pop186      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push142=, 0
	i32.const	$push32=, 1
	i32.store	$drop=, should_optimize($pop142), $pop32
	i32.const	$push33=, .L.str.1
	i32.store	$0=, 176($2), $pop33
	i32.const	$push141=, .L.str.4
	i32.const	$push83=, 176
	i32.add 	$push84=, $2, $pop83
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop141, $pop84
	i32.const	$push140=, 0
	i32.load	$push34=, should_optimize($pop140)
	i32.eqz 	$push187=, $pop34
	br_if   	0, $pop187      # 0: down to label1
# BB#16:                                # %if.end54
	i32.store	$drop=, 160($2), $0
	i32.const	$push35=, 0
	i32.const	$push144=, 0
	i32.store	$0=, should_optimize($pop35), $pop144
	i32.const	$push143=, .L.str.4
	i32.const	$push85=, 160
	i32.add 	$push86=, $2, $pop85
	i32.call	$push36=, __printf_chk@FUNCTION, $2, $pop143, $pop86
	i32.const	$push37=, 6
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push39=, should_optimize($0)
	i32.eqz 	$push188=, $pop39
	br_if   	0, $pop188      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push147=, 0
	i32.const	$push40=, 1
	i32.store	$0=, should_optimize($pop147), $pop40
	i32.const	$push41=, .L.str.2
	i32.store	$1=, 144($2), $pop41
	i32.const	$push146=, .L.str.4
	i32.const	$push87=, 144
	i32.add 	$push88=, $2, $pop87
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop146, $pop88
	i32.const	$push145=, 0
	i32.load	$push42=, should_optimize($pop145)
	i32.eqz 	$push189=, $pop42
	br_if   	0, $pop189      # 0: down to label1
# BB#19:                                # %if.end65
	i32.store	$drop=, 128($2), $1
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.store	$drop=, should_optimize($pop150), $pop149
	i32.const	$push148=, .L.str.4
	i32.const	$push89=, 128
	i32.add 	$push90=, $2, $pop89
	i32.call	$push43=, __printf_chk@FUNCTION, $2, $pop148, $pop90
	i32.ne  	$push44=, $pop43, $0
	br_if   	0, $pop44       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push151=, 0
	i32.load	$push45=, should_optimize($pop151)
	i32.eqz 	$push190=, $pop45
	br_if   	0, $pop190      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push154=, 0
	i32.const	$push46=, 1
	i32.store	$drop=, should_optimize($pop154), $pop46
	i32.const	$push47=, .L.str.3
	i32.store	$0=, 112($2), $pop47
	i32.const	$push153=, .L.str.4
	i32.const	$push91=, 112
	i32.add 	$push92=, $2, $pop91
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop153, $pop92
	i32.const	$push152=, 0
	i32.load	$push48=, should_optimize($pop152)
	i32.eqz 	$push191=, $pop48
	br_if   	0, $pop191      # 0: down to label1
# BB#22:                                # %if.end76
	i32.store	$drop=, 96($2), $0
	i32.const	$push49=, 0
	i32.const	$push156=, 0
	i32.store	$0=, should_optimize($pop49), $pop156
	i32.const	$push155=, .L.str.4
	i32.const	$push93=, 96
	i32.add 	$push94=, $2, $pop93
	i32.call	$push50=, __printf_chk@FUNCTION, $2, $pop155, $pop94
	br_if   	0, $pop50       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push51=, should_optimize($0)
	i32.eqz 	$push192=, $pop51
	br_if   	0, $pop192      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push159=, 0
	i32.const	$push52=, 1
	i32.store	$0=, should_optimize($pop159), $pop52
	i32.const	$push53=, 120
	i32.store	$1=, 80($2), $pop53
	i32.const	$push158=, .L.str.5
	i32.const	$push95=, 80
	i32.add 	$push96=, $2, $pop95
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop158, $pop96
	i32.const	$push157=, 0
	i32.load	$push54=, should_optimize($pop157)
	i32.eqz 	$push193=, $pop54
	br_if   	0, $pop193      # 0: down to label1
# BB#25:                                # %if.end87
	i32.store	$drop=, 64($2), $1
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.store	$drop=, should_optimize($pop162), $pop161
	i32.const	$push160=, .L.str.5
	i32.const	$push97=, 64
	i32.add 	$push98=, $2, $pop97
	i32.call	$push55=, __printf_chk@FUNCTION, $2, $pop160, $pop98
	i32.ne  	$push56=, $pop55, $0
	br_if   	0, $pop56       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push163=, 0
	i32.load	$push57=, should_optimize($pop163)
	i32.eqz 	$push194=, $pop57
	br_if   	0, $pop194      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push166=, 0
	i32.const	$push58=, 1
	i32.store	$drop=, should_optimize($pop166), $pop58
	i32.const	$push59=, .L.str.1
	i32.store	$0=, 48($2), $pop59
	i32.const	$push165=, .L.str.6
	i32.const	$push99=, 48
	i32.add 	$push100=, $2, $pop99
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop165, $pop100
	i32.const	$push164=, 0
	i32.load	$push60=, should_optimize($pop164)
	i32.eqz 	$push195=, $pop60
	br_if   	0, $pop195      # 0: down to label1
# BB#28:                                # %if.end98
	i32.store	$drop=, 32($2), $0
	i32.const	$push61=, 0
	i32.const	$push168=, 0
	i32.store	$0=, should_optimize($pop61), $pop168
	i32.const	$push167=, .L.str.6
	i32.const	$push101=, 32
	i32.add 	$push102=, $2, $pop101
	i32.call	$push62=, __printf_chk@FUNCTION, $2, $pop167, $pop102
	i32.const	$push63=, 7
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	0, $pop64       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push65=, should_optimize($0)
	i32.eqz 	$push196=, $pop65
	br_if   	0, $pop196      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push66=, 0
	i32.store	$push171=, 16($2), $pop66
	tee_local	$push170=, $0=, $pop171
	i32.store	$drop=, should_optimize($pop170), $0
	i32.const	$push169=, .L.str.7
	i32.const	$push103=, 16
	i32.add 	$push104=, $2, $pop103
	i32.call	$drop=, __printf_chk@FUNCTION, $2, $pop169, $pop104
	i32.load	$push67=, should_optimize($0)
	i32.eqz 	$push197=, $pop67
	br_if   	0, $pop197      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push174=, 0($2), $0
	tee_local	$push173=, $0=, $pop174
	i32.store	$drop=, should_optimize($pop173), $0
	i32.const	$push172=, .L.str.7
	i32.call	$push68=, __printf_chk@FUNCTION, $2, $pop172, $2
	i32.const	$push69=, 2
	i32.ne  	$push70=, $pop68, $pop69
	br_if   	0, $pop70       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push175=, 0
	i32.load	$push71=, should_optimize($pop175)
	i32.eqz 	$push198=, $pop71
	br_if   	0, $pop198      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push78=, 0
	i32.const	$push76=, 224
	i32.add 	$push77=, $2, $pop76
	i32.store	$drop=, __stack_pointer($pop78), $pop77
	i32.const	$push176=, 0
	return  	$pop176
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
	.functype	abort, void
	.functype	vprintf, i32, i32, i32
