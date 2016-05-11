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
	i32.const	$push11=, __stack_pointer
	i32.load	$push13=, 0($pop11)
	tee_local	$push12=, $5=, $pop13
	copy_local	$discard=, $pop12
	i32.const	$3=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$2=, $5
	i32.const	$push35=, 1000
	i32.rem_s	$push0=, $3, $pop35
	i32.const	$push34=, 2
	i32.shl 	$push33=, $pop0, $pop34
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 19
	i32.add 	$push1=, $pop32, $pop31
	i32.const	$push30=, -16
	i32.and 	$push2=, $pop1, $pop30
	i32.sub 	$push29=, $5, $pop2
	tee_local	$push28=, $5=, $pop29
	copy_local	$discard=, $pop28
	i32.const	$push27=, 1
	i32.store	$0=, 0($5), $pop27
	i32.add 	$push3=, $5, $1
	i32.const	$push26=, 2
	i32.store	$1=, 0($pop3), $pop26
	i32.const	$push25=, 0
	i32.store	$discard=, p($pop25), $5
	copy_local	$push24=, $2
	tee_local	$push23=, $5=, $pop24
	copy_local	$2=, $pop23
	i32.add 	$push4=, $3, $0
	i32.const	$push22=, 1000
	i32.rem_s	$push5=, $pop4, $pop22
	i32.shl 	$push21=, $pop5, $1
	tee_local	$push20=, $4=, $pop21
	i32.const	$push19=, 19
	i32.add 	$push6=, $pop20, $pop19
	i32.const	$push18=, -16
	i32.and 	$push7=, $pop6, $pop18
	i32.sub 	$push17=, $5, $pop7
	tee_local	$push16=, $5=, $pop17
	copy_local	$discard=, $pop16
	i32.store	$discard=, 0($5), $0
	i32.add 	$push8=, $5, $4
	i32.store	$0=, 0($pop8), $1
	i32.const	$push15=, 0
	i32.store	$discard=, p($pop15), $5
	copy_local	$5=, $2
	i32.add 	$3=, $3, $0
	i32.const	$push14=, 1000000
	i32.lt_s	$push9=, $3, $pop14
	br_if   	0, $pop9        # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push10=, 0
	return  	$pop10
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
