	.text
	.file	"pr19606.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 1
	i32.shr_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, 5
	i32.rem_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$0=, a($pop0)
	block   	
	i32.const	$push1=, 1
	i32.shr_u	$push2=, $0, $pop1
	i32.const	$push3=, 2147483646
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push5=, 5
	i32.rem_u	$push6=, $0, $pop5
	i32.const	$push7=, 2
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# %bb.2:                                # %if.end7
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB2_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
a:
	.int8	252                     # 0xfc
	.size	a, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
