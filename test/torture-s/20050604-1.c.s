	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	f32.load	$1=, v($pop0):p2align=4
	i32.const	$push33=, 0
	f32.load	$2=, v+4($pop33)
	i32.const	$push32=, 0
	f32.load	$3=, v+8($pop32):p2align=3
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	f32.load	$push6=, v+12($pop30)
	f32.const	$push7=, 0x0p0
	f32.add 	$push8=, $pop6, $pop7
	f32.const	$push29=, 0x0p0
	f32.add 	$push18=, $pop8, $pop29
	f32.store	$discard=, v+12($pop31), $pop18
	i32.const	$push28=, 0
	f32.const	$push9=, 0x1.6p4
	f32.add 	$push10=, $3, $pop9
	f32.const	$push27=, 0x1.6p4
	f32.add 	$push17=, $pop10, $pop27
	f32.store	$discard=, v+8($pop28):p2align=3, $pop17
	i32.const	$push26=, 0
	i32.load16_u	$0=, u($pop26):p2align=3
	i32.const	$push25=, 0
	f32.const	$push11=, 0x1.4p4
	f32.add 	$push12=, $2, $pop11
	f32.const	$push24=, 0x1.4p4
	f32.add 	$push16=, $pop12, $pop24
	f32.store	$discard=, v+4($pop25), $pop16
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load16_u	$push1=, u+2($pop22)
	i32.const	$push4=, 28
	i32.add 	$push5=, $pop1, $pop4
	i32.store16	$discard=, u+2($pop23), $pop5
	i32.const	$push21=, 0
	i32.const	$push2=, 24
	i32.add 	$push3=, $0, $pop2
	i32.store16	$discard=, u($pop21):p2align=3, $pop3
	i32.const	$push20=, 0
	f32.const	$push13=, 0x1.2p4
	f32.add 	$push14=, $1, $pop13
	f32.const	$push19=, 0x1.2p4
	f32.add 	$push15=, $pop14, $pop19
	f32.store	$discard=, v($pop20):p2align=4, $pop15
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	f32.load	$4=, v($pop6):p2align=4
	i32.const	$push52=, 0
	f32.load	$5=, v+4($pop52)
	i32.const	$push51=, 0
	f32.load	$6=, v+8($pop51):p2align=3
	i32.const	$push50=, 0
	f32.load	$7=, v+12($pop50)
	i32.const	$push49=, 0
	i32.load16_u	$2=, u($pop49):p2align=3
	i32.const	$push48=, 0
	i32.load16_u	$0=, u+6($pop48)
	i32.const	$push47=, 0
	i32.load16_u	$1=, u+4($pop47):p2align=2
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.load16_u	$push7=, u+2($pop45)
	i32.const	$push44=, 28
	i32.add 	$push4=, $pop7, $pop44
	i32.store16	$3=, u+2($pop46), $pop4
	i32.const	$push43=, 0
	i32.const	$push8=, 24
	i32.add 	$push9=, $2, $pop8
	i32.store16	$2=, u($pop43):p2align=3, $pop9
	i32.const	$push42=, 0
	f32.const	$push10=, 0x0p0
	f32.add 	$push11=, $7, $pop10
	f32.const	$push41=, 0x0p0
	f32.add 	$push3=, $pop11, $pop41
	f32.store	$7=, v+12($pop42), $pop3
	i32.const	$push40=, 0
	f32.const	$push12=, 0x1.6p4
	f32.add 	$push13=, $6, $pop12
	f32.const	$push39=, 0x1.6p4
	f32.add 	$push2=, $pop13, $pop39
	f32.store	$6=, v+8($pop40):p2align=3, $pop2
	i32.const	$push38=, 0
	f32.const	$push14=, 0x1.4p4
	f32.add 	$push15=, $5, $pop14
	f32.const	$push37=, 0x1.4p4
	f32.add 	$push1=, $pop15, $pop37
	f32.store	$5=, v+4($pop38), $pop1
	i32.const	$push36=, 0
	f32.const	$push16=, 0x1.2p4
	f32.add 	$push17=, $4, $pop16
	f32.const	$push35=, 0x1.2p4
	f32.add 	$push0=, $pop17, $pop35
	f32.store	$4=, v($pop36):p2align=4, $pop0
	block
	i32.const	$push34=, 65535
	i32.and 	$push18=, $2, $pop34
	i32.const	$push33=, 24
	i32.ne  	$push19=, $pop18, $pop33
	br_if   	0, $pop19       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push54=, 65535
	i32.and 	$push20=, $3, $pop54
	i32.const	$push53=, 28
	i32.ne  	$push21=, $pop20, $pop53
	br_if   	0, $pop21       # 0: down to label0
# BB#2:                                 # %entry
	i32.or  	$push5=, $0, $1
	i32.const	$push22=, 65535
	i32.and 	$push23=, $pop5, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#3:                                 # %if.end
	f32.const	$push24=, 0x1.2p5
	f32.ne  	$push25=, $4, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#4:                                 # %if.end
	f32.const	$push26=, 0x1.4p5
	f32.ne  	$push27=, $5, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %if.end
	f32.const	$push28=, 0x1.6p5
	f32.ne  	$push29=, $6, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end
	f32.const	$push30=, 0x0p0
	f32.ne  	$push31=, $7, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#7:                                 # %if.end26
	i32.const	$push32=, 0
	return  	$pop32
.LBB1_8:                                # %if.then25
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.bss.u,"aw",@nobits
	.globl	u
	.p2align	3
u:
	.skip	8
	.size	u, 8

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
	.p2align	4
v:
	.skip	16
	.size	v, 16


	.ident	"clang version 3.9.0 "
