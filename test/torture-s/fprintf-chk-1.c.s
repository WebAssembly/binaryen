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
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push10=, $pop4, $pop5
	i32.store	$4=, __stack_pointer($pop6), $pop10
	block
	i32.const	$push11=, 0
	i32.load	$push1=, should_optimize($pop11)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push2=, 1
	i32.store	$drop=, should_optimize($pop12), $pop2
	i32.store	$push0=, 12($4), $3
	i32.call	$0=, vfprintf@FUNCTION, $0, $2, $pop0
	i32.const	$push9=, 0
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	$drop=, __stack_pointer($pop9), $pop8
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
	i32.const	$push74=, 0
	i32.const	$push71=, 0
	i32.load	$push72=, __stack_pointer($pop71)
	i32.const	$push73=, 224
	i32.sub 	$push104=, $pop72, $pop73
	i32.store	$2=, __stack_pointer($pop74), $pop104
	i32.const	$push111=, 0
	i32.const	$push2=, 1
	i32.store	$drop=, should_optimize($pop111), $pop2
	i32.const	$push110=, 0
	i32.load	$push109=, stdout($pop110)
	tee_local	$push108=, $3=, $pop109
	i32.const	$push107=, .L.str
	i32.const	$push106=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $pop108, $2, $pop107, $pop106
	block
	i32.const	$push105=, 0
	i32.load	$push3=, should_optimize($pop105)
	i32.eqz 	$push184=, $pop3
	br_if   	0, $pop184      # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push114=, .L.str
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.store	$push0=, should_optimize($pop113), $pop112
	i32.call	$push4=, __fprintf_chk@FUNCTION, $3, $2, $pop114, $pop0
	i32.const	$push5=, 5
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push115=, 0
	i32.load	$push7=, should_optimize($pop115)
	i32.eqz 	$push185=, $pop7
	br_if   	0, $pop185      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push119=, 0
	i32.const	$push8=, 1
	i32.store	$drop=, should_optimize($pop119), $pop8
	i32.const	$push118=, .L.str.1
	i32.const	$push117=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop118, $pop117
	i32.const	$push116=, 0
	i32.load	$push9=, should_optimize($pop116)
	i32.eqz 	$push186=, $pop9
	br_if   	0, $pop186      # 0: down to label1
# BB#4:                                 # %if.end10
	i32.const	$push123=, .L.str.1
	i32.const	$push10=, 0
	i32.const	$push122=, 0
	i32.store	$push121=, should_optimize($pop10), $pop122
	tee_local	$push120=, $1=, $pop121
	i32.call	$push11=, __fprintf_chk@FUNCTION, $3, $2, $pop123, $pop120
	i32.const	$push12=, 6
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# BB#5:                                 # %if.end14
	i32.load	$push14=, should_optimize($1)
	i32.eqz 	$push187=, $pop14
	br_if   	0, $pop187      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push127=, 0
	i32.const	$push15=, 1
	i32.store	$1=, should_optimize($pop127), $pop15
	i32.const	$push126=, .L.str.2
	i32.const	$push125=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop126, $pop125
	i32.const	$push124=, 0
	i32.load	$push16=, should_optimize($pop124)
	i32.eqz 	$push188=, $pop16
	br_if   	0, $pop188      # 0: down to label1
# BB#7:                                 # %if.end21
	i32.const	$push130=, .L.str.2
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.store	$push1=, should_optimize($pop129), $pop128
	i32.call	$push17=, __fprintf_chk@FUNCTION, $3, $2, $pop130, $pop1
	i32.ne  	$push18=, $pop17, $1
	br_if   	0, $pop18       # 0: down to label1
# BB#8:                                 # %if.end25
	i32.const	$push131=, 0
	i32.load	$push19=, should_optimize($pop131)
	i32.eqz 	$push189=, $pop19
	br_if   	0, $pop189      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push135=, 0
	i32.const	$push20=, 1
	i32.store	$drop=, should_optimize($pop135), $pop20
	i32.const	$push134=, .L.str.3
	i32.const	$push133=, 0
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop134, $pop133
	i32.const	$push132=, 0
	i32.load	$push21=, should_optimize($pop132)
	i32.eqz 	$push190=, $pop21
	br_if   	0, $pop190      # 0: down to label1
# BB#10:                                # %if.end32
	i32.const	$push139=, .L.str.3
	i32.const	$push22=, 0
	i32.const	$push138=, 0
	i32.store	$push137=, should_optimize($pop22), $pop138
	tee_local	$push136=, $1=, $pop137
	i32.call	$push23=, __fprintf_chk@FUNCTION, $3, $2, $pop139, $pop136
	br_if   	0, $pop23       # 0: down to label1
# BB#11:                                # %if.end36
	i32.load	$push24=, should_optimize($1)
	i32.eqz 	$push191=, $pop24
	br_if   	0, $pop191      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push142=, 0
	i32.const	$push25=, 1
	i32.store	$drop=, should_optimize($pop142), $pop25
	i32.const	$push26=, .L.str
	i32.store	$1=, 208($2), $pop26
	i32.const	$push141=, .L.str.4
	i32.const	$push78=, 208
	i32.add 	$push79=, $2, $pop78
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop141, $pop79
	i32.const	$push140=, 0
	i32.load	$push27=, should_optimize($pop140)
	i32.eqz 	$push192=, $pop27
	br_if   	0, $pop192      # 0: down to label1
# BB#13:                                # %if.end43
	i32.store	$drop=, 192($2), $1
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.store	$drop=, should_optimize($pop145), $pop144
	i32.const	$push143=, .L.str.4
	i32.const	$push80=, 192
	i32.add 	$push81=, $2, $pop80
	i32.call	$push28=, __fprintf_chk@FUNCTION, $3, $2, $pop143, $pop81
	i32.const	$push29=, 5
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push146=, 0
	i32.load	$push31=, should_optimize($pop146)
	i32.eqz 	$push193=, $pop31
	br_if   	0, $pop193      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push149=, 0
	i32.const	$push32=, 1
	i32.store	$drop=, should_optimize($pop149), $pop32
	i32.const	$push33=, .L.str.1
	i32.store	$1=, 176($2), $pop33
	i32.const	$push148=, .L.str.4
	i32.const	$push82=, 176
	i32.add 	$push83=, $2, $pop82
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop148, $pop83
	i32.const	$push147=, 0
	i32.load	$push34=, should_optimize($pop147)
	i32.eqz 	$push194=, $pop34
	br_if   	0, $pop194      # 0: down to label1
# BB#16:                                # %if.end54
	i32.store	$drop=, 160($2), $1
	i32.const	$push35=, 0
	i32.const	$push151=, 0
	i32.store	$1=, should_optimize($pop35), $pop151
	i32.const	$push150=, .L.str.4
	i32.const	$push84=, 160
	i32.add 	$push85=, $2, $pop84
	i32.call	$push36=, __fprintf_chk@FUNCTION, $3, $2, $pop150, $pop85
	i32.const	$push37=, 6
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push39=, should_optimize($1)
	i32.eqz 	$push195=, $pop39
	br_if   	0, $pop195      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push154=, 0
	i32.const	$push40=, 1
	i32.store	$1=, should_optimize($pop154), $pop40
	i32.const	$push41=, .L.str.2
	i32.store	$0=, 144($2), $pop41
	i32.const	$push153=, .L.str.4
	i32.const	$push86=, 144
	i32.add 	$push87=, $2, $pop86
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop153, $pop87
	i32.const	$push152=, 0
	i32.load	$push42=, should_optimize($pop152)
	i32.eqz 	$push196=, $pop42
	br_if   	0, $pop196      # 0: down to label1
# BB#19:                                # %if.end65
	i32.store	$drop=, 128($2), $0
	i32.const	$push157=, 0
	i32.const	$push156=, 0
	i32.store	$drop=, should_optimize($pop157), $pop156
	i32.const	$push155=, .L.str.4
	i32.const	$push88=, 128
	i32.add 	$push89=, $2, $pop88
	i32.call	$push43=, __fprintf_chk@FUNCTION, $3, $2, $pop155, $pop89
	i32.ne  	$push44=, $pop43, $1
	br_if   	0, $pop44       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push158=, 0
	i32.load	$push45=, should_optimize($pop158)
	i32.eqz 	$push197=, $pop45
	br_if   	0, $pop197      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push161=, 0
	i32.const	$push46=, 1
	i32.store	$drop=, should_optimize($pop161), $pop46
	i32.const	$push47=, .L.str.3
	i32.store	$1=, 112($2), $pop47
	i32.const	$push160=, .L.str.4
	i32.const	$push90=, 112
	i32.add 	$push91=, $2, $pop90
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop160, $pop91
	i32.const	$push159=, 0
	i32.load	$push48=, should_optimize($pop159)
	i32.eqz 	$push198=, $pop48
	br_if   	0, $pop198      # 0: down to label1
# BB#22:                                # %if.end76
	i32.store	$drop=, 96($2), $1
	i32.const	$push49=, 0
	i32.const	$push163=, 0
	i32.store	$1=, should_optimize($pop49), $pop163
	i32.const	$push162=, .L.str.4
	i32.const	$push92=, 96
	i32.add 	$push93=, $2, $pop92
	i32.call	$push50=, __fprintf_chk@FUNCTION, $3, $2, $pop162, $pop93
	br_if   	0, $pop50       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push51=, should_optimize($1)
	i32.eqz 	$push199=, $pop51
	br_if   	0, $pop199      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push166=, 0
	i32.const	$push52=, 1
	i32.store	$1=, should_optimize($pop166), $pop52
	i32.const	$push53=, 120
	i32.store	$0=, 80($2), $pop53
	i32.const	$push165=, .L.str.5
	i32.const	$push94=, 80
	i32.add 	$push95=, $2, $pop94
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop165, $pop95
	i32.const	$push164=, 0
	i32.load	$push54=, should_optimize($pop164)
	i32.eqz 	$push200=, $pop54
	br_if   	0, $pop200      # 0: down to label1
# BB#25:                                # %if.end87
	i32.store	$drop=, 64($2), $0
	i32.const	$push169=, 0
	i32.const	$push168=, 0
	i32.store	$drop=, should_optimize($pop169), $pop168
	i32.const	$push167=, .L.str.5
	i32.const	$push96=, 64
	i32.add 	$push97=, $2, $pop96
	i32.call	$push55=, __fprintf_chk@FUNCTION, $3, $2, $pop167, $pop97
	i32.ne  	$push56=, $pop55, $1
	br_if   	0, $pop56       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push170=, 0
	i32.load	$push57=, should_optimize($pop170)
	i32.eqz 	$push201=, $pop57
	br_if   	0, $pop201      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push58=, .L.str.1
	i32.store	$1=, 48($2), $pop58
	i32.const	$push173=, 0
	i32.const	$push172=, 0
	i32.store	$0=, should_optimize($pop173), $pop172
	i32.const	$push171=, .L.str.6
	i32.const	$push98=, 48
	i32.add 	$push99=, $2, $pop98
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop171, $pop99
	i32.load	$push59=, should_optimize($0)
	i32.eqz 	$push202=, $pop59
	br_if   	0, $pop202      # 0: down to label1
# BB#28:                                # %if.end98
	i32.store	$drop=, 32($2), $1
	i32.const	$push60=, 0
	i32.const	$push175=, 0
	i32.store	$1=, should_optimize($pop60), $pop175
	i32.const	$push174=, .L.str.6
	i32.const	$push100=, 32
	i32.add 	$push101=, $2, $pop100
	i32.call	$push61=, __fprintf_chk@FUNCTION, $3, $2, $pop174, $pop101
	i32.const	$push62=, 7
	i32.ne  	$push63=, $pop61, $pop62
	br_if   	0, $pop63       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push64=, should_optimize($1)
	i32.eqz 	$push203=, $pop64
	br_if   	0, $pop203      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push65=, 0
	i32.store	$push178=, 16($2), $pop65
	tee_local	$push177=, $1=, $pop178
	i32.store	$drop=, should_optimize($pop177), $1
	i32.const	$push176=, .L.str.7
	i32.const	$push102=, 16
	i32.add 	$push103=, $2, $pop102
	i32.call	$drop=, __fprintf_chk@FUNCTION, $3, $2, $pop176, $pop103
	i32.load	$push66=, should_optimize($1)
	i32.eqz 	$push204=, $pop66
	br_if   	0, $pop204      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push181=, 0($2), $1
	tee_local	$push180=, $1=, $pop181
	i32.store	$drop=, should_optimize($pop180), $1
	i32.const	$push179=, .L.str.7
	i32.call	$push67=, __fprintf_chk@FUNCTION, $3, $2, $pop179, $2
	i32.const	$push68=, 2
	i32.ne  	$push69=, $pop67, $pop68
	br_if   	0, $pop69       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push182=, 0
	i32.load	$push70=, should_optimize($pop182)
	i32.eqz 	$push205=, $pop70
	br_if   	0, $pop205      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push77=, 0
	i32.const	$push75=, 224
	i32.add 	$push76=, $2, $pop75
	i32.store	$drop=, __stack_pointer($pop77), $pop76
	i32.const	$push183=, 0
	return  	$pop183
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
	.functype	vfprintf, i32, i32, i32, i32
