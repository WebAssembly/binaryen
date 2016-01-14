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
	i32.const	$0=, 0
	block
	i32.load	$push0=, s($0)
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load	$0=, s+4($0)
	i32.const	$push2=, 2
	i32.shl 	$push3=, $0, $pop2
	i32.const	$push1=, s
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$discard=, 0($pop6), $0
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push7=, 1
	return  	$pop7
	.endfunc
.Lfunc_end0:
	.size	x, .Lfunc_end0-x

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.store	$discard=, s($0), $0
	i32.store	$push0=, s+4($0), $0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	8
	.size	s, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
