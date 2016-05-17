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
	i32.const	$push6=, __stack_pointer
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$3=, 0($pop6), $pop10
	block
	i32.const	$push11=, 0
	i32.load	$push1=, should_optimize($pop11)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push2=, 1
	i32.store	$discard=, should_optimize($pop12), $pop2
	i32.store	$push0=, 12($3), $2
	i32.call	$1=, vprintf@FUNCTION, $1, $pop0
	i32.const	$push9=, __stack_pointer
	i32.const	$push7=, 16
	i32.add 	$push8=, $3, $pop7
	i32.store	$discard=, 0($pop9), $pop8
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
	i32.const	$push77=, __stack_pointer
	i32.const	$push74=, __stack_pointer
	i32.load	$push75=, 0($pop74)
	i32.const	$push76=, 224
	i32.sub 	$push107=, $pop75, $pop76
	i32.store	$1=, 0($pop77), $pop107
	i32.const	$push111=, .L.str
	i32.const	$push4=, 0
	i32.const	$push110=, 0
	i32.store	$push109=, should_optimize($pop4), $pop110
	tee_local	$push108=, $2=, $pop109
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop111, $pop108
	block
	i32.load	$push5=, should_optimize($2)
	i32.eqz 	$push176=, $pop5
	br_if   	0, $pop176      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push112=, .L.str
	i32.store	$push0=, should_optimize($2), $2
	i32.call	$push6=, __printf_chk@FUNCTION, $1, $pop112, $pop0
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push113=, 0
	i32.load	$push9=, should_optimize($pop113)
	i32.eqz 	$push177=, $pop9
	br_if   	0, $pop177      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push117=, 0
	i32.const	$push10=, 1
	i32.store	$discard=, should_optimize($pop117), $pop10
	i32.const	$push116=, .L.str.1
	i32.const	$push115=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop116, $pop115
	i32.const	$push114=, 0
	i32.load	$push11=, should_optimize($pop114)
	i32.eqz 	$push178=, $pop11
	br_if   	0, $pop178      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push121=, .L.str.1
	i32.const	$push12=, 0
	i32.const	$push120=, 0
	i32.store	$push119=, should_optimize($pop12), $pop120
	tee_local	$push118=, $2=, $pop119
	i32.call	$push13=, __printf_chk@FUNCTION, $1, $pop121, $pop118
	i32.const	$push14=, 6
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push16=, should_optimize($2)
	i32.eqz 	$push179=, $pop16
	br_if   	0, $pop179      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push125=, 0
	i32.const	$push17=, 1
	i32.store	$2=, should_optimize($pop125), $pop17
	i32.const	$push124=, .L.str.2
	i32.const	$push123=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop124, $pop123
	i32.const	$push122=, 0
	i32.load	$push18=, should_optimize($pop122)
	i32.eqz 	$push180=, $pop18
	br_if   	0, $pop180      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push128=, .L.str.2
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.store	$push1=, should_optimize($pop127), $pop126
	i32.call	$push19=, __printf_chk@FUNCTION, $1, $pop128, $pop1
	i32.ne  	$push20=, $pop19, $2
	br_if   	0, $pop20       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push129=, 0
	i32.load	$push21=, should_optimize($pop129)
	i32.eqz 	$push181=, $pop21
	br_if   	0, $pop181      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push133=, 0
	i32.const	$push22=, 1
	i32.store	$discard=, should_optimize($pop133), $pop22
	i32.const	$push132=, .L.str.3
	i32.const	$push131=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop132, $pop131
	i32.const	$push130=, 0
	i32.load	$push23=, should_optimize($pop130)
	i32.eqz 	$push182=, $pop23
	br_if   	0, $pop182      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push137=, .L.str.3
	i32.const	$push24=, 0
	i32.const	$push136=, 0
	i32.store	$push135=, should_optimize($pop24), $pop136
	tee_local	$push134=, $2=, $pop135
	i32.call	$push25=, __printf_chk@FUNCTION, $1, $pop137, $pop134
	br_if   	0, $pop25       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push26=, should_optimize($2)
	i32.eqz 	$push183=, $pop26
	br_if   	0, $pop183      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push27=, 0
	i32.const	$push139=, 0
	i32.store	$2=, should_optimize($pop27), $pop139
	i32.const	$push28=, .L.str
	i32.store	$0=, 208($1), $pop28
	i32.const	$push138=, .L.str.4
	i32.const	$push81=, 208
	i32.add 	$push82=, $1, $pop81
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop138, $pop82
	i32.load	$push29=, should_optimize($2)
	i32.eqz 	$push184=, $pop29
	br_if   	0, $pop184      # 0: down to label1
# BB#13:                                # %if.end43
	i32.store	$discard=, should_optimize($2), $2
	i32.store	$discard=, 192($1), $0
	i32.const	$push140=, .L.str.4
	i32.const	$push83=, 192
	i32.add 	$push84=, $1, $pop83
	i32.call	$push30=, __printf_chk@FUNCTION, $1, $pop140, $pop84
	i32.const	$push31=, 5
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push141=, 0
	i32.load	$push33=, should_optimize($pop141)
	i32.eqz 	$push185=, $pop33
	br_if   	0, $pop185      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push144=, 0
	i32.const	$push34=, 1
	i32.store	$discard=, should_optimize($pop144), $pop34
	i32.const	$push35=, .L.str.1
	i32.store	$2=, 176($1), $pop35
	i32.const	$push143=, .L.str.4
	i32.const	$push85=, 176
	i32.add 	$push86=, $1, $pop85
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop143, $pop86
	i32.const	$push142=, 0
	i32.load	$push36=, should_optimize($pop142)
	i32.eqz 	$push186=, $pop36
	br_if   	0, $pop186      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push37=, 0
	i32.const	$push146=, 0
	i32.store	$0=, should_optimize($pop37), $pop146
	i32.store	$discard=, 160($1), $2
	i32.const	$push145=, .L.str.4
	i32.const	$push87=, 160
	i32.add 	$push88=, $1, $pop87
	i32.call	$push38=, __printf_chk@FUNCTION, $1, $pop145, $pop88
	i32.const	$push39=, 6
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push41=, should_optimize($0)
	i32.eqz 	$push187=, $pop41
	br_if   	0, $pop187      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push149=, 0
	i32.const	$push42=, 1
	i32.store	$2=, should_optimize($pop149), $pop42
	i32.const	$push43=, .L.str.2
	i32.store	$0=, 144($1), $pop43
	i32.const	$push148=, .L.str.4
	i32.const	$push89=, 144
	i32.add 	$push90=, $1, $pop89
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop148, $pop90
	i32.const	$push147=, 0
	i32.load	$push44=, should_optimize($pop147)
	i32.eqz 	$push188=, $pop44
	br_if   	0, $pop188      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push152=, 0
	i32.const	$push151=, 0
	i32.store	$discard=, should_optimize($pop152), $pop151
	i32.store	$discard=, 128($1), $0
	i32.const	$push150=, .L.str.4
	i32.const	$push91=, 128
	i32.add 	$push92=, $1, $pop91
	i32.call	$push45=, __printf_chk@FUNCTION, $1, $pop150, $pop92
	i32.ne  	$push46=, $pop45, $2
	br_if   	0, $pop46       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push153=, 0
	i32.load	$push47=, should_optimize($pop153)
	i32.eqz 	$push189=, $pop47
	br_if   	0, $pop189      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push156=, 0
	i32.const	$push48=, 1
	i32.store	$discard=, should_optimize($pop156), $pop48
	i32.const	$push49=, .L.str.3
	i32.store	$2=, 112($1), $pop49
	i32.const	$push155=, .L.str.4
	i32.const	$push93=, 112
	i32.add 	$push94=, $1, $pop93
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop155, $pop94
	i32.const	$push154=, 0
	i32.load	$push50=, should_optimize($pop154)
	i32.eqz 	$push190=, $pop50
	br_if   	0, $pop190      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push51=, 0
	i32.const	$push158=, 0
	i32.store	$0=, should_optimize($pop51), $pop158
	i32.store	$discard=, 96($1), $2
	i32.const	$push157=, .L.str.4
	i32.const	$push95=, 96
	i32.add 	$push96=, $1, $pop95
	i32.call	$push52=, __printf_chk@FUNCTION, $1, $pop157, $pop96
	br_if   	0, $pop52       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push53=, should_optimize($0)
	i32.eqz 	$push191=, $pop53
	br_if   	0, $pop191      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push161=, 0
	i32.const	$push54=, 1
	i32.store	$2=, should_optimize($pop161), $pop54
	i32.const	$push55=, 120
	i32.store	$0=, 80($1), $pop55
	i32.const	$push160=, .L.str.5
	i32.const	$push97=, 80
	i32.add 	$push98=, $1, $pop97
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop160, $pop98
	i32.const	$push159=, 0
	i32.load	$push56=, should_optimize($pop159)
	i32.eqz 	$push192=, $pop56
	br_if   	0, $pop192      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.store	$discard=, should_optimize($pop164), $pop163
	i32.store	$discard=, 64($1), $0
	i32.const	$push162=, .L.str.5
	i32.const	$push99=, 64
	i32.add 	$push100=, $1, $pop99
	i32.call	$push57=, __printf_chk@FUNCTION, $1, $pop162, $pop100
	i32.ne  	$push58=, $pop57, $2
	br_if   	0, $pop58       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push165=, 0
	i32.load	$push59=, should_optimize($pop165)
	i32.eqz 	$push193=, $pop59
	br_if   	0, $pop193      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push168=, 0
	i32.const	$push60=, 1
	i32.store	$discard=, should_optimize($pop168), $pop60
	i32.const	$push61=, .L.str.1
	i32.store	$2=, 48($1), $pop61
	i32.const	$push167=, .L.str.6
	i32.const	$push101=, 48
	i32.add 	$push102=, $1, $pop101
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop167, $pop102
	i32.const	$push166=, 0
	i32.load	$push62=, should_optimize($pop166)
	i32.eqz 	$push194=, $pop62
	br_if   	0, $pop194      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push63=, 0
	i32.const	$push170=, 0
	i32.store	$0=, should_optimize($pop63), $pop170
	i32.store	$discard=, 32($1), $2
	i32.const	$push169=, .L.str.6
	i32.const	$push103=, 32
	i32.add 	$push104=, $1, $pop103
	i32.call	$push64=, __printf_chk@FUNCTION, $1, $pop169, $pop104
	i32.const	$push65=, 7
	i32.ne  	$push66=, $pop64, $pop65
	br_if   	0, $pop66       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push67=, should_optimize($0)
	i32.eqz 	$push195=, $pop67
	br_if   	0, $pop195      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push68=, 0
	i32.const	$push172=, 0
	i32.store	$push2=, should_optimize($pop68), $pop172
	i32.store	$2=, 16($1), $pop2
	i32.const	$push171=, .L.str.7
	i32.const	$push105=, 16
	i32.add 	$push106=, $1, $pop105
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop171, $pop106
	i32.load	$push69=, should_optimize($2)
	i32.eqz 	$push196=, $pop69
	br_if   	0, $pop196      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push3=, should_optimize($2), $2
	i32.store	$discard=, 0($1), $pop3
	i32.const	$push173=, .L.str.7
	i32.call	$push70=, __printf_chk@FUNCTION, $1, $pop173, $1
	i32.const	$push71=, 2
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push174=, 0
	i32.load	$push73=, should_optimize($pop174)
	i32.eqz 	$push197=, $pop73
	br_if   	0, $pop197      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push80=, __stack_pointer
	i32.const	$push78=, 224
	i32.add 	$push79=, $1, $pop78
	i32.store	$discard=, 0($pop80), $pop79
	i32.const	$push175=, 0
	return  	$pop175
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
