	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43783.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push3=, 1
	i64.store	$discard=, bid_Kx192+32($pop1):p2align=4, $pop3
	i32.const	$push64=, 0
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.const	$push61=, 0
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.const	$push55=, 0
	i32.const	$push54=, 0
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 0
	i32.const	$push50=, 0
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i64.const	$push0=, 0
	i64.store	$push2=, bid_Kx192+8($pop34), $pop0
	i64.store	$push4=, bid_Kx192+56($pop35), $pop2
	i64.store	$push5=, bid_Kx192+80($pop36):p2align=4, $pop4
	i64.store	$push6=, bid_Kx192+104($pop37), $pop5
	i64.store	$push7=, bid_Kx192+128($pop38):p2align=4, $pop6
	i64.store	$push8=, bid_Kx192+152($pop39), $pop7
	i64.store	$push9=, bid_Kx192+176($pop40):p2align=4, $pop8
	i64.store	$push10=, bid_Kx192+200($pop41), $pop9
	i64.store	$push11=, bid_Kx192+224($pop42):p2align=4, $pop10
	i64.store	$push12=, bid_Kx192+248($pop43), $pop11
	i64.store	$push13=, bid_Kx192+272($pop44):p2align=4, $pop12
	i64.store	$push14=, bid_Kx192+296($pop45), $pop13
	i64.store	$push15=, bid_Kx192+320($pop46):p2align=4, $pop14
	i64.store	$push16=, bid_Kx192+344($pop47), $pop15
	i64.store	$push17=, bid_Kx192+368($pop48):p2align=4, $pop16
	i64.store	$push18=, bid_Kx192+392($pop49), $pop17
	i64.store	$push19=, bid_Kx192+416($pop50):p2align=4, $pop18
	i64.store	$push20=, bid_Kx192+440($pop51), $pop19
	i64.store	$push21=, bid_Kx192+464($pop52):p2align=4, $pop20
	i64.store	$push22=, bid_Kx192+488($pop53), $pop21
	i64.store	$push23=, bid_Kx192+512($pop54):p2align=4, $pop22
	i64.store	$push24=, bid_Kx192+536($pop55), $pop23
	i64.store	$push25=, bid_Kx192+560($pop56):p2align=4, $pop24
	i64.store	$push26=, bid_Kx192+584($pop57), $pop25
	i64.store	$push27=, bid_Kx192+608($pop58):p2align=4, $pop26
	i64.store	$push28=, bid_Kx192+632($pop59), $pop27
	i64.store	$push29=, bid_Kx192+656($pop60):p2align=4, $pop28
	i64.store	$push30=, bid_Kx192+680($pop61), $pop29
	i64.store	$push31=, bid_Kx192+704($pop62):p2align=4, $pop30
	i64.store	$push32=, bid_Kx192+728($pop63), $pop31
	i64.store	$discard=, bid_Kx192+752($pop64):p2align=4, $pop32
	i32.const	$push33=, 0
	return  	$pop33
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


	.ident	"clang version 3.9.0 "
