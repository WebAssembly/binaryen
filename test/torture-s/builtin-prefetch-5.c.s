	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-5.c"
	.globl	arg_ptr
	.type	arg_ptr,@function
arg_ptr:                                # @arg_ptr
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	arg_ptr, .Lfunc_end0-arg_ptr

	.globl	arg_idx
	.type	arg_idx,@function
arg_idx:                                # @arg_idx
	.param  	i32, i32
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	arg_idx, .Lfunc_end1-arg_idx

	.globl	glob_ptr
	.type	glob_ptr,@function
glob_ptr:                               # @glob_ptr
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	glob_ptr, .Lfunc_end2-glob_ptr

	.globl	glob_idx
	.type	glob_idx,@function
glob_idx:                               # @glob_idx
# BB#0:                                 # %entry
	return
.Lfunc_end3:
	.size	glob_idx, .Lfunc_end3-glob_idx

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

	.type	arr,@object             # @arr
	.bss
	.globl	arr
	.align	4
arr:
	.zero	100
	.size	arr, 100

	.type	ptr,@object             # @ptr
	.data
	.globl	ptr
	.align	2
ptr:
	.int32	arr
	.size	ptr, 4

	.type	idx,@object             # @idx
	.globl	idx
	.align	2
idx:
	.int32	3                       # 0x3
	.size	idx, 4

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	1
s:
	.zero	12
	.size	s, 12


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
