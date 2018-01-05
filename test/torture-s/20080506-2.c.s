	.text
	.file	"20080506-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$0=, 0($0)
	i32.const	$push0=, 1
	i32.store	0($0), $pop0
	i32.load	$push1=, 0($1)
	i32.const	$push2=, 2
	i32.store	0($pop1), $pop2
	block   	
	i32.load	$push3=, 0($0)
	i32.const	$push5=, 2
	i32.ne  	$push4=, $pop3, $pop5
	br_if   	0, $pop4        # 0: down to label0
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
	i32.const	$push8=, 12
	i32.add 	$push9=, $0, $pop8
	i32.store	8($0), $pop9
	i32.const	$push10=, 12
	i32.add 	$push11=, $0, $pop10
	i32.store	4($0), $pop11
	i32.const	$push12=, 8
	i32.add 	$push13=, $0, $pop12
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	call    	foo@FUNCTION, $pop13, $pop15
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
