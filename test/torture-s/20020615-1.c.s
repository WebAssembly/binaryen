	.text
	.file	"20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints              # -- Begin function line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i32.const	$push52=, 0
	i32.load	$push6=, 4($2)
	i32.load	$push5=, 4($1)
	i32.sub 	$push51=, $pop6, $pop5
	tee_local	$push50=, $5=, $pop51
	i32.sub 	$push7=, $pop52, $pop50
	i32.load	$push49=, 8($0)
	tee_local	$push48=, $4=, $pop49
	i32.select	$push47=, $pop7, $5, $pop48
	tee_local	$push46=, $6=, $pop47
	i32.const	$push45=, 0
	i32.load	$push3=, 0($2)
	i32.load	$push2=, 0($1)
	i32.sub 	$push44=, $pop3, $pop2
	tee_local	$push43=, $2=, $pop44
	i32.sub 	$push4=, $pop45, $pop43
	i32.load	$push42=, 4($0)
	tee_local	$push41=, $3=, $pop42
	i32.select	$push40=, $pop4, $2, $pop41
	tee_local	$push39=, $7=, $pop40
	i32.load	$push38=, 0($0)
	tee_local	$push37=, $1=, $pop38
	i32.select	$push36=, $pop46, $pop39, $pop37
	tee_local	$push35=, $2=, $pop36
	i32.const	$push8=, 31
	i32.shr_s	$push34=, $2, $pop8
	tee_local	$push33=, $0=, $pop34
	i32.add 	$push9=, $pop35, $pop33
	i32.xor 	$5=, $pop9, $0
	i32.select	$push32=, $7, $6, $1
	tee_local	$push31=, $0=, $pop32
	i32.const	$push30=, 31
	i32.shr_s	$push29=, $0, $pop30
	tee_local	$push28=, $6=, $pop29
	i32.add 	$push10=, $pop31, $pop28
	i32.xor 	$6=, $pop10, $6
	block   	
	block   	
	i32.eqz 	$push60=, $0
	br_if   	0, $pop60       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push53=, 4
	i32.shr_s	$push1=, $6, $pop53
	i32.gt_s	$push11=, $5, $pop1
	br_if   	0, $pop11       # 0: down to label1
# BB#2:                                 # %if.then21
	i32.const	$push16=, 2
	i32.const	$push15=, 1
	i32.const	$push13=, 0
	i32.gt_s	$push14=, $0, $pop13
	i32.select	$push55=, $pop16, $pop15, $pop14
	tee_local	$push54=, $0=, $pop55
	i32.const	$push17=, 3
	i32.xor 	$push18=, $pop54, $pop17
	i32.select	$push12=, $4, $3, $1
	i32.select	$8=, $pop18, $0, $pop12
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.eqz 	$push61=, $2
	br_if   	0, $pop61       # 0: down to label0
# BB#4:                                 # %if.else
	i32.const	$push56=, 4
	i32.shr_s	$push19=, $5, $pop56
	i32.gt_s	$push20=, $6, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %if.then31
	i32.const	$push21=, 29
	i32.shr_u	$push22=, $2, $pop21
	i32.const	$push23=, 4
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push59=, 4
	i32.add 	$push58=, $pop24, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push25=, 12
	i32.xor 	$push26=, $pop57, $pop25
	i32.select	$push0=, $3, $4, $1
	i32.select	$push27=, $pop26, $0, $pop0
	return  	$pop27
.LBB0_6:                                # %if.end40
	end_block                       # label0:
	copy_local	$push62=, $8
                                        # fallthrough-return: $pop62
	.endfunc
.Lfunc_end0:
	.size	line_hints, .Lfunc_end0-line_hints
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push4=, 0
	i32.const	$push85=, 0
	i32.load	$push6=, main.gsf+8($pop85)
	i32.const	$push84=, 0
	i32.load	$push5=, main.gsf($pop84)
	i32.sub 	$push83=, $pop6, $pop5
	tee_local	$push82=, $3=, $pop83
	i32.sub 	$push7=, $pop4, $pop82
	i32.const	$push81=, 0
	i32.load	$push80=, main.fh+4($pop81)
	tee_local	$push79=, $0=, $pop80
	i32.select	$push78=, $pop7, $3, $pop79
	tee_local	$push77=, $7=, $pop78
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i32.load	$push9=, main.gsf+12($pop75)
	i32.const	$push74=, 0
	i32.load	$push8=, main.gsf+4($pop74)
	i32.sub 	$push73=, $pop9, $pop8
	tee_local	$push72=, $3=, $pop73
	i32.sub 	$push10=, $pop76, $pop72
	i32.const	$push71=, 0
	i32.load	$push70=, main.fh+8($pop71)
	tee_local	$push69=, $1=, $pop70
	i32.select	$push68=, $pop10, $3, $pop69
	tee_local	$push67=, $8=, $pop68
	i32.const	$push66=, 0
	i32.load	$push65=, main.fh($pop66)
	tee_local	$push64=, $2=, $pop65
	i32.select	$push63=, $pop77, $pop67, $pop64
	tee_local	$push62=, $3=, $pop63
	i32.eqz 	$push165=, $pop62
	br_if   	0, $pop165      # 0: down to label2
# BB#1:                                 # %entry
	i32.select	$push92=, $8, $7, $2
	tee_local	$push91=, $7=, $pop92
	i32.const	$push11=, 31
	i32.shr_s	$push90=, $7, $pop11
	tee_local	$push89=, $7=, $pop90
	i32.add 	$push12=, $pop91, $pop89
	i32.xor 	$push2=, $pop12, $7
	i32.const	$push88=, 31
	i32.shr_s	$push87=, $3, $pop88
	tee_local	$push86=, $7=, $pop87
	i32.add 	$push13=, $3, $pop86
	i32.xor 	$push14=, $pop13, $7
	i32.const	$push15=, 4
	i32.shr_s	$push3=, $pop14, $pop15
	i32.gt_s	$push16=, $pop2, $pop3
	br_if   	0, $pop16       # 0: down to label2
# BB#2:                                 # %line_hints.exit
	i32.const	$push20=, 2
	i32.const	$push19=, 1
	i32.const	$push96=, 0
	i32.gt_s	$push18=, $3, $pop96
	i32.select	$push95=, $pop20, $pop19, $pop18
	tee_local	$push94=, $3=, $pop95
	i32.const	$push21=, 3
	i32.xor 	$push22=, $pop94, $pop21
	i32.select	$push17=, $1, $0, $2
	i32.select	$push23=, $pop22, $3, $pop17
	i32.const	$push93=, 1
	i32.ne  	$push24=, $pop23, $pop93
	br_if   	0, $pop24       # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i32.const	$push132=, 0
	i32.const	$push131=, 0
	i32.load	$push29=, main.gsf+28($pop131)
	i32.const	$push130=, 0
	i32.load	$push28=, main.gsf+20($pop130)
	i32.sub 	$push129=, $pop29, $pop28
	tee_local	$push128=, $8=, $pop129
	i32.sub 	$push127=, $pop132, $pop128
	tee_local	$push126=, $5=, $pop127
	i32.const	$push125=, 0
	i32.load	$push124=, main.fh+20($pop125)
	tee_local	$push123=, $10=, $pop124
	i32.select	$push122=, $pop126, $8, $pop123
	tee_local	$push121=, $3=, $pop122
	i32.const	$push120=, 0
	i32.const	$push119=, 0
	i32.load	$push27=, main.gsf+24($pop119)
	i32.const	$push118=, 0
	i32.load	$push26=, main.gsf+16($pop118)
	i32.sub 	$push117=, $pop27, $pop26
	tee_local	$push116=, $0=, $pop117
	i32.sub 	$push115=, $pop120, $pop116
	tee_local	$push114=, $4=, $pop115
	i32.const	$push113=, 0
	i32.load	$push112=, main.fh+16($pop113)
	tee_local	$push111=, $9=, $pop112
	i32.select	$push110=, $pop114, $0, $pop111
	tee_local	$push109=, $6=, $pop110
	i32.const	$push108=, 0
	i32.load	$push107=, main.fh+12($pop108)
	tee_local	$push106=, $7=, $pop107
	i32.select	$push105=, $pop121, $pop109, $pop106
	tee_local	$push104=, $2=, $pop105
	i32.const	$push30=, 31
	i32.shr_s	$push103=, $2, $pop30
	tee_local	$push102=, $1=, $pop103
	i32.add 	$push31=, $pop104, $pop102
	i32.xor 	$1=, $pop31, $1
	i32.select	$push101=, $6, $3, $7
	tee_local	$push100=, $3=, $pop101
	i32.const	$push99=, 31
	i32.shr_s	$push98=, $3, $pop99
	tee_local	$push97=, $6=, $pop98
	i32.add 	$push32=, $pop100, $pop97
	i32.xor 	$6=, $pop32, $6
	block   	
	i32.eqz 	$push166=, $3
	br_if   	0, $pop166      # 0: down to label3
# BB#4:                                 # %lor.lhs.false
	i32.const	$push133=, 4
	i32.shr_s	$push25=, $6, $pop133
	i32.le_s	$push33=, $1, $pop25
	br_if   	1, $pop33       # 1: down to label2
.LBB1_5:                                # %if.else.i82
	end_block                       # label3:
	i32.eqz 	$push167=, $2
	br_if   	0, $pop167      # 0: down to label2
# BB#6:                                 # %if.else.i82
	i32.const	$push134=, 4
	i32.shr_s	$push34=, $1, $pop134
	i32.gt_s	$push35=, $6, $pop34
	br_if   	0, $pop35       # 0: down to label2
# BB#7:                                 # %line_hints.exit89
	i32.const	$push36=, 29
	i32.shr_u	$push37=, $2, $pop36
	i32.const	$push138=, 4
	i32.and 	$push38=, $pop37, $pop138
	i32.const	$push137=, 4
	i32.add 	$push136=, $pop38, $pop137
	tee_local	$push135=, $3=, $pop136
	i32.const	$push39=, 12
	i32.xor 	$push40=, $pop135, $pop39
	i32.select	$push0=, $9, $10, $7
	i32.select	$push41=, $pop40, $3, $pop0
	i32.const	$push42=, 8
	i32.ne  	$push43=, $pop41, $pop42
	br_if   	0, $pop43       # 0: down to label2
# BB#8:                                 # %lor.lhs.false3
	i32.const	$push45=, 0
	i32.load	$push159=, main.fh+32($pop45)
	tee_local	$push158=, $1=, $pop159
	i32.select	$push157=, $5, $8, $pop158
	tee_local	$push156=, $3=, $pop157
	i32.const	$push155=, 0
	i32.load	$push154=, main.fh+28($pop155)
	tee_local	$push153=, $6=, $pop154
	i32.select	$push152=, $4, $0, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 0
	i32.load	$push149=, main.fh+24($pop150)
	tee_local	$push148=, $7=, $pop149
	i32.select	$push147=, $pop156, $pop151, $pop148
	tee_local	$push146=, $2=, $pop147
	i32.const	$push46=, 31
	i32.shr_s	$push145=, $2, $pop46
	tee_local	$push144=, $8=, $pop145
	i32.add 	$push47=, $pop146, $pop144
	i32.xor 	$8=, $pop47, $8
	i32.select	$push143=, $0, $3, $7
	tee_local	$push142=, $3=, $pop143
	i32.const	$push141=, 31
	i32.shr_s	$push140=, $3, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.add 	$push48=, $pop142, $pop139
	i32.xor 	$0=, $pop48, $0
	block   	
	i32.eqz 	$push168=, $3
	br_if   	0, $pop168      # 0: down to label4
# BB#9:                                 # %lor.lhs.false3
	i32.const	$push160=, 4
	i32.shr_s	$push44=, $0, $pop160
	i32.le_s	$push49=, $8, $pop44
	br_if   	1, $pop49       # 1: down to label2
.LBB1_10:                               # %if.else.i40
	end_block                       # label4:
	i32.eqz 	$push169=, $2
	br_if   	0, $pop169      # 0: down to label2
# BB#11:                                # %if.else.i40
	i32.const	$push51=, 4
	i32.shr_s	$push50=, $8, $pop51
	i32.gt_s	$push52=, $0, $pop50
	br_if   	0, $pop52       # 0: down to label2
# BB#12:                                # %line_hints.exit47
	i32.const	$push53=, 29
	i32.shr_u	$push54=, $2, $pop53
	i32.const	$push55=, 4
	i32.and 	$push56=, $pop54, $pop55
	i32.const	$push164=, 4
	i32.add 	$push163=, $pop56, $pop164
	tee_local	$push162=, $3=, $pop163
	i32.const	$push57=, 12
	i32.xor 	$push58=, $pop162, $pop57
	i32.select	$push1=, $6, $1, $7
	i32.select	$push59=, $pop58, $3, $pop1
	i32.const	$push161=, 4
	i32.ne  	$push60=, $pop59, $pop161
	br_if   	0, $pop60       # 0: down to label2
# BB#13:                                # %if.end
	i32.const	$push61=, 0
	call    	exit@FUNCTION, $pop61
	unreachable
.LBB1_14:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	main.fh,@object         # @main.fh
	.section	.data.main.fh,"aw",@progbits
	.p2align	4
main.fh:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.skip	12
	.size	main.fh, 36

	.type	main.gsf,@object        # @main.gsf
	.section	.data.main.gsf,"aw",@progbits
	.p2align	4
main.gsf:
	.int32	196608                  # 0x30000
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	80216                   # 0x13958
	.int32	196608                  # 0x30000
	.int32	98697                   # 0x18189
	.int32	196608                  # 0x30000
	.size	main.gsf, 32


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
