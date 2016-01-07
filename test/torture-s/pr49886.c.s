	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49886.c"
	.globl	never_ever
	.type	never_ever,@function
never_ever:                             # @never_ever
	.param  	i32, i32
# BB#0:                                 # %entry
	call    	abort
	unreachable
.Lfunc_end0:
	.size	never_ever, .Lfunc_end0-never_ever

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, cond($0), $pop0
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.globl	bar_1
	.type	bar_1,@function
bar_1:                                  # @bar_1
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 4($1), $pop2
	call    	mark_cell, $1
	return
.Lfunc_end2:
	.size	bar_1, .Lfunc_end2-bar_1

	.type	mark_cell,@function
mark_cell:                              # @mark_cell
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	.LBB3_22
	i32.const	$push27=, 0
	i32.eq  	$push28=, $0, $pop27
	br_if   	$pop28, .LBB3_22
# BB#1:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, cond($pop1)
	i32.const	$push29=, 0
	i32.eq  	$push30=, $pop0, $pop29
	br_if   	$pop30, .LBB3_22
# BB#2:                                 # %land.lhs.true
	i32.const	$1=, 4
	i32.load	$push2=, 8($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, .LBB3_22
# BB#3:                                 # %land.lhs.true2
	i32.load	$0=, 0($0)
	i32.const	$push31=, 0
	i32.eq  	$push32=, $0, $pop31
	br_if   	$pop32, .LBB3_22
# BB#4:                                 # %land.lhs.true4
	i32.const	$2=, 2
	i32.add 	$3=, $0, $2
	block   	.LBB3_21
	i32.load8_u	$push4=, 0($3)
	i32.and 	$push5=, $pop4, $1
	i32.const	$push33=, 0
	i32.eq  	$push34=, $pop5, $pop33
	br_if   	$pop34, .LBB3_21
# BB#5:                                 # %land.lhs.true17
	block   	.LBB3_20
	i32.load8_u	$push6=, 0($3)
	i32.and 	$push7=, $pop6, $2
	i32.const	$push35=, 0
	i32.eq  	$push36=, $pop7, $pop35
	br_if   	$pop36, .LBB3_20
# BB#6:                                 # %land.lhs.true33
	i32.const	$2=, 1
	block   	.LBB3_19
	i32.load8_u	$push8=, 0($3)
	i32.and 	$push9=, $pop8, $2
	i32.const	$push37=, 0
	i32.eq  	$push38=, $pop9, $pop37
	br_if   	$pop38, .LBB3_19
# BB#7:                                 # %land.lhs.true49
	i32.add 	$0=, $0, $2
	block   	.LBB3_18
	i32.load8_u	$push10=, 0($0)
	i32.const	$push11=, 7
	i32.shr_u	$push12=, $pop10, $pop11
	i32.const	$push39=, 0
	i32.eq  	$push40=, $pop12, $pop39
	br_if   	$pop40, .LBB3_18
# BB#8:                                 # %land.lhs.true65
	block   	.LBB3_17
	i32.load8_u	$push13=, 0($0)
	i32.const	$push14=, 64
	i32.and 	$push15=, $pop13, $pop14
	i32.const	$push41=, 0
	i32.eq  	$push42=, $pop15, $pop41
	br_if   	$pop42, .LBB3_17
# BB#9:                                 # %land.lhs.true81
	block   	.LBB3_16
	i32.load8_u	$push16=, 0($0)
	i32.const	$push17=, 32
	i32.and 	$push18=, $pop16, $pop17
	i32.const	$push43=, 0
	i32.eq  	$push44=, $pop18, $pop43
	br_if   	$pop44, .LBB3_16
# BB#10:                                # %land.lhs.true97
	block   	.LBB3_15
	i32.load8_u	$push19=, 0($0)
	i32.const	$push20=, 16
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push45=, 0
	i32.eq  	$push46=, $pop21, $pop45
	br_if   	$pop46, .LBB3_15
# BB#11:                                # %land.lhs.true113
	block   	.LBB3_14
	i32.load8_u	$push22=, 0($0)
	i32.const	$push23=, 8
	i32.and 	$push24=, $pop22, $pop23
	i32.const	$push47=, 0
	i32.eq  	$push48=, $pop24, $pop47
	br_if   	$pop48, .LBB3_14
# BB#12:                                # %land.lhs.true129
	i32.load8_u	$push25=, 0($0)
	i32.and 	$push26=, $pop25, $1
	br_if   	$pop26, .LBB3_22
# BB#13:                                # %if.then134
	call    	never_ever, $0, $0
	unreachable
.LBB3_14:                                 # %if.then118
	call    	never_ever, $0, $0
	unreachable
.LBB3_15:                                 # %if.then102
	call    	never_ever, $0, $0
	unreachable
.LBB3_16:                                 # %if.then86
	call    	never_ever, $0, $0
	unreachable
.LBB3_17:                                 # %if.then70
	call    	never_ever, $0, $0
	unreachable
.LBB3_18:                                 # %if.then54
	call    	never_ever, $0, $0
	unreachable
.LBB3_19:                                 # %if.then38
	call    	never_ever, $0, $0
	unreachable
.LBB3_20:                                 # %if.then22
	call    	never_ever, $0, $0
	unreachable
.LBB3_21:                                 # %if.then7
	call    	never_ever, $0, $0
	unreachable
.LBB3_22:                                 # %if.end137
	return
.Lfunc_end3:
	.size	mark_cell, .Lfunc_end3-mark_cell

	.globl	bar_2
	.type	bar_2,@function
bar_2:                                  # @bar_2
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 2
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 4($1), $pop2
	call    	mark_cell, $1
	return
.Lfunc_end4:
	.size	bar_2, .Lfunc_end4-bar_2

	.type	cond,@object            # @cond
	.bss
	.globl	cond
	.align	2
cond:
	.int32	0                       # 0x0
	.size	cond, 4

	.type	gi,@object              # @gi
	.globl	gi
	.align	2
gi:
	.int32	0                       # 0x0
	.size	gi, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
