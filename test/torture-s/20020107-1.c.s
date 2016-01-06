	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020107-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	#NO_APP
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	return  	$pop1
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, buf
	copy_local	$0=, $1
	#APP
	#NO_APP
	i32.const	$2=, 1
	block   	BB1_2
	i32.add 	$push0=, $0, $2
	i32.sub 	$push1=, $pop0, $1
	i32.ne  	$push2=, $pop1, $2
	br_if   	$pop2, BB1_2
# BB#1:                                 # %bar.exit
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	buf,@object             # @buf
	.bss
	.globl	buf
buf:
	.zero	10
	.size	buf, 10


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
