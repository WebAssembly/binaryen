	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-1.c"
	.globl	sat_add
	.type	sat_add,@function
sat_add:                                # @sat_add
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.eq  	$push2=, $0, $1
	i32.const	$push0=, 1
	i32.add 	$push1=, $0, $pop0
	i32.select	$push3=, $pop2, $1, $pop1
	return  	$pop3
func_end0:
	.size	sat_add, func_end0-sat_add

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
