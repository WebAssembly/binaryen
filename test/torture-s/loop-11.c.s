	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 199
	i32.const	$0=, a+792
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push11=, -1
	i32.add 	$push0=, $1, $pop11
	i32.store	$1=, 0($0), $pop0
	i32.const	$push10=, -4
	i32.add 	$0=, $0, $pop10
	i32.const	$3=, 0
	i32.const	$2=, a
	i32.const	$push9=, 0
	i32.gt_s	$push1=, $1, $pop9
	br_if   	0, $pop1        # 0: up to label0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label1:
	block
	loop                            # label3:
	i32.load	$push2=, 0($2)
	i32.ne  	$push3=, $3, $pop2
	br_if   	2, $pop3        # 2: down to label2
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push4=, 1
	i32.add 	$3=, $3, $pop4
	i32.const	$push5=, 4
	i32.add 	$2=, $2, $pop5
	i32.const	$push6=, 198
	i32.le_s	$push7=, $3, $pop6
	br_if   	0, $pop7        # 0: up to label3
# BB#4:                                 # %for.end
	end_loop                        # label4:
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.lcomm	a,796,4

	.ident	"clang version 3.9.0 "
