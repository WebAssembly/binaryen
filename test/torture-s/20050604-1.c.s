	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	f32.load	$4=, v($0)
	f32.load	$5=, v+4($0)
	f32.const	$10=, 0x1.2p4
	f32.const	$9=, 0x1.4p4
	f32.load	$6=, v+8($0)
	f32.const	$8=, 0x1.6p4
	f32.const	$7=, 0x0p0
	f32.load	$push5=, v+12($0)
	f32.add 	$push6=, $pop5, $7
	f32.add 	$push13=, $pop6, $7
	f32.store	$discard=, v+12($0), $pop13
	i32.load16_u	$3=, u($0)
	f32.add 	$push7=, $6, $8
	f32.add 	$push12=, $pop7, $8
	f32.store	$discard=, v+8($0), $pop12
	f32.add 	$push8=, $5, $9
	f32.add 	$push11=, $pop8, $9
	f32.store	$discard=, v+4($0), $pop11
	i32.load16_u	$2=, u+2($0)
	i32.load16_u	$1=, u+4($0)
	i32.load16_u	$push0=, u+6($0)
	i32.store16	$discard=, u+6($0), $pop0
	i32.store16	$discard=, u+4($0), $1
	i32.const	$push3=, 28
	i32.add 	$push4=, $2, $pop3
	i32.store16	$discard=, u+2($0), $pop4
	i32.const	$push1=, 24
	i32.add 	$push2=, $3, $pop1
	i32.store16	$discard=, u($0), $pop2
	f32.add 	$push9=, $4, $10
	f32.add 	$push10=, $pop9, $10
	f32.store	$discard=, v($0), $pop10
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	f32.load	$7=, v($0)
	f32.load	$8=, v+4($0)
	f32.const	$13=, 0x1.2p4
	f32.const	$12=, 0x1.4p4
	f32.load	$9=, v+8($0)
	i32.load16_u	$15=, u($0)
	f32.const	$11=, 0x1.6p4
	i32.const	$3=, 24
	i32.load16_u	$2=, u+2($0)
	i32.load16_u	$1=, u+4($0)
	i32.const	$4=, 28
	i32.load16_u	$push6=, u+6($0)
	i32.store16	$5=, u+6($0), $pop6
	i32.store16	$6=, u+4($0), $1
	i32.add 	$push4=, $2, $4
	i32.store16	$1=, u+2($0), $pop4
	i32.add 	$push7=, $15, $3
	i32.store16	$2=, u($0), $pop7
	i32.const	$15=, 65535
	f32.const	$10=, 0x0p0
	block   	.LBB1_9
	f32.load	$push8=, v+12($0)
	f32.add 	$push9=, $pop8, $10
	f32.add 	$push3=, $pop9, $10
	f32.store	$14=, v+12($0), $pop3
	f32.add 	$push10=, $9, $11
	f32.add 	$push2=, $pop10, $11
	f32.store	$11=, v+8($0), $pop2
	f32.add 	$push11=, $8, $12
	f32.add 	$push1=, $pop11, $12
	f32.store	$12=, v+4($0), $pop1
	f32.add 	$push12=, $7, $13
	f32.add 	$push0=, $pop12, $13
	f32.store	$13=, v($0), $pop0
	i32.and 	$push13=, $2, $15
	i32.ne  	$push14=, $pop13, $3
	br_if   	$pop14, .LBB1_9
# BB#1:                                 # %entry
	i32.and 	$push15=, $1, $15
	i32.ne  	$push16=, $pop15, $4
	br_if   	$pop16, .LBB1_9
# BB#2:                                 # %entry
	i32.or  	$push5=, $5, $6
	i32.and 	$push17=, $pop5, $15
	br_if   	$pop17, .LBB1_9
# BB#3:                                 # %if.end
	block   	.LBB1_8
	f32.const	$push18=, 0x1.2p5
	f32.ne  	$push19=, $13, $pop18
	br_if   	$pop19, .LBB1_8
# BB#4:                                 # %if.end
	f32.const	$push20=, 0x1.4p5
	f32.ne  	$push21=, $12, $pop20
	br_if   	$pop21, .LBB1_8
# BB#5:                                 # %if.end
	f32.const	$push22=, 0x1.6p5
	f32.ne  	$push23=, $11, $pop22
	br_if   	$pop23, .LBB1_8
# BB#6:                                 # %if.end
	f32.ne  	$push24=, $14, $10
	br_if   	$pop24, .LBB1_8
# BB#7:                                 # %if.end26
	return  	$0
.LBB1_8:                                # %if.then25
	call    	abort
	unreachable
.LBB1_9:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
	.align	3
u:
	.skip	8
	.size	u, 8

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.align	4
v:
	.skip	16
	.size	v, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
