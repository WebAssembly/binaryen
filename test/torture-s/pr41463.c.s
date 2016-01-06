	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr41463.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $1, $pop0
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, 24
	i32.add 	$1=, $pop2, $pop3
	i32.const	$push4=, 0
	i32.store	$discard=, 0($1), $pop4
	i32.const	$push5=, 28
	i32.add 	$push6=, $0, $pop5
	i32.const	$push7=, global
	i32.store	$discard=, 0($pop6), $pop7
	i32.load	$push8=, 0($1)
	return  	$pop8
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push0=, 76
	i32.call	$push1=, malloc, $pop0
	i32.const	$push2=, 1
	i32.call	$push3=, foo, $pop1, $pop2
	i32.const	$push4=, global
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	return  	$pop6
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	global,@object          # @global
	.bss
	.globl	global
	.align	2
global:
	.zero	76
	.size	global, 76


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
