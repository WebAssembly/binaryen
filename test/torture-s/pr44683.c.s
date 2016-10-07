	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr44683.c"
	.section	.text.copysign_bug,"ax",@progbits
	.hidden	copysign_bug
	.globl	copysign_bug
	.type	copysign_bug,@function
copysign_bug:                           # @copysign_bug
	.param  	f64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	f64.const	$push9=, 0x0p0
	f64.eq  	$push2=, $0, $pop9
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$1=, 1
	f64.const	$push1=, 0x1p-1
	f64.mul 	$push0=, $0, $pop1
	f64.eq  	$push3=, $pop0, $0
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$push8=, 2
	i32.const	$push7=, 3
	f64.const	$push4=, 0x1p0
	f64.copysign	$push5=, $pop4, $0
	f64.const	$push10=, 0x0p0
	f64.lt  	$push6=, $pop5, $pop10
	i32.select	$1=, $pop8, $pop7, $pop6
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push11=, $1
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	copysign_bug, .Lfunc_end0-copysign_bug

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, -0x0p0
	i32.call	$push1=, copysign_bug@FUNCTION, $pop0
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
