	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961206-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	sub1, .Lfunc_end0-sub1

	.section	.text.sub2,"ax",@progbits
	.hidden	sub2
	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	sub2, .Lfunc_end1-sub2

	.section	.text.sub3,"ax",@progbits
	.hidden	sub3
	.globl	sub3
	.type	sub3,@function
sub3:                                   # @sub3
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	sub3, .Lfunc_end2-sub3

	.section	.text.sub4,"ax",@progbits
	.hidden	sub4
	.globl	sub4
	.type	sub4,@function
sub4:                                   # @sub4
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 2147483648
	i64.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end3:
	.size	sub4, .Lfunc_end3-sub4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end12
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
