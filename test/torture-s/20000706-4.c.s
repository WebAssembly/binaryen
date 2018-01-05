	.text
	.file	"20000706-4.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push4=, c($pop3)
	i32.load	$push0=, 0($pop4)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end
	return
.LBB0_3:                                # %if.then
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
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$2=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $2
	i32.const	$push0=, 0
	i32.const	$push12=, 12
	i32.add 	$push13=, $2, $pop12
	i32.store	c($pop0), $pop13
	i32.store	12($2), $0
	block   	
	i32.const	$push1=, 1
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push3=, 2
	i32.ne  	$push4=, $1, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %bar.exit
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $2, $pop9
	i32.store	__stack_pointer($pop11), $pop10
	return
.LBB1_3:                                # %if.then.i
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
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i32.load	$push1=, __stack_pointer($pop2)
	i32.const	$push3=, 16
	i32.sub 	$0=, $pop1, $pop3
	i32.const	$push4=, 0
	i32.store	__stack_pointer($pop4), $0
	i32.const	$push0=, 0
	i32.const	$push5=, 12
	i32.add 	$push6=, $0, $pop5
	i32.store	c($pop0), $pop6
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
