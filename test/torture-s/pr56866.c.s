	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push55=, __stack_pointer
	i32.const	$push52=, __stack_pointer
	i32.load	$push53=, 0($pop52)
	i32.const	$push54=, 7712
	i32.sub 	$push106=, $pop53, $pop54
	i32.store	$push113=, 0($pop55), $pop106
	tee_local	$push112=, $4=, $pop113
	i32.const	$push59=, 5664
	i32.add 	$push60=, $pop112, $pop59
	i32.const	$push111=, 0
	i32.const	$push110=, 2048
	i32.call	$drop=, memset@FUNCTION, $pop60, $pop111, $pop110
	i32.const	$push61=, 2592
	i32.add 	$push62=, $4, $pop61
	i32.const	$push109=, 0
	i32.const	$push0=, 1024
	i32.call	$drop=, memset@FUNCTION, $pop62, $pop109, $pop0
	i32.const	$push63=, 1056
	i32.add 	$push64=, $4, $pop63
	i32.const	$push108=, 0
	i32.const	$push1=, 512
	i32.call	$drop=, memset@FUNCTION, $pop64, $pop108, $pop1
	i32.const	$push65=, 288
	i32.add 	$push66=, $4, $pop65
	i32.const	$push107=, 0
	i32.const	$push2=, 256
	i32.call	$drop=, memset@FUNCTION, $pop66, $pop107, $pop2
	i32.const	$push4=, 19088743
	i32.store	$drop=, 2592($4), $pop4
	i32.const	$push5=, 17767
	i32.store16	$drop=, 1056($4), $pop5
	i32.const	$push6=, 115
	i32.store8	$drop=, 288($4), $pop6
	i64.const	$push3=, 81985529216486895
	i64.store	$drop=, 5664($4), $pop3
	i32.const	$push67=, 5664
	i32.add 	$push68=, $4, $pop67
	i32.store	$drop=, 28($4), $pop68
	i32.const	$push69=, 2592
	i32.add 	$push70=, $4, $pop69
	i32.store	$drop=, 24($4), $pop70
	i32.const	$push71=, 1056
	i32.add 	$push72=, $4, $pop71
	i32.store	$drop=, 20($4), $pop72
	i32.const	$push73=, 288
	i32.add 	$push74=, $4, $pop73
	i32.store	$drop=, 16($4), $pop74
	i32.const	$push75=, 28
	i32.add 	$5=, $4, $pop75
	i32.const	$push76=, 24
	i32.add 	$1=, $4, $pop76
	i32.const	$push77=, 20
	i32.add 	$2=, $4, $pop77
	i32.const	$push78=, 16
	i32.add 	$3=, $4, $pop78
	#APP
	#NO_APP
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push81=, 3616
	i32.add 	$push82=, $4, $pop81
	i32.add 	$push10=, $pop82, $0
	i32.const	$push79=, 5664
	i32.add 	$push80=, $4, $pop79
	i32.add 	$push7=, $pop80, $0
	i64.load	$push8=, 0($pop7)
	i64.const	$push116=, 56
	i64.rotl	$push9=, $pop8, $pop116
	i64.store	$drop=, 0($pop10), $pop9
	i32.const	$push115=, 8
	i32.add 	$0=, $0, $pop115
	i32.const	$push114=, 2048
	i32.ne  	$push11=, $0, $pop114
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %for.body16.preheader
	end_loop                        # label1:
	i32.const	$0=, 0
.LBB0_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push85=, 1568
	i32.add 	$push86=, $4, $pop85
	i32.add 	$push15=, $pop86, $0
	i32.const	$push83=, 2592
	i32.add 	$push84=, $4, $pop83
	i32.add 	$push12=, $pop84, $0
	i32.load	$push13=, 0($pop12)
	i32.const	$push119=, 24
	i32.rotl	$push14=, $pop13, $pop119
	i32.store	$drop=, 0($pop15), $pop14
	i32.const	$push118=, 4
	i32.add 	$0=, $0, $pop118
	i32.const	$push117=, 1024
	i32.ne  	$push16=, $0, $pop117
	br_if   	0, $pop16       # 0: up to label2
# BB#4:                                 # %for.body28.preheader
	end_loop                        # label3:
	i32.const	$0=, 0
.LBB0_5:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push89=, 544
	i32.add 	$push90=, $4, $pop89
	i32.add 	$push21=, $pop90, $0
	i32.const	$push87=, 1056
	i32.add 	$push88=, $4, $pop87
	i32.add 	$push17=, $pop88, $0
	i32.load16_u	$push125=, 0($pop17)
	tee_local	$push124=, $5=, $pop125
	i32.const	$push123=, 9
	i32.shr_u	$push18=, $pop124, $pop123
	i32.const	$push122=, 7
	i32.shl 	$push19=, $5, $pop122
	i32.or  	$push20=, $pop18, $pop19
	i32.store16	$drop=, 0($pop21), $pop20
	i32.const	$push121=, 2
	i32.add 	$0=, $0, $pop121
	i32.const	$push120=, 512
	i32.ne  	$push22=, $0, $pop120
	br_if   	0, $pop22       # 0: up to label4
# BB#6:                                 # %for.body43.preheader
	end_loop                        # label5:
	i32.const	$0=, 0
.LBB0_7:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push93=, 32
	i32.add 	$push94=, $4, $pop93
	i32.add 	$push27=, $pop94, $0
	i32.const	$push91=, 288
	i32.add 	$push92=, $4, $pop91
	i32.add 	$push23=, $pop92, $0
	i32.load8_u	$push131=, 0($pop23)
	tee_local	$push130=, $5=, $pop131
	i32.const	$push129=, 5
	i32.shr_u	$push24=, $pop130, $pop129
	i32.const	$push128=, 3
	i32.shl 	$push25=, $5, $pop128
	i32.or  	$push26=, $pop24, $pop25
	i32.store8	$drop=, 0($pop27), $pop26
	i32.const	$push127=, 1
	i32.add 	$0=, $0, $pop127
	i32.const	$push126=, 256
	i32.ne  	$push28=, $0, $pop126
	br_if   	0, $pop28       # 0: up to label6
# BB#8:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$push95=, 3616
	i32.add 	$push96=, $4, $pop95
	i32.store	$drop=, 12($4), $pop96
	i32.const	$push97=, 1568
	i32.add 	$push98=, $4, $pop97
	i32.store	$drop=, 8($4), $pop98
	i32.const	$push99=, 544
	i32.add 	$push100=, $4, $pop99
	i32.store	$drop=, 4($4), $pop100
	i32.const	$push101=, 32
	i32.add 	$push102=, $4, $pop101
	i32.store	$drop=, 0($4), $pop102
	i32.const	$push103=, 12
	i32.add 	$0=, $4, $pop103
	i32.const	$push104=, 8
	i32.add 	$5=, $4, $pop104
	i32.const	$push105=, 4
	i32.add 	$1=, $4, $pop105
	#APP
	#NO_APP
	block
	i64.load	$push29=, 3616($4)
	i64.const	$push30=, -1224658842671273011
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label8
# BB#9:                                 # %lor.lhs.false
	i64.load	$push32=, 3624($4)
	i64.eqz 	$push33=, $pop32
	i32.eqz 	$push138=, $pop33
	br_if   	0, $pop138      # 0: down to label8
# BB#10:                                # %if.end
	i64.load	$push133=, 1568($4)
	tee_local	$push132=, $6=, $pop133
	i32.wrap/i64	$push34=, $pop132
	i32.const	$push35=, 1728127813
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label8
# BB#11:                                # %if.end
	i64.const	$push37=, 4294967296
	i64.ge_u	$push38=, $6, $pop37
	br_if   	0, $pop38       # 0: down to label8
# BB#12:                                # %if.end71
	i32.load	$push135=, 544($4)
	tee_local	$push134=, $0=, $pop135
	i32.const	$push39=, 65535
	i32.and 	$push40=, $pop134, $pop39
	i32.const	$push41=, 45986
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label8
# BB#13:                                # %if.end71
	i32.const	$push43=, 65536
	i32.ge_u	$push44=, $0, $pop43
	br_if   	0, $pop44       # 0: down to label8
# BB#14:                                # %if.end81
	i32.load16_u	$push137=, 32($4)
	tee_local	$push136=, $0=, $pop137
	i32.const	$push45=, 255
	i32.and 	$push46=, $pop136, $pop45
	i32.const	$push47=, 155
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label8
# BB#15:                                # %if.end81
	i32.const	$push49=, 256
	i32.ge_u	$push50=, $0, $pop49
	br_if   	0, $pop50       # 0: down to label8
# BB#16:                                # %if.end91
	i32.const	$push58=, __stack_pointer
	i32.const	$push56=, 7712
	i32.add 	$push57=, $4, $pop56
	i32.store	$drop=, 0($pop58), $pop57
	i32.const	$push51=, 0
	return  	$pop51
.LBB0_17:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
