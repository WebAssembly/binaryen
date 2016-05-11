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
	i32.const	$push17=, 0
	i32.load	$12=, i($pop17)
	i32.const	$push110=, 0
	i32.load	$13=, j($pop110)
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push107=, j+4($pop108)
	tee_local	$push106=, $17=, $pop107
	i32.const	$push105=, 0
	i32.load	$push104=, i+4($pop105)
	tee_local	$push103=, $16=, $pop104
	i32.add 	$push3=, $pop106, $pop103
	i32.store	$0=, res+4($pop109), $pop3
	block
	i32.const	$push102=, 0
	i32.add 	$push2=, $13, $12
	i32.store	$push101=, res($pop102), $pop2
	tee_local	$push100=, $15=, $pop101
	i32.const	$push18=, 160
	i32.ne  	$push19=, $pop100, $pop18
	br_if   	0, $pop19       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push20=, 113
	i32.ne  	$push21=, $0, $pop20
	br_if   	0, $pop21       # 0: down to label1
# BB#2:                                 # %verify.exit
	i32.const	$push22=, 0
	i32.mul 	$push4=, $13, $12
	i32.store	$1=, res($pop22), $pop4
	i32.const	$push111=, 0
	i32.mul 	$push5=, $17, $16
	i32.store	$2=, res+4($pop111), $pop5
	i32.const	$push23=, 1500
	i32.ne  	$push24=, $1, $pop23
	br_if   	0, $pop24       # 0: down to label1
# BB#3:                                 # %verify.exit
	i32.const	$push25=, 1300
	i32.ne  	$push26=, $2, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#4:                                 # %verify.exit48
	i32.div_s	$14=, $16, $17
	i32.const	$push27=, 0
	i32.div_s	$push6=, $12, $13
	i32.store	$3=, res($pop27), $pop6
	i32.const	$push112=, 0
	i32.store	$discard=, res+4($pop112), $14
	i32.const	$push28=, 15
	i32.ne  	$push29=, $3, $pop28
	br_if   	0, $pop29       # 0: down to label1
# BB#5:                                 # %verify.exit48
	i32.const	$push30=, 7
	i32.ne  	$push31=, $14, $pop30
	br_if   	0, $pop31       # 0: down to label1
# BB#6:                                 # %verify.exit54
	i32.const	$push32=, 0
	i32.and 	$push7=, $13, $12
	i32.store	$4=, res($pop32), $pop7
	i32.const	$push113=, 0
	i32.and 	$push8=, $17, $16
	i32.store	$5=, res+4($pop113), $pop8
	i32.const	$push33=, 2
	i32.ne  	$push34=, $4, $pop33
	br_if   	0, $pop34       # 0: down to label1
# BB#7:                                 # %verify.exit54
	i32.const	$push35=, 4
	i32.ne  	$push36=, $5, $pop35
	br_if   	0, $pop36       # 0: down to label1
# BB#8:                                 # %verify.exit60
	i32.const	$push37=, 0
	i32.or  	$push9=, $13, $12
	i32.store	$6=, res($pop37), $pop9
	i32.const	$push114=, 0
	i32.or  	$push10=, $17, $16
	i32.store	$7=, res+4($pop114), $pop10
	i32.const	$push38=, 158
	i32.ne  	$push39=, $6, $pop38
	br_if   	0, $pop39       # 0: down to label1
# BB#9:                                 # %verify.exit60
	i32.const	$push40=, 109
	i32.ne  	$push41=, $7, $pop40
	br_if   	0, $pop41       # 0: down to label1
# BB#10:                                # %verify.exit66
	i32.const	$push42=, 0
	i32.xor 	$push11=, $12, $13
	i32.store	$13=, res($pop42), $pop11
	i32.const	$push115=, 0
	i32.xor 	$push12=, $16, $17
	i32.store	$17=, res+4($pop115), $pop12
	i32.const	$push43=, 156
	i32.ne  	$push44=, $13, $pop43
	br_if   	0, $pop44       # 0: down to label1
# BB#11:                                # %verify.exit66
	i32.const	$push45=, 105
	i32.ne  	$push46=, $17, $pop45
	br_if   	0, $pop46       # 0: down to label1
# BB#12:                                # %verify.exit72
	i32.const	$push47=, 0
	i32.const	$push118=, 0
	i32.sub 	$push13=, $pop118, $12
	i32.store	$8=, res($pop47), $pop13
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.sub 	$push14=, $pop116, $16
	i32.store	$9=, res+4($pop117), $pop14
	i32.const	$push48=, -150
	i32.ne  	$push49=, $8, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#13:                                # %verify.exit72
	i32.const	$push50=, -100
	i32.ne  	$push51=, $9, $pop50
	br_if   	0, $pop51       # 0: down to label1
# BB#14:                                # %verify.exit78
	i32.const	$push53=, 0
	i32.const	$push52=, -1
	i32.xor 	$push15=, $12, $pop52
	i32.store	$10=, res($pop53), $pop15
	i32.const	$push120=, 0
	i32.const	$push119=, -1
	i32.xor 	$push16=, $16, $pop119
	i32.store	$11=, res+4($pop120), $pop16
	i32.const	$push54=, 150
	i32.ne  	$push55=, $12, $pop54
	br_if   	0, $pop55       # 0: down to label1
# BB#15:                                # %verify.exit78
	i32.const	$push56=, -101
	i32.ne  	$push57=, $11, $pop56
	br_if   	0, $pop57       # 0: down to label1
# BB#16:                                # %verify.exit84
	i32.const	$push70=, 0
	i32.add 	$push59=, $1, $15
	i32.add 	$push62=, $pop59, $4
	i32.add 	$push63=, $pop62, $6
	i32.add 	$push66=, $pop63, $13
	i32.sub 	$push67=, $pop66, $12
	i32.add 	$push69=, $pop67, $10
	i32.store	$12=, k($pop70), $pop69
	i32.const	$push123=, 0
	i32.add 	$push60=, $2, $0
	i32.add 	$push61=, $pop60, $5
	i32.add 	$push64=, $pop61, $7
	i32.add 	$push65=, $pop64, $17
	i32.sub 	$push68=, $pop65, $16
	i32.add 	$push58=, $pop68, $11
	i32.store	$16=, k+4($pop123), $pop58
	i32.const	$push122=, 0
	i32.store	$discard=, res($pop122), $12
	i32.const	$push121=, 0
	i32.store	$discard=, res+4($pop121), $16
	i32.const	$push71=, 1675
	i32.ne  	$push72=, $12, $pop71
	br_if   	0, $pop72       # 0: down to label1
# BB#17:                                # %verify.exit84
	i32.const	$push73=, 1430
	i32.ne  	$push74=, $16, $pop73
	br_if   	0, $pop74       # 0: down to label1
# BB#18:                                # %verify.exit90
	i32.const	$push87=, 0
	i32.mul 	$push76=, $1, $15
	i32.mul 	$push79=, $pop76, $4
	i32.mul 	$push80=, $pop79, $6
	i32.mul 	$push83=, $pop80, $13
	i32.mul 	$push84=, $pop83, $8
	i32.mul 	$push86=, $pop84, $10
	i32.store	$12=, k($pop87), $pop86
	i32.const	$push126=, 0
	i32.mul 	$push77=, $2, $0
	i32.mul 	$push78=, $pop77, $5
	i32.mul 	$push81=, $pop78, $7
	i32.mul 	$push82=, $pop81, $17
	i32.mul 	$push85=, $pop82, $9
	i32.mul 	$push75=, $pop85, $11
	i32.store	$16=, k+4($pop126), $pop75
	i32.const	$push125=, 0
	i32.store	$discard=, res($pop125), $12
	i32.const	$push124=, 0
	i32.store	$discard=, res+4($pop124), $16
	i32.const	$push88=, 1456467968
	i32.ne  	$push89=, $12, $pop88
	br_if   	0, $pop89       # 0: down to label1
# BB#19:                                # %verify.exit90
	i32.const	$push90=, -1579586240
	i32.ne  	$push91=, $16, $pop90
	br_if   	0, $pop91       # 0: down to label1
# BB#20:                                # %verify.exit96
	i32.div_s	$12=, $0, $2
	i32.div_s	$push92=, $15, $1
	i32.div_s	$16=, $pop92, $3
	i32.div_s	$push93=, $12, $14
	i32.div_s	$12=, $pop93, $5
	i32.div_s	$push94=, $16, $4
	i32.div_s	$16=, $pop94, $6
	i32.div_s	$push95=, $12, $7
	i32.div_s	$12=, $pop95, $17
	i32.div_s	$push96=, $16, $13
	i32.div_s	$13=, $pop96, $8
	i32.div_s	$push97=, $12, $9
	i32.div_s	$12=, $pop97, $11
	i32.const	$push130=, 0
	i32.div_s	$push98=, $13, $10
	i32.store	$13=, k($pop130), $pop98
	i32.const	$push129=, 0
	i32.store	$discard=, k+4($pop129), $12
	i32.const	$push128=, 0
	i32.store	$push0=, res($pop128), $13
	i32.const	$push127=, 0
	i32.store	$push1=, res+4($pop127), $12
	i32.or  	$push99=, $pop0, $pop1
	br_if   	0, $pop99       # 0: down to label1
# BB#21:                                # %verify.exit102
	i32.const	$push131=, 0
	call    	exit@FUNCTION, $pop131
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
