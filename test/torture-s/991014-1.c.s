	.text
	.file	"991014-1.c"
	.section	.text.union_size,"ax",@progbits
	.hidden	union_size              # -- Begin function union_size
	.globl	union_size
	.type	union_size,@function
union_size:                             # @union_size
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1073741568
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	union_size, .Lfunc_end0-union_size
                                        # -- End function
	.section	.text.struct_size,"ax",@progbits
	.hidden	struct_size             # -- Begin function struct_size
	.globl	struct_size
	.type	struct_size,@function
struct_size:                            # @struct_size
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2147483152
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	struct_size, .Lfunc_end1-struct_size
                                        # -- End function
	.section	.text.struct_a_offset,"ax",@progbits
	.hidden	struct_a_offset         # -- Begin function struct_a_offset
	.globl	struct_a_offset
	.type	struct_a_offset,@function
struct_a_offset:                        # @struct_a_offset
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 2147483136
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	struct_a_offset, .Lfunc_end2-struct_a_offset
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
