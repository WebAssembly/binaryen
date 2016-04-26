	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push81=, __stack_pointer
	i32.load	$push82=, 0($pop81)
	i32.const	$push83=, 7712
	i32.sub 	$10=, $pop82, $pop83
	i32.const	$push84=, __stack_pointer
	i32.store	$discard=, 0($pop84), $10
	i32.const	$0=, 0
	i32.const	$push88=, 5664
	i32.add 	$push89=, $10, $pop88
	i32.const	$push56=, 0
	i32.const	$push55=, 2048
	i32.call	$discard=, memset@FUNCTION, $pop89, $pop56, $pop55
	i32.const	$push90=, 2592
	i32.add 	$push91=, $10, $pop90
	i32.const	$push54=, 0
	i32.const	$push0=, 1024
	i32.call	$discard=, memset@FUNCTION, $pop91, $pop54, $pop0
	i32.const	$push92=, 1056
	i32.add 	$push93=, $10, $pop92
	i32.const	$push53=, 0
	i32.const	$push1=, 512
	i32.call	$discard=, memset@FUNCTION, $pop93, $pop53, $pop1
	i32.const	$push94=, 288
	i32.add 	$push95=, $10, $pop94
	i32.const	$push52=, 0
	i32.const	$push2=, 256
	i32.call	$discard=, memset@FUNCTION, $pop95, $pop52, $pop2
	i32.const	$push4=, 19088743
	i32.store	$discard=, 2592($10), $pop4
	i32.const	$push5=, 17767
	i32.store16	$discard=, 1056($10), $pop5
	i32.const	$push6=, 115
	i32.store8	$discard=, 288($10), $pop6
	i64.const	$push3=, 81985529216486895
	i64.store	$discard=, 5664($10), $pop3
	i32.const	$push96=, 5664
	i32.add 	$push97=, $10, $pop96
	i32.store	$discard=, 28($10), $pop97
	i32.const	$push98=, 2592
	i32.add 	$push99=, $10, $pop98
	i32.store	$discard=, 24($10), $pop99
	i32.const	$push100=, 1056
	i32.add 	$push101=, $10, $pop100
	i32.store	$discard=, 20($10), $pop101
	i32.const	$push102=, 288
	i32.add 	$push103=, $10, $pop102
	i32.store	$discard=, 16($10), $pop103
	i32.const	$3=, 28
	i32.add 	$3=, $10, $3
	i32.const	$4=, 24
	i32.add 	$4=, $10, $4
	i32.const	$5=, 20
	i32.add 	$5=, $10, $5
	i32.const	$6=, 16
	i32.add 	$6=, $10, $6
	#APP
	#NO_APP
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push104=, 3616
	i32.add 	$push105=, $10, $pop104
	i32.add 	$push10=, $pop105, $0
	i32.const	$push106=, 5664
	i32.add 	$push107=, $10, $pop106
	i32.add 	$push7=, $pop107, $0
	i64.load	$push8=, 0($pop7)
	i64.const	$push59=, 56
	i64.rotl	$push9=, $pop8, $pop59
	i64.store	$discard=, 0($pop10), $pop9
	i32.const	$push58=, 8
	i32.add 	$0=, $0, $pop58
	i32.const	$push57=, 2048
	i32.ne  	$push11=, $0, $pop57
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %for.body16.preheader
	end_loop                        # label1:
	i32.const	$0=, 0
.LBB0_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push108=, 1568
	i32.add 	$push109=, $10, $pop108
	i32.add 	$push15=, $pop109, $0
	i32.const	$push110=, 2592
	i32.add 	$push111=, $10, $pop110
	i32.add 	$push12=, $pop111, $0
	i32.load	$push13=, 0($pop12)
	i32.const	$push62=, 24
	i32.rotl	$push14=, $pop13, $pop62
	i32.store	$discard=, 0($pop15), $pop14
	i32.const	$push61=, 4
	i32.add 	$0=, $0, $pop61
	i32.const	$push60=, 1024
	i32.ne  	$push16=, $0, $pop60
	br_if   	0, $pop16       # 0: up to label2
# BB#4:                                 # %for.body28.preheader
	end_loop                        # label3:
	i32.const	$0=, 0
.LBB0_5:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push112=, 544
	i32.add 	$push113=, $10, $pop112
	i32.add 	$push21=, $pop113, $0
	i32.const	$push114=, 1056
	i32.add 	$push115=, $10, $pop114
	i32.add 	$push17=, $pop115, $0
	i32.load16_u	$push68=, 0($pop17)
	tee_local	$push67=, $1=, $pop68
	i32.const	$push66=, 9
	i32.shr_u	$push18=, $pop67, $pop66
	i32.const	$push65=, 7
	i32.shl 	$push19=, $1, $pop65
	i32.or  	$push20=, $pop18, $pop19
	i32.store16	$discard=, 0($pop21), $pop20
	i32.const	$push64=, 2
	i32.add 	$0=, $0, $pop64
	i32.const	$push63=, 512
	i32.ne  	$push22=, $0, $pop63
	br_if   	0, $pop22       # 0: up to label4
# BB#6:                                 # %for.body43.preheader
	end_loop                        # label5:
	i32.const	$0=, 0
.LBB0_7:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label6:
	i32.const	$push116=, 32
	i32.add 	$push117=, $10, $pop116
	i32.add 	$push27=, $pop117, $0
	i32.const	$push118=, 288
	i32.add 	$push119=, $10, $pop118
	i32.add 	$push23=, $pop119, $0
	i32.load8_u	$push74=, 0($pop23)
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 5
	i32.shr_u	$push24=, $pop73, $pop72
	i32.const	$push71=, 3
	i32.shl 	$push25=, $1, $pop71
	i32.or  	$push26=, $pop24, $pop25
	i32.store8	$discard=, 0($pop27), $pop26
	i32.const	$push70=, 1
	i32.add 	$0=, $0, $pop70
	i32.const	$push69=, 256
	i32.ne  	$push28=, $0, $pop69
	br_if   	0, $pop28       # 0: up to label6
# BB#8:                                 # %for.end55
	end_loop                        # label7:
	i32.const	$push120=, 3616
	i32.add 	$push121=, $10, $pop120
	i32.store	$discard=, 12($10), $pop121
	i32.const	$push122=, 1568
	i32.add 	$push123=, $10, $pop122
	i32.store	$discard=, 8($10), $pop123
	i32.const	$push124=, 544
	i32.add 	$push125=, $10, $pop124
	i32.store	$discard=, 4($10), $pop125
	i32.const	$push126=, 32
	i32.add 	$push127=, $10, $pop126
	i32.store	$discard=, 0($10), $pop127
	i32.const	$7=, 12
	i32.add 	$7=, $10, $7
	i32.const	$8=, 8
	i32.add 	$8=, $10, $8
	i32.const	$9=, 4
	i32.add 	$9=, $10, $9
	#APP
	#NO_APP
	block
	i64.load	$push29=, 3616($10)
	i64.const	$push30=, -1224658842671273011
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label8
# BB#9:                                 # %lor.lhs.false
	i64.load	$push32=, 3624($10)
	i64.eqz 	$push33=, $pop32
	i32.const	$push128=, 0
	i32.eq  	$push129=, $pop33, $pop128
	br_if   	0, $pop129      # 0: down to label8
# BB#10:                                # %if.end
	i64.load	$push76=, 1568($10)
	tee_local	$push75=, $2=, $pop76
	i32.wrap/i64	$push34=, $pop75
	i32.const	$push35=, 1728127813
	i32.ne  	$push36=, $pop34, $pop35
	br_if   	0, $pop36       # 0: down to label8
# BB#11:                                # %if.end
	i64.const	$push37=, 4294967296
	i64.ge_u	$push38=, $2, $pop37
	br_if   	0, $pop38       # 0: down to label8
# BB#12:                                # %if.end71
	i32.load	$push78=, 544($10)
	tee_local	$push77=, $0=, $pop78
	i32.const	$push39=, 65535
	i32.and 	$push40=, $pop77, $pop39
	i32.const	$push41=, 45986
	i32.ne  	$push42=, $pop40, $pop41
	br_if   	0, $pop42       # 0: down to label8
# BB#13:                                # %if.end71
	i32.const	$push43=, 65536
	i32.ge_u	$push44=, $0, $pop43
	br_if   	0, $pop44       # 0: down to label8
# BB#14:                                # %if.end81
	i32.load16_u	$push80=, 32($10)
	tee_local	$push79=, $0=, $pop80
	i32.const	$push45=, 255
	i32.and 	$push46=, $pop79, $pop45
	i32.const	$push47=, 155
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label8
# BB#15:                                # %if.end81
	i32.const	$push49=, 256
	i32.ge_u	$push50=, $0, $pop49
	br_if   	0, $pop50       # 0: down to label8
# BB#16:                                # %if.end91
	i32.const	$push51=, 0
	i32.const	$push87=, __stack_pointer
	i32.const	$push85=, 7712
	i32.add 	$push86=, $10, $pop85
	i32.store	$discard=, 0($pop87), $pop86
	return  	$pop51
.LBB0_17:                               # %if.then90
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 3.9.0 "
