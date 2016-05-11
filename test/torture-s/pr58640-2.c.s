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
	i32.const	$push9=, 0
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.load	$push10=, a+36($pop23)
	i32.store	$push1=, a($pop24), $pop10
	i32.store	$discard=, a+4($pop9), $pop1
	i32.const	$push22=, 0
	i32.load	$1=, a+60($pop22)
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.const	$push8=, 1
	i32.store	$push3=, a($pop20), $pop8
	i32.store	$0=, a+4($pop21), $pop3
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.store	$push6=, a($pop18), $1
	i32.store	$discard=, a+4($pop19), $pop6
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.store	$push0=, a+48($pop12), $0
	i32.store	$push2=, c($pop13), $pop0
	i32.store	$push4=, c($pop14), $pop2
	i32.store	$push5=, c($pop15), $pop4
	i32.store	$push7=, c($pop16), $pop5
	i32.store	$discard=, c($pop17), $pop7
	i32.const	$push11=, 0
	return  	$pop11
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
	i32.const	$push3=, 1
	i32.store	$push0=, a+48($pop6), $pop3
	i32.store	$discard=, c($pop7), $pop0
	block
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.store	$push1=, a($pop4), $0
	i32.store	$push2=, a+4($pop5), $pop1
	br_if   	0, $pop2        # 0: down to label0
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
