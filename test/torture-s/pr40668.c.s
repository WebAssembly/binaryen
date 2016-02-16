	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40668.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -1
	i32.add 	$push8=, $0, $pop0
	tee_local	$push7=, $0=, $pop8
	i32.const	$push1=, 8
	i32.gt_u	$push2=, $pop7, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	block
	block
	block
	block
	tableswitch	$0, 0, 0, 4, 4, 4, 4, 4, 1, 2, 3 # 0: down to label4
                                        # 4: down to label0
                                        # 1: down to label3
                                        # 2: down to label2
                                        # 3: down to label1
.LBB0_2:                                # %sw.bb
	end_block                       # label4:
	i32.const	$push6=, 305419896
	i32.store	$discard=, 0($1):p2align=0, $pop6
	br      	3               # 3: down to label0
.LBB0_3:                                # %sw.bb1
	end_block                       # label3:
	i32.const	$push5=, 0
	i32.store	$discard=, 0($1):p2align=0, $pop5
	br      	2               # 2: down to label0
.LBB0_4:                                # %sw.bb2
	end_block                       # label2:
	i32.const	$push4=, 0
	i32.store	$discard=, 0($1):p2align=0, $pop4
	br      	1               # 1: down to label0
.LBB0_5:                                # %sw.bb3
	end_block                       # label1:
	i32.const	$push3=, 0
	i32.store	$discard=, 0($1):p2align=0, $pop3
.LBB0_6:                                # %sw.epilog
	end_block                       # label0:
	return
	.endfunc
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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
