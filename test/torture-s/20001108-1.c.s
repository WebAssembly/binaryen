	.text
	.file	"20001108-1.c"
	.section	.text.signed_poly,"ax",@progbits
	.hidden	signed_poly             # -- Begin function signed_poly
	.globl	signed_poly
	.type	signed_poly,@function
signed_poly:                            # @signed_poly
	.param  	i64, i32
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 32
	i64.shl 	$push1=, $0, $pop0
	i64.const	$push6=, 32
	i64.shr_s	$push2=, $pop1, $pop6
	i64.extend_s/i32	$push3=, $1
	i64.mul 	$push4=, $pop2, $pop3
	i64.add 	$push5=, $pop4, $0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	signed_poly, .Lfunc_end0-signed_poly
                                        # -- End function
	.section	.text.unsigned_poly,"ax",@progbits
	.hidden	unsigned_poly           # -- Begin function unsigned_poly
	.globl	unsigned_poly
	.type	unsigned_poly,@function
unsigned_poly:                          # @unsigned_poly
	.param  	i64, i32
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 4294967295
	i64.and 	$push1=, $0, $pop0
	i64.extend_u/i32	$push2=, $1
	i64.mul 	$push3=, $pop1, $pop2
	i64.add 	$push4=, $pop3, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	unsigned_poly, .Lfunc_end1-unsigned_poly
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end4
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
