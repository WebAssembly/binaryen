	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-5.c"
	.section	.text.arg_ptr,"ax",@progbits
	.hidden	arg_ptr
	.globl	arg_ptr
	.type	arg_ptr,@function
arg_ptr:                                # @arg_ptr
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	arg_ptr, .Lfunc_end0-arg_ptr

	.section	.text.arg_idx,"ax",@progbits
	.hidden	arg_idx
	.globl	arg_idx
	.type	arg_idx,@function
arg_idx:                                # @arg_idx
	.param  	i32, i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	arg_idx, .Lfunc_end1-arg_idx

	.section	.text.glob_ptr,"ax",@progbits
	.hidden	glob_ptr
	.globl	glob_ptr
	.type	glob_ptr,@function
glob_ptr:                               # @glob_ptr
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	glob_ptr, .Lfunc_end2-glob_ptr

	.section	.text.glob_idx,"ax",@progbits
	.hidden	glob_idx
	.globl	glob_idx
	.type	glob_idx,@function
glob_idx:                               # @glob_idx
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	glob_idx, .Lfunc_end3-glob_idx

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	idx($pop1), $pop0
	call    	glob_ptr@FUNCTION
	call    	glob_idx@FUNCTION
	i32.const	$push9=, 0
	i32.const	$push2=, 2
	i32.store	idx($pop9), $pop2
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.load	$push3=, ptr($pop7)
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop3, $pop4
	i32.store	ptr($pop8), $pop5
	call    	glob_ptr@FUNCTION
	call    	glob_idx@FUNCTION
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.hidden	arr                     # @arr
	.type	arr,@object
	.section	.bss.arr,"aw",@nobits
	.globl	arr
	.p2align	4
arr:
	.skip	100
	.size	arr, 100

	.hidden	ptr                     # @ptr
	.type	ptr,@object
	.section	.data.ptr,"aw",@progbits
	.globl	ptr
	.p2align	2
ptr:
	.int32	arr
	.size	ptr, 4

	.hidden	idx                     # @idx
	.type	idx,@object
	.section	.data.idx,"aw",@progbits
	.globl	idx
	.p2align	2
idx:
	.int32	3                       # 0x3
	.size	idx, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	1
s:
	.skip	12
	.size	s, 12


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
