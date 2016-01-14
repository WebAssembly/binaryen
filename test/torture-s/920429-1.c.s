	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920429-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load8_u	$2=, 0($0)
	i32.const	$1=, 1
	i32.const	$3=, 0
	i32.shr_u	$push1=, $2, $1
	i32.and 	$push2=, $pop1, $1
	i32.store	$discard=, i($3), $pop2
	i32.const	$push3=, 7
	i32.and 	$push4=, $2, $pop3
	i32.add 	$push5=, $pop4, $1
	i32.store	$discard=, j($3), $pop5
	i32.add 	$push0=, $0, $1
	return  	$pop0
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
	i32.const	$0=, 0
	i32.store	$discard=, i($0), $0
	i32.const	$push0=, 2
	i32.store	$discard=, j($0), $pop0
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.hidden	j                       # @j
	.type	j,@object
	.section	.bss.j,"aw",@nobits
	.globl	j
	.align	2
j:
	.int32	0                       # 0x0
	.size	j, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
