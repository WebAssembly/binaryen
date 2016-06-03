	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000528-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load16_u	$push1=, l($pop4)
	i32.store16	$push0=, s($pop5), $pop1
	i32.const	$push2=, 65534
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
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

	.hidden	l                       # @l
	.type	l,@object
	.section	.data.l,"aw",@progbits
	.globl	l
	.p2align	2
l:
	.int32	4294967294              # 0xfffffffe
	.size	l, 4

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	1
s:
	.int16	0                       # 0x0
	.size	s, 2


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
