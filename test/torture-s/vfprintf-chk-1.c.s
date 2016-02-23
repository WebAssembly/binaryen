	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vfprintf-chk-1.c"
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
	i32.store	$discard=, should_optimize($pop4), $pop1
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
	i32.const	$push193=, __stack_pointer
	i32.load	$push194=, 0($pop193)
	i32.const	$push195=, 16
	i32.sub 	$2=, $pop194, $pop195
	i32.const	$push196=, __stack_pointer
	i32.store	$discard=, 0($pop196), $2
	i32.store	$push0=, 12($2), $1
	i32.store	$discard=, 8($2), $pop0
	block
	i32.const	$push1=, 10
	i32.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label1
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
	tableswitch	$0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # 0: down to label13
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
	i32.const	$push133=, 0
	i32.const	$push118=, 1
	i32.store	$discard=, should_optimize($pop133), $pop118
	i32.const	$push132=, 0
	i32.load	$push119=, stdout($pop132)
	i32.const	$push131=, .L.str
	i32.load	$push120=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop119, $0, $pop131, $pop120
	i32.const	$push130=, 0
	i32.load	$push121=, should_optimize($pop130)
	i32.const	$push199=, 0
	i32.eq  	$push200=, $pop121, $pop199
	br_if   	11, $pop200     # 11: down to label1
# BB#3:                                 # %if.end
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.store	$push122=, should_optimize($pop136), $pop135
	i32.load	$push123=, stdout($pop122)
	i32.const	$push134=, .L.str
	i32.load	$push124=, 8($2)
	i32.call	$push125=, __vfprintf_chk@FUNCTION, $pop123, $0, $pop134, $pop124
	i32.const	$push126=, 5
	i32.ne  	$push127=, $pop125, $pop126
	br_if   	11, $pop127     # 11: down to label1
# BB#4:                                 # %if.end5
	i32.const	$push128=, 0
	i32.load	$push129=, should_optimize($pop128)
	br_if   	10, $pop129     # 10: down to label2
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %sw.bb9
	end_block                       # label12:
	i32.const	$push140=, 0
	i32.const	$push106=, 1
	i32.store	$discard=, should_optimize($pop140), $pop106
	i32.const	$push139=, 0
	i32.load	$push107=, stdout($pop139)
	i32.const	$push138=, .L.str.1
	i32.load	$push108=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop107, $0, $pop138, $pop108
	i32.const	$push137=, 0
	i32.load	$push109=, should_optimize($pop137)
	i32.const	$push201=, 0
	i32.eq  	$push202=, $pop109, $pop201
	br_if   	10, $pop202     # 10: down to label1
# BB#7:                                 # %if.end13
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.store	$push110=, should_optimize($pop143), $pop142
	i32.load	$push111=, stdout($pop110)
	i32.const	$push141=, .L.str.1
	i32.load	$push112=, 8($2)
	i32.call	$push113=, __vfprintf_chk@FUNCTION, $pop111, $0, $pop141, $pop112
	i32.const	$push114=, 6
	i32.ne  	$push115=, $pop113, $pop114
	br_if   	10, $pop115     # 10: down to label1
# BB#8:                                 # %if.end17
	i32.const	$push116=, 0
	i32.load	$push117=, should_optimize($pop116)
	br_if   	9, $pop117      # 9: down to label2
# BB#9:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %sw.bb21
	end_block                       # label11:
	i32.const	$push147=, 0
	i32.const	$push95=, 1
	i32.store	$0=, should_optimize($pop147), $pop95
	i32.const	$push146=, 0
	i32.load	$push96=, stdout($pop146)
	i32.const	$push145=, .L.str.2
	i32.load	$push97=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop96, $0, $pop145, $pop97
	i32.const	$push144=, 0
	i32.load	$push98=, should_optimize($pop144)
	i32.const	$push203=, 0
	i32.eq  	$push204=, $pop98, $pop203
	br_if   	9, $pop204      # 9: down to label1
# BB#11:                                # %if.end25
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.store	$push99=, should_optimize($pop150), $pop149
	i32.load	$push100=, stdout($pop99)
	i32.const	$push148=, .L.str.2
	i32.load	$push101=, 8($2)
	i32.call	$push102=, __vfprintf_chk@FUNCTION, $pop100, $0, $pop148, $pop101
	i32.ne  	$push103=, $pop102, $0
	br_if   	9, $pop103      # 9: down to label1
# BB#12:                                # %if.end29
	i32.const	$push104=, 0
	i32.load	$push105=, should_optimize($pop104)
	br_if   	8, $pop105      # 8: down to label2
# BB#13:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %sw.bb33
	end_block                       # label10:
	i32.const	$push154=, 0
	i32.const	$push85=, 1
	i32.store	$discard=, should_optimize($pop154), $pop85
	i32.const	$push153=, 0
	i32.load	$push86=, stdout($pop153)
	i32.const	$push152=, .L.str.3
	i32.load	$push87=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop86, $0, $pop152, $pop87
	i32.const	$push151=, 0
	i32.load	$push88=, should_optimize($pop151)
	i32.const	$push205=, 0
	i32.eq  	$push206=, $pop88, $pop205
	br_if   	8, $pop206      # 8: down to label1
# BB#15:                                # %if.end37
	i32.const	$push157=, 0
	i32.const	$push156=, 0
	i32.store	$push89=, should_optimize($pop157), $pop156
	i32.load	$push90=, stdout($pop89)
	i32.const	$push155=, .L.str.3
	i32.load	$push91=, 8($2)
	i32.call	$push92=, __vfprintf_chk@FUNCTION, $pop90, $0, $pop155, $pop91
	br_if   	8, $pop92       # 8: down to label1
# BB#16:                                # %if.end41
	i32.const	$push93=, 0
	i32.load	$push94=, should_optimize($pop93)
	br_if   	7, $pop94       # 7: down to label2
# BB#17:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %sw.bb45
	end_block                       # label9:
	i32.const	$push73=, 0
	i32.const	$push161=, 0
	i32.store	$push160=, should_optimize($pop73), $pop161
	tee_local	$push159=, $0=, $pop160
	i32.load	$push74=, stdout($pop159)
	i32.const	$push158=, .L.str.4
	i32.load	$push75=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop74, $0, $pop158, $pop75
	i32.load	$push76=, should_optimize($0)
	i32.const	$push207=, 0
	i32.eq  	$push208=, $pop76, $pop207
	br_if   	7, $pop208      # 7: down to label1
# BB#19:                                # %if.end49
	i32.store	$push77=, should_optimize($0), $0
	i32.load	$push78=, stdout($pop77)
	i32.const	$push162=, .L.str.4
	i32.load	$push79=, 8($2)
	i32.call	$push80=, __vfprintf_chk@FUNCTION, $pop78, $0, $pop162, $pop79
	i32.const	$push81=, 5
	i32.ne  	$push82=, $pop80, $pop81
	br_if   	7, $pop82       # 7: down to label1
# BB#20:                                # %if.end53
	i32.const	$push83=, 0
	i32.load	$push84=, should_optimize($pop83)
	br_if   	6, $pop84       # 6: down to label2
# BB#21:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %sw.bb57
	end_block                       # label8:
	i32.const	$push61=, 0
	i32.const	$push166=, 0
	i32.store	$push165=, should_optimize($pop61), $pop166
	tee_local	$push164=, $0=, $pop165
	i32.load	$push62=, stdout($pop164)
	i32.const	$push163=, .L.str.4
	i32.load	$push63=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop62, $0, $pop163, $pop63
	i32.load	$push64=, should_optimize($0)
	i32.const	$push209=, 0
	i32.eq  	$push210=, $pop64, $pop209
	br_if   	6, $pop210      # 6: down to label1
# BB#23:                                # %if.end61
	i32.store	$push65=, should_optimize($0), $0
	i32.load	$push66=, stdout($pop65)
	i32.const	$push167=, .L.str.4
	i32.load	$push67=, 8($2)
	i32.call	$push68=, __vfprintf_chk@FUNCTION, $pop66, $0, $pop167, $pop67
	i32.const	$push69=, 6
	i32.ne  	$push70=, $pop68, $pop69
	br_if   	6, $pop70       # 6: down to label1
# BB#24:                                # %if.end65
	i32.const	$push71=, 0
	i32.load	$push72=, should_optimize($pop71)
	br_if   	5, $pop72       # 5: down to label2
# BB#25:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %sw.bb69
	end_block                       # label7:
	i32.const	$push49=, 0
	i32.const	$push171=, 0
	i32.store	$push170=, should_optimize($pop49), $pop171
	tee_local	$push169=, $0=, $pop170
	i32.load	$push50=, stdout($pop169)
	i32.const	$push168=, .L.str.4
	i32.load	$push51=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop50, $0, $pop168, $pop51
	i32.load	$push52=, should_optimize($0)
	i32.const	$push211=, 0
	i32.eq  	$push212=, $pop52, $pop211
	br_if   	5, $pop212      # 5: down to label1
# BB#27:                                # %if.end73
	i32.store	$push53=, should_optimize($0), $0
	i32.load	$push54=, stdout($pop53)
	i32.const	$push172=, .L.str.4
	i32.load	$push55=, 8($2)
	i32.call	$push56=, __vfprintf_chk@FUNCTION, $pop54, $0, $pop172, $pop55
	i32.const	$push57=, 1
	i32.ne  	$push58=, $pop56, $pop57
	br_if   	5, $pop58       # 5: down to label1
# BB#28:                                # %if.end77
	i32.const	$push59=, 0
	i32.load	$push60=, should_optimize($pop59)
	br_if   	4, $pop60       # 4: down to label2
# BB#29:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %sw.bb81
	end_block                       # label6:
	i32.const	$push39=, 0
	i32.const	$push176=, 0
	i32.store	$push175=, should_optimize($pop39), $pop176
	tee_local	$push174=, $0=, $pop175
	i32.load	$push40=, stdout($pop174)
	i32.const	$push173=, .L.str.4
	i32.load	$push41=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop40, $0, $pop173, $pop41
	i32.load	$push42=, should_optimize($0)
	i32.const	$push213=, 0
	i32.eq  	$push214=, $pop42, $pop213
	br_if   	4, $pop214      # 4: down to label1
# BB#31:                                # %if.end85
	i32.store	$push43=, should_optimize($0), $0
	i32.load	$push44=, stdout($pop43)
	i32.const	$push177=, .L.str.4
	i32.load	$push45=, 8($2)
	i32.call	$push46=, __vfprintf_chk@FUNCTION, $pop44, $0, $pop177, $pop45
	br_if   	4, $pop46       # 4: down to label1
# BB#32:                                # %if.end89
	i32.const	$push47=, 0
	i32.load	$push48=, should_optimize($pop47)
	br_if   	3, $pop48       # 3: down to label2
# BB#33:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %sw.bb93
	end_block                       # label5:
	i32.const	$push27=, 0
	i32.const	$push181=, 0
	i32.store	$push180=, should_optimize($pop27), $pop181
	tee_local	$push179=, $0=, $pop180
	i32.load	$push28=, stdout($pop179)
	i32.const	$push178=, .L.str.5
	i32.load	$push29=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop28, $0, $pop178, $pop29
	i32.load	$push30=, should_optimize($0)
	i32.const	$push215=, 0
	i32.eq  	$push216=, $pop30, $pop215
	br_if   	3, $pop216      # 3: down to label1
# BB#35:                                # %if.end97
	i32.store	$push31=, should_optimize($0), $0
	i32.load	$push32=, stdout($pop31)
	i32.const	$push182=, .L.str.5
	i32.load	$push33=, 8($2)
	i32.call	$push34=, __vfprintf_chk@FUNCTION, $pop32, $0, $pop182, $pop33
	i32.const	$push35=, 1
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	3, $pop36       # 3: down to label1
# BB#36:                                # %if.end101
	i32.const	$push37=, 0
	i32.load	$push38=, should_optimize($pop37)
	br_if   	2, $pop38       # 2: down to label2
# BB#37:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %sw.bb105
	end_block                       # label4:
	i32.const	$push15=, 0
	i32.const	$push186=, 0
	i32.store	$push185=, should_optimize($pop15), $pop186
	tee_local	$push184=, $0=, $pop185
	i32.load	$push16=, stdout($pop184)
	i32.const	$push183=, .L.str.6
	i32.load	$push17=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop16, $0, $pop183, $pop17
	i32.load	$push18=, should_optimize($0)
	i32.const	$push217=, 0
	i32.eq  	$push218=, $pop18, $pop217
	br_if   	2, $pop218      # 2: down to label1
# BB#39:                                # %if.end109
	i32.store	$push19=, should_optimize($0), $0
	i32.load	$push20=, stdout($pop19)
	i32.const	$push187=, .L.str.6
	i32.load	$push21=, 8($2)
	i32.call	$push22=, __vfprintf_chk@FUNCTION, $pop20, $0, $pop187, $pop21
	i32.const	$push23=, 7
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	2, $pop24       # 2: down to label1
# BB#40:                                # %if.end113
	i32.const	$push25=, 0
	i32.load	$push26=, should_optimize($pop25)
	br_if   	1, $pop26       # 1: down to label2
# BB#41:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %sw.bb117
	end_block                       # label3:
	i32.const	$push3=, 0
	i32.const	$push191=, 0
	i32.store	$push190=, should_optimize($pop3), $pop191
	tee_local	$push189=, $0=, $pop190
	i32.load	$push4=, stdout($pop189)
	i32.const	$push188=, .L.str.7
	i32.load	$push5=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop4, $0, $pop188, $pop5
	i32.load	$push6=, should_optimize($0)
	i32.const	$push219=, 0
	i32.eq  	$push220=, $pop6, $pop219
	br_if   	1, $pop220      # 1: down to label1
# BB#43:                                # %if.end121
	i32.store	$push7=, should_optimize($0), $0
	i32.load	$push8=, stdout($pop7)
	i32.const	$push192=, .L.str.7
	i32.load	$push9=, 8($2)
	i32.call	$push10=, __vfprintf_chk@FUNCTION, $pop8, $0, $pop192, $pop9
	i32.const	$push11=, 2
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	1, $pop12       # 1: down to label1
# BB#44:                                # %if.end125
	i32.const	$push13=, 0
	i32.load	$push14=, should_optimize($pop13)
	i32.const	$push221=, 0
	i32.eq  	$push222=, $pop14, $pop221
	br_if   	1, $pop222      # 1: down to label1
.LBB1_45:                               # %sw.epilog
	end_block                       # label2:
	i32.const	$push197=, 16
	i32.add 	$2=, $2, $pop197
	i32.const	$push198=, __stack_pointer
	i32.store	$discard=, 0($pop198), $2
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, __stack_pointer
	i32.load	$push22=, 0($pop21)
	i32.const	$push23=, 112
	i32.sub 	$7=, $pop22, $pop23
	i32.const	$push24=, __stack_pointer
	i32.store	$discard=, 0($pop24), $7
	i32.const	$push0=, 0
	i32.const	$push20=, 0
	call    	inner@FUNCTION, $pop0, $pop20
	i32.const	$push1=, 1
	i32.const	$push19=, 0
	call    	inner@FUNCTION, $pop1, $pop19
	i32.const	$push2=, 2
	i32.const	$push18=, 0
	call    	inner@FUNCTION, $pop2, $pop18
	i32.const	$push3=, 3
	i32.const	$push17=, 0
	call    	inner@FUNCTION, $pop3, $pop17
	i32.const	$push4=, .L.str
	i32.store	$discard=, 96($7):p2align=4, $pop4
	i32.const	$push5=, 4
	i32.const	$1=, 96
	i32.add 	$1=, $7, $1
	call    	inner@FUNCTION, $pop5, $1
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 80($7):p2align=4, $pop6
	i32.const	$push7=, 5
	i32.const	$2=, 80
	i32.add 	$2=, $7, $2
	call    	inner@FUNCTION, $pop7, $2
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 64($7):p2align=4, $pop8
	i32.const	$push9=, 6
	i32.const	$3=, 64
	i32.add 	$3=, $7, $3
	call    	inner@FUNCTION, $pop9, $3
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 48($7):p2align=4, $pop10
	i32.const	$push11=, 7
	i32.const	$4=, 48
	i32.add 	$4=, $7, $4
	call    	inner@FUNCTION, $pop11, $4
	i32.const	$push12=, 120
	i32.store	$discard=, 32($7):p2align=4, $pop12
	i32.const	$push13=, 8
	i32.const	$5=, 32
	i32.add 	$5=, $7, $5
	call    	inner@FUNCTION, $pop13, $5
	i32.store	$discard=, 16($7):p2align=4, $0
	i32.const	$push14=, 9
	i32.const	$6=, 16
	i32.add 	$6=, $7, $6
	call    	inner@FUNCTION, $pop14, $6
	i32.const	$push16=, 0
	i32.store	$0=, 0($7):p2align=4, $pop16
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $7
	i32.const	$push25=, 112
	i32.add 	$7=, $7, $pop25
	i32.const	$push26=, __stack_pointer
	i32.store	$discard=, 0($pop26), $7
	return  	$0
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


	.ident	"clang version 3.9.0 "
