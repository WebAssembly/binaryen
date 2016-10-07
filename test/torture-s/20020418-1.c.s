	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020418-1.c"
	.section	.text.gcc_crash,"ax",@progbits
	.hidden	gcc_crash
	.globl	gcc_crash
	.type	gcc_crash,@function
gcc_crash:                              # @gcc_crash
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $2=, $pop4
	i32.const	$push0=, 52
	i32.lt_s	$push1=, $pop3, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:
	i32.const	$push2=, 60
	i32.gt_s	$1=, $2, $pop2
.LBB0_2:                                # %top
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	br_if   	0, $1           # 0: up to label1
# BB#3:                                 # %if.end6
	end_loop
	i32.store	0($0), $2
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	unreachable
	unreachable
	.endfunc
.Lfunc_end0:
	.size	gcc_crash, .Lfunc_end0-gcc_crash

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	tee_local	$push8=, $0=, $pop9
	i32.store	__stack_pointer($pop5), $pop8
	i32.const	$push0=, 53
	i32.store	8($0), $pop0
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	call    	gcc_crash@FUNCTION, $pop7
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
