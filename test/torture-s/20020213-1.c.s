	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020213-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, b($0)
	i32.const	$push1=, -1
	i32.add 	$1=, $pop0, $pop1
	i32.const	$2=, 2241
	i32.gt_s	$3=, $1, $2
	block   	BB0_2
	i32.select	$push2=, $3, $2, $1
	i32.store	$discard=, a+4($0), $pop2
	i32.const	$push3=, 0
	i32.eq  	$push4=, $3, $pop3
	br_if   	$pop4, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2241
	return  	$pop0
func_end1:
	.size	bar, func_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %foo.exit
	i32.const	$0=, 0
	i32.const	$push0=, 1065353216
	i32.store	$discard=, a($0), $pop0
	i32.const	$push1=, 3384
	i32.store	$discard=, b($0), $pop1
	i32.const	$push2=, 2241
	i32.store	$discard=, a+4($0), $pop2
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.zero	8
	.size	a, 8

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
