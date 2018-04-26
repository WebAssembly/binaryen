	.text
	.file	"va-arg-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 32
	i32.sub 	$0=, $pop5, $pop7
	i32.const	$push8=, 0
	i32.store	__stack_pointer($pop8), $0
	i32.const	$push0=, 16
	i32.add 	$push1=, $0, $pop0
	i32.const	$push9=, 0
	i32.store	0($pop1), $pop9
	i64.const	$push2=, 4294967298
	i64.store	8($0), $pop2
	i64.const	$push3=, 12884901892
	i64.store	0($0), $pop3
	block   	
	i32.call	$push4=, foo@FUNCTION, $0, $0
	br_if   	0, $pop4        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
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
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push6=, 0
	i32.load	$push5=, __stack_pointer($pop6)
	i32.const	$push7=, 16
	i32.sub 	$push8=, $pop5, $pop7
	i32.const	$push0=, 20
	i32.add 	$push1=, $1, $pop0
	i32.store	12($pop8), $pop1
	i32.const	$push2=, 16
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
