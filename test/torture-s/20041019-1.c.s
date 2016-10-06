	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041019-1.c"
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
	i32.store	0($pop19), $pop5
	i32.const	$push6=, 3
	i32.store	8($1), $pop6
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push20=, $pop9, $pop10
	tee_local	$push19=, $2=, $pop20
	i32.const	$push15=, 12
	i32.add 	$push16=, $pop19, $pop15
	i32.const	$push11=, 8
	i32.add 	$push12=, $2, $pop11
	i32.const	$push13=, 4
	i32.add 	$push14=, $2, $pop13
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.select	$push4=, $pop12, $pop14, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.select	$push18=, $pop16, $pop4, $pop1
	tee_local	$push17=, $1=, $pop18
	i32.store	0($pop17), $0
	i32.const	$push5=, 1
	i32.add 	$push6=, $0, $pop5
	i32.store	8($2), $pop6
	i32.load	$push7=, 0($1)
                                        # fallthrough-return: $pop7
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
