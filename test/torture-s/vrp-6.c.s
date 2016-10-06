	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-6.c"
	.section	.text.test01,"ax",@progbits
	.hidden	test01
	.globl	test01
	.type	test01,@function
test01:                                 # @test01
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push5=, 4
	i32.le_u	$push0=, $0, $pop5
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 4
	i32.le_u	$push1=, $1, $pop6
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end3
	i32.sub 	$push2=, $0, $1
	i32.const	$push3=, 5
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %if.end6
	return
.LBB0_4:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test01, .Lfunc_end0-test01

	.section	.text.test02,"ax",@progbits
	.hidden	test02
	.globl	test02
	.type	test02,@function
test02:                                 # @test02
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push1=, 12
	i32.lt_u	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label2
# BB#1:                                 # %entry
	i32.const	$push3=, 16
	i32.lt_u	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#2:                                 # %entry
	i32.sub 	$push0=, $0, $1
	i32.const	$push5=, -17
	i32.le_u	$push6=, $pop0, $pop5
	br_if   	1, $pop6        # 1: down to label1
.LBB1_3:                                # %if.end6
	end_block                       # label2:
	return
.LBB1_4:                                # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test02, .Lfunc_end1-test02

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
