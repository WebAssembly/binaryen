	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43220.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.load	$push15=, __stack_pointer($pop13)
	tee_local	$push14=, $3=, $pop15
	copy_local	$drop=, $pop14
	i32.const	$2=, 0
.LBB0_1:                                # %lab
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push44=, 1000
	i32.rem_s	$push0=, $2, $pop44
	i32.const	$push43=, 2
	i32.shl 	$push42=, $pop0, $pop43
	tee_local	$push41=, $0=, $pop42
	i32.const	$push40=, 19
	i32.add 	$push1=, $pop41, $pop40
	i32.const	$push39=, -16
	i32.and 	$push2=, $pop1, $pop39
	i32.sub 	$push38=, $3, $pop2
	tee_local	$push37=, $1=, $pop38
	copy_local	$drop=, $pop37
	i32.const	$push36=, 1
	i32.store	0($1), $pop36
	i32.const	$push35=, 0
	i32.store	p($pop35), $1
	i32.add 	$push4=, $1, $0
	i32.const	$push34=, 2
	i32.store	0($pop4), $pop34
	copy_local	$push3=, $3
	copy_local	$push33=, $pop3
	tee_local	$push32=, $3=, $pop33
	i32.const	$push31=, 1
	i32.add 	$push5=, $2, $pop31
	i32.const	$push30=, 1000
	i32.rem_s	$push6=, $pop5, $pop30
	i32.const	$push29=, 2
	i32.shl 	$push28=, $pop6, $pop29
	tee_local	$push27=, $0=, $pop28
	i32.const	$push26=, 19
	i32.add 	$push7=, $pop27, $pop26
	i32.const	$push25=, -16
	i32.and 	$push8=, $pop7, $pop25
	i32.sub 	$push24=, $pop32, $pop8
	tee_local	$push23=, $1=, $pop24
	copy_local	$drop=, $pop23
	i32.const	$push22=, 1
	i32.store	0($1), $pop22
	i32.const	$push21=, 0
	i32.store	p($pop21), $1
	i32.add 	$push10=, $1, $0
	i32.const	$push20=, 2
	i32.store	0($pop10), $pop20
	copy_local	$push9=, $3
	copy_local	$3=, $pop9
	i32.const	$push19=, 2
	i32.add 	$push18=, $2, $pop19
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 1000000
	i32.lt_s	$push11=, $pop17, $pop16
	br_if   	0, $pop11       # 0: up to label0
# BB#2:                                 # %if.end
	end_loop
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
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
