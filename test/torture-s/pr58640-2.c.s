	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640-2.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.load	$push2=, a+36($0)
	i32.store	$push3=, a($0), $pop2
	i32.store	$discard=, a+4($0), $pop3
	i32.const	$push0=, 1
	i32.store	$push1=, a+48($0), $pop0
	i32.store	$push4=, c($0), $pop1
	i32.store	$1=, c($0), $pop4
	i32.load	$2=, a+60($0)
	i32.store	$push5=, a($0), $1
	i32.store	$push6=, a+4($0), $pop5
	i32.store	$discard=, c($0), $pop6
	i32.store	$push7=, a($0), $2
	i32.store	$discard=, a+4($0), $pop7
	return  	$0
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, a+60($0)
	block   	.LBB1_2
	i32.const	$push0=, 1
	i32.store	$push1=, a+48($0), $pop0
	i32.store	$discard=, c($0), $pop1
	i32.store	$push2=, a($0), $1
	i32.store	$push3=, a+4($0), $pop2
	br_if   	$pop3, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.align	4
a:
	.skip	80
	.size	a, 80

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
