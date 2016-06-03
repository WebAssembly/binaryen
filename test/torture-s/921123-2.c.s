	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921123-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load16_u	$push0=, 4($0)
	i32.store	$drop=, b($pop1), $pop0
	i32.const	$push3=, 0
	i32.load16_u	$push2=, 6($0)
	i32.store	$drop=, a($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push2=, 0
	i32.const	$push1=, 38
	i32.store	$drop=, a($pop2), $pop1
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.store	$push0=, b($pop4), $pop3
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	1
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
