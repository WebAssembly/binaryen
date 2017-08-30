	.text
	.file	"981130-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.ne  	$push0=, $0, $1
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i64.load	$push4=, s2($pop5)
	tee_local	$push3=, $0=, $pop4
	i64.store	s1($pop0), $pop3
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
	.functype	abort, void
