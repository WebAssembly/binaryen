	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-1.c"
	.section	.text.good_const,"ax",@progbits
	.hidden	good_const
	.globl	good_const
	.type	good_const,@function
good_const:                             # @good_const
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	good_const, .Lfunc_end0-good_const

	.section	.text.good_enum,"ax",@progbits
	.hidden	good_enum
	.globl	good_enum
	.type	good_enum,@function
good_enum:                              # @good_enum
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	good_enum, .Lfunc_end1-good_enum

	.section	.text.good_expr,"ax",@progbits
	.hidden	good_expr
	.globl	good_expr
	.type	good_expr,@function
good_expr:                              # @good_expr
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	good_expr, .Lfunc_end2-good_expr

	.section	.text.good_vararg,"ax",@progbits
	.hidden	good_vararg
	.globl	good_vararg
	.type	good_vararg,@function
good_vararg:                            # @good_vararg
	.param  	i32
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	good_vararg, .Lfunc_end3-good_vararg

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, arr
	call    	good_const@FUNCTION, $pop0
	i32.const	$push4=, arr
	call    	good_enum@FUNCTION, $pop4
	i32.const	$push3=, arr
	call    	good_expr@FUNCTION, $pop3
	i32.const	$push2=, arr
	call    	good_vararg@FUNCTION, $pop2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
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
	.skip	40
	.size	arr, 40


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
