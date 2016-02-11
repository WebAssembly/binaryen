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
	i32.const	$push79=, .L.str
	i32.const	$push0=, 0
	i32.const	$push78=, 0
	i32.store	$push1=, should_optimize($pop0), $pop78
	tee_local	$push77=, $1=, $pop1
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop79, $pop77
	block
	i32.load	$push2=, should_optimize($1)
	i32.const	$push142=, 0
	i32.eq  	$push143=, $pop2, $pop142
	br_if   	0, $pop143      # 0: down to label1
# BB#1:                                 # %if.end
	block
	i32.const	$push80=, .L.str
	i32.store	$push3=, should_optimize($1), $1
	i32.call	$push4=, __printf_chk@FUNCTION, $1, $pop80, $pop3
	i32.const	$push5=, 5
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label2
# BB#2:                                 # %if.end3
	block
	i32.const	$push81=, 0
	i32.load	$push7=, should_optimize($pop81)
	i32.const	$push144=, 0
	i32.eq  	$push145=, $pop7, $pop144
	br_if   	0, $pop145      # 0: down to label3
# BB#3:                                 # %if.end6
	i32.const	$push85=, 0
	i32.const	$push8=, 1
	i32.store	$discard=, should_optimize($pop85), $pop8
	i32.const	$push84=, .L.str.1
	i32.const	$push83=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop84, $pop83
	block
	i32.const	$push82=, 0
	i32.load	$push9=, should_optimize($pop82)
	i32.const	$push146=, 0
	i32.eq  	$push147=, $pop9, $pop146
	br_if   	0, $pop147      # 0: down to label4
# BB#4:                                 # %if.end10
	block
	i32.const	$push88=, .L.str.1
	i32.const	$push10=, 0
	i32.const	$push87=, 0
	i32.store	$push11=, should_optimize($pop10), $pop87
	tee_local	$push86=, $1=, $pop11
	i32.call	$push12=, __printf_chk@FUNCTION, $1, $pop88, $pop86
	i32.const	$push13=, 6
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label5
# BB#5:                                 # %if.end14
	block
	i32.load	$push15=, should_optimize($1)
	i32.const	$push148=, 0
	i32.eq  	$push149=, $pop15, $pop148
	br_if   	0, $pop149      # 0: down to label6
# BB#6:                                 # %if.end17
	i32.const	$push92=, 0
	i32.const	$push16=, 1
	i32.store	$1=, should_optimize($pop92), $pop16
	i32.const	$push91=, .L.str.2
	i32.const	$push90=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop91, $pop90
	block
	i32.const	$push89=, 0
	i32.load	$push17=, should_optimize($pop89)
	i32.const	$push150=, 0
	i32.eq  	$push151=, $pop17, $pop150
	br_if   	0, $pop151      # 0: down to label7
# BB#7:                                 # %if.end21
	block
	i32.const	$push95=, .L.str.2
	i32.const	$push94=, 0
	i32.const	$push93=, 0
	i32.store	$push18=, should_optimize($pop94), $pop93
	i32.call	$push19=, __printf_chk@FUNCTION, $1, $pop95, $pop18
	i32.ne  	$push20=, $pop19, $1
	br_if   	0, $pop20       # 0: down to label8
# BB#8:                                 # %if.end25
	block
	i32.const	$push96=, 0
	i32.load	$push21=, should_optimize($pop96)
	i32.const	$push152=, 0
	i32.eq  	$push153=, $pop21, $pop152
	br_if   	0, $pop153      # 0: down to label9
# BB#9:                                 # %if.end28
	i32.const	$push100=, 0
	i32.const	$push22=, 1
	i32.store	$discard=, should_optimize($pop100), $pop22
	i32.const	$push99=, .L.str.3
	i32.const	$push98=, 0
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop99, $pop98
	block
	i32.const	$push97=, 0
	i32.load	$push23=, should_optimize($pop97)
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop23, $pop154
	br_if   	0, $pop155      # 0: down to label10
# BB#10:                                # %if.end32
	block
	i32.const	$push103=, .L.str.3
	i32.const	$push24=, 0
	i32.const	$push102=, 0
	i32.store	$push25=, should_optimize($pop24), $pop102
	tee_local	$push101=, $1=, $pop25
	i32.call	$push26=, __printf_chk@FUNCTION, $1, $pop103, $pop101
	br_if   	0, $pop26       # 0: down to label11
# BB#11:                                # %if.end36
	block
	i32.load	$push27=, should_optimize($1)
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop27, $pop156
	br_if   	0, $pop157      # 0: down to label12
# BB#12:                                # %if.end39
	i32.const	$push28=, 0
	i32.const	$push105=, 0
	i32.store	$1=, should_optimize($pop28), $pop105
	i32.const	$push29=, .L.str
	i32.store	$0=, 208($18):p2align=4, $pop29
	i32.const	$push104=, .L.str.4
	i32.const	$5=, 208
	i32.add 	$5=, $18, $5
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop104, $5
	block
	i32.load	$push30=, should_optimize($1)
	i32.const	$push158=, 0
	i32.eq  	$push159=, $pop30, $pop158
	br_if   	0, $pop159      # 0: down to label13
# BB#13:                                # %if.end43
	i32.store	$discard=, should_optimize($1), $1
	i32.store	$discard=, 192($18):p2align=4, $0
	i32.const	$push106=, .L.str.4
	i32.const	$6=, 192
	i32.add 	$6=, $18, $6
	block
	i32.call	$push31=, __printf_chk@FUNCTION, $1, $pop106, $6
	i32.const	$push32=, 5
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label14
# BB#14:                                # %if.end47
	block
	i32.const	$push107=, 0
	i32.load	$push34=, should_optimize($pop107)
	i32.const	$push160=, 0
	i32.eq  	$push161=, $pop34, $pop160
	br_if   	0, $pop161      # 0: down to label15
# BB#15:                                # %if.end50
	i32.const	$push110=, 0
	i32.const	$push35=, 1
	i32.store	$discard=, should_optimize($pop110), $pop35
	i32.const	$push36=, .L.str.1
	i32.store	$1=, 176($18):p2align=4, $pop36
	i32.const	$push109=, .L.str.4
	i32.const	$7=, 176
	i32.add 	$7=, $18, $7
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop109, $7
	block
	i32.const	$push108=, 0
	i32.load	$push37=, should_optimize($pop108)
	i32.const	$push162=, 0
	i32.eq  	$push163=, $pop37, $pop162
	br_if   	0, $pop163      # 0: down to label16
# BB#16:                                # %if.end54
	i32.const	$push38=, 0
	i32.const	$push112=, 0
	i32.store	$0=, should_optimize($pop38), $pop112
	i32.store	$discard=, 160($18):p2align=4, $1
	i32.const	$push111=, .L.str.4
	i32.const	$8=, 160
	i32.add 	$8=, $18, $8
	block
	i32.call	$push39=, __printf_chk@FUNCTION, $1, $pop111, $8
	i32.const	$push40=, 6
	i32.ne  	$push41=, $pop39, $pop40
	br_if   	0, $pop41       # 0: down to label17
# BB#17:                                # %if.end58
	block
	i32.load	$push42=, should_optimize($0)
	i32.const	$push164=, 0
	i32.eq  	$push165=, $pop42, $pop164
	br_if   	0, $pop165      # 0: down to label18
# BB#18:                                # %if.end61
	i32.const	$push115=, 0
	i32.const	$push43=, 1
	i32.store	$1=, should_optimize($pop115), $pop43
	i32.const	$push44=, .L.str.2
	i32.store	$0=, 144($18):p2align=4, $pop44
	i32.const	$push114=, .L.str.4
	i32.const	$9=, 144
	i32.add 	$9=, $18, $9
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop114, $9
	block
	i32.const	$push113=, 0
	i32.load	$push45=, should_optimize($pop113)
	i32.const	$push166=, 0
	i32.eq  	$push167=, $pop45, $pop166
	br_if   	0, $pop167      # 0: down to label19
# BB#19:                                # %if.end65
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i32.store	$discard=, should_optimize($pop118), $pop117
	i32.store	$discard=, 128($18):p2align=4, $0
	i32.const	$push116=, .L.str.4
	i32.const	$10=, 128
	i32.add 	$10=, $18, $10
	block
	i32.call	$push46=, __printf_chk@FUNCTION, $1, $pop116, $10
	i32.ne  	$push47=, $pop46, $1
	br_if   	0, $pop47       # 0: down to label20
# BB#20:                                # %if.end69
	block
	i32.const	$push119=, 0
	i32.load	$push48=, should_optimize($pop119)
	i32.const	$push168=, 0
	i32.eq  	$push169=, $pop48, $pop168
	br_if   	0, $pop169      # 0: down to label21
# BB#21:                                # %if.end72
	i32.const	$push122=, 0
	i32.const	$push49=, 1
	i32.store	$discard=, should_optimize($pop122), $pop49
	i32.const	$push50=, .L.str.3
	i32.store	$1=, 112($18):p2align=4, $pop50
	i32.const	$push121=, .L.str.4
	i32.const	$11=, 112
	i32.add 	$11=, $18, $11
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop121, $11
	block
	i32.const	$push120=, 0
	i32.load	$push51=, should_optimize($pop120)
	i32.const	$push170=, 0
	i32.eq  	$push171=, $pop51, $pop170
	br_if   	0, $pop171      # 0: down to label22
# BB#22:                                # %if.end76
	i32.const	$push52=, 0
	i32.const	$push124=, 0
	i32.store	$0=, should_optimize($pop52), $pop124
	i32.store	$discard=, 96($18):p2align=4, $1
	i32.const	$push123=, .L.str.4
	i32.const	$12=, 96
	i32.add 	$12=, $18, $12
	block
	i32.call	$push53=, __printf_chk@FUNCTION, $1, $pop123, $12
	br_if   	0, $pop53       # 0: down to label23
# BB#23:                                # %if.end80
	block
	i32.load	$push54=, should_optimize($0)
	i32.const	$push172=, 0
	i32.eq  	$push173=, $pop54, $pop172
	br_if   	0, $pop173      # 0: down to label24
# BB#24:                                # %if.end83
	i32.const	$push127=, 0
	i32.const	$push55=, 1
	i32.store	$1=, should_optimize($pop127), $pop55
	i32.const	$push56=, 120
	i32.store	$0=, 80($18):p2align=4, $pop56
	i32.const	$push126=, .L.str.5
	i32.const	$13=, 80
	i32.add 	$13=, $18, $13
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop126, $13
	block
	i32.const	$push125=, 0
	i32.load	$push57=, should_optimize($pop125)
	i32.const	$push174=, 0
	i32.eq  	$push175=, $pop57, $pop174
	br_if   	0, $pop175      # 0: down to label25
# BB#25:                                # %if.end87
	i32.const	$push130=, 0
	i32.const	$push129=, 0
	i32.store	$discard=, should_optimize($pop130), $pop129
	i32.store	$discard=, 64($18):p2align=4, $0
	i32.const	$push128=, .L.str.5
	i32.const	$14=, 64
	i32.add 	$14=, $18, $14
	block
	i32.call	$push58=, __printf_chk@FUNCTION, $1, $pop128, $14
	i32.ne  	$push59=, $pop58, $1
	br_if   	0, $pop59       # 0: down to label26
# BB#26:                                # %if.end91
	block
	i32.const	$push131=, 0
	i32.load	$push60=, should_optimize($pop131)
	i32.const	$push176=, 0
	i32.eq  	$push177=, $pop60, $pop176
	br_if   	0, $pop177      # 0: down to label27
# BB#27:                                # %if.end94
	i32.const	$push134=, 0
	i32.const	$push61=, 1
	i32.store	$discard=, should_optimize($pop134), $pop61
	i32.const	$push62=, .L.str.1
	i32.store	$1=, 48($18):p2align=4, $pop62
	i32.const	$push133=, .L.str.6
	i32.const	$15=, 48
	i32.add 	$15=, $18, $15
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop133, $15
	block
	i32.const	$push132=, 0
	i32.load	$push63=, should_optimize($pop132)
	i32.const	$push178=, 0
	i32.eq  	$push179=, $pop63, $pop178
	br_if   	0, $pop179      # 0: down to label28
# BB#28:                                # %if.end98
	i32.const	$push64=, 0
	i32.const	$push136=, 0
	i32.store	$0=, should_optimize($pop64), $pop136
	i32.store	$discard=, 32($18):p2align=4, $1
	i32.const	$push135=, .L.str.6
	i32.const	$16=, 32
	i32.add 	$16=, $18, $16
	block
	i32.call	$push65=, __printf_chk@FUNCTION, $1, $pop135, $16
	i32.const	$push66=, 7
	i32.ne  	$push67=, $pop65, $pop66
	br_if   	0, $pop67       # 0: down to label29
# BB#29:                                # %if.end102
	block
	i32.load	$push68=, should_optimize($0)
	i32.const	$push180=, 0
	i32.eq  	$push181=, $pop68, $pop180
	br_if   	0, $pop181      # 0: down to label30
# BB#30:                                # %if.end105
	i32.const	$push69=, 0
	i32.const	$push138=, 0
	i32.store	$push70=, should_optimize($pop69), $pop138
	i32.store	$1=, 16($18):p2align=4, $pop70
	i32.const	$push137=, .L.str.7
	i32.const	$17=, 16
	i32.add 	$17=, $18, $17
	i32.call	$discard=, __printf_chk@FUNCTION, $1, $pop137, $17
	block
	i32.load	$push71=, should_optimize($1)
	i32.const	$push182=, 0
	i32.eq  	$push183=, $pop71, $pop182
	br_if   	0, $pop183      # 0: down to label31
# BB#31:                                # %if.end109
	i32.store	$push72=, should_optimize($1), $1
	i32.store	$discard=, 0($18):p2align=4, $pop72
	block
	i32.const	$push139=, .L.str.7
	i32.call	$push73=, __printf_chk@FUNCTION, $1, $pop139, $18
	i32.const	$push74=, 2
	i32.ne  	$push75=, $pop73, $pop74
	br_if   	0, $pop75       # 0: down to label32
# BB#32:                                # %if.end113
	block
	i32.const	$push140=, 0
	i32.load	$push76=, should_optimize($pop140)
	i32.const	$push184=, 0
	i32.eq  	$push185=, $pop76, $pop184
	br_if   	0, $pop185      # 0: down to label33
# BB#33:                                # %if.end116
	i32.const	$push141=, 0
	i32.const	$4=, 224
	i32.add 	$18=, $18, $4
	i32.const	$4=, __stack_pointer
	i32.store	$18=, 0($4), $18
	return  	$pop141
.LBB1_34:                               # %if.then115
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_35:                               # %if.then112
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then108
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then104
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %if.then101
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_39:                               # %if.then97
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_40:                               # %if.then93
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_41:                               # %if.then90
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %if.then86
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_43:                               # %if.then82
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_44:                               # %if.then79
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_45:                               # %if.then75
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_46:                               # %if.then71
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_47:                               # %if.then68
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then64
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then60
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %if.then57
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_51:                               # %if.then53
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_52:                               # %if.then49
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_53:                               # %if.then46
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then42
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then38
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %if.then35
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_57:                               # %if.then31
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_58:                               # %if.then27
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_59:                               # %if.then24
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then20
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then16
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %if.then13
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_63:                               # %if.then9
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_64:                               # %if.then5
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_65:                               # %if.then2
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_66:                               # %if.then
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
