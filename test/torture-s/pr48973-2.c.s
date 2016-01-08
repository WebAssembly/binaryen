	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48973-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, v($0)
	i32.const	$push1=, 31
	i32.shr_u	$1=, $pop0, $pop1
	i32.load8_u	$push2=, s($0)
	i32.const	$push3=, 254
	i32.and 	$push4=, $pop2, $pop3
	i32.or  	$push5=, $pop4, $1
	i32.store8	$discard=, s($0), $pop5
	i32.const	$push6=, 1
	i32.ne  	$push7=, $1, $pop6
	br_if   	$pop7, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.align	2
v:
	.int32	4294967295              # 0xffffffff
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
