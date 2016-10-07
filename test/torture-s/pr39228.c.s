	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39228.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, infinity
	i32.call	$push1=, __builtin_isinff@FUNCTION, $pop0
	i32.const	$push2=, 0
	i32.le_s	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 1
	i32.eqz 	$push11=, $pop4
	br_if   	0, $pop11       # 0: down to label0
# BB#2:                                 # %if.end4
	i64.const	$push6=, 0
	i64.const	$push5=, 9223090561878065152
	i32.call	$push7=, __builtin_isinfl@FUNCTION, $pop6, $pop5
	i32.const	$push9=, 0
	i32.le_s	$push8=, $pop7, $pop9
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_4:                                # %if.then7
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	__builtin_isinff, i32
	.functype	__builtin_isinfl, i32
