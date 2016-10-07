	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930208-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load8_u	$push0=, 3($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store8	3($0), $pop2
	i32.load8_u	$push3=, 0($0)
	i32.const	$push12=, 1
	i32.add 	$push4=, $pop3, $pop12
	i32.store8	0($0), $pop4
	i32.load8_u	$push8=, 2($0)
	i32.const	$push6=, 2
	i32.ne  	$push9=, $pop8, $pop6
	i32.load8_u	$push5=, 1($0)
	i32.const	$push11=, 2
	i32.ne  	$push7=, $pop5, $pop11
	i32.or  	$push10=, $pop9, $pop7
                                        # fallthrough-return: $pop10
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
