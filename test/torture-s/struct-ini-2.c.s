	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ini-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	i32.load16_u	$push15=, x($pop0)
	tee_local	$push14=, $0=, $pop15
	i32.const	$push1=, 15
	i32.and 	$push2=, $pop14, $pop1
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push5=, 3840
	i32.and 	$push6=, $0, $pop5
	i32.const	$push7=, 768
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end7
	i32.const	$push9=, 61440
	i32.and 	$push10=, $0, $pop9
	i32.const	$push11=, 16384
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label0
# BB#3:                                 # %if.end13
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB0_4:                                # %if.then12
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	2
x:
	.int8	2                       # 0x2
	.int8	67                      # 0x43
	.skip	2
	.size	x, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
