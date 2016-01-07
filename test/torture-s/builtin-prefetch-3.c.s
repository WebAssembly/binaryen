	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-3.c"
	.globl	simple_vol_global
	.type	simple_vol_global,@function
simple_vol_global:                      # @simple_vol_global
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	return
.Lfunc_end0:
	.size	simple_vol_global, .Lfunc_end0-simple_vol_global

	.globl	simple_vol_file
	.type	simple_vol_file,@function
simple_vol_file:                        # @simple_vol_file
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$discard=, stat_vol_ptr_int($0)
	i32.load	$discard=, stat_vol_ptr_vol_int($0)
	return
.Lfunc_end1:
	.size	simple_vol_file, .Lfunc_end1-simple_vol_file

	.globl	expr_vol_global
	.type	expr_vol_global,@function
expr_vol_global:                        # @expr_vol_global
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$discard=, vol_ptr_str($0)
	i32.load	$discard=, vol_ptr_vol_str($0)
	i32.load	$discard=, vol_ptr_str($0)
	i32.load	$discard=, vol_ptr_vol_str($0)
	i32.load	$discard=, vol_ptr_str($0)
	i32.load	$discard=, vol_ptr_vol_str($0)
	i32.load	$discard=, vol_str+16($0)
	i32.load	$discard=, vol_ptr_str($0)
	i32.load	$push0=, ptr_vol_str($0)
	i32.load	$discard=, 16($pop0)
	i32.load	$push1=, vol_ptr_vol_str($0)
	i32.load	$discard=, 16($pop1)
	i32.load	$discard=, vol_str+16($0)
	i32.load	$discard=, vol_ptr_str($0)
	i32.load	$push2=, ptr_vol_str($0)
	i32.load	$discard=, 16($pop2)
	i32.load	$push3=, vol_ptr_vol_str($0)
	i32.load	$discard=, 16($pop3)
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	i32.load	$discard=, glob_vol_int($0)
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_int($0)
	i32.load	$discard=, glob_vol_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	i32.load	$discard=, glob_vol_int($0)
	return
.Lfunc_end2:
	.size	expr_vol_global, .Lfunc_end2-expr_vol_global

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$discard=, glob_vol_ptr_int($0)
	i32.load	$discard=, glob_vol_ptr_vol_int($0)
	i32.load	$discard=, stat_vol_ptr_int($0)
	i32.load	$discard=, stat_vol_ptr_vol_int($0)
	i32.const	$push0=, str
	i32.store	$push1=, str+16($0), $pop0
	i32.store	$discard=, vol_str+16($0), $pop1
	call    	expr_vol_global
	call    	exit, $0
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	glob_int,@object        # @glob_int
	.data
	.globl	glob_int
	.align	2
glob_int:
	.int32	4                       # 0x4
	.size	glob_int, 4

	.type	glob_int_arr,@object    # @glob_int_arr
	.bss
	.globl	glob_int_arr
	.align	4
glob_int_arr:
	.zero	400
	.size	glob_int_arr, 400

	.type	glob_vol_ptr_int,@object # @glob_vol_ptr_int
	.data
	.globl	glob_vol_ptr_int
	.align	2
glob_vol_ptr_int:
	.int32	glob_int_arr
	.size	glob_vol_ptr_int, 4

	.type	glob_vol_int_arr,@object # @glob_vol_int_arr
	.bss
	.globl	glob_vol_int_arr
	.align	4
glob_vol_int_arr:
	.zero	400
	.size	glob_vol_int_arr, 400

	.type	glob_ptr_vol_int,@object # @glob_ptr_vol_int
	.data
	.globl	glob_ptr_vol_int
	.align	2
glob_ptr_vol_int:
	.int32	glob_vol_int_arr
	.size	glob_ptr_vol_int, 4

	.type	glob_vol_ptr_vol_int,@object # @glob_vol_ptr_vol_int
	.globl	glob_vol_ptr_vol_int
	.align	2
glob_vol_ptr_vol_int:
	.int32	glob_vol_int_arr
	.size	glob_vol_ptr_vol_int, 4

	.type	str,@object             # @str
	.bss
	.globl	str
	.align	2
str:
	.zero	20
	.size	str, 20

	.type	vol_ptr_str,@object     # @vol_ptr_str
	.data
	.globl	vol_ptr_str
	.align	2
vol_ptr_str:
	.int32	str
	.size	vol_ptr_str, 4

	.type	vol_str,@object         # @vol_str
	.bss
	.globl	vol_str
	.align	2
vol_str:
	.zero	20
	.size	vol_str, 20

	.type	ptr_vol_str,@object     # @ptr_vol_str
	.data
	.globl	ptr_vol_str
	.align	2
ptr_vol_str:
	.int32	vol_str
	.size	ptr_vol_str, 4

	.type	vol_ptr_vol_str,@object # @vol_ptr_vol_str
	.globl	vol_ptr_vol_str
	.align	2
vol_ptr_vol_str:
	.int32	vol_str
	.size	vol_ptr_vol_str, 4

	.type	glob_vol_int,@object    # @glob_vol_int
	.bss
	.globl	glob_vol_int
	.align	2
glob_vol_int:
	.int32	0                       # 0x0
	.size	glob_vol_int, 4

	.type	stat_vol_int_arr,@object # @stat_vol_int_arr
	.lcomm	stat_vol_int_arr,400,4
	.type	stat_vol_ptr_int,@object # @stat_vol_ptr_int
	.data
	.align	2
stat_vol_ptr_int:
	.int32	stat_int_arr
	.size	stat_vol_ptr_int, 4

	.type	stat_vol_ptr_vol_int,@object # @stat_vol_ptr_vol_int
	.align	2
stat_vol_ptr_vol_int:
	.int32	stat_vol_int_arr
	.size	stat_vol_ptr_vol_int, 4

	.type	stat_vol_int,@object    # @stat_vol_int
	.lcomm	stat_vol_int,4,2
	.type	stat_int_arr,@object    # @stat_int_arr
	.lcomm	stat_int_arr,400,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
