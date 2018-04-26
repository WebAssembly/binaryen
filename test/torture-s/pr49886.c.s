	.text
	.file	"pr49886.c"
	.section	.text.never_ever,"ax",@progbits
	.hidden	never_ever              # -- Begin function never_ever
	.globl	never_ever
	.type	never_ever,@function
never_ever:                             # @never_ever
	.param  	i32, i32
# %bb.0:                                # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	never_ever, .Lfunc_end0-never_ever
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	cond($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.section	.text.bar_1,"ax",@progbits
	.hidden	bar_1                   # -- Begin function bar_1
	.globl	bar_1
	.type	bar_1,@function
bar_1:                                  # @bar_1
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	4($1), $pop2
	call    	mark_cell@FUNCTION, $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	bar_1, .Lfunc_end2-bar_1
                                        # -- End function
	.section	.text.mark_cell,"ax",@progbits
	.type	mark_cell,@function     # -- Begin function mark_cell
mark_cell:                              # @mark_cell
	.param  	i32
	.local  	i32
# %bb.0:                                # %entry
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
	i32.eqz 	$push41=, $0
	br_if   	0, $pop41       # 0: down to label9
# %bb.1:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, cond($pop1)
	i32.eqz 	$push42=, $pop0
	br_if   	0, $pop42       # 0: down to label9
# %bb.2:                                # %land.lhs.true
	i32.load	$push2=, 8($0)
	i32.const	$push3=, 4
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label9
# %bb.3:                                # %land.lhs.true2
	i32.load	$0=, 0($0)
	i32.eqz 	$push43=, $0
	br_if   	0, $pop43       # 0: down to label9
# %bb.4:                                # %land.lhs.true4
	i32.const	$push37=, 2
	i32.add 	$1=, $0, $pop37
	i32.load8_u	$push5=, 0($1)
	i32.const	$push6=, 4
	i32.and 	$push7=, $pop5, $pop6
	i32.eqz 	$push44=, $pop7
	br_if   	1, $pop44       # 1: down to label8
# %bb.5:                                # %land.lhs.true17
	i32.load8_u	$push8=, 0($1)
	i32.const	$push38=, 2
	i32.and 	$push9=, $pop8, $pop38
	i32.eqz 	$push45=, $pop9
	br_if   	2, $pop45       # 2: down to label7
# %bb.6:                                # %land.lhs.true33
	i32.const	$push10=, 2
	i32.add 	$push11=, $0, $pop10
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push39=, 1
	i32.and 	$push13=, $pop12, $pop39
	i32.eqz 	$push46=, $pop13
	br_if   	3, $pop46       # 3: down to label6
# %bb.7:                                # %land.lhs.true49
	i32.const	$push40=, 1
	i32.add 	$push14=, $0, $pop40
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push16=, 7
	i32.shr_u	$push17=, $pop15, $pop16
	i32.eqz 	$push47=, $pop17
	br_if   	4, $pop47       # 4: down to label5
# %bb.8:                                # %land.lhs.true65
	i32.const	$push18=, 1
	i32.add 	$1=, $0, $pop18
	i32.load8_u	$push19=, 0($1)
	i32.const	$push20=, 64
	i32.and 	$push21=, $pop19, $pop20
	i32.eqz 	$push48=, $pop21
	br_if   	5, $pop48       # 5: down to label4
# %bb.9:                                # %land.lhs.true81
	i32.load8_u	$push22=, 0($1)
	i32.const	$push23=, 32
	i32.and 	$push24=, $pop22, $pop23
	i32.eqz 	$push49=, $pop24
	br_if   	6, $pop49       # 6: down to label3
# %bb.10:                               # %land.lhs.true97
	i32.const	$push25=, 1
	i32.add 	$1=, $0, $pop25
	i32.load8_u	$push26=, 0($1)
	i32.const	$push27=, 16
	i32.and 	$push28=, $pop26, $pop27
	i32.eqz 	$push50=, $pop28
	br_if   	7, $pop50       # 7: down to label2
# %bb.11:                               # %land.lhs.true113
	i32.load8_u	$push29=, 0($1)
	i32.const	$push30=, 8
	i32.and 	$push31=, $pop29, $pop30
	i32.eqz 	$push51=, $pop31
	br_if   	8, $pop51       # 8: down to label1
# %bb.12:                               # %land.lhs.true129
	i32.const	$push32=, 1
	i32.add 	$push33=, $0, $pop32
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push35=, 4
	i32.and 	$push36=, $pop34, $pop35
	i32.eqz 	$push52=, $pop36
	br_if   	9, $pop52       # 9: down to label0
.LBB3_13:                               # %if.end137
	end_block                       # label9:
	return
.LBB3_14:                               # %if.then7
	end_block                       # label8:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_15:                               # %if.then22
	end_block                       # label7:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_16:                               # %if.then38
	end_block                       # label6:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_17:                               # %if.then54
	end_block                       # label5:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_18:                               # %if.then70
	end_block                       # label4:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_19:                               # %if.then86
	end_block                       # label3:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_20:                               # %if.then102
	end_block                       # label2:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_21:                               # %if.then118
	end_block                       # label1:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_22:                               # %if.then134
	end_block                       # label0:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	mark_cell, .Lfunc_end3-mark_cell
                                        # -- End function
	.section	.text.bar_2,"ax",@progbits
	.hidden	bar_2                   # -- Begin function bar_2
	.globl	bar_2
	.type	bar_2,@function
bar_2:                                  # @bar_2
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop0, $pop1
	i32.store	4($1), $pop2
	call    	mark_cell@FUNCTION, $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	bar_2, .Lfunc_end4-bar_2
                                        # -- End function
	.hidden	cond                    # @cond
	.type	cond,@object
	.section	.bss.cond,"aw",@nobits
	.globl	cond
	.p2align	2
cond:
	.int32	0                       # 0x0
	.size	cond, 4

	.hidden	gi                      # @gi
	.type	gi,@object
	.section	.bss.gi,"aw",@nobits
	.globl	gi
	.p2align	2
gi:
	.int32	0                       # 0x0
	.size	gi, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
