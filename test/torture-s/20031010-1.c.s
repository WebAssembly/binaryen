	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031010-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.const	$push2=, 0
	i32.eq  	$push3=, $2, $pop2
	br_if   	$pop3, BB0_4
# BB#1:                                 # %if.then
	i32.sub 	$2=, $0, $1
	block   	BB0_3
	i32.const	$push4=, 0
	i32.eq  	$push5=, $3, $pop4
	br_if   	$pop5, BB0_3
# BB#2:                                 # %if.then4
	i32.select	$push1=, $4, $1, $0
	i32.select	$push0=, $4, $0, $1
	i32.sub 	$2=, $pop1, $pop0
BB0_3:                                  # %if.end8
	return  	$2
BB0_4:                                  # %if.end9
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	block   	BB1_2
	i32.const	$push1=, 2
	i32.const	$push0=, 3
	i32.call	$push2=, foo, $pop1, $pop0, $0, $0, $0
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop2, $pop4
	br_if   	$pop5, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	return  	$pop3
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
