	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120111-1.c"
	.globl	f0a
	.type	f0a,@function
f0a:                                    # @f0a
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, -3
	i64.gt_u	$push1=, $0, $pop0
	i32.const	$push2=, -1
	i32.xor 	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	f0a, func_end0-f0a

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i64.const	$push0=, -6352373499721454287
	i32.call	$push1=, f0a, $pop0
	i32.const	$push2=, -1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
