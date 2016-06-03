	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981130-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
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

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push5=, 0
	i64.load	$push2=, s2($pop5)
	i64.store	$push0=, s1($pop1), $pop2
	i32.wrap/i64	$push3=, $pop0
	i32.const	$push4=, 1
	call    	check@FUNCTION, $pop3, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
	.functype	abort, void
