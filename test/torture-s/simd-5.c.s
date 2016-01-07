	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-5.c"
	.globl	func0
	.type	func0,@function
func0:                                  # @func0
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, dummy($pop0), $pop1
	return
.Lfunc_end0:
	.size	func0, .Lfunc_end0-func0

	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_u	$1=, q1+6($0)
	i32.load16_u	$2=, q1+4($0)
	i32.load16_u	$3=, q1+2($0)
	i32.load16_u	$4=, q1($0)
	i32.load16_u	$8=, q2($0)
	i32.load16_u	$7=, q2+2($0)
	i32.load16_u	$6=, q2+4($0)
	i32.load16_u	$5=, q2+6($0)
	i32.load16_u	$9=, q3+6($0)
	i32.load16_u	$10=, q3+4($0)
	i32.load16_u	$11=, q3+2($0)
	i32.load16_u	$12=, q3($0)
	i32.load16_u	$16=, q4($0)
	i32.load16_u	$15=, q4+2($0)
	i32.load16_u	$14=, q4+4($0)
	i32.load16_u	$13=, q4+6($0)
	call    	func0
	i32.mul 	$push3=, $5, $1
	i32.store16	$push8=, w1+6($0), $pop3
	i32.store16	$discard=, w3+6($0), $pop8
	i32.mul 	$push2=, $6, $2
	i32.store16	$push9=, w1+4($0), $pop2
	i32.store16	$discard=, w3+4($0), $pop9
	i32.mul 	$push1=, $7, $3
	i32.store16	$push10=, w1+2($0), $pop1
	i32.store16	$discard=, w3+2($0), $pop10
	i32.mul 	$push0=, $8, $4
	i32.store16	$push11=, w1($0), $pop0
	i32.store16	$discard=, w3($0), $pop11
	i32.mul 	$push7=, $13, $9
	i32.store16	$push12=, w2+6($0), $pop7
	i32.store16	$discard=, w4+6($0), $pop12
	i32.mul 	$push6=, $14, $10
	i32.store16	$push13=, w2+4($0), $pop6
	i32.store16	$discard=, w4+4($0), $pop13
	i32.mul 	$push5=, $15, $11
	i32.store16	$push14=, w2+2($0), $pop5
	i32.store16	$discard=, w4+2($0), $pop14
	i32.mul 	$push4=, $16, $12
	i32.store16	$push15=, w2($0), $pop4
	i32.store16	$discard=, w4($0), $pop15
	return
.Lfunc_end1:
	.size	func1, .Lfunc_end1-func1

	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_u	$1=, q1+6($0)
	i32.load16_u	$2=, q1+4($0)
	i32.load16_u	$3=, q1+2($0)
	i32.load16_u	$4=, q1($0)
	i32.load16_u	$8=, q2($0)
	i32.load16_u	$7=, q2+2($0)
	i32.load16_u	$6=, q2+4($0)
	i32.load16_u	$5=, q2+6($0)
	i32.load16_u	$9=, q3+6($0)
	i32.load16_u	$10=, q3+4($0)
	i32.load16_u	$11=, q3+2($0)
	i32.load16_u	$12=, q3($0)
	i32.load16_u	$16=, q4($0)
	i32.load16_u	$15=, q4+2($0)
	i32.load16_u	$14=, q4+4($0)
	i32.load16_u	$13=, q4+6($0)
	call    	func1
	i32.add 	$push3=, $5, $1
	i32.store16	$push8=, z1+6($0), $pop3
	i32.store16	$discard=, z3+6($0), $pop8
	i32.add 	$push2=, $6, $2
	i32.store16	$push9=, z1+4($0), $pop2
	i32.store16	$discard=, z3+4($0), $pop9
	i32.add 	$push1=, $7, $3
	i32.store16	$push10=, z1+2($0), $pop1
	i32.store16	$discard=, z3+2($0), $pop10
	i32.add 	$push0=, $8, $4
	i32.store16	$push11=, z1($0), $pop0
	i32.store16	$discard=, z3($0), $pop11
	i32.sub 	$push7=, $9, $13
	i32.store16	$push12=, z2+6($0), $pop7
	i32.store16	$discard=, z4+6($0), $pop12
	i32.sub 	$push6=, $10, $14
	i32.store16	$push13=, z2+4($0), $pop6
	i32.store16	$discard=, z4+4($0), $pop13
	i32.sub 	$push5=, $11, $15
	i32.store16	$push14=, z2+2($0), $pop5
	i32.store16	$discard=, z4+2($0), $pop14
	i32.sub 	$push4=, $12, $16
	i32.store16	$push15=, z2($0), $pop4
	i32.store16	$discard=, z4($0), $pop15
	return
.Lfunc_end2:
	.size	func2, .Lfunc_end2-func2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	call    	func2
	i32.const	$0=, 0
	block   	.LBB3_8
	i64.load	$push0=, w1($0)
	i64.load	$push1=, w3($0)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB3_8
# BB#1:                                 # %if.end
	block   	.LBB3_7
	i64.load	$push3=, w2($0)
	i64.load	$push4=, w4($0)
	i64.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB3_7
# BB#2:                                 # %if.end4
	block   	.LBB3_6
	i64.load	$push6=, z1($0)
	i64.load	$push7=, z3($0)
	i64.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, .LBB3_6
# BB#3:                                 # %if.end8
	block   	.LBB3_5
	i64.load	$push9=, z2($0)
	i64.load	$push10=, z4($0)
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, .LBB3_5
# BB#4:                                 # %if.end12
	return  	$0
.LBB3_5:                                  # %if.then11
	call    	abort
	unreachable
.LBB3_6:                                  # %if.then7
	call    	abort
	unreachable
.LBB3_7:                                  # %if.then3
	call    	abort
	unreachable
.LBB3_8:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	q1,@object              # @q1
	.data
	.globl	q1
	.align	3
q1:
	.int16	1                       # 0x1
	.int16	2                       # 0x2
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q1, 8

	.type	q2,@object              # @q2
	.globl	q2
	.align	3
q2:
	.int16	3                       # 0x3
	.int16	4                       # 0x4
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q2, 8

	.type	q3,@object              # @q3
	.globl	q3
	.align	3
q3:
	.int16	5                       # 0x5
	.int16	6                       # 0x6
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q3, 8

	.type	q4,@object              # @q4
	.globl	q4
	.align	3
q4:
	.int16	7                       # 0x7
	.int16	8                       # 0x8
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q4, 8

	.type	dummy,@object           # @dummy
	.bss
	.globl	dummy
	.align	2
dummy:
	.int32	0                       # 0x0
	.size	dummy, 4

	.type	w1,@object              # @w1
	.globl	w1
	.align	3
w1:
	.zero	8
	.size	w1, 8

	.type	w2,@object              # @w2
	.globl	w2
	.align	3
w2:
	.zero	8
	.size	w2, 8

	.type	w3,@object              # @w3
	.globl	w3
	.align	3
w3:
	.zero	8
	.size	w3, 8

	.type	w4,@object              # @w4
	.globl	w4
	.align	3
w4:
	.zero	8
	.size	w4, 8

	.type	z1,@object              # @z1
	.globl	z1
	.align	3
z1:
	.zero	8
	.size	z1, 8

	.type	z2,@object              # @z2
	.globl	z2
	.align	3
z2:
	.zero	8
	.size	z2, 8

	.type	z3,@object              # @z3
	.globl	z3
	.align	3
z3:
	.zero	8
	.size	z3, 8

	.type	z4,@object              # @z4
	.globl	z4
	.align	3
z4:
	.zero	8
	.size	z4, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
