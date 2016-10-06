	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020226-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push2=, 0
	i32.load8_u	$push103=, uc($pop2)
	tee_local	$push102=, $0=, $pop103
	i32.const	$push4=, 8
	i32.const	$push101=, 0
	i32.load	$push100=, shift1($pop101)
	tee_local	$push99=, $1=, $pop100
	i32.sub 	$push98=, $pop4, $pop99
	tee_local	$push97=, $2=, $pop98
	i32.shl 	$push5=, $pop102, $pop97
	i32.shr_u	$push3=, $0, $1
	i32.or  	$push6=, $pop5, $pop3
	i32.const	$push96=, 835
	i32.ne  	$push7=, $pop6, $pop96
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push8=, 4
	i32.shr_u	$push10=, $0, $pop8
	i32.const	$push105=, 4
	i32.shl 	$push9=, $0, $pop105
	i32.or  	$push11=, $pop10, $pop9
	i32.const	$push104=, 835
	i32.ne  	$push12=, $pop11, $pop104
	br_if   	0, $pop12       # 0: down to label0
# BB#2:                                 # %if.end11
	i32.const	$push14=, 0
	i32.load16_u	$push110=, us($pop14)
	tee_local	$push109=, $3=, $pop110
	i32.shr_u	$push16=, $pop109, $1
	i32.const	$push13=, 16
	i32.sub 	$push108=, $pop13, $1
	tee_local	$push107=, $4=, $pop108
	i32.shl 	$push15=, $3, $pop107
	i32.or  	$push17=, $pop16, $pop15
	i32.const	$push106=, 19087651
	i32.ne  	$push18=, $pop17, $pop106
	br_if   	0, $pop18       # 0: down to label0
# BB#3:                                 # %if.end21
	i32.const	$push21=, 4
	i32.shr_u	$push22=, $3, $pop21
	i32.const	$push19=, 12
	i32.shl 	$push20=, $3, $pop19
	i32.or  	$push23=, $pop22, $pop20
	i32.const	$push111=, 19087651
	i32.ne  	$push24=, $pop23, $pop111
	br_if   	0, $pop24       # 0: down to label0
# BB#4:                                 # %if.end30
	i32.const	$push26=, 0
	i32.load	$push114=, ui($pop26)
	tee_local	$push113=, $5=, $pop114
	i32.rotr	$push27=, $pop113, $1
	i32.const	$push112=, 1073742115
	i32.ne  	$push28=, $pop27, $pop112
	br_if   	0, $pop28       # 0: down to label0
# BB#5:                                 # %if.end38
	i32.const	$push29=, 28
	i32.rotl	$push30=, $5, $pop29
	i32.const	$push115=, 1073742115
	i32.ne  	$push31=, $pop30, $pop115
	br_if   	0, $pop31       # 0: down to label0
# BB#6:                                 # %if.end45
	i32.const	$push32=, 0
	i32.load	$push120=, ul($pop32)
	tee_local	$push119=, $7=, $pop120
	i32.shr_u	$push34=, $pop119, $1
	i32.const	$push25=, 32
	i32.sub 	$push118=, $pop25, $1
	tee_local	$push117=, $6=, $pop118
	i32.shl 	$push33=, $7, $pop117
	i32.or  	$push35=, $pop34, $pop33
	i32.const	$push116=, -2128394905
	i32.ne  	$push36=, $pop35, $pop116
	br_if   	0, $pop36       # 0: down to label0
# BB#7:                                 # %if.end53
	i32.const	$push37=, 28
	i32.rotl	$push38=, $7, $pop37
	i32.const	$push121=, -2128394905
	i32.ne  	$push39=, $pop38, $pop121
	br_if   	0, $pop39       # 0: down to label0
# BB#8:                                 # %if.end60
	i32.const	$push40=, 0
	i64.load	$push126=, ull($pop40)
	tee_local	$push125=, $8=, $pop126
	i64.extend_u/i32	$push124=, $1
	tee_local	$push123=, $9=, $pop124
	i64.rotr	$push41=, $pop125, $pop123
	i64.const	$push122=, 5124095577148911
	i64.ne  	$push42=, $pop41, $pop122
	br_if   	0, $pop42       # 0: down to label0
# BB#9:                                 # %if.end69
	i64.const	$push45=, 60
	i64.rotl	$push46=, $8, $pop45
	i64.const	$push127=, 5124095577148911
	i64.ne  	$push47=, $pop46, $pop127
	br_if   	0, $pop47       # 0: down to label0
# BB#10:                                # %if.end76
	i32.const	$push48=, 0
	i32.load	$push132=, shift2($pop48)
	tee_local	$push131=, $11=, $pop132
	i64.extend_u/i32	$push130=, $pop131
	tee_local	$push129=, $10=, $pop130
	i64.rotr	$push49=, $8, $pop129
	i64.const	$push128=, 1311768467750121216
	i64.ne  	$push50=, $pop49, $pop128
	br_if   	0, $pop50       # 0: down to label0
# BB#11:                                # %if.end86
	i64.const	$push53=, 4
	i64.rotl	$push54=, $8, $pop53
	i64.const	$push133=, 1311768467750121216
	i64.ne  	$push55=, $pop54, $pop133
	br_if   	0, $pop55       # 0: down to label0
# BB#12:                                # %if.end93
	i32.shr_u	$push57=, $0, $2
	i32.shl 	$push56=, $0, $1
	i32.or  	$push58=, $pop57, $pop56
	i32.const	$push59=, 835
	i32.ne  	$push60=, $pop58, $pop59
	br_if   	0, $pop60       # 0: down to label0
# BB#13:                                # %if.end112
	i32.shl 	$push62=, $3, $1
	i32.shr_u	$push61=, $3, $4
	i32.or  	$push63=, $pop62, $pop61
	i32.const	$push134=, 74561
	i32.ne  	$push64=, $pop63, $pop134
	br_if   	0, $pop64       # 0: down to label0
# BB#14:                                # %if.end122
	i32.const	$push67=, 4
	i32.shl 	$push68=, $3, $pop67
	i32.const	$push65=, 12
	i32.shr_u	$push66=, $3, $pop65
	i32.or  	$push69=, $pop68, $pop66
	i32.const	$push135=, 74561
	i32.ne  	$push70=, $pop69, $pop135
	br_if   	0, $pop70       # 0: down to label0
# BB#15:                                # %if.end131
	i32.shl 	$push72=, $5, $1
	i32.shr_u	$push71=, $5, $6
	i32.or  	$push73=, $pop72, $pop71
	i32.const	$push136=, 74560
	i32.ne  	$push74=, $pop73, $pop136
	br_if   	0, $pop74       # 0: down to label0
# BB#16:                                # %if.end139
	i32.const	$push75=, 4
	i32.rotl	$push76=, $5, $pop75
	i32.const	$push137=, 74560
	i32.ne  	$push77=, $pop76, $pop137
	br_if   	0, $pop77       # 0: down to label0
# BB#17:                                # %if.end146
	i32.shl 	$push79=, $7, $1
	i32.shr_u	$push78=, $7, $6
	i32.or  	$push80=, $pop79, $pop78
	i32.const	$push138=, 591751041
	i32.ne  	$push81=, $pop80, $pop138
	br_if   	0, $pop81       # 0: down to label0
# BB#18:                                # %if.end154
	i32.const	$push82=, 4
	i32.rotl	$push83=, $7, $pop82
	i32.const	$push139=, 591751041
	i32.ne  	$push84=, $pop83, $pop139
	br_if   	0, $pop84       # 0: down to label0
# BB#19:                                # %if.end161
	i64.shl 	$push86=, $8, $9
	i32.const	$push43=, 64
	i32.sub 	$push44=, $pop43, $1
	i64.extend_u/i32	$push0=, $pop44
	i64.shr_u	$push85=, $8, $pop0
	i64.or  	$push87=, $pop86, $pop85
	i64.const	$push88=, 1311768467750121216
	i64.ne  	$push89=, $pop87, $pop88
	br_if   	0, $pop89       # 0: down to label0
# BB#20:                                # %if.end178
	i32.const	$push51=, 64
	i32.sub 	$push52=, $pop51, $11
	i64.extend_u/i32	$push1=, $pop52
	i64.shr_u	$push91=, $8, $pop1
	i64.shl 	$push90=, $8, $10
	i64.or  	$push92=, $pop91, $pop90
	i64.const	$push93=, 5124095577148911
	i64.ne  	$push94=, $pop92, $pop93
	br_if   	0, $pop94       # 0: down to label0
# BB#21:                                # %if.end195
	i32.const	$push95=, 0
	call    	exit@FUNCTION, $pop95
	unreachable
.LBB0_22:                               # %if.then187
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	uc                      # @uc
	.type	uc,@object
	.section	.data.uc,"aw",@progbits
	.globl	uc
uc:
	.int8	52                      # 0x34
	.size	uc, 1

	.hidden	us                      # @us
	.type	us,@object
	.section	.data.us,"aw",@progbits
	.globl	us
	.p2align	1
us:
	.int16	4660                    # 0x1234
	.size	us, 2

	.hidden	ui                      # @ui
	.type	ui,@object
	.section	.data.ui,"aw",@progbits
	.globl	ui
	.p2align	2
ui:
	.int32	4660                    # 0x1234
	.size	ui, 4

	.hidden	ul                      # @ul
	.type	ul,@object
	.section	.data.ul,"aw",@progbits
	.globl	ul
	.p2align	2
ul:
	.int32	305419896               # 0x12345678
	.size	ul, 4

	.hidden	ull                     # @ull
	.type	ull,@object
	.section	.data.ull,"aw",@progbits
	.globl	ull
	.p2align	3
ull:
	.int64	81985529234382576       # 0x12345678abcdef0
	.size	ull, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.p2align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.p2align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
