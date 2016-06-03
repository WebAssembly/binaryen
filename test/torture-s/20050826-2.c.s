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
	i32.const	$3=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	block
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $2=, $pop8
	i32.eqz 	$push19=, $pop7
	br_if   	0, $pop19       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$4=, -22
	i32.load16_u	$push0=, 0($2)
	i32.const	$push10=, 65532
	i32.and 	$push1=, $pop0, $pop10
	i32.const	$push9=, 4
	i32.eq  	$push2=, $pop1, $pop9
	br_if   	2, $pop2        # 2: down to label1
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, -2
	i32.and 	$push3=, $3, $pop12
	i32.const	$push11=, 8
	i32.eq  	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label2
# BB#4:                                 # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 4
	i32.add 	$push5=, $2, $pop13
	i32.store	$drop=, 0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push18=, 4
	i32.add 	$1=, $1, $pop18
	i32.const	$4=, 0
	i32.const	$push17=, 1
	i32.add 	$push16=, $3, $pop17
	tee_local	$push15=, $3=, $pop16
	i32.const	$push14=, 15
	i32.lt_s	$push6=, $pop15, $pop14
	br_if   	0, $pop6        # 0: up to label0
.LBB0_6:                                # %cleanup14
	end_loop                        # label1:
	copy_local	$push20=, $4
                                        # fallthrough-return: $pop20
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
	i32.const	$push88=, 0
	i32.const	$push85=, 0
	i32.load	$push86=, __stack_pointer($pop85)
	i32.const	$push87=, 64
	i32.sub 	$push150=, $pop86, $pop87
	i32.store	$push152=, __stack_pointer($pop88), $pop150
	tee_local	$push151=, $1=, $pop152
	i64.const	$push0=, 51539607564
	i64.store	$drop=, 56($pop151), $pop0
	i32.const	$push92=, 56
	i32.add 	$push93=, $1, $pop92
	i32.store	$drop=, 4($1), $pop93
	i32.const	$push94=, 56
	i32.add 	$push95=, $1, $pop94
	i32.store	$drop=, 8($1), $pop95
	i32.const	$push96=, 56
	i32.add 	$push97=, $1, $pop96
	i32.store	$drop=, 12($1), $pop97
	i32.const	$push98=, 56
	i32.add 	$push99=, $1, $pop98
	i32.store	$drop=, 16($1), $pop99
	i32.const	$push100=, 56
	i32.add 	$push101=, $1, $pop100
	i32.store	$drop=, 0($1), $pop101
	i32.const	$push102=, 56
	i32.add 	$push103=, $1, $pop102
	i32.store	$drop=, 20($1), $pop103
	i32.const	$push104=, 56
	i32.add 	$push105=, $1, $pop104
	i32.store	$drop=, 24($1), $pop105
	i32.const	$push106=, 56
	i32.add 	$push107=, $1, $pop106
	i32.store	$drop=, 28($1), $pop107
	i32.const	$push108=, 56
	i32.add 	$push109=, $1, $pop108
	i32.store	$drop=, 32($1), $pop109
	i32.const	$push110=, 56
	i32.add 	$push111=, $1, $pop110
	i32.store	$drop=, 36($1), $pop111
	i32.const	$push112=, 56
	i32.add 	$push113=, $1, $pop112
	i32.store	$drop=, 40($1), $pop113
	i32.const	$push114=, 56
	i32.add 	$push115=, $1, $pop114
	i32.store	$drop=, 44($1), $pop115
	i32.const	$push116=, 56
	i32.add 	$push117=, $1, $pop116
	i32.store	$drop=, 48($1), $pop117
	i32.const	$push118=, 56
	i32.add 	$push119=, $1, $pop118
	i32.store	$drop=, 52($1), $pop119
	block
	block
	block
	i32.call	$push2=, inet_check_attr@FUNCTION, $2, $1
	br_if   	0, $pop2        # 0: down to label5
# BB#1:                                 # %for.body9.preheader
	i32.load	$push16=, 0($1)
	i32.const	$push120=, 56
	i32.add 	$push121=, $1, $pop120
	i32.const	$push1=, 4
	i32.or  	$push154=, $pop121, $pop1
	tee_local	$push153=, $3=, $pop154
	i32.ne  	$push17=, $pop16, $pop153
	br_if   	2, $pop17       # 2: down to label3
# BB#2:                                 # %for.body9.preheader
	i32.load	$push3=, 4($1)
	i32.ne  	$push38=, $pop3, $3
	br_if   	2, $pop38       # 2: down to label3
# BB#3:                                 # %for.body9.preheader
	i32.load	$push4=, 8($1)
	i32.ne  	$push39=, $pop4, $3
	br_if   	2, $pop39       # 2: down to label3
# BB#4:                                 # %for.body9.preheader
	i32.load	$push5=, 12($1)
	i32.ne  	$push40=, $pop5, $3
	br_if   	2, $pop40       # 2: down to label3
# BB#5:                                 # %for.body9.preheader
	i32.const	$push36=, 16
	i32.add 	$push37=, $1, $pop36
	i32.load	$push6=, 0($pop37)
	i32.ne  	$push41=, $pop6, $3
	br_if   	2, $pop41       # 2: down to label3
# BB#6:                                 # %for.body9.preheader
	i32.const	$push34=, 20
	i32.add 	$push35=, $1, $pop34
	i32.load	$push7=, 0($pop35)
	i32.ne  	$push42=, $pop7, $3
	br_if   	2, $pop42       # 2: down to label3
# BB#7:                                 # %for.body9.preheader
	i32.const	$push32=, 24
	i32.add 	$push33=, $1, $pop32
	i32.load	$push8=, 0($pop33)
	i32.ne  	$push43=, $pop8, $3
	br_if   	2, $pop43       # 2: down to label3
# BB#8:                                 # %for.body9.preheader
	i32.const	$push30=, 28
	i32.add 	$push31=, $1, $pop30
	i32.load	$push9=, 0($pop31)
	i32.const	$push122=, 56
	i32.add 	$push123=, $1, $pop122
	copy_local	$push156=, $pop123
	tee_local	$push155=, $2=, $pop156
	i32.ne  	$push44=, $pop9, $pop155
	br_if   	2, $pop44       # 2: down to label3
# BB#9:                                 # %for.body9.preheader
	i32.const	$push28=, 32
	i32.add 	$push29=, $1, $pop28
	i32.load	$push10=, 0($pop29)
	i32.ne  	$push45=, $pop10, $2
	br_if   	2, $pop45       # 2: down to label3
# BB#10:                                # %for.body9.preheader
	i32.const	$push26=, 36
	i32.add 	$push27=, $1, $pop26
	i32.load	$push11=, 0($pop27)
	i32.ne  	$push46=, $pop11, $3
	br_if   	2, $pop46       # 2: down to label3
# BB#11:                                # %for.body9.preheader
	i32.const	$push24=, 40
	i32.add 	$push25=, $1, $pop24
	i32.load	$push12=, 0($pop25)
	i32.ne  	$push47=, $pop12, $3
	br_if   	2, $pop47       # 2: down to label3
# BB#12:                                # %for.body9.preheader
	i32.const	$push22=, 44
	i32.add 	$push23=, $1, $pop22
	i32.load	$push13=, 0($pop23)
	i32.ne  	$push48=, $pop13, $3
	br_if   	2, $pop48       # 2: down to label3
# BB#13:                                # %for.body9.preheader
	i32.const	$push20=, 48
	i32.add 	$push21=, $1, $pop20
	i32.load	$push14=, 0($pop21)
	i32.ne  	$push49=, $pop14, $3
	br_if   	2, $pop49       # 2: down to label3
# BB#14:                                # %for.body9.preheader
	i32.const	$push18=, 52
	i32.add 	$push19=, $1, $pop18
	i32.load	$push15=, 0($pop19)
	i32.ne  	$push50=, $pop15, $3
	br_if   	2, $pop50       # 2: down to label3
# BB#15:                                # %for.cond7.13
	i32.const	$push51=, 16
	i32.add 	$push52=, $1, $pop51
	i32.const	$push124=, 56
	i32.add 	$push125=, $1, $pop124
	i32.store	$drop=, 0($pop52), $pop125
	i32.const	$push53=, 24
	i32.add 	$push54=, $1, $pop53
	i32.const	$push126=, 56
	i32.add 	$push127=, $1, $pop126
	i32.store	$drop=, 0($pop54), $pop127
	i32.const	$push55=, 28
	i32.add 	$push56=, $1, $pop55
	i32.const	$push128=, 56
	i32.add 	$push129=, $1, $pop128
	i32.store	$drop=, 0($pop56), $pop129
	i32.const	$push57=, 32
	i32.add 	$push58=, $1, $pop57
	i32.const	$push130=, 56
	i32.add 	$push131=, $1, $pop130
	i32.store	$drop=, 0($pop58), $pop131
	i32.const	$push132=, 56
	i32.add 	$push133=, $1, $pop132
	i32.store	$drop=, 8($1), $pop133
	i32.const	$push134=, 56
	i32.add 	$push135=, $1, $pop134
	i32.store	$drop=, 0($1), $pop135
	i32.const	$push136=, 56
	i32.add 	$push137=, $1, $pop136
	i32.store	$drop=, 12($1), $pop137
	i32.const	$push59=, 36
	i32.add 	$push60=, $1, $pop59
	i32.const	$push138=, 56
	i32.add 	$push139=, $1, $pop138
	i32.store	$drop=, 0($pop60), $pop139
	i32.const	$push61=, 40
	i32.add 	$push62=, $1, $pop61
	i32.const	$push140=, 56
	i32.add 	$push141=, $1, $pop140
	i32.store	$drop=, 0($pop62), $pop141
	i32.const	$push63=, 44
	i32.add 	$push64=, $1, $pop63
	i32.const	$push142=, 56
	i32.add 	$push143=, $1, $pop142
	i32.store	$drop=, 0($pop64), $pop143
	i32.const	$push65=, 48
	i32.add 	$push66=, $1, $pop65
	i32.const	$push144=, 56
	i32.add 	$push145=, $1, $pop144
	i32.store	$drop=, 0($pop66), $pop145
	i32.const	$push67=, 52
	i32.add 	$push68=, $1, $pop67
	i32.const	$push146=, 56
	i32.add 	$push147=, $1, $pop146
	i32.store	$drop=, 0($pop68), $pop147
	i32.const	$2=, 0
	i32.const	$push157=, 0
	i32.store	$drop=, 4($1), $pop157
	i32.load16_u	$push70=, 60($1)
	i32.const	$push69=, 65528
	i32.add 	$push71=, $pop70, $pop69
	i32.store16	$drop=, 60($1), $pop71
	i32.const	$push72=, 20
	i32.add 	$push73=, $1, $pop72
	i32.store	$0=, 0($pop73), $3
	i32.call	$push74=, inet_check_attr@FUNCTION, $2, $1
	i32.const	$push75=, -22
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	2, $pop76       # 2: down to label3
# BB#16:                                # %for.body43.preheader
	i32.load	$4=, 4($1)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label7:
	block
	i32.const	$push158=, 1
	i32.ne  	$push77=, $2, $pop158
	br_if   	0, $pop77       # 0: down to label9
# BB#18:                                # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$2=, 2
	i32.eqz 	$push165=, $4
	br_if   	1, $pop165      # 1: up to label7
	br      	3               # 3: down to label6
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label9:
	i32.const	$push160=, 2
	i32.shl 	$push79=, $2, $pop160
	i32.add 	$push80=, $1, $pop79
	i32.load	$3=, 0($pop80)
	block
	block
	i32.const	$push159=, 5
	i32.gt_s	$push78=, $2, $pop159
	br_if   	0, $pop78       # 0: down to label11
# BB#20:                                # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push82=, $3, $0
	br_if   	1, $pop82       # 1: down to label10
	br      	6               # 6: down to label4
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label11:
	i32.const	$push148=, 56
	i32.add 	$push149=, $1, $pop148
	i32.ne  	$push81=, $3, $pop149
	br_if   	4, $pop81       # 4: down to label5
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label10:
	i32.const	$push164=, 1
	i32.add 	$push163=, $2, $pop164
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 14
	i32.lt_s	$push83=, $pop162, $pop161
	br_if   	0, $pop83       # 0: up to label7
# BB#23:                                # %for.end75
	end_loop                        # label8:
	i32.const	$push91=, 0
	i32.const	$push89=, 64
	i32.add 	$push90=, $1, $pop89
	i32.store	$drop=, __stack_pointer($pop91), $pop90
	i32.const	$push84=, 0
	return  	$pop84
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
	.functype	abort, void
