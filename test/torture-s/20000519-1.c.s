	.text
	.file	"20000519-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.load	$2=, 0($1)
	i32.const	$push4=, 4
	i32.add 	$push0=, $1, $pop4
	copy_local	$1=, $pop0
	i32.const	$push3=, 10
	i32.gt_s	$push1=, $2, $pop3
	br_if   	0, $pop1        # 0: up to label0
# %bb.2:                                # %do.end
	end_loop
	i32.add 	$push2=, $2, $0
                                        # fallthrough-return: $pop2
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
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$push6=, $pop3, $pop5
	i32.store	12($pop6), $1
.LBB1_1:                                # %do.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$2=, 0($1)
	i32.const	$push8=, 4
	i32.add 	$push0=, $1, $pop8
	copy_local	$1=, $pop0
	i32.const	$push7=, 10
	i32.gt_s	$push1=, $2, $pop7
	br_if   	0, $pop1        # 0: up to label1
# %bb.2:                                # %bar.exit
	end_loop
	i32.add 	$push2=, $2, $0
                                        # fallthrough-return: $pop2
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
	i32.const	$push7=, 0
	i32.load	$push6=, __stack_pointer($pop7)
	i32.const	$push8=, 16
	i32.sub 	$0=, $pop6, $pop8
	i32.const	$push9=, 0
	i32.store	__stack_pointer($pop9), $0
	i64.const	$push0=, 12884901890
	i64.store	0($0), $pop0
	block   	
	i32.const	$push1=, 1
	i32.call	$push2=, foo@FUNCTION, $pop1, $0
	i32.const	$push3=, 3
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label2
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	__stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB2_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
