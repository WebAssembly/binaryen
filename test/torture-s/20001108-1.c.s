	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001108-1.c"
	.section	.text.signed_poly,"ax",@progbits
	.hidden	signed_poly
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

	.section	.text.unsigned_poly,"ax",@progbits
	.hidden	unsigned_poly
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

	.section	.text.main,"ax",@progbits
	.hidden	main
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
