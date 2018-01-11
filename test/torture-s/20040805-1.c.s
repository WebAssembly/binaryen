	.text
	.file	"20040805-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.call	$push1=, foo@FUNCTION
	i32.const	$push0=, 102
	i32.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, a($pop0)
	i32.const	$push5=, 0
	i32.store	a+4($pop5), $0
	i32.const	$push1=, 100
	i32.call	$drop=, bar@FUNCTION, $pop1
	i32.call	$push2=, bar@FUNCTION, $0
	i32.const	$push4=, 100
	i32.add 	$push3=, $pop2, $pop4
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.type	bar,@function           # -- Begin function bar
bar:                                    # @bar
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, a($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	a($pop0), $pop3
	copy_local	$push5=, $0
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.size	a, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
