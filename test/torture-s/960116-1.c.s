	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960116-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	
	block   	
	i32.const	$push2=, 1
	i32.and 	$push0=, $0, $pop2
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %land.lhs.true
	i32.load	$push1=, 0($0)
	br_if   	1, $pop1        # 1: down to label0
.LBB0_2:                                # %if.end
	end_block                       # label1:
	i32.const	$1=, 0
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push3=, $1
                                        # fallthrough-return: $pop3
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
