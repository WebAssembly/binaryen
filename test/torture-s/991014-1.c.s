	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991014-1.c"
	.section	.text.union_size,"ax",@progbits
	.hidden	union_size
	.globl	union_size
	.type	union_size,@function
union_size:                             # @union_size
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1073741568
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	union_size, .Lfunc_end0-union_size

	.section	.text.struct_size,"ax",@progbits
	.hidden	struct_size
	.globl	struct_size
	.type	struct_size,@function
struct_size:                            # @struct_size
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483152
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	struct_size, .Lfunc_end1-struct_size

	.section	.text.struct_a_offset,"ax",@progbits
	.hidden	struct_a_offset
	.globl	struct_a_offset
	.type	struct_a_offset,@function
struct_a_offset:                        # @struct_a_offset
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483136
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	struct_a_offset, .Lfunc_end2-struct_a_offset

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
