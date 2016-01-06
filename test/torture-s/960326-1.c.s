	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960326-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, s+4($0)
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	s,@object               # @s
	.data
	.globl	s
	.align	2
s:
	.int32	0                       # 0x0
	.int32	3                       # 0x3
	.int16	0                       # 0x0
	.zero	2
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.size	s, 24


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
