	.text
	.file	"20040823-1.c"
	.section	.text.bla,"ax",@progbits
	.hidden	bla                     # -- Begin function bla
	.globl	bla
	.type	bla,@function
bla:                                    # @bla
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, pwarn($pop2)
	i32.load	$push1=, 0($pop0)
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bla, .Lfunc_end0-bla
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
	i32.const	$push0=, 1
	i32.store	12($0), $pop0
	i32.const	$push1=, 0
	i32.const	$push6=, 12
	i32.add 	$push7=, $0, $pop6
	i32.store	pwarn($pop1), $pop7
	call    	bla@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	pwarn                   # @pwarn
	.type	pwarn,@object
	.section	.bss.pwarn,"aw",@nobits
	.globl	pwarn
	.p2align	2
pwarn:
	.int32	0
	.size	pwarn, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
