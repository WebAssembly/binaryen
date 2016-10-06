	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/950621-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %land.lhs.true
	i32.load	$push0=, 0($0)
	i32.const	$push3=, -1
	i32.ne  	$push1=, $pop0, $pop3
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %land.rhs
	i32.load	$push2=, 4($0)
	i32.const	$push4=, -1
	i32.eq  	$1=, $pop2, $pop4
.LBB0_3:                                # %land.end
	end_block                       # label0:
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
