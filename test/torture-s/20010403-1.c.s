	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010403-1.c"
	.globl	a
	.type	a,@function
a:                                      # @a
	.param  	i32, i32
# BB#0:                                 # %c.exit
	return
.Lfunc_end0:
	.size	a, .Lfunc_end0-a

	.globl	b
	.type	b,@function
b:                                      # @b
	.param  	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 0($0), $pop2
	return
.Lfunc_end1:
	.size	b, .Lfunc_end1-b

	.globl	c
	.type	c,@function
c:                                      # @c
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, .LBB2_2
# BB#1:                                 # %if.end
	return
.LBB2_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end2:
	.size	c, .Lfunc_end2-c

	.globl	d
	.type	d,@function
d:                                      # @d
	.param  	i32
# BB#0:                                 # %entry
	return
.Lfunc_end3:
	.size	d, .Lfunc_end3-d

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.type	e,@object               # @e
	.bss
	.globl	e
	.align	2
e:
	.int32	0                       # 0x0
	.size	e, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
