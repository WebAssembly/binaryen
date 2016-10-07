	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push50=, 0
	i32.const	$push47=, 0
	i32.load	$push48=, __stack_pointer($pop47)
	i32.const	$push49=, 7712
	i32.sub 	$push107=, $pop48, $pop49
	tee_local	$push106=, $5=, $pop107
	i32.store	__stack_pointer($pop50), $pop106
	i32.const	$1=, 0
	i32.const	$push54=, 5664
	i32.add 	$push55=, $5, $pop54
	i32.const	$push105=, 0
	i32.const	$push104=, 2048
	i32.call	$drop=, memset@FUNCTION, $pop55, $pop105, $pop104
	i32.const	$push56=, 2592
	i32.add 	$push57=, $5, $pop56
	i32.const	$push103=, 0
	i32.const	$push0=, 1024
	i32.call	$drop=, memset@FUNCTION, $pop57, $pop103, $pop0
	i32.const	$push58=, 1056
	i32.add 	$push59=, $5, $pop58
	i32.const	$push102=, 0
	i32.const	$push1=, 512
	i32.call	$drop=, memset@FUNCTION, $pop59, $pop102, $pop1
	i32.const	$push60=, 288
	i32.add 	$push61=, $5, $pop60
	i32.const	$push101=, 0
	i32.const	$push2=, 256
	i32.call	$drop=, memset@FUNCTION, $pop61, $pop101, $pop2
	i64.const	$push3=, 81985529216486895
	i64.store	5664($5), $pop3
	i32.const	$push4=, 19088743
	i32.store	2592($5), $pop4
	i32.const	$push5=, 17767
	i32.store16	1056($5), $pop5
	i32.const	$push6=, 115
	i32.store8	288($5), $pop6
	i32.const	$push62=, 5664
	i32.add 	$push63=, $5, $pop62
	i32.store	28($5), $pop63
	i32.const	$push64=, 2592
	i32.add 	$push65=, $5, $pop64
	i32.store	24($5), $pop65
	i32.const	$push66=, 1056
	i32.add 	$push67=, $5, $pop66
	i32.store	20($5), $pop67
	i32.const	$push68=, 288
	i32.add 	$push69=, $5, $pop68
	i32.store	16($5), $pop69
	i32.const	$push70=, 28
	i32.add 	$0=, $5, $pop70
	i32.const	$push71=, 24
	i32.add 	$2=, $5, $pop71
	i32.const	$push72=, 20
	i32.add 	$3=, $5, $pop72
	i32.const	$push73=, 16
	i32.add 	$4=, $5, $pop73
	#APP
	#NO_APP
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push76=, 3616
	i32.add 	$push77=, $5, $pop76
	i32.add 	$push10=, $pop77, $1
	i32.const	$push74=, 5664
	i32.add 	$push75=, $5, $pop74
	i32.add 	$push7=, $pop75, $1
	i64.load	$push8=, 0($pop7)
	i64.const	$push112=, 56
	i64.rotl	$push9=, $pop8, $pop112
	i64.store	0($pop10), $pop9
	i32.const	$push111=, 8
	i32.add 	$push110=, $1, $pop111
	tee_local	$push109=, $1=, $pop110
	i32.const	$push108=, 2048
	i32.ne  	$push11=, $pop109, $pop108
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %for.body16.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push80=, 1568
	i32.add 	$push81=, $5, $pop80
	i32.add 	$push15=, $pop81, $1
	i32.const	$push78=, 2592
	i32.add 	$push79=, $5, $pop78
	i32.add 	$push12=, $pop79, $1
	i32.load	$push13=, 0($pop12)
	i32.const	$push117=, 24
	i32.rotl	$push14=, $pop13, $pop117
	i32.store	0($pop15), $pop14
	i32.const	$push116=, 4
	i32.add 	$push115=, $1, $pop116
	tee_local	$push114=, $1=, $pop115
	i32.const	$push113=, 1024
	i32.ne  	$push16=, $pop114, $pop113
	br_if   	0, $pop16       # 0: up to label1
# BB#4:                                 # %for.body28.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_5:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push84=, 544
	i32.add 	$push85=, $5, $pop84
	i32.add 	$push21=, $pop85, $1
	i32.const	$push82=, 1056
	i32.add 	$push83=, $5, $pop82
	i32.add 	$push17=, $pop83, $1
	i32.load16_u	$push125=, 0($pop17)
	tee_local	$push124=, $0=, $pop125
	i32.const	$push123=, 9
	i32.shr_u	$push19=, $pop124, $pop123
	i32.const	$push122=, 7
	i32.shl 	$push18=, $0, $pop122
	i32.or  	$push20=, $pop19, $pop18
	i32.store16	0($pop21), $pop20
	i32.const	$push121=, 2
	i32.add 	$push120=, $1, $pop121
	tee_local	$push119=, $1=, $pop120
	i32.const	$push118=, 512
	i32.ne  	$push22=, $pop119, $pop118
	br_if   	0, $pop22       # 0: up to label2
# BB#6:                                 # %for.body43.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_7:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push88=, 32
	i32.add 	$push89=, $5, $pop88
	i32.add 	$push27=, $pop89, $1
	i32.const	$push86=, 288
	i32.add 	$push87=, $5, $pop86
	i32.add 	$push23=, $pop87, $1
	i32.load8_u	$push133=, 0($pop23)
	tee_local	$push132=, $0=, $pop133
	i32.const	$push131=, 5
	i32.shr_u	$push25=, $pop132, $pop131
	i32.const	$push130=, 3
	i32.shl 	$push24=, $0, $pop130
	i32.or  	$push26=, $pop25, $pop24
	i32.store8	0($pop27), $pop26
	i32.const	$push129=, 1
	i32.add 	$push128=, $1, $pop129
	tee_local	$push127=, $1=, $pop128
	i32.const	$push126=, 256
	i32.ne  	$push28=, $pop127, $pop126
	br_if   	0, $pop28       # 0: up to label3
# BB#8:                                 # %for.end55
	end_loop
	i32.const	$push90=, 3616
	i32.add 	$push91=, $5, $pop90
	i32.store	12($5), $pop91
	i32.const	$push92=, 1568
	i32.add 	$push93=, $5, $pop92
	i32.store	8($5), $pop93
	i32.const	$push94=, 544
	i32.add 	$push95=, $5, $pop94
	i32.store	4($5), $pop95
	i32.const	$push96=, 32
	i32.add 	$push97=, $5, $pop96
	i32.store	0($5), $pop97
	i32.const	$push98=, 12
	i32.add 	$1=, $5, $pop98
	i32.const	$push99=, 8
	i32.add 	$0=, $5, $pop99
	i32.const	$push100=, 4
	i32.add 	$2=, $5, $pop100
	#APP
	#NO_APP
	block   	
	i64.load	$push30=, 3616($5)
	i64.const	$push29=, -1224658842671273011
	i64.ne  	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label4
# BB#9:                                 # %lor.lhs.false
	i64.load	$push32=, 3624($5)
	i64.eqz 	$push33=, $pop32
	i32.eqz 	$push134=, $pop33
	br_if   	0, $pop134      # 0: down to label4
# BB#10:                                # %if.end
	i32.load	$push35=, 1568($5)
	i32.const	$push34=, 1728127813
	i32.ne  	$push36=, $pop35, $pop34
	br_if   	0, $pop36       # 0: down to label4
# BB#11:                                # %lor.lhs.false67
	i32.load	$push37=, 1572($5)
	br_if   	0, $pop37       # 0: down to label4
# BB#12:                                # %if.end71
	i32.load16_u	$push39=, 544($5)
	i32.const	$push38=, 45986
	i32.ne  	$push40=, $pop39, $pop38
	br_if   	0, $pop40       # 0: down to label4
# BB#13:                                # %lor.lhs.false76
	i32.load16_u	$push41=, 546($5)
	br_if   	0, $pop41       # 0: down to label4
# BB#14:                                # %if.end81
	i32.load8_u	$push43=, 32($5)
	i32.const	$push42=, 155
	i32.ne  	$push44=, $pop43, $pop42
	br_if   	0, $pop44       # 0: down to label4
# BB#15:                                # %lor.lhs.false86
	i32.load8_u	$push45=, 33($5)
	br_if   	0, $pop45       # 0: down to label4
# BB#16:                                # %if.end91
	i32.const	$push53=, 0
	i32.const	$push51=, 7712
	i32.add 	$push52=, $5, $pop51
	i32.store	__stack_pointer($pop53), $pop52
	i32.const	$push46=, 0
	return  	$pop46
.LBB0_17:                               # %if.then90
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
