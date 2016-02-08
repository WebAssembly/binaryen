	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920501-1.c"
	.section	.text.x,"ax",@progbits
	.hidden	x
	.globl	x
	.type	x,@function
x:                                      # @x
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.load	$push0=, s($pop5)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push7=, 0
	i32.load	$push1=, s+4($pop7)
	tee_local	$push6=, $0=, $pop1
	i32.const	$push2=, 2
	i32.shl 	$push3=, $pop6, $pop2
	i32.store	$discard=, s+4($pop3), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end0:
	.size	x, .Lfunc_end0-x

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, 0
	i64.store	$discard=, s($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.p2align	2
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 3.9.0 "
