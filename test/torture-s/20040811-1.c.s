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
	i32.const	$push6=, __stack_pointer
	i32.load	$push8=, 0($pop6)
	tee_local	$push7=, $3=, $pop8
	copy_local	$discard=, $pop7
	i32.const	$2=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$1=, $3
	i32.const	$push20=, 1000
	i32.rem_s	$push0=, $2, $pop20
	i32.const	$push19=, 2
	i32.shl 	$push18=, $pop0, $pop19
	tee_local	$push17=, $4=, $pop18
	i32.const	$push16=, 19
	i32.add 	$push1=, $pop17, $pop16
	i32.const	$push15=, -16
	i32.and 	$push2=, $pop1, $pop15
	i32.sub 	$push14=, $3, $pop2
	tee_local	$push13=, $3=, $pop14
	copy_local	$discard=, $pop13
	i32.const	$push12=, 1
	i32.store	$0=, 0($3), $pop12
	i32.add 	$push3=, $3, $4
	i32.const	$push11=, 2
	i32.store	$discard=, 0($pop3), $pop11
	i32.const	$push10=, 0
	i32.store	$discard=, p($pop10), $3
	i32.add 	$2=, $2, $0
	copy_local	$3=, $1
	i32.const	$push9=, 1000000
	i32.ne  	$push4=, $2, $pop9
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %cleanup3
	end_loop                        # label1:
	i32.const	$push5=, 0
	return  	$pop5
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
