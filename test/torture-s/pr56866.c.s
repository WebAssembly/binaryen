	.text
	.file	"pr56866.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push48=, 0
	i32.load	$push47=, __stack_pointer($pop48)
	i32.const	$push49=, 7712
	i32.sub 	$4=, $pop47, $pop49
	i32.const	$push50=, 0
	i32.store	__stack_pointer($pop50), $4
	i32.const	$1=, 0
	i32.const	$push54=, 5664
	i32.add 	$push55=, $4, $pop54
	i32.const	$push103=, 0
	i32.const	$push102=, 2048
	i32.call	$drop=, memset@FUNCTION, $pop55, $pop103, $pop102
	i32.const	$push56=, 2592
	i32.add 	$push57=, $4, $pop56
	i32.const	$push101=, 0
	i32.const	$push0=, 1024
	i32.call	$drop=, memset@FUNCTION, $pop57, $pop101, $pop0
	i32.const	$push58=, 1056
	i32.add 	$push59=, $4, $pop58
	i32.const	$push100=, 0
	i32.const	$push1=, 512
	i32.call	$drop=, memset@FUNCTION, $pop59, $pop100, $pop1
	i32.const	$push60=, 288
	i32.add 	$push61=, $4, $pop60
	i32.const	$push99=, 0
	i32.const	$push2=, 256
	i32.call	$drop=, memset@FUNCTION, $pop61, $pop99, $pop2
	i32.const	$push3=, 19088743
	i32.store	2592($4), $pop3
	i64.const	$push4=, 81985529216486895
	i64.store	5664($4), $pop4
	i32.const	$push5=, 17767
	i32.store16	1056($4), $pop5
	i32.const	$push6=, 115
	i32.store8	288($4), $pop6
	i32.const	$push62=, 5664
	i32.add 	$push63=, $4, $pop62
	i32.store	28($4), $pop63
	i32.const	$push64=, 2592
	i32.add 	$push65=, $4, $pop64
	i32.store	24($4), $pop65
	i32.const	$push66=, 1056
	i32.add 	$push67=, $4, $pop66
	i32.store	20($4), $pop67
	i32.const	$push68=, 288
	i32.add 	$push69=, $4, $pop68
	i32.store	16($4), $pop69
	i32.const	$push70=, 24
	i32.add 	$0=, $4, $pop70
	i32.const	$push71=, 20
	i32.add 	$2=, $4, $pop71
	i32.const	$push72=, 16
	i32.add 	$3=, $4, $pop72
	#APP
	#NO_APP
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push75=, 3616
	i32.add 	$push76=, $4, $pop75
	i32.add 	$push10=, $pop76, $1
	i32.const	$push73=, 5664
	i32.add 	$push74=, $4, $pop73
	i32.add 	$push7=, $pop74, $1
	i64.load	$push8=, 0($pop7)
	i64.const	$push106=, 56
	i64.rotl	$push9=, $pop8, $pop106
	i64.store	0($pop10), $pop9
	i32.const	$push105=, 8
	i32.add 	$1=, $1, $pop105
	i32.const	$push104=, 2048
	i32.ne  	$push11=, $1, $pop104
	br_if   	0, $pop11       # 0: up to label0
# %bb.2:                                # %for.body16.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push79=, 1568
	i32.add 	$push80=, $4, $pop79
	i32.add 	$push15=, $pop80, $1
	i32.const	$push77=, 2592
	i32.add 	$push78=, $4, $pop77
	i32.add 	$push12=, $pop78, $1
	i32.load	$push13=, 0($pop12)
	i32.const	$push109=, 24
	i32.rotl	$push14=, $pop13, $pop109
	i32.store	0($pop15), $pop14
	i32.const	$push108=, 4
	i32.add 	$1=, $1, $pop108
	i32.const	$push107=, 1024
	i32.ne  	$push16=, $1, $pop107
	br_if   	0, $pop16       # 0: up to label1
# %bb.4:                                # %for.body28.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_5:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push81=, 1056
	i32.add 	$push82=, $4, $pop81
	i32.add 	$push17=, $pop82, $1
	i32.load16_u	$0=, 0($pop17)
	i32.const	$push83=, 544
	i32.add 	$push84=, $4, $pop83
	i32.add 	$push21=, $pop84, $1
	i32.const	$push113=, 9
	i32.shr_u	$push19=, $0, $pop113
	i32.const	$push112=, 7
	i32.shl 	$push18=, $0, $pop112
	i32.or  	$push20=, $pop19, $pop18
	i32.store16	0($pop21), $pop20
	i32.const	$push111=, 2
	i32.add 	$1=, $1, $pop111
	i32.const	$push110=, 512
	i32.ne  	$push22=, $1, $pop110
	br_if   	0, $pop22       # 0: up to label2
# %bb.6:                                # %for.body43.preheader
	end_loop
	i32.const	$1=, 0
.LBB0_7:                                # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push85=, 288
	i32.add 	$push86=, $4, $pop85
	i32.add 	$push23=, $pop86, $1
	i32.load8_u	$0=, 0($pop23)
	i32.const	$push87=, 32
	i32.add 	$push88=, $4, $pop87
	i32.add 	$push27=, $pop88, $1
	i32.const	$push117=, 5
	i32.shr_u	$push25=, $0, $pop117
	i32.const	$push116=, 3
	i32.shl 	$push24=, $0, $pop116
	i32.or  	$push26=, $pop25, $pop24
	i32.store8	0($pop27), $pop26
	i32.const	$push115=, 1
	i32.add 	$1=, $1, $pop115
	i32.const	$push114=, 256
	i32.ne  	$push28=, $1, $pop114
	br_if   	0, $pop28       # 0: up to label3
# %bb.8:                                # %for.end55
	end_loop
	i32.const	$push89=, 1568
	i32.add 	$push90=, $4, $pop89
	i32.store	8($4), $pop90
	i32.const	$push91=, 3616
	i32.add 	$push92=, $4, $pop91
	i32.store	12($4), $pop92
	i32.const	$push93=, 544
	i32.add 	$push94=, $4, $pop93
	i32.store	4($4), $pop94
	i32.const	$push95=, 32
	i32.add 	$push96=, $4, $pop95
	i32.store	0($4), $pop96
	i32.const	$push97=, 8
	i32.add 	$1=, $4, $pop97
	i32.const	$push98=, 4
	i32.add 	$0=, $4, $pop98
	#APP
	#NO_APP
	block   	
	i64.load	$push30=, 3616($4)
	i64.const	$push29=, -1224658842671273011
	i64.ne  	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label4
# %bb.9:                                # %lor.lhs.false
	i64.load	$push32=, 3624($4)
	i64.eqz 	$push33=, $pop32
	i32.eqz 	$push118=, $pop33
	br_if   	0, $pop118      # 0: down to label4
# %bb.10:                               # %if.end
	i32.load	$push35=, 1568($4)
	i32.const	$push34=, 1728127813
	i32.ne  	$push36=, $pop35, $pop34
	br_if   	0, $pop36       # 0: down to label4
# %bb.11:                               # %lor.lhs.false67
	i32.load	$push37=, 1572($4)
	br_if   	0, $pop37       # 0: down to label4
# %bb.12:                               # %if.end71
	i32.load16_u	$push39=, 544($4)
	i32.const	$push38=, 45986
	i32.ne  	$push40=, $pop39, $pop38
	br_if   	0, $pop40       # 0: down to label4
# %bb.13:                               # %lor.lhs.false76
	i32.load16_u	$push41=, 546($4)
	br_if   	0, $pop41       # 0: down to label4
# %bb.14:                               # %if.end81
	i32.load8_u	$push43=, 32($4)
	i32.const	$push42=, 155
	i32.ne  	$push44=, $pop43, $pop42
	br_if   	0, $pop44       # 0: down to label4
# %bb.15:                               # %lor.lhs.false86
	i32.load8_u	$push45=, 33($4)
	br_if   	0, $pop45       # 0: down to label4
# %bb.16:                               # %if.end91
	i32.const	$push53=, 0
	i32.const	$push51=, 7712
	i32.add 	$push52=, $4, $pop51
	i32.store	__stack_pointer($pop53), $pop52
	i32.const	$push46=, 0
	return  	$pop46
.LBB0_17:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
