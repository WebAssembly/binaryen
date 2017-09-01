	.text
	.file	"20050604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push37=, 0
	i32.load16_u	$push1=, u+2($pop37)
	i32.const	$push2=, 28
	i32.add 	$push3=, $pop1, $pop2
	i32.store16	u+2($pop0), $pop3
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.load16_u	$push4=, u($pop35)
	i32.const	$push5=, 24
	i32.add 	$push6=, $pop4, $pop5
	i32.store16	u($pop36), $pop6
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	f32.load	$push7=, v+12($pop33)
	f32.const	$push8=, 0x0p0
	f32.add 	$push9=, $pop7, $pop8
	f32.const	$push32=, 0x0p0
	f32.add 	$push10=, $pop9, $pop32
	f32.store	v+12($pop34), $pop10
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	f32.load	$push11=, v+8($pop30)
	f32.const	$push12=, 0x1.6p4
	f32.add 	$push13=, $pop11, $pop12
	f32.const	$push29=, 0x1.6p4
	f32.add 	$push14=, $pop13, $pop29
	f32.store	v+8($pop31), $pop14
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	f32.load	$push15=, v+4($pop27)
	f32.const	$push16=, 0x1.4p4
	f32.add 	$push17=, $pop15, $pop16
	f32.const	$push26=, 0x1.4p4
	f32.add 	$push18=, $pop17, $pop26
	f32.store	v+4($pop28), $pop18
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	f32.load	$push19=, v($pop24)
	f32.const	$push20=, 0x1.2p4
	f32.add 	$push21=, $pop19, $pop20
	f32.const	$push23=, 0x1.2p4
	f32.add 	$push22=, $pop21, $pop23
	f32.store	v($pop25), $pop22
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f32, f32, f32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.load16_u	$push1=, u+2($pop62)
	i32.const	$push61=, 28
	i32.add 	$push60=, $pop1, $pop61
	tee_local	$push59=, $4=, $pop60
	i32.store16	u+2($pop63), $pop59
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.load16_u	$push2=, u($pop57)
	i32.const	$push3=, 24
	i32.add 	$push56=, $pop2, $pop3
	tee_local	$push55=, $5=, $pop56
	i32.store16	u($pop58), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	f32.load	$push4=, v+12($pop53)
	f32.const	$push5=, 0x0p0
	f32.add 	$push6=, $pop4, $pop5
	f32.const	$push52=, 0x0p0
	f32.add 	$push51=, $pop6, $pop52
	tee_local	$push50=, $3=, $pop51
	f32.store	v+12($pop54), $pop50
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	f32.load	$push7=, v+8($pop48)
	f32.const	$push8=, 0x1.6p4
	f32.add 	$push9=, $pop7, $pop8
	f32.const	$push47=, 0x1.6p4
	f32.add 	$push46=, $pop9, $pop47
	tee_local	$push45=, $2=, $pop46
	f32.store	v+8($pop49), $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	f32.load	$push10=, v+4($pop43)
	f32.const	$push11=, 0x1.4p4
	f32.add 	$push12=, $pop10, $pop11
	f32.const	$push42=, 0x1.4p4
	f32.add 	$push41=, $pop12, $pop42
	tee_local	$push40=, $1=, $pop41
	f32.store	v+4($pop44), $pop40
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	f32.load	$push13=, v($pop38)
	f32.const	$push14=, 0x1.2p4
	f32.add 	$push15=, $pop13, $pop14
	f32.const	$push37=, 0x1.2p4
	f32.add 	$push36=, $pop15, $pop37
	tee_local	$push35=, $0=, $pop36
	f32.store	v($pop39), $pop35
	block   	
	i32.const	$push34=, 65535
	i32.and 	$push18=, $5, $pop34
	i32.const	$push33=, 24
	i32.ne  	$push19=, $pop18, $pop33
	br_if   	0, $pop19       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push65=, 65535
	i32.and 	$push20=, $4, $pop65
	i32.const	$push64=, 28
	i32.ne  	$push21=, $pop20, $pop64
	br_if   	0, $pop21       # 0: down to label0
# BB#2:                                 # %entry
	i32.const	$push67=, 0
	i32.load16_u	$push17=, u+6($pop67)
	i32.const	$push66=, 0
	i32.load16_u	$push16=, u+4($pop66)
	i32.or  	$push0=, $pop17, $pop16
	i32.const	$push22=, 65535
	i32.and 	$push23=, $pop0, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#3:                                 # %if.end
	f32.const	$push24=, 0x1.2p5
	f32.ne  	$push25=, $0, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#4:                                 # %if.end
	f32.const	$push26=, 0x1.4p5
	f32.ne  	$push27=, $1, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#5:                                 # %if.end
	f32.const	$push28=, 0x1.6p5
	f32.ne  	$push29=, $2, $pop28
	br_if   	0, $pop29       # 0: down to label0
# BB#6:                                 # %if.end
	f32.const	$push30=, 0x0p0
	f32.ne  	$push31=, $3, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#7:                                 # %if.end26
	i32.const	$push32=, 0
	return  	$pop32
.LBB1_8:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
