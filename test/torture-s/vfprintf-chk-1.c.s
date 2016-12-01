	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c"
	.section	.text.__vfprintf_chk,"ax",@progbits
	.hidden	__vfprintf_chk
	.globl	__vfprintf_chk
	.type	__vfprintf_chk,@function
__vfprintf_chk:                         # @__vfprintf_chk
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, should_optimize($pop3)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store	should_optimize($pop4), $pop1
	i32.call	$push2=, vfprintf@FUNCTION, $0, $2, $3
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__vfprintf_chk, .Lfunc_end0-__vfprintf_chk

	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push91=, 0
	i32.const	$push88=, 0
	i32.load	$push89=, __stack_pointer($pop88)
	i32.const	$push90=, 16
	i32.sub 	$push96=, $pop89, $pop90
	tee_local	$push95=, $2=, $pop96
	i32.store	__stack_pointer($pop91), $pop95
	i32.store	12($2), $1
	i32.store	8($2), $1
	block   	
	i32.const	$push0=, 10
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0 # 0: down to label13
                                        # 1: down to label12
                                        # 2: down to label11
                                        # 3: down to label10
                                        # 4: down to label9
                                        # 5: down to label8
                                        # 6: down to label7
                                        # 7: down to label6
                                        # 8: down to label5
                                        # 9: down to label4
                                        # 10: down to label3
.LBB1_2:                                # %sw.bb
	end_block                       # label13:
	i32.const	$push102=, 0
	i32.const	$push79=, 1
	i32.store	should_optimize($pop102), $pop79
	i32.const	$push101=, 0
	i32.load	$push100=, stdout($pop101)
	tee_local	$push99=, $1=, $pop100
	i32.const	$push98=, .L.str
	i32.load	$push80=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop99, $2, $pop98, $pop80
	i32.const	$push97=, 0
	i32.load	$push81=, should_optimize($pop97)
	i32.eqz 	$push205=, $pop81
	br_if   	11, $pop205     # 11: down to label1
# BB#3:                                 # %if.end
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.store	should_optimize($pop105), $pop104
	i32.const	$push103=, .L.str
	i32.load	$push82=, 8($2)
	i32.call	$push83=, __vfprintf_chk@FUNCTION, $1, $2, $pop103, $pop82
	i32.const	$push84=, 5
	i32.ne  	$push85=, $pop83, $pop84
	br_if   	11, $pop85      # 11: down to label1
# BB#4:                                 # %if.end5
	i32.const	$push86=, 0
	i32.load	$push87=, should_optimize($pop86)
	br_if   	10, $pop87      # 10: down to label2
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %sw.bb9
	end_block                       # label12:
	i32.const	$push111=, 0
	i32.const	$push70=, 1
	i32.store	should_optimize($pop111), $pop70
	i32.const	$push110=, 0
	i32.load	$push109=, stdout($pop110)
	tee_local	$push108=, $1=, $pop109
	i32.const	$push107=, .L.str.1
	i32.load	$push71=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop108, $2, $pop107, $pop71
	i32.const	$push106=, 0
	i32.load	$push72=, should_optimize($pop106)
	i32.eqz 	$push206=, $pop72
	br_if   	10, $pop206     # 10: down to label1
# BB#7:                                 # %if.end13
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.store	should_optimize($pop114), $pop113
	i32.const	$push112=, .L.str.1
	i32.load	$push73=, 8($2)
	i32.call	$push74=, __vfprintf_chk@FUNCTION, $1, $2, $pop112, $pop73
	i32.const	$push75=, 6
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	10, $pop76      # 10: down to label1
# BB#8:                                 # %if.end17
	i32.const	$push77=, 0
	i32.load	$push78=, should_optimize($pop77)
	br_if   	9, $pop78       # 9: down to label2
# BB#9:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %sw.bb21
	end_block                       # label11:
	i32.const	$push121=, 0
	i32.const	$push120=, 1
	i32.store	should_optimize($pop121), $pop120
	i32.const	$push119=, 0
	i32.load	$push118=, stdout($pop119)
	tee_local	$push117=, $1=, $pop118
	i32.const	$push116=, .L.str.2
	i32.load	$push63=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop117, $2, $pop116, $pop63
	i32.const	$push115=, 0
	i32.load	$push64=, should_optimize($pop115)
	i32.eqz 	$push207=, $pop64
	br_if   	9, $pop207      # 9: down to label1
# BB#11:                                # %if.end25
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.store	should_optimize($pop125), $pop124
	i32.const	$push123=, .L.str.2
	i32.load	$push65=, 8($2)
	i32.call	$push66=, __vfprintf_chk@FUNCTION, $1, $2, $pop123, $pop65
	i32.const	$push122=, 1
	i32.ne  	$push67=, $pop66, $pop122
	br_if   	9, $pop67       # 9: down to label1
# BB#12:                                # %if.end29
	i32.const	$push68=, 0
	i32.load	$push69=, should_optimize($pop68)
	br_if   	8, $pop69       # 8: down to label2
# BB#13:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %sw.bb33
	end_block                       # label10:
	i32.const	$push131=, 0
	i32.const	$push56=, 1
	i32.store	should_optimize($pop131), $pop56
	i32.const	$push130=, 0
	i32.load	$push129=, stdout($pop130)
	tee_local	$push128=, $1=, $pop129
	i32.const	$push127=, .L.str.3
	i32.load	$push57=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop128, $2, $pop127, $pop57
	i32.const	$push126=, 0
	i32.load	$push58=, should_optimize($pop126)
	i32.eqz 	$push208=, $pop58
	br_if   	8, $pop208      # 8: down to label1
# BB#15:                                # %if.end37
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i32.store	should_optimize($pop134), $pop133
	i32.const	$push132=, .L.str.3
	i32.load	$push59=, 8($2)
	i32.call	$push60=, __vfprintf_chk@FUNCTION, $1, $2, $pop132, $pop59
	br_if   	8, $pop60       # 8: down to label1
# BB#16:                                # %if.end41
	i32.const	$push61=, 0
	i32.load	$push62=, should_optimize($pop61)
	br_if   	7, $pop62       # 7: down to label2
# BB#17:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %sw.bb45
	end_block                       # label9:
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.store	should_optimize($pop141), $pop140
	i32.const	$push139=, 0
	i32.load	$push138=, stdout($pop139)
	tee_local	$push137=, $1=, $pop138
	i32.const	$push136=, .L.str.4
	i32.load	$push48=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop137, $2, $pop136, $pop48
	i32.const	$push135=, 0
	i32.load	$push49=, should_optimize($pop135)
	i32.eqz 	$push209=, $pop49
	br_if   	7, $pop209      # 7: down to label1
# BB#19:                                # %if.end49
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.store	should_optimize($pop144), $pop143
	i32.const	$push142=, .L.str.4
	i32.load	$push50=, 8($2)
	i32.call	$push51=, __vfprintf_chk@FUNCTION, $1, $2, $pop142, $pop50
	i32.const	$push52=, 5
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	7, $pop53       # 7: down to label1
# BB#20:                                # %if.end53
	i32.const	$push54=, 0
	i32.load	$push55=, should_optimize($pop54)
	br_if   	6, $pop55       # 6: down to label2
# BB#21:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %sw.bb57
	end_block                       # label8:
	i32.const	$push151=, 0
	i32.const	$push150=, 0
	i32.store	should_optimize($pop151), $pop150
	i32.const	$push149=, 0
	i32.load	$push148=, stdout($pop149)
	tee_local	$push147=, $1=, $pop148
	i32.const	$push146=, .L.str.4
	i32.load	$push40=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop147, $2, $pop146, $pop40
	i32.const	$push145=, 0
	i32.load	$push41=, should_optimize($pop145)
	i32.eqz 	$push210=, $pop41
	br_if   	6, $pop210      # 6: down to label1
# BB#23:                                # %if.end61
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.store	should_optimize($pop154), $pop153
	i32.const	$push152=, .L.str.4
	i32.load	$push42=, 8($2)
	i32.call	$push43=, __vfprintf_chk@FUNCTION, $1, $2, $pop152, $pop42
	i32.const	$push44=, 6
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	6, $pop45       # 6: down to label1
# BB#24:                                # %if.end65
	i32.const	$push46=, 0
	i32.load	$push47=, should_optimize($pop46)
	br_if   	5, $pop47       # 5: down to label2
# BB#25:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %sw.bb69
	end_block                       # label7:
	i32.const	$push161=, 0
	i32.const	$push160=, 0
	i32.store	should_optimize($pop161), $pop160
	i32.const	$push159=, 0
	i32.load	$push158=, stdout($pop159)
	tee_local	$push157=, $1=, $pop158
	i32.const	$push156=, .L.str.4
	i32.load	$push32=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop157, $2, $pop156, $pop32
	i32.const	$push155=, 0
	i32.load	$push33=, should_optimize($pop155)
	i32.eqz 	$push211=, $pop33
	br_if   	5, $pop211      # 5: down to label1
# BB#27:                                # %if.end73
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.store	should_optimize($pop164), $pop163
	i32.const	$push162=, .L.str.4
	i32.load	$push34=, 8($2)
	i32.call	$push35=, __vfprintf_chk@FUNCTION, $1, $2, $pop162, $pop34
	i32.const	$push36=, 1
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	5, $pop37       # 5: down to label1
# BB#28:                                # %if.end77
	i32.const	$push38=, 0
	i32.load	$push39=, should_optimize($pop38)
	br_if   	4, $pop39       # 4: down to label2
# BB#29:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %sw.bb81
	end_block                       # label6:
	i32.const	$push171=, 0
	i32.const	$push170=, 0
	i32.store	should_optimize($pop171), $pop170
	i32.const	$push169=, 0
	i32.load	$push168=, stdout($pop169)
	tee_local	$push167=, $1=, $pop168
	i32.const	$push166=, .L.str.4
	i32.load	$push26=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop167, $2, $pop166, $pop26
	i32.const	$push165=, 0
	i32.load	$push27=, should_optimize($pop165)
	i32.eqz 	$push212=, $pop27
	br_if   	4, $pop212      # 4: down to label1
# BB#31:                                # %if.end85
	i32.const	$push174=, 0
	i32.const	$push173=, 0
	i32.store	should_optimize($pop174), $pop173
	i32.const	$push172=, .L.str.4
	i32.load	$push28=, 8($2)
	i32.call	$push29=, __vfprintf_chk@FUNCTION, $1, $2, $pop172, $pop28
	br_if   	4, $pop29       # 4: down to label1
# BB#32:                                # %if.end89
	i32.const	$push30=, 0
	i32.load	$push31=, should_optimize($pop30)
	br_if   	3, $pop31       # 3: down to label2
# BB#33:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %sw.bb93
	end_block                       # label5:
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.store	should_optimize($pop181), $pop180
	i32.const	$push179=, 0
	i32.load	$push178=, stdout($pop179)
	tee_local	$push177=, $1=, $pop178
	i32.const	$push176=, .L.str.5
	i32.load	$push18=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop177, $2, $pop176, $pop18
	i32.const	$push175=, 0
	i32.load	$push19=, should_optimize($pop175)
	i32.eqz 	$push213=, $pop19
	br_if   	3, $pop213      # 3: down to label1
# BB#35:                                # %if.end97
	i32.const	$push184=, 0
	i32.const	$push183=, 0
	i32.store	should_optimize($pop184), $pop183
	i32.const	$push182=, .L.str.5
	i32.load	$push20=, 8($2)
	i32.call	$push21=, __vfprintf_chk@FUNCTION, $1, $2, $pop182, $pop20
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	3, $pop23       # 3: down to label1
# BB#36:                                # %if.end101
	i32.const	$push24=, 0
	i32.load	$push25=, should_optimize($pop24)
	br_if   	2, $pop25       # 2: down to label2
# BB#37:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %sw.bb105
	end_block                       # label4:
	i32.const	$push191=, 0
	i32.const	$push190=, 0
	i32.store	should_optimize($pop191), $pop190
	i32.const	$push189=, 0
	i32.load	$push188=, stdout($pop189)
	tee_local	$push187=, $1=, $pop188
	i32.const	$push186=, .L.str.6
	i32.load	$push10=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop187, $2, $pop186, $pop10
	i32.const	$push185=, 0
	i32.load	$push11=, should_optimize($pop185)
	i32.eqz 	$push214=, $pop11
	br_if   	2, $pop214      # 2: down to label1
# BB#39:                                # %if.end109
	i32.const	$push194=, 0
	i32.const	$push193=, 0
	i32.store	should_optimize($pop194), $pop193
	i32.const	$push192=, .L.str.6
	i32.load	$push12=, 8($2)
	i32.call	$push13=, __vfprintf_chk@FUNCTION, $1, $2, $pop192, $pop12
	i32.const	$push14=, 7
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	2, $pop15       # 2: down to label1
# BB#40:                                # %if.end113
	i32.const	$push16=, 0
	i32.load	$push17=, should_optimize($pop16)
	br_if   	1, $pop17       # 1: down to label2
# BB#41:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %sw.bb117
	end_block                       # label3:
	i32.const	$push201=, 0
	i32.const	$push200=, 0
	i32.store	should_optimize($pop201), $pop200
	i32.const	$push199=, 0
	i32.load	$push198=, stdout($pop199)
	tee_local	$push197=, $1=, $pop198
	i32.const	$push196=, .L.str.7
	i32.load	$push2=, 12($2)
	i32.call	$drop=, __vfprintf_chk@FUNCTION, $pop197, $2, $pop196, $pop2
	i32.const	$push195=, 0
	i32.load	$push3=, should_optimize($pop195)
	i32.eqz 	$push215=, $pop3
	br_if   	1, $pop215      # 1: down to label1
# BB#43:                                # %if.end121
	i32.const	$push204=, 0
	i32.const	$push203=, 0
	i32.store	should_optimize($pop204), $pop203
	i32.const	$push202=, .L.str.7
	i32.load	$push4=, 8($2)
	i32.call	$push5=, __vfprintf_chk@FUNCTION, $1, $2, $pop202, $pop4
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label1
# BB#44:                                # %if.end125
	i32.const	$push8=, 0
	i32.load	$push9=, should_optimize($pop8)
	i32.eqz 	$push216=, $pop9
	br_if   	1, $pop216      # 1: down to label1
.LBB1_45:                               # %sw.epilog
	end_block                       # label2:
	i32.const	$push94=, 0
	i32.const	$push92=, 16
	i32.add 	$push93=, $2, $pop92
	i32.store	__stack_pointer($pop94), $pop93
	return
.LBB1_46:                               # %sw.default
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	inner, .Lfunc_end1-inner

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push19=, 0
	i32.const	$push16=, 0
	i32.load	$push17=, __stack_pointer($pop16)
	i32.const	$push18=, 112
	i32.sub 	$push43=, $pop17, $pop18
	tee_local	$push42=, $0=, $pop43
	i32.store	__stack_pointer($pop19), $pop42
	i32.const	$push0=, 0
	i32.const	$push41=, 0
	call    	inner@FUNCTION, $pop0, $pop41
	i32.const	$push1=, 1
	i32.const	$push40=, 0
	call    	inner@FUNCTION, $pop1, $pop40
	i32.const	$push2=, 2
	i32.const	$push39=, 0
	call    	inner@FUNCTION, $pop2, $pop39
	i32.const	$push3=, 3
	i32.const	$push38=, 0
	call    	inner@FUNCTION, $pop3, $pop38
	i32.const	$push4=, .L.str
	i32.store	96($0), $pop4
	i32.const	$push5=, 4
	i32.const	$push23=, 96
	i32.add 	$push24=, $0, $pop23
	call    	inner@FUNCTION, $pop5, $pop24
	i32.const	$push6=, .L.str.1
	i32.store	80($0), $pop6
	i32.const	$push7=, 5
	i32.const	$push25=, 80
	i32.add 	$push26=, $0, $pop25
	call    	inner@FUNCTION, $pop7, $pop26
	i32.const	$push8=, .L.str.2
	i32.store	64($0), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $0, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	48($0), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $0, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	32($0), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $0, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.const	$push37=, .L.str.1
	i32.store	16($0), $pop37
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $0, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	0($0), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $0
	i32.const	$push22=, 0
	i32.const	$push20=, 112
	i32.add 	$push21=, $0, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push35=, 0
                                        # fallthrough-return: $pop35
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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
