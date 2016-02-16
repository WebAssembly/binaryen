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
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push49=, 0
	i32.eq  	$push50=, $0, $pop49
	br_if   	0, $pop50       # 0: down to label9
# BB#1:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, cond($pop1)
	i32.const	$push51=, 0
	i32.eq  	$push52=, $pop0, $pop51
	br_if   	0, $pop52       # 0: down to label9
# BB#2:                                 # %land.lhs.true
	i32.load	$push2=, 8($0)
	i32.const	$push3=, 4
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label9
# BB#3:                                 # %land.lhs.true2
	i32.load	$push38=, 0($0)
	tee_local	$push37=, $0=, $pop38
	i32.const	$push53=, 0
	i32.eq  	$push54=, $pop37, $pop53
	br_if   	0, $pop54       # 0: down to label9
# BB#4:                                 # %land.lhs.true4
	i32.const	$push41=, 2
	i32.add 	$push40=, $0, $pop41
	tee_local	$push39=, $1=, $pop40
	i32.load8_u	$push5=, 0($pop39):p2align=1
	i32.const	$push6=, 4
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push55=, 0
	i32.eq  	$push56=, $pop7, $pop55
	br_if   	1, $pop56       # 1: down to label8
# BB#5:                                 # %land.lhs.true17
	i32.load8_u	$push8=, 0($1):p2align=1
	i32.const	$push42=, 2
	i32.and 	$push9=, $pop8, $pop42
	i32.const	$push57=, 0
	i32.eq  	$push58=, $pop9, $pop57
	br_if   	2, $pop58       # 2: down to label7
# BB#6:                                 # %land.lhs.true33
	i32.const	$push10=, 2
	i32.add 	$push11=, $0, $pop10
	i32.load8_u	$push12=, 0($pop11):p2align=1
	i32.const	$push43=, 1
	i32.and 	$push13=, $pop12, $pop43
	i32.const	$push59=, 0
	i32.eq  	$push60=, $pop13, $pop59
	br_if   	3, $pop60       # 3: down to label6
# BB#7:                                 # %land.lhs.true49
	i32.const	$push44=, 1
	i32.add 	$push14=, $0, $pop44
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push16=, 7
	i32.shr_u	$push17=, $pop15, $pop16
	i32.const	$push61=, 0
	i32.eq  	$push62=, $pop17, $pop61
	br_if   	4, $pop62       # 4: down to label5
# BB#8:                                 # %land.lhs.true65
	i32.const	$push18=, 1
	i32.add 	$push46=, $0, $pop18
	tee_local	$push45=, $1=, $pop46
	i32.load8_u	$push19=, 0($pop45)
	i32.const	$push20=, 64
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push63=, 0
	i32.eq  	$push64=, $pop21, $pop63
	br_if   	5, $pop64       # 5: down to label4
# BB#9:                                 # %land.lhs.true81
	i32.load8_u	$push22=, 0($1)
	i32.const	$push23=, 32
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push65=, 0
	i32.eq  	$push66=, $pop24, $pop65
	br_if   	6, $pop66       # 6: down to label3
# BB#10:                                # %land.lhs.true97
	i32.const	$push25=, 1
	i32.add 	$push48=, $0, $pop25
	tee_local	$push47=, $1=, $pop48
	i32.load8_u	$push26=, 0($pop47)
	i32.const	$push27=, 16
	i32.and 	$push28=, $pop26, $pop27
	i32.const	$push67=, 0
	i32.eq  	$push68=, $pop28, $pop67
	br_if   	7, $pop68       # 7: down to label2
# BB#11:                                # %land.lhs.true113
	i32.load8_u	$push29=, 0($1)
	i32.const	$push30=, 8
	i32.and 	$push31=, $pop29, $pop30
	i32.const	$push69=, 0
	i32.eq  	$push70=, $pop31, $pop69
	br_if   	8, $pop70       # 8: down to label1
# BB#12:                                # %land.lhs.true129
	i32.const	$push32=, 1
	i32.add 	$push33=, $0, $pop32
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push35=, 4
	i32.and 	$push36=, $pop34, $pop35
	i32.const	$push71=, 0
	i32.eq  	$push72=, $pop36, $pop71
	br_if   	9, $pop72       # 9: down to label0
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
