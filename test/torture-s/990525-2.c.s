	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990525-2.c"
	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end15
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	func1, .Lfunc_end0-func1

	.section	.text.func2,"ax",@progbits
	.hidden	func2
	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.param  	i32
# BB#0:                                 # %entry
	i64.const	$push0=, 85899345930
	i64.store	0($0):p2align=2, $pop0
	i64.const	$push1=, 171798691870
	i64.store	8($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	func2, .Lfunc_end1-func2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
