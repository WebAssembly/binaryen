	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23135.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.ne  	$push0=, $0, $2
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.ne  	$push1=, $1, $3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push24=, 0
	i32.const	$push128=, 0
	i32.load	$push127=, j+4($pop128)
	tee_local	$push126=, $17=, $pop127
	i32.const	$push125=, 0
	i32.load	$push124=, i+4($pop125)
	tee_local	$push123=, $15=, $pop124
	i32.add 	$push9=, $pop126, $pop123
	i32.store	$0=, res+4($pop24), $pop9
	block
	i32.const	$push122=, 0
	i32.const	$push121=, 0
	i32.load	$push120=, j($pop121)
	tee_local	$push119=, $16=, $pop120
	i32.const	$push118=, 0
	i32.load	$push117=, i($pop118)
	tee_local	$push116=, $14=, $pop117
	i32.add 	$push8=, $pop119, $pop116
	i32.store	$push115=, res($pop122), $pop8
	tee_local	$push114=, $1=, $pop115
	i32.const	$push25=, 160
	i32.ne  	$push26=, $pop114, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push27=, 113
	i32.ne  	$push28=, $0, $pop27
	br_if   	0, $pop28       # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push29=, 0
	i32.mul 	$push10=, $16, $14
	i32.store	$2=, res($pop29), $pop10
	i32.const	$push129=, 0
	i32.mul 	$push11=, $17, $15
	i32.store	$3=, res+4($pop129), $pop11
	i32.const	$push30=, 1500
	i32.ne  	$push31=, $2, $pop30
	br_if   	0, $pop31       # 0: down to label1
# BB#3:                                 # %verify.exit
	i32.const	$push32=, 1300
	i32.ne  	$push33=, $3, $pop32
	br_if   	0, $pop33       # 0: down to label1
# BB#4:                                 # %verify.exit48
	i32.const	$push34=, 0
	i32.div_s	$push12=, $14, $16
	i32.store	$4=, res($pop34), $pop12
	i32.const	$push130=, 0
	i32.div_s	$push13=, $15, $17
	i32.store	$5=, res+4($pop130), $pop13
	i32.const	$push35=, 15
	i32.ne  	$push36=, $4, $pop35
	br_if   	0, $pop36       # 0: down to label1
# BB#5:                                 # %verify.exit48
	i32.const	$push37=, 7
	i32.ne  	$push38=, $5, $pop37
	br_if   	0, $pop38       # 0: down to label1
# BB#6:                                 # %verify.exit54
	i32.const	$push39=, 0
	i32.and 	$push14=, $16, $14
	i32.store	$6=, res($pop39), $pop14
	i32.const	$push131=, 0
	i32.and 	$push15=, $17, $15
	i32.store	$7=, res+4($pop131), $pop15
	i32.const	$push40=, 2
	i32.ne  	$push41=, $6, $pop40
	br_if   	0, $pop41       # 0: down to label1
# BB#7:                                 # %verify.exit54
	i32.const	$push42=, 4
	i32.ne  	$push43=, $7, $pop42
	br_if   	0, $pop43       # 0: down to label1
# BB#8:                                 # %verify.exit60
	i32.const	$push44=, 0
	i32.or  	$push16=, $16, $14
	i32.store	$8=, res($pop44), $pop16
	i32.const	$push132=, 0
	i32.or  	$push17=, $17, $15
	i32.store	$9=, res+4($pop132), $pop17
	i32.const	$push45=, 158
	i32.ne  	$push46=, $8, $pop45
	br_if   	0, $pop46       # 0: down to label1
# BB#9:                                 # %verify.exit60
	i32.const	$push47=, 109
	i32.ne  	$push48=, $9, $pop47
	br_if   	0, $pop48       # 0: down to label1
# BB#10:                                # %verify.exit66
	i32.const	$push49=, 0
	i32.xor 	$push18=, $14, $16
	i32.store	$16=, res($pop49), $pop18
	i32.const	$push133=, 0
	i32.xor 	$push19=, $15, $17
	i32.store	$17=, res+4($pop133), $pop19
	i32.const	$push50=, 156
	i32.ne  	$push51=, $16, $pop50
	br_if   	0, $pop51       # 0: down to label1
# BB#11:                                # %verify.exit66
	i32.const	$push52=, 105
	i32.ne  	$push53=, $17, $pop52
	br_if   	0, $pop53       # 0: down to label1
# BB#12:                                # %verify.exit72
	i32.const	$push54=, 0
	i32.const	$push136=, 0
	i32.sub 	$push20=, $pop136, $14
	i32.store	$10=, res($pop54), $pop20
	i32.const	$push135=, 0
	i32.const	$push134=, 0
	i32.sub 	$push21=, $pop134, $15
	i32.store	$11=, res+4($pop135), $pop21
	i32.const	$push55=, -150
	i32.ne  	$push56=, $10, $pop55
	br_if   	0, $pop56       # 0: down to label1
# BB#13:                                # %verify.exit72
	i32.const	$push57=, -100
	i32.ne  	$push58=, $11, $pop57
	br_if   	0, $pop58       # 0: down to label1
# BB#14:                                # %verify.exit78
	i32.const	$push60=, 0
	i32.const	$push59=, -1
	i32.xor 	$push22=, $14, $pop59
	i32.store	$12=, res($pop60), $pop22
	i32.const	$push138=, 0
	i32.const	$push137=, -1
	i32.xor 	$push23=, $15, $pop137
	i32.store	$13=, res+4($pop138), $pop23
	i32.const	$push61=, 150
	i32.ne  	$push62=, $14, $pop61
	br_if   	0, $pop62       # 0: down to label1
# BB#15:                                # %verify.exit78
	i32.const	$push63=, -101
	i32.ne  	$push64=, $13, $pop63
	br_if   	0, $pop64       # 0: down to label1
# BB#16:                                # %verify.exit84
	i32.const	$push72=, 0
	i32.const	$push141=, 0
	i32.add 	$push66=, $2, $1
	i32.add 	$push67=, $pop66, $6
	i32.add 	$push68=, $pop67, $8
	i32.add 	$push69=, $pop68, $16
	i32.sub 	$push70=, $pop69, $14
	i32.add 	$push71=, $pop70, $12
	i32.store	$push0=, res($pop141), $pop71
	i32.store	$14=, k($pop72), $pop0
	i32.const	$push140=, 0
	i32.const	$push139=, 0
	i32.add 	$push73=, $3, $0
	i32.add 	$push74=, $pop73, $7
	i32.add 	$push75=, $pop74, $9
	i32.add 	$push76=, $pop75, $17
	i32.sub 	$push77=, $pop76, $15
	i32.add 	$push65=, $pop77, $13
	i32.store	$push1=, res+4($pop139), $pop65
	i32.store	$15=, k+4($pop140), $pop1
	i32.const	$push78=, 1675
	i32.ne  	$push79=, $14, $pop78
	br_if   	0, $pop79       # 0: down to label1
# BB#17:                                # %verify.exit84
	i32.const	$push80=, 1430
	i32.ne  	$push81=, $15, $pop80
	br_if   	0, $pop81       # 0: down to label1
# BB#18:                                # %verify.exit90
	i32.const	$push89=, 0
	i32.const	$push144=, 0
	i32.mul 	$push83=, $2, $1
	i32.mul 	$push84=, $pop83, $6
	i32.mul 	$push85=, $pop84, $8
	i32.mul 	$push86=, $pop85, $16
	i32.mul 	$push87=, $pop86, $10
	i32.mul 	$push88=, $pop87, $12
	i32.store	$push2=, res($pop144), $pop88
	i32.store	$14=, k($pop89), $pop2
	i32.const	$push143=, 0
	i32.const	$push142=, 0
	i32.mul 	$push90=, $3, $0
	i32.mul 	$push91=, $pop90, $7
	i32.mul 	$push92=, $pop91, $9
	i32.mul 	$push93=, $pop92, $17
	i32.mul 	$push94=, $pop93, $11
	i32.mul 	$push82=, $pop94, $13
	i32.store	$push3=, res+4($pop142), $pop82
	i32.store	$15=, k+4($pop143), $pop3
	i32.const	$push95=, 1456467968
	i32.ne  	$push96=, $14, $pop95
	br_if   	0, $pop96       # 0: down to label1
# BB#19:                                # %verify.exit90
	i32.const	$push97=, -1579586240
	i32.ne  	$push98=, $15, $pop97
	br_if   	0, $pop98       # 0: down to label1
# BB#20:                                # %verify.exit96
	i32.const	$push148=, 0
	i32.const	$push147=, 0
	i32.div_s	$push99=, $1, $2
	i32.div_s	$push100=, $pop99, $4
	i32.div_s	$push101=, $pop100, $6
	i32.div_s	$push102=, $pop101, $8
	i32.div_s	$push103=, $pop102, $16
	i32.div_s	$push104=, $pop103, $10
	i32.div_s	$push105=, $pop104, $12
	i32.store	$push4=, res($pop147), $pop105
	i32.store	$push5=, k($pop148), $pop4
	i32.const	$push146=, 0
	i32.const	$push145=, 0
	i32.div_s	$push106=, $0, $3
	i32.div_s	$push107=, $pop106, $5
	i32.div_s	$push108=, $pop107, $7
	i32.div_s	$push109=, $pop108, $9
	i32.div_s	$push110=, $pop109, $17
	i32.div_s	$push111=, $pop110, $11
	i32.div_s	$push112=, $pop111, $13
	i32.store	$push6=, res+4($pop145), $pop112
	i32.store	$push7=, k+4($pop146), $pop6
	i32.or  	$push113=, $pop5, $pop7
	br_if   	0, $pop113      # 0: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push149=, 0
	call    	exit@FUNCTION, $pop149
	unreachable
.LBB1_22:                               # %if.then.i101
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.data.i,"aw",@progbits
	.globl	i
	.p2align	3
i:
	.int32	150                     # 0x96
	.int32	100                     # 0x64
	.size	i, 8

	.hidden	j                       # @j
	.type	j,@object
	.section	.data.j,"aw",@progbits
	.globl	j
	.p2align	3
j:
	.int32	10                      # 0xa
	.int32	13                      # 0xd
	.size	j, 8

	.hidden	res                     # @res
	.type	res,@object
	.section	.bss.res,"aw",@nobits
	.globl	res
	.p2align	3
res:
	.skip	8
	.size	res, 8

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	3
k:
	.skip	8
	.size	k, 8


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
