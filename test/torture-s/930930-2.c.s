	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930930-2.c"
	.globl	test_endianness
	.type	test_endianness,@function
test_endianness:                        # @test_endianness
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	test_endianness, .Lfunc_end0-test_endianness

	.globl	test_endianness_vol
	.type	test_endianness_vol,@function
test_endianness_vol:                    # @test_endianness_vol
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i64.const	$push0=, 4621819117588971520
	i64.store	$discard=, 8($3), $pop0
	i32.load	$push1=, 8($3)
	i32.const	$push2=, 0
	i32.ne  	$push3=, $pop1, $pop2
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop3
.Lfunc_end1:
	.size	test_endianness_vol, .Lfunc_end1-test_endianness_vol

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$2=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$2=, 0($1), $2
	block   	.LBB2_2
	i64.const	$push0=, 4621819117588971520
	i64.store	$discard=, 8($2), $pop0
	i32.load	$push1=, 8($2)
	br_if   	$pop1, .LBB2_2
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit, $pop2
	unreachable
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
