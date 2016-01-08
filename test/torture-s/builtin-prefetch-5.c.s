	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-5.c"
	.section	.text.arg_ptr,"ax",@progbits
	.hidden	arg_ptr
	.globl	arg_ptr
	.type	arg_ptr,@function
arg_ptr:                                # @arg_ptr
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	arg_ptr, .Lfunc_end0-arg_ptr

	.section	.text.arg_idx,"ax",@progbits
	.hidden	arg_idx
	.globl	arg_idx
	.type	arg_idx,@function
arg_idx:                                # @arg_idx
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	arg_idx, .Lfunc_end1-arg_idx

	.section	.text.glob_ptr,"ax",@progbits
	.hidden	glob_ptr
	.globl	glob_ptr
	.type	glob_ptr,@function
glob_ptr:                               # @glob_ptr
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	glob_ptr, .Lfunc_end2-glob_ptr

	.section	.text.glob_idx,"ax",@progbits
	.hidden	glob_idx
	.globl	glob_idx
	.type	glob_idx,@function
glob_idx:                               # @glob_idx
# BB#0:                                 # %entry
	return
.Lfunc_end3:
	.size	glob_idx, .Lfunc_end3-glob_idx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, ptr($0)
	i32.const	$push0=, 3
	i32.store	$discard=, idx($0), $pop0
	i32.const	$push1=, 1
	i32.add 	$push2=, $1, $pop1
	i32.store	$discard=, ptr($0), $pop2
	i32.const	$push3=, 2
	i32.store	$discard=, idx($0), $pop3
	call    	exit, $0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.align	4
arr:
	.skip	100
	.size	arr, 100

	.hidden	ptr                     # @ptr
	.type	ptr,@object
	.section	.data.ptr,"aw",@progbits
	.globl	ptr
	.align	2
ptr:
	.int32	arr
	.size	ptr, 4

	.hidden	idx                     # @idx
	.type	idx,@object
	.section	.data.idx,"aw",@progbits
	.globl	idx
	.align	2
idx:
	.int32	3                       # 0x3
	.size	idx, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	1
s:
	.skip	12
	.size	s, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
