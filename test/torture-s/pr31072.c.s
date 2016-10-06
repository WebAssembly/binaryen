	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31072.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push3=, 0
	i32.load	$push0=, ReadyFlag_NotProperlyInitialized($pop3)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ReadyFlag_NotProperlyInitialized # @ReadyFlag_NotProperlyInitialized
	.type	ReadyFlag_NotProperlyInitialized,@object
	.section	.data.ReadyFlag_NotProperlyInitialized,"aw",@progbits
	.globl	ReadyFlag_NotProperlyInitialized
	.p2align	2
ReadyFlag_NotProperlyInitialized:
	.int32	1                       # 0x1
	.size	ReadyFlag_NotProperlyInitialized, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
