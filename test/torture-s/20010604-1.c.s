	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010604-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$7=, 1
	block   	.LBB0_5
	i32.const	$push3=, 255
	i32.and 	$push4=, $6, $pop3
	i32.ne  	$push5=, $pop4, $7
	br_if   	$pop5, .LBB0_5
# BB#1:                                 # %entry
	i32.xor 	$push0=, $3, $7
	br_if   	$pop0, .LBB0_5
# BB#2:                                 # %entry
	i32.xor 	$push1=, $4, $7
	br_if   	$pop1, .LBB0_5
# BB#3:                                 # %entry
	i32.xor 	$push2=, $5, $7
	br_if   	$pop2, .LBB0_5
# BB#4:                                 # %if.end
	i32.add 	$push6=, $1, $0
	i32.add 	$push7=, $pop6, $2
	return  	$pop7
.LBB0_5:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
