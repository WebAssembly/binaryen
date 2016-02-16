	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vprintf-chk-1.c"
	.section	.text.__vprintf_chk,"ax",@progbits
	.hidden	__vprintf_chk
	.globl	__vprintf_chk
	.type	__vprintf_chk,@function
__vprintf_chk:                          # @__vprintf_chk
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push4=, 0
	i32.load	$push0=, should_optimize($pop4)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, should_optimize($pop6), $pop1
	i32.const	$push5=, 0
	i32.load	$push2=, stdout($pop5)
	i32.call	$push3=, vfprintf@FUNCTION, $pop2, $1, $2
	return  	$pop3
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__vprintf_chk, .Lfunc_end0-__vprintf_chk

	.section	.text.inner,"ax",@progbits
	.hidden	inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$push0=, 12($5), $1
	i32.store	$discard=, 8($5), $pop0
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
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push1=, 10
	i32.gt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label24
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
	tableswitch	$0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # 0: down to label36
                                        # 1: down to label35
                                        # 2: down to label34
                                        # 3: down to label33
                                        # 4: down to label32
                                        # 5: down to label31
                                        # 6: down to label30
                                        # 7: down to label29
                                        # 8: down to label28
                                        # 9: down to label27
                                        # 10: down to label26
.LBB1_2:                                # %sw.bb
	end_block                       # label36:
	i32.const	$push88=, 0
	i32.const	$push98=, 0
	i32.store	$0=, should_optimize($pop88), $pop98
	i32.const	$push97=, .L.str
	i32.load	$push89=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop97, $pop89
	i32.load	$push90=, should_optimize($0)
	i32.const	$push139=, 0
	i32.eq  	$push140=, $pop90, $pop139
	br_if   	12, $pop140     # 12: down to label23
# BB#3:                                 # %if.end
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push99=, .L.str
	i32.load	$push91=, 8($5)
	i32.call	$push92=, __vprintf_chk@FUNCTION, $0, $pop99, $pop91
	i32.const	$push93=, 5
	i32.ne  	$push94=, $pop92, $pop93
	br_if   	13, $pop94      # 13: down to label22
# BB#4:                                 # %if.end5
	i32.const	$push95=, 0
	i32.load	$push96=, should_optimize($pop95)
	br_if   	10, $pop96      # 10: down to label25
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %sw.bb9
	end_block                       # label35:
	i32.const	$push102=, 0
	i32.const	$push79=, 1
	i32.store	$discard=, should_optimize($pop102), $pop79
	i32.const	$push101=, .L.str.1
	i32.load	$push80=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop101, $pop80
	i32.const	$push100=, 0
	i32.load	$push81=, should_optimize($pop100)
	i32.const	$push141=, 0
	i32.eq  	$push142=, $pop81, $pop141
	br_if   	13, $pop142     # 13: down to label21
# BB#7:                                 # %if.end13
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.store	$discard=, should_optimize($pop105), $pop104
	i32.const	$push103=, .L.str.1
	i32.load	$push82=, 8($5)
	i32.call	$push83=, __vprintf_chk@FUNCTION, $0, $pop103, $pop82
	i32.const	$push84=, 6
	i32.ne  	$push85=, $pop83, $pop84
	br_if   	14, $pop85      # 14: down to label20
# BB#8:                                 # %if.end17
	i32.const	$push86=, 0
	i32.load	$push87=, should_optimize($pop86)
	br_if   	9, $pop87       # 9: down to label25
# BB#9:                                 # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %sw.bb21
	end_block                       # label34:
	i32.const	$push108=, 0
	i32.const	$push71=, 1
	i32.store	$0=, should_optimize($pop108), $pop71
	i32.const	$push107=, .L.str.2
	i32.load	$push72=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop107, $pop72
	i32.const	$push106=, 0
	i32.load	$push73=, should_optimize($pop106)
	i32.const	$push143=, 0
	i32.eq  	$push144=, $pop73, $pop143
	br_if   	14, $pop144     # 14: down to label19
# BB#11:                                # %if.end25
	i32.const	$push111=, 0
	i32.const	$push110=, 0
	i32.store	$discard=, should_optimize($pop111), $pop110
	i32.const	$push109=, .L.str.2
	i32.load	$push74=, 8($5)
	i32.call	$push75=, __vprintf_chk@FUNCTION, $0, $pop109, $pop74
	i32.ne  	$push76=, $pop75, $0
	br_if   	15, $pop76      # 15: down to label18
# BB#12:                                # %if.end29
	i32.const	$push77=, 0
	i32.load	$push78=, should_optimize($pop77)
	br_if   	8, $pop78       # 8: down to label25
# BB#13:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB1_14:                               # %sw.bb33
	end_block                       # label33:
	i32.const	$push114=, 0
	i32.const	$push64=, 1
	i32.store	$discard=, should_optimize($pop114), $pop64
	i32.const	$push113=, .L.str.3
	i32.load	$push65=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop113, $pop65
	i32.const	$push112=, 0
	i32.load	$push66=, should_optimize($pop112)
	i32.const	$push145=, 0
	i32.eq  	$push146=, $pop66, $pop145
	br_if   	15, $pop146     # 15: down to label17
# BB#15:                                # %if.end37
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.store	$discard=, should_optimize($pop117), $pop116
	i32.const	$push115=, .L.str.3
	i32.load	$push67=, 8($5)
	i32.call	$push68=, __vprintf_chk@FUNCTION, $0, $pop115, $pop67
	br_if   	16, $pop68      # 16: down to label16
# BB#16:                                # %if.end41
	i32.const	$push69=, 0
	i32.load	$push70=, should_optimize($pop69)
	br_if   	7, $pop70       # 7: down to label25
# BB#17:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %sw.bb45
	end_block                       # label32:
	i32.const	$push55=, 0
	i32.const	$push119=, 0
	i32.store	$0=, should_optimize($pop55), $pop119
	i32.const	$push118=, .L.str.4
	i32.load	$push56=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop118, $pop56
	i32.load	$push57=, should_optimize($0)
	i32.const	$push147=, 0
	i32.eq  	$push148=, $pop57, $pop147
	br_if   	16, $pop148     # 16: down to label15
# BB#19:                                # %if.end49
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push120=, .L.str.4
	i32.load	$push58=, 8($5)
	i32.call	$push59=, __vprintf_chk@FUNCTION, $0, $pop120, $pop58
	i32.const	$push60=, 5
	i32.ne  	$push61=, $pop59, $pop60
	br_if   	17, $pop61      # 17: down to label14
# BB#20:                                # %if.end53
	i32.const	$push62=, 0
	i32.load	$push63=, should_optimize($pop62)
	br_if   	6, $pop63       # 6: down to label25
# BB#21:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB1_22:                               # %sw.bb57
	end_block                       # label31:
	i32.const	$push46=, 0
	i32.const	$push122=, 0
	i32.store	$0=, should_optimize($pop46), $pop122
	i32.const	$push121=, .L.str.4
	i32.load	$push47=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop121, $pop47
	i32.load	$push48=, should_optimize($0)
	i32.const	$push149=, 0
	i32.eq  	$push150=, $pop48, $pop149
	br_if   	17, $pop150     # 17: down to label13
# BB#23:                                # %if.end61
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push123=, .L.str.4
	i32.load	$push49=, 8($5)
	i32.call	$push50=, __vprintf_chk@FUNCTION, $0, $pop123, $pop49
	i32.const	$push51=, 6
	i32.ne  	$push52=, $pop50, $pop51
	br_if   	18, $pop52      # 18: down to label12
# BB#24:                                # %if.end65
	i32.const	$push53=, 0
	i32.load	$push54=, should_optimize($pop53)
	br_if   	5, $pop54       # 5: down to label25
# BB#25:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %sw.bb69
	end_block                       # label30:
	i32.const	$push37=, 0
	i32.const	$push125=, 0
	i32.store	$0=, should_optimize($pop37), $pop125
	i32.const	$push124=, .L.str.4
	i32.load	$push38=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop124, $pop38
	i32.load	$push39=, should_optimize($0)
	i32.const	$push151=, 0
	i32.eq  	$push152=, $pop39, $pop151
	br_if   	18, $pop152     # 18: down to label11
# BB#27:                                # %if.end73
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push126=, .L.str.4
	i32.load	$push40=, 8($5)
	i32.call	$push41=, __vprintf_chk@FUNCTION, $0, $pop126, $pop40
	i32.const	$push42=, 1
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	19, $pop43      # 19: down to label10
# BB#28:                                # %if.end77
	i32.const	$push44=, 0
	i32.load	$push45=, should_optimize($pop44)
	br_if   	4, $pop45       # 4: down to label25
# BB#29:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %sw.bb81
	end_block                       # label29:
	i32.const	$push30=, 0
	i32.const	$push128=, 0
	i32.store	$0=, should_optimize($pop30), $pop128
	i32.const	$push127=, .L.str.4
	i32.load	$push31=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop127, $pop31
	i32.load	$push32=, should_optimize($0)
	i32.const	$push153=, 0
	i32.eq  	$push154=, $pop32, $pop153
	br_if   	19, $pop154     # 19: down to label9
# BB#31:                                # %if.end85
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push129=, .L.str.4
	i32.load	$push33=, 8($5)
	i32.call	$push34=, __vprintf_chk@FUNCTION, $0, $pop129, $pop33
	br_if   	20, $pop34      # 20: down to label8
# BB#32:                                # %if.end89
	i32.const	$push35=, 0
	i32.load	$push36=, should_optimize($pop35)
	br_if   	3, $pop36       # 3: down to label25
# BB#33:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %sw.bb93
	end_block                       # label28:
	i32.const	$push21=, 0
	i32.const	$push131=, 0
	i32.store	$0=, should_optimize($pop21), $pop131
	i32.const	$push130=, .L.str.5
	i32.load	$push22=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop130, $pop22
	i32.load	$push23=, should_optimize($0)
	i32.const	$push155=, 0
	i32.eq  	$push156=, $pop23, $pop155
	br_if   	20, $pop156     # 20: down to label7
# BB#35:                                # %if.end97
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push132=, .L.str.5
	i32.load	$push24=, 8($5)
	i32.call	$push25=, __vprintf_chk@FUNCTION, $0, $pop132, $pop24
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	21, $pop27      # 21: down to label6
# BB#36:                                # %if.end101
	i32.const	$push28=, 0
	i32.load	$push29=, should_optimize($pop28)
	br_if   	2, $pop29       # 2: down to label25
# BB#37:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB1_38:                               # %sw.bb105
	end_block                       # label27:
	i32.const	$push12=, 0
	i32.const	$push134=, 0
	i32.store	$0=, should_optimize($pop12), $pop134
	i32.const	$push133=, .L.str.6
	i32.load	$push13=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop133, $pop13
	i32.load	$push14=, should_optimize($0)
	i32.const	$push157=, 0
	i32.eq  	$push158=, $pop14, $pop157
	br_if   	21, $pop158     # 21: down to label5
# BB#39:                                # %if.end109
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push135=, .L.str.6
	i32.load	$push15=, 8($5)
	i32.call	$push16=, __vprintf_chk@FUNCTION, $0, $pop135, $pop15
	i32.const	$push17=, 7
	i32.ne  	$push18=, $pop16, $pop17
	br_if   	22, $pop18      # 22: down to label4
# BB#40:                                # %if.end113
	i32.const	$push19=, 0
	i32.load	$push20=, should_optimize($pop19)
	br_if   	1, $pop20       # 1: down to label25
# BB#41:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB1_42:                               # %sw.bb117
	end_block                       # label26:
	i32.const	$push3=, 0
	i32.const	$push137=, 0
	i32.store	$0=, should_optimize($pop3), $pop137
	i32.const	$push136=, .L.str.7
	i32.load	$push4=, 12($5)
	i32.call	$discard=, __vprintf_chk@FUNCTION, $0, $pop136, $pop4
	i32.load	$push5=, should_optimize($0)
	i32.const	$push159=, 0
	i32.eq  	$push160=, $pop5, $pop159
	br_if   	22, $pop160     # 22: down to label3
# BB#43:                                # %if.end121
	i32.store	$discard=, should_optimize($0), $0
	i32.const	$push138=, .L.str.7
	i32.load	$push6=, 8($5)
	i32.call	$push7=, __vprintf_chk@FUNCTION, $0, $pop138, $pop6
	i32.const	$push8=, 2
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	23, $pop9       # 23: down to label2
# BB#44:                                # %if.end125
	i32.const	$push10=, 0
	i32.load	$push11=, should_optimize($pop10)
	i32.const	$push161=, 0
	i32.eq  	$push162=, $pop11, $pop161
	br_if   	24, $pop162     # 24: down to label1
.LBB1_45:                               # %sw.epilog
	end_block                       # label25:
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return
.LBB1_46:                               # %sw.default
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB1_47:                               # %if.then
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               # %if.then4
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
.LBB1_49:                               # %if.then12
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB1_50:                               # %if.then16
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB1_51:                               # %if.then24
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB1_52:                               # %if.then28
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB1_53:                               # %if.then36
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_54:                               # %if.then40
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_55:                               # %if.then48
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB1_56:                               # %if.then52
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_57:                               # %if.then60
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_58:                               # %if.then64
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_59:                               # %if.then72
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_60:                               # %if.then76
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_61:                               # %if.then84
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_62:                               # %if.then88
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_63:                               # %if.then96
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_64:                               # %if.then100
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_65:                               # %if.then108
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_66:                               # %if.then112
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_67:                               # %if.then120
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_68:                               # %if.then124
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB1_69:                               # %if.then127
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 112
	i32.sub 	$10=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$10=, 0($2), $10
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
	i32.store	$discard=, 96($10):p2align=4, $pop4
	i32.const	$push5=, 4
	i32.const	$4=, 96
	i32.add 	$4=, $10, $4
	call    	inner@FUNCTION, $pop5, $4
	i32.const	$push6=, .L.str.1
	i32.store	$0=, 80($10):p2align=4, $pop6
	i32.const	$push7=, 5
	i32.const	$5=, 80
	i32.add 	$5=, $10, $5
	call    	inner@FUNCTION, $pop7, $5
	i32.const	$push8=, .L.str.2
	i32.store	$discard=, 64($10):p2align=4, $pop8
	i32.const	$push9=, 6
	i32.const	$6=, 64
	i32.add 	$6=, $10, $6
	call    	inner@FUNCTION, $pop9, $6
	i32.const	$push10=, .L.str.3
	i32.store	$discard=, 48($10):p2align=4, $pop10
	i32.const	$push11=, 7
	i32.const	$7=, 48
	i32.add 	$7=, $10, $7
	call    	inner@FUNCTION, $pop11, $7
	i32.const	$push12=, 120
	i32.store	$discard=, 32($10):p2align=4, $pop12
	i32.const	$push13=, 8
	i32.const	$8=, 32
	i32.add 	$8=, $10, $8
	call    	inner@FUNCTION, $pop13, $8
	i32.store	$discard=, 16($10):p2align=4, $0
	i32.const	$push14=, 9
	i32.const	$9=, 16
	i32.add 	$9=, $10, $9
	call    	inner@FUNCTION, $pop14, $9
	i32.const	$push16=, 0
	i32.store	$0=, 0($10):p2align=4, $pop16
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $10
	i32.const	$3=, 112
	i32.add 	$10=, $10, $3
	i32.const	$3=, __stack_pointer
	i32.store	$10=, 0($3), $10
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
