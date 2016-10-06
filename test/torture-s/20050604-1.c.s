	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050604-1.c"
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
	i32.store16	u+2($pop0), $pop3
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load16_u	$push4=, u($pop32)
	i32.const	$push5=, 24
	i32.add 	$push6=, $pop4, $pop5
	i32.store16	u($pop33), $pop6
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
	f32.store	v+12($pop28), $pop10
	i32.const	$push25=, 0
	f32.const	$push11=, 0x1.6p4
	f32.add 	$push12=, $2, $pop11
	f32.const	$push24=, 0x1.6p4
	f32.add 	$push13=, $pop12, $pop24
	f32.store	v+8($pop25), $pop13
	i32.const	$push23=, 0
	f32.const	$push14=, 0x1.4p4
	f32.add 	$push15=, $1, $pop14
	f32.const	$push22=, 0x1.4p4
	f32.add 	$push16=, $pop15, $pop22
	f32.store	v+4($pop23), $pop16
	i32.const	$push21=, 0
	f32.const	$push17=, 0x1.2p4
	f32.add 	$push18=, $0, $pop17
	f32.const	$push20=, 0x1.2p4
	f32.add 	$push19=, $pop18, $pop20
	f32.store	v($pop21), $pop19
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
	.local  	f32, i32, i32, i32, i32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push60=, 0
	i32.load16_u	$push2=, u+2($pop60)
	i32.const	$push59=, 28
	i32.add 	$push58=, $pop2, $pop59
	tee_local	$push57=, $1=, $pop58
	i32.store16	u+2($pop1), $pop57
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.load16_u	$push3=, u($pop55)
	i32.const	$push4=, 24
	i32.add 	$push54=, $pop3, $pop4
	tee_local	$push53=, $2=, $pop54
	i32.store16	u($pop56), $pop53
	i32.const	$push52=, 0
	i32.load16_u	$3=, u+6($pop52)
	i32.const	$push51=, 0
	i32.load16_u	$4=, u+4($pop51)
	i32.const	$push50=, 0
	f32.load	$5=, v($pop50)
	i32.const	$push49=, 0
	f32.load	$6=, v+4($pop49)
	i32.const	$push48=, 0
	f32.load	$7=, v+8($pop48)
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	f32.load	$push5=, v+12($pop46)
	f32.const	$push6=, 0x0p0
	f32.add 	$push7=, $pop5, $pop6
	f32.const	$push45=, 0x0p0
	f32.add 	$push44=, $pop7, $pop45
	tee_local	$push43=, $0=, $pop44
	f32.store	v+12($pop47), $pop43
	i32.const	$push42=, 0
	f32.const	$push8=, 0x1.6p4
	f32.add 	$push9=, $7, $pop8
	f32.const	$push41=, 0x1.6p4
	f32.add 	$push40=, $pop9, $pop41
	tee_local	$push39=, $7=, $pop40
	f32.store	v+8($pop42), $pop39
	i32.const	$push38=, 0
	f32.const	$push10=, 0x1.4p4
	f32.add 	$push11=, $6, $pop10
	f32.const	$push37=, 0x1.4p4
	f32.add 	$push36=, $pop11, $pop37
	tee_local	$push35=, $6=, $pop36
	f32.store	v+4($pop38), $pop35
	i32.const	$push34=, 0
	f32.const	$push12=, 0x1.2p4
	f32.add 	$push13=, $5, $pop12
	f32.const	$push33=, 0x1.2p4
	f32.add 	$push32=, $pop13, $pop33
	tee_local	$push31=, $5=, $pop32
	f32.store	v($pop34), $pop31
	block   	
	i32.const	$push30=, 65535
	i32.and 	$push14=, $2, $pop30
	i32.const	$push29=, 24
	i32.ne  	$push15=, $pop14, $pop29
	br_if   	0, $pop15       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push62=, 65535
	i32.and 	$push16=, $1, $pop62
	i32.const	$push61=, 28
	i32.ne  	$push17=, $pop16, $pop61
	br_if   	0, $pop17       # 0: down to label0
# BB#2:                                 # %entry
	i32.or  	$push0=, $3, $4
	i32.const	$push18=, 65535
	i32.and 	$push19=, $pop0, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#3:                                 # %if.end
	f32.const	$push20=, 0x1.2p5
	f32.ne  	$push21=, $5, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#4:                                 # %if.end
	f32.const	$push22=, 0x1.4p5
	f32.ne  	$push23=, $6, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#5:                                 # %if.end
	f32.const	$push24=, 0x1.6p5
	f32.ne  	$push25=, $7, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#6:                                 # %if.end
	f32.const	$push26=, 0x0p0
	f32.ne  	$push27=, $0, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end26
	i32.const	$push28=, 0
	return  	$pop28
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
