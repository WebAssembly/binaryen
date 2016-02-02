	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/packed-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load16_u	$push1=, x1($pop5)
	i32.store16	$push2=, t($pop0), $pop1
	i32.const	$push3=, 17
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.call	$discard=, f@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x1                      # @x1
	.type	x1,@object
	.section	.data.x1,"aw",@progbits
	.globl	x1
	.p2align	1
x1:
	.int16	17                      # 0x11
	.size	x1, 2

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	1
t:
	.skip	2
	.size	t, 2


	.ident	"clang version 3.9.0 "
