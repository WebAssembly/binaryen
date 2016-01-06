	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/990604-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, b($0)
	br_if   	$pop0, BB0_2
# BB#1:                                 # %do.body.preheader
	i32.const	$push1=, 9
	i32.store	$discard=, b($0), $pop1
BB0_2:                                  # %if.end
	return
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, b($1)
	i32.const	$2=, 9
	block   	BB1_4
	i32.eq  	$push0=, $0, $2
	br_if   	$pop0, BB1_4
# BB#1:                                 # %entry
	block   	BB1_3
	br_if   	$0, BB1_3
# BB#2:                                 # %f.exit.thread
	i32.store	$discard=, b($1), $2
	br      	BB1_4
BB1_3:                                  # %if.then
	call    	abort
	unreachable
BB1_4:                                  # %if.end
	return  	$1
func_end1:
	.size	main, func_end1-main

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
