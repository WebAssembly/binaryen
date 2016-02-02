	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020615-1.c"
	.section	.text.line_hints,"ax",@progbits
	.hidden	line_hints
	.globl	line_hints
	.type	line_hints,@function
line_hints:                             # @line_hints
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.load	$push2=, 0($0)
	tee_local	$push50=, $7=, $pop2
	i32.load	$push0=, 4($0)
	tee_local	$push49=, $6=, $pop0
	i32.const	$push48=, 0
	i32.load	$push5=, 0($2)
	i32.load	$push6=, 0($1)
	i32.sub 	$push7=, $pop5, $pop6
	tee_local	$push47=, $3=, $pop7
	i32.sub 	$push11=, $pop48, $pop47
	i32.select	$push12=, $pop49, $pop11, $3
	tee_local	$push46=, $3=, $pop12
	i32.load	$push1=, 8($0)
	tee_local	$push45=, $5=, $pop1
	i32.const	$push44=, 0
	i32.load	$push8=, 4($2)
	i32.load	$push9=, 4($1)
	i32.sub 	$push10=, $pop8, $pop9
	tee_local	$push43=, $0=, $pop10
	i32.sub 	$push13=, $pop44, $pop43
	i32.select	$push14=, $pop45, $pop13, $0
	tee_local	$push42=, $1=, $pop14
	i32.select	$0=, $pop50, $pop46, $pop42
	i32.const	$push15=, 31
	i32.shr_s	$push16=, $0, $pop15
	tee_local	$push41=, $2=, $pop16
	i32.add 	$push17=, $0, $pop41
	i32.xor 	$2=, $pop17, $2
	i32.select	$1=, $7, $1, $3
	i32.const	$push40=, 31
	i32.shr_s	$push18=, $1, $pop40
	tee_local	$push39=, $3=, $pop18
	i32.add 	$push19=, $1, $pop39
	i32.xor 	$3=, $pop19, $3
	block
	block
	i32.const	$push56=, 0
	i32.eq  	$push57=, $0, $pop56
	br_if   	$pop57, 0       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push51=, 4
	i32.shr_s	$push4=, $2, $pop51
	i32.gt_s	$push20=, $3, $pop4
	br_if   	$pop20, 0       # 0: down to label1
# BB#2:                                 # %if.then21
	i32.select	$push21=, $7, $5, $6
	i32.const	$push22=, 0
	i32.gt_s	$push23=, $0, $pop22
	i32.const	$push25=, 2
	i32.const	$push24=, 1
	i32.select	$push26=, $pop23, $pop25, $pop24
	tee_local	$push52=, $0=, $pop26
	i32.const	$push27=, 3
	i32.xor 	$push28=, $pop52, $pop27
	i32.select	$4=, $pop21, $pop28, $0
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label1:
	i32.const	$push58=, 0
	i32.eq  	$push59=, $1, $pop58
	br_if   	$pop59, 0       # 0: down to label0
# BB#4:                                 # %if.else
	i32.const	$push53=, 4
	i32.shr_s	$push29=, $3, $pop53
	i32.gt_s	$push30=, $2, $pop29
	br_if   	$pop30, 0       # 0: down to label0
# BB#5:                                 # %if.then31
	i32.select	$push3=, $7, $6, $5
	i32.const	$push31=, 29
	i32.shr_u	$push32=, $1, $pop31
	i32.const	$push33=, 4
	i32.and 	$push34=, $pop32, $pop33
	i32.const	$push55=, 4
	i32.add 	$push35=, $pop34, $pop55
	tee_local	$push54=, $0=, $pop35
	i32.const	$push36=, 12
	i32.xor 	$push37=, $pop54, $pop36
	i32.select	$push38=, $pop3, $pop37, $0
	return  	$pop38
.LBB0_6:                                # %if.end40
	end_block                       # label0:
	return  	$4
	.endfunc
.Lfunc_end0:
	.size	line_hints, .Lfunc_end0-line_hints

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i64, i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push13=, 0
	i32.load	$push3=, main.fh($pop13):p2align=4
	tee_local	$push122=, $9=, $pop3
	i32.const	$push121=, 0
	i32.load	$push0=, main.fh+4($pop121)
	tee_local	$push120=, $8=, $pop0
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i64.load	$push14=, main.gsf+8($pop118)
	tee_local	$push117=, $7=, $pop14
	i32.wrap/i64	$push15=, $pop117
	i32.const	$push116=, 0
	i64.load	$push16=, main.gsf($pop116):p2align=4
	tee_local	$push115=, $6=, $pop16
	i32.wrap/i64	$push17=, $pop115
	i32.sub 	$push18=, $pop15, $pop17
	tee_local	$push114=, $2=, $pop18
	i32.sub 	$push25=, $pop119, $pop114
	i32.select	$push26=, $pop120, $pop25, $2
	tee_local	$push113=, $1=, $pop26
	i32.const	$push112=, 0
	i64.load	$push1=, main.fh+8($pop112)
	tee_local	$push111=, $5=, $pop1
	i32.wrap/i64	$push2=, $pop111
	tee_local	$push110=, $4=, $pop2
	i32.const	$push109=, 0
	i64.const	$push19=, 32
	i64.shr_u	$push20=, $7, $pop19
	i32.wrap/i64	$push21=, $pop20
	i64.const	$push108=, 32
	i64.shr_u	$push22=, $6, $pop108
	i32.wrap/i64	$push23=, $pop22
	i32.sub 	$push24=, $pop21, $pop23
	tee_local	$push107=, $2=, $pop24
	i32.sub 	$push27=, $pop109, $pop107
	i32.select	$push28=, $pop110, $pop27, $2
	tee_local	$push106=, $3=, $pop28
	i32.select	$push4=, $pop122, $pop113, $pop106
	tee_local	$push105=, $2=, $pop4
	i32.const	$push169=, 0
	i32.eq  	$push170=, $pop105, $pop169
	br_if   	$pop170, 0      # 0: down to label2
# BB#1:                                 # %entry
	i32.select	$1=, $9, $3, $1
	i32.const	$push29=, 31
	i32.shr_s	$push33=, $1, $pop29
	tee_local	$push125=, $3=, $pop33
	i32.add 	$push34=, $1, $pop125
	i32.xor 	$push11=, $pop34, $3
	i32.const	$push124=, 31
	i32.shr_s	$push30=, $2, $pop124
	tee_local	$push123=, $1=, $pop30
	i32.add 	$push31=, $2, $pop123
	i32.xor 	$push32=, $pop31, $1
	i32.const	$push35=, 4
	i32.shr_s	$push12=, $pop32, $pop35
	i32.gt_s	$push36=, $pop11, $pop12
	br_if   	$pop36, 0       # 0: down to label2
# BB#2:                                 # %line_hints.exit
	i32.select	$push37=, $9, $4, $8
	i32.const	$push128=, 0
	i32.gt_s	$push38=, $2, $pop128
	i32.const	$push40=, 2
	i32.const	$push39=, 1
	i32.select	$push41=, $pop38, $pop40, $pop39
	tee_local	$push127=, $2=, $pop41
	i32.const	$push42=, 3
	i32.xor 	$push43=, $pop127, $pop42
	i32.select	$push44=, $pop37, $pop43, $2
	i32.const	$push126=, 1
	i32.ne  	$push45=, $pop44, $pop126
	br_if   	$pop45, 0       # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i64.const	$push60=, 4294967296
	i64.lt_u	$push61=, $5, $pop60
	tee_local	$push149=, $1=, $pop61
	i32.const	$push148=, 0
	i32.load	$push57=, main.fh+20($pop148)
	tee_local	$push147=, $13=, $pop57
	i32.const	$push146=, 0
	i32.const	$push145=, 0
	i64.load	$push47=, main.gsf+24($pop145)
	tee_local	$push144=, $7=, $pop47
	i64.const	$push51=, 32
	i64.shr_u	$push52=, $pop144, $pop51
	i32.wrap/i64	$push53=, $pop52
	i32.const	$push143=, 0
	i64.load	$push49=, main.gsf+16($pop143):p2align=4
	tee_local	$push142=, $6=, $pop49
	i64.const	$push141=, 32
	i64.shr_u	$push54=, $pop142, $pop141
	i32.wrap/i64	$push55=, $pop54
	i32.sub 	$push6=, $pop53, $pop55
	tee_local	$push140=, $3=, $pop6
	i32.sub 	$push8=, $pop146, $pop140
	tee_local	$push139=, $12=, $pop8
	i32.select	$push59=, $pop147, $pop139, $3
	tee_local	$push138=, $9=, $pop59
	i32.const	$push137=, 0
	i32.load	$push56=, main.fh+16($pop137):p2align=4
	tee_local	$push136=, $11=, $pop56
	i32.const	$push135=, 0
	i32.wrap/i64	$push48=, $7
	i32.wrap/i64	$push50=, $6
	i32.sub 	$push5=, $pop48, $pop50
	tee_local	$push134=, $8=, $pop5
	i32.sub 	$push7=, $pop135, $pop134
	tee_local	$push133=, $10=, $pop7
	i32.select	$push58=, $pop136, $pop133, $8
	tee_local	$push132=, $0=, $pop58
	i32.select	$2=, $pop149, $pop138, $pop132
	i32.const	$push62=, 31
	i32.shr_s	$push63=, $2, $pop62
	tee_local	$push131=, $4=, $pop63
	i32.add 	$push64=, $2, $pop131
	i32.xor 	$4=, $pop64, $4
	i32.select	$9=, $1, $0, $9
	i32.const	$push130=, 31
	i32.shr_s	$push65=, $9, $pop130
	tee_local	$push129=, $0=, $pop65
	i32.add 	$push66=, $9, $pop129
	i32.xor 	$0=, $pop66, $0
	block
	i32.const	$push171=, 0
	i32.eq  	$push172=, $2, $pop171
	br_if   	$pop172, 0      # 0: down to label3
# BB#4:                                 # %lor.lhs.false
	i32.const	$push150=, 4
	i32.shr_s	$push46=, $4, $pop150
	i32.le_s	$push67=, $0, $pop46
	br_if   	$pop67, 1       # 1: down to label2
.LBB1_5:                                # %if.else.i82
	end_block                       # label3:
	i32.const	$push173=, 0
	i32.eq  	$push174=, $9, $pop173
	br_if   	$pop174, 0      # 0: down to label2
# BB#6:                                 # %if.else.i82
	i32.const	$push151=, 4
	i32.shr_s	$push68=, $0, $pop151
	i32.gt_s	$push69=, $4, $pop68
	br_if   	$pop69, 0       # 0: down to label2
# BB#7:                                 # %line_hints.exit89
	i32.select	$push9=, $1, $13, $11
	i32.const	$push70=, 29
	i32.shr_u	$push71=, $9, $pop70
	i32.const	$push154=, 4
	i32.and 	$push72=, $pop71, $pop154
	i32.const	$push153=, 4
	i32.add 	$push73=, $pop72, $pop153
	tee_local	$push152=, $2=, $pop73
	i32.const	$push74=, 12
	i32.xor 	$push75=, $pop152, $pop74
	i32.select	$push76=, $pop9, $pop75, $2
	i32.const	$push77=, 8
	i32.ne  	$push78=, $pop76, $pop77
	br_if   	$pop78, 0       # 0: down to label2
# BB#8:                                 # %lor.lhs.false3
	i32.const	$push80=, 0
	i32.load	$push85=, main.fh+24($pop80):p2align=3
	tee_local	$push164=, $1=, $pop85
	i32.const	$push163=, 0
	i32.load	$push81=, main.fh+28($pop163)
	tee_local	$push162=, $4=, $pop81
	i32.select	$push83=, $pop162, $10, $8
	tee_local	$push161=, $9=, $pop83
	i32.const	$push160=, 0
	i32.load	$push82=, main.fh+32($pop160):p2align=4
	tee_local	$push159=, $0=, $pop82
	i32.select	$push84=, $pop159, $12, $3
	tee_local	$push158=, $8=, $pop84
	i32.select	$2=, $pop164, $pop161, $pop158
	i32.const	$push86=, 31
	i32.shr_s	$push87=, $2, $pop86
	tee_local	$push157=, $3=, $pop87
	i32.add 	$push88=, $2, $pop157
	i32.xor 	$3=, $pop88, $3
	i32.select	$9=, $1, $8, $9
	i32.const	$push156=, 31
	i32.shr_s	$push89=, $9, $pop156
	tee_local	$push155=, $8=, $pop89
	i32.add 	$push90=, $9, $pop155
	i32.xor 	$8=, $pop90, $8
	block
	i32.const	$push175=, 0
	i32.eq  	$push176=, $2, $pop175
	br_if   	$pop176, 0      # 0: down to label4
# BB#9:                                 # %lor.lhs.false3
	i32.const	$push165=, 4
	i32.shr_s	$push79=, $3, $pop165
	i32.le_s	$push91=, $8, $pop79
	br_if   	$pop91, 1       # 1: down to label2
.LBB1_10:                               # %if.else.i40
	end_block                       # label4:
	i32.const	$push177=, 0
	i32.eq  	$push178=, $9, $pop177
	br_if   	$pop178, 0      # 0: down to label2
# BB#11:                                # %if.else.i40
	i32.const	$push93=, 4
	i32.shr_s	$push92=, $8, $pop93
	i32.gt_s	$push94=, $3, $pop92
	br_if   	$pop94, 0       # 0: down to label2
# BB#12:                                # %line_hints.exit47
	i32.select	$push10=, $1, $4, $0
	i32.const	$push95=, 29
	i32.shr_u	$push96=, $9, $pop95
	i32.const	$push97=, 4
	i32.and 	$push98=, $pop96, $pop97
	i32.const	$push168=, 4
	i32.add 	$push99=, $pop98, $pop168
	tee_local	$push167=, $2=, $pop99
	i32.const	$push100=, 12
	i32.xor 	$push101=, $pop167, $pop100
	i32.select	$push102=, $pop10, $pop101, $2
	i32.const	$push166=, 4
	i32.ne  	$push103=, $pop102, $pop166
	br_if   	$pop103, 0      # 0: down to label2
# BB#13:                                # %if.end
	i32.const	$push104=, 0
	call    	exit@FUNCTION, $pop104
	unreachable
.LBB1_14:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 3.9.0 "
