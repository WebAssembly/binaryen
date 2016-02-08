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
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	copy_local	$5=, $4
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.store	$push0=, 12($4), $5
	i32.store	$discard=, 8($4), $pop0
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
	block
	block
	block
	tableswitch	$0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # 0: down to label16
                                        # 1: down to label15
                                        # 2: down to label14
                                        # 3: down to label13
                                        # 4: down to label12
                                        # 5: down to label11
                                        # 6: down to label10
                                        # 7: down to label9
                                        # 8: down to label8
                                        # 9: down to label7
                                        # 10: down to label6
.LBB1_2:                                # %sw.bb
	end_block                       # label16:
	i32.const	$push140=, 0
	i32.const	$push125=, 1
	i32.store	$discard=, should_optimize($pop140), $pop125
	i32.const	$push139=, 0
	i32.load	$push126=, stdout($pop139)
	i32.const	$push138=, .L.str
	i32.load	$push127=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop126, $0, $pop138, $pop127
	block
	i32.const	$push137=, 0
	i32.load	$push128=, should_optimize($pop137)
	i32.const	$push193=, 0
	i32.eq  	$push194=, $pop128, $pop193
	br_if   	0, $pop194      # 0: down to label17
# BB#3:                                 # %if.end
	block
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.store	$push129=, should_optimize($pop143), $pop142
	i32.load	$push130=, stdout($pop129)
	i32.const	$push141=, .L.str
	i32.load	$push131=, 8($4)
	i32.call	$push132=, __vfprintf_chk@FUNCTION, $pop130, $0, $pop141, $pop131
	i32.const	$push133=, 5
	i32.ne  	$push134=, $pop132, $pop133
	br_if   	0, $pop134      # 0: down to label18
# BB#4:                                 # %if.end5
	i32.const	$push135=, 0
	i32.load	$push136=, should_optimize($pop135)
	br_if   	12, $pop136     # 12: down to label5
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then4
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_8:                                # %sw.bb9
	end_block                       # label15:
	i32.const	$push147=, 0
	i32.const	$push113=, 1
	i32.store	$discard=, should_optimize($pop147), $pop113
	i32.const	$push146=, 0
	i32.load	$push114=, stdout($pop146)
	i32.const	$push145=, .L.str.1
	i32.load	$push115=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop114, $0, $pop145, $pop115
	block
	i32.const	$push144=, 0
	i32.load	$push116=, should_optimize($pop144)
	i32.const	$push195=, 0
	i32.eq  	$push196=, $pop116, $pop195
	br_if   	0, $pop196      # 0: down to label19
# BB#9:                                 # %if.end13
	block
	i32.const	$push150=, 0
	i32.const	$push149=, 0
	i32.store	$push117=, should_optimize($pop150), $pop149
	i32.load	$push118=, stdout($pop117)
	i32.const	$push148=, .L.str.1
	i32.load	$push119=, 8($4)
	i32.call	$push120=, __vfprintf_chk@FUNCTION, $pop118, $0, $pop148, $pop119
	i32.const	$push121=, 6
	i32.ne  	$push122=, $pop120, $pop121
	br_if   	0, $pop122      # 0: down to label20
# BB#10:                                # %if.end17
	i32.const	$push123=, 0
	i32.load	$push124=, should_optimize($pop123)
	br_if   	11, $pop124     # 11: down to label5
# BB#11:                                # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB1_12:                               # %if.then16
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_13:                               # %if.then12
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %sw.bb21
	end_block                       # label14:
	i32.const	$push154=, 0
	i32.const	$push102=, 1
	i32.store	$0=, should_optimize($pop154), $pop102
	i32.const	$push153=, 0
	i32.load	$push103=, stdout($pop153)
	i32.const	$push152=, .L.str.2
	i32.load	$push104=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop103, $0, $pop152, $pop104
	block
	i32.const	$push151=, 0
	i32.load	$push105=, should_optimize($pop151)
	i32.const	$push197=, 0
	i32.eq  	$push198=, $pop105, $pop197
	br_if   	0, $pop198      # 0: down to label21
# BB#15:                                # %if.end25
	block
	i32.const	$push157=, 0
	i32.const	$push156=, 0
	i32.store	$push106=, should_optimize($pop157), $pop156
	i32.load	$push107=, stdout($pop106)
	i32.const	$push155=, .L.str.2
	i32.load	$push108=, 8($4)
	i32.call	$push109=, __vfprintf_chk@FUNCTION, $pop107, $0, $pop155, $pop108
	i32.ne  	$push110=, $pop109, $0
	br_if   	0, $pop110      # 0: down to label22
# BB#16:                                # %if.end29
	i32.const	$push111=, 0
	i32.load	$push112=, should_optimize($pop111)
	br_if   	10, $pop112     # 10: down to label5
# BB#17:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then28
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then24
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_20:                               # %sw.bb33
	end_block                       # label13:
	i32.const	$push161=, 0
	i32.const	$push92=, 1
	i32.store	$discard=, should_optimize($pop161), $pop92
	i32.const	$push160=, 0
	i32.load	$push93=, stdout($pop160)
	i32.const	$push159=, .L.str.3
	i32.load	$push94=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop93, $0, $pop159, $pop94
	block
	i32.const	$push158=, 0
	i32.load	$push95=, should_optimize($pop158)
	i32.const	$push199=, 0
	i32.eq  	$push200=, $pop95, $pop199
	br_if   	0, $pop200      # 0: down to label23
# BB#21:                                # %if.end37
	block
	i32.const	$push164=, 0
	i32.const	$push163=, 0
	i32.store	$push96=, should_optimize($pop164), $pop163
	i32.load	$push97=, stdout($pop96)
	i32.const	$push162=, .L.str.3
	i32.load	$push98=, 8($4)
	i32.call	$push99=, __vfprintf_chk@FUNCTION, $pop97, $0, $pop162, $pop98
	br_if   	0, $pop99       # 0: down to label24
# BB#22:                                # %if.end41
	i32.const	$push100=, 0
	i32.load	$push101=, should_optimize($pop100)
	br_if   	9, $pop101      # 9: down to label5
# BB#23:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB1_24:                               # %if.then40
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then36
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %sw.bb45
	end_block                       # label12:
	i32.const	$push79=, 0
	i32.const	$push167=, 0
	i32.store	$push80=, should_optimize($pop79), $pop167
	tee_local	$push166=, $0=, $pop80
	i32.load	$push81=, stdout($pop166)
	i32.const	$push165=, .L.str.4
	i32.load	$push82=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop81, $0, $pop165, $pop82
	block
	i32.load	$push83=, should_optimize($0)
	i32.const	$push201=, 0
	i32.eq  	$push202=, $pop83, $pop201
	br_if   	0, $pop202      # 0: down to label25
# BB#27:                                # %if.end49
	block
	i32.store	$push84=, should_optimize($0), $0
	i32.load	$push85=, stdout($pop84)
	i32.const	$push168=, .L.str.4
	i32.load	$push86=, 8($4)
	i32.call	$push87=, __vfprintf_chk@FUNCTION, $pop85, $0, $pop168, $pop86
	i32.const	$push88=, 5
	i32.ne  	$push89=, $pop87, $pop88
	br_if   	0, $pop89       # 0: down to label26
# BB#28:                                # %if.end53
	i32.const	$push90=, 0
	i32.load	$push91=, should_optimize($pop90)
	br_if   	8, $pop91       # 8: down to label5
# BB#29:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then52
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %if.then48
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
.LBB1_32:                               # %sw.bb57
	end_block                       # label11:
	i32.const	$push66=, 0
	i32.const	$push171=, 0
	i32.store	$push67=, should_optimize($pop66), $pop171
	tee_local	$push170=, $0=, $pop67
	i32.load	$push68=, stdout($pop170)
	i32.const	$push169=, .L.str.4
	i32.load	$push69=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop68, $0, $pop169, $pop69
	block
	i32.load	$push70=, should_optimize($0)
	i32.const	$push203=, 0
	i32.eq  	$push204=, $pop70, $pop203
	br_if   	0, $pop204      # 0: down to label27
# BB#33:                                # %if.end61
	block
	i32.store	$push71=, should_optimize($0), $0
	i32.load	$push72=, stdout($pop71)
	i32.const	$push172=, .L.str.4
	i32.load	$push73=, 8($4)
	i32.call	$push74=, __vfprintf_chk@FUNCTION, $pop72, $0, $pop172, $pop73
	i32.const	$push75=, 6
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label28
# BB#34:                                # %if.end65
	i32.const	$push77=, 0
	i32.load	$push78=, should_optimize($pop77)
	br_if   	7, $pop78       # 7: down to label5
# BB#35:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB1_36:                               # %if.then64
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
.LBB1_37:                               # %if.then60
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %sw.bb69
	end_block                       # label10:
	i32.const	$push53=, 0
	i32.const	$push175=, 0
	i32.store	$push54=, should_optimize($pop53), $pop175
	tee_local	$push174=, $0=, $pop54
	i32.load	$push55=, stdout($pop174)
	i32.const	$push173=, .L.str.4
	i32.load	$push56=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop55, $0, $pop173, $pop56
	block
	i32.load	$push57=, should_optimize($0)
	i32.const	$push205=, 0
	i32.eq  	$push206=, $pop57, $pop205
	br_if   	0, $pop206      # 0: down to label29
# BB#39:                                # %if.end73
	block
	i32.store	$push58=, should_optimize($0), $0
	i32.load	$push59=, stdout($pop58)
	i32.const	$push176=, .L.str.4
	i32.load	$push60=, 8($4)
	i32.call	$push61=, __vfprintf_chk@FUNCTION, $pop59, $0, $pop176, $pop60
	i32.const	$push62=, 1
	i32.ne  	$push63=, $pop61, $pop62
	br_if   	0, $pop63       # 0: down to label30
# BB#40:                                # %if.end77
	i32.const	$push64=, 0
	i32.load	$push65=, should_optimize($pop64)
	br_if   	6, $pop65       # 6: down to label5
# BB#41:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %if.then76
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_43:                               # %if.then72
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB1_44:                               # %sw.bb81
	end_block                       # label9:
	i32.const	$push42=, 0
	i32.const	$push179=, 0
	i32.store	$push43=, should_optimize($pop42), $pop179
	tee_local	$push178=, $0=, $pop43
	i32.load	$push44=, stdout($pop178)
	i32.const	$push177=, .L.str.4
	i32.load	$push45=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop44, $0, $pop177, $pop45
	block
	i32.load	$push46=, should_optimize($0)
	i32.const	$push207=, 0
	i32.eq  	$push208=, $pop46, $pop207
	br_if   	0, $pop208      # 0: down to label31
# BB#45:                                # %if.end85
	block
	i32.store	$push47=, should_optimize($0), $0
	i32.load	$push48=, stdout($pop47)
	i32.const	$push180=, .L.str.4
	i32.load	$push49=, 8($4)
	i32.call	$push50=, __vfprintf_chk@FUNCTION, $pop48, $0, $pop180, $pop49
	br_if   	0, $pop50       # 0: down to label32
# BB#46:                                # %if.end89
	i32.const	$push51=, 0
	i32.load	$push52=, should_optimize($pop51)
	br_if   	5, $pop52       # 5: down to label5
# BB#47:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then88
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then84
	end_block                       # label31:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %sw.bb93
	end_block                       # label8:
	i32.const	$push29=, 0
	i32.const	$push183=, 0
	i32.store	$push30=, should_optimize($pop29), $pop183
	tee_local	$push182=, $0=, $pop30
	i32.load	$push31=, stdout($pop182)
	i32.const	$push181=, .L.str.5
	i32.load	$push32=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop31, $0, $pop181, $pop32
	block
	i32.load	$push33=, should_optimize($0)
	i32.const	$push209=, 0
	i32.eq  	$push210=, $pop33, $pop209
	br_if   	0, $pop210      # 0: down to label33
# BB#51:                                # %if.end97
	block
	i32.store	$push34=, should_optimize($0), $0
	i32.load	$push35=, stdout($pop34)
	i32.const	$push184=, .L.str.5
	i32.load	$push36=, 8($4)
	i32.call	$push37=, __vfprintf_chk@FUNCTION, $pop35, $0, $pop184, $pop36
	i32.const	$push38=, 1
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label34
# BB#52:                                # %if.end101
	i32.const	$push40=, 0
	i32.load	$push41=, should_optimize($pop40)
	br_if   	4, $pop41       # 4: down to label5
# BB#53:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then100
	end_block                       # label34:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then96
	end_block                       # label33:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %sw.bb105
	end_block                       # label7:
	i32.const	$push16=, 0
	i32.const	$push187=, 0
	i32.store	$push17=, should_optimize($pop16), $pop187
	tee_local	$push186=, $0=, $pop17
	i32.load	$push18=, stdout($pop186)
	i32.const	$push185=, .L.str.6
	i32.load	$push19=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop18, $0, $pop185, $pop19
	block
	i32.load	$push20=, should_optimize($0)
	i32.const	$push211=, 0
	i32.eq  	$push212=, $pop20, $pop211
	br_if   	0, $pop212      # 0: down to label35
# BB#57:                                # %if.end109
	block
	i32.store	$push21=, should_optimize($0), $0
	i32.load	$push22=, stdout($pop21)
	i32.const	$push188=, .L.str.6
	i32.load	$push23=, 8($4)
	i32.call	$push24=, __vfprintf_chk@FUNCTION, $pop22, $0, $pop188, $pop23
	i32.const	$push25=, 7
	i32.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label36
# BB#58:                                # %if.end113
	i32.const	$push27=, 0
	i32.load	$push28=, should_optimize($pop27)
	br_if   	3, $pop28       # 3: down to label5
# BB#59:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then112
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then108
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %sw.bb117
	end_block                       # label6:
	i32.const	$push3=, 0
	i32.const	$push191=, 0
	i32.store	$push4=, should_optimize($pop3), $pop191
	tee_local	$push190=, $0=, $pop4
	i32.load	$push5=, stdout($pop190)
	i32.const	$push189=, .L.str.7
	i32.load	$push6=, 12($4)
	i32.call	$discard=, __vfprintf_chk@FUNCTION, $pop5, $0, $pop189, $pop6
	i32.load	$push7=, should_optimize($0)
	i32.const	$push213=, 0
	i32.eq  	$push214=, $pop7, $pop213
	br_if   	3, $pop214      # 3: down to label2
# BB#63:                                # %if.end121
	i32.store	$push8=, should_optimize($0), $0
	i32.load	$push9=, stdout($pop8)
	i32.const	$push192=, .L.str.7
	i32.load	$push10=, 8($4)
	i32.call	$push11=, __vfprintf_chk@FUNCTION, $pop9, $0, $pop192, $pop10
	i32.const	$push12=, 2
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	2, $pop13       # 2: down to label3
# BB#64:                                # %if.end125
	i32.const	$push14=, 0
	i32.load	$push15=, should_optimize($pop14)
	i32.const	$push215=, 0
	i32.eq  	$push216=, $pop15, $pop215
	br_if   	1, $pop216      # 1: down to label4
.LBB1_65:                               # %sw.epilog
	end_block                       # label5:
	i32.const	$3=, 16
	i32.add 	$4=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
.LBB1_66:                               # %if.then127
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_67:                               # %if.then124
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_68:                               # %if.then120
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_69:                               # %sw.default
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$29=, __stack_pointer
	i32.load	$29=, 0($29)
	i32.const	$30=, 16
	i32.sub 	$32=, $29, $30
	i32.const	$30=, __stack_pointer
	i32.store	$32=, 0($30), $32
	i32.const	$push0=, 0
	call    	inner@FUNCTION, $pop0
	i32.const	$push1=, 1
	call    	inner@FUNCTION, $pop1
	i32.const	$push2=, 2
	call    	inner@FUNCTION, $pop2
	i32.const	$push3=, 3
	call    	inner@FUNCTION, $pop3
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 4
	i32.sub 	$32=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$32=, 0($2), $32
	i32.const	$push4=, .L.str
	i32.store	$discard=, 0($32), $pop4
	i32.const	$push5=, 4
	call    	inner@FUNCTION, $pop5
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 4
	i32.add 	$32=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$32=, 0($4), $32
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 4
	i32.sub 	$32=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$32=, 0($6), $32
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 0($32), $pop6
	i32.const	$push7=, 5
	call    	inner@FUNCTION, $pop7
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 4
	i32.add 	$32=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$32=, 0($8), $32
	i32.const	$9=, __stack_pointer
	i32.load	$9=, 0($9)
	i32.const	$10=, 4
	i32.sub 	$32=, $9, $10
	i32.const	$10=, __stack_pointer
	i32.store	$32=, 0($10), $32
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 0($32), $pop8
	i32.const	$push9=, 6
	call    	inner@FUNCTION, $pop9
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 4
	i32.add 	$32=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$32=, 0($12), $32
	i32.const	$13=, __stack_pointer
	i32.load	$13=, 0($13)
	i32.const	$14=, 4
	i32.sub 	$32=, $13, $14
	i32.const	$14=, __stack_pointer
	i32.store	$32=, 0($14), $32
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 0($32), $pop10
	i32.const	$push11=, 7
	call    	inner@FUNCTION, $pop11
	i32.const	$15=, __stack_pointer
	i32.load	$15=, 0($15)
	i32.const	$16=, 4
	i32.add 	$32=, $15, $16
	i32.const	$16=, __stack_pointer
	i32.store	$32=, 0($16), $32
	i32.const	$17=, __stack_pointer
	i32.load	$17=, 0($17)
	i32.const	$18=, 4
	i32.sub 	$32=, $17, $18
	i32.const	$18=, __stack_pointer
	i32.store	$32=, 0($18), $32
	i32.const	$push12=, 120
	i32.store	$discard=, 0($32), $pop12
	i32.const	$push13=, 8
	call    	inner@FUNCTION, $pop13
	i32.const	$19=, __stack_pointer
	i32.load	$19=, 0($19)
	i32.const	$20=, 4
	i32.add 	$32=, $19, $20
	i32.const	$20=, __stack_pointer
	i32.store	$32=, 0($20), $32
	i32.const	$21=, __stack_pointer
	i32.load	$21=, 0($21)
	i32.const	$22=, 4
	i32.sub 	$32=, $21, $22
	i32.const	$22=, __stack_pointer
	i32.store	$32=, 0($22), $32
	i32.store	$discard=, 0($32), $0
	i32.const	$push14=, 9
	call    	inner@FUNCTION, $pop14
	i32.const	$23=, __stack_pointer
	i32.load	$23=, 0($23)
	i32.const	$24=, 4
	i32.add 	$32=, $23, $24
	i32.const	$24=, __stack_pointer
	i32.store	$32=, 0($24), $32
	i32.const	$25=, __stack_pointer
	i32.load	$25=, 0($25)
	i32.const	$26=, 4
	i32.sub 	$32=, $25, $26
	i32.const	$26=, __stack_pointer
	i32.store	$32=, 0($26), $32
	i32.const	$push16=, 0
	i32.store	$0=, 0($32), $pop16
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15
	i32.const	$27=, __stack_pointer
	i32.load	$27=, 0($27)
	i32.const	$28=, 4
	i32.add 	$32=, $27, $28
	i32.const	$28=, __stack_pointer
	i32.store	$32=, 0($28), $32
	i32.const	$31=, 16
	i32.add 	$32=, $32, $31
	i32.const	$31=, __stack_pointer
	i32.store	$32=, 0($31), $32
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
