	.text
	.file	"20000706-2.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# %bb.2:                                # %lor.lhs.false2
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.3:                                # %lor.lhs.false4
	i32.load	$push9=, 12($0)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %lor.lhs.false6
	i32.const	$push13=, 10
	i32.ne  	$push14=, $5, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.5:                                # %lor.lhs.false6
	i32.const	$push15=, 9
	i32.ne  	$push16=, $4, $pop15
	br_if   	0, $pop16       # 0: down to label0
# %bb.6:                                # %lor.lhs.false6
	i32.const	$push17=, 8
	i32.ne  	$push18=, $3, $pop17
	br_if   	0, $pop18       # 0: down to label0
# %bb.7:                                # %lor.lhs.false6
	i32.const	$push19=, 7
	i32.ne  	$push20=, $2, $pop19
	br_if   	0, $pop20       # 0: down to label0
# %bb.8:                                # %lor.lhs.false6
	i32.const	$push21=, 6
	i32.ne  	$push22=, $1, $pop21
	br_if   	0, $pop22       # 0: down to label0
# %bb.9:                                # %lor.lhs.false6
	i32.load	$push12=, 16($0)
	i32.const	$push23=, 5
	i32.ne  	$push24=, $pop12, $pop23
	br_if   	0, $pop24       # 0: down to label0
# %bb.10:                               # %if.end
	return
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %lor.lhs.false.i
	i32.load	$push3=, 4($1)
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.2:                                # %lor.lhs.false2.i
	i32.load	$push6=, 8($1)
	i32.const	$push7=, 3
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# %bb.3:                                # %lor.lhs.false4.i
	i32.load	$push9=, 12($1)
	i32.const	$push10=, 4
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label1
# %bb.4:                                # %lor.lhs.false6.i
	i32.load	$push12=, 16($1)
	i32.const	$push13=, 5
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label1
# %bb.5:                                # %bar.exit
	return
.LBB1_6:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %foo.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
