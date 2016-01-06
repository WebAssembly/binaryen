	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49073.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$2=, a+4
BB0_1:                                  # %do.body
                                        # =>This Inner Loop Header: Depth=1
	block   	BB0_6
	loop    	BB0_5
	i32.load	$0=, 0($2)
	i32.const	$1=, 1
	block   	BB0_4
	i32.and 	$push1=, $3, $1
	i32.const	$push12=, 0
	i32.eq  	$push13=, $pop1, $pop12
	br_if   	$pop13, BB0_4
# BB#2:                                 # %do.body
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push2=, 4
	i32.ne  	$push3=, $0, $pop2
	br_if   	$pop3, BB0_4
# BB#3:                                 # %if.then
	i32.const	$0=, 0
	i32.load	$push9=, c($0)
	i32.add 	$push0=, $pop9, $1
	i32.store	$0=, c($0), $pop0
	br      	BB0_6
BB0_4:                                  # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push4=, 3
	i32.eq  	$3=, $0, $pop4
	i32.const	$push7=, 4
	i32.add 	$2=, $2, $pop7
	i32.const	$push5=, 7
	i32.lt_s	$push6=, $0, $pop5
	br_if   	$pop6, BB0_1
BB0_5:                                  # %do.endthread-pre-split
	i32.const	$push8=, 0
	i32.load	$0=, c($pop8)
BB0_6:                                  # %do.end
	block   	BB0_8
	i32.ne  	$push10=, $0, $1
	br_if   	$pop10, BB0_8
# BB#7:                                 # %if.end6
	i32.const	$push11=, 0
	return  	$pop11
BB0_8:                                  # %if.then5
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	4
a:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.int32	3                       # 0x3
	.int32	4                       # 0x4
	.int32	5                       # 0x5
	.int32	6                       # 0x6
	.int32	7                       # 0x7
	.size	a, 28

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
