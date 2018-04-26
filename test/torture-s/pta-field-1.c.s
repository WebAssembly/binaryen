	.text
	.file	"pta-field-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push1=, 0
	i32.store	0($pop0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$1=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $1
	i32.const	$push0=, 1
	i32.store	4($1), $pop0
	i32.const	$push1=, 2
	i32.store	0($1), $pop1
	i32.const	$push9=, 4
	i32.add 	$push10=, $1, $pop9
	i32.store	8($1), $pop10
	i32.store	12($1), $1
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	call    	bar@FUNCTION, $pop12
	i32.load	$0=, 0($1)
	i32.const	$push8=, 0
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	__stack_pointer($pop8), $pop7
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
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
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 16
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i32.const	$push0=, 1
	i32.store	4($0), $pop0
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
	i32.const	$push11=, 4
	i32.add 	$push12=, $0, $pop11
	i32.store	8($0), $pop12
	i32.store	12($0), $0
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	call    	bar@FUNCTION, $pop14
	block   	
	i32.load	$push2=, 0($0)
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
	return  	$pop3
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
