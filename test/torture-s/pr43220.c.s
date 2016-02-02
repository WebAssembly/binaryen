	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43220.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$8=, 0($6)
	copy_local	$9=, $8
	i32.const	$4=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$0=, $8
	i32.const	$push26=, 1000
	i32.rem_s	$push0=, $4, $pop26
	i32.const	$push25=, 2
	i32.shl 	$push1=, $pop0, $pop25
	tee_local	$push24=, $3=, $pop1
	i32.const	$push23=, 19
	i32.add 	$push2=, $pop24, $pop23
	i32.const	$push22=, -16
	i32.and 	$push3=, $pop2, $pop22
	i32.sub 	$1=, $8, $pop3
	copy_local	$8=, $1
	i32.const	$push21=, 1
	i32.store	$2=, 0($1):p2align=4, $pop21
	i32.add 	$push4=, $1, $3
	i32.const	$push20=, 2
	i32.store	$3=, 0($pop4), $pop20
	i32.const	$push19=, 0
	i32.store	$discard=, p($pop19), $1
	copy_local	$8=, $0
	copy_local	$0=, $8
	i32.add 	$push5=, $4, $2
	i32.const	$push18=, 1000
	i32.rem_s	$push6=, $pop5, $pop18
	i32.shl 	$push7=, $pop6, $3
	tee_local	$push17=, $5=, $pop7
	i32.const	$push16=, 19
	i32.add 	$push8=, $pop17, $pop16
	i32.const	$push15=, -16
	i32.and 	$push9=, $pop8, $pop15
	i32.sub 	$1=, $8, $pop9
	copy_local	$8=, $1
	i32.store	$discard=, 0($1):p2align=4, $2
	i32.add 	$push10=, $1, $5
	i32.store	$2=, 0($pop10), $3
	i32.const	$push14=, 0
	i32.store	$discard=, p($pop14), $1
	copy_local	$8=, $0
	i32.add 	$4=, $4, $2
	i32.const	$push13=, 1000000
	i32.lt_s	$push11=, $4, $pop13
	br_if   	$pop11, 0       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push12=, 0
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $9
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
