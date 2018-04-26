	.text
	.file	"20011113-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 21
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push9=, 12
	i32.add 	$push10=, $0, $pop9
	i32.load	$push0=, 0($pop10)
	i32.const	$push11=, 22
	i32.ne  	$push12=, $pop0, $pop11
	br_if   	0, $pop12       # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.load	$push1=, 0($pop8)
	i32.const	$push13=, 23
	i32.ne  	$push14=, $pop1, $pop13
	br_if   	0, $pop14       # 0: down to label0
# %bb.3:                                # %bar.exit
	i32.const	$push15=, 0
	return  	$pop15
.LBB0_4:                                # %if.then.i
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
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 21
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %lor.lhs.false
	i32.load	$push3=, 4($0)
	i32.const	$push4=, 22
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.2:                                # %lor.lhs.false4
	i32.load	$push6=, 8($0)
	i32.const	$push7=, 23
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 21
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label2
# %bb.1:                                # %entry
	i32.const	$push9=, 12
	i32.add 	$push10=, $0, $pop9
	i32.load	$push0=, 0($pop10)
	i32.const	$push11=, 22
	i32.ne  	$push12=, $pop0, $pop11
	br_if   	0, $pop12       # 0: down to label2
# %bb.2:                                # %entry
	i32.const	$push7=, 16
	i32.add 	$push8=, $0, $pop7
	i32.load	$push1=, 0($pop8)
	i32.const	$push13=, 23
	i32.ne  	$push14=, $pop1, $pop13
	br_if   	0, $pop14       # 0: down to label2
# %bb.3:                                # %bar.exit
	i32.const	$push15=, 0
	return  	$pop15
.LBB2_4:                                # %if.then.i
	end_block                       # label2:
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
# %bb.0:                                # %entry
	i32.const	$push0=, t
	i32.call	$drop=, baz@FUNCTION, $pop0
	i32.const	$push2=, t
	i32.call	$drop=, foo@FUNCTION, $pop2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.hidden	t                       # @t
	.type	t,@object
	.section	.data.t,"aw",@progbits
	.globl	t
	.p2align	2
t:
	.int8	26                      # 0x1a
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int32	0                       # 0x0
	.int32	21                      # 0x15
	.int32	22                      # 0x16
	.int32	23                      # 0x17
	.size	t, 20


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
