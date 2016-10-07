	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	
	i32.load16_u	$push0=, 0($0)
	i32.const	$push5=, 1
	i32.ne  	$push1=, $pop0, $pop5
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	f64.load	$push2=, 2($0):p2align=1
	f64.const	$push3=, 0x1p4
	f64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$1=, 0
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

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
