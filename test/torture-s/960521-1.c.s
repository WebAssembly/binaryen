	.text
	.file	"960521-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	i32.load	$push0=, n($pop8)
	i32.const	$push7=, 1
	i32.lt_s	$push1=, $pop0, $pop7
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i32.const	$push9=, 0
	i32.load	$0=, a($pop9)
	i32.const	$1=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push15=, -1
	i32.store	0($0), $pop15
	i32.const	$push14=, 4
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 0
	i32.load	$push2=, n($pop10)
	i32.lt_s	$push3=, $pop11, $pop2
	br_if   	0, $pop3        # 0: up to label1
.LBB0_3:                                # %for.end
	end_loop
	end_block                       # label0:
	i32.const	$push16=, 0
	i32.load	$push4=, b($pop16)
	i32.const	$push6=, 255
	i32.const	$push5=, 522236
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop6, $pop5
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 130560
	i32.store	n($pop1), $pop0
	i32.const	$push18=, 0
	i32.const	$push2=, 522240
	i32.call	$push17=, malloc@FUNCTION, $pop2
	tee_local	$push16=, $0=, $pop17
	i32.store	a($pop18), $pop16
	i32.const	$push15=, 522240
	i32.call	$push14=, malloc@FUNCTION, $pop15
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 0
	i32.store	0($pop13), $pop12
	i32.const	$push11=, 0
	i32.const	$push3=, 4
	i32.add 	$push10=, $1, $pop3
	tee_local	$push9=, $1=, $pop10
	i32.store	b($pop11), $pop9
	i32.const	$push4=, 255
	i32.const	$push8=, 522240
	i32.call	$drop=, memset@FUNCTION, $0, $pop4, $pop8
	i32.const	$push7=, 255
	i32.const	$push5=, 522236
	i32.call	$drop=, memset@FUNCTION, $1, $pop7, $pop5
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	malloc, i32, i32
	.functype	exit, void, i32
