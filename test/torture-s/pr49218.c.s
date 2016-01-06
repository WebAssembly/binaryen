	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i64, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$12=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	i32.const	$1=, 0
	f32.load	$push0=, f($1)
	i32.const	$10=, 0
	i32.add 	$10=, $12, $10
	call    	__fixsfti, $10, $pop0
	i64.load	$5=, 0($12)
	i32.const	$push1=, 8
	i32.const	$11=, 0
	i32.add 	$11=, $12, $11
	i32.add 	$push2=, $11, $pop1
	i64.load	$6=, 0($pop2)
	i64.const	$2=, 0
	block   	BB0_2
	i64.eq  	$push6=, $6, $2
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $5, $pop4
	i64.gt_s	$push3=, $6, $2
	i32.select	$push7=, $pop6, $pop5, $pop3
	br_if   	$pop7, BB0_2
BB0_1:                                  # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	i64.const	$3=, 1
	i64.add 	$0=, $5, $3
	i64.lt_u	$4=, $0, $5
	i64.extend_u/i32	$5=, $4
	i64.eq  	$4=, $0, $2
	i64.select	$5=, $4, $3, $5
	i64.add 	$6=, $6, $5
	#APP
	#NO_APP
	copy_local	$5=, $0
	i64.const	$push8=, 11
	i64.xor 	$push9=, $0, $pop8
	i64.or  	$push10=, $pop9, $6
	i64.ne  	$push11=, $pop10, $2
	br_if   	$pop11, BB0_1
BB0_2:                                  # %if.end
	i32.const	$9=, 16
	i32.add 	$12=, $12, $9
	i32.const	$9=, __stack_pointer
	i32.store	$12=, 0($9), $12
	return  	$1
func_end0:
	.size	main, func_end0-main

	.type	f,@object               # @f
	.bss
	.globl	f
	.align	2
f:
	.int32	0                       # float 0
	.size	f, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
