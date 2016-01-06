	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34415.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 1
                                        # implicit-def: %vreg38
BB0_1:                                  # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	BB0_8
	copy_local	$1=, $0
	i32.load8_s	$2=, 0($1)
	i32.const	$4=, 255
	i32.const	$push0=, -97
	i32.add 	$push1=, $2, $pop0
	i32.and 	$push2=, $pop1, $4
	i32.const	$push3=, 26
	i32.lt_u	$push4=, $pop2, $pop3
	i32.const	$push5=, -32
	i32.add 	$push6=, $2, $pop5
	i32.select	$3=, $pop4, $pop6, $2
	copy_local	$0=, $1
	block   	BB0_7
	i32.const	$push7=, 66
	i32.eq  	$push8=, $3, $pop7
	br_if   	$pop8, BB0_7
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $1
	block   	BB0_4
	i32.const	$push9=, 65
	i32.ne  	$push10=, $3, $pop9
	br_if   	$pop10, BB0_4
BB0_3:                                  # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB0_4
	i32.const	$push11=, 1
	i32.add 	$0=, $0, $pop11
	i32.load8_u	$push12=, 0($0)
	i32.const	$push13=, 43
	i32.eq  	$push14=, $pop12, $pop13
	br_if   	$pop14, BB0_3
	br      	BB0_7
BB0_4:                                  # %for.end
	block   	BB0_6
	i32.const	$push15=, 3
	i32.lt_s	$push16=, $6, $pop15
	br_if   	$pop16, BB0_6
# BB#5:                                 # %land.lhs.true17
	i32.and 	$push17=, $2, $4
	i32.const	$push18=, 58
	i32.eq  	$push19=, $pop17, $pop18
	i32.select	$push20=, $pop19, $5, $1
	return  	$pop20
BB0_6:                                  # %if.end22
	return  	$1
BB0_7:                                  # %cleanup.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$2=, 1
	i32.add 	$0=, $0, $2
	i32.add 	$6=, $6, $2
	copy_local	$5=, $1
	br      	BB0_1
BB0_8:
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .str
	i32.call	$push1=, foo, $pop0
	i32.const	$push2=, .str+2
	i32.ne  	$push3=, $pop1, $pop2
	return  	$pop3
func_end1:
	.size	main, func_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"Bbb:"
	.size	.str, 5


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
