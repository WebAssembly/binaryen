	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43783.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, 1
	i64.store	bid_Kx192+32($pop1), $pop0
	i32.const	$push64=, 0
	i64.const	$push2=, 0
	i64.store	bid_Kx192+8($pop64), $pop2
	i32.const	$push63=, 0
	i64.const	$push62=, 0
	i64.store	bid_Kx192+56($pop63), $pop62
	i32.const	$push61=, 0
	i64.const	$push60=, 0
	i64.store	bid_Kx192+80($pop61), $pop60
	i32.const	$push59=, 0
	i64.const	$push58=, 0
	i64.store	bid_Kx192+104($pop59), $pop58
	i32.const	$push57=, 0
	i64.const	$push56=, 0
	i64.store	bid_Kx192+128($pop57), $pop56
	i32.const	$push55=, 0
	i64.const	$push54=, 0
	i64.store	bid_Kx192+152($pop55), $pop54
	i32.const	$push53=, 0
	i64.const	$push52=, 0
	i64.store	bid_Kx192+176($pop53), $pop52
	i32.const	$push51=, 0
	i64.const	$push50=, 0
	i64.store	bid_Kx192+200($pop51), $pop50
	i32.const	$push49=, 0
	i64.const	$push48=, 0
	i64.store	bid_Kx192+224($pop49), $pop48
	i32.const	$push47=, 0
	i64.const	$push46=, 0
	i64.store	bid_Kx192+248($pop47), $pop46
	i32.const	$push45=, 0
	i64.const	$push44=, 0
	i64.store	bid_Kx192+272($pop45), $pop44
	i32.const	$push43=, 0
	i64.const	$push42=, 0
	i64.store	bid_Kx192+296($pop43), $pop42
	i32.const	$push41=, 0
	i64.const	$push40=, 0
	i64.store	bid_Kx192+320($pop41), $pop40
	i32.const	$push39=, 0
	i64.const	$push38=, 0
	i64.store	bid_Kx192+344($pop39), $pop38
	i32.const	$push37=, 0
	i64.const	$push36=, 0
	i64.store	bid_Kx192+368($pop37), $pop36
	i32.const	$push35=, 0
	i64.const	$push34=, 0
	i64.store	bid_Kx192+392($pop35), $pop34
	i32.const	$push33=, 0
	i64.const	$push32=, 0
	i64.store	bid_Kx192+416($pop33), $pop32
	i32.const	$push31=, 0
	i64.const	$push30=, 0
	i64.store	bid_Kx192+440($pop31), $pop30
	i32.const	$push29=, 0
	i64.const	$push28=, 0
	i64.store	bid_Kx192+464($pop29), $pop28
	i32.const	$push27=, 0
	i64.const	$push26=, 0
	i64.store	bid_Kx192+488($pop27), $pop26
	i32.const	$push25=, 0
	i64.const	$push24=, 0
	i64.store	bid_Kx192+512($pop25), $pop24
	i32.const	$push23=, 0
	i64.const	$push22=, 0
	i64.store	bid_Kx192+536($pop23), $pop22
	i32.const	$push21=, 0
	i64.const	$push20=, 0
	i64.store	bid_Kx192+560($pop21), $pop20
	i32.const	$push19=, 0
	i64.const	$push18=, 0
	i64.store	bid_Kx192+584($pop19), $pop18
	i32.const	$push17=, 0
	i64.const	$push16=, 0
	i64.store	bid_Kx192+608($pop17), $pop16
	i32.const	$push15=, 0
	i64.const	$push14=, 0
	i64.store	bid_Kx192+632($pop15), $pop14
	i32.const	$push13=, 0
	i64.const	$push12=, 0
	i64.store	bid_Kx192+656($pop13), $pop12
	i32.const	$push11=, 0
	i64.const	$push10=, 0
	i64.store	bid_Kx192+680($pop11), $pop10
	i32.const	$push9=, 0
	i64.const	$push8=, 0
	i64.store	bid_Kx192+704($pop9), $pop8
	i32.const	$push7=, 0
	i64.const	$push6=, 0
	i64.store	bid_Kx192+728($pop7), $pop6
	i32.const	$push5=, 0
	i64.const	$push4=, 0
	i64.store	bid_Kx192+752($pop5), $pop4
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	bid_Kx192               # @bid_Kx192
	.type	bid_Kx192,@object
	.section	.bss.bid_Kx192,"aw",@nobits
	.globl	bid_Kx192
	.p2align	4
bid_Kx192:
	.skip	768
	.size	bid_Kx192, 768


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
