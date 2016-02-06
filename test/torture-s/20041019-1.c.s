	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041019-1.c"
	.section	.text.test_store_ccp,"ax",@progbits
	.hidden	test_store_ccp
	.globl	test_store_ccp
	.type	test_store_ccp,@function
test_store_ccp:                         # @test_store_ccp
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.const	$4=, 8
	i32.add 	$4=, $7, $4
	i32.const	$5=, 4
	i32.add 	$5=, $7, $5
	i32.select	$push4=, $4, $5, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.const	$6=, 12
	i32.add 	$6=, $7, $6
	i32.select	$push5=, $6, $pop4, $pop1
	tee_local	$push11=, $0=, $pop5
	i32.const	$push6=, 10
	i32.store	$discard=, 0($pop11), $pop6
	i32.const	$push7=, 3
	i32.store	$discard=, 8($7), $pop7
	i32.load	$push8=, 0($0)
	i32.const	$push9=, 2
	i32.add 	$push10=, $pop8, $pop9
	i32.const	$3=, 16
	i32.add 	$7=, $7, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	return  	$pop10
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$8=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$8=, 0($3), $8
	i32.const	$push2=, 8
	i32.gt_s	$push3=, $0, $pop2
	i32.const	$5=, 8
	i32.add 	$5=, $8, $5
	i32.const	$6=, 4
	i32.add 	$6=, $8, $6
	i32.select	$push4=, $5, $6, $pop3
	i32.const	$push0=, 5
	i32.lt_s	$push1=, $0, $pop0
	i32.const	$7=, 12
	i32.add 	$7=, $8, $7
	i32.select	$push5=, $7, $pop4, $pop1
	tee_local	$push10=, $1=, $pop5
	i32.store	$push6=, 0($pop10), $0
	i32.const	$push7=, 1
	i32.add 	$push8=, $pop6, $pop7
	i32.store	$discard=, 8($8), $pop8
	i32.load	$push9=, 0($1)
	i32.const	$4=, 16
	i32.add 	$8=, $8, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	return  	$pop9
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
