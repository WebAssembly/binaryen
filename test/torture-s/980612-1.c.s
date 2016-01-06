	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980612-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, f
	return  	$pop0
func_end0:
	.size	g, func_end0-g

	.globl	h
	.type	h,@function
h:                                      # @h
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	return  	$pop0
func_end1:
	.size	h, func_end1-h

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$1=, f($0)
	block   	BB2_2
	i32.const	$push0=, 255
	i32.store8	$discard=, f+1($0), $pop0
	i32.const	$push1=, 111
	i32.and 	$push2=, $1, $pop1
	i32.const	$push3=, 2
	i32.gt_u	$push4=, $pop2, $pop3
	br_if   	$pop4, BB2_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB2_2:                                  # %if.end
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	f,@object               # @f
	.data
	.globl	f
f:
	.int8	5                       # 0x5
	.int8	0                       # 0x0
	.size	f, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
