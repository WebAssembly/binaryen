	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/float-floor.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 0
	f64.load	$push1=, d($pop0)
	f64.floor	$push10=, $pop1
	tee_local	$push9=, $0=, $pop10
	i32.trunc_s/f64	$push2=, $pop9
	i32.const	$push8=, 1023
	i32.ne  	$push3=, $pop2, $pop8
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	f32.demote/f64	$push4=, $0
	i32.trunc_s/f32	$push5=, $pop4
	i32.const	$push11=, 1023
	i32.ne  	$push6=, $pop5, $pop11
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	3
d:
	.int64	4652218414805286912     # double 1023.9999694824219
	.size	d, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	floor, f64, f64
	.functype	abort, void
