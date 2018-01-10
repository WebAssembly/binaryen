	.text
	.file	"920501-1.c"
	.section	.text.x,"ax",@progbits
	.hidden	x                       # -- Begin function x
	.globl	x
	.type	x,@function
x:                                      # @x
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push7=, 0
	i32.load	$push0=, s($pop7)
	i32.eqz 	$push9=, $pop0
	br_if   	0, $pop9        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push6=, 1
	return  	$pop6
.LBB0_2:                                # %if.then
	end_block                       # label0:
	i32.const	$push8=, 0
	i32.load	$0=, s+4($pop8)
	i32.const	$push1=, 2
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push3=, s+4
	i32.add 	$push4=, $pop2, $pop3
	i32.store	0($pop4), $0
	i32.const	$push5=, 1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	x, .Lfunc_end0-x
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	s($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	3
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
