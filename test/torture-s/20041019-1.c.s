	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041019-1.c"
	.section	.text.test_store_ccp,"ax",@progbits
	.hidden	test_store_ccp
	.globl	test_store_ccp
	.type	test_store_ccp,@function
test_store_ccp:                         # @test_store_ccp
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 16
	i32.sub 	$1=, $pop13, $pop14
	i32.const	$push19=, 12
	i32.add 	$push20=, $1, $pop19
	i32.const	$push15=, 8
	i32.add 	$push16=, $1, $pop15
	i32.const	$push17=, 4
	i32.add 	$push18=, $1, $pop17
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.select	$push4=, $pop16, $pop18, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.select	$push11=, $pop20, $pop4, $pop1
	tee_local	$push10=, $0=, $pop11
	i32.const	$push5=, 10
	i32.store	$discard=, 0($pop10), $pop5
	i32.const	$push6=, 3
	i32.store	$discard=, 8($1), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push8=, 2
	i32.add 	$push9=, $pop7, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end0:
	.size	test_store_ccp, .Lfunc_end0-test_store_ccp

	.section	.text.test_store_copy_prop,"ax",@progbits
	.hidden	test_store_copy_prop
	.globl	test_store_copy_prop
	.type	test_store_copy_prop,@function
test_store_copy_prop:                   # @test_store_copy_prop
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$2=, $pop12, $pop13
	i32.const	$push18=, 12
	i32.add 	$push19=, $2, $pop18
	i32.const	$push14=, 8
	i32.add 	$push15=, $2, $pop14
	i32.const	$push16=, 4
	i32.add 	$push17=, $2, $pop16
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.select	$push4=, $pop15, $pop17, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.select	$push10=, $pop19, $pop4, $pop1
	tee_local	$push9=, $1=, $pop10
	i32.store	$push5=, 0($pop9), $0
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.store	$discard=, 8($2), $pop7
	i32.load	$push8=, 0($1)
	return  	$pop8
	.endfunc
.Lfunc_end1:
	.size	test_store_copy_prop, .Lfunc_end1-test_store_copy_prop

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end4
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
