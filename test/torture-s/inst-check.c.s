	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/inst-check.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$push5=, -1
	i32.add 	$push6=, $0, $pop5
	i64.extend_u/i32	$push7=, $pop6
	i32.const	$push2=, -2
	i32.add 	$push3=, $0, $pop2
	i64.extend_u/i32	$push4=, $pop3
	i64.mul 	$push8=, $pop7, $pop4
	i64.const	$push9=, 1
	i64.shr_u	$push10=, $pop8, $pop9
	i32.wrap/i64	$push11=, $pop10
	i32.add 	$push12=, $pop11, $0
	i32.const	$push15=, -1
	i32.add 	$push13=, $pop12, $pop15
	return  	$pop13
.LBB0_2:
	end_block                       # label0:
	i32.const	$push14=, 0
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
