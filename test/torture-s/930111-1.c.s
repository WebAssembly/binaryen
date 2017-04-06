	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930111-1.c"
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
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.wwrite,"ax",@progbits
	.hidden	wwrite
	.globl	wwrite
	.type	wwrite,@function
wwrite:                                 # @wwrite
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i64.const	$push1=, -3
	i64.add 	$push6=, $0, $pop1
	tee_local	$push5=, $0=, $pop6
	i64.const	$push2=, 44
	i64.gt_u	$push3=, $pop5, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %entry
	block   	
	i32.wrap/i64	$push0=, $0
	br_table 	$pop0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 # 0: down to label1
                                        # 1: down to label0
.LBB1_2:                                # %return
	end_block                       # label1:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_3:                                # %sw.default
	end_block                       # label0:
	i32.const	$push4=, 123
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	wwrite, .Lfunc_end1-wwrite


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
