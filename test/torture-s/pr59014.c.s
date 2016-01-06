	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59014.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, a($1)
	block   	BB0_2
	i32.load	$push0=, b($1)
	i32.gt_s	$push1=, $pop0, $1
	i32.const	$push2=, 1
	i32.and 	$push3=, $0, $pop2
	i32.or  	$push4=, $pop1, $pop3
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB0_2
BB0_1:                                  # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_2
	br      	BB0_1
BB0_2:                                  # %if.else
	i32.store	$discard=, d($1), $0
	return  	$1
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, a($1)
	block   	BB1_2
	i32.load	$push0=, b($1)
	i32.gt_s	$push1=, $pop0, $1
	i32.const	$push2=, 1
	i32.and 	$push3=, $0, $pop2
	i32.or  	$push4=, $pop1, $pop3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $pop4, $pop8
	br_if   	$pop9, BB1_2
BB1_1:                                  # %for.inc.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_2
	br      	BB1_1
BB1_2:                                  # %foo.exit
	block   	BB1_4
	i32.store	$push5=, d($1), $0
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, BB1_4
# BB#3:                                 # %if.end
	return  	$1
BB1_4:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	2                       # 0x2
	.size	a, 4

	.type	b,@object               # @b
	.bss
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
