	.text
	.file	"/tmp/tmplu1mMq/a.out.bc"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:
	i32.const	$push0=, .str
	call    	$drop=, puts@FUNCTION, $pop0
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
	block
	block
	br_if   	0, $pop10
.LBB0_1:                                  # %.preheader
                                        # =>This Inner Loop Header: Depth=1
        block
	loop
	i32.const	$push12=, 10
	i32.gt_s	$push13=, $0, $pop12
	i32.add 	$0=, $pop13, $0
	i32.const	$push14=, 5
	i32.rem_s	$push15=, $0, $pop14
	i32.const	$push16=, 3
	i32.ne  	$push17=, $pop15, $pop16
	block
	br_if   	0, $pop17
# BB#2:                                 #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$push18=, 111
	i32.rem_s	$push19=, $0, $pop18
	i32.add 	$0=, $pop19, $0
	end_block
	i32.const	$push20=, 7
	i32.rem_s	$push21=, $0, $pop20
	i32.const	$push22=, 0
	i32.eq  	$push23=, $pop21, $pop22
	br_if   	2, $pop23
	br      	0
	end_loop
        end_block
	end_block
	i32.const	$push11=, -12
	i32.add 	$0=, $0, $pop11
	i32.const	$drop=, main@FUNCTION # just take address for testing
	end_block
	copy_local	$push24=, $0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.str,@object            # @.str
	.data
.str:
	.asciz	"hello, world!\n"
	.size	.str, 15

	.type	a2,@object              # @a2
	.globl	a2
a2:
	.int8	118                     # 0x76
	.ascii	"cq"
	.size	a2, 3 # surprisingly large size

	.type	a3,@object              # @a3
	.globl	a3
a3:
	.int32 a2-10

