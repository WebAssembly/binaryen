	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031214-1.c"
	.section	.text.b,"ax",@progbits
	.hidden	b
	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	b, .Lfunc_end0-b

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push17=, 0
	i32.load	$push16=, k($pop17)
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, 0
	i32.load	$push13=, g+8($pop14)
	tee_local	$push12=, $0=, $pop13
	i32.gt_s	$push1=, $1, $0
	i32.select	$push11=, $pop15, $pop12, $pop1
	tee_local	$push10=, $1=, $pop11
	i32.const	$push9=, 0
	i32.load	$push8=, g+12($pop9)
	tee_local	$push7=, $0=, $pop8
	i32.gt_s	$push2=, $1, $0
	i32.select	$push3=, $pop10, $pop7, $pop2
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	k($pop0), $pop5
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	g                       # @g
	.type	g,@object
	.section	.data.g,"aw",@progbits
	.globl	g
	.p2align	3
g:
	.int64	0                       # double 0
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	g, 16

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.p2align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
