	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48814-2.c"
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, count($pop15)
	tee_local	$push13=, $1=, $pop14
	i32.const	$push12=, 2
	i32.add 	$push0=, $pop13, $pop12
	i32.store	$0=, count($pop1), $pop0
	i32.const	$push2=, 1
	i32.add 	$push11=, $1, $pop2
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 2
	i32.shl 	$push3=, $pop10, $pop9
	i32.store	$drop=, arr($pop3), $2
	block
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push16=, 2
	i32.shl 	$push4=, $0, $pop16
	i32.load	$push5=, arr($pop4)
	i32.const	$push6=, 3
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
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
