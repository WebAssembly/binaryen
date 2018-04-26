	.text
	.file	"va-arg-23.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.load	$push7=, __stack_pointer($pop8)
	i32.const	$push9=, 16
	i32.sub 	$8=, $pop7, $pop9
	i32.const	$push10=, 0
	i32.store	__stack_pointer($pop10), $8
	i32.const	$push1=, 4
	i32.add 	$push2=, $7, $pop1
	i32.store	12($8), $pop2
	block   	
	i32.const	$push3=, 1
	i32.ne  	$push4=, $6, $pop3
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %entry
	i32.load	$push0=, 0($7)
	i32.const	$push5=, 2
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.2:                                # %if.end
	i32.const	$push13=, 0
	i32.const	$push11=, 16
	i32.add 	$push12=, $8, $pop11
	i32.store	__stack_pointer($pop13), $pop12
	return
.LBB0_3:                                # %if.then
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
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 32
	i32.sub 	$0=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $0
	i32.const	$push0=, 2
	i32.store	0($0), $pop0
	i64.load	$push1=, 24($0)
	i64.store	16($0), $pop1
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.const	$push2=, 1
	call    	foo@FUNCTION, $0, $0, $0, $0, $0, $pop12, $pop2, $0
	i32.const	$push10=, 0
	i32.const	$push8=, 32
	i32.add 	$push9=, $0, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
