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
	i32.const	$push1=, 1
	i32.add 	$1=, $1, $pop1
	i32.ge_s	$push0=, $1, $0
	br_if   	1, $pop0
	call    	something@FUNCTION
	br      	0
.LBB0_3:
	end_loop
	return
	.endfunc
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
	i32.const	$push1=, 1
	i32.add 	$1=, $1, $pop1
	i32.ge_s	$push0=, $1, $0
	br_if   	1, $pop0
	call    	something@FUNCTION
	br      	0
.LBB1_3:
	end_loop
	return
	.endfunc
.Lfunc_end1:
	.size	test1, .Lfunc_end1-test1

	.globl	test2
	.type	test2,@function
test2:
	.param  	i32, i32
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	br_if   	0, $pop1
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
	br_if   	0, $1
.LBB2_2:
	end_loop
	end_block
	return
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2

	.globl	doublediamond
	.type	doublediamond,@function
doublediamond:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	block
	block
	br_if   	0, $0
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	1
.LBB3_2:
	end_block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	block
	br_if   	0, $1
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
	i32.const	$push6=, 0
	return  	$pop6
	.endfunc
.Lfunc_end3:
	.size	doublediamond, .Lfunc_end3-doublediamond

	.globl	triangle
	.type	triangle,@function
triangle:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	block
	br_if   	0, $1
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
.LBB4_2:
	end_block
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
	.endfunc
.Lfunc_end4:
	.size	triangle, .Lfunc_end4-triangle

	.globl	diamond
	.type	diamond,@function
diamond:
	.param  	i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	block
	block
	br_if   	0, $1
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
	i32.const	$push4=, 0
	return  	$pop4
	.endfunc
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
	.endfunc
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
	.endfunc
.Lfunc_end7:
	.size	minimal_loop, .Lfunc_end7-minimal_loop

	.globl	simple_loop
	.type	simple_loop,@function
simple_loop:
	.param  	i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
.LBB8_1:
	loop
	i32.const	$push3=, 1
	i32.store	$discard=, 0($0), $pop3
	i32.const	$push4=, 0
	i32.eq  	$push5=, $1, $pop4
	br_if   	0, $pop5
	end_loop
	i32.const	$push1=, 2
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push2=, 0
	return  	$pop2
	.endfunc
.Lfunc_end8:
	.size	simple_loop, .Lfunc_end8-simple_loop

	.globl	doubletriangle
	.type	doubletriangle,@function
doubletriangle:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	block
	br_if   	0, $0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	block
	br_if   	0, $1
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
	.endfunc
.Lfunc_end9:
	.size	doubletriangle, .Lfunc_end9-doubletriangle

	.globl	ifelse_earlyexits
	.type	ifelse_earlyexits,@function
ifelse_earlyexits:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	block
	block
	br_if   	0, $0
	i32.const	$push3=, 1
	i32.store	$discard=, 0($2), $pop3
	br      	1
.LBB10_2:
	end_block
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	0, $1
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
.LBB10_4:
	end_block
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	i32.const	$push5=, 0
	return  	$pop5
	.endfunc
.Lfunc_end10:
	.size	ifelse_earlyexits, .Lfunc_end10-ifelse_earlyexits

	.globl	doublediamond_in_a_loop
	.type	doublediamond_in_a_loop,@function
doublediamond_in_a_loop:
	.param  	i32, i32, i32
	.result 	i32
.LBB11_1:
	loop
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	block
	block
	br_if   	0, $0
	i32.const	$push1=, 1
	i32.store	$discard=, 0($2), $pop1
	br      	1
.LBB11_3:
	end_block
	i32.const	$push2=, 2
	i32.store	$discard=, 0($2), $pop2
	block
	br_if   	0, $1
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	1
.LBB11_5:
	end_block
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
.LBB11_6:
	end_block
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	br      	0
.LBB11_7:
	end_loop
	.endfunc
.Lfunc_end11:
	.size	doublediamond_in_a_loop, .Lfunc_end11-doublediamond_in_a_loop

	.globl	test3
	.type	test3,@function
test3:
	.param  	i32
	block
	i32.const	$push0=, 0
	br_if   	0, $pop0
.LBB12_1:
	loop
	br_if   	1, $0
.LBB12_2:
	loop
	i32.ne  	$push1=, $0, $0
	br_if   	0, $pop1
	end_loop
	call    	bar@FUNCTION
	br      	0
.LBB12_4:
	end_loop
	unreachable
.LBB12_5:
	end_block
	return
	.endfunc
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
	br_if   	0, $pop1
	block
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	0, $pop9
	i32.const	$push6=, 2
	i32.ne  	$push7=, $0, $pop6
	br_if   	2, $pop7
.LBB13_3:
	end_block
	return
.LBB13_4:
	end_block
	i32.const	$push2=, 4
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3
	i32.const	$push4=, 622
	i32.ne  	$push5=, $0, $pop4
	br_if   	0, $pop5
	return
.LBB13_7:
	end_block
	return
.LBB13_8:
	end_block
	return
	.endfunc
.Lfunc_end13:
	.size	test4, .Lfunc_end13-test4

	.globl	test5
	.type	test5,@function
test5:
	.param  	i32, i32
	.local  	i32
	i32.const	$push5=, 1
	i32.and 	$0=, $0, $pop5
	i32.const	$push4=, 1
	i32.and 	$2=, $1, $pop4
.LBB14_1:
	block
	loop
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	$1=, 0($pop7), $pop6
	i32.const	$push9=, 0
	i32.eq  	$push10=, $0, $pop9
	br_if   	2, $pop10
	i32.const	$push8=, 1
	i32.store	$discard=, 0($1), $pop8
	br_if   	0, $2
	end_loop
	i32.const	$push2=, 0
	i32.const	$push3=, 3
	i32.store	$discard=, 0($pop2), $pop3
	return
.LBB14_4:
	end_block
	i32.const	$push0=, 0
	i32.const	$push1=, 2
	i32.store	$discard=, 0($pop0), $pop1
	return
	.endfunc
.Lfunc_end14:
	.size	test5, .Lfunc_end14-test5

	.globl	test6
	.type	test6,@function
test6:
	.param  	i32, i32
	.local  	i32, i32, i32
	i32.const	$push8=, 1
	i32.and 	$2=, $0, $pop8
.LBB15_1:
	block
	block
	loop
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.store	$0=, 0($pop10), $pop9
	i32.const	$push14=, 0
	i32.eq  	$push15=, $2, $pop14
	br_if   	3, $pop15
	i32.const	$push13=, 1
	i32.store	$push0=, 0($0), $pop13
	tee_local	$push12=, $4=, $pop0
	i32.and 	$push1=, $1, $pop12
	tee_local	$push11=, $3=, $pop1
	i32.const	$push16=, 0
	i32.eq  	$push17=, $pop11, $pop16
	br_if   	2, $pop17
	i32.store	$discard=, 0($0), $4
	br_if   	0, $3
	end_loop
	i32.const	$push6=, 0
	i32.const	$push7=, 2
	i32.store	$discard=, 0($pop6), $pop7
	return
.LBB15_5:
	end_block
	i32.const	$push2=, 0
	i32.const	$push3=, 3
	i32.store	$discard=, 0($pop2), $pop3
.LBB15_6:
	end_block
	i32.const	$push4=, 0
	i32.const	$push5=, 4
	i32.store	$discard=, 0($pop4), $pop5
	return
	.endfunc
.Lfunc_end15:
	.size	test6, .Lfunc_end15-test6

	.globl	test7
	.type	test7,@function
test7:
	.param  	i32, i32
	.local  	i32, i32
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.store	$2=, 0($pop0), $pop8
	i32.const	$push7=, 1
	i32.and 	$3=, $0, $pop7
.LBB16_1:
	loop
	i32.const	$push9=, 1
	i32.store	$0=, 0($2), $pop9
	block
	br_if   	0, $3
	i32.const	$push10=, 2
	i32.store	$discard=, 0($2), $pop10
	i32.and 	$push1=, $1, $0
	br_if   	1, $pop1
	i32.const	$push2=, 0
	i32.const	$push3=, 4
	i32.store	$discard=, 0($pop2), $pop3
	unreachable
.LBB16_4:
	end_block
	i32.const	$push11=, 3
	i32.store	$discard=, 0($2), $pop11
	i32.and 	$push4=, $1, $0
	br_if   	0, $pop4
	end_loop
	i32.const	$push5=, 0
	i32.const	$push6=, 5
	i32.store	$discard=, 0($pop5), $pop6
	unreachable
	.endfunc
.Lfunc_end16:
	.size	test7, .Lfunc_end16-test7

	.globl	test8
	.type	test8,@function
test8:
	.result 	i32
.LBB17_1:
	loop
	block
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop0, $pop3
	br_if   	0, $pop4
	i32.const	$push2=, 0
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop2, $pop5
	br_if   	1, $pop6
.LBB17_3:
	end_block
	loop
	i32.const	$push1=, 0
	br_if   	0, $pop1
	br      	2
.LBB17_4:
	end_loop
	end_loop
	.endfunc
.Lfunc_end17:
	.size	test8, .Lfunc_end17-test8

	.globl	test9
	.type	test9,@function
test9:
	.local  	i32, i32
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i32.store	$0=, 0($pop0), $pop12
.LBB18_1:
	loop
	i32.const	$push14=, 1
	i32.store	$push1=, 0($0), $pop14
	tee_local	$push13=, $1=, $pop1
	i32.call	$push2=, a@FUNCTION
	i32.and 	$push3=, $pop13, $pop2
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop3, $pop18
	br_if   	1, $pop19
.LBB18_2:
	loop
	i32.const	$push15=, 2
	i32.store	$discard=, 0($0), $pop15
	block
	i32.call	$push6=, a@FUNCTION
	i32.and 	$push7=, $pop6, $1
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop7, $pop20
	br_if   	0, $pop21
	i32.const	$push16=, 3
	i32.store	$discard=, 0($0), $pop16
	i32.call	$push10=, a@FUNCTION
	i32.and 	$push11=, $pop10, $1
	br_if   	1, $pop11
	br      	3
.LBB18_4:
	end_block
	i32.const	$push17=, 4
	i32.store	$discard=, 0($0), $pop17
	i32.call	$push8=, a@FUNCTION
	i32.and 	$push9=, $pop8, $1
	br_if   	0, $pop9
	br      	2
.LBB18_5:
	end_loop
	end_loop
	i32.const	$push4=, 0
	i32.const	$push5=, 5
	i32.store	$discard=, 0($pop4), $pop5
	return
	.endfunc
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
	br_if   	0, $4
.LBB19_2:
	block
	loop
	copy_local	$4=, $3
	copy_local	$3=, $2
.LBB19_3:
	loop
	copy_local	$2=, $4
	i32.const	$push1=, 4
	i32.gt_u	$push0=, $2, $pop1
	br_if   	5, $pop0
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
	.endfunc
.Lfunc_end19:
	.size	test10, .Lfunc_end19-test10

	.globl	test11
	.type	test11,@function
test11:
	.local  	i32
	block
	block
	block
	block
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.store	$push1=, 0($pop0), $pop15
	tee_local	$push14=, $0=, $pop1
	br_if   	0, $pop14
	i32.const	$push7=, 1
	i32.store	$discard=, 0($0), $pop7
	block
	br_if   	0, $0
	i32.const	$push9=, 0
	i32.const	$push8=, 2
	i32.store	$discard=, 0($pop9), $pop8
	i32.const	$push16=, 0
	br_if   	2, $pop16
.LBB20_3:
	end_block
	i32.const	$push12=, 0
	i32.const	$push13=, 3
	i32.store	$discard=, 0($pop12), $pop13
	return
.LBB20_4:
	end_block
	i32.const	$push2=, 4
	i32.store	$discard=, 0($0), $pop2
	br_if   	2, $0
	i32.const	$push18=, 0
	i32.const	$push3=, 5
	i32.store	$discard=, 0($pop18), $pop3
	i32.const	$push17=, 0
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop17, $pop20
	br_if   	1, $pop21
.LBB20_6:
	end_block
	i32.const	$push10=, 0
	i32.const	$push11=, 7
	i32.store	$discard=, 0($pop10), $pop11
	return
.LBB20_7:
	end_block
	i32.const	$push19=, 0
	i32.const	$push4=, 6
	i32.store	$discard=, 0($pop19), $pop4
	return
.LBB20_8:
	end_block
	i32.const	$push5=, 0
	i32.const	$push6=, 8
	i32.store	$discard=, 0($pop5), $pop6
	return
	.endfunc
.Lfunc_end20:
	.size	test11, .Lfunc_end20-test11

	.globl	test12
	.type	test12,@function
test12:
	.param  	i32
	.local  	i32
.LBB21_1:
	loop
	block
	block
	block
	i32.load8_u	$push0=, 0($0)
	tee_local	$push7=, $1=, $pop0
	i32.const	$push6=, 103
	i32.gt_s	$push1=, $pop7, $pop6
	br_if   	0, $pop1
	i32.const	$push8=, 42
	i32.eq  	$push4=, $1, $pop8
	br_if   	2, $pop4
	i32.const	$push9=, 76
	i32.eq  	$push5=, $1, $pop9
	br_if   	2, $pop5
	br      	1
.LBB21_4:
	end_block
	i32.const	$push10=, 108
	i32.eq  	$push2=, $1, $pop10
	br_if   	1, $pop2
	i32.const	$push11=, 104
	i32.eq  	$push3=, $1, $pop11
	br_if   	1, $pop3
.LBB21_6:
	end_block
	return
.LBB21_7:
	end_block
	i32.const	$push12=, 1
	i32.add 	$0=, $0, $pop12
	br      	0
.LBB21_8:
	end_loop
	.endfunc
.Lfunc_end21:
	.size	test12, .Lfunc_end21-test12

	.globl	test13
	.type	test13,@function
test13:
	.local  	i32
	block
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop0, $pop4
	br_if   	0, $pop5
	return
.LBB22_2:
	end_block
	i32.const	$0=, 0
	block
	i32.const	$push3=, 0
	br_if   	0, $pop3
	i32.const	$0=, 0
.LBB22_4:
	end_block
	block
	i32.const	$push1=, 1
	i32.and 	$push2=, $0, $pop1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop2, $pop6
	br_if   	0, $pop7
	end_block
	unreachable
	.endfunc
.Lfunc_end22:
	.size	test13, .Lfunc_end22-test13

	.globl	test14
	.type	test14,@function
test14:
.LBB23_1:
	loop
	i32.const	$push0=, 0
	br_if   	0, $pop0
.LBB23_2:
	end_loop
	loop
	i32.const	$discard=, 0
	i32.const	$push1=, 0
	br_if   	0, $pop1
	end_loop
	return
	.endfunc
.Lfunc_end23:
	.size	test14, .Lfunc_end23-test14


