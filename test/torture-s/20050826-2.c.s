	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050826-2.c"
	.section	.text.inet_check_attr,"ax",@progbits
	.hidden	inet_check_attr
	.globl	inet_check_attr
	.type	inet_check_attr,@function
inet_check_attr:                        # @inet_check_attr
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	block   	
	i32.load	$push10=, 0($1)
	tee_local	$push9=, $2=, $pop10
	i32.eqz 	$push21=, $pop9
	br_if   	0, $pop21       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load16_u	$push0=, 0($2)
	i32.const	$push12=, 65532
	i32.and 	$push1=, $pop0, $pop12
	i32.const	$push11=, 4
	i32.eq  	$push2=, $pop1, $pop11
	br_if   	2, $pop2        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push14=, -2
	i32.and 	$push3=, $3, $pop14
	i32.const	$push13=, 8
	i32.eq  	$push4=, $pop3, $pop13
	br_if   	0, $pop4        # 0: down to label2
# BB#4:                                 # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push15=, 4
	i32.add 	$push5=, $2, $pop15
	i32.store	0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push20=, 4
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, 1
	i32.add 	$push18=, $3, $pop19
	tee_local	$push17=, $3=, $pop18
	i32.const	$push16=, 15
	i32.lt_s	$push6=, $pop17, $pop16
	br_if   	0, $pop6        # 0: up to label1
# BB#6:
	end_loop
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_7:
	end_block                       # label0:
	i32.const	$push8=, -22
                                        # fallthrough-return: $pop8
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
	i32.sub 	$push151=, $pop86, $pop87
	tee_local	$push150=, $4=, $pop151
	i32.store	__stack_pointer($pop88), $pop150
	i64.const	$push0=, 51539607564
	i64.store	56($4), $pop0
	i32.const	$push92=, 56
	i32.add 	$push93=, $4, $pop92
	i32.store	4($4), $pop93
	i32.const	$push94=, 56
	i32.add 	$push95=, $4, $pop94
	i32.store	8($4), $pop95
	i32.const	$push96=, 56
	i32.add 	$push97=, $4, $pop96
	i32.store	12($4), $pop97
	i32.const	$push98=, 56
	i32.add 	$push99=, $4, $pop98
	i32.store	16($4), $pop99
	i32.const	$push100=, 56
	i32.add 	$push101=, $4, $pop100
	i32.store	0($4), $pop101
	i32.const	$push102=, 56
	i32.add 	$push103=, $4, $pop102
	i32.store	20($4), $pop103
	i32.const	$push104=, 56
	i32.add 	$push105=, $4, $pop104
	i32.store	24($4), $pop105
	i32.const	$push106=, 56
	i32.add 	$push107=, $4, $pop106
	i32.store	28($4), $pop107
	i32.const	$push108=, 56
	i32.add 	$push109=, $4, $pop108
	i32.store	32($4), $pop109
	i32.const	$push110=, 56
	i32.add 	$push111=, $4, $pop110
	i32.store	36($4), $pop111
	i32.const	$push112=, 56
	i32.add 	$push113=, $4, $pop112
	i32.store	40($4), $pop113
	i32.const	$push114=, 56
	i32.add 	$push115=, $4, $pop114
	i32.store	44($4), $pop115
	i32.const	$push116=, 56
	i32.add 	$push117=, $4, $pop116
	i32.store	48($4), $pop117
	i32.const	$push118=, 56
	i32.add 	$push119=, $4, $pop118
	i32.store	52($4), $pop119
	block   	
	block   	
	block   	
	i32.call	$push2=, inet_check_attr@FUNCTION, $1, $4
	br_if   	0, $pop2        # 0: down to label5
# BB#1:                                 # %for.body9.preheader
	i32.load	$push16=, 0($4)
	i32.const	$push120=, 56
	i32.add 	$push121=, $4, $pop120
	i32.const	$push1=, 4
	i32.or  	$push153=, $pop121, $pop1
	tee_local	$push152=, $0=, $pop153
	i32.ne  	$push17=, $pop16, $pop152
	br_if   	2, $pop17       # 2: down to label3
# BB#2:                                 # %for.body9.preheader
	i32.load	$push3=, 4($4)
	i32.ne  	$push38=, $pop3, $0
	br_if   	2, $pop38       # 2: down to label3
# BB#3:                                 # %for.body9.preheader
	i32.load	$push4=, 8($4)
	i32.ne  	$push39=, $pop4, $0
	br_if   	2, $pop39       # 2: down to label3
# BB#4:                                 # %for.body9.preheader
	i32.load	$push5=, 12($4)
	i32.ne  	$push40=, $pop5, $0
	br_if   	2, $pop40       # 2: down to label3
# BB#5:                                 # %for.body9.preheader
	i32.const	$push36=, 16
	i32.add 	$push37=, $4, $pop36
	i32.load	$push6=, 0($pop37)
	i32.ne  	$push41=, $pop6, $0
	br_if   	2, $pop41       # 2: down to label3
# BB#6:                                 # %for.body9.preheader
	i32.const	$push34=, 20
	i32.add 	$push35=, $4, $pop34
	i32.load	$push7=, 0($pop35)
	i32.ne  	$push42=, $pop7, $0
	br_if   	2, $pop42       # 2: down to label3
# BB#7:                                 # %for.body9.preheader
	i32.const	$push32=, 24
	i32.add 	$push33=, $4, $pop32
	i32.load	$push8=, 0($pop33)
	i32.ne  	$push43=, $pop8, $0
	br_if   	2, $pop43       # 2: down to label3
# BB#8:                                 # %for.body9.preheader
	i32.const	$push30=, 28
	i32.add 	$push31=, $4, $pop30
	i32.load	$push9=, 0($pop31)
	i32.const	$push122=, 56
	i32.add 	$push123=, $4, $pop122
	copy_local	$push155=, $pop123
	tee_local	$push154=, $1=, $pop155
	i32.ne  	$push44=, $pop9, $pop154
	br_if   	2, $pop44       # 2: down to label3
# BB#9:                                 # %for.body9.preheader
	i32.const	$push28=, 32
	i32.add 	$push29=, $4, $pop28
	i32.load	$push10=, 0($pop29)
	i32.ne  	$push45=, $pop10, $1
	br_if   	2, $pop45       # 2: down to label3
# BB#10:                                # %for.body9.preheader
	i32.const	$push26=, 36
	i32.add 	$push27=, $4, $pop26
	i32.load	$push11=, 0($pop27)
	i32.ne  	$push46=, $pop11, $0
	br_if   	2, $pop46       # 2: down to label3
# BB#11:                                # %for.body9.preheader
	i32.const	$push24=, 40
	i32.add 	$push25=, $4, $pop24
	i32.load	$push12=, 0($pop25)
	i32.ne  	$push47=, $pop12, $0
	br_if   	2, $pop47       # 2: down to label3
# BB#12:                                # %for.body9.preheader
	i32.const	$push22=, 44
	i32.add 	$push23=, $4, $pop22
	i32.load	$push13=, 0($pop23)
	i32.ne  	$push48=, $pop13, $0
	br_if   	2, $pop48       # 2: down to label3
# BB#13:                                # %for.body9.preheader
	i32.const	$push20=, 48
	i32.add 	$push21=, $4, $pop20
	i32.load	$push14=, 0($pop21)
	i32.ne  	$push49=, $pop14, $0
	br_if   	2, $pop49       # 2: down to label3
# BB#14:                                # %for.body9.preheader
	i32.const	$push18=, 52
	i32.add 	$push19=, $4, $pop18
	i32.load	$push15=, 0($pop19)
	i32.ne  	$push50=, $pop15, $0
	br_if   	2, $pop50       # 2: down to label3
# BB#15:                                # %for.cond7.13
	i32.const	$push51=, 16
	i32.add 	$push52=, $4, $pop51
	i32.const	$push124=, 56
	i32.add 	$push125=, $4, $pop124
	i32.store	0($pop52), $pop125
	i32.const	$push53=, 24
	i32.add 	$push54=, $4, $pop53
	i32.const	$push126=, 56
	i32.add 	$push127=, $4, $pop126
	i32.store	0($pop54), $pop127
	i32.const	$push55=, 28
	i32.add 	$push56=, $4, $pop55
	i32.const	$push128=, 56
	i32.add 	$push129=, $4, $pop128
	i32.store	0($pop56), $pop129
	i32.const	$push57=, 32
	i32.add 	$push58=, $4, $pop57
	i32.const	$push130=, 56
	i32.add 	$push131=, $4, $pop130
	i32.store	0($pop58), $pop131
	i32.const	$push132=, 56
	i32.add 	$push133=, $4, $pop132
	i32.store	8($4), $pop133
	i32.const	$push134=, 56
	i32.add 	$push135=, $4, $pop134
	i32.store	0($4), $pop135
	i32.const	$push136=, 56
	i32.add 	$push137=, $4, $pop136
	i32.store	12($4), $pop137
	i32.const	$push59=, 36
	i32.add 	$push60=, $4, $pop59
	i32.const	$push138=, 56
	i32.add 	$push139=, $4, $pop138
	i32.store	0($pop60), $pop139
	i32.const	$push61=, 40
	i32.add 	$push62=, $4, $pop61
	i32.const	$push140=, 56
	i32.add 	$push141=, $4, $pop140
	i32.store	0($pop62), $pop141
	i32.const	$push63=, 44
	i32.add 	$push64=, $4, $pop63
	i32.const	$push142=, 56
	i32.add 	$push143=, $4, $pop142
	i32.store	0($pop64), $pop143
	i32.const	$push65=, 48
	i32.add 	$push66=, $4, $pop65
	i32.const	$push144=, 56
	i32.add 	$push145=, $4, $pop144
	i32.store	0($pop66), $pop145
	i32.const	$push67=, 52
	i32.add 	$push68=, $4, $pop67
	i32.const	$push146=, 56
	i32.add 	$push147=, $4, $pop146
	i32.store	0($pop68), $pop147
	i32.const	$1=, 0
	i32.const	$push156=, 0
	i32.store	4($4), $pop156
	i32.load16_u	$push70=, 60($4)
	i32.const	$push69=, 65528
	i32.add 	$push71=, $pop70, $pop69
	i32.store16	60($4), $pop71
	i32.const	$push72=, 20
	i32.add 	$push73=, $4, $pop72
	i32.store	0($pop73), $0
	i32.call	$push74=, inet_check_attr@FUNCTION, $1, $4
	i32.const	$push75=, -22
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	2, $pop76       # 2: down to label3
# BB#16:                                # %for.body43.preheader
	i32.load	$3=, 4($4)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label7:
	block   	
	i32.const	$push157=, 1
	i32.ne  	$push77=, $1, $pop157
	br_if   	0, $pop77       # 0: down to label8
# BB#18:                                # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.const	$1=, 2
	i32.eqz 	$push164=, $3
	br_if   	1, $pop164      # 1: up to label7
	br      	2               # 2: down to label6
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label8:
	i32.const	$push159=, 2
	i32.shl 	$push79=, $1, $pop159
	i32.add 	$push80=, $4, $pop79
	i32.load	$2=, 0($pop80)
	block   	
	block   	
	i32.const	$push158=, 5
	i32.gt_s	$push78=, $1, $pop158
	br_if   	0, $pop78       # 0: down to label10
# BB#20:                                # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push82=, $2, $0
	br_if   	1, $pop82       # 1: down to label9
	br      	5               # 5: down to label4
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label10:
	i32.const	$push148=, 56
	i32.add 	$push149=, $4, $pop148
	i32.ne  	$push81=, $2, $pop149
	br_if   	3, $pop81       # 3: down to label5
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label9:
	i32.const	$push163=, 1
	i32.add 	$push162=, $1, $pop163
	tee_local	$push161=, $1=, $pop162
	i32.const	$push160=, 14
	i32.lt_s	$push83=, $pop161, $pop160
	br_if   	0, $pop83       # 0: up to label7
# BB#23:                                # %for.end75
	end_loop
	i32.const	$push91=, 0
	i32.const	$push89=, 64
	i32.add 	$push90=, $4, $pop89
	i32.store	__stack_pointer($pop91), $pop90
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
