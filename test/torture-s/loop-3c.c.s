	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 3
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push5=, a
	i32.add 	$1=, $pop1, $pop5
	i32.const	$2=, 256
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push15=, 1
	i32.shr_s	$push14=, $2, $pop15
	tee_local	$push13=, $2=, $pop14
	i32.const	$push12=, 2
	i32.shl 	$push2=, $pop13, $pop12
	i32.const	$push11=, a
	i32.add 	$push3=, $pop2, $pop11
	i32.store	0($pop3), $1
	i32.const	$push10=, 32
	i32.add 	$1=, $1, $pop10
	i32.const	$push9=, 4
	i32.add 	$push8=, $0, $pop9
	tee_local	$push7=, $0=, $pop8
	i32.const	$push6=, 1073741840
	i32.lt_s	$push4=, $pop7, $pop6
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop
	copy_local	$push16=, $1
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end7
	i32.const	$push1=, 0
	i32.const	$push0=, a
	i32.store	a+512($pop1), $pop0
	i32.const	$push10=, 0
	i32.const	$push2=, a+32
	i32.store	a+256($pop10), $pop2
	i32.const	$push9=, 0
	i32.const	$push3=, a+64
	i32.store	a+128($pop9), $pop3
	i32.const	$push8=, 0
	i32.const	$push4=, a+96
	i32.store	a+64($pop8), $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	a+32($pop7), $pop6
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	1020
	.size	a, 1020


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
