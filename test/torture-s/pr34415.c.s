	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34415.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 1
                                        # implicit-def: %vreg38
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	.LBB0_8
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
	block   	.LBB0_7
	i32.const	$push7=, 66
	i32.eq  	$push8=, $3, $pop7
	br_if   	$pop8, .LBB0_7
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	copy_local	$0=, $1
	block   	.LBB0_4
	i32.const	$push9=, 65
	i32.ne  	$push10=, $3, $pop9
	br_if   	$pop10, .LBB0_4
.LBB0_3:                                # %do.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_4
	i32.const	$push11=, 1
	i32.add 	$0=, $0, $pop11
	i32.load8_u	$push12=, 0($0)
	i32.const	$push13=, 43
	i32.eq  	$push14=, $pop12, $pop13
	br_if   	$pop14, .LBB0_3
	br      	.LBB0_7
.LBB0_4:                                # %for.end
	block   	.LBB0_6
	i32.const	$push15=, 3
	i32.lt_s	$push16=, $6, $pop15
	br_if   	$pop16, .LBB0_6
# BB#5:                                 # %land.lhs.true17
	i32.and 	$push17=, $2, $4
	i32.const	$push18=, 58
	i32.eq  	$push19=, $pop17, $pop18
	i32.select	$push20=, $pop19, $5, $1
	return  	$pop20
.LBB0_6:                                # %if.end22
	return  	$1
.LBB0_7:                                # %cleanup.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$2=, 1
	i32.add 	$0=, $0, $2
	i32.add 	$6=, $6, $2
	copy_local	$5=, $1
	br      	.LBB0_1
.LBB0_8:
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push2=, .L.str+2
	i32.ne  	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"Bbb:"
	.size	.L.str, 5


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
