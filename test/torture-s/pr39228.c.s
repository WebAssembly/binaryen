	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39228.c"
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
	i32.const	$push8=, 0
	i32.le_s	$push2=, $pop1, $pop8
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end4
	i64.const	$push4=, 0
	i64.const	$push3=, 9223090561878065152
	i32.call	$push5=, __builtin_isinfl@FUNCTION, $pop4, $pop3
	i32.const	$push9=, 0
	i32.le_s	$push6=, $pop5, $pop9
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end8
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	__builtin_isinff, i32
	.functype	__builtin_isinfl, i32
