	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950612-1.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i32.add 	$push1=, $0, $pop3
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.f2,"ax",@progbits
	.hidden	f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 31
	i32.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i32.add 	$push1=, $0, $pop3
	i32.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2

	.section	.text.f3,"ax",@progbits
	.hidden	f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i64.add 	$push1=, $0, $pop3
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3

	.section	.text.f4,"ax",@progbits
	.hidden	f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i64
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 63
	i64.shr_s	$push4=, $0, $pop0
	tee_local	$push3=, $1=, $pop4
	i64.add 	$push1=, $0, $pop3
	i64.xor 	$push2=, $pop1, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.cond.10
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
