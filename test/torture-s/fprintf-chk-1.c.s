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
	i32.const	$push76=, __stack_pointer
	i32.const	$push73=, __stack_pointer
	i32.load	$push74=, 0($pop73)
	i32.const	$push75=, 224
	i32.sub 	$push106=, $pop74, $pop75
	i32.store	$2=, 0($pop76), $pop106
	i32.const	$push113=, 0
	i32.const	$push4=, 1
	i32.store	$discard=, should_optimize($pop113), $pop4
	i32.const	$push112=, 0
	i32.load	$push111=, stdout($pop112)
	tee_local	$push110=, $3=, $pop111
	i32.const	$push109=, .L.str
	i32.const	$push108=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $pop110, $2, $pop109, $pop108
	block
	i32.const	$push107=, 0
	i32.load	$push5=, should_optimize($pop107)
	i32.eqz 	$push183=, $pop5
	br_if   	0, $pop183      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push116=, .L.str
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.store	$push0=, should_optimize($pop115), $pop114
	i32.call	$push6=, __fprintf_chk@FUNCTION, $3, $2, $pop116, $pop0
	i32.const	$push7=, 5
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push117=, 0
	i32.load	$push9=, should_optimize($pop117)
	i32.eqz 	$push184=, $pop9
	br_if   	0, $pop184      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push121=, 0
	i32.const	$push10=, 1
	i32.store	$discard=, should_optimize($pop121), $pop10
	i32.const	$push120=, .L.str.1
	i32.const	$push119=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop120, $pop119
	i32.const	$push118=, 0
	i32.load	$push11=, should_optimize($pop118)
	i32.eqz 	$push185=, $pop11
	br_if   	0, $pop185      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push125=, .L.str.1
	i32.const	$push12=, 0
	i32.const	$push124=, 0
	i32.store	$push123=, should_optimize($pop12), $pop124
	tee_local	$push122=, $1=, $pop123
	i32.call	$push13=, __fprintf_chk@FUNCTION, $3, $2, $pop125, $pop122
	i32.const	$push14=, 6
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push16=, should_optimize($1)
	i32.eqz 	$push186=, $pop16
	br_if   	0, $pop186      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push129=, 0
	i32.const	$push17=, 1
	i32.store	$1=, should_optimize($pop129), $pop17
	i32.const	$push128=, .L.str.2
	i32.const	$push127=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop128, $pop127
	i32.const	$push126=, 0
	i32.load	$push18=, should_optimize($pop126)
	i32.eqz 	$push187=, $pop18
	br_if   	0, $pop187      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push132=, .L.str.2
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.store	$push1=, should_optimize($pop131), $pop130
	i32.call	$push19=, __fprintf_chk@FUNCTION, $3, $2, $pop132, $pop1
	i32.ne  	$push20=, $pop19, $1
	br_if   	0, $pop20       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push133=, 0
	i32.load	$push21=, should_optimize($pop133)
	i32.eqz 	$push188=, $pop21
	br_if   	0, $pop188      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push137=, 0
	i32.const	$push22=, 1
	i32.store	$discard=, should_optimize($pop137), $pop22
	i32.const	$push136=, .L.str.3
	i32.const	$push135=, 0
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop136, $pop135
	i32.const	$push134=, 0
	i32.load	$push23=, should_optimize($pop134)
	i32.eqz 	$push189=, $pop23
	br_if   	0, $pop189      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push141=, .L.str.3
	i32.const	$push24=, 0
	i32.const	$push140=, 0
	i32.store	$push139=, should_optimize($pop24), $pop140
	tee_local	$push138=, $1=, $pop139
	i32.call	$push25=, __fprintf_chk@FUNCTION, $3, $2, $pop141, $pop138
	br_if   	0, $pop25       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push26=, should_optimize($1)
	i32.eqz 	$push190=, $pop26
	br_if   	0, $pop190      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push144=, 0
	i32.const	$push27=, 1
	i32.store	$discard=, should_optimize($pop144), $pop27
	i32.const	$push28=, .L.str
	i32.store	$1=, 208($2), $pop28
	i32.const	$push143=, .L.str.4
	i32.const	$push80=, 208
	i32.add 	$push81=, $2, $pop80
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop143, $pop81
	i32.const	$push142=, 0
	i32.load	$push29=, should_optimize($pop142)
	i32.eqz 	$push191=, $pop29
	br_if   	0, $pop191      # 0: down to label1
# BB#13:                                # %if.end43
	i32.const	$push147=, 0
	i32.const	$push146=, 0
	i32.store	$discard=, should_optimize($pop147), $pop146
	i32.store	$discard=, 192($2), $1
	i32.const	$push145=, .L.str.4
	i32.const	$push82=, 192
	i32.add 	$push83=, $2, $pop82
	i32.call	$push30=, __fprintf_chk@FUNCTION, $3, $2, $pop145, $pop83
	i32.const	$push31=, 5
	i32.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push148=, 0
	i32.load	$push33=, should_optimize($pop148)
	i32.eqz 	$push192=, $pop33
	br_if   	0, $pop192      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push151=, 0
	i32.const	$push34=, 1
	i32.store	$discard=, should_optimize($pop151), $pop34
	i32.const	$push35=, .L.str.1
	i32.store	$1=, 176($2), $pop35
	i32.const	$push150=, .L.str.4
	i32.const	$push84=, 176
	i32.add 	$push85=, $2, $pop84
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop150, $pop85
	i32.const	$push149=, 0
	i32.load	$push36=, should_optimize($pop149)
	i32.eqz 	$push193=, $pop36
	br_if   	0, $pop193      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push37=, 0
	i32.const	$push153=, 0
	i32.store	$0=, should_optimize($pop37), $pop153
	i32.store	$discard=, 160($2), $1
	i32.const	$push152=, .L.str.4
	i32.const	$push86=, 160
	i32.add 	$push87=, $2, $pop86
	i32.call	$push38=, __fprintf_chk@FUNCTION, $3, $2, $pop152, $pop87
	i32.const	$push39=, 6
	i32.ne  	$push40=, $pop38, $pop39
	br_if   	0, $pop40       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push41=, should_optimize($0)
	i32.eqz 	$push194=, $pop41
	br_if   	0, $pop194      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push156=, 0
	i32.const	$push42=, 1
	i32.store	$1=, should_optimize($pop156), $pop42
	i32.const	$push43=, .L.str.2
	i32.store	$0=, 144($2), $pop43
	i32.const	$push155=, .L.str.4
	i32.const	$push88=, 144
	i32.add 	$push89=, $2, $pop88
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop155, $pop89
	i32.const	$push154=, 0
	i32.load	$push44=, should_optimize($pop154)
	i32.eqz 	$push195=, $pop44
	br_if   	0, $pop195      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.store	$discard=, should_optimize($pop159), $pop158
	i32.store	$discard=, 128($2), $0
	i32.const	$push157=, .L.str.4
	i32.const	$push90=, 128
	i32.add 	$push91=, $2, $pop90
	i32.call	$push45=, __fprintf_chk@FUNCTION, $3, $2, $pop157, $pop91
	i32.ne  	$push46=, $pop45, $1
	br_if   	0, $pop46       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push160=, 0
	i32.load	$push47=, should_optimize($pop160)
	i32.eqz 	$push196=, $pop47
	br_if   	0, $pop196      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push163=, 0
	i32.const	$push48=, 1
	i32.store	$discard=, should_optimize($pop163), $pop48
	i32.const	$push49=, .L.str.3
	i32.store	$1=, 112($2), $pop49
	i32.const	$push162=, .L.str.4
	i32.const	$push92=, 112
	i32.add 	$push93=, $2, $pop92
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop162, $pop93
	i32.const	$push161=, 0
	i32.load	$push50=, should_optimize($pop161)
	i32.eqz 	$push197=, $pop50
	br_if   	0, $pop197      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push51=, 0
	i32.const	$push165=, 0
	i32.store	$0=, should_optimize($pop51), $pop165
	i32.store	$discard=, 96($2), $1
	i32.const	$push164=, .L.str.4
	i32.const	$push94=, 96
	i32.add 	$push95=, $2, $pop94
	i32.call	$push52=, __fprintf_chk@FUNCTION, $3, $2, $pop164, $pop95
	br_if   	0, $pop52       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push53=, should_optimize($0)
	i32.eqz 	$push198=, $pop53
	br_if   	0, $pop198      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push168=, 0
	i32.const	$push54=, 1
	i32.store	$1=, should_optimize($pop168), $pop54
	i32.const	$push55=, 120
	i32.store	$0=, 80($2), $pop55
	i32.const	$push167=, .L.str.5
	i32.const	$push96=, 80
	i32.add 	$push97=, $2, $pop96
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop167, $pop97
	i32.const	$push166=, 0
	i32.load	$push56=, should_optimize($pop166)
	i32.eqz 	$push199=, $pop56
	br_if   	0, $pop199      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push171=, 0
	i32.const	$push170=, 0
	i32.store	$discard=, should_optimize($pop171), $pop170
	i32.store	$discard=, 64($2), $0
	i32.const	$push169=, .L.str.5
	i32.const	$push98=, 64
	i32.add 	$push99=, $2, $pop98
	i32.call	$push57=, __fprintf_chk@FUNCTION, $3, $2, $pop169, $pop99
	i32.ne  	$push58=, $pop57, $1
	br_if   	0, $pop58       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push172=, 0
	i32.load	$push59=, should_optimize($pop172)
	i32.eqz 	$push200=, $pop59
	br_if   	0, $pop200      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push175=, 0
	i32.const	$push174=, 0
	i32.store	$1=, should_optimize($pop175), $pop174
	i32.const	$push60=, .L.str.1
	i32.store	$0=, 48($2), $pop60
	i32.const	$push173=, .L.str.6
	i32.const	$push100=, 48
	i32.add 	$push101=, $2, $pop100
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop173, $pop101
	i32.load	$push61=, should_optimize($1)
	i32.eqz 	$push201=, $pop61
	br_if   	0, $pop201      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push62=, 0
	i32.const	$push177=, 0
	i32.store	$1=, should_optimize($pop62), $pop177
	i32.store	$discard=, 32($2), $0
	i32.const	$push176=, .L.str.6
	i32.const	$push102=, 32
	i32.add 	$push103=, $2, $pop102
	i32.call	$push63=, __fprintf_chk@FUNCTION, $3, $2, $pop176, $pop103
	i32.const	$push64=, 7
	i32.ne  	$push65=, $pop63, $pop64
	br_if   	0, $pop65       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push66=, should_optimize($1)
	i32.eqz 	$push202=, $pop66
	br_if   	0, $pop202      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push67=, 0
	i32.const	$push179=, 0
	i32.store	$push2=, should_optimize($pop67), $pop179
	i32.store	$1=, 16($2), $pop2
	i32.const	$push178=, .L.str.7
	i32.const	$push104=, 16
	i32.add 	$push105=, $2, $pop104
	i32.call	$discard=, __fprintf_chk@FUNCTION, $3, $2, $pop178, $pop105
	i32.load	$push68=, should_optimize($1)
	i32.eqz 	$push203=, $pop68
	br_if   	0, $pop203      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push3=, should_optimize($1), $1
	i32.store	$discard=, 0($2), $pop3
	i32.const	$push180=, .L.str.7
	i32.call	$push69=, __fprintf_chk@FUNCTION, $3, $2, $pop180, $2
	i32.const	$push70=, 2
	i32.ne  	$push71=, $pop69, $pop70
	br_if   	0, $pop71       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push181=, 0
	i32.load	$push72=, should_optimize($pop181)
	i32.eqz 	$push204=, $pop72
	br_if   	0, $pop204      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push79=, __stack_pointer
	i32.const	$push77=, 224
	i32.add 	$push78=, $2, $pop77
	i32.store	$discard=, 0($pop79), $pop78
	i32.const	$push182=, 0
	return  	$pop182
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
