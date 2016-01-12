	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930622-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.h,"ax",@progbits
	.hidden	h
	.globl	h
	.type	h,@function
h:                                      # @h
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$1
.Lfunc_end1:
	.size	h, .Lfunc_end1-h

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$push0=, a($0), $0
	return  	$pop0
.Lfunc_end2:
	.size	f, .Lfunc_end2-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store	$push0=, a($0), $0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
