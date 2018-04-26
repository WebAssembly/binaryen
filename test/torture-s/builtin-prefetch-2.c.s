	.text
	.file	"builtin-prefetch-2.c"
	.section	.text.simple_global,"ax",@progbits
	.hidden	simple_global           # -- Begin function simple_global
	.globl	simple_global
	.type	simple_global,@function
simple_global:                          # @simple_global
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	simple_global, .Lfunc_end0-simple_global
                                        # -- End function
	.section	.text.simple_file,"ax",@progbits
	.hidden	simple_file             # -- Begin function simple_file
	.globl	simple_file
	.type	simple_file,@function
simple_file:                            # @simple_file
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	simple_file, .Lfunc_end1-simple_file
                                        # -- End function
	.section	.text.simple_static_local,"ax",@progbits
	.hidden	simple_static_local     # -- Begin function simple_static_local
	.globl	simple_static_local
	.type	simple_static_local,@function
simple_static_local:                    # @simple_static_local
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	simple_static_local, .Lfunc_end2-simple_static_local
                                        # -- End function
	.section	.text.simple_local,"ax",@progbits
	.hidden	simple_local            # -- Begin function simple_local
	.globl	simple_local
	.type	simple_local,@function
simple_local:                           # @simple_local
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 416
	i32.sub 	$0=, $pop0, $pop2
	i32.const	$push3=, 0
	i32.store	__stack_pointer($pop3), $0
	i32.const	$push6=, 0
	i32.const	$push4=, 416
	i32.add 	$push5=, $0, $pop4
	i32.store	__stack_pointer($pop6), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	simple_local, .Lfunc_end3-simple_local
                                        # -- End function
	.section	.text.simple_arg,"ax",@progbits
	.hidden	simple_arg              # -- Begin function simple_arg
	.globl	simple_arg
	.type	simple_arg,@function
simple_arg:                             # @simple_arg
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 16
	i32.sub 	$push3=, $pop0, $pop2
	i32.store	12($pop3), $2
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	simple_arg, .Lfunc_end4-simple_arg
                                        # -- End function
	.section	.text.expr_global,"ax",@progbits
	.hidden	expr_global             # -- Begin function expr_global
	.globl	expr_global
	.type	expr_global,@function
expr_global:                            # @expr_global
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	expr_global, .Lfunc_end5-expr_global
                                        # -- End function
	.section	.text.expr_local,"ax",@progbits
	.hidden	expr_local              # -- Begin function expr_local
	.globl	expr_local
	.type	expr_local,@function
expr_local:                             # @expr_local
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, __stack_pointer($pop1)
	i32.const	$push2=, 80
	i32.sub 	$drop=, $pop0, $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	expr_local, .Lfunc_end6-expr_local
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 416
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push0=, 0
	i32.load	$push1=, glob_int($pop0)
	i32.store	8($0), $pop1
	i32.const	$push8=, 0
	i32.const	$push2=, str
	i32.store	str+16($pop8), $pop2
	call    	expr_global@FUNCTION
	call    	expr_local@FUNCTION
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end7:
	.size	main, .Lfunc_end7-main
                                        # -- End function
	.hidden	glob_int_arr            # @glob_int_arr
	.type	glob_int_arr,@object
	.section	.bss.glob_int_arr,"aw",@nobits
	.globl	glob_int_arr
	.p2align	4
glob_int_arr:
	.skip	400
	.size	glob_int_arr, 400

	.hidden	glob_ptr_int            # @glob_ptr_int
	.type	glob_ptr_int,@object
	.section	.data.glob_ptr_int,"aw",@progbits
	.globl	glob_ptr_int
	.p2align	2
glob_ptr_int:
	.int32	glob_int_arr
	.size	glob_ptr_int, 4

	.hidden	glob_int                # @glob_int
	.type	glob_int,@object
	.section	.data.glob_int,"aw",@progbits
	.globl	glob_int
	.p2align	2
glob_int:
	.int32	4                       # 0x4
	.size	glob_int, 4

	.hidden	str                     # @str
	.type	str,@object
	.section	.bss.str,"aw",@nobits
	.globl	str
	.p2align	2
str:
	.skip	20
	.size	str, 20

	.hidden	ptr_str                 # @ptr_str
	.type	ptr_str,@object
	.section	.data.ptr_str,"aw",@progbits
	.globl	ptr_str
	.p2align	2
ptr_str:
	.int32	str
	.size	ptr_str, 4

	.type	stat_int_arr,@object    # @stat_int_arr
	.section	.bss.stat_int_arr,"aw",@nobits
	.p2align	4
stat_int_arr:
	.skip	400
	.size	stat_int_arr, 400

	.type	stat_int,@object        # @stat_int
	.section	.bss.stat_int,"aw",@nobits
	.p2align	2
stat_int:
	.int32	0                       # 0x0
	.size	stat_int, 4

	.type	simple_static_local.gx,@object # @simple_static_local.gx
	.section	.bss.simple_static_local.gx,"aw",@nobits
	.p2align	4
simple_static_local.gx:
	.skip	400
	.size	simple_static_local.gx, 400

	.type	simple_static_local.ix,@object # @simple_static_local.ix
	.section	.bss.simple_static_local.ix,"aw",@nobits
	.p2align	2
simple_static_local.ix:
	.int32	0                       # 0x0
	.size	simple_static_local.ix, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
