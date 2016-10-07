	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031012-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 15008
	i32.sub 	$push16=, $pop5, $pop6
	tee_local	$push15=, $2=, $pop16
	i32.store	__stack_pointer($pop7), $pop15
	i32.const	$push1=, 205
	i32.const	$push0=, 13371
	i32.call	$push14=, memset@FUNCTION, $2, $pop1, $pop0
	tee_local	$push13=, $2=, $pop14
	i32.const	$push12=, 0
	i32.store8	13371($pop13), $pop12
	block   	
	i32.call	$push2=, strlen@FUNCTION, $2
	i32.const	$push11=, 13371
	i32.ne  	$push3=, $pop2, $pop11
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %foo.exit
	i32.const	$push10=, 0
	i32.const	$push8=, 15008
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push17=, 0
	return  	$pop17
.LBB0_2:                                # %if.then.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	strlen, i32, i32
	.functype	abort, void
