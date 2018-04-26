	.text
	.file	"pr23135.c"
	.section	.text.verify,"ax",@progbits
	.hidden	verify                  # -- Begin function verify
	.globl	verify
	.type	verify,@function
verify:                                 # @verify
	.param  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.ne  	$push0=, $0, $2
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %entry
	i32.ne  	$push1=, $1, $3
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	verify, .Lfunc_end0-verify
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push88=, 0
	i32.load	$1=, i+4($pop88)
	i32.const	$push87=, 0
	i32.load	$5=, j+4($pop87)
	i32.add 	$7=, $5, $1
	i32.const	$push86=, 0
	i32.store	res+4($pop86), $7
	i32.const	$push85=, 0
	i32.load	$0=, i($pop85)
	i32.const	$push84=, 0
	i32.load	$4=, j($pop84)
	i32.add 	$6=, $4, $0
	i32.const	$push83=, 0
	i32.store	res($pop83), $6
	block   	
	i32.const	$push0=, 160
	i32.ne  	$push1=, $6, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 113
	i32.ne  	$push3=, $7, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.2:                                # %verify.exit
	i32.mul 	$8=, $4, $0
	i32.const	$push4=, 0
	i32.store	res($pop4), $8
	i32.mul 	$9=, $5, $1
	i32.const	$push89=, 0
	i32.store	res+4($pop89), $9
	i32.const	$push5=, 1500
	i32.ne  	$push6=, $8, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.3:                                # %verify.exit
	i32.const	$push7=, 1300
	i32.ne  	$push8=, $9, $pop7
	br_if   	0, $pop8        # 0: down to label1
# %bb.4:                                # %verify.exit48
	i32.div_s	$10=, $0, $4
	i32.const	$push9=, 0
	i32.store	res($pop9), $10
	i32.div_s	$11=, $1, $5
	i32.const	$push90=, 0
	i32.store	res+4($pop90), $11
	i32.const	$push10=, 15
	i32.ne  	$push11=, $10, $pop10
	br_if   	0, $pop11       # 0: down to label1
# %bb.5:                                # %verify.exit48
	i32.const	$push12=, 7
	i32.ne  	$push13=, $11, $pop12
	br_if   	0, $pop13       # 0: down to label1
# %bb.6:                                # %verify.exit54
	i32.and 	$12=, $4, $0
	i32.const	$push14=, 0
	i32.store	res($pop14), $12
	i32.and 	$13=, $5, $1
	i32.const	$push91=, 0
	i32.store	res+4($pop91), $13
	i32.const	$push15=, 2
	i32.ne  	$push16=, $12, $pop15
	br_if   	0, $pop16       # 0: down to label1
# %bb.7:                                # %verify.exit54
	i32.const	$push17=, 4
	i32.ne  	$push18=, $13, $pop17
	br_if   	0, $pop18       # 0: down to label1
# %bb.8:                                # %verify.exit60
	i32.or  	$14=, $4, $0
	i32.const	$push19=, 0
	i32.store	res($pop19), $14
	i32.or  	$15=, $5, $1
	i32.const	$push92=, 0
	i32.store	res+4($pop92), $15
	i32.const	$push20=, 158
	i32.ne  	$push21=, $14, $pop20
	br_if   	0, $pop21       # 0: down to label1
# %bb.9:                                # %verify.exit60
	i32.const	$push22=, 109
	i32.ne  	$push23=, $15, $pop22
	br_if   	0, $pop23       # 0: down to label1
# %bb.10:                               # %verify.exit66
	i32.xor 	$4=, $4, $0
	i32.const	$push24=, 0
	i32.store	res($pop24), $4
	i32.xor 	$5=, $5, $1
	i32.const	$push93=, 0
	i32.store	res+4($pop93), $5
	i32.const	$push25=, 156
	i32.ne  	$push26=, $4, $pop25
	br_if   	0, $pop26       # 0: down to label1
# %bb.11:                               # %verify.exit66
	i32.const	$push27=, 105
	i32.ne  	$push28=, $5, $pop27
	br_if   	0, $pop28       # 0: down to label1
# %bb.12:                               # %verify.exit72
	i32.const	$push96=, 0
	i32.sub 	$3=, $pop96, $1
	i32.const	$push95=, 0
	i32.sub 	$2=, $pop95, $0
	i32.const	$push29=, 0
	i32.store	res($pop29), $2
	i32.const	$push94=, 0
	i32.store	res+4($pop94), $3
	i32.const	$push30=, -150
	i32.ne  	$push31=, $2, $pop30
	br_if   	0, $pop31       # 0: down to label1
# %bb.13:                               # %verify.exit72
	i32.const	$push32=, -100
	i32.ne  	$push33=, $3, $pop32
	br_if   	0, $pop33       # 0: down to label1
# %bb.14:                               # %verify.exit78
	i32.const	$push34=, -1
	i32.xor 	$16=, $0, $pop34
	i32.const	$push35=, 0
	i32.store	res($pop35), $16
	i32.const	$push98=, -1
	i32.xor 	$17=, $1, $pop98
	i32.const	$push97=, 0
	i32.store	res+4($pop97), $17
	i32.const	$push36=, 150
	i32.ne  	$push37=, $0, $pop36
	br_if   	0, $pop37       # 0: down to label1
# %bb.15:                               # %verify.exit78
	i32.const	$push38=, -101
	i32.ne  	$push39=, $17, $pop38
	br_if   	0, $pop39       # 0: down to label1
# %bb.16:                               # %verify.exit84
	i32.sub 	$push40=, $16, $0
	i32.add 	$push41=, $pop40, $8
	i32.add 	$push42=, $pop41, $6
	i32.add 	$push43=, $pop42, $12
	i32.add 	$push44=, $pop43, $14
	i32.add 	$0=, $pop44, $4
	i32.const	$push45=, 0
	i32.store	res($pop45), $0
	i32.const	$push101=, 0
	i32.store	k($pop101), $0
	i32.sub 	$push46=, $17, $1
	i32.add 	$push47=, $pop46, $9
	i32.add 	$push48=, $pop47, $7
	i32.add 	$push49=, $pop48, $13
	i32.add 	$push50=, $pop49, $15
	i32.add 	$1=, $pop50, $5
	i32.const	$push100=, 0
	i32.store	res+4($pop100), $1
	i32.const	$push99=, 0
	i32.store	k+4($pop99), $1
	i32.const	$push51=, 1675
	i32.ne  	$push52=, $0, $pop51
	br_if   	0, $pop52       # 0: down to label1
# %bb.17:                               # %verify.exit84
	i32.const	$push53=, 1430
	i32.ne  	$push54=, $1, $pop53
	br_if   	0, $pop54       # 0: down to label1
# %bb.18:                               # %verify.exit90
	i32.mul 	$push55=, $16, $2
	i32.mul 	$push56=, $pop55, $8
	i32.mul 	$push57=, $pop56, $6
	i32.mul 	$push58=, $pop57, $12
	i32.mul 	$push59=, $pop58, $14
	i32.mul 	$0=, $pop59, $4
	i32.const	$push60=, 0
	i32.store	res($pop60), $0
	i32.const	$push104=, 0
	i32.store	k($pop104), $0
	i32.mul 	$push61=, $17, $3
	i32.mul 	$push62=, $pop61, $9
	i32.mul 	$push63=, $pop62, $7
	i32.mul 	$push64=, $pop63, $13
	i32.mul 	$push65=, $pop64, $15
	i32.mul 	$1=, $pop65, $5
	i32.const	$push103=, 0
	i32.store	res+4($pop103), $1
	i32.const	$push102=, 0
	i32.store	k+4($pop102), $1
	i32.const	$push66=, 1456467968
	i32.ne  	$push67=, $0, $pop66
	br_if   	0, $pop67       # 0: down to label1
# %bb.19:                               # %verify.exit90
	i32.const	$push68=, -1579586240
	i32.ne  	$push69=, $1, $pop68
	br_if   	0, $pop69       # 0: down to label1
# %bb.20:                               # %verify.exit96
	i32.div_s	$push70=, $6, $8
	i32.div_s	$push71=, $pop70, $10
	i32.div_s	$push72=, $pop71, $12
	i32.div_s	$push73=, $pop72, $14
	i32.div_s	$push74=, $pop73, $4
	i32.div_s	$push75=, $pop74, $2
	i32.div_s	$6=, $pop75, $16
	i32.const	$push108=, 0
	i32.store	res($pop108), $6
	i32.const	$push107=, 0
	i32.store	k($pop107), $6
	i32.div_s	$push76=, $7, $9
	i32.div_s	$push77=, $pop76, $11
	i32.div_s	$push78=, $pop77, $13
	i32.div_s	$push79=, $pop78, $15
	i32.div_s	$push80=, $pop79, $5
	i32.div_s	$push81=, $pop80, $3
	i32.div_s	$0=, $pop81, $17
	i32.const	$push106=, 0
	i32.store	res+4($pop106), $0
	i32.const	$push105=, 0
	i32.store	k+4($pop105), $0
	i32.or  	$push82=, $0, $6
	br_if   	0, $pop82       # 0: down to label1
# %bb.21:                               # %verify.exit102
	i32.const	$push109=, 0
	call    	exit@FUNCTION, $pop109
	unreachable
.LBB1_22:                               # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
