	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48814-2.c"
	.section	.text.incr,"ax",@progbits
	.hidden	incr
	.globl	incr
	.type	incr,@function
incr:                                   # @incr
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, count($pop5)
	i32.const	$push2=, 1
	i32.add 	$push4=, $pop1, $pop2
	tee_local	$push3=, $0=, $pop4
	i32.store	count($pop0), $pop3
	copy_local	$push6=, $0
                                        # fallthrough-return: $pop6
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
	i32.const	$push0=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, count($pop19)
	tee_local	$push17=, $1=, $pop18
	i32.const	$push16=, 2
	i32.add 	$push15=, $pop17, $pop16
	tee_local	$push14=, $0=, $pop15
	i32.store	count($pop0), $pop14
	i32.const	$push1=, 1
	i32.add 	$push13=, $1, $pop1
	tee_local	$push12=, $2=, $pop13
	i32.const	$push11=, 2
	i32.shl 	$push2=, $pop12, $pop11
	i32.const	$push10=, arr
	i32.add 	$push3=, $pop2, $pop10
	i32.store	0($pop3), $2
	block   	
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push21=, 2
	i32.shl 	$push4=, $0, $pop21
	i32.const	$push20=, arr
	i32.add 	$push5=, $pop4, $pop20
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
