	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930111-1.c"
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
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i64.const	$push1=, -3
	i64.add 	$push5=, $0, $pop1
	tee_local	$push4=, $0=, $pop5
	i64.const	$push2=, 44
	i64.gt_u	$push3=, $pop4, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$1=, 0
	i32.wrap/i64	$push0=, $0
	br_table 	$pop0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 # 1: down to label0
                                        # 0: down to label1
.LBB1_2:                                # %sw.default
	end_block                       # label1:
	i32.const	$1=, 123
.LBB1_3:                                # %return
	end_block                       # label0:
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	wwrite, .Lfunc_end1-wwrite


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
