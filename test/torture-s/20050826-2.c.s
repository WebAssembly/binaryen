	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-2.c"
	.section	.text.inet_check_attr,"ax",@progbits
	.hidden	inet_check_attr
	.globl	inet_check_attr
	.type	inet_check_attr,@function
inet_check_attr:                        # @inet_check_attr
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $4=, $pop8
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop7, $pop17
	br_if   	0, $pop18       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, -22
	i32.load16_u	$push0=, 0($4)
	i32.const	$push10=, 65532
	i32.and 	$push1=, $pop0, $pop10
	i32.const	$push9=, 4
	i32.eq  	$push2=, $pop1, $pop9
	br_if   	2, $pop2        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, -2
	i32.and 	$push3=, $2, $pop12
	i32.const	$push11=, 8
	i32.eq  	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label2
# BB#4:                                 # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 4
	i32.add 	$push5=, $4, $pop13
	i32.store	$discard=, 0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push16=, 1
	i32.add 	$2=, $2, $pop16
	i32.const	$push15=, 4
	i32.add 	$1=, $1, $pop15
	i32.const	$3=, 0
	i32.const	$push14=, 15
	i32.lt_s	$push6=, $2, $pop14
	br_if   	0, $pop6        # 0: up to label0
.LBB0_6:                                # %cleanup14
	end_loop                        # label1:
	return  	$3
	.endfunc
.Lfunc_end0:
	.size	inet_check_attr, .Lfunc_end0-inet_check_attr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push94=, __stack_pointer
	i32.load	$push95=, 0($pop94)
	i32.const	$push96=, 64
	i32.sub 	$4=, $pop95, $pop96
	i32.const	$push97=, __stack_pointer
	i32.store	$discard=, 0($pop97), $4
	i32.const	$push0=, 12
	i32.store16	$discard=, 56($4):p2align=3, $pop0
	i32.const	$push1=, 0
	i32.store16	$discard=, 58($4), $pop1
	i32.load	$push3=, 56($4):p2align=3
	i32.store	$discard=, 60($4), $pop3
	i32.const	$push101=, 56
	i32.add 	$push102=, $4, $pop101
	i32.store	$discard=, 0($4):p2align=4, $pop102
	i32.const	$push103=, 56
	i32.add 	$push104=, $4, $pop103
	i32.store	$discard=, 4($4), $pop104
	i32.const	$push105=, 56
	i32.add 	$push106=, $4, $pop105
	i32.store	$discard=, 8($4):p2align=3, $pop106
	i32.const	$push107=, 56
	i32.add 	$push108=, $4, $pop107
	i32.store	$discard=, 12($4), $pop108
	i32.const	$push109=, 56
	i32.add 	$push110=, $4, $pop109
	i32.store	$discard=, 16($4):p2align=4, $pop110
	i32.const	$push111=, 56
	i32.add 	$push112=, $4, $pop111
	i32.store	$discard=, 20($4), $pop112
	i32.const	$push113=, 56
	i32.add 	$push114=, $4, $pop113
	i32.store	$discard=, 24($4):p2align=3, $pop114
	i32.const	$push115=, 56
	i32.add 	$push116=, $4, $pop115
	i32.store	$discard=, 28($4), $pop116
	i32.const	$push117=, 56
	i32.add 	$push118=, $4, $pop117
	i32.store	$discard=, 32($4):p2align=4, $pop118
	i32.const	$push119=, 56
	i32.add 	$push120=, $4, $pop119
	i32.store	$discard=, 36($4), $pop120
	i32.const	$push121=, 56
	i32.add 	$push122=, $4, $pop121
	i32.store	$discard=, 40($4):p2align=3, $pop122
	i32.const	$push123=, 56
	i32.add 	$push124=, $4, $pop123
	i32.store	$discard=, 44($4), $pop124
	i32.const	$push125=, 56
	i32.add 	$push126=, $4, $pop125
	i32.store	$discard=, 48($4):p2align=4, $pop126
	i32.const	$push127=, 56
	i32.add 	$push128=, $4, $pop127
	i32.store	$discard=, 52($4), $pop128
	block
	block
	block
	i32.call	$push4=, inet_check_attr@FUNCTION, $0, $4
	br_if   	0, $pop4        # 0: down to label5
# BB#1:                                 # %for.body9.preheader
	i32.const	$push129=, 56
	i32.add 	$push130=, $4, $pop129
	copy_local	$1=, $pop130
	i32.load	$push18=, 0($4):p2align=4
	i32.const	$push131=, 56
	i32.add 	$push132=, $4, $pop131
	i32.const	$push2=, 4
	i32.or  	$push88=, $pop132, $pop2
	tee_local	$push87=, $0=, $pop88
	i32.ne  	$push39=, $pop18, $pop87
	br_if   	2, $pop39       # 2: down to label3
# BB#2:                                 # %for.body9.preheader
	i32.load	$push5=, 4($4)
	i32.ne  	$push40=, $pop5, $0
	br_if   	2, $pop40       # 2: down to label3
# BB#3:                                 # %for.body9.preheader
	i32.load	$push6=, 8($4):p2align=3
	i32.ne  	$push41=, $pop6, $0
	br_if   	2, $pop41       # 2: down to label3
# BB#4:                                 # %for.body9.preheader
	i32.load	$push7=, 12($4)
	i32.ne  	$push42=, $pop7, $0
	br_if   	2, $pop42       # 2: down to label3
# BB#5:                                 # %for.body9.preheader
	i32.const	$push19=, 16
	i32.add 	$push20=, $4, $pop19
	i32.load	$push8=, 0($pop20):p2align=4
	i32.ne  	$push43=, $pop8, $0
	br_if   	2, $pop43       # 2: down to label3
# BB#6:                                 # %for.body9.preheader
	i32.const	$push21=, 20
	i32.add 	$push22=, $4, $pop21
	i32.load	$push9=, 0($pop22)
	i32.ne  	$push44=, $pop9, $0
	br_if   	2, $pop44       # 2: down to label3
# BB#7:                                 # %for.body9.preheader
	i32.const	$push23=, 24
	i32.add 	$push24=, $4, $pop23
	i32.load	$push10=, 0($pop24):p2align=3
	i32.ne  	$push45=, $pop10, $0
	br_if   	2, $pop45       # 2: down to label3
# BB#8:                                 # %for.body9.preheader
	i32.const	$push25=, 28
	i32.add 	$push26=, $4, $pop25
	i32.load	$push11=, 0($pop26)
	i32.ne  	$push46=, $pop11, $1
	br_if   	2, $pop46       # 2: down to label3
# BB#9:                                 # %for.body9.preheader
	i32.const	$push27=, 32
	i32.add 	$push28=, $4, $pop27
	i32.load	$push12=, 0($pop28):p2align=4
	i32.ne  	$push47=, $pop12, $1
	br_if   	2, $pop47       # 2: down to label3
# BB#10:                                # %for.body9.preheader
	i32.const	$push29=, 36
	i32.add 	$push30=, $4, $pop29
	i32.load	$push13=, 0($pop30)
	i32.ne  	$push48=, $pop13, $0
	br_if   	2, $pop48       # 2: down to label3
# BB#11:                                # %for.body9.preheader
	i32.const	$push31=, 40
	i32.add 	$push32=, $4, $pop31
	i32.load	$push14=, 0($pop32):p2align=3
	i32.ne  	$push49=, $pop14, $0
	br_if   	2, $pop49       # 2: down to label3
# BB#12:                                # %for.body9.preheader
	i32.const	$push33=, 44
	i32.add 	$push34=, $4, $pop33
	i32.load	$push15=, 0($pop34)
	i32.ne  	$push50=, $pop15, $0
	br_if   	2, $pop50       # 2: down to label3
# BB#13:                                # %for.body9.preheader
	i32.const	$push35=, 48
	i32.add 	$push36=, $4, $pop35
	i32.load	$push16=, 0($pop36):p2align=4
	i32.ne  	$push51=, $pop16, $0
	br_if   	2, $pop51       # 2: down to label3
# BB#14:                                # %for.body9.preheader
	i32.const	$push37=, 52
	i32.add 	$push38=, $4, $pop37
	i32.load	$push17=, 0($pop38)
	i32.ne  	$push52=, $pop17, $0
	br_if   	2, $pop52       # 2: down to label3
# BB#15:                                # %for.cond7.13
	i32.const	$push53=, 16
	i32.add 	$push54=, $4, $pop53
	i32.const	$push133=, 56
	i32.add 	$push134=, $4, $pop133
	i32.store	$discard=, 0($pop54):p2align=4, $pop134
	i32.const	$push55=, 24
	i32.add 	$push56=, $4, $pop55
	i32.const	$push135=, 56
	i32.add 	$push136=, $4, $pop135
	i32.store	$discard=, 0($pop56):p2align=3, $pop136
	i32.const	$push57=, 28
	i32.add 	$push58=, $4, $pop57
	i32.const	$push137=, 56
	i32.add 	$push138=, $4, $pop137
	i32.store	$discard=, 0($pop58), $pop138
	i32.const	$push59=, 32
	i32.add 	$push60=, $4, $pop59
	i32.const	$push139=, 56
	i32.add 	$push140=, $4, $pop139
	i32.store	$discard=, 0($pop60):p2align=4, $pop140
	i32.const	$push61=, 36
	i32.add 	$push62=, $4, $pop61
	i32.const	$push141=, 56
	i32.add 	$push142=, $4, $pop141
	i32.store	$discard=, 0($pop62), $pop142
	i32.const	$push63=, 40
	i32.add 	$push64=, $4, $pop63
	i32.const	$push143=, 56
	i32.add 	$push144=, $4, $pop143
	i32.store	$discard=, 0($pop64):p2align=3, $pop144
	i32.const	$push65=, 44
	i32.add 	$push66=, $4, $pop65
	i32.const	$push145=, 56
	i32.add 	$push146=, $4, $pop145
	i32.store	$discard=, 0($pop66), $pop146
	i32.const	$push67=, 48
	i32.add 	$push68=, $4, $pop67
	i32.const	$push147=, 56
	i32.add 	$push148=, $4, $pop147
	i32.store	$discard=, 0($pop68):p2align=4, $pop148
	i32.load16_u	$1=, 60($4):p2align=2
	i32.const	$push69=, 52
	i32.add 	$push70=, $4, $pop69
	i32.const	$push149=, 56
	i32.add 	$push150=, $4, $pop149
	i32.store	$discard=, 0($pop70), $pop150
	i32.const	$push72=, 65528
	i32.add 	$push73=, $1, $pop72
	i32.store16	$discard=, 60($4):p2align=2, $pop73
	i32.const	$push74=, 20
	i32.add 	$push75=, $4, $pop74
	i32.store	$3=, 0($pop75), $0
	i32.const	$push151=, 56
	i32.add 	$push152=, $4, $pop151
	i32.store	$discard=, 0($4):p2align=4, $pop152
	i32.const	$push153=, 56
	i32.add 	$push154=, $4, $pop153
	i32.store	$discard=, 8($4):p2align=3, $pop154
	i32.const	$push155=, 56
	i32.add 	$push156=, $4, $pop155
	i32.store	$discard=, 12($4), $pop156
	i32.const	$push71=, 0
	i32.store	$0=, 4($4), $pop71
	i32.call	$push76=, inet_check_attr@FUNCTION, $0, $4
	i32.const	$push77=, -22
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	2, $pop78       # 2: down to label3
# BB#16:                                # %for.body43.preheader
	i32.load	$2=, 4($4)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	block
	i32.const	$push89=, 1
	i32.ne  	$push79=, $0, $pop89
	br_if   	0, $pop79       # 0: down to label9
# BB#18:                                # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$0=, 2
	i32.const	$push159=, 0
	i32.eq  	$push160=, $2, $pop159
	br_if   	1, $pop160      # 1: up to label7
	br      	3               # 3: down to label6
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label9:
	i32.const	$push91=, 2
	i32.shl 	$push80=, $0, $pop91
	i32.add 	$push81=, $4, $pop80
	i32.load	$1=, 0($pop81)
	block
	block
	i32.const	$push90=, 5
	i32.gt_s	$push82=, $0, $pop90
	br_if   	0, $pop82       # 0: down to label11
# BB#20:                                # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push84=, $1, $3
	br_if   	1, $pop84       # 1: down to label10
	br      	6               # 6: down to label4
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label11:
	i32.const	$push157=, 56
	i32.add 	$push158=, $4, $pop157
	i32.ne  	$push83=, $1, $pop158
	br_if   	4, $pop83       # 4: down to label5
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label10:
	i32.const	$push93=, 1
	i32.add 	$0=, $0, $pop93
	i32.const	$push92=, 14
	i32.lt_s	$push85=, $0, $pop92
	br_if   	0, $pop85       # 0: up to label7
# BB#23:                                # %for.end75
	end_loop                        # label8:
	i32.const	$push86=, 0
	i32.const	$push100=, __stack_pointer
	i32.const	$push98=, 64
	i32.add 	$push99=, $4, $pop98
	i32.store	$discard=, 0($pop100), $pop99
	return  	$pop86
.LBB1_24:                               # %if.then49
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then69
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then60
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then38
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
