	.text
	.file	"arith-rand.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand             # -- Begin function simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, simple_rand.seed($pop0)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$0=, $pop3, $pop4
	i32.const	$push7=, 0
	i32.store	simple_rand.seed($pop7), $0
	i32.const	$push5=, 8
	i32.shr_u	$push6=, $0, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	simple_rand, .Lfunc_end0-simple_rand
                                        # -- End function
	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring        # -- Begin function random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$3=, 0
	i32.const	$push14=, 0
	i32.load	$push0=, simple_rand.seed($pop14)
	i32.const	$push13=, 1103515245
	i32.mul 	$push1=, $pop0, $pop13
	i32.const	$push12=, 12345
	i32.add 	$2=, $pop1, $pop12
	i32.const	$push11=, 0
	i32.store	simple_rand.seed($pop11), $2
	i32.const	$push10=, 9
	i32.shr_u	$push2=, $2, $pop10
	i32.const	$push9=, 15
	i32.and 	$0=, $pop2, $pop9
	block   	
	i32.eqz 	$push24=, $0
	br_if   	0, $pop24       # 0: down to label0
# %bb.1:                                # %if.else.preheader
	copy_local	$1=, $0
	i32.const	$3=, 0
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.shl 	$3=, $3, $1
	block   	
	i32.const	$push15=, 256
	i32.and 	$push3=, $2, $pop15
	i32.eqz 	$push25=, $pop3
	br_if   	0, $pop25       # 0: down to label2
# %bb.3:                                # %if.then1
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push17=, 1
	i32.shl 	$push4=, $pop17, $1
	i32.const	$push16=, -1
	i32.add 	$push5=, $pop4, $pop16
	i32.or  	$3=, $pop5, $3
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label2:
	i32.const	$push18=, 39
	i32.ge_u	$push6=, $0, $pop18
	br_if   	1, $pop6        # 1: down to label0
# %bb.5:                                # %for.cond
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push23=, 1103515245
	i32.mul 	$push7=, $2, $pop23
	i32.const	$push22=, 12345
	i32.add 	$2=, $pop7, $pop22
	i32.const	$push21=, 0
	i32.store	simple_rand.seed($pop21), $2
	i32.const	$push20=, 9
	i32.shr_u	$push8=, $2, $pop20
	i32.const	$push19=, 15
	i32.and 	$1=, $pop8, $pop19
	i32.add 	$0=, $1, $0
	br_if   	0, $1           # 0: up to label1
.LBB1_6:                                # %cleanup
	end_loop
	end_block                       # label0:
	copy_local	$push26=, $3
                                        # fallthrough-return: $pop26
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
	i32.const	$push56=, 0
	i32.load	$3=, simple_rand.seed($pop56)
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_10 Depth 2
	block   	
	block   	
	block   	
	loop    	                # label6:
	i32.const	$push60=, 1103515245
	i32.mul 	$push2=, $3, $pop60
	i32.const	$push59=, 12345
	i32.add 	$3=, $pop2, $pop59
	i32.const	$push58=, 9
	i32.shr_u	$push3=, $3, $pop58
	i32.const	$push57=, 15
	i32.and 	$2=, $pop3, $pop57
	block   	
	block   	
	i32.eqz 	$push112=, $2
	br_if   	0, $pop112      # 0: down to label8
# %bb.2:                                # %if.else.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
	copy_local	$8=, $2
.LBB2_3:                                # %if.else.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.shl 	$1=, $1, $8
	block   	
	i32.const	$push61=, 256
	i32.and 	$push4=, $3, $pop61
	i32.eqz 	$push113=, $pop4
	br_if   	0, $pop113      # 0: down to label10
# %bb.4:                                # %if.then1.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push63=, 1
	i32.shl 	$push5=, $pop63, $8
	i32.const	$push62=, -1
	i32.add 	$push6=, $pop5, $pop62
	i32.or  	$1=, $1, $pop6
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_3 Depth=2
	end_block                       # label10:
	i32.const	$push64=, 39
	i32.ge_u	$push7=, $2, $pop64
	br_if   	2, $pop7        # 2: down to label7
# %bb.6:                                # %for.cond.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push68=, 1103515245
	i32.mul 	$push8=, $3, $pop68
	i32.const	$push67=, 12345
	i32.add 	$3=, $pop8, $pop67
	i32.const	$push66=, 9
	i32.shr_u	$push9=, $3, $pop66
	i32.const	$push65=, 15
	i32.and 	$8=, $pop9, $pop65
	i32.add 	$2=, $8, $2
	br_if   	0, $8           # 0: up to label9
	br      	2               # 2: down to label7
.LBB2_7:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label8:
	i32.const	$1=, 0
.LBB2_8:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	i32.const	$push72=, 1103515245
	i32.mul 	$push10=, $3, $pop72
	i32.const	$push71=, 12345
	i32.add 	$3=, $pop10, $pop71
	i32.const	$push70=, 9
	i32.shr_u	$push11=, $3, $pop70
	i32.const	$push69=, 15
	i32.and 	$9=, $pop11, $pop69
	block   	
	i32.eqz 	$push114=, $9
	br_if   	0, $pop114      # 0: down to label11
# %bb.9:                                # %if.else.i346.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
	copy_local	$8=, $9
.LBB2_10:                               # %if.else.i346
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i32.shl 	$2=, $2, $8
	block   	
	i32.const	$push73=, 256
	i32.and 	$push12=, $3, $pop73
	i32.eqz 	$push115=, $pop12
	br_if   	0, $pop115      # 0: down to label13
# %bb.11:                               # %if.then1.i350
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push75=, 1
	i32.shl 	$push13=, $pop75, $8
	i32.const	$push74=, -1
	i32.add 	$push14=, $pop13, $pop74
	i32.or  	$2=, $2, $pop14
.LBB2_12:                               # %if.end.i353
                                        #   in Loop: Header=BB2_10 Depth=2
	end_block                       # label13:
	block   	
	i32.const	$push76=, 39
	i32.ge_u	$push15=, $9, $pop76
	br_if   	0, $pop15       # 0: down to label14
# %bb.13:                               # %for.cond.i339
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push80=, 1103515245
	i32.mul 	$push16=, $3, $pop80
	i32.const	$push79=, 12345
	i32.add 	$3=, $pop16, $pop79
	i32.const	$push78=, 9
	i32.shr_u	$push17=, $3, $pop78
	i32.const	$push77=, 15
	i32.and 	$8=, $pop17, $pop77
	i32.add 	$9=, $8, $9
	br_if   	1, $8           # 1: up to label12
.LBB2_14:                               # %random_bitstring.exit355
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	end_loop
	i32.eqz 	$push116=, $2
	br_if   	0, $pop116      # 0: down to label11
# %bb.15:                               # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.const	$push81=, 2147483647
	i32.and 	$push18=, $1, $pop81
	br_if   	0, $pop18       # 0: down to label15
# %bb.16:                               # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push82=, -1
	i32.eq  	$push19=, $2, $pop82
	br_if   	1, $pop19       # 1: down to label11
.LBB2_17:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i32.const	$push84=, 31
	i32.shr_s	$8=, $2, $pop84
	i32.rem_s	$9=, $1, $2
	i32.const	$push83=, 31
	i32.shr_s	$4=, $9, $pop83
	i32.add 	$push22=, $9, $4
	i32.xor 	$push23=, $pop22, $4
	i32.add 	$push20=, $2, $8
	i32.xor 	$push21=, $pop20, $8
	i32.ge_u	$push24=, $pop23, $pop21
	br_if   	3, $pop24       # 3: down to label4
# %bb.18:                               # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push85=, 65535
	i32.and 	$push26=, $2, $pop85
	i32.eqz 	$push117=, $pop26
	br_if   	0, $pop117      # 0: down to label11
# %bb.19:                               # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push94=, 16
	i32.shl 	$4=, $2, $pop94
	i32.const	$push93=, 16
	i32.shr_s	$8=, $4, $pop93
	i32.const	$push92=, 16
	i32.shl 	$push27=, $1, $pop92
	i32.const	$push91=, 16
	i32.shr_s	$9=, $pop27, $pop91
	i32.div_s	$push0=, $9, $8
	i32.mul 	$5=, $pop0, $8
	i32.sub 	$push28=, $9, $5
	i32.const	$push90=, 16
	i32.shl 	$6=, $pop28, $pop90
	i32.const	$push89=, 31
	i32.shr_s	$7=, $6, $pop89
	i32.const	$push88=, 16
	i32.shr_s	$6=, $6, $pop88
	i32.const	$push87=, 31
	i32.shr_s	$4=, $4, $pop87
	i32.add 	$push29=, $6, $7
	i32.xor 	$push30=, $pop29, $7
	i32.add 	$push31=, $8, $4
	i32.xor 	$push32=, $pop31, $4
	i32.const	$push86=, 65535
	i32.and 	$push33=, $pop32, $pop86
	i32.ge_s	$push34=, $pop30, $pop33
	br_if   	2, $pop34       # 2: down to label5
# %bb.20:                               # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$push35=, $5, $6
	i32.const	$push96=, 16
	i32.shl 	$push36=, $pop35, $pop96
	i32.const	$push95=, 16
	i32.shr_s	$push37=, $pop36, $pop95
	i32.ne  	$push38=, $pop37, $9
	br_if   	2, $pop38       # 2: down to label5
# %bb.21:                               # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push97=, 255
	i32.and 	$push40=, $2, $pop97
	i32.eqz 	$push118=, $pop40
	br_if   	0, $pop118      # 0: down to label11
# %bb.22:                               # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push106=, 24
	i32.shl 	$9=, $2, $pop106
	i32.const	$push105=, 24
	i32.shr_s	$8=, $9, $pop105
	i32.const	$push104=, 24
	i32.shl 	$push41=, $1, $pop104
	i32.const	$push103=, 24
	i32.shr_s	$2=, $pop41, $pop103
	i32.div_s	$push1=, $2, $8
	i32.mul 	$1=, $pop1, $8
	i32.sub 	$push42=, $2, $1
	i32.const	$push102=, 24
	i32.shl 	$4=, $pop42, $pop102
	i32.const	$push101=, 31
	i32.shr_s	$5=, $4, $pop101
	i32.const	$push100=, 24
	i32.shr_s	$4=, $4, $pop100
	i32.const	$push99=, 31
	i32.shr_s	$9=, $9, $pop99
	i32.add 	$push43=, $4, $5
	i32.xor 	$push44=, $pop43, $5
	i32.add 	$push45=, $8, $9
	i32.xor 	$push46=, $pop45, $9
	i32.const	$push98=, 255
	i32.and 	$push47=, $pop46, $pop98
	i32.ge_s	$push48=, $pop44, $pop47
	br_if   	4, $pop48       # 4: down to label3
# %bb.23:                               # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$push49=, $1, $4
	i32.const	$push108=, 24
	i32.shl 	$push50=, $pop49, $pop108
	i32.const	$push107=, 24
	i32.shr_s	$push51=, $pop50, $pop107
	i32.ne  	$push52=, $pop51, $2
	br_if   	4, $pop52       # 4: down to label3
.LBB2_24:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push110=, 1
	i32.add 	$0=, $0, $pop110
	i32.const	$push109=, 1000
	i32.lt_u	$push54=, $0, $pop109
	br_if   	0, $pop54       # 0: up to label6
# %bb.25:                               # %for.end
	end_loop
	i32.const	$push55=, 0
	i32.store	simple_rand.seed($pop55), $3
	i32.const	$push111=, 0
	call    	exit@FUNCTION, $pop111
	unreachable
.LBB2_26:                               # %if.then136
	end_block                       # label5:
	i32.const	$push39=, 0
	i32.store	simple_rand.seed($pop39), $3
	call    	abort@FUNCTION
	unreachable
.LBB2_27:                               # %if.then40
	end_block                       # label4:
	i32.const	$push25=, 0
	i32.store	simple_rand.seed($pop25), $3
	call    	abort@FUNCTION
	unreachable
.LBB2_28:                               # %if.then227
	end_block                       # label3:
	i32.const	$push53=, 0
	i32.store	simple_rand.seed($pop53), $3
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.p2align	2
simple_rand.seed:
	.int32	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
