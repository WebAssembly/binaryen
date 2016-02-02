	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/vla-dealloc-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, __stack_pointer
	i32.load	$7=, 0($5)
	copy_local	$8=, $7
	i32.const	$3=, 0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	copy_local	$0=, $7
	i32.const	$push15=, 1000
	i32.rem_s	$push0=, $3, $pop15
	i32.const	$push14=, 2
	i32.shl 	$push1=, $pop0, $pop14
	tee_local	$push13=, $4=, $pop1
	i32.const	$push12=, 19
	i32.add 	$push2=, $pop13, $pop12
	i32.const	$push11=, -16
	i32.and 	$push3=, $pop2, $pop11
	i32.sub 	$1=, $7, $pop3
	copy_local	$7=, $1
	i32.const	$push10=, 1
	i32.store	$2=, 0($1):p2align=4, $pop10
	i32.add 	$push4=, $1, $4
	i32.const	$push9=, 2
	i32.store	$discard=, 0($pop4), $pop9
	i32.const	$push8=, 0
	i32.store	$discard=, p($pop8), $1
	i32.add 	$3=, $3, $2
	copy_local	$7=, $0
	i32.const	$push7=, 1000000
	i32.ne  	$push5=, $3, $pop7
	br_if   	$pop5, 0        # 0: up to label0
# BB#2:                                 # %cleanup5
	end_loop                        # label1:
	i32.const	$push6=, 0
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $8
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
