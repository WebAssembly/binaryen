	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42614.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.call	$push1=, malloc@FUNCTION, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.expect_func,"ax",@progbits
	.hidden	expect_func
	.globl	expect_func
	.type	expect_func,@function
expect_func:                            # @expect_func
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.eqz 	$push0=, $0
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.eqz 	$push1=, $1
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %if.end6
	return
.LBB1_3:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	expect_func, .Lfunc_end1-expect_func

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
	i32.sub 	$push13=, $pop3, $pop4
	tee_local	$push12=, $0=, $pop13
	i32.store	__stack_pointer($pop5), $pop12
	i32.const	$push0=, 0
	i32.store8	15($0), $pop0
	i32.const	$push1=, 1
	i32.const	$push9=, 15
	i32.add 	$push10=, $0, $pop9
	call    	expect_func@FUNCTION, $pop1, $pop10
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	i32.const	$push11=, 0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	abort, void
