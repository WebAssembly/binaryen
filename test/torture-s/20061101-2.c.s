	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20061101-2.c"
	.section	.text.tar,"ax",@progbits
	.hidden	tar
	.globl	tar
	.type	tar,@function
tar:                                    # @tar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 36863
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, -1
	return  	$pop2
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	tar, .Lfunc_end0-tar

	.section	.text.bug,"ax",@progbits
	.hidden	bug
	.globl	bug
	.type	bug,@function
bug:                                    # @bug
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.add 	$2=, $0, $pop0
	i32.const	$3=, 1
	i32.const	$0=, 0
	copy_local	$4=, $3
.LBB1_1:                                # %while.cond
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label2:
	i32.and 	$push1=, $4, $3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop1, $pop8
	br_if   	$pop9, 2        # 2: down to label1
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.lt_s	$push4=, $0, $2
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.select	$0=, $pop4, $pop3, $2
	i32.const	$4=, 0
	i32.mul 	$push5=, $0, $1
	i32.const	$push6=, 36863
	i32.eq  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: up to label2
# BB#3:                                 # %if.then.i
	end_loop                        # label3:
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %while.end
	end_block                       # label1:
	return
.Lfunc_end1:
	.size	bug, .Lfunc_end1-bug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %bug.exit
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
