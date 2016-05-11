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
	i32.const	$push133=, __stack_pointer
	i32.const	$push130=, __stack_pointer
	i32.load	$push131=, 0($pop130)
	i32.const	$push132=, 16
	i32.sub 	$push137=, $pop131, $pop132
	i32.store	$2=, 0($pop133), $pop137
	i32.store	$push0=, 12($2), $1
	i32.store	$discard=, 8($2), $pop0
	block
	i32.const	$push12=, 10
	i32.gt_u	$push13=, $0, $pop12
	br_if   	0, $pop13       # 0: down to label1
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
	i32.const	$push141=, 0
	i32.const	$push119=, 1
	i32.store	$discard=, should_optimize($pop141), $pop119
	i32.const	$push140=, 0
	i32.load	$push120=, stdout($pop140)
	i32.const	$push139=, .L.str
	i32.load	$push121=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop120, $2, $pop139, $pop121
	i32.const	$push138=, 0
	i32.load	$push122=, should_optimize($pop138)
	i32.const	$push201=, 0
	i32.eq  	$push202=, $pop122, $pop201
	br_if   	11, $pop202     # 11: down to label1
# BB#3:                                 # %if.end
	i32.const	$push144=, 0
	i32.const	$push143=, 0
	i32.store	$push11=, should_optimize($pop144), $pop143
	i32.load	$push123=, stdout($pop11)
	i32.const	$push142=, .L.str
	i32.load	$push124=, 8($2)
	i32.call	$push125=, __vfprintf_chk@FUNCTION, $pop123, $2, $pop142, $pop124
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
	i32.const	$push148=, 0
	i32.const	$push108=, 1
	i32.store	$discard=, should_optimize($pop148), $pop108
	i32.const	$push147=, 0
	i32.load	$push109=, stdout($pop147)
	i32.const	$push146=, .L.str.1
	i32.load	$push110=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop109, $2, $pop146, $pop110
	i32.const	$push145=, 0
	i32.load	$push111=, should_optimize($pop145)
	i32.const	$push203=, 0
	i32.eq  	$push204=, $pop111, $pop203
	br_if   	10, $pop204     # 10: down to label1
# BB#7:                                 # %if.end13
	i32.const	$push151=, 0
	i32.const	$push150=, 0
	i32.store	$push10=, should_optimize($pop151), $pop150
	i32.load	$push112=, stdout($pop10)
	i32.const	$push149=, .L.str.1
	i32.load	$push113=, 8($2)
	i32.call	$push114=, __vfprintf_chk@FUNCTION, $pop112, $2, $pop149, $pop113
	i32.const	$push115=, 6
	i32.ne  	$push116=, $pop114, $pop115
	br_if   	10, $pop116     # 10: down to label1
# BB#8:                                 # %if.end17
	i32.const	$push117=, 0
	i32.load	$push118=, should_optimize($pop117)
	br_if   	9, $pop118      # 9: down to label2
# BB#9:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %sw.bb21
	end_block                       # label11:
	i32.const	$push155=, 0
	i32.const	$push98=, 1
	i32.store	$0=, should_optimize($pop155), $pop98
	i32.const	$push154=, 0
	i32.load	$push99=, stdout($pop154)
	i32.const	$push153=, .L.str.2
	i32.load	$push100=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop99, $2, $pop153, $pop100
	i32.const	$push152=, 0
	i32.load	$push101=, should_optimize($pop152)
	i32.const	$push205=, 0
	i32.eq  	$push206=, $pop101, $pop205
	br_if   	9, $pop206      # 9: down to label1
# BB#11:                                # %if.end25
	i32.const	$push158=, 0
	i32.const	$push157=, 0
	i32.store	$push9=, should_optimize($pop158), $pop157
	i32.load	$push102=, stdout($pop9)
	i32.const	$push156=, .L.str.2
	i32.load	$push103=, 8($2)
	i32.call	$push104=, __vfprintf_chk@FUNCTION, $pop102, $2, $pop156, $pop103
	i32.ne  	$push105=, $pop104, $0
	br_if   	9, $pop105      # 9: down to label1
# BB#12:                                # %if.end29
	i32.const	$push106=, 0
	i32.load	$push107=, should_optimize($pop106)
	br_if   	8, $pop107      # 8: down to label2
# BB#13:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %sw.bb33
	end_block                       # label10:
	i32.const	$push162=, 0
	i32.const	$push89=, 1
	i32.store	$discard=, should_optimize($pop162), $pop89
	i32.const	$push161=, 0
	i32.load	$push90=, stdout($pop161)
	i32.const	$push160=, .L.str.3
	i32.load	$push91=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop90, $2, $pop160, $pop91
	i32.const	$push159=, 0
	i32.load	$push92=, should_optimize($pop159)
	i32.const	$push207=, 0
	i32.eq  	$push208=, $pop92, $pop207
	br_if   	8, $pop208      # 8: down to label1
# BB#15:                                # %if.end37
	i32.const	$push165=, 0
	i32.const	$push164=, 0
	i32.store	$push8=, should_optimize($pop165), $pop164
	i32.load	$push93=, stdout($pop8)
	i32.const	$push163=, .L.str.3
	i32.load	$push94=, 8($2)
	i32.call	$push95=, __vfprintf_chk@FUNCTION, $pop93, $2, $pop163, $pop94
	br_if   	8, $pop95       # 8: down to label1
# BB#16:                                # %if.end41
	i32.const	$push96=, 0
	i32.load	$push97=, should_optimize($pop96)
	br_if   	7, $pop97       # 7: down to label2
# BB#17:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %sw.bb45
	end_block                       # label9:
	i32.const	$push78=, 0
	i32.const	$push169=, 0
	i32.store	$push168=, should_optimize($pop78), $pop169
	tee_local	$push167=, $0=, $pop168
	i32.load	$push79=, stdout($pop167)
	i32.const	$push166=, .L.str.4
	i32.load	$push80=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop79, $2, $pop166, $pop80
	i32.load	$push81=, should_optimize($0)
	i32.const	$push209=, 0
	i32.eq  	$push210=, $pop81, $pop209
	br_if   	7, $pop210      # 7: down to label1
# BB#19:                                # %if.end49
	i32.store	$push7=, should_optimize($0), $0
	i32.load	$push82=, stdout($pop7)
	i32.const	$push170=, .L.str.4
	i32.load	$push83=, 8($2)
	i32.call	$push84=, __vfprintf_chk@FUNCTION, $pop82, $2, $pop170, $pop83
	i32.const	$push85=, 5
	i32.ne  	$push86=, $pop84, $pop85
	br_if   	7, $pop86       # 7: down to label1
# BB#20:                                # %if.end53
	i32.const	$push87=, 0
	i32.load	$push88=, should_optimize($pop87)
	br_if   	6, $pop88       # 6: down to label2
# BB#21:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %sw.bb57
	end_block                       # label8:
	i32.const	$push67=, 0
	i32.const	$push174=, 0
	i32.store	$push173=, should_optimize($pop67), $pop174
	tee_local	$push172=, $0=, $pop173
	i32.load	$push68=, stdout($pop172)
	i32.const	$push171=, .L.str.4
	i32.load	$push69=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop68, $2, $pop171, $pop69
	i32.load	$push70=, should_optimize($0)
	i32.const	$push211=, 0
	i32.eq  	$push212=, $pop70, $pop211
	br_if   	6, $pop212      # 6: down to label1
# BB#23:                                # %if.end61
	i32.store	$push6=, should_optimize($0), $0
	i32.load	$push71=, stdout($pop6)
	i32.const	$push175=, .L.str.4
	i32.load	$push72=, 8($2)
	i32.call	$push73=, __vfprintf_chk@FUNCTION, $pop71, $2, $pop175, $pop72
	i32.const	$push74=, 6
	i32.ne  	$push75=, $pop73, $pop74
	br_if   	6, $pop75       # 6: down to label1
# BB#24:                                # %if.end65
	i32.const	$push76=, 0
	i32.load	$push77=, should_optimize($pop76)
	br_if   	5, $pop77       # 5: down to label2
# BB#25:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %sw.bb69
	end_block                       # label7:
	i32.const	$push56=, 0
	i32.const	$push179=, 0
	i32.store	$push178=, should_optimize($pop56), $pop179
	tee_local	$push177=, $0=, $pop178
	i32.load	$push57=, stdout($pop177)
	i32.const	$push176=, .L.str.4
	i32.load	$push58=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop57, $2, $pop176, $pop58
	i32.load	$push59=, should_optimize($0)
	i32.const	$push213=, 0
	i32.eq  	$push214=, $pop59, $pop213
	br_if   	5, $pop214      # 5: down to label1
# BB#27:                                # %if.end73
	i32.store	$push5=, should_optimize($0), $0
	i32.load	$push60=, stdout($pop5)
	i32.const	$push180=, .L.str.4
	i32.load	$push61=, 8($2)
	i32.call	$push62=, __vfprintf_chk@FUNCTION, $pop60, $2, $pop180, $pop61
	i32.const	$push63=, 1
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	5, $pop64       # 5: down to label1
# BB#28:                                # %if.end77
	i32.const	$push65=, 0
	i32.load	$push66=, should_optimize($pop65)
	br_if   	4, $pop66       # 4: down to label2
# BB#29:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %sw.bb81
	end_block                       # label6:
	i32.const	$push47=, 0
	i32.const	$push184=, 0
	i32.store	$push183=, should_optimize($pop47), $pop184
	tee_local	$push182=, $0=, $pop183
	i32.load	$push48=, stdout($pop182)
	i32.const	$push181=, .L.str.4
	i32.load	$push49=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop48, $2, $pop181, $pop49
	i32.load	$push50=, should_optimize($0)
	i32.const	$push215=, 0
	i32.eq  	$push216=, $pop50, $pop215
	br_if   	4, $pop216      # 4: down to label1
# BB#31:                                # %if.end85
	i32.store	$push4=, should_optimize($0), $0
	i32.load	$push51=, stdout($pop4)
	i32.const	$push185=, .L.str.4
	i32.load	$push52=, 8($2)
	i32.call	$push53=, __vfprintf_chk@FUNCTION, $pop51, $2, $pop185, $pop52
	br_if   	4, $pop53       # 4: down to label1
# BB#32:                                # %if.end89
	i32.const	$push54=, 0
	i32.load	$push55=, should_optimize($pop54)
	br_if   	3, $pop55       # 3: down to label2
# BB#33:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %sw.bb93
	end_block                       # label5:
	i32.const	$push36=, 0
	i32.const	$push189=, 0
	i32.store	$push188=, should_optimize($pop36), $pop189
	tee_local	$push187=, $0=, $pop188
	i32.load	$push37=, stdout($pop187)
	i32.const	$push186=, .L.str.5
	i32.load	$push38=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop37, $2, $pop186, $pop38
	i32.load	$push39=, should_optimize($0)
	i32.const	$push217=, 0
	i32.eq  	$push218=, $pop39, $pop217
	br_if   	3, $pop218      # 3: down to label1
# BB#35:                                # %if.end97
	i32.store	$push3=, should_optimize($0), $0
	i32.load	$push40=, stdout($pop3)
	i32.const	$push190=, .L.str.5
	i32.load	$push41=, 8($2)
	i32.call	$push42=, __vfprintf_chk@FUNCTION, $pop40, $2, $pop190, $pop41
	i32.const	$push43=, 1
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	3, $pop44       # 3: down to label1
# BB#36:                                # %if.end101
	i32.const	$push45=, 0
	i32.load	$push46=, should_optimize($pop45)
	br_if   	2, $pop46       # 2: down to label2
# BB#37:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %sw.bb105
	end_block                       # label4:
	i32.const	$push25=, 0
	i32.const	$push194=, 0
	i32.store	$push193=, should_optimize($pop25), $pop194
	tee_local	$push192=, $0=, $pop193
	i32.load	$push26=, stdout($pop192)
	i32.const	$push191=, .L.str.6
	i32.load	$push27=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop26, $2, $pop191, $pop27
	i32.load	$push28=, should_optimize($0)
	i32.const	$push219=, 0
	i32.eq  	$push220=, $pop28, $pop219
	br_if   	2, $pop220      # 2: down to label1
# BB#39:                                # %if.end109
	i32.store	$push2=, should_optimize($0), $0
	i32.load	$push29=, stdout($pop2)
	i32.const	$push195=, .L.str.6
	i32.load	$push30=, 8($2)
	i32.call	$push31=, __vfprintf_chk@FUNCTION, $pop29, $2, $pop195, $pop30
	i32.const	$push32=, 7
	i32.ne  	$push33=, $pop31, $pop32
	br_if   	2, $pop33       # 2: down to label1
# BB#40:                                # %if.end113
	i32.const	$push34=, 0
	i32.load	$push35=, should_optimize($pop34)
	br_if   	1, $pop35       # 1: down to label2
# BB#41:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %sw.bb117
	end_block                       # label3:
	i32.const	$push14=, 0
	i32.const	$push199=, 0
	i32.store	$push198=, should_optimize($pop14), $pop199
	tee_local	$push197=, $0=, $pop198
	i32.load	$push15=, stdout($pop197)
	i32.const	$push196=, .L.str.7
	i32.load	$push16=, 12($2)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop15, $2, $pop196, $pop16
	i32.load	$push17=, should_optimize($0)
	i32.const	$push221=, 0
	i32.eq  	$push222=, $pop17, $pop221
	br_if   	1, $pop222      # 1: down to label1
# BB#43:                                # %if.end121
	i32.store	$push1=, should_optimize($0), $0
	i32.load	$push18=, stdout($pop1)
	i32.const	$push200=, .L.str.7
	i32.load	$push19=, 8($2)
	i32.call	$push20=, __vfprintf_chk@FUNCTION, $pop18, $2, $pop200, $pop19
	i32.const	$push21=, 2
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	1, $pop22       # 1: down to label1
# BB#44:                                # %if.end125
	i32.const	$push23=, 0
	i32.load	$push24=, should_optimize($pop23)
	i32.const	$push223=, 0
	i32.eq  	$push224=, $pop24, $pop223
	br_if   	1, $pop224      # 1: down to label1
.LBB1_45:                               # %sw.epilog
	end_block                       # label2:
	i32.const	$push136=, __stack_pointer
	i32.const	$push134=, 16
	i32.add 	$push135=, $2, $pop134
	i32.store	$discard=, 0($pop136), $pop135
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push19=, __stack_pointer
	i32.const	$push16=, __stack_pointer
	i32.load	$push17=, 0($pop16)
	i32.const	$push18=, 112
	i32.sub 	$push35=, $pop17, $pop18
	i32.store	$1=, 0($pop19), $pop35
	i32.const	$push0=, 0
	i32.const	$push40=, 0
	call    	inner@FUNCTION, $pop0, $pop40
	i32.const	$push1=, 1
	i32.const	$push39=, 0
	call    	inner@FUNCTION, $pop1, $pop39
	i32.const	$push2=, 2
	i32.const	$push38=, 0
	call    	inner@FUNCTION, $pop2, $pop38
	i32.const	$push3=, 3
	i32.const	$push37=, 0
	call    	inner@FUNCTION, $pop3, $pop37
	i32.const	$push4=, .L.str
	i32.store	$discard=, 96($1), $pop4
	i32.const	$push5=, 4
	i32.const	$push23=, 96
	i32.add 	$push24=, $1, $pop23
	call    	inner@FUNCTION, $pop5, $pop24
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 80($1), $pop6
	i32.const	$push7=, 5
	i32.const	$push25=, 80
	i32.add 	$push26=, $1, $pop25
	call    	inner@FUNCTION, $pop7, $pop26
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 64($1), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $1, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 48($1), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $1, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	$discard=, 32($1), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $1, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.store	$discard=, 16($1), $0
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $1, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	$0=, 0($1), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $1
	i32.const	$push22=, __stack_pointer
	i32.const	$push20=, 112
	i32.add 	$push21=, $1, $pop20
	i32.store	$discard=, 0($pop22), $pop21
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
