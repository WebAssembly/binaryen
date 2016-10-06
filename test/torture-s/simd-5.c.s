	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-5.c"
	.section	.text.func0,"ax",@progbits
	.hidden	func0
	.globl	func0
	.type	func0,@function
func0:                                  # @func0
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.store	dummy($pop1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	func0, .Lfunc_end0-func0

	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push63=, 0
	i32.load16_u	$push2=, q2+6($pop63)
	i32.const	$push62=, 0
	i32.load16_u	$push1=, q1+6($pop62)
	i32.mul 	$push61=, $pop2, $pop1
	tee_local	$push60=, $0=, $pop61
	i32.store16	w1+6($pop0), $pop60
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.load16_u	$push4=, q2+4($pop58)
	i32.const	$push57=, 0
	i32.load16_u	$push3=, q1+4($pop57)
	i32.mul 	$push56=, $pop4, $pop3
	tee_local	$push55=, $1=, $pop56
	i32.store16	w1+4($pop59), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i32.load16_u	$push6=, q2+2($pop53)
	i32.const	$push52=, 0
	i32.load16_u	$push5=, q1+2($pop52)
	i32.mul 	$push51=, $pop6, $pop5
	tee_local	$push50=, $2=, $pop51
	i32.store16	w1+2($pop54), $pop50
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load16_u	$push8=, q2($pop48)
	i32.const	$push47=, 0
	i32.load16_u	$push7=, q1($pop47)
	i32.mul 	$push46=, $pop8, $pop7
	tee_local	$push45=, $3=, $pop46
	i32.store16	w1($pop49), $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.load16_u	$push10=, q4+6($pop43)
	i32.const	$push42=, 0
	i32.load16_u	$push9=, q3+6($pop42)
	i32.mul 	$push41=, $pop10, $pop9
	tee_local	$push40=, $4=, $pop41
	i32.store16	w2+6($pop44), $pop40
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load16_u	$push12=, q4+4($pop38)
	i32.const	$push37=, 0
	i32.load16_u	$push11=, q3+4($pop37)
	i32.mul 	$push36=, $pop12, $pop11
	tee_local	$push35=, $5=, $pop36
	i32.store16	w2+4($pop39), $pop35
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.load16_u	$push14=, q4+2($pop33)
	i32.const	$push32=, 0
	i32.load16_u	$push13=, q3+2($pop32)
	i32.mul 	$push31=, $pop14, $pop13
	tee_local	$push30=, $6=, $pop31
	i32.store16	w2+2($pop34), $pop30
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load16_u	$push16=, q4($pop28)
	i32.const	$push27=, 0
	i32.load16_u	$push15=, q3($pop27)
	i32.mul 	$push26=, $pop16, $pop15
	tee_local	$push25=, $7=, $pop26
	i32.store16	w2($pop29), $pop25
	call    	func0@FUNCTION
	i32.const	$push24=, 0
	i32.store16	w4+6($pop24), $4
	i32.const	$push23=, 0
	i32.store16	w4+4($pop23), $5
	i32.const	$push22=, 0
	i32.store16	w4+2($pop22), $6
	i32.const	$push21=, 0
	i32.store16	w4($pop21), $7
	i32.const	$push20=, 0
	i32.store16	w3+6($pop20), $0
	i32.const	$push19=, 0
	i32.store16	w3+4($pop19), $1
	i32.const	$push18=, 0
	i32.store16	w3+2($pop18), $2
	i32.const	$push17=, 0
	i32.store16	w3($pop17), $3
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	func1, .Lfunc_end1-func1

	.section	.text.func2,"ax",@progbits
	.hidden	func2
	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push63=, 0
	i32.load16_u	$push2=, q2+6($pop63)
	i32.const	$push62=, 0
	i32.load16_u	$push1=, q1+6($pop62)
	i32.add 	$push61=, $pop2, $pop1
	tee_local	$push60=, $0=, $pop61
	i32.store16	z1+6($pop0), $pop60
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.load16_u	$push4=, q2+4($pop58)
	i32.const	$push57=, 0
	i32.load16_u	$push3=, q1+4($pop57)
	i32.add 	$push56=, $pop4, $pop3
	tee_local	$push55=, $1=, $pop56
	i32.store16	z1+4($pop59), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i32.load16_u	$push6=, q2+2($pop53)
	i32.const	$push52=, 0
	i32.load16_u	$push5=, q1+2($pop52)
	i32.add 	$push51=, $pop6, $pop5
	tee_local	$push50=, $2=, $pop51
	i32.store16	z1+2($pop54), $pop50
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.load16_u	$push8=, q2($pop48)
	i32.const	$push47=, 0
	i32.load16_u	$push7=, q1($pop47)
	i32.add 	$push46=, $pop8, $pop7
	tee_local	$push45=, $3=, $pop46
	i32.store16	z1($pop49), $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.load16_u	$push10=, q3+6($pop43)
	i32.const	$push42=, 0
	i32.load16_u	$push9=, q4+6($pop42)
	i32.sub 	$push41=, $pop10, $pop9
	tee_local	$push40=, $4=, $pop41
	i32.store16	z2+6($pop44), $pop40
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load16_u	$push12=, q3+4($pop38)
	i32.const	$push37=, 0
	i32.load16_u	$push11=, q4+4($pop37)
	i32.sub 	$push36=, $pop12, $pop11
	tee_local	$push35=, $5=, $pop36
	i32.store16	z2+4($pop39), $pop35
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.load16_u	$push14=, q3+2($pop33)
	i32.const	$push32=, 0
	i32.load16_u	$push13=, q4+2($pop32)
	i32.sub 	$push31=, $pop14, $pop13
	tee_local	$push30=, $6=, $pop31
	i32.store16	z2+2($pop34), $pop30
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load16_u	$push16=, q3($pop28)
	i32.const	$push27=, 0
	i32.load16_u	$push15=, q4($pop27)
	i32.sub 	$push26=, $pop16, $pop15
	tee_local	$push25=, $7=, $pop26
	i32.store16	z2($pop29), $pop25
	call    	func1@FUNCTION
	i32.const	$push24=, 0
	i32.store16	z4+6($pop24), $4
	i32.const	$push23=, 0
	i32.store16	z4+4($pop23), $5
	i32.const	$push22=, 0
	i32.store16	z4+2($pop22), $6
	i32.const	$push21=, 0
	i32.store16	z4($pop21), $7
	i32.const	$push20=, 0
	i32.store16	z3+6($pop20), $0
	i32.const	$push19=, 0
	i32.store16	z3+4($pop19), $1
	i32.const	$push18=, 0
	i32.store16	z3+2($pop18), $2
	i32.const	$push17=, 0
	i32.store16	z3($pop17), $3
                                        # fallthrough-return
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
	i32.const	$push14=, 0
	i64.load	$push1=, w1($pop14)
	i32.const	$push13=, 0
	i64.load	$push0=, w3($pop13)
	i64.ne  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push16=, 0
	i64.load	$push4=, w2($pop16)
	i32.const	$push15=, 0
	i64.load	$push3=, w4($pop15)
	i64.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %if.end4
	i32.const	$push18=, 0
	i64.load	$push7=, z1($pop18)
	i32.const	$push17=, 0
	i64.load	$push6=, z3($pop17)
	i64.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %if.end8
	i32.const	$push20=, 0
	i64.load	$push10=, z2($pop20)
	i32.const	$push19=, 0
	i64.load	$push9=, z4($pop19)
	i64.ne  	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push12=, 0
	return  	$pop12
.LBB3_5:                                # %if.then11
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
