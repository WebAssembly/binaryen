	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980424-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	f, func_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
# BB#0:                                 # %entry
	block   	BB1_2
	i32.const	$push6=, a
	i32.const	$push0=, 0
	i32.load	$push1=, i($pop0)
	i32.const	$push2=, 63
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2
	i32.shl 	$push5=, $pop3, $pop4
	i32.add 	$push7=, $pop6, $pop5
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, BB1_2
# BB#1:                                 # %f.exit
	return
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	g, func_end1-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %g.exit
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, a($0), $pop0
	i32.const	$push1=, 64
	i32.store	$discard=, i($0), $pop1
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	a,@object               # @a
	.globl	a
	.align	4
a:
	.zero	396
	.size	a, 396


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
