	.text
	.file	"pr58640-2.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1                     # -- Begin function fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32
# BB#0:                                 # %for.body3.split
	i32.const	$push1=, 0
	i64.const	$push0=, 4294967297
	i64.store	a($pop1), $pop0
	i32.const	$push11=, 0
	i32.const	$push2=, 1
	i32.store	a+48($pop11), $pop2
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.store	c($pop10), $pop9
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push6=, a+60($pop7)
	tee_local	$push5=, $0=, $pop6
	i32.store	a($pop8), $pop5
	i32.const	$push4=, 0
	i32.store	a+4($pop4), $0
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push0=, 1
	i32.store	a+48($pop8), $pop0
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store	c($pop7), $pop6
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, a+60($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.store	a($pop5), $pop2
	i32.const	$push1=, 0
	i32.store	a+4($pop1), $0
	block   	
	br_if   	0, $0           # 0: down to label0
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
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
