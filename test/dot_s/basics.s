	.text
	.file	"/tmp/tmplu1mMq/a.out.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:
	i32.const	$push0=, .str
	call    	$discard=, puts, $pop0
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $0, $pop1
	i32.const	$push3=, 30
	i32.shr_u	$push4=, $pop2, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, -4
	i32.and 	$push7=, $pop5, $pop6
	i32.sub 	$push8=, $0, $pop7
	i32.const	$push9=, 1
	i32.ne  	$push10=, $pop8, $pop9
	block   	BB0_5
	block   	BB0_4
	br_if   	$pop10, BB0_4
BB0_1:                                  # %.preheader
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_4
	i32.const	$push12=, 10
	i32.gt_s	$push13=, $0, $pop12
	i32.add 	$0=, $pop13, $0
	i32.const	$push14=, 5
	i32.rem_s	$push15=, $0, $pop14
	i32.const	$push16=, 3
	i32.ne  	$push17=, $pop15, $pop16
	block   	BB0_3
	br_if   	$pop17, BB0_3
# BB#2:                                 #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push18=, 111
	i32.rem_s	$push19=, $0, $pop18
	i32.add 	$0=, $pop19, $0
BB0_3:                                  #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push20=, 7
	i32.rem_s	$push21=, $0, $pop20
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop21, $pop22
	br_if   	$pop23, BB0_5
	br      	BB0_1
BB0_4:
	i32.const	$push11=, -12
	i32.add 	$0=, $0, $pop11
BB0_5:                                  # %.loopexit
	return  	$0
func_end0:
	.size	main, func_end0-main

	.type	.str,@object            # @.str
	.data
.str:
	.asciz	"hello, world!\n"
	.size	.str, 15


