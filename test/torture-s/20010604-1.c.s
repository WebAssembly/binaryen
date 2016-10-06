	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010604-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push6=, 1
	i32.ne  	$push3=, $6, $pop6
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push7=, 1
	i32.xor 	$push0=, $3, $pop7
	br_if   	0, $pop0        # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push8=, 1
	i32.xor 	$push1=, $4, $pop8
	br_if   	0, $pop1        # 0: down to label0
# BB#3:                                 # %entry
	i32.const	$push9=, 1
	i32.xor 	$push2=, $5, $pop9
	br_if   	0, $pop2        # 0: down to label0
# BB#4:                                 # %if.end
	i32.add 	$push4=, $1, $0
	i32.add 	$push5=, $pop4, $2
	return  	$pop5
.LBB0_5:                                # %if.then
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
