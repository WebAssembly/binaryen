	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-5.c"
	.section	.text.func0,"ax",@progbits
	.hidden	func0
	.globl	func0
	.type	func0,@function
func0:                                  # @func0
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 1
	i32.store	$discard=, dummy($pop0), $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	func0, .Lfunc_end0-func0

	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$0=, q1+4($pop0):p2align=2
	i32.const	$push41=, 0
	i32.load16_u	$1=, q1+2($pop41)
	i32.const	$push40=, 0
	i32.load16_u	$2=, q1($pop40):p2align=3
	i32.const	$push39=, 0
	i32.load16_u	$5=, q2($pop39):p2align=3
	i32.const	$push38=, 0
	i32.load16_u	$4=, q2+2($pop38)
	i32.const	$push37=, 0
	i32.load16_u	$3=, q2+4($pop37):p2align=2
	i32.const	$push36=, 0
	i32.load16_u	$6=, q3+6($pop36)
	i32.const	$push35=, 0
	i32.load16_u	$7=, q3+4($pop35):p2align=2
	i32.const	$push34=, 0
	i32.load16_u	$8=, q3+2($pop34)
	i32.const	$push33=, 0
	i32.load16_u	$9=, q3($pop33):p2align=3
	i32.const	$push32=, 0
	i32.load16_u	$13=, q4($pop32):p2align=3
	i32.const	$push31=, 0
	i32.load16_u	$12=, q4+2($pop31)
	i32.const	$push30=, 0
	i32.load16_u	$11=, q4+4($pop30):p2align=2
	i32.const	$push29=, 0
	i32.load16_u	$10=, q4+6($pop29)
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load16_u	$push2=, q2+6($pop27)
	i32.const	$push26=, 0
	i32.load16_u	$push1=, q1+6($pop26)
	i32.mul 	$push6=, $pop2, $pop1
	i32.store16	$14=, w1+6($pop28), $pop6
	i32.const	$push25=, 0
	i32.mul 	$push5=, $3, $0
	i32.store16	$0=, w1+4($pop25):p2align=2, $pop5
	i32.const	$push24=, 0
	i32.mul 	$push4=, $4, $1
	i32.store16	$1=, w1+2($pop24), $pop4
	i32.const	$push23=, 0
	i32.mul 	$push3=, $5, $2
	i32.store16	$2=, w1($pop23):p2align=3, $pop3
	i32.const	$push22=, 0
	i32.mul 	$push10=, $10, $6
	i32.store16	$5=, w2+6($pop22), $pop10
	i32.const	$push21=, 0
	i32.mul 	$push9=, $11, $7
	i32.store16	$4=, w2+4($pop21):p2align=2, $pop9
	i32.const	$push20=, 0
	i32.mul 	$push8=, $12, $8
	i32.store16	$3=, w2+2($pop20), $pop8
	i32.const	$push19=, 0
	i32.mul 	$push7=, $13, $9
	i32.store16	$6=, w2($pop19):p2align=3, $pop7
	call    	func0@FUNCTION
	i32.const	$push18=, 0
	i32.store16	$discard=, w3+6($pop18), $14
	i32.const	$push17=, 0
	i32.store16	$discard=, w3+4($pop17):p2align=2, $0
	i32.const	$push16=, 0
	i32.store16	$discard=, w3+2($pop16), $1
	i32.const	$push15=, 0
	i32.store16	$discard=, w3($pop15):p2align=3, $2
	i32.const	$push14=, 0
	i32.store16	$discard=, w4+6($pop14), $5
	i32.const	$push13=, 0
	i32.store16	$discard=, w4+4($pop13):p2align=2, $4
	i32.const	$push12=, 0
	i32.store16	$discard=, w4+2($pop12), $3
	i32.const	$push11=, 0
	i32.store16	$discard=, w4($pop11):p2align=3, $6
	return
	.endfunc
.Lfunc_end1:
	.size	func1, .Lfunc_end1-func1

	.section	.text.func2,"ax",@progbits
	.hidden	func2
	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$0=, q1+4($pop0):p2align=2
	i32.const	$push41=, 0
	i32.load16_u	$1=, q1+2($pop41)
	i32.const	$push40=, 0
	i32.load16_u	$2=, q1($pop40):p2align=3
	i32.const	$push39=, 0
	i32.load16_u	$5=, q2($pop39):p2align=3
	i32.const	$push38=, 0
	i32.load16_u	$4=, q2+2($pop38)
	i32.const	$push37=, 0
	i32.load16_u	$3=, q2+4($pop37):p2align=2
	i32.const	$push36=, 0
	i32.load16_u	$6=, q3+6($pop36)
	i32.const	$push35=, 0
	i32.load16_u	$7=, q3+4($pop35):p2align=2
	i32.const	$push34=, 0
	i32.load16_u	$8=, q3+2($pop34)
	i32.const	$push33=, 0
	i32.load16_u	$9=, q3($pop33):p2align=3
	i32.const	$push32=, 0
	i32.load16_u	$13=, q4($pop32):p2align=3
	i32.const	$push31=, 0
	i32.load16_u	$12=, q4+2($pop31)
	i32.const	$push30=, 0
	i32.load16_u	$11=, q4+4($pop30):p2align=2
	i32.const	$push29=, 0
	i32.load16_u	$10=, q4+6($pop29)
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.load16_u	$push2=, q2+6($pop27)
	i32.const	$push26=, 0
	i32.load16_u	$push1=, q1+6($pop26)
	i32.add 	$push6=, $pop2, $pop1
	i32.store16	$14=, z1+6($pop28), $pop6
	i32.const	$push25=, 0
	i32.add 	$push5=, $3, $0
	i32.store16	$0=, z1+4($pop25):p2align=2, $pop5
	i32.const	$push24=, 0
	i32.add 	$push4=, $4, $1
	i32.store16	$1=, z1+2($pop24), $pop4
	i32.const	$push23=, 0
	i32.add 	$push3=, $5, $2
	i32.store16	$2=, z1($pop23):p2align=3, $pop3
	i32.const	$push22=, 0
	i32.sub 	$push10=, $6, $10
	i32.store16	$5=, z2+6($pop22), $pop10
	i32.const	$push21=, 0
	i32.sub 	$push9=, $7, $11
	i32.store16	$4=, z2+4($pop21):p2align=2, $pop9
	i32.const	$push20=, 0
	i32.sub 	$push8=, $8, $12
	i32.store16	$3=, z2+2($pop20), $pop8
	i32.const	$push19=, 0
	i32.sub 	$push7=, $9, $13
	i32.store16	$6=, z2($pop19):p2align=3, $pop7
	call    	func1@FUNCTION
	i32.const	$push18=, 0
	i32.store16	$discard=, z3+6($pop18), $14
	i32.const	$push17=, 0
	i32.store16	$discard=, z3+4($pop17):p2align=2, $0
	i32.const	$push16=, 0
	i32.store16	$discard=, z3+2($pop16), $1
	i32.const	$push15=, 0
	i32.store16	$discard=, z3($pop15):p2align=3, $2
	i32.const	$push14=, 0
	i32.store16	$discard=, z4+6($pop14), $5
	i32.const	$push13=, 0
	i32.store16	$discard=, z4+4($pop13):p2align=2, $4
	i32.const	$push12=, 0
	i32.store16	$discard=, z4+2($pop12), $3
	i32.const	$push11=, 0
	i32.store16	$discard=, z4($pop11):p2align=3, $6
	return
	.endfunc
.Lfunc_end2:
	.size	func2, .Lfunc_end2-func2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	func2@FUNCTION
	block
	block
	block
	block
	i32.const	$push14=, 0
	i64.load	$push0=, w1($pop14)
	i32.const	$push13=, 0
	i64.load	$push1=, w3($pop13)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %if.end
	i32.const	$push16=, 0
	i64.load	$push3=, w2($pop16)
	i32.const	$push15=, 0
	i64.load	$push4=, w4($pop15)
	i64.ne  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label2
# BB#2:                                 # %if.end4
	i32.const	$push18=, 0
	i64.load	$push6=, z1($pop18)
	i32.const	$push17=, 0
	i64.load	$push7=, z3($pop17)
	i64.ne  	$push8=, $pop6, $pop7
	br_if   	2, $pop8        # 2: down to label1
# BB#3:                                 # %if.end8
	i32.const	$push20=, 0
	i64.load	$push9=, z2($pop20)
	i32.const	$push19=, 0
	i64.load	$push10=, z4($pop19)
	i64.ne  	$push11=, $pop9, $pop10
	br_if   	3, $pop11       # 3: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push12=, 0
	return  	$pop12
.LBB3_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB3_6:                                # %if.then3
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB3_7:                                # %if.then7
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB3_8:                                # %if.then11
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	q1                      # @q1
	.type	q1,@object
	.section	.data.q1,"aw",@progbits
	.globl	q1
	.p2align	3
q1:
	.int16	1                       # 0x1
	.int16	2                       # 0x2
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q1, 8

	.hidden	q2                      # @q2
	.type	q2,@object
	.section	.data.q2,"aw",@progbits
	.globl	q2
	.p2align	3
q2:
	.int16	3                       # 0x3
	.int16	4                       # 0x4
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q2, 8

	.hidden	q3                      # @q3
	.type	q3,@object
	.section	.data.q3,"aw",@progbits
	.globl	q3
	.p2align	3
q3:
	.int16	5                       # 0x5
	.int16	6                       # 0x6
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q3, 8

	.hidden	q4                      # @q4
	.type	q4,@object
	.section	.data.q4,"aw",@progbits
	.globl	q4
	.p2align	3
q4:
	.int16	7                       # 0x7
	.int16	8                       # 0x8
	.int16	0                       # 0x0
	.int16	0                       # 0x0
	.size	q4, 8

	.hidden	dummy                   # @dummy
	.type	dummy,@object
	.section	.bss.dummy,"aw",@nobits
	.globl	dummy
	.p2align	2
dummy:
	.int32	0                       # 0x0
	.size	dummy, 4

	.hidden	w1                      # @w1
	.type	w1,@object
	.section	.bss.w1,"aw",@nobits
	.globl	w1
	.p2align	3
w1:
	.skip	8
	.size	w1, 8

	.hidden	w2                      # @w2
	.type	w2,@object
	.section	.bss.w2,"aw",@nobits
	.globl	w2
	.p2align	3
w2:
	.skip	8
	.size	w2, 8

	.hidden	w3                      # @w3
	.type	w3,@object
	.section	.bss.w3,"aw",@nobits
	.globl	w3
	.p2align	3
w3:
	.skip	8
	.size	w3, 8

	.hidden	w4                      # @w4
	.type	w4,@object
	.section	.bss.w4,"aw",@nobits
	.globl	w4
	.p2align	3
w4:
	.skip	8
	.size	w4, 8

	.hidden	z1                      # @z1
	.type	z1,@object
	.section	.bss.z1,"aw",@nobits
	.globl	z1
	.p2align	3
z1:
	.skip	8
	.size	z1, 8

	.hidden	z2                      # @z2
	.type	z2,@object
	.section	.bss.z2,"aw",@nobits
	.globl	z2
	.p2align	3
z2:
	.skip	8
	.size	z2, 8

	.hidden	z3                      # @z3
	.type	z3,@object
	.section	.bss.z3,"aw",@nobits
	.globl	z3
	.p2align	3
z3:
	.skip	8
	.size	z3, 8

	.hidden	z4                      # @z4
	.type	z4,@object
	.section	.bss.z4,"aw",@nobits
	.globl	z4
	.p2align	3
z4:
	.skip	8
	.size	z4, 8


	.ident	"clang version 3.9.0 "
