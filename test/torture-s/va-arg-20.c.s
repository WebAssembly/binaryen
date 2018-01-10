	.text
	.file	"va-arg-20.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 7
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, -8
	i32.and 	$push3=, $pop1, $pop2
	i64.load	$push4=, 0($pop3)
	i64.const	$push5=, 16
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
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
	.param  	i32, i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$3=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $3
	i32.store	12($3), $2
	block   	
	i32.const	$push0=, 7
	i32.add 	$push1=, $2, $pop0
	i32.const	$push2=, -8
	i32.and 	$push3=, $pop1, $pop2
	i64.load	$push4=, 0($pop3)
	i64.const	$push5=, 16
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	0, $pop6        # 0: down to label1
# %bb.1:                                # %foo.exit
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $3, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
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
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i64.const	$push0=, 16
	i64.store	0($0), $pop0
	i32.const	$push1=, 0
	i32.const	$push7=, 0
	call    	bar@FUNCTION, $pop1, $pop7, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
