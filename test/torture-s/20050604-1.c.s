	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push34=, 0
	i32.load16_u	$push1=, u+2($pop34)
	i32.const	$push2=, 28
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	$drop=, u+2($pop0), $pop3
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load16_u	$push4=, u($pop32)
	i32.const	$push5=, 24
	i32.add 	$push6=, $pop4, $pop5
	i32.store16	$drop=, u($pop33), $pop6
	i32.const	$push31=, 0
	f32.load	$0=, v($pop31)
	i32.const	$push30=, 0
	f32.load	$1=, v+4($pop30)
	i32.const	$push29=, 0
	f32.load	$2=, v+8($pop29)
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	f32.load	$push7=, v+12($pop27)
	f32.const	$push8=, 0x0p0
	f32.add 	$push9=, $pop7, $pop8
	f32.const	$push26=, 0x0p0
	f32.add 	$push10=, $pop9, $pop26
	f32.store	$drop=, v+12($pop28), $pop10
	i32.const	$push25=, 0
	f32.const	$push11=, 0x1.6p4
	f32.add 	$push12=, $2, $pop11
	f32.const	$push24=, 0x1.6p4
	f32.add 	$push13=, $pop12, $pop24
	f32.store	$drop=, v+8($pop25), $pop13
	i32.const	$push23=, 0
	f32.const	$push14=, 0x1.4p4
	f32.add 	$push15=, $1, $pop14
	f32.const	$push22=, 0x1.4p4
	f32.add 	$push16=, $pop15, $pop22
	f32.store	$drop=, v+4($pop23), $pop16
	i32.const	$push21=, 0
	f32.const	$push17=, 0x1.2p4
	f32.add 	$push18=, $0, $pop17
	f32.const	$push20=, 0x1.2p4
	f32.add 	$push19=, $pop18, $pop20
	f32.store	$drop=, v($pop21), $pop19
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, f32, i32, i32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push54=, 0
	i32.load16_u	$push7=, u+2($pop54)
	i32.const	$push53=, 28
	i32.add 	$push4=, $pop7, $pop53
	i32.store16	$0=, u+2($pop6), $pop4
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.load16_u	$push8=, u($pop51)
	i32.const	$push9=, 24
	i32.add 	$push10=, $pop8, $pop9
	i32.store16	$1=, u($pop52), $pop10
	i32.const	$push50=, 0
	i32.load16_u	$3=, u+6($pop50)
	i32.const	$push49=, 0
	i32.load16_u	$4=, u+4($pop49)
	i32.const	$push48=, 0
	f32.load	$5=, v($pop48)
	i32.const	$push47=, 0
	f32.load	$6=, v+4($pop47)
	i32.const	$push46=, 0
	f32.load	$7=, v+8($pop46)
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	f32.load	$push11=, v+12($pop44)
	f32.const	$push12=, 0x0p0
	f32.add 	$push13=, $pop11, $pop12
	f32.const	$push43=, 0x0p0
	f32.add 	$push3=, $pop13, $pop43
	f32.store	$2=, v+12($pop45), $pop3
	i32.const	$push42=, 0
	f32.const	$push14=, 0x1.6p4
	f32.add 	$push15=, $7, $pop14
	f32.const	$push41=, 0x1.6p4
	f32.add 	$push2=, $pop15, $pop41
	f32.store	$7=, v+8($pop42), $pop2
	i32.const	$push40=, 0
	f32.const	$push16=, 0x1.4p4
	f32.add 	$push17=, $6, $pop16
	f32.const	$push39=, 0x1.4p4
	f32.add 	$push1=, $pop17, $pop39
	f32.store	$6=, v+4($pop40), $pop1
	i32.const	$push38=, 0
	f32.const	$push18=, 0x1.2p4
	f32.add 	$push19=, $5, $pop18
	f32.const	$push37=, 0x1.2p4
	f32.add 	$push0=, $pop19, $pop37
	f32.store	$5=, v($pop38), $pop0
	block
	i32.const	$push36=, 65535
	i32.and 	$push20=, $1, $pop36
	i32.const	$push35=, 24
	i32.ne  	$push21=, $pop20, $pop35
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push56=, 65535
	i32.and 	$push22=, $0, $pop56
	i32.const	$push55=, 28
	i32.ne  	$push23=, $pop22, $pop55
	br_if   	0, $pop23       # 0: down to label0
# BB#2:                                 # %entry
	i32.or  	$push5=, $3, $4
	i32.const	$push24=, 65535
	i32.and 	$push25=, $pop5, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#3:                                 # %if.end
	f32.const	$push26=, 0x1.2p5
	f32.ne  	$push27=, $5, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#4:                                 # %if.end
	f32.const	$push28=, 0x1.4p5
	f32.ne  	$push29=, $6, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#5:                                 # %if.end
	f32.const	$push30=, 0x1.6p5
	f32.ne  	$push31=, $7, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#6:                                 # %if.end
	f32.const	$push32=, 0x0p0
	f32.ne  	$push33=, $2, $pop32
	br_if   	0, $pop33       # 0: down to label0
# BB#7:                                 # %if.end26
	i32.const	$push34=, 0
	return  	$pop34
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
	.functype	abort, void
