	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040811-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.load	$push9=, __stack_pointer($pop7)
	tee_local	$push8=, $3=, $pop9
	copy_local	$drop=, $pop8
	i32.const	$2=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push24=, 1000
	i32.rem_s	$push0=, $2, $pop24
	i32.const	$push23=, 2
	i32.shl 	$push22=, $pop0, $pop23
	tee_local	$push21=, $0=, $pop22
	i32.const	$push20=, 19
	i32.add 	$push1=, $pop21, $pop20
	i32.const	$push19=, -16
	i32.and 	$push2=, $pop1, $pop19
	i32.sub 	$push18=, $3, $pop2
	tee_local	$push17=, $1=, $pop18
	copy_local	$drop=, $pop17
	i32.const	$push16=, 1
	i32.store	0($1), $pop16
	i32.const	$push15=, 0
	i32.store	p($pop15), $1
	i32.add 	$push4=, $1, $0
	i32.const	$push14=, 2
	i32.store	0($pop4), $pop14
	copy_local	$push3=, $3
	copy_local	$3=, $pop3
	i32.const	$push13=, 1
	i32.add 	$push12=, $2, $pop13
	tee_local	$push11=, $2=, $pop12
	i32.const	$push10=, 1000000
	i32.ne  	$push5=, $pop11, $pop10
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %cleanup3
	end_loop
	i32.const	$push6=, 0
                                        # fallthrough-return: $pop6
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
