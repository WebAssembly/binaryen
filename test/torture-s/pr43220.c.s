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
	i32.const	$push13=, __stack_pointer
	i32.load	$push15=, 0($pop13)
	tee_local	$push14=, $3=, $pop15
	copy_local	$drop=, $pop14
	i32.const	$2=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push37=, 1000
	i32.rem_s	$push0=, $2, $pop37
	i32.const	$push36=, 2
	i32.shl 	$push35=, $pop0, $pop36
	tee_local	$push34=, $1=, $pop35
	i32.const	$push33=, 19
	i32.add 	$push2=, $pop34, $pop33
	i32.const	$push32=, -16
	i32.and 	$push3=, $pop2, $pop32
	i32.sub 	$push31=, $3, $pop3
	tee_local	$push30=, $5=, $pop31
	copy_local	$drop=, $pop30
	i32.const	$push29=, 1
	i32.store	$0=, 0($5), $pop29
	i32.add 	$push4=, $5, $1
	i32.const	$push28=, 2
	i32.store	$1=, 0($pop4), $pop28
	i32.const	$push27=, 0
	i32.store	$drop=, p($pop27), $5
	copy_local	$push1=, $3
	copy_local	$push26=, $pop1
	tee_local	$push25=, $3=, $pop26
	i32.add 	$push5=, $2, $0
	i32.const	$push24=, 1000
	i32.rem_s	$push6=, $pop5, $pop24
	i32.shl 	$push23=, $pop6, $1
	tee_local	$push22=, $4=, $pop23
	i32.const	$push21=, 19
	i32.add 	$push8=, $pop22, $pop21
	i32.const	$push20=, -16
	i32.and 	$push9=, $pop8, $pop20
	i32.sub 	$push19=, $pop25, $pop9
	tee_local	$push18=, $5=, $pop19
	copy_local	$drop=, $pop18
	i32.store	$drop=, 0($5), $0
	i32.add 	$push10=, $5, $4
	i32.store	$0=, 0($pop10), $1
	i32.const	$push17=, 0
	i32.store	$drop=, p($pop17), $5
	copy_local	$push7=, $3
	copy_local	$3=, $pop7
	i32.add 	$2=, $2, $0
	i32.const	$push16=, 1000000
	i32.lt_s	$push11=, $2, $pop16
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push12=, 0
	return  	$pop12
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
