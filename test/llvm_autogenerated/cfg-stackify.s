	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/cfg-stackify.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
.LBB0_1:
	loop
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, 1
	call    	something@FUNCTION
	br      	0
.LBB0_3:
	end_loop
	return
.Lfunc_end0:
	.size	test0, .Lfunc_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
.LBB1_1:
	loop
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, 1
	call    	something@FUNCTION
	br      	0
.LBB1_3:
	end_loop
	return
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.globl	test2
	.type	test2,@function
test2:
	.param  	i32, i32
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	br_if   	$pop1, 0
.LBB2_1:
	loop
	i32.const	$push5=, -1
	i32.add 	$1=, $1, $pop5
	f64.load	$push2=, 0($0)
	f64.const	$push3=, 0x1.999999999999ap1
	f64.mul 	$push4=, $pop2, $pop3
	f64.store	$discard=, 0($0), $pop4
	i32.const	$push6=, 8
	i32.add 	$0=, $0, $pop6
	br_if   	$1, 0
.LBB2_2:
	end_loop
	end_block
	return
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.globl	doublediamond
	.type	doublediamond,@function
doublediamond:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block
	block
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, 0
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	1
.LBB3_2:
	end_block
	block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, 0
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	1
.LBB3_4:
	end_block
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
.LBB3_5:
	end_block
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	return  	$3
.Lfunc_end3:
	.size	doublediamond, .Lfunc_end3-doublediamond

	.globl	triangle
	.type	triangle,@function
triangle:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	block
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	br_if   	$1, 0
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
.LBB4_2:
	end_block
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
.Lfunc_end4:
	.size	triangle, .Lfunc_end4-triangle

	.globl	diamond
	.type	diamond,@function
diamond:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	block
	block
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	br_if   	$1, 0
	i32.const	$push2=, 1
	i32.store	$discard=, 0($0), $pop2
	br      	1
.LBB5_2:
	end_block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($0), $pop1
.LBB5_3:
	end_block
	i32.const	$push3=, 3
	i32.store	$discard=, 0($0), $pop3
	return  	$2
.Lfunc_end5:
	.size	diamond, .Lfunc_end5-diamond

	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
.Lfunc_end6:
	.size	single_block, .Lfunc_end6-single_block

	.globl	minimal_loop
	.type	minimal_loop,@function
minimal_loop:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
.LBB7_1:
	loop
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	br      	0
.LBB7_2:
	end_loop
.Lfunc_end7:
	.size	minimal_loop, .Lfunc_end7-minimal_loop

	.globl	simple_loop
	.type	simple_loop,@function
simple_loop:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
.LBB8_1:
	loop
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, 0
	end_loop
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
.Lfunc_end8:
	.size	simple_loop, .Lfunc_end8-simple_loop

	.globl	doubletriangle
	.type	doubletriangle,@function
doubletriangle:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, 0
	block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, 0
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
.LBB9_3:
	end_block
	i32.const	$push3=, 4
	i32.store	$discard=, 0($2), $pop3
.LBB9_4:
	end_block
	i32.const	$push4=, 5
	i32.store	$discard=, 0($2), $pop4
	return  	$3
.Lfunc_end9:
	.size	doubletriangle, .Lfunc_end9-doubletriangle

	.globl	ifelse_earlyexits
	.type	ifelse_earlyexits,@function
ifelse_earlyexits:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block
	block
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, 0
	i32.const	$push3=, 1
	i32.store	$discard=, 0($2), $pop3
	br      	1
.LBB10_2:
	end_block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, 0
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
.LBB10_4:
	end_block
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	return  	$3
.Lfunc_end10:
	.size	ifelse_earlyexits, .Lfunc_end10-ifelse_earlyexits

	.globl	doublediamond_in_a_loop
	.type	doublediamond_in_a_loop,@function
doublediamond_in_a_loop:
	.param  	i32, i32, i32
	.result 	i32
.LBB11_1:
	loop
	block
	block
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	br_if   	$0, 0
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	1
.LBB11_3:
	end_block
	block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, 0
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	1
.LBB11_5:
	end_block
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
.LBB11_6:
	end_block
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	br      	0
.LBB11_7:
	end_loop
.Lfunc_end11:
	.size	doublediamond_in_a_loop, .Lfunc_end11-doublediamond_in_a_loop

	.globl	test3
	.type	test3,@function
test3:
	.param  	i32
	block
	i32.const	$push0=, 0
	br_if   	$pop0, 0
.LBB12_1:
	loop
	br_if   	$0, 1
.LBB12_2:
	loop
	i32.ne  	$push1=, $0, $0
	br_if   	$pop1, 0
	end_loop
	call    	bar@FUNCTION
	br      	0
.LBB12_4:
	end_loop
	unreachable
.LBB12_5:
	end_block
	return
.Lfunc_end12:
	.size	test3, .Lfunc_end12-test3

	.globl	test4
	.type	test4,@function
test4:
	.param  	i32
	block
	block
	block
	i32.const	$push0=, 3
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, 0
	i32.const	$push6=, 2
	i32.ne  	$push7=, $0, $pop6
	br_if   	$pop7, 2
.LBB13_3:
	end_block
	return
.LBB13_4:
	end_block
	i32.const	$push2=, 4
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 1
	i32.const	$push4=, 622
	i32.ne  	$push5=, $0, $pop4
	br_if   	$pop5, 0
	return
.LBB13_7:
	end_block
	return
.LBB13_8:
	end_block
	return
.Lfunc_end13:
	.size	test4, .Lfunc_end13-test4

	.globl	test5
	.type	test5,@function
test5:
	.param  	i32, i32
	.local  	i32, i32
.LBB14_1:
	block
	loop
	i32.const	$2=, 0
	i32.store	$3=, 0($2), $2
	i32.const	$2=, 1
	i32.and 	$push0=, $0, $2
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	$pop6, 2
	i32.store	$push2=, 0($3), $2
	i32.and 	$push3=, $1, $pop2
	br_if   	$pop3, 0
	end_loop
	i32.const	$push4=, 3
	i32.store	$discard=, 0($3), $pop4
	return
.LBB14_4:
	end_block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($3), $pop1
	return
.Lfunc_end14:
	.size	test5, .Lfunc_end14-test5

	.globl	test6
	.type	test6,@function
test6:
	.param  	i32, i32
	.local  	i32, i32, i32
.LBB15_1:
	block
	block
	loop
	i32.const	$2=, 0
	i32.store	$discard=, 0($2), $2
	i32.const	$3=, 1
	i32.and 	$push0=, $0, $3
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop0, $pop4
	br_if   	$pop5, 3
	i32.store	$discard=, 0($2), $3
	i32.and 	$4=, $1, $3
	i32.const	$push6=, 0
	i32.eq  	$push7=, $4, $pop6
	br_if   	$pop7, 2
	i32.store	$discard=, 0($2), $3
	br_if   	$4, 0
	end_loop
	i32.const	$push3=, 2
	i32.store	$discard=, 0($2), $pop3
	return
.LBB15_5:
	end_block
	i32.const	$push1=, 3
	i32.store	$discard=, 0($2), $pop1
.LBB15_6:
	end_block
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
	return
.Lfunc_end15:
	.size	test6, .Lfunc_end15-test6

	.globl	test7
	.type	test7,@function
test7:
	.param  	i32, i32
	.local  	i32, i32
	i32.const	$3=, 0
	i32.store	$2=, 0($3), $3
.LBB16_1:
	loop
	block
	i32.const	$push0=, 1
	i32.store	$3=, 0($2), $pop0
	i32.and 	$push1=, $0, $3
	br_if   	$pop1, 0
	i32.const	$push2=, 2
	i32.store	$discard=, 0($2), $pop2
	i32.and 	$push3=, $1, $3
	br_if   	$pop3, 1
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	unreachable
.LBB16_4:
	end_block
	i32.const	$push5=, 3
	i32.store	$discard=, 0($2), $pop5
	i32.and 	$push6=, $1, $3
	br_if   	$pop6, 0
	end_loop
	i32.const	$push7=, 5
	i32.store	$discard=, 0($2), $pop7
	unreachable
.Lfunc_end16:
	.size	test7, .Lfunc_end16-test7

	.globl	test8
	.type	test8,@function
test8:
	.result 	i32
	.local  	i32
	i32.const	$0=, 0
.LBB17_1:
	loop
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, 0
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, 1
.LBB17_3:
	end_block
	loop
	br_if   	$0, 0
	br      	2
.LBB17_4:
	end_loop
	end_loop
.Lfunc_end17:
	.size	test8, .Lfunc_end17-test8

	.globl	test9
	.type	test9,@function
test9:
	.local  	i32, i32
	i32.const	$1=, 0
	i32.store	$0=, 0($1), $1
.LBB18_1:
	loop
	i32.const	$push0=, 1
	i32.store	$1=, 0($0), $pop0
	i32.call	$push1=, a@FUNCTION
	i32.and 	$push2=, $pop1, $1
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop2, $pop13
	br_if   	$pop14, 1
.LBB18_2:
	loop
	block
	i32.const	$push4=, 2
	i32.store	$discard=, 0($0), $pop4
	i32.call	$push5=, a@FUNCTION
	i32.and 	$push6=, $pop5, $1
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop6, $pop15
	br_if   	$pop16, 0
	i32.const	$push10=, 3
	i32.store	$discard=, 0($0), $pop10
	i32.call	$push11=, a@FUNCTION
	i32.and 	$push12=, $pop11, $1
	br_if   	$pop12, 1
	br      	3
.LBB18_4:
	end_block
	i32.const	$push7=, 4
	i32.store	$discard=, 0($0), $pop7
	i32.call	$push8=, a@FUNCTION
	i32.and 	$push9=, $pop8, $1
	br_if   	$pop9, 0
	br      	2
.LBB18_5:
	end_loop
	end_loop
	i32.const	$push3=, 5
	i32.store	$discard=, 0($0), $pop3
	return
.Lfunc_end18:
	.size	test9, .Lfunc_end18-test9

	.globl	test10
	.type	test10,@function
test10:
	.local  	i32, i32, i32, i32, i32
	i32.const	$0=, 2
.LBB19_1:
	loop
	copy_local	$4=, $1
	copy_local	$3=, $0
	i32.const	$1=, 0
	i32.const	$0=, 3
	i32.const	$2=, 4
	br_if   	$4, 0
.LBB19_2:
	block
	loop
	copy_local	$4=, $3
	copy_local	$3=, $2
.LBB19_3:
	loop
	copy_local	$2=, $4
	i32.const	$push0=, 4
	i32.gt_u	$push1=, $2, $pop0
	br_if   	$pop1, 5
	copy_local	$4=, $3
	tableswitch	$2, 0, 0, 1, 5, 2, 4
.LBB19_5:
	end_loop
	end_loop
	return
.LBB19_6:
	end_block
	i32.const	$1=, 1
	br      	0
.LBB19_7:
	end_loop
.Lfunc_end19:
	.size	test10, .Lfunc_end19-test10

	.globl	test11
	.type	test11,@function
test11:
	.local  	i32
	i32.const	$0=, 0
	i32.store	$discard=, 0($0), $0
	block
	block
	block
	block
	br_if   	$0, 0
	block
	i32.const	$push4=, 1
	i32.store	$discard=, 0($0), $pop4
	br_if   	$0, 0
	i32.const	$push5=, 2
	i32.store	$discard=, 0($0), $pop5
	br_if   	$0, 2
.LBB20_3:
	end_block
	i32.const	$push7=, 3
	i32.store	$discard=, 0($0), $pop7
	return
.LBB20_4:
	end_block
	i32.const	$push0=, 4
	i32.store	$discard=, 0($0), $pop0
	br_if   	$0, 2
	i32.const	$push1=, 5
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, 1
.LBB20_6:
	end_block
	i32.const	$push6=, 7
	i32.store	$discard=, 0($0), $pop6
	return
.LBB20_7:
	end_block
	i32.const	$push2=, 6
	i32.store	$discard=, 0($0), $pop2
	return
.LBB20_8:
	end_block
	i32.const	$push3=, 8
	i32.store	$discard=, 0($0), $pop3
	return
.Lfunc_end20:
	.size	test11, .Lfunc_end20-test11

	.globl	test12
	.type	test12,@function
test12:
	.param  	i32
	.local  	i32
.LBB21_1:
	loop
	i32.load8_u	$1=, 0($0)
	block
	block
	block
	i32.const	$push0=, 103
	i32.gt_s	$push1=, $1, $pop0
	br_if   	$pop1, 0
	i32.const	$push6=, 42
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, 2
	i32.const	$push8=, 76
	i32.eq  	$push9=, $1, $pop8
	br_if   	$pop9, 2
	br      	1
.LBB21_4:
	end_block
	i32.const	$push2=, 108
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, 1
	i32.const	$push4=, 104
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, 1
.LBB21_6:
	end_block
	return
.LBB21_7:
	end_block
	i32.const	$push10=, 1
	i32.add 	$0=, $0, $pop10
	br      	0
.LBB21_8:
	end_loop
.Lfunc_end21:
	.size	test12, .Lfunc_end21-test12

	.globl	test13
	.type	test13,@function
test13:
	.local  	i32
	block
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop0, $pop3
	br_if   	$pop4, 0
	return
.LBB22_2:
	end_block
	i32.const	$0=, 0
	block
	br_if   	$0, 0
	i32.const	$0=, 0
.LBB22_4:
	end_block
	block
	i32.const	$push1=, 1
	i32.and 	$push2=, $0, $pop1
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop2, $pop5
	br_if   	$pop6, 0
	end_block
	unreachable
.Lfunc_end22:
	.size	test13, .Lfunc_end22-test13

	.globl	test14
	.type	test14,@function
test14:
	.local  	i32
	i32.const	$0=, 0
.LBB23_1:
	loop
	br_if   	$0, 0
.LBB23_2:
	end_loop
	loop
	br_if   	$0, 0
	end_loop
	return
.Lfunc_end23:
	.size	test14, .Lfunc_end23-test14


	.section	".note.GNU-stack","",@progbits
