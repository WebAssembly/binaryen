	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-2c.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	BB0_3
	i32.const	$push9=, 0
	i32.eq  	$push10=, $0, $pop9
	br_if   	$pop10, BB0_3
# BB#1:                                 # %for.body.preheader
	i32.const	$2=, -3
	i32.const	$push0=, 3
	i32.mul 	$push1=, $0, $pop0
	i32.add 	$push2=, $1, $pop1
	i32.add 	$4=, $pop2, $2
	i32.const	$3=, -4
	i32.const	$push3=, 2
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push5=, a
	i32.add 	$push6=, $pop4, $pop5
	i32.add 	$1=, $pop6, $3
BB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_3
	i32.const	$push7=, -1
	i32.add 	$0=, $0, $pop7
	i32.store	$push8=, 0($1), $4
	i32.add 	$4=, $pop8, $2
	i32.add 	$1=, $1, $3
	br_if   	$0, BB0_2
BB0_3:                                  # %for.end
	return  	$0
func_end0:
	.size	f, func_end0-f

	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	block   	BB1_3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, BB1_3
# BB#1:                                 # %for.body.preheader.i
	i32.const	$3=, a
	i32.const	$1=, -3
	i32.const	$push0=, 3
	i32.mul 	$push1=, $0, $pop0
	i32.add 	$push5=, $pop1, $3
	i32.add 	$4=, $pop5, $1
	i32.const	$2=, -4
	i32.const	$push2=, 2
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop3, $3
	i32.add 	$3=, $pop4, $2
BB1_2:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_3
	i32.const	$push6=, -1
	i32.add 	$0=, $0, $pop6
	i32.store	$push7=, 0($3), $4
	i32.add 	$4=, $pop7, $1
	i32.add 	$3=, $3, $2
	br_if   	$0, BB1_2
BB1_3:                                  # %f.exit
	return  	$0
func_end1:
	.size	g, func_end1-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, a+3
	i32.store	$discard=, a+4($0), $pop0
	i32.const	$push1=, a
	i32.store	$discard=, a($0), $pop1
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	2
a:
	.zero	8
	.size	a, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
