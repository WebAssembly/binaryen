	.text
	.file	"pr43220.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
	i32.const	$push42=, 1000
	i32.rem_s	$push1=, $2, $pop42
	i32.const	$push41=, 2
	i32.shl 	$push40=, $pop1, $pop41
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 19
	i32.add 	$push2=, $pop39, $pop38
	i32.const	$push37=, -16
	i32.and 	$push3=, $pop2, $pop37
	i32.sub 	$push36=, $3, $pop3
	tee_local	$push35=, $1=, $pop36
	copy_local	$drop=, $pop35
	i32.const	$push34=, 1
	i32.store	0($1), $pop34
	i32.const	$push33=, 0
	i32.store	p($pop33), $1
	i32.add 	$push5=, $1, $0
	i32.const	$push32=, 2
	i32.store	0($pop5), $pop32
	copy_local	$push4=, $3
	copy_local	$push31=, $pop4
	tee_local	$push30=, $3=, $pop31
	i32.const	$push29=, 1
	i32.add 	$push6=, $2, $pop29
	i32.const	$push28=, 1000
	i32.rem_s	$push7=, $pop6, $pop28
	i32.const	$push27=, 2
	i32.shl 	$push26=, $pop7, $pop27
	tee_local	$push25=, $0=, $pop26
	i32.const	$push24=, 19
	i32.add 	$push8=, $pop25, $pop24
	i32.const	$push23=, -16
	i32.and 	$push9=, $pop8, $pop23
	i32.sub 	$push22=, $pop30, $pop9
	tee_local	$push21=, $1=, $pop22
	copy_local	$drop=, $pop21
	i32.const	$push20=, 1
	i32.store	0($1), $pop20
	i32.const	$push19=, 0
	i32.store	p($pop19), $1
	i32.add 	$push11=, $1, $0
	i32.const	$push18=, 2
	i32.store	0($pop11), $pop18
	i32.const	$push17=, 999998
	i32.lt_u	$1=, $2, $pop17
	copy_local	$push10=, $3
	copy_local	$3=, $pop10
	i32.const	$push16=, 2
	i32.add 	$push0=, $2, $pop16
	copy_local	$2=, $pop0
	br_if   	0, $1           # 0: up to label0
# BB#2:                                 # %if.end
	end_loop
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
