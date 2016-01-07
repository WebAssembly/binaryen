	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921202-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond
	i32.call	$discard=, exxit
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.globl	mpn_mul_1
	.type	mpn_mul_1,@function
mpn_mul_1:                              # @mpn_mul_1
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end2:
	.size	mpn_mul_1, .Lfunc_end2-mpn_mul_1

	.globl	mpn_print
	.type	mpn_print,@function
mpn_print:                              # @mpn_print
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end3:
	.size	mpn_print, .Lfunc_end3-mpn_print

	.globl	mpn_random2
	.type	mpn_random2,@function
mpn_random2:                            # @mpn_random2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end4:
	.size	mpn_random2, .Lfunc_end4-mpn_random2

	.globl	mpn_cmp
	.type	mpn_cmp,@function
mpn_cmp:                                # @mpn_cmp
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end5:
	.size	mpn_cmp, .Lfunc_end5-mpn_cmp

	.globl	exxit
	.type	exxit,@function
exxit:                                  # @exxit
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end6:
	.size	exxit, .Lfunc_end6-exxit


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
