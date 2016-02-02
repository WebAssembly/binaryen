	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030903-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push6=, 0
	i32.load	$push1=, test($pop6)
	i32.const	$push2=, -1
	i32.add 	$push0=, $pop1, $pop2
	tee_local	$push5=, $0=, $pop0
	i32.const	$push3=, 3
	i32.le_u	$push4=, $pop5, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %sw.epilog
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_2:                                # %entry
	end_block                       # label0:
	block
	block
	block
	block
	tableswitch	$0, 0, 0, 1, 2, 3 # 0: down to label4
                                        # 1: down to label3
                                        # 2: down to label2
                                        # 3: down to label1
.LBB0_3:                                # %sw.bb
	end_block                       # label4:
	call    	y@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb1
	end_block                       # label3:
	call    	y@FUNCTION
	unreachable
.LBB0_5:                                # %sw.bb2
	end_block                       # label2:
	call    	y@FUNCTION
	unreachable
.LBB0_6:                                # %sw.bb3
	end_block                       # label1:
	call    	y@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.y,"ax",@progbits
	.type	y,@function
y:                                      # @y
# BB#0:                                 # %entry
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	y, .Lfunc_end1-y

	.type	test,@object            # @test
	.lcomm	test,4,2

	.ident	"clang version 3.9.0 "
