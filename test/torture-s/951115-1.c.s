	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/951115-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, var($pop0), $pop1
	return  	$0
func_end0:
	.size	g, func_end0-g

	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, var($pop0), $pop1
	return  	$0
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
	i32.store	$discard=, var($0), $pop0
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	var,@object             # @var
	.bss
	.globl	var
	.align	2
var:
	.int32	0                       # 0x0
	.size	var, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
