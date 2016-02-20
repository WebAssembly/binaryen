	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/printf-chk-1.c"
	.section	.text.__printf_chk,"ax",@progbits
	.hidden	__printf_chk
	.globl	__printf_chk
	.type	__printf_chk,@function
__printf_chk:                           # @__printf_chk
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$6=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
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
	i32.store	$push2=, 12($6), $2
	i32.call	$push4=, vfprintf@FUNCTION, $pop3, $1, $pop2
	i32.const	$5=, 16
	i32.add 	$6=, $6, $5
	i32.const	$5=, __stack_pointer
	i32.store	$6=, 0($5), $6
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 224
	i32.sub 	$18=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$18=, 0($3), $18
	i32.const	$push77=, .L.str
	i32.const	$push0=, 0
	i32.const	$push76=, 0
	i32.store	$push75=, should_optimize($pop0), $pop76
	tee_local	$push74=, $1=, $pop75
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop77, $pop74
	block
	i32.load	$push1=, should_optimize($1)
	i32.const	$push142=, 0
	i32.eq  	$push143=, $pop1, $pop142
	br_if   	0, $pop143      # 0: down to label1
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
	i32.const	$push144=, 0
	i32.eq  	$push145=, $pop6, $pop144
	br_if   	0, $pop145      # 0: down to label1
# BB#3:                                 # %if.end6
	i32.const	$push83=, 0
	i32.const	$push7=, 1
	i32.store	$discard=, should_optimize($pop83), $pop7
	i32.const	$push82=, .L.str.1
	i32.const	$push81=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop82, $pop81
	i32.const	$push80=, 0
	i32.load	$push8=, should_optimize($pop80)
	i32.const	$push146=, 0
	i32.eq  	$push147=, $pop8, $pop146
	br_if   	0, $pop147      # 0: down to label1
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
	i32.const	$push148=, 0
	i32.eq  	$push149=, $pop13, $pop148
	br_if   	0, $pop149      # 0: down to label1
# BB#6:                                 # %if.end17
	i32.const	$push91=, 0
	i32.const	$push14=, 1
	i32.store	$1=, should_optimize($pop91), $pop14
	i32.const	$push90=, .L.str.2
	i32.const	$push89=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop90, $pop89
	i32.const	$push88=, 0
	i32.load	$push15=, should_optimize($pop88)
	i32.const	$push150=, 0
	i32.eq  	$push151=, $pop15, $pop150
	br_if   	0, $pop151      # 0: down to label1
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
	i32.const	$push152=, 0
	i32.eq  	$push153=, $pop19, $pop152
	br_if   	0, $pop153      # 0: down to label1
# BB#9:                                 # %if.end28
	i32.const	$push99=, 0
	i32.const	$push20=, 1
	i32.store	$discard=, should_optimize($pop99), $pop20
	i32.const	$push98=, .L.str.3
	i32.const	$push97=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop98, $pop97
	i32.const	$push96=, 0
	i32.load	$push21=, should_optimize($pop96)
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop21, $pop154
	br_if   	0, $pop155      # 0: down to label1
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
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop24, $pop156
	br_if   	0, $pop157      # 0: down to label1
# BB#12:                                # %if.end39
	i32.const	$push25=, 0
	i32.const	$push105=, 0
	i32.store	$1=, should_optimize($pop25), $pop105
	i32.const	$push26=, .L.str
	i32.store	$0=, 208($18):p2align=4, $pop26
	i32.const	$push104=, .L.str.4
	i32.const	$5=, 208
	i32.add 	$5=, $18, $5
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop104, $5
	i32.load	$push27=, should_optimize($1)
	i32.const	$push158=, 0
	i32.eq  	$push159=, $pop27, $pop158
	br_if   	0, $pop159      # 0: down to label1
# BB#13:                                # %if.end43
	i32.store	$discard=, should_optimize($1), $1
	i32.store	$discard=, 192($18):p2align=4, $0
	i32.const	$push106=, .L.str.4
	i32.const	$6=, 192
	i32.add 	$6=, $18, $6
	i32.call	$push28=, __printf_chk@FUNCTION, $1, $pop106, $6
	i32.const	$push29=, 5
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#14:                                # %if.end47
	i32.const	$push107=, 0
	i32.load	$push31=, should_optimize($pop107)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop31, $pop160
	br_if   	0, $pop161      # 0: down to label1
# BB#15:                                # %if.end50
	i32.const	$push110=, 0
	i32.const	$push32=, 1
	i32.store	$discard=, should_optimize($pop110), $pop32
	i32.const	$push33=, .L.str.1
	i32.store	$1=, 176($18):p2align=4, $pop33
	i32.const	$push109=, .L.str.4
	i32.const	$7=, 176
	i32.add 	$7=, $18, $7
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop109, $7
	i32.const	$push108=, 0
	i32.load	$push34=, should_optimize($pop108)
	i32.const	$push162=, 0
	i32.eq  	$push163=, $pop34, $pop162
	br_if   	0, $pop163      # 0: down to label1
# BB#16:                                # %if.end54
	i32.const	$push35=, 0
	i32.const	$push112=, 0
	i32.store	$0=, should_optimize($pop35), $pop112
	i32.store	$discard=, 160($18):p2align=4, $1
	i32.const	$push111=, .L.str.4
	i32.const	$8=, 160
	i32.add 	$8=, $18, $8
	i32.call	$push36=, __printf_chk@FUNCTION, $1, $pop111, $8
	i32.const	$push37=, 6
	i32.ne  	$push38=, $pop36, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#17:                                # %if.end58
	i32.load	$push39=, should_optimize($0)
	i32.const	$push164=, 0
	i32.eq  	$push165=, $pop39, $pop164
	br_if   	0, $pop165      # 0: down to label1
# BB#18:                                # %if.end61
	i32.const	$push115=, 0
	i32.const	$push40=, 1
	i32.store	$1=, should_optimize($pop115), $pop40
	i32.const	$push41=, .L.str.2
	i32.store	$0=, 144($18):p2align=4, $pop41
	i32.const	$push114=, .L.str.4
	i32.const	$9=, 144
	i32.add 	$9=, $18, $9
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop114, $9
	i32.const	$push113=, 0
	i32.load	$push42=, should_optimize($pop113)
	i32.const	$push166=, 0
	i32.eq  	$push167=, $pop42, $pop166
	br_if   	0, $pop167      # 0: down to label1
# BB#19:                                # %if.end65
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.store	$discard=, should_optimize($pop118), $pop117
	i32.store	$discard=, 128($18):p2align=4, $0
	i32.const	$push116=, .L.str.4
	i32.const	$10=, 128
	i32.add 	$10=, $18, $10
	i32.call	$push43=, __printf_chk@FUNCTION, $1, $pop116, $10
	i32.ne  	$push44=, $pop43, $1
	br_if   	0, $pop44       # 0: down to label1
# BB#20:                                # %if.end69
	i32.const	$push119=, 0
	i32.load	$push45=, should_optimize($pop119)
	i32.const	$push168=, 0
	i32.eq  	$push169=, $pop45, $pop168
	br_if   	0, $pop169      # 0: down to label1
# BB#21:                                # %if.end72
	i32.const	$push122=, 0
	i32.const	$push46=, 1
	i32.store	$discard=, should_optimize($pop122), $pop46
	i32.const	$push47=, .L.str.3
	i32.store	$1=, 112($18):p2align=4, $pop47
	i32.const	$push121=, .L.str.4
	i32.const	$11=, 112
	i32.add 	$11=, $18, $11
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop121, $11
	i32.const	$push120=, 0
	i32.load	$push48=, should_optimize($pop120)
	i32.const	$push170=, 0
	i32.eq  	$push171=, $pop48, $pop170
	br_if   	0, $pop171      # 0: down to label1
# BB#22:                                # %if.end76
	i32.const	$push49=, 0
	i32.const	$push124=, 0
	i32.store	$0=, should_optimize($pop49), $pop124
	i32.store	$discard=, 96($18):p2align=4, $1
	i32.const	$push123=, .L.str.4
	i32.const	$12=, 96
	i32.add 	$12=, $18, $12
	i32.call	$push50=, __printf_chk@FUNCTION, $1, $pop123, $12
	br_if   	0, $pop50       # 0: down to label1
# BB#23:                                # %if.end80
	i32.load	$push51=, should_optimize($0)
	i32.const	$push172=, 0
	i32.eq  	$push173=, $pop51, $pop172
	br_if   	0, $pop173      # 0: down to label1
# BB#24:                                # %if.end83
	i32.const	$push127=, 0
	i32.const	$push52=, 1
	i32.store	$1=, should_optimize($pop127), $pop52
	i32.const	$push53=, 120
	i32.store	$0=, 80($18):p2align=4, $pop53
	i32.const	$push126=, .L.str.5
	i32.const	$13=, 80
	i32.add 	$13=, $18, $13
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop126, $13
	i32.const	$push125=, 0
	i32.load	$push54=, should_optimize($pop125)
	i32.const	$push174=, 0
	i32.eq  	$push175=, $pop54, $pop174
	br_if   	0, $pop175      # 0: down to label1
# BB#25:                                # %if.end87
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.store	$discard=, should_optimize($pop130), $pop129
	i32.store	$discard=, 64($18):p2align=4, $0
	i32.const	$push128=, .L.str.5
	i32.const	$14=, 64
	i32.add 	$14=, $18, $14
	i32.call	$push55=, __printf_chk@FUNCTION, $1, $pop128, $14
	i32.ne  	$push56=, $pop55, $1
	br_if   	0, $pop56       # 0: down to label1
# BB#26:                                # %if.end91
	i32.const	$push131=, 0
	i32.load	$push57=, should_optimize($pop131)
	i32.const	$push176=, 0
	i32.eq  	$push177=, $pop57, $pop176
	br_if   	0, $pop177      # 0: down to label1
# BB#27:                                # %if.end94
	i32.const	$push134=, 0
	i32.const	$push58=, 1
	i32.store	$discard=, should_optimize($pop134), $pop58
	i32.const	$push59=, .L.str.1
	i32.store	$1=, 48($18):p2align=4, $pop59
	i32.const	$push133=, .L.str.6
	i32.const	$15=, 48
	i32.add 	$15=, $18, $15
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop133, $15
	i32.const	$push132=, 0
	i32.load	$push60=, should_optimize($pop132)
	i32.const	$push178=, 0
	i32.eq  	$push179=, $pop60, $pop178
	br_if   	0, $pop179      # 0: down to label1
# BB#28:                                # %if.end98
	i32.const	$push61=, 0
	i32.const	$push136=, 0
	i32.store	$0=, should_optimize($pop61), $pop136
	i32.store	$discard=, 32($18):p2align=4, $1
	i32.const	$push135=, .L.str.6
	i32.const	$16=, 32
	i32.add 	$16=, $18, $16
	i32.call	$push62=, __printf_chk@FUNCTION, $1, $pop135, $16
	i32.const	$push63=, 7
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	0, $pop64       # 0: down to label1
# BB#29:                                # %if.end102
	i32.load	$push65=, should_optimize($0)
	i32.const	$push180=, 0
	i32.eq  	$push181=, $pop65, $pop180
	br_if   	0, $pop181      # 0: down to label1
# BB#30:                                # %if.end105
	i32.const	$push66=, 0
	i32.const	$push138=, 0
	i32.store	$push67=, should_optimize($pop66), $pop138
	i32.store	$1=, 16($18):p2align=4, $pop67
	i32.const	$push137=, .L.str.7
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop137, $17
	i32.load	$push68=, should_optimize($1)
	i32.const	$push182=, 0
	i32.eq  	$push183=, $pop68, $pop182
	br_if   	0, $pop183      # 0: down to label1
# BB#31:                                # %if.end109
	i32.store	$push69=, should_optimize($1), $1
	i32.store	$discard=, 0($18):p2align=4, $pop69
	i32.const	$push139=, .L.str.7
	i32.call	$push70=, __printf_chk@FUNCTION, $1, $pop139, $18
	i32.const	$push71=, 2
	i32.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#32:                                # %if.end113
	i32.const	$push140=, 0
	i32.load	$push73=, should_optimize($pop140)
	i32.const	$push184=, 0
	i32.eq  	$push185=, $pop73, $pop184
	br_if   	0, $pop185      # 0: down to label1
# BB#33:                                # %if.end116
	i32.const	$push141=, 0
	i32.const	$4=, 224
	i32.add 	$18=, $18, $4
	i32.const	$4=, __stack_pointer
	i32.store	$18=, 0($4), $18
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
