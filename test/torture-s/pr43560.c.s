	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43560.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push8=, 4($0)
	tee_local	$push7=, $3=, $pop8
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $pop7, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %land.rhs.preheader
	i32.const	$push5=, 4
	i32.add 	$2=, $0, $pop5
.LBB0_2:                                # %land.rhs
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push15=, -1
	i32.add 	$push14=, $3, $pop15
	tee_local	$push13=, $3=, $pop14
	i32.add 	$push2=, $0, $pop13
	i32.const	$push12=, 8
	i32.add 	$push11=, $pop2, $pop12
	tee_local	$push10=, $1=, $pop11
	i32.load8_u	$push3=, 0($pop10)
	i32.const	$push9=, 47
	i32.ne  	$push4=, $pop3, $pop9
	br_if   	1, $pop4        # 1: down to label0
# BB#3:                                 # %while.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	0($2), $3
	i32.const	$push19=, 0
	i32.store8	0($1), $pop19
	i32.load	$push18=, 0($2)
	tee_local	$push17=, $3=, $pop18
	i32.const	$push16=, 1
	i32.gt_s	$push6=, $pop17, $pop16
	br_if   	0, $pop6        # 0: up to label1
.LBB0_4:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, s
	#APP
	#NO_APP
	call    	test@FUNCTION, $0
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.rodata.s,"a",@progbits
	.globl	s
	.p2align	2
s:
	.skip	20
	.size	s, 20


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
