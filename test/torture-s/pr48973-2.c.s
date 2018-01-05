	.text
	.file	"pr48973-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push10=, 0
	i32.load	$push0=, v($pop10)
	i32.const	$push1=, 31
	i32.shr_u	$0=, $pop0, $pop1
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load8_u	$push2=, s($pop8)
	i32.const	$push3=, 254
	i32.and 	$push4=, $pop2, $pop3
	i32.or  	$push5=, $pop4, $0
	i32.store8	s($pop9), $pop5
	block   	
	i32.const	$push6=, 1
	i32.ne  	$push7=, $0, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push11=, 0
	return  	$pop11
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	v                       # @v
	.type	v,@object
	.section	.data.v,"aw",@progbits
	.globl	v
	.p2align	2
v:
	.int32	4294967295              # 0xffffffff
	.size	v, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
