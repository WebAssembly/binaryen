	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020206-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 176
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 52
	i32.store	$discard=, 4($0), $pop1
	i32.const	$push2=, 31
	i32.store	$discard=, 8($0), $pop2
	return
func_end0:
	.size	bar, func_end0-bar

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	block   	BB1_4
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 176
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB1_4
# BB#1:                                 # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 52
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB1_4
# BB#2:                                 # %lor.lhs.false3
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 31
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, BB1_4
# BB#3:                                 # %if.end
	return
BB1_4:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	baz, func_end1-baz

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %baz.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
