	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991014-1.c"
	.globl	union_size
	.type	union_size,@function
union_size:                             # @union_size
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1073741568
	return  	$pop0
func_end0:
	.size	union_size, func_end0-union_size

	.globl	struct_size
	.type	struct_size,@function
struct_size:                            # @struct_size
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483152
	return  	$pop0
func_end1:
	.size	struct_size, func_end1-struct_size

	.globl	struct_a_offset
	.type	struct_a_offset,@function
struct_a_offset:                        # @struct_a_offset
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483136
	return  	$pop0
func_end2:
	.size	struct_a_offset, func_end2-struct_a_offset

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end3:
	.size	main, func_end3-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
