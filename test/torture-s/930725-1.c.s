	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930725-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	return  	$pop0
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, v($pop0)
	i32.const	$push3=, .L.str.1
	i32.const	$push2=, .L.str
	i32.select	$push4=, $pop1, $pop3, $pop2
	return  	$pop4
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, v($0), $pop0
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.skip	1
	.size	.L.str, 1

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.align	2
v:
	.int32	0                       # 0x0
	.size	v, 4

	.type	.L.str.1,@object        # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"abc"
	.size	.L.str.1, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
