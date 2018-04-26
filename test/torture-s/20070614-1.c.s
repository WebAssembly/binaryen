	.text
	.file	"20070614-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	f64.load	$push3=, 0($0)
	i32.const	$push6=, 0
	f64.load	$push2=, v($pop6)
	f64.ne  	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %entry
	f64.load	$push0=, 8($0)
	i32.const	$push7=, 0
	f64.load	$push1=, v+8($pop7)
	f64.ne  	$push5=, $pop0, $pop1
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# %bb.0:                                # %entry
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
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.result 	i32
	.local  	f64, f64
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	f64.load	$0=, v+8($pop4)
	i32.const	$push3=, 0
	f64.load	$1=, v($pop3)
	block   	
	f64.ne  	$push1=, $1, $1
	f64.ne  	$push0=, $0, $0
	i32.or  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry.split
	i32.const	$push5=, 0
	return  	$pop5
.LBB2_2:                                # %if.then.i.split
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64, f64
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	f64.load	$0=, v+8($pop4)
	i32.const	$push3=, 0
	f64.load	$1=, v($pop3)
	block   	
	f64.eq  	$push1=, $1, $1
	f64.eq  	$push0=, $0, $0
	i32.and 	$push2=, $pop1, $pop0
	i32.eqz 	$push6=, $pop2
	br_if   	0, $pop6        # 0: down to label2
# %bb.1:                                # %baz.exit
	i32.const	$push5=, 0
	return  	$pop5
.LBB3_2:                                # %if.then.i.split.i
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	3
v:
	.int64	4613937818241073152     # double 3
	.int64	4607182418800017408     # double 1
	.size	v, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
