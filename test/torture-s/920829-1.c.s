	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920829-1.c"
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
	i64.load	$push0=, c($0)
	i64.const	$push1=, 3
	i64.mul 	$push2=, $pop0, $pop1
	i64.load	$push3=, c3($0)
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	call    	exit@FUNCTION, $0
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.align	3
c:
	.int64	2863311530              # 0xaaaaaaaa
	.size	c, 8

	.hidden	c3                      # @c3
	.type	c3,@object
	.section	.data.c3,"aw",@progbits
	.globl	c3
	.align	3
c3:
	.int64	8589934590              # 0x1fffffffe
	.size	c3, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
