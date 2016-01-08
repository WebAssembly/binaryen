	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-2.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1633771873
	i32.store	$discard=, u($0), $pop0
	i32.const	$push1=, 24929
	i32.store16	$discard=, u+4($0), $pop1
	i32.const	$push2=, 97
	i32.store8	$push3=, u+6($0), $pop2
	i32.store8	$push4=, u+7($0), $pop3
	i32.store8	$push5=, u+8($0), $pop4
	i32.store8	$push6=, u+9($0), $pop5
	i32.store8	$push7=, u+10($0), $pop6
	i32.store8	$push8=, u+11($0), $pop7
	i32.store8	$push9=, u+12($0), $pop8
	i32.store8	$push10=, u+13($0), $pop9
	i32.store8	$push11=, u+14($0), $pop10
	i32.store8	$push12=, u+15($0), $pop11
	i32.store8	$push13=, u+16($0), $pop12
	i32.store8	$push14=, u+17($0), $pop13
	i32.store8	$push15=, u+18($0), $pop14
	i32.store8	$push16=, u+19($0), $pop15
	i32.store8	$push17=, u+20($0), $pop16
	i32.store8	$push18=, u+21($0), $pop17
	i32.store8	$push19=, u+22($0), $pop18
	i32.store8	$push20=, u+23($0), $pop19
	i32.store8	$push21=, u+24($0), $pop20
	i32.store8	$push22=, u+25($0), $pop21
	i32.store8	$push23=, u+26($0), $pop22
	i32.store8	$push24=, u+27($0), $pop23
	i32.store8	$push25=, u+28($0), $pop24
	i32.store8	$push26=, u+29($0), $pop25
	i32.store8	$discard=, u+30($0), $pop26
	return
.Lfunc_end0:
	.size	reset, .Lfunc_end0-reset

	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$3=, u
	block   	.LBB1_4
	i32.le_s	$push0=, $0, $4
	br_if   	$pop0, .LBB1_4
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.const	$3=, u
	i32.add 	$push1=, $3, $4
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push3=, 97
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB1_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push5=, 1
	i32.add 	$4=, $4, $pop5
	i32.add 	$3=, $3, $4
	i32.lt_s	$push6=, $4, $0
	br_if   	$pop6, .LBB1_1
	br      	.LBB1_4
.LBB1_3:                                # %if.then
	call    	abort
	unreachable
.LBB1_4:                                # %for.cond3.preheader
	i32.const	$4=, 0
	copy_local	$0=, $3
	block   	.LBB1_8
	i32.le_s	$push7=, $1, $4
	br_if   	$pop7, .LBB1_8
.LBB1_5:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_7
	i32.add 	$push8=, $3, $4
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	$pop10, .LBB1_7
# BB#6:                                 # %for.inc12
                                        #   in Loop: Header=BB1_5 Depth=1
	i32.const	$push11=, 1
	i32.add 	$4=, $4, $pop11
	i32.add 	$0=, $3, $4
	i32.lt_s	$push12=, $4, $1
	br_if   	$pop12, .LBB1_5
	br      	.LBB1_8
.LBB1_7:                                # %if.then10
	call    	abort
	unreachable
.LBB1_8:                                # %for.body19.preheader
	i32.const	$4=, 97
	block   	.LBB1_17
	i32.load8_u	$push13=, 0($0)
	i32.ne  	$push14=, $pop13, $4
	br_if   	$pop14, .LBB1_17
# BB#9:                                 # %for.inc25
	i32.load8_u	$push15=, 1($0)
	i32.ne  	$push16=, $pop15, $4
	br_if   	$pop16, .LBB1_17
# BB#10:                                # %for.inc25.1
	i32.load8_u	$push17=, 2($0)
	i32.ne  	$push18=, $pop17, $4
	br_if   	$pop18, .LBB1_17
# BB#11:                                # %for.inc25.2
	i32.load8_u	$push19=, 3($0)
	i32.ne  	$push20=, $pop19, $4
	br_if   	$pop20, .LBB1_17
# BB#12:                                # %for.inc25.3
	i32.load8_u	$push21=, 4($0)
	i32.ne  	$push22=, $pop21, $4
	br_if   	$pop22, .LBB1_17
# BB#13:                                # %for.inc25.4
	i32.load8_u	$push23=, 5($0)
	i32.ne  	$push24=, $pop23, $4
	br_if   	$pop24, .LBB1_17
# BB#14:                                # %for.inc25.5
	i32.load8_u	$push25=, 6($0)
	i32.ne  	$push26=, $pop25, $4
	br_if   	$pop26, .LBB1_17
# BB#15:                                # %for.inc25.6
	i32.load8_u	$push27=, 7($0)
	i32.ne  	$push28=, $pop27, $4
	br_if   	$pop28, .LBB1_17
# BB#16:                                # %for.inc25.7
	return
.LBB1_17:                               # %if.then23
	call    	abort
	unreachable
.Lfunc_end1:
	.size	check, .Lfunc_end1-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$27=, 0
	copy_local	$25=, $27
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_2
	i32.const	$push0=, 1633771873
	i32.store	$22=, u($27), $pop0
	i32.const	$push1=, 24929
	i32.store16	$9=, u+4($27), $pop1
	i32.const	$push2=, 97
	i32.store8	$push3=, u+6($27), $pop2
	i32.store8	$push4=, u+7($27), $pop3
	i32.store8	$push5=, u+8($27), $pop4
	i32.store8	$push6=, u+9($27), $pop5
	i32.store8	$push7=, u+10($27), $pop6
	i32.store8	$push8=, u+11($27), $pop7
	i32.store8	$push9=, u+12($27), $pop8
	i32.store8	$push10=, u+13($27), $pop9
	i32.store8	$push11=, u+14($27), $pop10
	i32.store8	$push12=, u+15($27), $pop11
	i32.store8	$push13=, u+16($27), $pop12
	i32.store8	$push14=, u+17($27), $pop13
	i32.store8	$push15=, u+18($27), $pop14
	i32.store8	$push16=, u+19($27), $pop15
	i32.store8	$push17=, u+20($27), $pop16
	i32.store8	$push18=, u+21($27), $pop17
	i32.store8	$push19=, u+22($27), $pop18
	i32.store8	$push20=, u+23($27), $pop19
	i32.store8	$push21=, u+24($27), $pop20
	i32.store8	$push22=, u+25($27), $pop21
	i32.store8	$push23=, u+26($27), $pop22
	i32.store8	$push24=, u+27($27), $pop23
	i32.store8	$push25=, u+28($27), $pop24
	i32.store8	$push26=, u+29($27), $pop25
	i32.store8	$13=, u+30($27), $pop26
	i32.const	$0=, u
	i32.add 	$24=, $0, $25
	i32.store8	$17=, 0($24), $27
	i32.const	$1=, 1
	call    	check, $25, $1, $17
	i32.const	$2=, 65
	i32.load8_u	$push27=, A($17)
	i32.store8	$discard=, 0($24), $pop27
	call    	check, $25, $1, $2
	i32.const	$push28=, 66
	i32.store8	$21=, 0($24), $pop28
	call    	check, $25, $1, $21
	i32.add 	$25=, $25, $1
	i32.const	$3=, 8
	copy_local	$24=, $17
	i32.ne  	$push29=, $25, $3
	br_if   	$pop29, .LBB2_1
.LBB2_2:                                # %for.body18
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_3
	i32.store8	$push30=, u+6($17), $13
	i32.store8	$push31=, u+7($17), $pop30
	i32.store8	$push32=, u+8($17), $pop31
	i32.store8	$push33=, u+9($17), $pop32
	i32.store8	$push34=, u+10($17), $pop33
	i32.store8	$push35=, u+11($17), $pop34
	i32.store8	$push36=, u+12($17), $pop35
	i32.store8	$push37=, u+13($17), $pop36
	i32.store8	$push38=, u+14($17), $pop37
	i32.store8	$push39=, u+15($17), $pop38
	i32.store8	$push40=, u+16($17), $pop39
	i32.store8	$push41=, u+17($17), $pop40
	i32.store8	$push42=, u+18($17), $pop41
	i32.store8	$push43=, u+19($17), $pop42
	i32.store8	$push44=, u+20($17), $pop43
	i32.store8	$push45=, u+21($17), $pop44
	i32.store8	$push46=, u+22($17), $pop45
	i32.store8	$push47=, u+23($17), $pop46
	i32.store8	$push48=, u+24($17), $pop47
	i32.store8	$push49=, u+25($17), $pop48
	i32.store8	$push50=, u+26($17), $pop49
	i32.store8	$push51=, u+27($17), $pop50
	i32.store8	$push52=, u+28($17), $pop51
	i32.store8	$push53=, u+29($17), $pop52
	i32.store8	$8=, u+30($17), $pop53
	i32.store	$11=, u($17), $22
	i32.store16	$12=, u+4($17), $9
	i32.add 	$18=, $0, $24
	i32.add 	$23=, $18, $1
	i32.store8	$push54=, 0($23), $17
	i32.store8	$27=, 0($18), $pop54
	i32.const	$25=, 2
	call    	check, $24, $25, $27
	i32.load8_u	$push55=, A($27)
	i32.store8	$push56=, 0($23), $pop55
	i32.store8	$discard=, 0($18), $pop56
	call    	check, $24, $25, $2
	i32.store8	$push57=, 0($23), $21
	i32.store8	$26=, 0($18), $pop57
	call    	check, $24, $25, $26
	i32.add 	$24=, $24, $1
	copy_local	$18=, $27
	i32.ne  	$push58=, $24, $3
	br_if   	$pop58, .LBB2_2
.LBB2_3:                                # %for.body44
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_4
	i32.store8	$push59=, u+6($27), $8
	i32.store8	$push60=, u+7($27), $pop59
	i32.store8	$push61=, u+8($27), $pop60
	i32.store8	$push62=, u+9($27), $pop61
	i32.store8	$push63=, u+10($27), $pop62
	i32.store8	$push64=, u+11($27), $pop63
	i32.store8	$push65=, u+12($27), $pop64
	i32.store8	$push66=, u+13($27), $pop65
	i32.store8	$push67=, u+14($27), $pop66
	i32.store8	$push68=, u+15($27), $pop67
	i32.store8	$push69=, u+16($27), $pop68
	i32.store8	$push70=, u+17($27), $pop69
	i32.store8	$push71=, u+18($27), $pop70
	i32.store8	$push72=, u+19($27), $pop71
	i32.store8	$push73=, u+20($27), $pop72
	i32.store8	$push74=, u+21($27), $pop73
	i32.store8	$push75=, u+22($27), $pop74
	i32.store8	$push76=, u+23($27), $pop75
	i32.store8	$push77=, u+24($27), $pop76
	i32.store8	$push78=, u+25($27), $pop77
	i32.store8	$push79=, u+26($27), $pop78
	i32.store8	$push80=, u+27($27), $pop79
	i32.store8	$push81=, u+28($27), $pop80
	i32.store8	$push82=, u+29($27), $pop81
	i32.store8	$15=, u+30($27), $pop82
	i32.store	$16=, u($27), $11
	i32.store16	$20=, u+4($27), $12
	i32.add 	$24=, $0, $18
	i32.add 	$21=, $24, $25
	i32.store8	$17=, 0($21), $27
	i32.add 	$22=, $24, $1
	i32.store8	$push83=, 0($22), $17
	i32.store8	$17=, 0($24), $pop83
	i32.const	$23=, 3
	call    	check, $18, $23, $17
	i32.load8_u	$push84=, A($17)
	i32.store8	$push85=, 0($21), $pop84
	i32.store8	$push86=, 0($22), $pop85
	i32.store8	$discard=, 0($24), $pop86
	call    	check, $18, $23, $2
	i32.store8	$push87=, 0($21), $26
	i32.store8	$push88=, 0($22), $pop87
	i32.store8	$13=, 0($24), $pop88
	call    	check, $18, $23, $13
	i32.add 	$18=, $18, $1
	copy_local	$24=, $17
	i32.ne  	$push89=, $18, $3
	br_if   	$pop89, .LBB2_3
.LBB2_4:                                # %for.body70
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_5
	i32.store8	$push90=, u+6($17), $15
	i32.store8	$push91=, u+7($17), $pop90
	i32.store8	$push92=, u+8($17), $pop91
	i32.store8	$push93=, u+9($17), $pop92
	i32.store8	$push94=, u+10($17), $pop93
	i32.store8	$push95=, u+11($17), $pop94
	i32.store8	$push96=, u+12($17), $pop95
	i32.store8	$push97=, u+13($17), $pop96
	i32.store8	$push98=, u+14($17), $pop97
	i32.store8	$push99=, u+15($17), $pop98
	i32.store8	$push100=, u+16($17), $pop99
	i32.store8	$push101=, u+17($17), $pop100
	i32.store8	$push102=, u+18($17), $pop101
	i32.store8	$push103=, u+19($17), $pop102
	i32.store8	$push104=, u+20($17), $pop103
	i32.store8	$push105=, u+21($17), $pop104
	i32.store8	$push106=, u+22($17), $pop105
	i32.store8	$push107=, u+23($17), $pop106
	i32.store8	$push108=, u+24($17), $pop107
	i32.store8	$push109=, u+25($17), $pop108
	i32.store8	$push110=, u+26($17), $pop109
	i32.store8	$push111=, u+27($17), $pop110
	i32.store8	$push112=, u+28($17), $pop111
	i32.store8	$push113=, u+29($17), $pop112
	i32.store8	$12=, u+30($17), $pop113
	i32.store	$4=, u($17), $16
	i32.store16	$5=, u+4($17), $20
	i32.add 	$18=, $0, $24
	i32.add 	$22=, $18, $23
	i32.store8	$27=, 0($22), $17
	i32.add 	$26=, $18, $25
	i32.store8	$discard=, 0($26), $27
	i32.add 	$9=, $18, $1
	i32.store8	$push114=, 0($9), $27
	i32.store8	$27=, 0($18), $pop114
	i32.const	$21=, 4
	call    	check, $24, $21, $27
	i32.load8_u	$push115=, A($27)
	i32.store8	$push116=, 0($22), $pop115
	i32.store8	$push117=, 0($26), $pop116
	i32.store8	$push118=, 0($9), $pop117
	i32.store8	$discard=, 0($18), $pop118
	call    	check, $24, $21, $2
	i32.store8	$push119=, 0($22), $13
	i32.store8	$push120=, 0($26), $pop119
	i32.store8	$push121=, 0($9), $pop120
	i32.store8	$11=, 0($18), $pop121
	call    	check, $24, $21, $11
	i32.add 	$24=, $24, $1
	copy_local	$18=, $27
	i32.ne  	$push122=, $24, $3
	br_if   	$pop122, .LBB2_4
.LBB2_5:                                # %for.body96
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_6
	i32.store8	$push123=, u+6($27), $12
	i32.store8	$push124=, u+7($27), $pop123
	i32.store8	$push125=, u+8($27), $pop124
	i32.store8	$push126=, u+9($27), $pop125
	i32.store8	$push127=, u+10($27), $pop126
	i32.store8	$push128=, u+11($27), $pop127
	i32.store8	$push129=, u+12($27), $pop128
	i32.store8	$push130=, u+13($27), $pop129
	i32.store8	$push131=, u+14($27), $pop130
	i32.store8	$push132=, u+15($27), $pop131
	i32.store8	$push133=, u+16($27), $pop132
	i32.store8	$push134=, u+17($27), $pop133
	i32.store8	$push135=, u+18($27), $pop134
	i32.store8	$push136=, u+19($27), $pop135
	i32.store8	$push137=, u+20($27), $pop136
	i32.store8	$push138=, u+21($27), $pop137
	i32.store8	$push139=, u+22($27), $pop138
	i32.store8	$push140=, u+23($27), $pop139
	i32.store8	$push141=, u+24($27), $pop140
	i32.store8	$push142=, u+25($27), $pop141
	i32.store8	$push143=, u+26($27), $pop142
	i32.store8	$push144=, u+27($27), $pop143
	i32.store8	$push145=, u+28($27), $pop144
	i32.store8	$push146=, u+29($27), $pop145
	i32.store8	$16=, u+30($27), $pop146
	i32.store	$6=, u($27), $4
	i32.store16	$7=, u+4($27), $5
	i32.add 	$24=, $0, $18
	i32.add 	$22=, $24, $21
	i32.store8	$17=, 0($22), $27
	i32.add 	$26=, $24, $23
	i32.store8	$discard=, 0($26), $17
	i32.add 	$13=, $24, $25
	i32.store8	$discard=, 0($13), $17
	i32.add 	$8=, $24, $1
	i32.store8	$push147=, 0($8), $17
	i32.store8	$17=, 0($24), $pop147
	i32.const	$9=, 5
	call    	check, $18, $9, $17
	i32.load8_u	$push148=, A($17)
	i32.store8	$push149=, 0($22), $pop148
	i32.store8	$push150=, 0($26), $pop149
	i32.store8	$push151=, 0($13), $pop150
	i32.store8	$push152=, 0($8), $pop151
	i32.store8	$discard=, 0($24), $pop152
	call    	check, $18, $9, $2
	i32.store8	$push153=, 0($22), $11
	i32.store8	$push154=, 0($26), $pop153
	i32.store8	$push155=, 0($13), $pop154
	i32.store8	$push156=, 0($8), $pop155
	i32.store8	$15=, 0($24), $pop156
	call    	check, $18, $9, $15
	i32.add 	$18=, $18, $1
	copy_local	$22=, $17
	i32.ne  	$push157=, $18, $3
	br_if   	$pop157, .LBB2_5
.LBB2_6:                                # %for.body122
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_7
	i32.store8	$push158=, u+6($17), $16
	i32.store8	$push159=, u+7($17), $pop158
	i32.store8	$push160=, u+8($17), $pop159
	i32.store8	$push161=, u+9($17), $pop160
	i32.store8	$push162=, u+10($17), $pop161
	i32.store8	$push163=, u+11($17), $pop162
	i32.store8	$push164=, u+12($17), $pop163
	i32.store8	$push165=, u+13($17), $pop164
	i32.store8	$push166=, u+14($17), $pop165
	i32.store8	$push167=, u+15($17), $pop166
	i32.store8	$push168=, u+16($17), $pop167
	i32.store8	$push169=, u+17($17), $pop168
	i32.store8	$push170=, u+18($17), $pop169
	i32.store8	$push171=, u+19($17), $pop170
	i32.store8	$push172=, u+20($17), $pop171
	i32.store8	$push173=, u+21($17), $pop172
	i32.store8	$push174=, u+22($17), $pop173
	i32.store8	$push175=, u+23($17), $pop174
	i32.store8	$push176=, u+24($17), $pop175
	i32.store8	$push177=, u+25($17), $pop176
	i32.store8	$push178=, u+26($17), $pop177
	i32.store8	$push179=, u+27($17), $pop178
	i32.store8	$push180=, u+28($17), $pop179
	i32.store8	$push181=, u+29($17), $pop180
	i32.store8	$4=, u+30($17), $pop181
	i32.store	$5=, u($17), $6
	i32.store16	$10=, u+4($17), $7
	i32.add 	$24=, $0, $22
	i32.add 	$18=, $24, $9
	i32.store8	$27=, 0($18), $17
	i32.add 	$26=, $24, $21
	i32.store8	$discard=, 0($26), $27
	i32.add 	$8=, $24, $23
	i32.store8	$discard=, 0($8), $27
	i32.add 	$11=, $24, $25
	i32.store8	$discard=, 0($11), $27
	i32.add 	$12=, $24, $1
	i32.store8	$push182=, 0($12), $27
	i32.store8	$27=, 0($24), $pop182
	i32.const	$13=, 6
	call    	check, $22, $13, $27
	i32.load8_u	$push183=, A($27)
	i32.store8	$push184=, 0($18), $pop183
	i32.store8	$push185=, 0($26), $pop184
	i32.store8	$push186=, 0($8), $pop185
	i32.store8	$push187=, 0($11), $pop186
	i32.store8	$push188=, 0($12), $pop187
	i32.store8	$discard=, 0($24), $pop188
	call    	check, $22, $13, $2
	i32.store8	$push189=, 0($18), $15
	i32.store8	$push190=, 0($26), $pop189
	i32.store8	$push191=, 0($8), $pop190
	i32.store8	$push192=, 0($11), $pop191
	i32.store8	$push193=, 0($12), $pop192
	i32.store8	$20=, 0($24), $pop193
	call    	check, $22, $13, $20
	i32.add 	$22=, $22, $1
	copy_local	$26=, $27
	i32.ne  	$push194=, $22, $3
	br_if   	$pop194, .LBB2_6
.LBB2_7:                                # %for.body148
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_8
	i32.store8	$push195=, u+6($27), $4
	i32.store8	$push196=, u+7($27), $pop195
	i32.store8	$push197=, u+8($27), $pop196
	i32.store8	$push198=, u+9($27), $pop197
	i32.store8	$push199=, u+10($27), $pop198
	i32.store8	$push200=, u+11($27), $pop199
	i32.store8	$push201=, u+12($27), $pop200
	i32.store8	$push202=, u+13($27), $pop201
	i32.store8	$push203=, u+14($27), $pop202
	i32.store8	$push204=, u+15($27), $pop203
	i32.store8	$push205=, u+16($27), $pop204
	i32.store8	$push206=, u+17($27), $pop205
	i32.store8	$push207=, u+18($27), $pop206
	i32.store8	$push208=, u+19($27), $pop207
	i32.store8	$push209=, u+20($27), $pop208
	i32.store8	$push210=, u+21($27), $pop209
	i32.store8	$push211=, u+22($27), $pop210
	i32.store8	$push212=, u+23($27), $pop211
	i32.store8	$push213=, u+24($27), $pop212
	i32.store8	$push214=, u+25($27), $pop213
	i32.store8	$push215=, u+26($27), $pop214
	i32.store8	$push216=, u+27($27), $pop215
	i32.store8	$push217=, u+28($27), $pop216
	i32.store8	$push218=, u+29($27), $pop217
	i32.store8	$6=, u+30($27), $pop218
	i32.store	$7=, u($27), $5
	i32.store16	$14=, u+4($27), $10
	i32.add 	$24=, $0, $26
	i32.add 	$18=, $24, $13
	i32.store8	$17=, 0($18), $27
	i32.add 	$8=, $24, $9
	i32.store8	$discard=, 0($8), $17
	i32.add 	$11=, $24, $21
	i32.store8	$discard=, 0($11), $17
	i32.add 	$12=, $24, $23
	i32.store8	$discard=, 0($12), $17
	i32.add 	$15=, $24, $25
	i32.store8	$discard=, 0($15), $17
	i32.add 	$16=, $24, $1
	i32.store8	$push219=, 0($16), $17
	i32.store8	$17=, 0($24), $pop219
	i32.const	$22=, 7
	call    	check, $26, $22, $17
	i32.load8_u	$push220=, A($17)
	i32.store8	$push221=, 0($18), $pop220
	i32.store8	$push222=, 0($8), $pop221
	i32.store8	$push223=, 0($11), $pop222
	i32.store8	$push224=, 0($12), $pop223
	i32.store8	$push225=, 0($15), $pop224
	i32.store8	$push226=, 0($16), $pop225
	i32.store8	$discard=, 0($24), $pop226
	call    	check, $26, $22, $2
	i32.store8	$push227=, 0($18), $20
	i32.store8	$push228=, 0($8), $pop227
	i32.store8	$push229=, 0($11), $pop228
	i32.store8	$push230=, 0($12), $pop229
	i32.store8	$push231=, 0($15), $pop230
	i32.store8	$push232=, 0($16), $pop231
	i32.store8	$18=, 0($24), $pop232
	call    	check, $26, $22, $18
	i32.add 	$26=, $26, $1
	copy_local	$24=, $17
	i32.ne  	$push233=, $26, $3
	br_if   	$pop233, .LBB2_7
.LBB2_8:                                # %for.body174
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_9
	i32.store8	$push234=, u+6($17), $6
	i32.store8	$push235=, u+7($17), $pop234
	i32.store8	$push236=, u+8($17), $pop235
	i32.store8	$push237=, u+9($17), $pop236
	i32.store8	$push238=, u+10($17), $pop237
	i32.store8	$push239=, u+11($17), $pop238
	i32.store8	$push240=, u+12($17), $pop239
	i32.store8	$push241=, u+13($17), $pop240
	i32.store8	$push242=, u+14($17), $pop241
	i32.store8	$push243=, u+15($17), $pop242
	i32.store8	$push244=, u+16($17), $pop243
	i32.store8	$push245=, u+17($17), $pop244
	i32.store8	$push246=, u+18($17), $pop245
	i32.store8	$push247=, u+19($17), $pop246
	i32.store8	$push248=, u+20($17), $pop247
	i32.store8	$push249=, u+21($17), $pop248
	i32.store8	$push250=, u+22($17), $pop249
	i32.store8	$push251=, u+23($17), $pop250
	i32.store8	$push252=, u+24($17), $pop251
	i32.store8	$push253=, u+25($17), $pop252
	i32.store8	$push254=, u+26($17), $pop253
	i32.store8	$push255=, u+27($17), $pop254
	i32.store8	$push256=, u+28($17), $pop255
	i32.store8	$push257=, u+29($17), $pop256
	i32.store8	$4=, u+30($17), $pop257
	i32.store	$5=, u($17), $7
	i32.store16	$10=, u+4($17), $14
	i32.add 	$27=, $0, $24
	i32.add 	$26=, $27, $22
	i64.const	$push258=, 0
	i64.store8	$19=, 0($26), $pop258
	i32.add 	$8=, $27, $13
	i64.store8	$discard=, 0($8), $19
	i32.add 	$11=, $27, $9
	i64.store8	$discard=, 0($11), $19
	i32.add 	$12=, $27, $21
	i64.store8	$discard=, 0($12), $19
	i32.add 	$15=, $27, $23
	i64.store8	$discard=, 0($15), $19
	i32.add 	$16=, $27, $25
	i64.store8	$discard=, 0($16), $19
	i32.add 	$20=, $27, $1
	i64.store8	$push259=, 0($20), $19
	i64.store8	$discard=, 0($27), $pop259
	call    	check, $24, $3, $17
	i32.load8_u	$push260=, A($17)
	i32.store8	$push261=, 0($26), $pop260
	i32.store8	$push262=, 0($8), $pop261
	i32.store8	$push263=, 0($11), $pop262
	i32.store8	$push264=, 0($12), $pop263
	i32.store8	$push265=, 0($15), $pop264
	i32.store8	$push266=, 0($16), $pop265
	i32.store8	$push267=, 0($20), $pop266
	i32.store8	$discard=, 0($27), $pop267
	call    	check, $24, $3, $2
	i64.const	$push268=, 66
	i64.store8	$push269=, 0($26), $pop268
	i64.store8	$push270=, 0($8), $pop269
	i64.store8	$push271=, 0($11), $pop270
	i64.store8	$push272=, 0($12), $pop271
	i64.store8	$push273=, 0($15), $pop272
	i64.store8	$push274=, 0($16), $pop273
	i64.store8	$push275=, 0($20), $pop274
	i64.store8	$discard=, 0($27), $pop275
	call    	check, $24, $3, $18
	i32.add 	$24=, $24, $1
	copy_local	$27=, $17
	i32.ne  	$push276=, $24, $3
	br_if   	$pop276, .LBB2_8
.LBB2_9:                                # %for.body200
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_10
	i32.store8	$push277=, u+6($17), $4
	i32.store8	$push278=, u+7($17), $pop277
	i32.store8	$push279=, u+8($17), $pop278
	i32.store8	$push280=, u+9($17), $pop279
	i32.store8	$push281=, u+10($17), $pop280
	i32.store8	$push282=, u+11($17), $pop281
	i32.store8	$push283=, u+12($17), $pop282
	i32.store8	$push284=, u+13($17), $pop283
	i32.store8	$push285=, u+14($17), $pop284
	i32.store8	$push286=, u+15($17), $pop285
	i32.store8	$push287=, u+16($17), $pop286
	i32.store8	$push288=, u+17($17), $pop287
	i32.store8	$push289=, u+18($17), $pop288
	i32.store8	$push290=, u+19($17), $pop289
	i32.store8	$push291=, u+20($17), $pop290
	i32.store8	$push292=, u+21($17), $pop291
	i32.store8	$push293=, u+22($17), $pop292
	i32.store8	$push294=, u+23($17), $pop293
	i32.store8	$push295=, u+24($17), $pop294
	i32.store8	$push296=, u+25($17), $pop295
	i32.store8	$push297=, u+26($17), $pop296
	i32.store8	$push298=, u+27($17), $pop297
	i32.store8	$push299=, u+28($17), $pop298
	i32.store8	$push300=, u+29($17), $pop299
	i32.store8	$23=, u+30($17), $pop300
	i32.store	$21=, u($17), $5
	i32.add 	$24=, $0, $27
	i32.const	$25=, 9
	i32.store16	$22=, u+4($17), $10
	call    	memset, $24, $17, $25
	call    	check, $27, $25, $17
	i32.load8_u	$push301=, A($17)
	call    	memset, $24, $pop301, $25
	call    	check, $27, $25, $2
	call    	memset, $24, $18, $25
	call    	check, $27, $25, $18
	i32.add 	$27=, $27, $1
	copy_local	$25=, $17
	i32.ne  	$push302=, $27, $3
	br_if   	$pop302, .LBB2_9
.LBB2_10:                               # %for.body226
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_11
	i32.store8	$push303=, u+6($17), $23
	i32.store8	$push304=, u+7($17), $pop303
	i32.store8	$push305=, u+8($17), $pop304
	i32.store8	$push306=, u+9($17), $pop305
	i32.store8	$push307=, u+10($17), $pop306
	i32.store8	$push308=, u+11($17), $pop307
	i32.store8	$push309=, u+12($17), $pop308
	i32.store8	$push310=, u+13($17), $pop309
	i32.store8	$push311=, u+14($17), $pop310
	i32.store8	$push312=, u+15($17), $pop311
	i32.store8	$push313=, u+16($17), $pop312
	i32.store8	$push314=, u+17($17), $pop313
	i32.store8	$push315=, u+18($17), $pop314
	i32.store8	$push316=, u+19($17), $pop315
	i32.store8	$push317=, u+20($17), $pop316
	i32.store8	$push318=, u+21($17), $pop317
	i32.store8	$push319=, u+22($17), $pop318
	i32.store8	$push320=, u+23($17), $pop319
	i32.store8	$push321=, u+24($17), $pop320
	i32.store8	$push322=, u+25($17), $pop321
	i32.store8	$push323=, u+26($17), $pop322
	i32.store8	$push324=, u+27($17), $pop323
	i32.store8	$push325=, u+28($17), $pop324
	i32.store8	$push326=, u+29($17), $pop325
	i32.store8	$26=, u+30($17), $pop326
	i32.store	$9=, u($17), $21
	i32.add 	$24=, $0, $25
	i32.const	$27=, 10
	i32.store16	$13=, u+4($17), $22
	call    	memset, $24, $17, $27
	call    	check, $25, $27, $17
	i32.load8_u	$push327=, A($17)
	call    	memset, $24, $pop327, $27
	call    	check, $25, $27, $2
	call    	memset, $24, $18, $27
	call    	check, $25, $27, $18
	i32.add 	$25=, $25, $1
	copy_local	$27=, $17
	i32.ne  	$push328=, $25, $3
	br_if   	$pop328, .LBB2_10
.LBB2_11:                               # %for.body252
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_12
	i32.store8	$push329=, u+6($17), $26
	i32.store8	$push330=, u+7($17), $pop329
	i32.store8	$push331=, u+8($17), $pop330
	i32.store8	$push332=, u+9($17), $pop331
	i32.store8	$push333=, u+10($17), $pop332
	i32.store8	$push334=, u+11($17), $pop333
	i32.store8	$push335=, u+12($17), $pop334
	i32.store8	$push336=, u+13($17), $pop335
	i32.store8	$push337=, u+14($17), $pop336
	i32.store8	$push338=, u+15($17), $pop337
	i32.store8	$push339=, u+16($17), $pop338
	i32.store8	$push340=, u+17($17), $pop339
	i32.store8	$push341=, u+18($17), $pop340
	i32.store8	$push342=, u+19($17), $pop341
	i32.store8	$push343=, u+20($17), $pop342
	i32.store8	$push344=, u+21($17), $pop343
	i32.store8	$push345=, u+22($17), $pop344
	i32.store8	$push346=, u+23($17), $pop345
	i32.store8	$push347=, u+24($17), $pop346
	i32.store8	$push348=, u+25($17), $pop347
	i32.store8	$push349=, u+26($17), $pop348
	i32.store8	$push350=, u+27($17), $pop349
	i32.store8	$push351=, u+28($17), $pop350
	i32.store8	$push352=, u+29($17), $pop351
	i32.store8	$23=, u+30($17), $pop352
	i32.store	$21=, u($17), $9
	i32.add 	$24=, $0, $27
	i32.const	$25=, 11
	i32.store16	$22=, u+4($17), $13
	call    	memset, $24, $17, $25
	call    	check, $27, $25, $17
	i32.load8_u	$push353=, A($17)
	call    	memset, $24, $pop353, $25
	call    	check, $27, $25, $2
	call    	memset, $24, $18, $25
	call    	check, $27, $25, $18
	i32.add 	$27=, $27, $1
	copy_local	$25=, $17
	i32.ne  	$push354=, $27, $3
	br_if   	$pop354, .LBB2_11
.LBB2_12:                               # %for.body278
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_13
	i32.store8	$push355=, u+6($17), $23
	i32.store8	$push356=, u+7($17), $pop355
	i32.store8	$push357=, u+8($17), $pop356
	i32.store8	$push358=, u+9($17), $pop357
	i32.store8	$push359=, u+10($17), $pop358
	i32.store8	$push360=, u+11($17), $pop359
	i32.store8	$push361=, u+12($17), $pop360
	i32.store8	$push362=, u+13($17), $pop361
	i32.store8	$push363=, u+14($17), $pop362
	i32.store8	$push364=, u+15($17), $pop363
	i32.store8	$push365=, u+16($17), $pop364
	i32.store8	$push366=, u+17($17), $pop365
	i32.store8	$push367=, u+18($17), $pop366
	i32.store8	$push368=, u+19($17), $pop367
	i32.store8	$push369=, u+20($17), $pop368
	i32.store8	$push370=, u+21($17), $pop369
	i32.store8	$push371=, u+22($17), $pop370
	i32.store8	$push372=, u+23($17), $pop371
	i32.store8	$push373=, u+24($17), $pop372
	i32.store8	$push374=, u+25($17), $pop373
	i32.store8	$push375=, u+26($17), $pop374
	i32.store8	$push376=, u+27($17), $pop375
	i32.store8	$push377=, u+28($17), $pop376
	i32.store8	$push378=, u+29($17), $pop377
	i32.store8	$26=, u+30($17), $pop378
	i32.store	$9=, u($17), $21
	i32.add 	$24=, $0, $25
	i32.const	$27=, 12
	i32.store16	$13=, u+4($17), $22
	call    	memset, $24, $17, $27
	call    	check, $25, $27, $17
	i32.load8_u	$push379=, A($17)
	call    	memset, $24, $pop379, $27
	call    	check, $25, $27, $2
	call    	memset, $24, $18, $27
	call    	check, $25, $27, $18
	i32.add 	$25=, $25, $1
	copy_local	$27=, $17
	i32.ne  	$push380=, $25, $3
	br_if   	$pop380, .LBB2_12
.LBB2_13:                               # %for.body304
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_14
	i32.store8	$push381=, u+6($17), $26
	i32.store8	$push382=, u+7($17), $pop381
	i32.store8	$push383=, u+8($17), $pop382
	i32.store8	$push384=, u+9($17), $pop383
	i32.store8	$push385=, u+10($17), $pop384
	i32.store8	$push386=, u+11($17), $pop385
	i32.store8	$push387=, u+12($17), $pop386
	i32.store8	$push388=, u+13($17), $pop387
	i32.store8	$push389=, u+14($17), $pop388
	i32.store8	$push390=, u+15($17), $pop389
	i32.store8	$push391=, u+16($17), $pop390
	i32.store8	$push392=, u+17($17), $pop391
	i32.store8	$push393=, u+18($17), $pop392
	i32.store8	$push394=, u+19($17), $pop393
	i32.store8	$push395=, u+20($17), $pop394
	i32.store8	$push396=, u+21($17), $pop395
	i32.store8	$push397=, u+22($17), $pop396
	i32.store8	$push398=, u+23($17), $pop397
	i32.store8	$push399=, u+24($17), $pop398
	i32.store8	$push400=, u+25($17), $pop399
	i32.store8	$push401=, u+26($17), $pop400
	i32.store8	$push402=, u+27($17), $pop401
	i32.store8	$push403=, u+28($17), $pop402
	i32.store8	$push404=, u+29($17), $pop403
	i32.store8	$8=, u+30($17), $pop404
	i32.store	$11=, u($17), $9
	i32.add 	$24=, $0, $27
	i32.const	$25=, 13
	i32.store16	$12=, u+4($17), $13
	call    	memset, $24, $17, $25
	call    	check, $27, $25, $17
	i32.load8_u	$push405=, A($17)
	call    	memset, $24, $pop405, $25
	call    	check, $27, $25, $2
	call    	memset, $24, $18, $25
	call    	check, $27, $25, $18
	i32.add 	$27=, $27, $1
	copy_local	$25=, $17
	i32.ne  	$push406=, $27, $3
	br_if   	$pop406, .LBB2_13
.LBB2_14:                               # %for.body330
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_15
	i32.store8	$push407=, u+6($17), $8
	i32.store8	$push408=, u+7($17), $pop407
	i32.store8	$push409=, u+8($17), $pop408
	i32.store8	$push410=, u+9($17), $pop409
	i32.store8	$push411=, u+10($17), $pop410
	i32.store8	$push412=, u+11($17), $pop411
	i32.store8	$push413=, u+12($17), $pop412
	i32.store8	$push414=, u+13($17), $pop413
	i32.store8	$push415=, u+14($17), $pop414
	i32.store8	$push416=, u+15($17), $pop415
	i32.store8	$push417=, u+16($17), $pop416
	i32.store8	$push418=, u+17($17), $pop417
	i32.store8	$push419=, u+18($17), $pop418
	i32.store8	$push420=, u+19($17), $pop419
	i32.store8	$push421=, u+20($17), $pop420
	i32.store8	$push422=, u+21($17), $pop421
	i32.store8	$push423=, u+22($17), $pop422
	i32.store8	$push424=, u+23($17), $pop423
	i32.store8	$push425=, u+24($17), $pop424
	i32.store8	$push426=, u+25($17), $pop425
	i32.store8	$push427=, u+26($17), $pop426
	i32.store8	$push428=, u+27($17), $pop427
	i32.store8	$push429=, u+28($17), $pop428
	i32.store8	$push430=, u+29($17), $pop429
	i32.store8	$23=, u+30($17), $pop430
	i32.store	$21=, u($17), $11
	i32.add 	$24=, $0, $25
	i32.const	$27=, 14
	i32.store16	$22=, u+4($17), $12
	call    	memset, $24, $17, $27
	call    	check, $25, $27, $17
	i32.load8_u	$push431=, A($17)
	call    	memset, $24, $pop431, $27
	call    	check, $25, $27, $2
	call    	memset, $24, $18, $27
	call    	check, $25, $27, $18
	i32.add 	$25=, $25, $1
	copy_local	$27=, $17
	i32.ne  	$push432=, $25, $3
	br_if   	$pop432, .LBB2_14
.LBB2_15:                               # %for.body356
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_16
	i32.store8	$push433=, u+6($17), $23
	i32.store8	$push434=, u+7($17), $pop433
	i32.store8	$push435=, u+8($17), $pop434
	i32.store8	$push436=, u+9($17), $pop435
	i32.store8	$push437=, u+10($17), $pop436
	i32.store8	$push438=, u+11($17), $pop437
	i32.store8	$push439=, u+12($17), $pop438
	i32.store8	$push440=, u+13($17), $pop439
	i32.store8	$push441=, u+14($17), $pop440
	i32.store8	$push442=, u+15($17), $pop441
	i32.store8	$push443=, u+16($17), $pop442
	i32.store8	$push444=, u+17($17), $pop443
	i32.store8	$push445=, u+18($17), $pop444
	i32.store8	$push446=, u+19($17), $pop445
	i32.store8	$push447=, u+20($17), $pop446
	i32.store8	$push448=, u+21($17), $pop447
	i32.store8	$push449=, u+22($17), $pop448
	i32.store8	$push450=, u+23($17), $pop449
	i32.store8	$push451=, u+24($17), $pop450
	i32.store8	$push452=, u+25($17), $pop451
	i32.store8	$push453=, u+26($17), $pop452
	i32.store8	$push454=, u+27($17), $pop453
	i32.store8	$push455=, u+28($17), $pop454
	i32.store8	$push456=, u+29($17), $pop455
	i32.store8	$discard=, u+30($17), $pop456
	i32.store	$discard=, u($17), $21
	i32.add 	$24=, $0, $27
	i32.const	$25=, 15
	i32.store16	$discard=, u+4($17), $22
	call    	memset, $24, $17, $25
	call    	check, $27, $25, $17
	i32.load8_u	$push457=, A($17)
	call    	memset, $24, $pop457, $25
	call    	check, $27, $25, $2
	call    	memset, $24, $18, $25
	call    	check, $27, $25, $18
	i32.add 	$27=, $27, $1
	i32.ne  	$push458=, $27, $3
	br_if   	$pop458, .LBB2_15
.LBB2_16:                               # %for.end378
	i32.const	$push459=, 0
	call    	exit, $pop459
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
A:
	.int8	65                      # 0x41
	.size	A, 1

	.type	u,@object               # @u
	.lcomm	u,32,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
