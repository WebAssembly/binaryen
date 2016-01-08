	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43560.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$3=, 4($0)
	block   	.LBB0_3
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $3, $pop0
	br_if   	$pop1, .LBB0_3
.LBB0_1:                                # %land.rhs
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.const	$push2=, -1
	i32.add 	$3=, $3, $pop2
	i32.add 	$push3=, $0, $3
	i32.const	$push4=, 8
	i32.add 	$1=, $pop3, $pop4
	i32.load8_u	$push5=, 0($1)
	i32.const	$push6=, 47
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB0_3
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 4
	i32.add 	$2=, $0, $pop8
	i32.store	$discard=, 0($2), $3
	i32.const	$push9=, 0
	i32.store8	$discard=, 0($1), $pop9
	i32.load	$3=, 0($2)
	i32.const	$push10=, 1
	i32.gt_s	$push11=, $3, $pop10
	br_if   	$pop11, .LBB0_1
.LBB0_3:                                # %while.end
	return
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
	call    	test, $0
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.rodata.s,"a",@progbits
	.globl	s
	.align	2
s:
	.skip	20
	.size	s, 20


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
