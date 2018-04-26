	.text
	.file	"pr51466.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$push7=, $pop4, $pop6
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push2=, $pop7, $pop1
	i32.const	$push3=, 6
	i32.store	0($pop2), $pop3
	i32.const	$push8=, 6
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push8=, $pop5, $pop7
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$0=, $pop8, $pop1
	i32.const	$push2=, 6
	i32.store	0($0), $pop2
	i32.const	$push3=, 8
	i32.store	0($0), $pop3
	i32.load	$push4=, 0($0)
                                        # fallthrough-return: $pop4
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$1=, $pop5, $pop7
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$0=, $1, $pop1
	i32.const	$push2=, 6
	i32.store	0($0), $pop2
	i32.const	$push3=, 8
	i32.store	0($1), $pop3
	i32.load	$push4=, 0($0)
                                        # fallthrough-return: $pop4
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
	i32.const	$push0=, 3
	i32.call	$drop=, foo@FUNCTION, $pop0
	block   	
	i32.const	$push1=, 2
	i32.call	$push2=, bar@FUNCTION, $pop1
	i32.const	$push12=, 8
	i32.ne  	$push3=, $pop2, $pop12
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %lor.lhs.false3
	i32.const	$push4=, 0
	i32.call	$push5=, baz@FUNCTION, $pop4
	i32.const	$push13=, 8
	i32.ne  	$push6=, $pop5, $pop13
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %lor.lhs.false6
	i32.const	$push7=, 1
	i32.call	$push8=, baz@FUNCTION, $pop7
	i32.const	$push9=, 6
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	0, $pop10       # 0: down to label0
# %bb.3:                                # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB3_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
