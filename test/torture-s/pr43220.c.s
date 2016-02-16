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
	i32.shl 	$push24=, $pop0, $pop25
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 19
	i32.add 	$push1=, $pop23, $pop22
	i32.const	$push21=, -16
	i32.and 	$push2=, $pop1, $pop21
	i32.sub 	$1=, $8, $pop2
	copy_local	$8=, $1
	i32.const	$push20=, 1
	i32.store	$2=, 0($1):p2align=4, $pop20
	i32.add 	$push3=, $1, $3
	i32.const	$push19=, 2
	i32.store	$3=, 0($pop3), $pop19
	i32.const	$push18=, 0
	i32.store	$discard=, p($pop18), $1
	copy_local	$8=, $0
	copy_local	$0=, $8
	i32.add 	$push4=, $4, $2
	i32.const	$push17=, 1000
	i32.rem_s	$push5=, $pop4, $pop17
	i32.shl 	$push16=, $pop5, $3
	tee_local	$push15=, $5=, $pop16
	i32.const	$push14=, 19
	i32.add 	$push6=, $pop15, $pop14
	i32.const	$push13=, -16
	i32.and 	$push7=, $pop6, $pop13
	i32.sub 	$1=, $8, $pop7
	copy_local	$8=, $1
	i32.store	$discard=, 0($1):p2align=4, $2
	i32.add 	$push8=, $1, $5
	i32.store	$2=, 0($pop8), $3
	i32.const	$push12=, 0
	i32.store	$discard=, p($pop12), $1
	copy_local	$8=, $0
	i32.add 	$4=, $4, $2
	i32.const	$push11=, 1000000
	i32.lt_s	$push9=, $4, $pop11
	br_if   	0, $pop9        # 0: up to label0
# BB#2:                                 # %if.end
	end_loop                        # label1:
	i32.const	$push10=, 0
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $9
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
