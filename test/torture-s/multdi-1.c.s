	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/multdi-1.c"
	.globl	mpy
	.type	mpy,@function
mpy:                                    # @mpy
	.param  	i32, i32
	.result 	i64
# BB#0:                                 # %entry
	i64.extend_s/i32	$push1=, $1
	i64.extend_s/i32	$push0=, $0
	i64.mul 	$push2=, $pop1, $pop0
	return  	$pop2
.Lfunc_end0:
	.size	mpy, .Lfunc_end0-mpy

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i64.const	$push0=, -1
	i64.store	$discard=, mpy_res($0), $pop0
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	mpy_res,@object         # @mpy_res
	.bss
	.globl	mpy_res
	.align	3
mpy_res:
	.int64	0                       # 0x0
	.size	mpy_res, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
