	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23604.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push0=, 1
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %if.then2
	i32.eq  	$push2=, $0, $1
	br_if   	0, $pop2        # 0: down to label1
# BB#2:                                 # %if.then2
	i32.const	$0=, 0
	br_if   	1, $1           # 1: down to label0
.LBB0_3:                                # %if.end9
	end_block                       # label1:
	i32.const	$0=, 1
.LBB0_4:                                # %return
	end_block                       # label0:
	copy_local	$push3=, $0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
