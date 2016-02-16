	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920429-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load8_u	$push13=, 0($0)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push0=, 1
	i32.shr_u	$push2=, $pop12, $pop0
	i32.const	$push11=, 1
	i32.and 	$push3=, $pop2, $pop11
	i32.store	$discard=, i($pop4), $pop3
	i32.const	$push10=, 0
	i32.const	$push5=, 7
	i32.and 	$push6=, $1, $pop5
	i32.const	$push9=, 1
	i32.add 	$push7=, $pop6, $pop9
	i32.store	$discard=, j($pop10), $pop7
	i32.const	$push8=, 1
	i32.add 	$push1=, $0, $pop8
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.store	$push3=, i($pop0), $pop4
	tee_local	$push2=, $0=, $pop3
	i32.const	$push1=, 2
	i32.store	$discard=, j($pop2), $pop1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.p2align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 3.9.0 "
