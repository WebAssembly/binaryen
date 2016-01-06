	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050613-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_5
	i32.load	$push0=, 0($0)
	br_if   	$pop0, BB0_5
# BB#1:                                 # %lor.lhs.false
	i32.load	$push1=, 4($0)
	i32.const	$push2=, 5
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_5
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push4=, 8($0)
	br_if   	$pop4, BB0_5
# BB#3:                                 # %lor.lhs.false4
	i32.load	$push5=, 12($0)
	br_if   	$pop5, BB0_5
# BB#4:                                 # %if.end
	return
BB0_5:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %foo.exit28
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
