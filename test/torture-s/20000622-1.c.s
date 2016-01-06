	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000622-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.const	$push0=, 12
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_4
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB0_4
# BB#2:                                 # %entry
	i32.const	$push4=, 11
	i32.ne  	$push5=, $2, $pop4
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$1
func_end1:
	.size	bar, func_end1-bar

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block   	BB2_3
	i32.const	$push0=, 11
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, BB2_3
# BB#1:                                 # %entry
	i32.const	$push2=, 12
	i32.ne  	$push3=, $2, $pop2
	br_if   	$pop3, BB2_3
# BB#2:                                 # %foo.exit
	return
BB2_3:                                  # %if.then.i
	call    	abort
	unreachable
func_end2:
	.size	baz, func_end2-baz

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end3:
	.size	main, func_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
