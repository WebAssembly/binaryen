	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000503-1.c"
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2
	i32.add 	$0=, $0, $pop0
	i32.const	$1=, 0
	i32.lt_s	$push1=, $0, $1
	i32.select	$push2=, $pop1, $1, $0
	i32.const	$push3=, 2
	i32.shl 	$push4=, $pop2, $pop3
	return  	$pop4
func_end0:
	.size	sub, func_end0-sub

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
