	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/cfg-stackify.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.local  	i32
	i32.const	$1=, 1
.LBB0_1:
	loop    	
	block   	
	i32.lt_s	$push0=, $1, $0
	br_if   	0, $pop0
	return
.LBB0_3:
	end_block
	i32.const	$push1=, 1
	i32.add 	$1=, $1, $pop1
	call    	something@FUNCTION
	br      	0
.LBB0_4:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	test0, .Lfunc_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.local  	i32
	i32.const	$1=, 1
.LBB1_1:
	loop    	
	block   	
	i32.lt_s	$push0=, $1, $0
	br_if   	0, $pop0
	return
.LBB1_3:
	end_block
	i32.const	$push1=, 1
	i32.add 	$1=, $1, $pop1
	call    	something@FUNCTION
	br      	0
.LBB1_4:
	end_loop
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
.LBB2_2:
	loop    	
	f64.load	$push2=, 0($0)
	f64.const	$push8=, 0x1.999999999999ap1
	f64.mul 	$push3=, $pop2, $pop8
	f64.store	0($0), $pop3
	i32.const	$push7=, 8
	i32.add 	$0=, $0, $pop7
	i32.const	$push6=, -1
	i32.add 	$push5=, $1, $pop6
	tee_local	$push4=, $1=, $pop5
	br_if   	0, $pop4
.LBB2_3:
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
	i32.store	0($2), $pop0
	block   	
	block   	
	br_if   	0, $0
	i32.const	$push4=, 1
	i32.store	0($2), $pop4
	br      	1
.LBB3_2:
	end_block
	i32.const	$push1=, 2
	i32.store	0($2), $pop1
	block   	
	br_if   	0, $1
	i32.const	$push3=, 3
	i32.store	0($2), $pop3
	br      	1
.LBB3_4:
	end_block
	i32.const	$push2=, 4
	i32.store	0($2), $pop2
.LBB3_5:
	end_block
	i32.const	$push5=, 5
	i32.store	0($2), $pop5
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
	i32.const	$push2=, 0
	i32.store	0($0), $pop2
	block   	
	br_if   	0, $1
	i32.const	$push0=, 1
	i32.store	0($0), $pop0
.LBB4_2:
	end_block
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
	i32.const	$push3=, 0
	return  	$pop3
	.endfunc
.Lfunc_end4:
	.size	triangle, .Lfunc_end4-triangle

	.globl	diamond
	.type	diamond,@function
diamond:
	.param  	i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	block   	
	block   	
	br_if   	0, $1
	i32.const	$push2=, 1
	i32.store	0($0), $pop2
	br      	1
.LBB5_2:
	end_block
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
.LBB5_3:
	end_block
	i32.const	$push3=, 3
	i32.store	0($0), $pop3
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
	i32.store	0($0), $pop0
	i32.const	$push1=, 0
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
	i32.store	0($0), $pop0
.LBB7_1:
	loop    	i32
	i32.const	$push1=, 1
	i32.store	0($0), $pop1
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
	i32.store	0($0), $pop0
.LBB8_1:
	loop    	
	i32.const	$push3=, 1
	i32.store	0($0), $pop3
	i32.eqz 	$push4=, $1
	br_if   	0, $pop4
	end_loop
	i32.const	$push1=, 2
	i32.store	0($0), $pop1
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
	i32.const	$push4=, 0
	i32.store	0($2), $pop4
	block   	
	br_if   	0, $0
	i32.const	$push0=, 2
	i32.store	0($2), $pop0
	block   	
	br_if   	0, $1
	i32.const	$push1=, 3
	i32.store	0($2), $pop1
.LBB9_3:
	end_block
	i32.const	$push2=, 4
	i32.store	0($2), $pop2
.LBB9_4:
	end_block
	i32.const	$push3=, 5
	i32.store	0($2), $pop3
	i32.const	$push5=, 0
	return  	$pop5
	.endfunc
.Lfunc_end9:
	.size	doubletriangle, .Lfunc_end9-doubletriangle

	.globl	ifelse_earlyexits
	.type	ifelse_earlyexits,@function
ifelse_earlyexits:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	0($2), $pop0
	block   	
	block   	
	br_if   	0, $0
	i32.const	$push3=, 1
	i32.store	0($2), $pop3
	br      	1
.LBB10_2:
	end_block
	i32.const	$push1=, 2
	i32.store	0($2), $pop1
	br_if   	0, $1
	i32.const	$push2=, 3
	i32.store	0($2), $pop2
.LBB10_4:
	end_block
	i32.const	$push4=, 4
	i32.store	0($2), $pop4
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
	loop    	i32
	i32.const	$push0=, 0
	i32.store	0($2), $pop0
	block   	
	br_if   	0, $0
	i32.const	$push2=, 1
	i32.store	0($2), $pop2
	i32.const	$push1=, 5
	i32.store	0($2), $pop1
	br      	1
.LBB11_3:
	end_block
	i32.const	$push3=, 2
	i32.store	0($2), $pop3
	block   	
	br_if   	0, $1
	i32.const	$push5=, 3
	i32.store	0($2), $pop5
	i32.const	$push4=, 5
	i32.store	0($2), $pop4
	br      	1
.LBB11_5:
	end_block
	i32.const	$push7=, 4
	i32.store	0($2), $pop7
	i32.const	$push6=, 5
	i32.store	0($2), $pop6
	br      	0
.LBB11_6:
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
	i32.eq  	$0=, $0, $0
.LBB12_2:
	block   	
	loop    	
	br_if   	1, $0
.LBB12_3:
	loop    	
	i32.eqz 	$push1=, $0
	br_if   	0, $pop1
	end_loop
	call    	bar@FUNCTION
	br      	0
.LBB12_5:
	end_loop
	end_block
	unreachable
.LBB12_6:
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
	i32.const	$push0=, 3
	i32.gt_s	$push1=, $0, $pop0
	br_if   	0, $pop1
	i32.eqz 	$push7=, $0
	br_if   	1, $pop7
	i32.const	$push6=, 2
	i32.eq  	$drop=, $0, $pop6
	br      	1
.LBB13_3:
	end_block
	block   	
	i32.const	$push2=, 4
	i32.eq  	$push3=, $0, $pop2
	br_if   	0, $pop3
	i32.const	$push4=, 622
	i32.ne  	$push5=, $0, $pop4
	br_if   	1, $pop5
.LBB13_5:
	end_block
	return
.LBB13_6:
	end_block
	return
	.endfunc
.Lfunc_end13:
	.size	test4, .Lfunc_end13-test4

	.globl	test5
	.type	test5,@function
test5:
	.param  	i32, i32
	i32.const	$push5=, 1
	i32.and 	$0=, $0, $pop5
	i32.const	$push4=, 1
	i32.and 	$1=, $1, $pop4
.LBB14_1:
	block   	
	loop    	
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	0($pop7), $pop6
	i32.eqz 	$push10=, $0
	br_if   	1, $pop10
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	0($pop9), $pop8
	br_if   	0, $1
	end_loop
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	0($pop3), $pop2
	return
.LBB14_4:
	end_block
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store	0($pop1), $pop0
	return
	.endfunc
.Lfunc_end14:
	.size	test5, .Lfunc_end14-test5

	.globl	test6
	.type	test6,@function
test6:
	.param  	i32, i32
	.local  	i32
	i32.const	$push6=, 1
	i32.and 	$2=, $0, $pop6
.LBB15_1:
	block   	
	block   	
	loop    	
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	0($pop8), $pop7
	i32.eqz 	$push16=, $2
	br_if   	2, $pop16
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.store	0($pop13), $pop12
	i32.const	$push11=, 1
	i32.and 	$push10=, $1, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.eqz 	$push17=, $pop9
	br_if   	1, $pop17
	i32.const	$push15=, 0
	i32.const	$push14=, 1
	i32.store	0($pop15), $pop14
	br_if   	0, $0
	end_loop
	i32.const	$push5=, 0
	i32.const	$push4=, 2
	i32.store	0($pop5), $pop4
	return
.LBB15_5:
	end_block
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	0($pop1), $pop0
.LBB15_6:
	end_block
	i32.const	$push3=, 0
	i32.const	$push2=, 4
	i32.store	0($pop3), $pop2
	return
	.endfunc
.Lfunc_end15:
	.size	test6, .Lfunc_end15-test6

	.globl	test7
	.type	test7,@function
test7:
	.param  	i32, i32
	i32.const	$push8=, 0
	i32.const	$push7=, 0
	i32.store	0($pop8), $pop7
	i32.const	$push6=, 1
	i32.and 	$0=, $0, $pop6
.LBB16_1:
	loop    	
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.store	0($pop10), $pop9
	block   	
	br_if   	0, $0
	i32.const	$push13=, 0
	i32.const	$push12=, 2
	i32.store	0($pop13), $pop12
	i32.const	$push11=, 1
	i32.and 	$push0=, $1, $pop11
	br_if   	1, $pop0
	i32.const	$push2=, 0
	i32.const	$push1=, 4
	i32.store	0($pop2), $pop1
	unreachable
.LBB16_4:
	end_block
	i32.const	$push16=, 0
	i32.const	$push15=, 3
	i32.store	0($pop16), $pop15
	i32.const	$push14=, 1
	i32.and 	$push3=, $1, $pop14
	br_if   	0, $pop3
	end_loop
	i32.const	$push5=, 0
	i32.const	$push4=, 5
	i32.store	0($pop5), $pop4
	unreachable
	.endfunc
.Lfunc_end16:
	.size	test7, .Lfunc_end16-test7

	.globl	test8
	.type	test8,@function
test8:
	.result 	i32
.LBB17_1:
	loop    	i32
	i32.const	$push0=, 0
	br_if   	0, $pop0
	br      	0
.LBB17_2:
	end_loop
	.endfunc
.Lfunc_end17:
	.size	test8, .Lfunc_end17-test8

	.globl	test9
	.type	test9,@function
test9:
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i32.store	0($pop11), $pop10
.LBB18_1:
	block   	
	loop    	
	i32.const	$push14=, 0
	i32.const	$push13=, 1
	i32.store	0($pop14), $pop13
	i32.call	$push0=, a@FUNCTION
	i32.const	$push12=, 1
	i32.and 	$push1=, $pop0, $pop12
	i32.eqz 	$push24=, $pop1
	br_if   	1, $pop24
.LBB18_2:
	loop    	
	i32.const	$push17=, 0
	i32.const	$push16=, 2
	i32.store	0($pop17), $pop16
	block   	
	i32.call	$push4=, a@FUNCTION
	i32.const	$push15=, 1
	i32.and 	$push5=, $pop4, $pop15
	i32.eqz 	$push25=, $pop5
	br_if   	0, $pop25
	i32.const	$push20=, 0
	i32.const	$push19=, 3
	i32.store	0($pop20), $pop19
	i32.call	$push8=, a@FUNCTION
	i32.const	$push18=, 1
	i32.and 	$push9=, $pop8, $pop18
	i32.eqz 	$push26=, $pop9
	br_if   	2, $pop26
	br      	1
.LBB18_4:
	end_block
	i32.const	$push23=, 0
	i32.const	$push22=, 4
	i32.store	0($pop23), $pop22
	i32.call	$push6=, a@FUNCTION
	i32.const	$push21=, 1
	i32.and 	$push7=, $pop6, $pop21
	i32.eqz 	$push27=, $pop7
	br_if   	1, $pop27
	br      	0
.LBB18_5:
	end_loop
	end_loop
	end_block
	i32.const	$push3=, 0
	i32.const	$push2=, 5
	i32.store	0($pop3), $pop2
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
	copy_local	$2=, $1
	copy_local	$3=, $0
	i32.const	$1=, 0
	i32.const	$0=, 3
	br_if   	0, $2
	i32.const	$2=, 4
.LBB19_3:
	block   	
	loop    	
	copy_local	$4=, $3
	copy_local	$3=, $2
.LBB19_4:
	loop    	
	copy_local	$push3=, $4
	tee_local	$push2=, $2=, $pop3
	i32.const	$push1=, 4
	i32.gt_u	$push0=, $pop2, $pop1
	br_if   	3, $pop0
	block   	
	copy_local	$4=, $3
	br_table 	$2, 1, 0, 4, 2, 3, 1
.LBB19_6:
	end_block
	end_loop
	end_loop
	return
.LBB19_7:
	end_block
	i32.const	$1=, 1
	br      	0
.LBB19_8:
	end_loop
	.endfunc
.Lfunc_end19:
	.size	test10, .Lfunc_end19-test10

	.globl	test11
	.type	test11,@function
test11:
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.store	0($pop14), $pop13
	block   	
	block   	
	block   	
	block   	
	i32.const	$push12=, 0
	br_if   	0, $pop12
	i32.const	$push16=, 0
	i32.const	$push5=, 1
	i32.store	0($pop16), $pop5
	block   	
	i32.const	$push15=, 0
	br_if   	0, $pop15
	i32.const	$push7=, 0
	i32.const	$push6=, 2
	i32.store	0($pop7), $pop6
	i32.const	$push17=, 0
	br_if   	2, $pop17
.LBB20_3:
	end_block
	i32.const	$push11=, 0
	i32.const	$push10=, 3
	i32.store	0($pop11), $pop10
	return
.LBB20_4:
	end_block
	i32.const	$push19=, 0
	i32.const	$push0=, 4
	i32.store	0($pop19), $pop0
	i32.const	$push18=, 0
	br_if   	1, $pop18
	i32.const	$push21=, 0
	i32.const	$push1=, 5
	i32.store	0($pop21), $pop1
	i32.const	$push20=, 0
	i32.eqz 	$push23=, $pop20
	br_if   	2, $pop23
.LBB20_6:
	end_block
	i32.const	$push9=, 0
	i32.const	$push8=, 7
	i32.store	0($pop9), $pop8
	return
.LBB20_7:
	end_block
	i32.const	$push4=, 0
	i32.const	$push3=, 8
	i32.store	0($pop4), $pop3
	return
.LBB20_8:
	end_block
	i32.const	$push22=, 0
	i32.const	$push2=, 6
	i32.store	0($pop22), $pop2
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
	block   	
	loop    	
	block   	
	block   	
	i32.load8_u	$push7=, 0($0)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 103
	i32.gt_s	$push0=, $pop6, $pop5
	br_if   	0, $pop0
	i32.const	$push8=, 42
	i32.eq  	$push3=, $1, $pop8
	br_if   	1, $pop3
	i32.const	$push9=, 76
	i32.eq  	$push4=, $1, $pop9
	br_if   	1, $pop4
	br      	3
.LBB21_4:
	end_block
	i32.const	$push10=, 108
	i32.eq  	$push1=, $1, $pop10
	br_if   	0, $pop1
	i32.const	$push11=, 104
	i32.ne  	$push2=, $1, $pop11
	br_if   	2, $pop2
.LBB21_6:
	end_block
	i32.const	$push12=, 1
	i32.add 	$0=, $0, $pop12
	br      	0
.LBB21_7:
	end_loop
	end_block
	return
	.endfunc
.Lfunc_end21:
	.size	test12, .Lfunc_end21-test12

	.globl	test13
	.type	test13,@function
test13:
	.local  	i32
	block   	
	block   	
	i32.const	$push0=, 0
	br_if   	0, $pop0
	i32.const	$0=, 0
	block   	
	i32.const	$push3=, 0
	br_if   	0, $pop3
	i32.const	$0=, 0
.LBB22_3:
	end_block
	i32.const	$push1=, 1
	i32.and 	$push2=, $0, $pop1
	br_if   	1, $pop2
	br      	1
.LBB22_4:
	end_block
	return
.LBB22_5:
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
	end_loop
.LBB23_3:
	loop    	
	i32.const	$push1=, 0
	br_if   	0, $pop1
	end_loop
	return
	.endfunc
.Lfunc_end23:
	.size	test14, .Lfunc_end23-test14

	.globl	test15
	.type	test15,@function
test15:
	.local  	i32, i32
	block   	
	block   	
	i32.const	$push0=, 1
	br_if   	0, $pop0
	i32.const	$0=, 0
.LBB24_2:
	block   	
	block   	
	loop    	
	i32.const	$push1=, 1
	br_if   	1, $pop1
	i32.const	$1=, 0
	i32.const	$push4=, -4
	i32.add 	$push3=, $0, $pop4
	tee_local	$push2=, $0=, $pop3
	br_if   	0, $pop2
	br      	2
.LBB24_4:
	end_loop
	end_block
	i32.const	$1=, 0
.LBB24_5:
	end_block
	i32.eqz 	$push5=, $1
	br_if   	1, $pop5
	call    	test15_callee0@FUNCTION
	return
.LBB24_7:
	end_block
	call    	test15_callee1@FUNCTION
.LBB24_8:
	end_block
	return
	.endfunc
.Lfunc_end24:
	.size	test15, .Lfunc_end24-test15


	.functype	something, void
	.functype	bar, void
	.functype	a, i32
	.functype	test15_callee0, void
	.functype	test15_callee1, void
