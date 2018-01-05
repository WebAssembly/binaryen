	.text
	.file	"vprintf-chk-1.c"
	.section	.text.__vprintf_chk,"ax",@progbits
	.hidden	__vprintf_chk           # -- Begin function __vprintf_chk
	.globl	__vprintf_chk
	.type	__vprintf_chk,@function
__vprintf_chk:                          # @__vprintf_chk
	.param  	i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, should_optimize($pop3)
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store	should_optimize($pop4), $pop1
	i32.call	$push2=, vprintf@FUNCTION, $1, $2
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	__vprintf_chk, .Lfunc_end0-__vprintf_chk
                                        # -- End function
	.section	.text.inner,"ax",@progbits
	.hidden	inner                   # -- Begin function inner
	.globl	inner
	.type	inner,@function
inner:                                  # @inner
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push88=, 0
	i32.load	$push87=, __stack_pointer($pop88)
	i32.const	$push89=, 16
	i32.sub 	$2=, $pop87, $pop89
	i32.const	$push90=, 0
	i32.store	__stack_pointer($pop90), $2
	i32.store	8($2), $1
	i32.store	12($2), $1
	block   	
	i32.const	$push0=, 10
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$0, 0, 1, 2, 3, 4, 5, 8, 6, 9, 7, 10, 0 # 0: down to label13
                                        # 1: down to label12
                                        # 2: down to label11
                                        # 3: down to label10
                                        # 4: down to label9
                                        # 5: down to label8
                                        # 8: down to label5
                                        # 6: down to label7
                                        # 9: down to label4
                                        # 7: down to label6
                                        # 10: down to label3
.LBB1_2:                                # %sw.bb
	end_block                       # label13:
	i32.const	$push97=, 0
	i32.const	$push96=, 0
	i32.store	should_optimize($pop97), $pop96
	i32.const	$push95=, .L.str
	i32.load	$push79=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop95, $pop79
	i32.const	$push94=, 0
	i32.load	$push80=, should_optimize($pop94)
	i32.eqz 	$push170=, $pop80
	br_if   	11, $pop170     # 11: down to label1
# %bb.3:                                # %if.end
	i32.const	$push100=, 0
	i32.const	$push99=, 0
	i32.store	should_optimize($pop100), $pop99
	i32.const	$push98=, .L.str
	i32.load	$push81=, 8($2)
	i32.call	$push82=, __vprintf_chk@FUNCTION, $2, $pop98, $pop81
	i32.const	$push83=, 5
	i32.ne  	$push84=, $pop82, $pop83
	br_if   	11, $pop84      # 11: down to label1
# %bb.4:                                # %if.end5
	i32.const	$push85=, 0
	i32.load	$push86=, should_optimize($pop85)
	br_if   	10, $pop86      # 10: down to label2
	br      	11              # 11: down to label1
.LBB1_5:                                # %sw.bb9
	end_block                       # label12:
	i32.const	$push103=, 0
	i32.const	$push70=, 1
	i32.store	should_optimize($pop103), $pop70
	i32.const	$push102=, .L.str.1
	i32.load	$push71=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop102, $pop71
	i32.const	$push101=, 0
	i32.load	$push72=, should_optimize($pop101)
	i32.eqz 	$push171=, $pop72
	br_if   	10, $pop171     # 10: down to label1
# %bb.6:                                # %if.end13
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.store	should_optimize($pop106), $pop105
	i32.const	$push104=, .L.str.1
	i32.load	$push73=, 8($2)
	i32.call	$push74=, __vprintf_chk@FUNCTION, $2, $pop104, $pop73
	i32.const	$push75=, 6
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	10, $pop76      # 10: down to label1
# %bb.7:                                # %if.end17
	i32.const	$push77=, 0
	i32.load	$push78=, should_optimize($pop77)
	br_if   	9, $pop78       # 9: down to label2
	br      	10              # 10: down to label1
.LBB1_8:                                # %sw.bb21
	end_block                       # label11:
	i32.const	$push110=, 0
	i32.const	$push109=, 1
	i32.store	should_optimize($pop110), $pop109
	i32.const	$push108=, .L.str.2
	i32.load	$push63=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop108, $pop63
	i32.const	$push107=, 0
	i32.load	$push64=, should_optimize($pop107)
	i32.eqz 	$push172=, $pop64
	br_if   	9, $pop172      # 9: down to label1
# %bb.9:                                # %if.end25
	i32.const	$push114=, 0
	i32.const	$push113=, 0
	i32.store	should_optimize($pop114), $pop113
	i32.const	$push112=, .L.str.2
	i32.load	$push65=, 8($2)
	i32.call	$push66=, __vprintf_chk@FUNCTION, $2, $pop112, $pop65
	i32.const	$push111=, 1
	i32.ne  	$push67=, $pop66, $pop111
	br_if   	9, $pop67       # 9: down to label1
# %bb.10:                               # %if.end29
	i32.const	$push68=, 0
	i32.load	$push69=, should_optimize($pop68)
	br_if   	8, $pop69       # 8: down to label2
	br      	9               # 9: down to label1
.LBB1_11:                               # %sw.bb33
	end_block                       # label10:
	i32.const	$push117=, 0
	i32.const	$push56=, 1
	i32.store	should_optimize($pop117), $pop56
	i32.const	$push116=, .L.str.3
	i32.load	$push57=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop116, $pop57
	i32.const	$push115=, 0
	i32.load	$push58=, should_optimize($pop115)
	i32.eqz 	$push173=, $pop58
	br_if   	8, $pop173      # 8: down to label1
# %bb.12:                               # %if.end37
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.store	should_optimize($pop120), $pop119
	i32.const	$push118=, .L.str.3
	i32.load	$push59=, 8($2)
	i32.call	$push60=, __vprintf_chk@FUNCTION, $2, $pop118, $pop59
	br_if   	8, $pop60       # 8: down to label1
# %bb.13:                               # %if.end41
	i32.const	$push61=, 0
	i32.load	$push62=, should_optimize($pop61)
	br_if   	7, $pop62       # 7: down to label2
	br      	8               # 8: down to label1
.LBB1_14:                               # %sw.bb45
	end_block                       # label9:
	i32.const	$push124=, 0
	i32.const	$push123=, 0
	i32.store	should_optimize($pop124), $pop123
	i32.const	$push122=, .L.str.4
	i32.load	$push48=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop122, $pop48
	i32.const	$push121=, 0
	i32.load	$push49=, should_optimize($pop121)
	i32.eqz 	$push174=, $pop49
	br_if   	7, $pop174      # 7: down to label1
# %bb.15:                               # %if.end49
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.store	should_optimize($pop127), $pop126
	i32.const	$push125=, .L.str.4
	i32.load	$push50=, 8($2)
	i32.call	$push51=, __vprintf_chk@FUNCTION, $2, $pop125, $pop50
	i32.const	$push52=, 5
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	7, $pop53       # 7: down to label1
# %bb.16:                               # %if.end53
	i32.const	$push54=, 0
	i32.load	$push55=, should_optimize($pop54)
	br_if   	6, $pop55       # 6: down to label2
	br      	7               # 7: down to label1
.LBB1_17:                               # %sw.bb57
	end_block                       # label8:
	i32.const	$push131=, 0
	i32.const	$push130=, 0
	i32.store	should_optimize($pop131), $pop130
	i32.const	$push129=, .L.str.4
	i32.load	$push40=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop129, $pop40
	i32.const	$push128=, 0
	i32.load	$push41=, should_optimize($pop128)
	i32.eqz 	$push175=, $pop41
	br_if   	6, $pop175      # 6: down to label1
# %bb.18:                               # %if.end61
	i32.const	$push134=, 0
	i32.const	$push133=, 0
	i32.store	should_optimize($pop134), $pop133
	i32.const	$push132=, .L.str.4
	i32.load	$push42=, 8($2)
	i32.call	$push43=, __vprintf_chk@FUNCTION, $2, $pop132, $pop42
	i32.const	$push44=, 6
	i32.ne  	$push45=, $pop43, $pop44
	br_if   	6, $pop45       # 6: down to label1
# %bb.19:                               # %if.end65
	i32.const	$push46=, 0
	i32.load	$push47=, should_optimize($pop46)
	br_if   	5, $pop47       # 5: down to label2
	br      	6               # 6: down to label1
.LBB1_20:                               # %sw.bb81
	end_block                       # label7:
	i32.const	$push138=, 0
	i32.const	$push137=, 0
	i32.store	should_optimize($pop138), $pop137
	i32.const	$push136=, .L.str.4
	i32.load	$push26=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop136, $pop26
	i32.const	$push135=, 0
	i32.load	$push27=, should_optimize($pop135)
	i32.eqz 	$push176=, $pop27
	br_if   	5, $pop176      # 5: down to label1
# %bb.21:                               # %if.end85
	i32.const	$push141=, 0
	i32.const	$push140=, 0
	i32.store	should_optimize($pop141), $pop140
	i32.const	$push139=, .L.str.4
	i32.load	$push28=, 8($2)
	i32.call	$push29=, __vprintf_chk@FUNCTION, $2, $pop139, $pop28
	br_if   	5, $pop29       # 5: down to label1
# %bb.22:                               # %if.end89
	i32.const	$push30=, 0
	i32.load	$push31=, should_optimize($pop30)
	br_if   	4, $pop31       # 4: down to label2
	br      	5               # 5: down to label1
.LBB1_23:                               # %sw.bb105
	end_block                       # label6:
	i32.const	$push145=, 0
	i32.const	$push144=, 0
	i32.store	should_optimize($pop145), $pop144
	i32.const	$push143=, .L.str.6
	i32.load	$push10=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop143, $pop10
	i32.const	$push142=, 0
	i32.load	$push11=, should_optimize($pop142)
	i32.eqz 	$push177=, $pop11
	br_if   	4, $pop177      # 4: down to label1
# %bb.24:                               # %if.end109
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.store	should_optimize($pop148), $pop147
	i32.const	$push146=, .L.str.6
	i32.load	$push12=, 8($2)
	i32.call	$push13=, __vprintf_chk@FUNCTION, $2, $pop146, $pop12
	i32.const	$push14=, 7
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	4, $pop15       # 4: down to label1
# %bb.25:                               # %if.end113
	i32.const	$push16=, 0
	i32.load	$push17=, should_optimize($pop16)
	br_if   	3, $pop17       # 3: down to label2
	br      	4               # 4: down to label1
.LBB1_26:                               # %sw.bb69
	end_block                       # label5:
	i32.const	$push152=, 0
	i32.const	$push151=, 0
	i32.store	should_optimize($pop152), $pop151
	i32.const	$push150=, .L.str.4
	i32.load	$push32=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop150, $pop32
	i32.const	$push149=, 0
	i32.load	$push33=, should_optimize($pop149)
	i32.eqz 	$push178=, $pop33
	br_if   	3, $pop178      # 3: down to label1
# %bb.27:                               # %if.end73
	i32.const	$push155=, 0
	i32.const	$push154=, 0
	i32.store	should_optimize($pop155), $pop154
	i32.const	$push153=, .L.str.4
	i32.load	$push34=, 8($2)
	i32.call	$push35=, __vprintf_chk@FUNCTION, $2, $pop153, $pop34
	i32.const	$push36=, 1
	i32.ne  	$push37=, $pop35, $pop36
	br_if   	3, $pop37       # 3: down to label1
# %bb.28:                               # %if.end77
	i32.const	$push38=, 0
	i32.load	$push39=, should_optimize($pop38)
	br_if   	2, $pop39       # 2: down to label2
	br      	3               # 3: down to label1
.LBB1_29:                               # %sw.bb93
	end_block                       # label4:
	i32.const	$push159=, 0
	i32.const	$push158=, 0
	i32.store	should_optimize($pop159), $pop158
	i32.const	$push157=, .L.str.5
	i32.load	$push18=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop157, $pop18
	i32.const	$push156=, 0
	i32.load	$push19=, should_optimize($pop156)
	i32.eqz 	$push179=, $pop19
	br_if   	2, $pop179      # 2: down to label1
# %bb.30:                               # %if.end97
	i32.const	$push162=, 0
	i32.const	$push161=, 0
	i32.store	should_optimize($pop162), $pop161
	i32.const	$push160=, .L.str.5
	i32.load	$push20=, 8($2)
	i32.call	$push21=, __vprintf_chk@FUNCTION, $2, $pop160, $pop20
	i32.const	$push22=, 1
	i32.ne  	$push23=, $pop21, $pop22
	br_if   	2, $pop23       # 2: down to label1
# %bb.31:                               # %if.end101
	i32.const	$push24=, 0
	i32.load	$push25=, should_optimize($pop24)
	br_if   	1, $pop25       # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_32:                               # %sw.bb117
	end_block                       # label3:
	i32.const	$push166=, 0
	i32.const	$push165=, 0
	i32.store	should_optimize($pop166), $pop165
	i32.const	$push164=, .L.str.7
	i32.load	$push2=, 12($2)
	i32.call	$drop=, __vprintf_chk@FUNCTION, $2, $pop164, $pop2
	i32.const	$push163=, 0
	i32.load	$push3=, should_optimize($pop163)
	i32.eqz 	$push180=, $pop3
	br_if   	1, $pop180      # 1: down to label1
# %bb.33:                               # %if.end121
	i32.const	$push169=, 0
	i32.const	$push168=, 0
	i32.store	should_optimize($pop169), $pop168
	i32.const	$push167=, .L.str.7
	i32.load	$push4=, 8($2)
	i32.call	$push5=, __vprintf_chk@FUNCTION, $2, $pop167, $pop4
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label1
# %bb.34:                               # %if.end125
	i32.const	$push8=, 0
	i32.load	$push9=, should_optimize($pop8)
	i32.eqz 	$push181=, $pop9
	br_if   	1, $pop181      # 1: down to label1
.LBB1_35:                               # %sw.epilog
	end_block                       # label2:
	i32.const	$push93=, 0
	i32.const	$push91=, 16
	i32.add 	$push92=, $2, $pop91
	i32.store	__stack_pointer($pop93), $pop92
	return
.LBB1_36:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	inner, .Lfunc_end1-inner
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i32.load	$push16=, __stack_pointer($pop17)
	i32.const	$push18=, 112
	i32.sub 	$0=, $pop16, $pop18
	i32.const	$push19=, 0
	i32.store	__stack_pointer($pop19), $0
	i32.const	$push0=, 0
	i32.const	$push41=, 0
	call    	inner@FUNCTION, $pop0, $pop41
	i32.const	$push1=, 1
	i32.const	$push40=, 0
	call    	inner@FUNCTION, $pop1, $pop40
	i32.const	$push2=, 2
	i32.const	$push39=, 0
	call    	inner@FUNCTION, $pop2, $pop39
	i32.const	$push3=, 3
	i32.const	$push38=, 0
	call    	inner@FUNCTION, $pop3, $pop38
	i32.const	$push4=, .L.str
	i32.store	96($0), $pop4
	i32.const	$push5=, 4
	i32.const	$push23=, 96
	i32.add 	$push24=, $0, $pop23
	call    	inner@FUNCTION, $pop5, $pop24
	i32.const	$push6=, .L.str.1
	i32.store	80($0), $pop6
	i32.const	$push7=, 5
	i32.const	$push25=, 80
	i32.add 	$push26=, $0, $pop25
	call    	inner@FUNCTION, $pop7, $pop26
	i32.const	$push8=, .L.str.2
	i32.store	64($0), $pop8
	i32.const	$push9=, 6
	i32.const	$push27=, 64
	i32.add 	$push28=, $0, $pop27
	call    	inner@FUNCTION, $pop9, $pop28
	i32.const	$push10=, .L.str.3
	i32.store	48($0), $pop10
	i32.const	$push11=, 7
	i32.const	$push29=, 48
	i32.add 	$push30=, $0, $pop29
	call    	inner@FUNCTION, $pop11, $pop30
	i32.const	$push12=, 120
	i32.store	32($0), $pop12
	i32.const	$push13=, 8
	i32.const	$push31=, 32
	i32.add 	$push32=, $0, $pop31
	call    	inner@FUNCTION, $pop13, $pop32
	i32.const	$push37=, .L.str.1
	i32.store	16($0), $pop37
	i32.const	$push14=, 9
	i32.const	$push33=, 16
	i32.add 	$push34=, $0, $pop33
	call    	inner@FUNCTION, $pop14, $pop34
	i32.const	$push36=, 0
	i32.store	0($0), $pop36
	i32.const	$push15=, 10
	call    	inner@FUNCTION, $pop15, $0
	i32.const	$push22=, 0
	i32.const	$push20=, 112
	i32.add 	$push21=, $0, $pop20
	i32.store	__stack_pointer($pop22), $pop21
	i32.const	$push35=, 0
                                        # fallthrough-return: $pop35
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	should_optimize         # @should_optimize
	.type	should_optimize,@object
	.section	.bss.should_optimize,"aw",@nobits
	.globl	should_optimize
	.p2align	2
should_optimize:
	.int32	0                       # 0x0
	.size	should_optimize, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"hello"
	.size	.L.str, 6

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"hello\n"
	.size	.L.str.1, 7

	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"a"
	.size	.L.str.2, 2

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.skip	1
	.size	.L.str.3, 1

	.type	.L.str.4,@object        # @.str.4
.L.str.4:
	.asciz	"%s"
	.size	.L.str.4, 3

	.type	.L.str.5,@object        # @.str.5
.L.str.5:
	.asciz	"%c"
	.size	.L.str.5, 3

	.type	.L.str.6,@object        # @.str.6
.L.str.6:
	.asciz	"%s\n"
	.size	.L.str.6, 4

	.type	.L.str.7,@object        # @.str.7
.L.str.7:
	.asciz	"%d\n"
	.size	.L.str.7, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	vprintf, i32, i32, i32
