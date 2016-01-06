	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031215-1.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
# BB#0:                                 # %entry
	return
func_end0:
	.size	test1, func_end0-test1

	.globl	test2
	.type	test2,@function
test2:                                  # @test2
# BB#0:                                 # %entry
	return
func_end1:
	.size	test2, func_end1-test2

	.globl	test3
	.type	test3,@function
test3:                                  # @test3
# BB#0:                                 # %entry
	return
func_end2:
	.size	test3, func_end2-test3

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end3:
	.size	main, func_end3-main

	.type	ao,@object              # @ao
	.section	.rodata,"a",@progbits
	.globl	ao
	.align	2
ao:
	.int32	2                       # 0x2
	.int32	2                       # 0x2
	.asciz	"OK"
	.zero	1
	.size	ao, 12

	.type	a,@object               # @a
	.section	.data.rel.ro,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	ao
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
