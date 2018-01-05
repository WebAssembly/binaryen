	.text
	.file	"20060420-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.const	$push79=, 1
	i32.lt_s	$push3=, $3, $pop79
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %land.rhs.lr.ph
	i32.const	$push81=, -1
	i32.add 	$8=, $2, $pop81
	i32.const	$push80=, 4
	i32.add 	$4=, $1, $pop80
	i32.const	$10=, 0
.LBB0_2:                                # %land.rhs
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop    	                # label2:
	i32.add 	$push4=, $10, $0
	i32.const	$push82=, 15
	i32.and 	$push5=, $pop4, $pop82
	i32.eqz 	$push133=, $pop5
	br_if   	2, $pop133      # 2: down to label0
# %bb.3:                                # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push84=, 2
	i32.shl 	$12=, $10, $pop84
	i32.load	$push7=, 0($1)
	i32.add 	$push8=, $pop7, $12
	f32.load	$25=, 0($pop8)
	block   	
	i32.const	$push83=, 2
	i32.lt_s	$push6=, $2, $pop83
	br_if   	0, $pop6        # 0: down to label3
# %bb.4:                                # %for.body4.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$9=, $8
	copy_local	$11=, $4
.LBB0_5:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label4:
	i32.const	$push86=, -1
	i32.add 	$9=, $9, $pop86
	i32.load	$push9=, 0($11)
	i32.add 	$push10=, $pop9, $12
	f32.load	$push11=, 0($pop10)
	f32.add 	$25=, $25, $pop11
	i32.const	$push85=, 4
	i32.add 	$push0=, $11, $pop85
	copy_local	$11=, $pop0
	br_if   	0, $9           # 0: up to label4
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label3:
	i32.add 	$push12=, $0, $12
	f32.store	0($pop12), $25
	i32.const	$push87=, 1
	i32.add 	$10=, $10, $pop87
	i32.lt_s	$push13=, $10, $3
	br_if   	0, $pop13       # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_7:
	end_loop
	end_block                       # label1:
	i32.const	$10=, 0
.LBB0_8:                                # %for.end11
	end_block                       # label0:
	i32.const	$push14=, -15
	i32.add 	$4=, $3, $pop14
	block   	
	i32.ge_s	$push15=, $10, $4
	br_if   	0, $pop15       # 0: down to label5
# %bb.9:                                # %for.body15.lr.ph
	i32.const	$push90=, -1
	i32.add 	$7=, $2, $pop90
	i32.const	$push89=, 4
	i32.add 	$6=, $1, $pop89
	i32.const	$push16=, -16
	i32.add 	$push17=, $3, $pop16
	i32.sub 	$push18=, $pop17, $10
	i32.const	$push88=, -16
	i32.and 	$push19=, $pop18, $pop88
	i32.add 	$5=, $10, $pop19
.LBB0_10:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_12 Depth 2
	loop    	                # label6:
	i32.const	$push102=, 2
	i32.shl 	$8=, $10, $pop102
	i32.load	$push21=, 0($1)
	i32.add 	$9=, $pop21, $8
	f32.load	$25=, 48($9)
	f32.load	$21=, 32($9)
	f32.load	$17=, 16($9)
	f32.load	$15=, 8($9)
	f32.load	$14=, 4($9)
	f32.load	$13=, 0($9)
	i32.const	$push101=, 60
	i32.add 	$push22=, $9, $pop101
	f32.load	$28=, 0($pop22)
	i32.const	$push100=, 56
	i32.add 	$push23=, $9, $pop100
	f32.load	$27=, 0($pop23)
	i32.const	$push99=, 52
	i32.add 	$push24=, $9, $pop99
	f32.load	$26=, 0($pop24)
	i32.const	$push98=, 44
	i32.add 	$push25=, $9, $pop98
	f32.load	$24=, 0($pop25)
	i32.const	$push97=, 40
	i32.add 	$push26=, $9, $pop97
	f32.load	$23=, 0($pop26)
	i32.const	$push96=, 36
	i32.add 	$push27=, $9, $pop96
	f32.load	$22=, 0($pop27)
	i32.const	$push95=, 28
	i32.add 	$push28=, $9, $pop95
	f32.load	$20=, 0($pop28)
	i32.const	$push94=, 24
	i32.add 	$push29=, $9, $pop94
	f32.load	$19=, 0($pop29)
	i32.const	$push93=, 20
	i32.add 	$push30=, $9, $pop93
	f32.load	$18=, 0($pop30)
	i32.const	$push92=, 12
	i32.add 	$push31=, $9, $pop92
	f32.load	$16=, 0($pop31)
	block   	
	i32.const	$push91=, 2
	i32.lt_s	$push20=, $2, $pop91
	br_if   	0, $pop20       # 0: down to label7
# %bb.11:                               # %for.body33.preheader
                                        #   in Loop: Header=BB0_10 Depth=1
	copy_local	$11=, $7
	copy_local	$12=, $6
.LBB0_12:                               # %for.body33
                                        #   Parent Loop BB0_10 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label8:
	i32.const	$push114=, -1
	i32.add 	$11=, $11, $pop114
	i32.load	$push32=, 0($12)
	i32.add 	$9=, $pop32, $8
	f32.load	$push33=, 48($9)
	f32.add 	$25=, $25, $pop33
	f32.load	$push34=, 32($9)
	f32.add 	$21=, $21, $pop34
	f32.load	$push35=, 16($9)
	f32.add 	$17=, $17, $pop35
	f32.load	$push36=, 8($9)
	f32.add 	$15=, $15, $pop36
	f32.load	$push37=, 4($9)
	f32.add 	$14=, $14, $pop37
	f32.load	$push38=, 0($9)
	f32.add 	$13=, $13, $pop38
	i32.const	$push113=, 60
	i32.add 	$push39=, $9, $pop113
	f32.load	$push40=, 0($pop39)
	f32.add 	$28=, $28, $pop40
	i32.const	$push112=, 56
	i32.add 	$push41=, $9, $pop112
	f32.load	$push42=, 0($pop41)
	f32.add 	$27=, $27, $pop42
	i32.const	$push111=, 52
	i32.add 	$push43=, $9, $pop111
	f32.load	$push44=, 0($pop43)
	f32.add 	$26=, $26, $pop44
	i32.const	$push110=, 44
	i32.add 	$push45=, $9, $pop110
	f32.load	$push46=, 0($pop45)
	f32.add 	$24=, $24, $pop46
	i32.const	$push109=, 40
	i32.add 	$push47=, $9, $pop109
	f32.load	$push48=, 0($pop47)
	f32.add 	$23=, $23, $pop48
	i32.const	$push108=, 36
	i32.add 	$push49=, $9, $pop108
	f32.load	$push50=, 0($pop49)
	f32.add 	$22=, $22, $pop50
	i32.const	$push107=, 28
	i32.add 	$push51=, $9, $pop107
	f32.load	$push52=, 0($pop51)
	f32.add 	$20=, $20, $pop52
	i32.const	$push106=, 24
	i32.add 	$push53=, $9, $pop106
	f32.load	$push54=, 0($pop53)
	f32.add 	$19=, $19, $pop54
	i32.const	$push105=, 20
	i32.add 	$push55=, $9, $pop105
	f32.load	$push56=, 0($pop55)
	f32.add 	$18=, $18, $pop56
	i32.const	$push104=, 12
	i32.add 	$push57=, $9, $pop104
	f32.load	$push58=, 0($pop57)
	f32.add 	$16=, $16, $pop58
	i32.const	$push103=, 4
	i32.add 	$push1=, $12, $pop103
	copy_local	$12=, $pop1
	br_if   	0, $11          # 0: up to label8
.LBB0_13:                               # %for.end56
                                        #   in Loop: Header=BB0_10 Depth=1
	end_loop
	end_block                       # label7:
	i32.add 	$9=, $0, $8
	f32.store	16($9), $17
	f32.store	8($9), $15
	f32.store	4($9), $14
	f32.store	0($9), $13
	f32.store	32($9), $21
	f32.store	48($9), $25
	i32.const	$push125=, 28
	i32.add 	$push59=, $9, $pop125
	f32.store	0($pop59), $20
	i32.const	$push124=, 24
	i32.add 	$push60=, $9, $pop124
	f32.store	0($pop60), $19
	i32.const	$push123=, 20
	i32.add 	$push61=, $9, $pop123
	f32.store	0($pop61), $18
	i32.const	$push122=, 12
	i32.add 	$push62=, $9, $pop122
	f32.store	0($pop62), $16
	i32.const	$push121=, 44
	i32.add 	$push63=, $9, $pop121
	f32.store	0($pop63), $24
	i32.const	$push120=, 40
	i32.add 	$push64=, $9, $pop120
	f32.store	0($pop64), $23
	i32.const	$push119=, 36
	i32.add 	$push65=, $9, $pop119
	f32.store	0($pop65), $22
	i32.const	$push118=, 60
	i32.add 	$push66=, $9, $pop118
	f32.store	0($pop66), $28
	i32.const	$push117=, 56
	i32.add 	$push67=, $9, $pop117
	f32.store	0($pop67), $27
	i32.const	$push116=, 52
	i32.add 	$push68=, $9, $pop116
	f32.store	0($pop68), $26
	i32.const	$push115=, 16
	i32.add 	$10=, $10, $pop115
	i32.lt_s	$push69=, $10, $4
	br_if   	0, $pop69       # 0: up to label6
# %bb.14:                               # %for.end72.loopexit
	end_loop
	i32.const	$push70=, 16
	i32.add 	$10=, $5, $pop70
.LBB0_15:                               # %for.end72
	end_block                       # label5:
	block   	
	i32.ge_s	$push71=, $10, $3
	br_if   	0, $pop71       # 0: down to label9
# %bb.16:                               # %for.body75.lr.ph
	i32.const	$push127=, -1
	i32.add 	$4=, $2, $pop127
	i32.const	$push126=, 4
	i32.add 	$7=, $1, $pop126
	i32.load	$8=, 0($1)
.LBB0_17:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_19 Depth 2
	loop    	                # label10:
	i32.const	$push129=, 2
	i32.shl 	$12=, $10, $pop129
	i32.add 	$push73=, $8, $12
	f32.load	$25=, 0($pop73)
	block   	
	i32.const	$push128=, 2
	i32.lt_s	$push72=, $2, $pop128
	br_if   	0, $pop72       # 0: down to label11
# %bb.18:                               # %for.body81.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	copy_local	$9=, $4
	copy_local	$11=, $7
.LBB0_19:                               # %for.body81
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i32.const	$push131=, -1
	i32.add 	$9=, $9, $pop131
	i32.load	$push74=, 0($11)
	i32.add 	$push75=, $pop74, $12
	f32.load	$push76=, 0($pop75)
	f32.add 	$25=, $25, $pop76
	i32.const	$push130=, 4
	i32.add 	$push2=, $11, $pop130
	copy_local	$11=, $pop2
	br_if   	0, $9           # 0: up to label12
.LBB0_20:                               # %for.end87
                                        #   in Loop: Header=BB0_17 Depth=1
	end_loop
	end_block                       # label11:
	i32.add 	$push77=, $0, $12
	f32.store	0($pop77), $25
	i32.const	$push132=, 1
	i32.add 	$10=, $10, $pop132
	i32.ne  	$push78=, $10, $3
	br_if   	0, $pop78       # 0: up to label10
.LBB0_21:                               # %for.end91
	end_loop
	end_block                       # label9:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 16
	i32.sub 	$3=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $3
	i32.const	$2=, 0
	i32.const	$push36=, 0
	i32.const	$push0=, buffer
	i32.sub 	$push1=, $pop36, $pop0
	i32.const	$push2=, 63
	i32.and 	$1=, $pop1, $pop2
	i32.const	$push3=, buffer+128
	i32.add 	$push4=, $1, $pop3
	i32.store	12($3), $pop4
	i32.const	$push5=, buffer+64
	i32.add 	$1=, $1, $pop5
	i32.store	8($3), $1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	f32.convert_s/i32	$0=, $2
	i32.const	$push42=, 64
	i32.add 	$push6=, $1, $pop42
	f32.const	$push41=, 0x1.8p3
	f32.mul 	$push7=, $0, $pop41
	f32.add 	$push8=, $pop7, $0
	f32.store	0($pop6), $pop8
	f32.const	$push40=, 0x1.6p3
	f32.mul 	$push9=, $0, $pop40
	f32.add 	$push10=, $pop9, $0
	f32.store	0($1), $pop10
	i32.const	$push39=, 4
	i32.add 	$1=, $1, $pop39
	i32.const	$push38=, 1
	i32.add 	$2=, $2, $pop38
	i32.const	$push37=, 16
	i32.ne  	$push11=, $2, $pop37
	br_if   	0, $pop11       # 0: up to label13
# %bb.2:                                # %for.end
	end_loop
	i32.const	$1=, 0
	i32.const	$push44=, 0
	i32.const	$push12=, buffer
	i32.sub 	$push13=, $pop44, $pop12
	i32.const	$push14=, 63
	i32.and 	$push15=, $pop13, $pop14
	i32.const	$push43=, buffer
	i32.add 	$2=, $pop15, $pop43
	i32.const	$push34=, 8
	i32.add 	$push35=, $3, $pop34
	i32.const	$push17=, 2
	i32.const	$push16=, 16
	call    	foo@FUNCTION, $2, $pop35, $pop17, $pop16
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label15:
	f32.convert_s/i32	$0=, $1
	f32.load	$push23=, 0($2)
	f32.const	$push46=, 0x1.8p3
	f32.mul 	$push18=, $0, $pop46
	f32.const	$push45=, 0x1.6p3
	f32.mul 	$push19=, $0, $pop45
	f32.add 	$push20=, $pop19, $0
	f32.add 	$push21=, $pop20, $0
	f32.add 	$push22=, $pop18, $pop21
	f32.ne  	$push24=, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label14
# %bb.4:                                # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push49=, 1
	i32.add 	$1=, $1, $pop49
	i32.const	$push48=, 4
	i32.add 	$2=, $2, $pop48
	i32.const	$push47=, 15
	i32.le_u	$push25=, $1, $pop47
	br_if   	0, $pop25       # 0: up to label15
# %bb.5:                                # %for.end31
	end_loop
	i32.const	$push33=, 0
	i32.const	$push31=, 16
	i32.add 	$push32=, $3, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push26=, 0
	return  	$pop26
.LBB1_6:                                # %if.then
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	buffer                  # @buffer
	.type	buffer,@object
	.section	.bss.buffer,"aw",@nobits
	.globl	buffer
	.p2align	4
buffer:
	.skip	256
	.size	buffer, 256


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
