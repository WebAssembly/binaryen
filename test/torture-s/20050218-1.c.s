	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050218-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	block   	BB0_6
	i32.const	$push5=, 0
	i32.eq  	$push6=, $2, $pop5
	br_if   	$pop6, BB0_6
# BB#1:                                 # %for.body.lr.ph
	i32.const	$7=, 0
	i32.const	$6=, a
	copy_local	$8=, $7
BB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_6
	i32.load	$4=, 0($6)
	i32.call	$3=, strlen, $4
	i32.add 	$push0=, $0, $7
	i32.call	$5=, strncmp, $pop0, $4, $3
	i32.const	$4=, 2
	br_if   	$5, BB0_6
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$7=, $3, $7
	block   	BB0_5
	i32.const	$push7=, 0
	i32.eq  	$push8=, $1, $pop7
	br_if   	$pop8, BB0_5
# BB#4:                                 # %if.then6
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.call	$push1=, strlen, $1
	i32.add 	$7=, $pop1, $7
BB0_5:                                  # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push2=, 1
	i32.add 	$8=, $8, $pop2
	i32.const	$push3=, 4
	i32.add 	$6=, $6, $pop3
	i32.const	$4=, 0
	i32.lt_u	$push4=, $8, $2
	br_if   	$pop4, BB0_2
BB0_6:                                  # %cleanup
	return  	$4
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$3=, a($2)
	i32.call	$0=, strlen, $3
	i32.const	$4=, .str.4
	block   	BB1_4
	i32.call	$push0=, strncmp, $4, $3, $0
	br_if   	$pop0, BB1_4
# BB#1:                                 # %if.end.i
	i32.load	$3=, a+4($2)
	i32.call	$1=, strlen, $3
	i32.add 	$push1=, $4, $0
	i32.call	$push2=, strncmp, $pop1, $3, $1
	br_if   	$pop2, BB1_4
# BB#2:                                 # %if.end.i.1
	i32.load	$3=, a+8($2)
	i32.add 	$push3=, $1, $0
	i32.add 	$push4=, $4, $pop3
	i32.call	$push5=, strlen, $3
	i32.call	$push6=, strncmp, $pop4, $3, $pop5
	br_if   	$pop6, BB1_4
# BB#3:                                 # %if.end.i.2
	return  	$2
BB1_4:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"a"
	.size	.str, 2

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"bc"
	.size	.str.1, 3

	.type	.str.2,@object          # @.str.2
.str.2:
	.asciz	"de"
	.size	.str.2, 3

	.type	.str.3,@object          # @.str.3
.str.3:
	.asciz	"fgh"
	.size	.str.3, 4

	.type	a,@object               # @a
	.data
	.globl	a
	.align	4
a:
	.int32	.str
	.int32	.str.1
	.int32	.str.2
	.int32	.str.3
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.int32	0
	.size	a, 64

	.type	.str.4,@object          # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.str.4:
	.asciz	"abcde"
	.size	.str.4, 6


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
