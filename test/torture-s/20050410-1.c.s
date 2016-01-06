	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050410-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 24
	i32.const	$push0=, 0
	i32.load	$push1=, s($pop0)
	i32.shl 	$push2=, $pop1, $0
	i32.const	$push3=, -1677721600
	i32.add 	$push4=, $pop2, $pop3
	i32.shr_s	$push5=, $pop4, $0
	i32.const	$push6=, -5
	i32.add 	$push7=, $pop5, $pop6
	return  	$pop7
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	i32.call	$push0=, foo
	i32.const	$push1=, 95
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	s,@object               # @s
	.data
	.globl	s
	.align	2
s:
	.int32	200                     # 0xc8
	.size	s, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
