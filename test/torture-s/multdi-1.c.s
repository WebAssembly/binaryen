	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/multdi-1.c"
	.section	.text.mpy,"ax",@progbits
	.hidden	mpy
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
	.endfunc
.Lfunc_end0:
	.size	mpy, .Lfunc_end0-mpy

	.section	.text.main,"ax",@progbits
	.hidden	main
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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	mpy_res                 # @mpy_res
	.type	mpy_res,@object
	.section	.bss.mpy_res,"aw",@nobits
	.globl	mpy_res
	.align	3
mpy_res:
	.int64	0                       # 0x0
	.size	mpy_res, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
