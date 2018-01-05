	.text
	.file	"loop-10.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %while.end
	i32.const	$push3=, 0
	i32.load	$0=, count($pop3)
	i32.const	$push2=, 0
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	i32.store	count($pop2), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end4
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then3
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	count,@object           # @count
	.section	.bss.count,"aw",@nobits
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
