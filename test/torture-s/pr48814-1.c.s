	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48814-1.c"
	.section	.text.incr,"ax",@progbits
	.hidden	incr
	.globl	incr
	.type	incr,@function
incr:                                   # @incr
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, count($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push4=, count($pop0), $pop3
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	incr, .Lfunc_end0-incr

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push15=, 0
	i32.load	$push2=, count($pop15)
	tee_local	$push14=, $0=, $pop2
	i32.const	$push6=, 2
	i32.shl 	$push7=, $pop14, $pop6
	i32.call	$push1=, incr@FUNCTION
	i32.store	$discard=, arr($pop7), $pop1
	block
	i32.const	$push13=, 0
	i32.const	$push3=, 1
	i32.add 	$push4=, $0, $pop3
	i32.store	$push5=, count($pop13), $pop4
	i32.const	$push12=, 2
	i32.ne  	$push8=, $pop5, $pop12
	br_if   	0, $pop8        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push16=, 0
	i32.load	$push0=, arr+8($pop16):p2align=3
	i32.const	$push9=, 3
	i32.ne  	$push10=, $pop0, $pop9
	br_if   	0, $pop10       # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push11=, 0
	return  	$pop11
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
