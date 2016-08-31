	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push55=, 0
	i32.const	$push52=, 0
	i32.load	$push53=, __stack_pointer($pop52)
	i32.const	$push54=, 7712
	i32.sub 	$push112=, $pop53, $pop54
	tee_local	$push111=, $6=, $pop112
	i32.store	$drop=, __stack_pointer($pop55), $pop111
	i32.const	$2=, 0
	i32.const	$push59=, 5664
	i32.add 	$push60=, $6, $pop59
	i32.const	$push110=, 0
	i32.const	$push109=, 2048
	i32.call	$drop=, memset@FUNCTION, $pop60, $pop110, $pop109
	i32.const	$push61=, 2592
	i32.add 	$push62=, $6, $pop61
	i32.const	$push108=, 0
	i32.const	$push0=, 1024
	i32.call	$drop=, memset@FUNCTION, $pop62, $pop108, $pop0
	i32.const	$push63=, 1056
	i32.add 	$push64=, $6, $pop63
	i32.const	$push107=, 0
	i32.const	$push1=, 512
	i32.call	$drop=, memset@FUNCTION, $pop64, $pop107, $pop1
	i32.const	$push65=, 288
	i32.add 	$push66=, $6, $pop65
	i32.const	$push106=, 0
	i32.const	$push2=, 256
	i32.call	$drop=, memset@FUNCTION, $pop66, $pop106, $pop2
	i64.const	$push3=, 81985529216486895
	i64.store	$drop=, 5664($6), $pop3
	i32.const	$push4=, 19088743
	i32.store	$drop=, 2592($6), $pop4
	i32.const	$push5=, 17767
	i32.store16	$drop=, 1056($6), $pop5
	i32.const	$push6=, 115
	i32.store8	$drop=, 288($6), $pop6
	i32.const	$push67=, 5664
	i32.add 	$push68=, $6, $pop67
	i32.store	$drop=, 28($6), $pop68
	i32.const	$push69=, 2592
	i32.add 	$push70=, $6, $pop69
	i32.store	$drop=, 24($6), $pop70
	i32.const	$push71=, 1056
	i32.add 	$push72=, $6, $pop71
	i32.store	$drop=, 20($6), $pop72
	i32.const	$push73=, 288
	i32.add 	$push74=, $6, $pop73
	i32.store	$drop=, 16($6), $pop74
	i32.const	$push75=, 28
	i32.add 	$0=, $6, $pop75
	i32.const	$push76=, 24
	i32.add 	$3=, $6, $pop76
	i32.const	$push77=, 20
	i32.add 	$4=, $6, $pop77
	i32.const	$push78=, 16
	i32.add 	$5=, $6, $pop78
	#APP
	#NO_APP
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push81=, 3616
	i32.add 	$push82=, $6, $pop81
	i32.add 	$push10=, $pop82, $2
	i32.const	$push79=, 5664
	i32.add 	$push80=, $6, $pop79
	i32.add 	$push7=, $pop80, $2
	i64.load	$push8=, 0($pop7)
	i64.const	$push117=, 56
	i64.rotl	$push9=, $pop8, $pop117
	i64.store	$drop=, 0($pop10), $pop9
	i32.const	$push116=, 8
	i32.add 	$push115=, $2, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 2048
	i32.ne  	$push11=, $pop114, $pop113
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %for.body16.preheader
	end_loop                        # label1:
	i32.const	$2=, 0
.LBB0_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push85=, 1568
	i32.add 	$push86=, $6, $pop85
	i32.add 	$push15=, $pop86, $2
	i32.const	$push83=, 2592
	i32.add 	$push84=, $6, $pop83
	i32.add 	$push12=, $pop84, $2
	i32.load	$push13=, 0($pop12)
	i32.const	$push122=, 24
	i32.rotl	$push14=, $pop13, $pop122
	i32.store	$drop=, 0($pop15), $pop14
	i32.const	$push121=, 4
	i32.add 	$push120=, $2, $pop121
	tee_local	$push119=, $2=, $pop120
	i32.const	$push118=, 1024
	i32.ne  	$push16=, $pop119, $pop118
	br_if   	0, $pop16       # 0: up to label2
# BB#4:                                 # %for.body28.preheader
	end_loop                        # label3:
	i32.const	$2=, 0
.LBB0_5:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push89=, 544
	i32.add 	$push90=, $6, $pop89
	i32.add 	$push21=, $pop90, $2
	i32.const	$push87=, 1056
	i32.add 	$push88=, $6, $pop87
	i32.add 	$push17=, $pop88, $2
	i32.load16_u	$push130=, 0($pop17)
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 9
	i32.shr_u	$push19=, $pop129, $pop128
	i32.const	$push127=, 7
	i32.shl 	$push18=, $0, $pop127
	i32.or  	$push20=, $pop19, $pop18
	i32.store16	$drop=, 0($pop21), $pop20
	i32.const	$push126=, 2
	i32.add 	$push125=, $2, $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push123=, 512
	i32.ne  	$push22=, $pop124, $pop123
	br_if   	0, $pop22       # 0: up to label4
# BB#6:                                 # %for.body43.preheader
	end_loop                        # label5:
	i32.const	$2=, 0
.LBB0_7:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push93=, 32
	i32.add 	$push94=, $6, $pop93
	i32.add 	$push27=, $pop94, $2
	i32.const	$push91=, 288
	i32.add 	$push92=, $6, $pop91
	i32.add 	$push23=, $pop92, $2
	i32.load8_u	$push138=, 0($pop23)
	tee_local	$push137=, $0=, $pop138
	i32.const	$push136=, 5
	i32.shr_u	$push25=, $pop137, $pop136
	i32.const	$push135=, 3
	i32.shl 	$push24=, $0, $pop135
	i32.or  	$push26=, $pop25, $pop24
	i32.store8	$drop=, 0($pop27), $pop26
	i32.const	$push134=, 1
	i32.add 	$push133=, $2, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 256
	i32.ne  	$push28=, $pop132, $pop131
	br_if   	0, $pop28       # 0: up to label6
# BB#8:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$push95=, 3616
	i32.add 	$push96=, $6, $pop95
	i32.store	$drop=, 12($6), $pop96
	i32.const	$push97=, 1568
	i32.add 	$push98=, $6, $pop97
	i32.store	$drop=, 8($6), $pop98
	i32.const	$push99=, 544
	i32.add 	$push100=, $6, $pop99
	i32.store	$drop=, 4($6), $pop100
	i32.const	$push101=, 32
	i32.add 	$push102=, $6, $pop101
	i32.store	$drop=, 0($6), $pop102
	i32.const	$push103=, 12
	i32.add 	$2=, $6, $pop103
	i32.const	$push104=, 8
	i32.add 	$0=, $6, $pop104
	i32.const	$push105=, 4
	i32.add 	$3=, $6, $pop105
	#APP
	#NO_APP
	block
	i64.load	$push30=, 3616($6)
	i64.const	$push29=, -1224658842671273011
	i64.ne  	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label8
# BB#9:                                 # %lor.lhs.false
	i64.load	$push32=, 3624($6)
	i64.eqz 	$push33=, $pop32
	i32.eqz 	$push145=, $pop33
	br_if   	0, $pop145      # 0: down to label8
# BB#10:                                # %if.end
	i64.load	$push140=, 1568($6)
	tee_local	$push139=, $1=, $pop140
	i32.wrap/i64	$push34=, $pop139
	i32.const	$push35=, 1728127813
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label8
# BB#11:                                # %if.end
	i64.const	$push37=, 4294967296
	i64.ge_u	$push38=, $1, $pop37
	br_if   	0, $pop38       # 0: down to label8
# BB#12:                                # %if.end71
	i32.load	$push142=, 544($6)
	tee_local	$push141=, $2=, $pop142
	i32.const	$push39=, 65535
	i32.and 	$push40=, $pop141, $pop39
	i32.const	$push41=, 45986
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label8
# BB#13:                                # %if.end71
	i32.const	$push43=, 65536
	i32.ge_u	$push44=, $2, $pop43
	br_if   	0, $pop44       # 0: down to label8
# BB#14:                                # %if.end81
	i32.load16_u	$push144=, 32($6)
	tee_local	$push143=, $2=, $pop144
	i32.const	$push45=, 255
	i32.and 	$push46=, $pop143, $pop45
	i32.const	$push47=, 155
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label8
# BB#15:                                # %if.end81
	i32.const	$push49=, 256
	i32.ge_u	$push50=, $2, $pop49
	br_if   	0, $pop50       # 0: down to label8
# BB#16:                                # %if.end91
	i32.const	$push58=, 0
	i32.const	$push56=, 7712
	i32.add 	$push57=, $6, $pop56
	i32.store	$drop=, __stack_pointer($pop58), $pop57
	i32.const	$push51=, 0
	return  	$pop51
.LBB0_17:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
