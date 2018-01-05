	.text
	.file	"20050604-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	i32.const	$push51=, 0
	i32.load16_u	$push1=, u+2($pop51)
	i32.const	$push50=, 28
	i32.add 	$4=, $pop1, $pop50
	i32.const	$push49=, 0
	i32.store16	u+2($pop49), $4
	i32.const	$push48=, 0
	i32.load16_u	$push2=, u($pop48)
	i32.const	$push3=, 24
	i32.add 	$5=, $pop2, $pop3
	i32.const	$push47=, 0
	i32.store16	u($pop47), $5
	i32.const	$push46=, 0
	f32.load	$push4=, v+12($pop46)
	f32.const	$push5=, 0x0p0
	f32.add 	$push6=, $pop4, $pop5
	f32.const	$push45=, 0x0p0
	f32.add 	$3=, $pop6, $pop45
	i32.const	$push44=, 0
	f32.store	v+12($pop44), $3
	i32.const	$push43=, 0
	f32.load	$push7=, v+8($pop43)
	f32.const	$push8=, 0x1.6p4
	f32.add 	$push9=, $pop7, $pop8
	f32.const	$push42=, 0x1.6p4
	f32.add 	$2=, $pop9, $pop42
	i32.const	$push41=, 0
	f32.store	v+8($pop41), $2
	i32.const	$push40=, 0
	f32.load	$push10=, v+4($pop40)
	f32.const	$push11=, 0x1.4p4
	f32.add 	$push12=, $pop10, $pop11
	f32.const	$push39=, 0x1.4p4
	f32.add 	$1=, $pop12, $pop39
	i32.const	$push38=, 0
	f32.store	v+4($pop38), $1
	i32.const	$push37=, 0
	f32.load	$push13=, v($pop37)
	f32.const	$push14=, 0x1.2p4
	f32.add 	$push15=, $pop13, $pop14
	f32.const	$push36=, 0x1.2p4
	f32.add 	$0=, $pop15, $pop36
	i32.const	$push35=, 0
	f32.store	v($pop35), $0
	block   	
	i32.const	$push34=, 65535
	i32.and 	$push18=, $5, $pop34
	i32.const	$push33=, 24
	i32.ne  	$push19=, $pop18, $pop33
	br_if   	0, $pop19       # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push53=, 65535
	i32.and 	$push20=, $4, $pop53
	i32.const	$push52=, 28
	i32.ne  	$push21=, $pop20, $pop52
	br_if   	0, $pop21       # 0: down to label0
# %bb.2:                                # %entry
	i32.const	$push55=, 0
	i32.load16_u	$push17=, u+6($pop55)
	i32.const	$push54=, 0
	i32.load16_u	$push16=, u+4($pop54)
	i32.or  	$push0=, $pop17, $pop16
	i32.const	$push22=, 65535
	i32.and 	$push23=, $pop0, $pop22
	br_if   	0, $pop23       # 0: down to label0
# %bb.3:                                # %if.end
	f32.const	$push24=, 0x1.2p5
	f32.ne  	$push25=, $0, $pop24
	br_if   	0, $pop25       # 0: down to label0
# %bb.4:                                # %if.end
	f32.const	$push26=, 0x1.4p5
	f32.ne  	$push27=, $1, $pop26
	br_if   	0, $pop27       # 0: down to label0
# %bb.5:                                # %if.end
	f32.const	$push28=, 0x1.6p5
	f32.ne  	$push29=, $2, $pop28
	br_if   	0, $pop29       # 0: down to label0
# %bb.6:                                # %if.end
	f32.const	$push30=, 0x0p0
	f32.ne  	$push31=, $3, $pop30
	br_if   	0, $pop31       # 0: down to label0
# %bb.7:                                # %if.end26
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
