	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vla-dealloc-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$push10=, __stack_pointer($pop8)
	tee_local	$push9=, $4=, $pop10
	copy_local	$drop=, $pop9
	i32.const	$3=, 0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push24=, 1000
	i32.rem_s	$push1=, $3, $pop24
	i32.const	$push23=, 2
	i32.shl 	$push22=, $pop1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 19
	i32.add 	$push2=, $pop21, $pop20
	i32.const	$push19=, -16
	i32.and 	$push3=, $pop2, $pop19
	i32.sub 	$push18=, $4, $pop3
	tee_local	$push17=, $2=, $pop18
	copy_local	$drop=, $pop17
	i32.const	$push16=, 1
	i32.store	$0=, 0($2), $pop16
	i32.const	$push15=, 0
	i32.store	$push0=, p($pop15), $2
	i32.add 	$push5=, $pop0, $1
	i32.const	$push14=, 2
	i32.store	$drop=, 0($pop5), $pop14
	copy_local	$push4=, $4
	copy_local	$4=, $pop4
	i32.add 	$push13=, $3, $0
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, 1000000
	i32.ne  	$push6=, $pop12, $pop11
	br_if   	0, $pop6        # 0: up to label0
# BB#2:                                 # %cleanup5
	end_loop                        # label1:
	i32.const	$push7=, 0
                                        # fallthrough-return: $pop7
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
