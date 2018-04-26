	.text
	.file	"980617-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 24
	i32.shl 	$0=, $pop0, $pop1
	block   	
	block   	
	i32.const	$push2=, 301989888
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push4=, 285212672
	i32.ne  	$push5=, $0, $pop4
	br_if   	1, $pop5        # 1: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label1:
	return
.LBB0_3:                                # %if.else
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
	i32.const	$push3=, 0
	i32.load	$push2=, __stack_pointer($pop3)
	i32.const	$push4=, 16
	i32.sub 	$0=, $pop2, $pop4
	i32.const	$push5=, 0
	i32.store	__stack_pointer($pop5), $0
	i32.const	$push0=, 196625
	i32.store	12($0), $pop0
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	call    	foo@FUNCTION, $pop7
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
