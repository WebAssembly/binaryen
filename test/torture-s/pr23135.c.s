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
	i32.const	$push18=, 0
	i32.load	$13=, i($pop18)
	i32.const	$push118=, 0
	i32.load	$14=, j($pop118)
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.load	$push115=, j+4($pop116)
	tee_local	$push114=, $17=, $pop115
	i32.const	$push113=, 0
	i32.load	$push112=, i+4($pop113)
	tee_local	$push111=, $16=, $pop112
	i32.add 	$push3=, $pop114, $pop111
	i32.store	$0=, res+4($pop117), $pop3
	block
	i32.const	$push110=, 0
	i32.add 	$push2=, $14, $13
	i32.store	$push109=, res($pop110), $pop2
	tee_local	$push108=, $15=, $pop109
	i32.const	$push19=, 160
	i32.ne  	$push20=, $pop108, $pop19
	br_if   	0, $pop20       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push21=, 113
	i32.ne  	$push22=, $0, $pop21
	br_if   	0, $pop22       # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push23=, 0
	i32.mul 	$push4=, $14, $13
	i32.store	$1=, res($pop23), $pop4
	i32.const	$push119=, 0
	i32.mul 	$push5=, $17, $16
	i32.store	$2=, res+4($pop119), $pop5
	i32.const	$push24=, 1500
	i32.ne  	$push25=, $1, $pop24
	br_if   	0, $pop25       # 0: down to label1
# BB#3:                                 # %verify.exit
	i32.const	$push26=, 1300
	i32.ne  	$push27=, $2, $pop26
	br_if   	0, $pop27       # 0: down to label1
# BB#4:                                 # %verify.exit48
	i32.const	$push28=, 0
	i32.div_s	$push6=, $13, $14
	i32.store	$3=, res($pop28), $pop6
	i32.const	$push120=, 0
	i32.div_s	$push7=, $16, $17
	i32.store	$4=, res+4($pop120), $pop7
	i32.const	$push29=, 15
	i32.ne  	$push30=, $3, $pop29
	br_if   	0, $pop30       # 0: down to label1
# BB#5:                                 # %verify.exit48
	i32.const	$push31=, 7
	i32.ne  	$push32=, $4, $pop31
	br_if   	0, $pop32       # 0: down to label1
# BB#6:                                 # %verify.exit54
	i32.const	$push33=, 0
	i32.and 	$push8=, $14, $13
	i32.store	$5=, res($pop33), $pop8
	i32.const	$push121=, 0
	i32.and 	$push9=, $17, $16
	i32.store	$6=, res+4($pop121), $pop9
	i32.const	$push34=, 2
	i32.ne  	$push35=, $5, $pop34
	br_if   	0, $pop35       # 0: down to label1
# BB#7:                                 # %verify.exit54
	i32.const	$push36=, 4
	i32.ne  	$push37=, $6, $pop36
	br_if   	0, $pop37       # 0: down to label1
# BB#8:                                 # %verify.exit60
	i32.const	$push38=, 0
	i32.or  	$push10=, $14, $13
	i32.store	$7=, res($pop38), $pop10
	i32.const	$push122=, 0
	i32.or  	$push11=, $17, $16
	i32.store	$8=, res+4($pop122), $pop11
	i32.const	$push39=, 158
	i32.ne  	$push40=, $7, $pop39
	br_if   	0, $pop40       # 0: down to label1
# BB#9:                                 # %verify.exit60
	i32.const	$push41=, 109
	i32.ne  	$push42=, $8, $pop41
	br_if   	0, $pop42       # 0: down to label1
# BB#10:                                # %verify.exit66
	i32.const	$push43=, 0
	i32.xor 	$push12=, $13, $14
	i32.store	$14=, res($pop43), $pop12
	i32.const	$push123=, 0
	i32.xor 	$push13=, $16, $17
	i32.store	$17=, res+4($pop123), $pop13
	i32.const	$push44=, 156
	i32.ne  	$push45=, $14, $pop44
	br_if   	0, $pop45       # 0: down to label1
# BB#11:                                # %verify.exit66
	i32.const	$push46=, 105
	i32.ne  	$push47=, $17, $pop46
	br_if   	0, $pop47       # 0: down to label1
# BB#12:                                # %verify.exit72
	i32.const	$push48=, 0
	i32.const	$push126=, 0
	i32.sub 	$push14=, $pop126, $13
	i32.store	$9=, res($pop48), $pop14
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.sub 	$push15=, $pop124, $16
	i32.store	$10=, res+4($pop125), $pop15
	i32.const	$push49=, -150
	i32.ne  	$push50=, $9, $pop49
	br_if   	0, $pop50       # 0: down to label1
# BB#13:                                # %verify.exit72
	i32.const	$push51=, -100
	i32.ne  	$push52=, $10, $pop51
	br_if   	0, $pop52       # 0: down to label1
# BB#14:                                # %verify.exit78
	i32.const	$push54=, 0
	i32.const	$push53=, -1
	i32.xor 	$push16=, $13, $pop53
	i32.store	$11=, res($pop54), $pop16
	i32.const	$push128=, 0
	i32.const	$push127=, -1
	i32.xor 	$push17=, $16, $pop127
	i32.store	$12=, res+4($pop128), $pop17
	i32.const	$push55=, 150
	i32.ne  	$push56=, $13, $pop55
	br_if   	0, $pop56       # 0: down to label1
# BB#15:                                # %verify.exit78
	i32.const	$push57=, -101
	i32.ne  	$push58=, $12, $pop57
	br_if   	0, $pop58       # 0: down to label1
# BB#16:                                # %verify.exit84
	i32.const	$push71=, 0
	i32.add 	$push60=, $1, $15
	i32.add 	$push63=, $pop60, $5
	i32.add 	$push64=, $pop63, $7
	i32.add 	$push67=, $pop64, $14
	i32.sub 	$push68=, $pop67, $13
	i32.add 	$push70=, $pop68, $11
	i32.store	$13=, k($pop71), $pop70
	i32.const	$push131=, 0
	i32.add 	$push61=, $2, $0
	i32.add 	$push62=, $pop61, $6
	i32.add 	$push65=, $pop62, $8
	i32.add 	$push66=, $pop65, $17
	i32.sub 	$push69=, $pop66, $16
	i32.add 	$push59=, $pop69, $12
	i32.store	$16=, k+4($pop131), $pop59
	i32.const	$push130=, 0
	i32.store	$drop=, res($pop130), $13
	i32.const	$push129=, 0
	i32.store	$drop=, res+4($pop129), $16
	i32.const	$push72=, 1675
	i32.ne  	$push73=, $13, $pop72
	br_if   	0, $pop73       # 0: down to label1
# BB#17:                                # %verify.exit84
	i32.const	$push74=, 1430
	i32.ne  	$push75=, $16, $pop74
	br_if   	0, $pop75       # 0: down to label1
# BB#18:                                # %verify.exit90
	i32.const	$push88=, 0
	i32.mul 	$push77=, $1, $15
	i32.mul 	$push80=, $pop77, $5
	i32.mul 	$push81=, $pop80, $7
	i32.mul 	$push84=, $pop81, $14
	i32.mul 	$push85=, $pop84, $9
	i32.mul 	$push87=, $pop85, $11
	i32.store	$13=, k($pop88), $pop87
	i32.const	$push134=, 0
	i32.mul 	$push78=, $2, $0
	i32.mul 	$push79=, $pop78, $6
	i32.mul 	$push82=, $pop79, $8
	i32.mul 	$push83=, $pop82, $17
	i32.mul 	$push86=, $pop83, $10
	i32.mul 	$push76=, $pop86, $12
	i32.store	$16=, k+4($pop134), $pop76
	i32.const	$push133=, 0
	i32.store	$drop=, res($pop133), $13
	i32.const	$push132=, 0
	i32.store	$drop=, res+4($pop132), $16
	i32.const	$push89=, 1456467968
	i32.ne  	$push90=, $13, $pop89
	br_if   	0, $pop90       # 0: down to label1
# BB#19:                                # %verify.exit90
	i32.const	$push91=, -1579586240
	i32.ne  	$push92=, $16, $pop91
	br_if   	0, $pop92       # 0: down to label1
# BB#20:                                # %verify.exit96
	i32.const	$push138=, 0
	i32.div_s	$push94=, $15, $1
	i32.div_s	$push95=, $pop94, $3
	i32.div_s	$push98=, $pop95, $5
	i32.div_s	$push99=, $pop98, $7
	i32.div_s	$push102=, $pop99, $14
	i32.div_s	$push103=, $pop102, $9
	i32.div_s	$push106=, $pop103, $11
	i32.store	$13=, k($pop138), $pop106
	i32.const	$push137=, 0
	i32.div_s	$push93=, $0, $2
	i32.div_s	$push96=, $pop93, $4
	i32.div_s	$push97=, $pop96, $6
	i32.div_s	$push100=, $pop97, $8
	i32.div_s	$push101=, $pop100, $17
	i32.div_s	$push104=, $pop101, $10
	i32.div_s	$push105=, $pop104, $12
	i32.store	$14=, k+4($pop137), $pop105
	i32.const	$push136=, 0
	i32.store	$push0=, res($pop136), $13
	i32.const	$push135=, 0
	i32.store	$push1=, res+4($pop135), $14
	i32.or  	$push107=, $pop0, $pop1
	br_if   	0, $pop107      # 0: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push139=, 0
	call    	exit@FUNCTION, $pop139
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
