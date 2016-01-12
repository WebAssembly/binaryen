	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-3.c"
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
	call    	abort@FUNCTION
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
	call    	abort@FUNCTION
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
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	check, .Lfunc_end1-check

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$12=, 0
	copy_local	$13=, $12
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_14 Depth 2
                                        #     Child Loop BB2_26 Depth 2
	block   	.LBB2_48
	block   	.LBB2_47
	block   	.LBB2_46
	loop    	.LBB2_38
	i32.const	$push0=, 1633771873
	i32.store	$8=, u($12), $pop0
	i32.const	$push1=, 24929
	i32.store16	$9=, u+4($12), $pop1
	i32.const	$push2=, 97
	i32.store8	$push3=, u+6($12), $pop2
	i32.store8	$push4=, u+7($12), $pop3
	i32.store8	$push5=, u+8($12), $pop4
	i32.store8	$push6=, u+9($12), $pop5
	i32.store8	$push7=, u+10($12), $pop6
	i32.store8	$push8=, u+11($12), $pop7
	i32.store8	$push9=, u+12($12), $pop8
	i32.store8	$push10=, u+13($12), $pop9
	i32.store8	$push11=, u+14($12), $pop10
	i32.store8	$push12=, u+15($12), $pop11
	i32.store8	$push13=, u+16($12), $pop12
	i32.store8	$push14=, u+17($12), $pop13
	i32.store8	$push15=, u+18($12), $pop14
	i32.store8	$push16=, u+19($12), $pop15
	i32.store8	$push17=, u+20($12), $pop16
	i32.store8	$push18=, u+21($12), $pop17
	i32.store8	$push19=, u+22($12), $pop18
	i32.store8	$push20=, u+23($12), $pop19
	i32.store8	$push21=, u+24($12), $pop20
	i32.store8	$push22=, u+25($12), $pop21
	i32.store8	$push23=, u+26($12), $pop22
	i32.store8	$push24=, u+27($12), $pop23
	i32.store8	$push25=, u+28($12), $pop24
	i32.store8	$2=, u+29($12), $pop25
	i32.const	$11=, u
	i32.store8	$10=, u+30($12), $2
	call    	memset@FUNCTION, $11, $12, $13
	i32.const	$0=, 1
	i32.lt_s	$6=, $13, $0
	copy_local	$2=, $12
	block   	.LBB2_5
	br_if   	$6, .LBB2_5
.LBB2_2:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_4
	i32.const	$11=, u
	i32.add 	$push26=, $11, $2
	i32.load8_u	$push27=, 0($pop26)
	br_if   	$pop27, .LBB2_4
# BB#3:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$2=, $2, $0
	i32.add 	$11=, $11, $2
	i32.lt_s	$push28=, $2, $13
	br_if   	$pop28, .LBB2_2
	br      	.LBB2_5
.LBB2_4:                                # %if.then10.i
	call    	abort@FUNCTION
	unreachable
.LBB2_5:                                # %for.body19.preheader.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 0($11)
	i32.ne  	$push30=, $pop29, $10
	br_if   	$pop30, .LBB2_48
# BB#6:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 1($11)
	i32.ne  	$push32=, $pop31, $10
	br_if   	$pop32, .LBB2_48
# BB#7:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 2($11)
	i32.ne  	$push34=, $pop33, $10
	br_if   	$pop34, .LBB2_48
# BB#8:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 3($11)
	i32.ne  	$push36=, $pop35, $10
	br_if   	$pop36, .LBB2_48
# BB#9:                                 # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 4($11)
	i32.ne  	$push38=, $pop37, $10
	br_if   	$pop38, .LBB2_48
# BB#10:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push39=, 5($11)
	i32.ne  	$push40=, $pop39, $10
	br_if   	$pop40, .LBB2_48
# BB#11:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push41=, 6($11)
	i32.ne  	$push42=, $pop41, $10
	br_if   	$pop42, .LBB2_48
# BB#12:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push43=, 7($11)
	i32.ne  	$push44=, $pop43, $10
	br_if   	$pop44, .LBB2_48
# BB#13:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
	i32.const	$11=, u
	block   	.LBB2_17
	i32.load8_u	$push45=, A($2)
	call    	memset@FUNCTION, $11, $pop45, $13
	br_if   	$6, .LBB2_17
.LBB2_14:                               # %for.body6.i241
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_16
	i32.const	$11=, u
	i32.add 	$push46=, $11, $2
	i32.load8_u	$push47=, 0($pop46)
	i32.const	$push48=, 65
	i32.ne  	$push49=, $pop47, $pop48
	br_if   	$pop49, .LBB2_16
# BB#15:                                # %for.inc12.i246
                                        #   in Loop: Header=BB2_14 Depth=2
	i32.add 	$2=, $2, $0
	i32.add 	$11=, $11, $2
	i32.lt_s	$push50=, $2, $13
	br_if   	$pop50, .LBB2_14
	br      	.LBB2_17
.LBB2_16:                               # %if.then10.i242
	call    	abort@FUNCTION
	unreachable
.LBB2_17:                               # %for.body19.preheader.i249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push51=, 0($11)
	i32.ne  	$push52=, $pop51, $10
	br_if   	$pop52, .LBB2_47
# BB#18:                                # %for.inc25.i253
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push53=, 1($11)
	i32.ne  	$push54=, $pop53, $10
	br_if   	$pop54, .LBB2_47
# BB#19:                                # %for.inc25.1.i256
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push55=, 2($11)
	i32.ne  	$push56=, $pop55, $10
	br_if   	$pop56, .LBB2_47
# BB#20:                                # %for.inc25.2.i259
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push57=, 3($11)
	i32.ne  	$push58=, $pop57, $10
	br_if   	$pop58, .LBB2_47
# BB#21:                                # %for.inc25.3.i262
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push59=, 4($11)
	i32.ne  	$push60=, $pop59, $10
	br_if   	$pop60, .LBB2_47
# BB#22:                                # %for.inc25.4.i265
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push61=, 5($11)
	i32.ne  	$push62=, $pop61, $10
	br_if   	$pop62, .LBB2_47
# BB#23:                                # %for.inc25.5.i268
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push63=, 6($11)
	i32.ne  	$push64=, $pop63, $10
	br_if   	$pop64, .LBB2_47
# BB#24:                                # %for.inc25.6.i271
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push65=, 7($11)
	i32.ne  	$push66=, $pop65, $10
	br_if   	$pop66, .LBB2_47
# BB#25:                                # %check.exit272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$11=, u
	i32.const	$1=, 66
	call    	memset@FUNCTION, $11, $1, $13
	i32.const	$2=, 0
	block   	.LBB2_29
	br_if   	$6, .LBB2_29
.LBB2_26:                               # %for.body6.i278
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB2_28
	i32.const	$11=, u
	i32.add 	$push67=, $11, $2
	i32.load8_u	$push68=, 0($pop67)
	i32.ne  	$push69=, $pop68, $1
	br_if   	$pop69, .LBB2_28
# BB#27:                                # %for.inc12.i283
                                        #   in Loop: Header=BB2_26 Depth=2
	i32.add 	$2=, $2, $0
	i32.add 	$11=, $11, $2
	i32.lt_s	$push70=, $2, $13
	br_if   	$pop70, .LBB2_26
	br      	.LBB2_29
.LBB2_28:                               # %if.then10.i279
	call    	abort@FUNCTION
	unreachable
.LBB2_29:                               # %for.body19.preheader.i286
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push71=, 0($11)
	i32.ne  	$push72=, $pop71, $10
	br_if   	$pop72, .LBB2_46
# BB#30:                                # %for.inc25.i290
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push73=, 1($11)
	i32.ne  	$push74=, $pop73, $10
	br_if   	$pop74, .LBB2_46
# BB#31:                                # %for.inc25.1.i293
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push75=, 2($11)
	i32.ne  	$push76=, $pop75, $10
	br_if   	$pop76, .LBB2_46
# BB#32:                                # %for.inc25.2.i296
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push77=, 3($11)
	i32.ne  	$push78=, $pop77, $10
	br_if   	$pop78, .LBB2_46
# BB#33:                                # %for.inc25.3.i299
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push79=, 4($11)
	i32.ne  	$push80=, $pop79, $10
	br_if   	$pop80, .LBB2_46
# BB#34:                                # %for.inc25.4.i302
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push81=, 5($11)
	i32.ne  	$push82=, $pop81, $10
	br_if   	$pop82, .LBB2_46
# BB#35:                                # %for.inc25.5.i305
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push83=, 6($11)
	i32.ne  	$push84=, $pop83, $10
	br_if   	$pop84, .LBB2_46
# BB#36:                                # %for.inc25.6.i308
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push85=, 7($11)
	i32.ne  	$push86=, $pop85, $10
	br_if   	$pop86, .LBB2_46
# BB#37:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$13=, $13, $0
	i32.const	$2=, 0
	copy_local	$11=, $2
	i32.const	$push87=, 14
	i32.le_s	$push88=, $13, $pop87
	br_if   	$pop88, .LBB2_1
.LBB2_38:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_39
	i32.store8	$push89=, u+6($2), $10
	i32.store8	$push90=, u+7($2), $pop89
	i32.store8	$push91=, u+8($2), $pop90
	i32.store8	$push92=, u+9($2), $pop91
	i32.store8	$push93=, u+10($2), $pop92
	i32.store8	$push94=, u+11($2), $pop93
	i32.store8	$push95=, u+12($2), $pop94
	i32.store8	$push96=, u+13($2), $pop95
	i32.store8	$push97=, u+14($2), $pop96
	i32.store8	$push98=, u+15($2), $pop97
	i32.store8	$push99=, u+16($2), $pop98
	i32.store8	$push100=, u+17($2), $pop99
	i32.store8	$push101=, u+18($2), $pop100
	i32.store8	$push102=, u+19($2), $pop101
	i32.store8	$push103=, u+20($2), $pop102
	i32.store8	$push104=, u+21($2), $pop103
	i32.store8	$push105=, u+22($2), $pop104
	i32.store8	$push106=, u+23($2), $pop105
	i32.store8	$push107=, u+24($2), $pop106
	i32.store8	$push108=, u+25($2), $pop107
	i32.store8	$push109=, u+26($2), $pop108
	i32.store8	$push110=, u+27($2), $pop109
	i32.store8	$push111=, u+28($2), $pop110
	i32.store8	$push112=, u+29($2), $pop111
	i32.store8	$5=, u+30($2), $pop112
	i32.store	$3=, u($2), $8
	i32.const	$13=, u+1
	i32.store16	$4=, u+4($2), $9
	call    	memset@FUNCTION, $13, $2, $11
	call    	check@FUNCTION, $0, $11, $2
	i32.load8_u	$push113=, A($2)
	call    	memset@FUNCTION, $13, $pop113, $11
	i32.const	$6=, 65
	call    	check@FUNCTION, $0, $11, $6
	call    	memset@FUNCTION, $13, $1, $11
	call    	check@FUNCTION, $0, $11, $1
	i32.add 	$11=, $11, $0
	i32.const	$7=, 15
	copy_local	$13=, $2
	i32.ne  	$push114=, $11, $7
	br_if   	$pop114, .LBB2_38
.LBB2_39:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_40
	i32.store8	$push115=, u+6($2), $5
	i32.store8	$push116=, u+7($2), $pop115
	i32.store8	$push117=, u+8($2), $pop116
	i32.store8	$push118=, u+9($2), $pop117
	i32.store8	$push119=, u+10($2), $pop118
	i32.store8	$push120=, u+11($2), $pop119
	i32.store8	$push121=, u+12($2), $pop120
	i32.store8	$push122=, u+13($2), $pop121
	i32.store8	$push123=, u+14($2), $pop122
	i32.store8	$push124=, u+15($2), $pop123
	i32.store8	$push125=, u+16($2), $pop124
	i32.store8	$push126=, u+17($2), $pop125
	i32.store8	$push127=, u+18($2), $pop126
	i32.store8	$push128=, u+19($2), $pop127
	i32.store8	$push129=, u+20($2), $pop128
	i32.store8	$push130=, u+21($2), $pop129
	i32.store8	$push131=, u+22($2), $pop130
	i32.store8	$push132=, u+23($2), $pop131
	i32.store8	$push133=, u+24($2), $pop132
	i32.store8	$push134=, u+25($2), $pop133
	i32.store8	$push135=, u+26($2), $pop134
	i32.store8	$push136=, u+27($2), $pop135
	i32.store8	$push137=, u+28($2), $pop136
	i32.store8	$push138=, u+29($2), $pop137
	i32.store8	$10=, u+30($2), $pop138
	i32.store	$8=, u($2), $3
	i32.const	$11=, u+2
	i32.store16	$9=, u+4($2), $4
	call    	memset@FUNCTION, $11, $2, $13
	i32.const	$12=, 2
	call    	check@FUNCTION, $12, $13, $2
	i32.load8_u	$push139=, A($2)
	call    	memset@FUNCTION, $11, $pop139, $13
	call    	check@FUNCTION, $12, $13, $6
	call    	memset@FUNCTION, $11, $1, $13
	call    	check@FUNCTION, $12, $13, $1
	i32.add 	$13=, $13, $0
	copy_local	$11=, $2
	i32.ne  	$push140=, $13, $7
	br_if   	$pop140, .LBB2_39
.LBB2_40:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_41
	i32.store8	$push141=, u+6($2), $10
	i32.store8	$push142=, u+7($2), $pop141
	i32.store8	$push143=, u+8($2), $pop142
	i32.store8	$push144=, u+9($2), $pop143
	i32.store8	$push145=, u+10($2), $pop144
	i32.store8	$push146=, u+11($2), $pop145
	i32.store8	$push147=, u+12($2), $pop146
	i32.store8	$push148=, u+13($2), $pop147
	i32.store8	$push149=, u+14($2), $pop148
	i32.store8	$push150=, u+15($2), $pop149
	i32.store8	$push151=, u+16($2), $pop150
	i32.store8	$push152=, u+17($2), $pop151
	i32.store8	$push153=, u+18($2), $pop152
	i32.store8	$push154=, u+19($2), $pop153
	i32.store8	$push155=, u+20($2), $pop154
	i32.store8	$push156=, u+21($2), $pop155
	i32.store8	$push157=, u+22($2), $pop156
	i32.store8	$push158=, u+23($2), $pop157
	i32.store8	$push159=, u+24($2), $pop158
	i32.store8	$push160=, u+25($2), $pop159
	i32.store8	$push161=, u+26($2), $pop160
	i32.store8	$push162=, u+27($2), $pop161
	i32.store8	$push163=, u+28($2), $pop162
	i32.store8	$push164=, u+29($2), $pop163
	i32.store8	$5=, u+30($2), $pop164
	i32.store	$3=, u($2), $8
	i32.const	$13=, u+3
	i32.store16	$4=, u+4($2), $9
	call    	memset@FUNCTION, $13, $2, $11
	i32.const	$12=, 3
	call    	check@FUNCTION, $12, $11, $2
	i32.load8_u	$push165=, A($2)
	call    	memset@FUNCTION, $13, $pop165, $11
	call    	check@FUNCTION, $12, $11, $6
	call    	memset@FUNCTION, $13, $1, $11
	call    	check@FUNCTION, $12, $11, $1
	i32.add 	$11=, $11, $0
	copy_local	$13=, $2
	i32.ne  	$push166=, $11, $7
	br_if   	$pop166, .LBB2_40
.LBB2_41:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_42
	i32.store8	$push167=, u+6($2), $5
	i32.store8	$push168=, u+7($2), $pop167
	i32.store8	$push169=, u+8($2), $pop168
	i32.store8	$push170=, u+9($2), $pop169
	i32.store8	$push171=, u+10($2), $pop170
	i32.store8	$push172=, u+11($2), $pop171
	i32.store8	$push173=, u+12($2), $pop172
	i32.store8	$push174=, u+13($2), $pop173
	i32.store8	$push175=, u+14($2), $pop174
	i32.store8	$push176=, u+15($2), $pop175
	i32.store8	$push177=, u+16($2), $pop176
	i32.store8	$push178=, u+17($2), $pop177
	i32.store8	$push179=, u+18($2), $pop178
	i32.store8	$push180=, u+19($2), $pop179
	i32.store8	$push181=, u+20($2), $pop180
	i32.store8	$push182=, u+21($2), $pop181
	i32.store8	$push183=, u+22($2), $pop182
	i32.store8	$push184=, u+23($2), $pop183
	i32.store8	$push185=, u+24($2), $pop184
	i32.store8	$push186=, u+25($2), $pop185
	i32.store8	$push187=, u+26($2), $pop186
	i32.store8	$push188=, u+27($2), $pop187
	i32.store8	$push189=, u+28($2), $pop188
	i32.store8	$push190=, u+29($2), $pop189
	i32.store8	$10=, u+30($2), $pop190
	i32.store	$8=, u($2), $3
	i32.const	$11=, u+4
	i32.store16	$9=, u+4($2), $4
	call    	memset@FUNCTION, $11, $2, $13
	i32.const	$12=, 4
	call    	check@FUNCTION, $12, $13, $2
	i32.load8_u	$push191=, A($2)
	call    	memset@FUNCTION, $11, $pop191, $13
	call    	check@FUNCTION, $12, $13, $6
	call    	memset@FUNCTION, $11, $1, $13
	call    	check@FUNCTION, $12, $13, $1
	i32.add 	$13=, $13, $0
	copy_local	$11=, $2
	i32.ne  	$push192=, $13, $7
	br_if   	$pop192, .LBB2_41
.LBB2_42:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_43
	i32.store8	$push193=, u+6($2), $10
	i32.store8	$push194=, u+7($2), $pop193
	i32.store8	$push195=, u+8($2), $pop194
	i32.store8	$push196=, u+9($2), $pop195
	i32.store8	$push197=, u+10($2), $pop196
	i32.store8	$push198=, u+11($2), $pop197
	i32.store8	$push199=, u+12($2), $pop198
	i32.store8	$push200=, u+13($2), $pop199
	i32.store8	$push201=, u+14($2), $pop200
	i32.store8	$push202=, u+15($2), $pop201
	i32.store8	$push203=, u+16($2), $pop202
	i32.store8	$push204=, u+17($2), $pop203
	i32.store8	$push205=, u+18($2), $pop204
	i32.store8	$push206=, u+19($2), $pop205
	i32.store8	$push207=, u+20($2), $pop206
	i32.store8	$push208=, u+21($2), $pop207
	i32.store8	$push209=, u+22($2), $pop208
	i32.store8	$push210=, u+23($2), $pop209
	i32.store8	$push211=, u+24($2), $pop210
	i32.store8	$push212=, u+25($2), $pop211
	i32.store8	$push213=, u+26($2), $pop212
	i32.store8	$push214=, u+27($2), $pop213
	i32.store8	$push215=, u+28($2), $pop214
	i32.store8	$push216=, u+29($2), $pop215
	i32.store8	$5=, u+30($2), $pop216
	i32.store	$3=, u($2), $8
	i32.const	$13=, u+5
	i32.store16	$4=, u+4($2), $9
	call    	memset@FUNCTION, $13, $2, $11
	i32.const	$12=, 5
	call    	check@FUNCTION, $12, $11, $2
	i32.load8_u	$push217=, A($2)
	call    	memset@FUNCTION, $13, $pop217, $11
	call    	check@FUNCTION, $12, $11, $6
	call    	memset@FUNCTION, $13, $1, $11
	call    	check@FUNCTION, $12, $11, $1
	i32.add 	$11=, $11, $0
	copy_local	$12=, $2
	i32.ne  	$push218=, $11, $7
	br_if   	$pop218, .LBB2_42
.LBB2_43:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_44
	i32.store8	$push219=, u+6($2), $5
	i32.store8	$push220=, u+7($2), $pop219
	i32.store8	$push221=, u+8($2), $pop220
	i32.store8	$push222=, u+9($2), $pop221
	i32.store8	$push223=, u+10($2), $pop222
	i32.store8	$push224=, u+11($2), $pop223
	i32.store8	$push225=, u+12($2), $pop224
	i32.store8	$push226=, u+13($2), $pop225
	i32.store8	$push227=, u+14($2), $pop226
	i32.store8	$push228=, u+15($2), $pop227
	i32.store8	$push229=, u+16($2), $pop228
	i32.store8	$push230=, u+17($2), $pop229
	i32.store8	$push231=, u+18($2), $pop230
	i32.store8	$push232=, u+19($2), $pop231
	i32.store8	$push233=, u+20($2), $pop232
	i32.store8	$push234=, u+21($2), $pop233
	i32.store8	$push235=, u+22($2), $pop234
	i32.store8	$push236=, u+23($2), $pop235
	i32.store8	$push237=, u+24($2), $pop236
	i32.store8	$push238=, u+25($2), $pop237
	i32.store8	$push239=, u+26($2), $pop238
	i32.store8	$push240=, u+27($2), $pop239
	i32.store8	$push241=, u+28($2), $pop240
	i32.store8	$push242=, u+29($2), $pop241
	i32.store8	$10=, u+30($2), $pop242
	i32.store	$8=, u($2), $3
	i32.const	$13=, u+6
	i32.store16	$9=, u+4($2), $4
	call    	memset@FUNCTION, $13, $2, $12
	i32.const	$11=, 6
	call    	check@FUNCTION, $11, $12, $2
	i32.load8_u	$push243=, A($2)
	call    	memset@FUNCTION, $13, $pop243, $12
	call    	check@FUNCTION, $11, $12, $6
	call    	memset@FUNCTION, $13, $1, $12
	call    	check@FUNCTION, $11, $12, $1
	i32.add 	$12=, $12, $0
	copy_local	$13=, $2
	i32.ne  	$push244=, $12, $7
	br_if   	$pop244, .LBB2_43
.LBB2_44:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_45
	i32.store8	$push245=, u+6($2), $10
	i32.store8	$push246=, u+7($2), $pop245
	i32.store8	$push247=, u+8($2), $pop246
	i32.store8	$push248=, u+9($2), $pop247
	i32.store8	$push249=, u+10($2), $pop248
	i32.store8	$push250=, u+11($2), $pop249
	i32.store8	$push251=, u+12($2), $pop250
	i32.store8	$push252=, u+13($2), $pop251
	i32.store8	$push253=, u+14($2), $pop252
	i32.store8	$push254=, u+15($2), $pop253
	i32.store8	$push255=, u+16($2), $pop254
	i32.store8	$push256=, u+17($2), $pop255
	i32.store8	$push257=, u+18($2), $pop256
	i32.store8	$push258=, u+19($2), $pop257
	i32.store8	$push259=, u+20($2), $pop258
	i32.store8	$push260=, u+21($2), $pop259
	i32.store8	$push261=, u+22($2), $pop260
	i32.store8	$push262=, u+23($2), $pop261
	i32.store8	$push263=, u+24($2), $pop262
	i32.store8	$push264=, u+25($2), $pop263
	i32.store8	$push265=, u+26($2), $pop264
	i32.store8	$push266=, u+27($2), $pop265
	i32.store8	$push267=, u+28($2), $pop266
	i32.store8	$push268=, u+29($2), $pop267
	i32.store8	$discard=, u+30($2), $pop268
	i32.store	$discard=, u($2), $8
	i32.const	$11=, u+7
	i32.store16	$discard=, u+4($2), $9
	call    	memset@FUNCTION, $11, $2, $13
	i32.const	$12=, 7
	call    	check@FUNCTION, $12, $13, $2
	i32.load8_u	$push269=, A($2)
	call    	memset@FUNCTION, $11, $pop269, $13
	call    	check@FUNCTION, $12, $13, $6
	call    	memset@FUNCTION, $11, $1, $13
	call    	check@FUNCTION, $12, $13, $1
	i32.add 	$13=, $13, $0
	i32.ne  	$push270=, $13, $7
	br_if   	$pop270, .LBB2_44
.LBB2_45:                               # %for.end149
	i32.const	$push271=, 0
	call    	exit@FUNCTION, $pop271
	unreachable
.LBB2_46:                               # %if.then23.i287
	call    	abort@FUNCTION
	unreachable
.LBB2_47:                               # %if.then23.i250
	call    	abort@FUNCTION
	unreachable
.LBB2_48:                               # %if.then23.i
	call    	abort@FUNCTION
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
