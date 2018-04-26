	.text
	.file	"981130-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
# %bb.0:                                # %entry
	block   	
	i32.ne  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i64.load	$0=, s2($pop0)
	i32.const	$push3=, 0
	i64.store	s1($pop3), $0
	i32.wrap/i64	$push1=, $0
	i32.const	$push2=, 1
	call    	check@FUNCTION, $pop1, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	s2                      # @s2
	.type	s2,@object
	.section	.data.s2,"aw",@progbits
	.globl	s2
	.p2align	3
s2:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	s2, 8

	.hidden	s1                      # @s1
	.type	s1,@object
	.section	.bss.s1,"aw",@nobits
	.globl	s1
	.p2align	3
s1:
	.skip	8
	.size	s1, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
	.functype	abort, void
