	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000819-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.sub 	$1=, $2, $1
	block   	BB0_5
	i32.gt_s	$push0=, $1, $2
	br_if   	$pop0, BB0_5
# BB#1:                                 # %for.body.preheader
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.add 	$1=, $0, $pop2
BB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_4
	i32.load	$push3=, 0($1)
	i32.const	$push5=, 1
	i32.le_s	$push6=, $pop3, $pop5
	br_if   	$pop6, BB0_4
# BB#3:                                 # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push4=, 4
	i32.add 	$1=, $1, $pop4
	i32.le_u	$push7=, $1, $0
	br_if   	$pop7, BB0_2
	br      	BB0_5
BB0_4:                                  # %if.then
	call    	exit, $2
	unreachable
BB0_5:                                  # %for.end
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_3
	i32.load	$push1=, a($0)
	i32.const	$push2=, 2
	i32.lt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, BB1_3
# BB#1:                                 # %entry
	i32.load	$push0=, a+4($0)
	i32.const	$push4=, 1
	i32.le_s	$push5=, $pop0, $pop4
	br_if   	$pop5, BB1_3
# BB#2:                                 # %for.cond.i.1
	call    	abort
	unreachable
BB1_3:                                  # %if.then.i
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	2                       # 0x2
	.int32	0                       # 0x0
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
