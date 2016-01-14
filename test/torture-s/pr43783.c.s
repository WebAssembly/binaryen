	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43783.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i64.const	$push2=, 1
	i64.store	$discard=, bid_Kx192+32($0), $pop2
	i64.const	$push0=, 0
	i64.store	$push1=, bid_Kx192+8($0), $pop0
	i64.store	$push3=, bid_Kx192+56($0), $pop1
	i64.store	$push4=, bid_Kx192+80($0), $pop3
	i64.store	$push5=, bid_Kx192+104($0), $pop4
	i64.store	$push6=, bid_Kx192+128($0), $pop5
	i64.store	$push7=, bid_Kx192+152($0), $pop6
	i64.store	$push8=, bid_Kx192+176($0), $pop7
	i64.store	$push9=, bid_Kx192+200($0), $pop8
	i64.store	$push10=, bid_Kx192+224($0), $pop9
	i64.store	$push11=, bid_Kx192+248($0), $pop10
	i64.store	$push12=, bid_Kx192+272($0), $pop11
	i64.store	$push13=, bid_Kx192+296($0), $pop12
	i64.store	$push14=, bid_Kx192+320($0), $pop13
	i64.store	$push15=, bid_Kx192+344($0), $pop14
	i64.store	$push16=, bid_Kx192+368($0), $pop15
	i64.store	$push17=, bid_Kx192+392($0), $pop16
	i64.store	$push18=, bid_Kx192+416($0), $pop17
	i64.store	$push19=, bid_Kx192+440($0), $pop18
	i64.store	$push20=, bid_Kx192+464($0), $pop19
	i64.store	$push21=, bid_Kx192+488($0), $pop20
	i64.store	$push22=, bid_Kx192+512($0), $pop21
	i64.store	$push23=, bid_Kx192+536($0), $pop22
	i64.store	$push24=, bid_Kx192+560($0), $pop23
	i64.store	$push25=, bid_Kx192+584($0), $pop24
	i64.store	$push26=, bid_Kx192+608($0), $pop25
	i64.store	$push27=, bid_Kx192+632($0), $pop26
	i64.store	$push28=, bid_Kx192+656($0), $pop27
	i64.store	$push29=, bid_Kx192+680($0), $pop28
	i64.store	$push30=, bid_Kx192+704($0), $pop29
	i64.store	$push31=, bid_Kx192+728($0), $pop30
	i64.store	$discard=, bid_Kx192+752($0), $pop31
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	bid_Kx192               # @bid_Kx192
	.type	bid_Kx192,@object
	.section	.bss.bid_Kx192,"aw",@nobits
	.globl	bid_Kx192
	.align	4
bid_Kx192:
	.skip	768
	.size	bid_Kx192, 768


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
