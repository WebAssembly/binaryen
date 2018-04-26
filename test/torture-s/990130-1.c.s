	.text
	.file	"990130-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$1=, count($pop5)
	i32.const	$push4=, 0
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.store	count($pop4), $pop1
	i32.const	$push3=, 0
	i32.load	$0=, dummy($pop3)
	#APP
	#NO_APP
	i32.const	$push2=, 0
	i32.store	dummy($pop2), $0
	block   	
	br_if   	0, $1           # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4

	.hidden	dummy                   # @dummy
	.type	dummy,@object
	.section	.bss.dummy,"aw",@nobits
	.globl	dummy
	.p2align	2
dummy:
	.int32	0                       # 0x0
	.size	dummy, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
