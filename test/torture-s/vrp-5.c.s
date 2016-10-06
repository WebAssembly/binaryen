	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-5.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
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
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $1
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %if.end6
	return
.LBB0_4:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
