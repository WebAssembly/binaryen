	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001024-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB0_5
	i32.load	$push0=, 0($1)
	br_if   	$pop0, BB0_5
# BB#1:                                 # %lor.lhs.false
	i32.const	$3=, 250000
	i32.load	$push1=, 4($1)
	i32.ne  	$push2=, $pop1, $3
	br_if   	$pop2, BB0_5
# BB#2:                                 # %lor.lhs.false2
	i32.load	$push3=, 8($1)
	br_if   	$pop3, BB0_5
# BB#3:                                 # %lor.lhs.false5
	i32.const	$push4=, 12
	i32.add 	$push5=, $1, $pop4
	i32.load	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $3
	br_if   	$pop7, BB0_5
# BB#4:                                 # %if.end
	return  	$1
BB0_5:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %bar.exit
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
