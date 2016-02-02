	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921112-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 8($0), $pop0
	return  	$0
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
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i64.const	$push1=, 8589934593
	i64.store	$push3=, v($pop7), $pop1
	i64.store	$discard=, x+8($pop2), $pop3
	block
	i32.const	$push6=, 0
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %entry
	i64.const	$push0=, 8589934592
	i64.const	$push8=, 8589934592
	i64.ne  	$push4=, $pop0, $pop8
	br_if   	$pop4, 0        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	4
x:
	.skip	16
	.size	x, 16

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	3
v:
	.skip	8
	.size	v, 8


	.ident	"clang version 3.9.0 "
