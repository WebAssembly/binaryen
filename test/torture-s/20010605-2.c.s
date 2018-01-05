	.text
	.file	"20010605-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %baz.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	block   	
	f64.load	$push0=, 0($0)
	f64.const	$push1=, 0x1p0
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	f64.load	$push3=, 8($0)
	f64.const	$push4=, 0x1p1
	f64.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	block   	
	f32.load	$push0=, 0($0)
	f32.const	$push1=, 0x1.8p1
	f32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %lor.lhs.false
	f32.load	$push3=, 4($0)
	f32.const	$push4=, 0x1p2
	f32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.2:                                # %if.end
	return
.LBB2_3:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i64.load	$push3=, 0($0)
	i32.const	$push0=, 8
	i32.add 	$push1=, $0, $pop0
	i64.load	$push2=, 0($pop1)
	i64.const	$push12=, 0
	i64.const	$push4=, 4612037862148276224
	i32.call	$push5=, __netf2@FUNCTION, $pop3, $pop2, $pop12, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.1:                                # %lor.lhs.false
	i64.load	$push9=, 16($0)
	i32.const	$push6=, 24
	i32.add 	$push7=, $0, $pop6
	i64.load	$push8=, 0($pop7)
	i64.const	$push13=, 0
	i64.const	$push10=, 4612108230892453888
	i32.call	$push11=, __eqtf2@FUNCTION, $pop9, $pop8, $pop13, $pop10
	br_if   	0, $pop11       # 0: down to label2
# %bb.2:                                # %if.end
	return
.LBB3_3:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	baz, .Lfunc_end3-baz
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
