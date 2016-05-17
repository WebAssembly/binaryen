	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040811-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, __stack_pointer
	i32.load	$push9=, 0($pop7)
	tee_local	$push8=, $2=, $pop9
	copy_local	$drop=, $pop8
	i32.const	$1=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push21=, 1000
	i32.rem_s	$push0=, $1, $pop21
	i32.const	$push20=, 2
	i32.shl 	$push19=, $pop0, $pop20
	tee_local	$push18=, $4=, $pop19
	i32.const	$push17=, 19
	i32.add 	$push2=, $pop18, $pop17
	i32.const	$push16=, -16
	i32.and 	$push3=, $pop2, $pop16
	i32.sub 	$push15=, $2, $pop3
	tee_local	$push14=, $3=, $pop15
	copy_local	$drop=, $pop14
	i32.const	$push13=, 1
	i32.store	$0=, 0($3), $pop13
	i32.add 	$push4=, $3, $4
	i32.const	$push12=, 2
	i32.store	$drop=, 0($pop4), $pop12
	i32.const	$push11=, 0
	i32.store	$drop=, p($pop11), $3
	i32.add 	$1=, $1, $0
	copy_local	$push1=, $2
	copy_local	$2=, $pop1
	i32.const	$push10=, 1000000
	i32.ne  	$push5=, $1, $pop10
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %cleanup3
	end_loop                        # label1:
	i32.const	$push6=, 0
	return  	$pop6
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
