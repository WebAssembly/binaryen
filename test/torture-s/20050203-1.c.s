	.text
	.file	"20050203-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$0=, $pop3, $pop5
	i32.const	$push6=, 0
	i32.store	__stack_pointer($pop6), $0
	i32.const	$push7=, 15
	i32.add 	$push8=, $0, $pop7
	call    	foo@FUNCTION, $pop8
	i32.load8_s	$0=, 15($0)
	call    	bar@FUNCTION
	block   	
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB0_2:                                # %if.else
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
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 129
	i32.store8	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.type	bar,@function           # -- Begin function bar
bar:                                    # @bar
# %bb.0:                                # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
