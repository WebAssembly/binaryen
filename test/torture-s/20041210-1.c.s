	.text
	.file	"20041210-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push9=, 0
	i32.load	$push1=, x($pop9)
	i32.const	$push8=, 0
	i32.load	$push0=, x+4($pop8)
	i32.ge_s	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push11=, 0
	i32.load	$push4=, x+12($pop11)
	i32.const	$push10=, 0
	i32.load	$push3=, x+8($pop10)
	i32.and 	$push5=, $pop4, $pop3
	i32.const	$push6=, -1
	i32.gt_s	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.2:                                # %if.then2
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.end3
	end_block                       # label0:
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.data.x,"aw",@progbits
	.globl	x
	.p2align	4
x:
	.int32	3221225472              # 0xc0000000
	.int32	2147483647              # 0x7fffffff
	.int32	2                       # 0x2
	.int32	4                       # 0x4
	.size	x, 16


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
