	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950322-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 1($0)
	i32.sub 	$push11=, $pop1, $pop0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push2=, 31
	i32.shr_s	$push9=, $0, $pop2
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push3=, $pop10, $pop8
	i32.xor 	$push4=, $pop3, $1
	i32.const	$push7=, 31
	i32.shr_u	$push5=, $0, $pop7
	i32.add 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
