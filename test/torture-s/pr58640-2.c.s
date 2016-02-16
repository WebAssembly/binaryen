	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640-2.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load	$push3=, a+36($pop19)
	i32.store	$push4=, a($pop20):p2align=4, $pop3
	i32.store	$discard=, a+4($pop1), $pop4
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.const	$push0=, 1
	i32.store	$push2=, a+48($pop16):p2align=4, $pop0
	i32.store	$push5=, c($pop17), $pop2
	i32.store	$0=, c($pop18), $pop5
	i32.const	$push15=, 0
	i32.load	$1=, a+60($pop15)
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.store	$push6=, a($pop12):p2align=4, $0
	i32.store	$push7=, a+4($pop13), $pop6
	i32.store	$discard=, c($pop14), $pop7
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.store	$push8=, a($pop10):p2align=4, $1
	i32.store	$discard=, a+4($pop11), $pop8
	i32.const	$push9=, 0
	return  	$pop9
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$0=, a+60($pop8)
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.const	$push0=, 1
	i32.store	$push1=, a+48($pop6):p2align=4, $pop0
	i32.store	$discard=, c($pop7), $pop1
	block
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store	$push2=, a($pop4):p2align=4, $0
	i32.store	$push3=, a+4($pop5), $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	80
	.size	a, 80

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.9.0 "
