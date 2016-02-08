	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49886.c"
	.section	.text.never_ever,"ax",@progbits
	.hidden	never_ever
	.globl	never_ever
	.type	never_ever,@function
never_ever:                             # @never_ever
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	never_ever, .Lfunc_end0-never_ever

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, cond($pop1), $pop0
	i32.const	$push2=, 0
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.section	.text.bar_1,"ax",@progbits
	.hidden	bar_1
	.globl	bar_1
	.type	bar_1,@function
bar_1:                                  # @bar_1
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 4($1), $pop2
	call    	mark_cell@FUNCTION, $1
	return
	.endfunc
.Lfunc_end2:
	.size	bar_1, .Lfunc_end2-bar_1

	.section	.text.mark_cell,"ax",@progbits
	.type	mark_cell,@function
mark_cell:                              # @mark_cell
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push49=, 0
	i32.eq  	$push50=, $0, $pop49
	br_if   	0, $pop50       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.load	$push1=, cond($pop2)
	i32.const	$push51=, 0
	i32.eq  	$push52=, $pop1, $pop51
	br_if   	0, $pop52       # 0: down to label0
# BB#2:                                 # %land.lhs.true
	i32.load	$push3=, 8($0)
	i32.const	$push4=, 4
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#3:                                 # %land.lhs.true2
	i32.load	$push0=, 0($0)
	tee_local	$push41=, $0=, $pop0
	i32.const	$push53=, 0
	i32.eq  	$push54=, $pop41, $pop53
	br_if   	0, $pop54       # 0: down to label0
# BB#4:                                 # %land.lhs.true4
	block
	i32.const	$push43=, 2
	i32.add 	$push6=, $0, $pop43
	tee_local	$push42=, $1=, $pop6
	i32.load8_u	$push7=, 0($pop42):p2align=1
	i32.const	$push8=, 4
	i32.and 	$push9=, $pop7, $pop8
	i32.const	$push55=, 0
	i32.eq  	$push56=, $pop9, $pop55
	br_if   	0, $pop56       # 0: down to label1
# BB#5:                                 # %land.lhs.true17
	block
	i32.load8_u	$push10=, 0($1):p2align=1
	i32.const	$push44=, 2
	i32.and 	$push11=, $pop10, $pop44
	i32.const	$push57=, 0
	i32.eq  	$push58=, $pop11, $pop57
	br_if   	0, $pop58       # 0: down to label2
# BB#6:                                 # %land.lhs.true33
	block
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.load8_u	$push14=, 0($pop13):p2align=1
	i32.const	$push45=, 1
	i32.and 	$push15=, $pop14, $pop45
	i32.const	$push59=, 0
	i32.eq  	$push60=, $pop15, $pop59
	br_if   	0, $pop60       # 0: down to label3
# BB#7:                                 # %land.lhs.true49
	block
	i32.const	$push46=, 1
	i32.add 	$push16=, $0, $pop46
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push18=, 7
	i32.shr_u	$push19=, $pop17, $pop18
	i32.const	$push61=, 0
	i32.eq  	$push62=, $pop19, $pop61
	br_if   	0, $pop62       # 0: down to label4
# BB#8:                                 # %land.lhs.true65
	block
	i32.const	$push20=, 1
	i32.add 	$push21=, $0, $pop20
	tee_local	$push47=, $1=, $pop21
	i32.load8_u	$push22=, 0($pop47)
	i32.const	$push23=, 64
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push63=, 0
	i32.eq  	$push64=, $pop24, $pop63
	br_if   	0, $pop64       # 0: down to label5
# BB#9:                                 # %land.lhs.true81
	block
	i32.load8_u	$push25=, 0($1)
	i32.const	$push26=, 32
	i32.and 	$push27=, $pop25, $pop26
	i32.const	$push65=, 0
	i32.eq  	$push66=, $pop27, $pop65
	br_if   	0, $pop66       # 0: down to label6
# BB#10:                                # %land.lhs.true97
	block
	i32.const	$push28=, 1
	i32.add 	$push29=, $0, $pop28
	tee_local	$push48=, $1=, $pop29
	i32.load8_u	$push30=, 0($pop48)
	i32.const	$push31=, 16
	i32.and 	$push32=, $pop30, $pop31
	i32.const	$push67=, 0
	i32.eq  	$push68=, $pop32, $pop67
	br_if   	0, $pop68       # 0: down to label7
# BB#11:                                # %land.lhs.true113
	block
	i32.load8_u	$push33=, 0($1)
	i32.const	$push34=, 8
	i32.and 	$push35=, $pop33, $pop34
	i32.const	$push69=, 0
	i32.eq  	$push70=, $pop35, $pop69
	br_if   	0, $pop70       # 0: down to label8
# BB#12:                                # %land.lhs.true129
	i32.const	$push36=, 1
	i32.add 	$push37=, $0, $pop36
	i32.load8_u	$push38=, 0($pop37)
	i32.const	$push39=, 4
	i32.and 	$push40=, $pop38, $pop39
	br_if   	8, $pop40       # 8: down to label0
# BB#13:                                # %if.then134
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_14:                               # %if.then118
	end_block                       # label8:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_15:                               # %if.then102
	end_block                       # label7:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_16:                               # %if.then86
	end_block                       # label6:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_17:                               # %if.then70
	end_block                       # label5:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_18:                               # %if.then54
	end_block                       # label4:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_19:                               # %if.then38
	end_block                       # label3:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_20:                               # %if.then22
	end_block                       # label2:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_21:                               # %if.then7
	end_block                       # label1:
	call    	never_ever@FUNCTION, $0, $0
	unreachable
.LBB3_22:                               # %if.end137
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end3:
	.size	mark_cell, .Lfunc_end3-mark_cell

	.section	.text.bar_2,"ax",@progbits
	.hidden	bar_2
	.globl	bar_2
	.type	bar_2,@function
bar_2:                                  # @bar_2
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 4($1), $pop2
	call    	mark_cell@FUNCTION, $1
	return
	.endfunc
.Lfunc_end4:
	.size	bar_2, .Lfunc_end4-bar_2

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


	.ident	"clang version 3.9.0 "
