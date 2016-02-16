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
	i32.load	$push13=, 4($0)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $pop12, $pop0
	br_if   	0, $pop1        # 0: down to label0
.LBB0_1:                                # %land.rhs
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push2=, -1
	i32.add 	$push17=, $1, $pop2
	tee_local	$push16=, $1=, $pop17
	i32.add 	$push3=, $0, $pop16
	i32.const	$push4=, 8
	i32.add 	$push15=, $pop3, $pop4
	tee_local	$push14=, $2=, $pop15
	i32.load8_u	$push5=, 0($pop14)
	i32.const	$push6=, 47
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	1, $pop7        # 1: down to label2
# BB#2:                                 # %while.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push8=, 4
	i32.add 	$push19=, $0, $pop8
	tee_local	$push18=, $3=, $pop19
	i32.store	$discard=, 0($pop18), $1
	i32.const	$push9=, 0
	i32.store8	$discard=, 0($2), $pop9
	i32.load	$1=, 0($3)
	i32.const	$push10=, 1
	i32.gt_s	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: up to label1
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
