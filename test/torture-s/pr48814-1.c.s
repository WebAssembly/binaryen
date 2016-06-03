	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48814-1.c"
	.section	.text.incr,"ax",@progbits
	.hidden	incr
	.globl	incr
	.type	incr,@function
incr:                                   # @incr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push5=, 0
	i32.load	$push2=, count($pop5)
	i32.const	$push3=, 1
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$push0=, count($pop1), $pop4
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	incr, .Lfunc_end0-incr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.call	$0=, incr@FUNCTION
	i32.const	$push14=, 0
	i32.load	$push13=, count($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push2=, 2
	i32.shl 	$push3=, $pop12, $pop2
	i32.store	$drop=, arr($pop3), $0
	block
	i32.const	$push11=, 0
	i32.const	$push4=, 1
	i32.add 	$push5=, $1, $pop4
	i32.store	$push0=, count($pop11), $pop5
	i32.const	$push10=, 2
	i32.ne  	$push6=, $pop0, $pop10
	br_if   	0, $pop6        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push1=, arr+8($pop15)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop1, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.data.arr,"aw",@progbits
	.globl	arr
	.p2align	4
arr:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.size	arr, 16

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
