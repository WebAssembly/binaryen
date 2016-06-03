	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000715-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.test2,"ax",@progbits
	.hidden	test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2

	.section	.text.test3,"ax",@progbits
	.hidden	test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3

	.section	.text.test4,"ax",@progbits
	.hidden	test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
# BB#0:                                 # %if.end8
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 3
	i32.store	$push0=, y($pop3), $pop1
	i32.store	$drop=, x($pop2), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4

	.section	.text.test5,"ax",@progbits
	.hidden	test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
# BB#0:                                 # %if.end8
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 3
	i32.store	$push0=, y($pop3), $pop1
	i32.store	$drop=, x($pop2), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5

	.section	.text.test6,"ax",@progbits
	.hidden	test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
# BB#0:                                 # %if.end8
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 3
	i32.store	$push0=, y($pop3), $pop1
	i32.store	$drop=, x($pop2), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	test4@FUNCTION
	call    	test5@FUNCTION
	call    	test6@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
