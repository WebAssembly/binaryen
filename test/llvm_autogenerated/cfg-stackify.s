	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/cfg-stackify.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
BB0_1:
	loop    	BB0_3
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, BB0_3
	call    	something
	br      	BB0_1
BB0_3:
	return
func_end0:
	.size	test0, func_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
BB1_1:
	loop    	BB1_3
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, BB1_3
	call    	something
	br      	BB1_1
BB1_3:
	return
func_end1:
	.size	test1, func_end1-test1

	.globl	test2
	.type	test2,@function
test2:
	.param  	i32, i32
	block   	BB2_2
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	br_if   	$pop1, BB2_2
BB2_1:
	loop    	BB2_2
	i32.const	$push5=, -1
	i32.add 	$1=, $1, $pop5
	f64.load	$push2=, 0($0)
	f64.const	$push3=, 0x1.999999999999ap1
	f64.mul 	$push4=, $pop2, $pop3
	f64.store	$discard=, 0($0), $pop4
	i32.const	$push6=, 8
	i32.add 	$0=, $0, $pop6
	br_if   	$1, BB2_1
BB2_2:
	return
func_end2:
	.size	test2, func_end2-test2

	.globl	doublediamond
	.type	doublediamond,@function
doublediamond:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block   	BB3_5
	block   	BB3_2
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, BB3_2
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	BB3_5
BB3_2:
	block   	BB3_4
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, BB3_4
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	BB3_5
BB3_4:
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
BB3_5:
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	return  	$3
func_end3:
	.size	doublediamond, func_end3-doublediamond

	.globl	triangle
	.type	triangle,@function
triangle:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	block   	BB4_2
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	br_if   	$1, BB4_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
BB4_2:
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
func_end4:
	.size	triangle, func_end4-triangle

	.globl	diamond
	.type	diamond,@function
diamond:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	block   	BB5_3
	block   	BB5_2
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	br_if   	$1, BB5_2
	i32.const	$push2=, 1
	i32.store	$discard=, 0($0), $pop2
	br      	BB5_3
BB5_2:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($0), $pop1
BB5_3:
	i32.const	$push3=, 3
	i32.store	$discard=, 0($0), $pop3
	return  	$2
func_end5:
	.size	diamond, func_end5-diamond

	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
func_end6:
	.size	single_block, func_end6-single_block

	.globl	minimal_loop
	.type	minimal_loop,@function
minimal_loop:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
BB7_1:
	loop    	BB7_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	br      	BB7_1
BB7_2:
func_end7:
	.size	minimal_loop, func_end7-minimal_loop

	.globl	simple_loop
	.type	simple_loop,@function
simple_loop:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
BB8_1:
	loop    	BB8_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, BB8_1
BB8_2:
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
func_end8:
	.size	simple_loop, func_end8-simple_loop

	.globl	doubletriangle
	.type	doubletriangle,@function
doubletriangle:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block   	BB9_4
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, BB9_4
	block   	BB9_3
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, BB9_3
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
BB9_3:
	i32.const	$push3=, 4
	i32.store	$discard=, 0($2), $pop3
BB9_4:
	i32.const	$push4=, 5
	i32.store	$discard=, 0($2), $pop4
	return  	$3
func_end9:
	.size	doubletriangle, func_end9-doubletriangle

	.globl	ifelse_earlyexits
	.type	ifelse_earlyexits,@function
ifelse_earlyexits:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	block   	BB10_4
	block   	BB10_2
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	br_if   	$0, BB10_2
	i32.const	$push3=, 1
	i32.store	$discard=, 0($2), $pop3
	br      	BB10_4
BB10_2:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, BB10_4
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
BB10_4:
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	return  	$3
func_end10:
	.size	ifelse_earlyexits, func_end10-ifelse_earlyexits

	.globl	doublediamond_in_a_loop
	.type	doublediamond_in_a_loop,@function
doublediamond_in_a_loop:
	.param  	i32, i32, i32
	.result 	i32
BB11_1:
	loop    	BB11_7
	block   	BB11_6
	block   	BB11_3
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	br_if   	$0, BB11_3
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	BB11_6
BB11_3:
	block   	BB11_5
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, BB11_5
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	BB11_6
BB11_5:
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
BB11_6:
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	br      	BB11_1
BB11_7:
func_end11:
	.size	doublediamond_in_a_loop, func_end11-doublediamond_in_a_loop

	.globl	test3
	.type	test3,@function
test3:
	.param  	i32
	block   	BB12_5
	i32.const	$push0=, 0
	br_if   	$pop0, BB12_5
BB12_1:
	loop    	BB12_4
	br_if   	$0, BB12_4
BB12_2:
	loop    	BB12_3
	i32.ne  	$push1=, $0, $0
	br_if   	$pop1, BB12_2
BB12_3:
	call    	bar
	br      	BB12_1
BB12_4:
	unreachable
BB12_5:
	return
func_end12:
	.size	test3, func_end12-test3

	.globl	test4
	.type	test4,@function
test4:
	.param  	i32
	block   	BB13_8
	block   	BB13_7
	block   	BB13_4
	i32.const	$push0=, 3
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB13_4
	block   	BB13_3
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, BB13_3
	i32.const	$push6=, 2
	i32.ne  	$push7=, $0, $pop6
	br_if   	$pop7, BB13_7
BB13_3:
	return
BB13_4:
	i32.const	$push2=, 4
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, BB13_8
	i32.const	$push4=, 622
	i32.ne  	$push5=, $0, $pop4
	br_if   	$pop5, BB13_7
	return
BB13_7:
	return
BB13_8:
	return
func_end13:
	.size	test4, func_end13-test4

	.globl	test5
	.type	test5,@function
test5:
	.param  	i32, i32
	.local  	i32, i32
BB14_1:
	block   	BB14_4
	loop    	BB14_3
	i32.const	$2=, 0
	i32.store	$3=, 0($2), $2
	i32.const	$2=, 1
	i32.and 	$push0=, $0, $2
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop0, $pop5
	br_if   	$pop6, BB14_4
	i32.store	$push2=, 0($3), $2
	i32.and 	$push3=, $1, $pop2
	br_if   	$pop3, BB14_1
BB14_3:
	i32.const	$push4=, 3
	i32.store	$discard=, 0($3), $pop4
	return
BB14_4:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($3), $pop1
	return
func_end14:
	.size	test5, func_end14-test5

	.globl	test6
	.type	test6,@function
test6:
	.param  	i32, i32
	.local  	i32, i32, i32
BB15_1:
	block   	BB15_6
	block   	BB15_5
	loop    	BB15_4
	i32.const	$2=, 0
	i32.store	$discard=, 0($2), $2
	i32.const	$3=, 1
	i32.and 	$push0=, $0, $3
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop0, $pop4
	br_if   	$pop5, BB15_6
	i32.store	$discard=, 0($2), $3
	i32.and 	$4=, $1, $3
	i32.const	$push6=, 0
	i32.eq  	$push7=, $4, $pop6
	br_if   	$pop7, BB15_5
	i32.store	$discard=, 0($2), $3
	br_if   	$4, BB15_1
BB15_4:
	i32.const	$push3=, 2
	i32.store	$discard=, 0($2), $pop3
	return
BB15_5:
	i32.const	$push1=, 3
	i32.store	$discard=, 0($2), $pop1
BB15_6:
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
	return
func_end15:
	.size	test6, func_end15-test6

	.globl	test7
	.type	test7,@function
test7:
	.param  	i32, i32
	.local  	i32, i32
	i32.const	$3=, 0
	i32.store	$2=, 0($3), $3
BB16_1:
	loop    	BB16_5
	block   	BB16_4
	i32.const	$push0=, 1
	i32.store	$3=, 0($2), $pop0
	i32.and 	$push1=, $0, $3
	br_if   	$pop1, BB16_4
	i32.const	$push2=, 2
	i32.store	$discard=, 0($2), $pop2
	i32.and 	$push3=, $1, $3
	br_if   	$pop3, BB16_1
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	unreachable
BB16_4:
	i32.const	$push5=, 3
	i32.store	$discard=, 0($2), $pop5
	i32.and 	$push6=, $1, $3
	br_if   	$pop6, BB16_1
BB16_5:
	i32.const	$push7=, 5
	i32.store	$discard=, 0($2), $pop7
	unreachable
func_end16:
	.size	test7, func_end16-test7

	.globl	test8
	.type	test8,@function
test8:
	.result 	i32
	.local  	i32
	i32.const	$0=, 0
BB17_1:
	loop    	BB17_4
	block   	BB17_3
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, BB17_3
	i32.const	$push2=, 0
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, BB17_1
BB17_3:
	loop    	BB17_4
	br_if   	$0, BB17_3
	br      	BB17_1
BB17_4:
func_end17:
	.size	test8, func_end17-test8

	.globl	test9
	.type	test9,@function
test9:
	.local  	i32, i32
	i32.const	$1=, 0
	i32.store	$0=, 0($1), $1
BB18_1:
	loop    	BB18_5
	i32.const	$push0=, 1
	i32.store	$1=, 0($0), $pop0
	i32.call	$push1=, a
	i32.and 	$push2=, $pop1, $1
	i32.const	$push13=, 0
	i32.eq  	$push14=, $pop2, $pop13
	br_if   	$pop14, BB18_5
BB18_2:
	loop    	BB18_5
	block   	BB18_4
	i32.const	$push4=, 2
	i32.store	$discard=, 0($0), $pop4
	i32.call	$push5=, a
	i32.and 	$push6=, $pop5, $1
	i32.const	$push15=, 0
	i32.eq  	$push16=, $pop6, $pop15
	br_if   	$pop16, BB18_4
	i32.const	$push10=, 3
	i32.store	$discard=, 0($0), $pop10
	i32.call	$push11=, a
	i32.and 	$push12=, $pop11, $1
	br_if   	$pop12, BB18_2
	br      	BB18_1
BB18_4:
	i32.const	$push7=, 4
	i32.store	$discard=, 0($0), $pop7
	i32.call	$push8=, a
	i32.and 	$push9=, $pop8, $1
	br_if   	$pop9, BB18_2
	br      	BB18_1
BB18_5:
	i32.const	$push3=, 5
	i32.store	$discard=, 0($0), $pop3
	return
func_end18:
	.size	test9, func_end18-test9

	.globl	test10
	.type	test10,@function
test10:
	.local  	i32, i32, i32, i32, i32
	i32.const	$0=, 2
BB19_1:
	loop    	BB19_7
	copy_local	$4=, $1
	copy_local	$3=, $0
	i32.const	$1=, 0
	i32.const	$0=, 3
	i32.const	$2=, 4
	br_if   	$4, BB19_1
BB19_2:
	block   	BB19_6
	loop    	BB19_5
	copy_local	$4=, $3
	copy_local	$3=, $2
BB19_3:
	loop    	BB19_5
	copy_local	$2=, $4
	i32.const	$push0=, 4
	i32.gt_u	$push1=, $2, $pop0
	br_if   	$pop1, BB19_1
	copy_local	$4=, $3
	tableswitch	$2, BB19_3, BB19_3, BB19_5, BB19_1, BB19_2, BB19_6
BB19_5:
	return
BB19_6:
	i32.const	$1=, 1
	br      	BB19_1
BB19_7:
func_end19:
	.size	test10, func_end19-test10

	.globl	test11
	.type	test11,@function
test11:
	.local  	i32
	i32.const	$0=, 0
	i32.store	$discard=, 0($0), $0
	block   	BB20_8
	block   	BB20_7
	block   	BB20_6
	block   	BB20_4
	br_if   	$0, BB20_4
	block   	BB20_3
	i32.const	$push4=, 1
	i32.store	$discard=, 0($0), $pop4
	br_if   	$0, BB20_3
	i32.const	$push5=, 2
	i32.store	$discard=, 0($0), $pop5
	br_if   	$0, BB20_6
BB20_3:
	i32.const	$push7=, 3
	i32.store	$discard=, 0($0), $pop7
	return
BB20_4:
	i32.const	$push0=, 4
	i32.store	$discard=, 0($0), $pop0
	br_if   	$0, BB20_8
	i32.const	$push1=, 5
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push8=, 0
	i32.eq  	$push9=, $0, $pop8
	br_if   	$pop9, BB20_7
BB20_6:
	i32.const	$push6=, 7
	i32.store	$discard=, 0($0), $pop6
	return
BB20_7:
	i32.const	$push2=, 6
	i32.store	$discard=, 0($0), $pop2
	return
BB20_8:
	i32.const	$push3=, 8
	i32.store	$discard=, 0($0), $pop3
	return
func_end20:
	.size	test11, func_end20-test11

	.globl	test12
	.type	test12,@function
test12:
	.param  	i32
	.local  	i32
BB21_1:
	loop    	BB21_8
	i32.load8_u	$1=, 0($0)
	block   	BB21_7
	block   	BB21_6
	block   	BB21_4
	i32.const	$push0=, 103
	i32.gt_s	$push1=, $1, $pop0
	br_if   	$pop1, BB21_4
	i32.const	$push6=, 42
	i32.eq  	$push7=, $1, $pop6
	br_if   	$pop7, BB21_7
	i32.const	$push8=, 76
	i32.eq  	$push9=, $1, $pop8
	br_if   	$pop9, BB21_7
	br      	BB21_6
BB21_4:
	i32.const	$push2=, 108
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB21_7
	i32.const	$push4=, 104
	i32.eq  	$push5=, $1, $pop4
	br_if   	$pop5, BB21_7
BB21_6:
	return
BB21_7:
	i32.const	$push10=, 1
	i32.add 	$0=, $0, $pop10
	br      	BB21_1
BB21_8:
func_end21:
	.size	test12, func_end21-test12

	.globl	test13
	.type	test13,@function
test13:
	.local  	i32
	block   	BB22_2
	i32.const	$push0=, 0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop0, $pop3
	br_if   	$pop4, BB22_2
	return
BB22_2:
	i32.const	$0=, 0
	block   	BB22_4
	br_if   	$0, BB22_4
	i32.const	$0=, 0
BB22_4:
	block   	BB22_5
	i32.const	$push1=, 1
	i32.and 	$push2=, $0, $pop1
	i32.const	$push5=, 0
	i32.eq  	$push6=, $pop2, $pop5
	br_if   	$pop6, BB22_5
BB22_5:
	unreachable
func_end22:
	.size	test13, func_end22-test13


	.section	".note.GNU-stack","",@progbits
