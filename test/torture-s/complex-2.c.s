	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-2.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	f64.load	$push1=, 0($2)
	f64.load	$push0=, 0($1)
	f64.add 	$push2=, $pop1, $pop0
	f64.store	0($0), $pop2
	f64.load	$push4=, 8($2)
	f64.load	$push3=, 8($1)
	f64.add 	$push5=, $pop4, $pop3
	f64.store	8($0), $pop5
                                        # fallthrough-return
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
	block   	
	i32.const	$push6=, 0
	f64.load	$push1=, ag($pop6)
	f64.const	$push5=, 0x1p0
	f64.ne  	$push2=, $pop1, $pop5
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push8=, 0
	f64.load	$push0=, ag+8($pop8)
	f64.const	$push7=, 0x1p0
	f64.ne  	$push3=, $pop0, $pop7
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end26
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	ag                      # @ag
	.type	ag,@object
	.section	.data.ag,"aw",@progbits
	.globl	ag
	.p2align	3
ag:
	.int64	4607182418800017408     # double 1
	.int64	4607182418800017408     # double 1
	.size	ag, 16

	.hidden	bg                      # @bg
	.type	bg,@object
	.section	.data.bg,"aw",@progbits
	.globl	bg
	.p2align	3
bg:
	.int64	-4611686018427387904    # double -2
	.int64	4611686018427387904     # double 2
	.size	bg, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
