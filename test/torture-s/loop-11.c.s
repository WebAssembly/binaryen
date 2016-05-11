	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 199
	i32.const	$1=, a+792
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push7=, -1
	i32.add 	$2=, $2, $pop7
	i32.store	$0=, 0($1), $2
	i32.const	$push6=, -4
	i32.add 	$1=, $1, $pop6
	i32.const	$push5=, 0
	i32.gt_s	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: up to label0
# BB#2:                                 # %for.body.preheader
	end_loop                        # label1:
	i32.const	$2=, 0
	i32.const	$1=, a
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label3:
	i32.load	$push1=, 0($1)
	i32.ne  	$push2=, $2, $pop1
	br_if   	2, $pop2        # 2: down to label2
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push10=, 1
	i32.add 	$2=, $2, $pop10
	i32.const	$push9=, 4
	i32.add 	$1=, $1, $pop9
	i32.const	$push8=, 198
	i32.le_s	$push3=, $2, $pop8
	br_if   	0, $pop3        # 0: up to label3
# BB#5:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.lcomm	a,796,4

	.ident	"clang version 3.9.0 "
