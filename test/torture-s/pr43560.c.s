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
	block
	i32.load	$push15=, 4($0)
	tee_local	$push16=, $1=, $pop15
	i32.const	$push2=, 2
	i32.lt_s	$push3=, $pop16, $pop2
	br_if   	0, $pop3        # 0: down to label0
.LBB0_1:                                # %land.rhs
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push4=, -1
	i32.add 	$push0=, $1, $pop4
	tee_local	$push18=, $1=, $pop0
	i32.add 	$push5=, $0, $pop18
	i32.const	$push6=, 8
	i32.add 	$push1=, $pop5, $pop6
	tee_local	$push17=, $2=, $pop1
	i32.load8_u	$push7=, 0($pop17)
	i32.const	$push8=, 47
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	1, $pop9        # 1: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	tee_local	$push19=, $3=, $pop11
	i32.store	$discard=, 0($pop19), $1
	i32.const	$push12=, 0
	i32.store8	$discard=, 0($2), $pop12
	i32.load	$1=, 0($3)
	i32.const	$push13=, 1
	i32.gt_s	$push14=, $1, $pop13
	br_if   	0, $pop14       # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
	return  	$pop0
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


	.ident	"clang version 3.9.0 "
