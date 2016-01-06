	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-2.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.inc.1.1
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$push1=, w($0), $pop0
	i32.store	$discard=, w+12($0), $pop1
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, w+8($0)
	i32.load	$2=, w+4($0)
	block   	BB1_2
	i32.const	$push0=, 1
	i32.store	$push1=, w($0), $pop0
	i32.store	$discard=, w+12($0), $pop1
	i32.or  	$push2=, $2, $1
	br_if   	$pop2, BB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	w,@object               # @w
	.bss
	.globl	w
	.align	4
w:
	.zero	16
	.size	w, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
