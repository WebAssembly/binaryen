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
	i32.const	$push4=, 0
	i32.load	$push0=, s($pop4)
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push7=, 0
	i32.load	$push6=, s+4($pop7)
	tee_local	$push5=, $0=, $pop6
	i32.const	$push1=, 2
	i32.shl 	$push2=, $pop5, $pop1
	i32.store	$drop=, s+4($pop2), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push3=, 1
                                        # fallthrough-return: $pop3
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
	i64.store	$drop=, s($pop1), $pop0
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
	.p2align	3
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
