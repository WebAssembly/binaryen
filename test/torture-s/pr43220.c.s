	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43220.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.load	$push18=, __stack_pointer($pop16)
	tee_local	$push17=, $5=, $pop18
	copy_local	$drop=, $pop17
	i32.const	$4=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push46=, 1000
	i32.rem_s	$push3=, $4, $pop46
	i32.const	$push45=, 2
	i32.shl 	$push44=, $pop3, $pop45
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 19
	i32.add 	$push4=, $pop43, $pop42
	i32.const	$push41=, -16
	i32.and 	$push5=, $pop4, $pop41
	i32.sub 	$push40=, $5, $pop5
	tee_local	$push39=, $2=, $pop40
	copy_local	$drop=, $pop39
	copy_local	$push6=, $5
	copy_local	$push38=, $pop6
	tee_local	$push37=, $5=, $pop38
	i32.const	$push36=, 1
	i32.store	$push35=, 0($2), $pop36
	tee_local	$push34=, $0=, $pop35
	i32.add 	$push8=, $4, $pop34
	i32.const	$push33=, 1000
	i32.rem_s	$push9=, $pop8, $pop33
	i32.const	$push32=, 0
	i32.store	$push0=, p($pop32), $2
	i32.add 	$push7=, $pop0, $1
	i32.const	$push31=, 2
	i32.store	$push30=, 0($pop7), $pop31
	tee_local	$push29=, $1=, $pop30
	i32.shl 	$push28=, $pop9, $pop29
	tee_local	$push27=, $3=, $pop28
	i32.const	$push26=, 19
	i32.add 	$push10=, $pop27, $pop26
	i32.const	$push25=, -16
	i32.and 	$push11=, $pop10, $pop25
	i32.sub 	$push24=, $pop37, $pop11
	tee_local	$push23=, $2=, $pop24
	copy_local	$drop=, $pop23
	i32.store	$drop=, 0($2), $0
	copy_local	$push12=, $5
	copy_local	$5=, $pop12
	i32.const	$push22=, 0
	i32.store	$push1=, p($pop22), $2
	i32.add 	$push13=, $pop1, $3
	i32.store	$push2=, 0($pop13), $1
	i32.add 	$push21=, $4, $pop2
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 1000000
	i32.lt_s	$push14=, $pop20, $pop19
	br_if   	0, $pop14       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push15=, 0
                                        # fallthrough-return: $pop15
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 3.9.0 "
