	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-2.c"
	.globl	simple_global
	.type	simple_global,@function
simple_global:                          # @simple_global
# BB#0:                                 # %entry
	return
.Lfunc_end0:
	.size	simple_global, .Lfunc_end0-simple_global

	.globl	simple_file
	.type	simple_file,@function
simple_file:                            # @simple_file
# BB#0:                                 # %entry
	return
.Lfunc_end1:
	.size	simple_file, .Lfunc_end1-simple_file

	.globl	simple_static_local
	.type	simple_static_local,@function
simple_static_local:                    # @simple_static_local
# BB#0:                                 # %entry
	return
.Lfunc_end2:
	.size	simple_static_local, .Lfunc_end2-simple_static_local

	.globl	simple_local
	.type	simple_local,@function
simple_local:                           # @simple_local
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 416
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$2=, 416
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return
.Lfunc_end3:
	.size	simple_local, .Lfunc_end3-simple_local

	.globl	simple_arg
	.type	simple_arg,@function
simple_arg:                             # @simple_arg
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$3=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$3=, 0($4), $3
	i32.store	$discard=, 12($3), $2
	i32.const	$5=, 16
	i32.add 	$3=, $3, $5
	i32.const	$5=, __stack_pointer
	i32.store	$3=, 0($5), $3
	return
.Lfunc_end4:
	.size	simple_arg, .Lfunc_end4-simple_arg

	.globl	expr_global
	.type	expr_global,@function
expr_global:                            # @expr_global
# BB#0:                                 # %entry
	return
.Lfunc_end5:
	.size	expr_global, .Lfunc_end5-expr_global

	.globl	expr_local
	.type	expr_local,@function
expr_local:                             # @expr_local
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 80
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$2=, 80
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return
.Lfunc_end6:
	.size	expr_local, .Lfunc_end6-expr_local

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 80
	i32.sub 	$3=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	i32.const	$0=, 0
	i32.load	$push0=, glob_int($0)
	i32.store	$discard=, 32($3), $pop0
	i32.const	$push1=, str
	i32.store	$discard=, str+16($0), $pop1
	call    	exit, $0
	unreachable
.Lfunc_end7:
	.size	main, .Lfunc_end7-main

	.type	glob_int_arr,@object    # @glob_int_arr
	.bss
	.globl	glob_int_arr
	.align	4
glob_int_arr:
	.zero	400
	.size	glob_int_arr, 400

	.type	glob_ptr_int,@object    # @glob_ptr_int
	.data
	.globl	glob_ptr_int
	.align	2
glob_ptr_int:
	.int32	glob_int_arr
	.size	glob_ptr_int, 4

	.type	glob_int,@object        # @glob_int
	.globl	glob_int
	.align	2
glob_int:
	.int32	4                       # 0x4
	.size	glob_int, 4

	.type	str,@object             # @str
	.bss
	.globl	str
	.align	2
str:
	.zero	20
	.size	str, 20

	.type	ptr_str,@object         # @ptr_str
	.data
	.globl	ptr_str
	.align	2
ptr_str:
	.int32	str
	.size	ptr_str, 4

	.type	stat_int_arr,@object    # @stat_int_arr
	.lcomm	stat_int_arr,400,4
	.type	stat_int,@object        # @stat_int
	.lcomm	stat_int,4,2
	.type	simple_static_local.gx,@object # @simple_static_local.gx
	.lcomm	simple_static_local.gx,400,4
	.type	simple_static_local.ix,@object # @simple_static_local.ix
	.lcomm	simple_static_local.ix,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
