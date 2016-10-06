	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921204-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push8=, 0($1)
	tee_local	$push7=, $1=, $pop8
	i32.const	$push4=, 1310720
	i32.or  	$push5=, $pop7, $pop4
	i32.const	$push2=, -1310721
	i32.and 	$push3=, $1, $pop2
	i32.const	$push0=, 1
	i32.and 	$push1=, $1, $pop0
	i32.select	$push6=, $pop5, $pop3, $pop1
	i32.store	0($0), $pop6
                                        # fallthrough-return
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
