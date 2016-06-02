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
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push22=, $pop11, $pop12
	tee_local	$push21=, $1=, $pop22
	i32.const	$push17=, 12
	i32.add 	$push18=, $pop21, $pop17
	i32.const	$push13=, 8
	i32.add 	$push14=, $1, $pop13
	i32.const	$push15=, 4
	i32.add 	$push16=, $1, $pop15
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.select	$push4=, $pop14, $pop16, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.select	$push20=, $pop18, $pop4, $pop1
	tee_local	$push19=, $0=, $pop20
	i32.const	$push5=, 10
	i32.store	$drop=, 0($pop19), $pop5
	i32.const	$push6=, 3
	i32.store	$drop=, 8($1), $pop6
	i32.load	$push7=, 0($0)
	i32.const	$push8=, 2
	i32.add 	$push9=, $pop7, $pop8
                                        # fallthrough-return: $pop9
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push21=, $pop10, $pop11
	tee_local	$push20=, $1=, $pop21
	i32.const	$push16=, 12
	i32.add 	$push17=, $1, $pop16
	i32.const	$push12=, 8
	i32.add 	$push13=, $1, $pop12
	i32.const	$push14=, 4
	i32.add 	$push15=, $1, $pop14
	i32.const	$push3=, 8
	i32.gt_s	$push4=, $0, $pop3
	i32.select	$push5=, $pop13, $pop15, $pop4
	i32.const	$push1=, 5
	i32.lt_s	$push2=, $0, $pop1
	i32.select	$push19=, $pop17, $pop5, $pop2
	tee_local	$push18=, $1=, $pop19
	i32.store	$push0=, 0($pop18), $0
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop0, $pop6
	i32.store	$drop=, 8($pop20), $pop7
	i32.load	$push8=, 0($1)
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
