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
	i32.shl 	$push13=, $pop0, $pop14
	tee_local	$push12=, $4=, $pop13
	i32.const	$push11=, 19
	i32.add 	$push1=, $pop12, $pop11
	i32.const	$push10=, -16
	i32.and 	$push2=, $pop1, $pop10
	i32.sub 	$1=, $7, $pop2
	copy_local	$7=, $1
	i32.const	$push9=, 1
	i32.store	$2=, 0($1):p2align=4, $pop9
	i32.add 	$push3=, $1, $4
	i32.const	$push8=, 2
	i32.store	$discard=, 0($pop3), $pop8
	i32.const	$push7=, 0
	i32.store	$discard=, p($pop7), $1
	i32.add 	$3=, $3, $2
	copy_local	$7=, $0
	i32.const	$push6=, 1000000
	i32.ne  	$push4=, $3, $pop6
	br_if   	0, $pop4        # 0: up to label0
# BB#2:                                 # %cleanup5
	end_loop                        # label1:
	i32.const	$push5=, 0
	i32.const	$6=, __stack_pointer
	i32.store	$7=, 0($6), $8
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
