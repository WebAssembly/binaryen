	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr24141.c"
	.globl	g
	.type	g,@function
g:                                      # @g
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, i($pop0), $pop1
	return
func_end0:
	.size	g, func_end0-g

	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB1_3
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, BB1_3
# BB#1:                                 # %entry
	br_if   	$1, BB1_3
# BB#2:                                 # %if.then10
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, i($pop0), $pop1
BB1_3:                                  # %cleanup
	return
func_end1:
	.size	f, func_end1-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, i($0), $pop0
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
