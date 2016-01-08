	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40668.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_6
	i32.const	$push0=, -1
	i32.add 	$0=, $0, $pop0
	i32.const	$push1=, 8
	i32.gt_u	$push2=, $0, $pop1
	br_if   	$pop2, .LBB0_6
# BB#1:                                 # %entry
	block   	.LBB0_5
	block   	.LBB0_4
	block   	.LBB0_3
	block   	.LBB0_2
	tableswitch	$0, .LBB0_2, .LBB0_2, .LBB0_6, .LBB0_6, .LBB0_6, .LBB0_6, .LBB0_6, .LBB0_3, .LBB0_4, .LBB0_5
.LBB0_2:                                # %sw.bb
	i32.const	$push24=, 120
	i32.store8	$discard=, 0($1), $pop24
	i32.const	$push25=, 3
	i32.add 	$push26=, $1, $pop25
	i32.const	$push27=, 18
	i32.store8	$discard=, 0($pop26), $pop27
	i32.const	$push28=, 2
	i32.add 	$push29=, $1, $pop28
	i32.const	$push30=, 52
	i32.store8	$discard=, 0($pop29), $pop30
	i32.const	$push31=, 1
	i32.add 	$push32=, $1, $pop31
	i32.const	$push33=, 86
	i32.store8	$discard=, 0($pop32), $pop33
	br      	.LBB0_6
.LBB0_3:                                # %sw.bb1
	i32.const	$push17=, 0
	i32.store8	$0=, 0($1), $pop17
	i32.const	$push18=, 3
	i32.add 	$push19=, $1, $pop18
	i32.store8	$discard=, 0($pop19), $0
	i32.const	$push20=, 2
	i32.add 	$push21=, $1, $pop20
	i32.store8	$discard=, 0($pop21), $0
	i32.const	$push22=, 1
	i32.add 	$push23=, $1, $pop22
	i32.store8	$discard=, 0($pop23), $0
	br      	.LBB0_6
.LBB0_4:                                # %sw.bb2
	i32.const	$push10=, 0
	i32.store8	$0=, 0($1), $pop10
	i32.const	$push11=, 3
	i32.add 	$push12=, $1, $pop11
	i32.store8	$discard=, 0($pop12), $0
	i32.const	$push13=, 2
	i32.add 	$push14=, $1, $pop13
	i32.store8	$discard=, 0($pop14), $0
	i32.const	$push15=, 1
	i32.add 	$push16=, $1, $pop15
	i32.store8	$discard=, 0($pop16), $0
	br      	.LBB0_6
.LBB0_5:                                # %sw.bb3
	i32.const	$push3=, 0
	i32.store8	$0=, 0($1), $pop3
	i32.const	$push4=, 3
	i32.add 	$push5=, $1, $pop4
	i32.store8	$discard=, 0($pop5), $0
	i32.const	$push6=, 2
	i32.add 	$push7=, $1, $pop6
	i32.store8	$discard=, 0($pop7), $0
	i32.const	$push8=, 1
	i32.add 	$push9=, $1, $pop8
	i32.store8	$discard=, 0($pop9), $0
.LBB0_6:                                # %sw.epilog
	return
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
