	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000528-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load16_u	$push0=, l($0)
	i32.store16	$push1=, s($0), $pop0
	i32.const	$push2=, 65534
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	l,@object               # @l
	.data
	.globl	l
	.align	2
l:
	.int32	4294967294              # 0xfffffffe
	.size	l, 4

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	1
s:
	.int16	0                       # 0x0
	.size	s, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
