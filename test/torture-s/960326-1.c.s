	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960326-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block
	i32.load	$push0=, s+4($0)
	i32.const	$push1=, 3
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.data.s,"aw",@progbits
	.globl	s
	.align	2
s:
	.int32	0                       # 0x0
	.int32	3                       # 0x3
	.int16	0                       # 0x0
	.skip	2
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.size	s, 24


	.ident	"clang version 3.9.0 "
