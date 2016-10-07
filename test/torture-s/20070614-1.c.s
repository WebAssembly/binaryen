	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070614-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	f64.load	$push3=, 0($0)
	i32.const	$push6=, 0
	f64.load	$push2=, v($pop6)
	f64.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %entry
	f64.load	$push0=, 8($0)
	i32.const	$push7=, 0
	f64.load	$push1=, v+8($pop7)
	f64.ne  	$push5=, $pop0, $pop1
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, v($pop0)
	i64.store	0($0), $pop1
	i32.const	$push3=, 0
	i64.load	$push2=, v+8($pop3)
	i64.store	8($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	f64.load	$push7=, v($pop8)
	tee_local	$push6=, $0=, $pop7
	f64.ne  	$push1=, $pop6, $0
	i32.const	$push5=, 0
	f64.load	$push4=, v+8($pop5)
	tee_local	$push3=, $0=, $pop4
	f64.ne  	$push0=, $pop3, $0
	i32.or  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$push9=, 0
	return  	$pop9
.LBB2_2:                                # %if.then.i.split
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block   	
	i32.const	$push8=, 0
	f64.load	$push7=, v($pop8)
	tee_local	$push6=, $0=, $pop7
	f64.eq  	$push1=, $pop6, $0
	i32.const	$push5=, 0
	f64.load	$push4=, v+8($pop5)
	tee_local	$push3=, $0=, $pop4
	f64.eq  	$push0=, $pop3, $0
	i32.and 	$push2=, $pop1, $pop0
	i32.eqz 	$push10=, $pop2
	br_if   	0, $pop10       # 0: down to label2
# BB#1:                                 # %baz.exit
	i32.const	$push9=, 0
	return  	$pop9
.LBB3_2:                                # %if.then.i.split.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	3
v:
	.int64	4613937818241073152     # double 3
	.int64	4607182418800017408     # double 1
	.size	v, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
