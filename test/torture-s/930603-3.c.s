	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 1
	block   	
	block   	
	i32.const	$push0=, 100
	i32.eq  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 107
	i32.ne  	$push3=, $1, $pop2
	br_if   	1, $pop3        # 1: down to label0
# BB#2:                                 # %sw.bb3
	i32.const	$push4=, 3
	i32.add 	$0=, $0, $pop4
	i32.const	$2=, 4
.LBB0_3:                                # %sw.epilog
	end_block                       # label1:
	i32.load8_u	$push5=, 0($0)
	i32.shr_u	$push6=, $pop5, $2
	return  	$pop6
.LBB0_4:                                # %sw.default
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	.functype	abort, void
	.functype	exit, void, i32
