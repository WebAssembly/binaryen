	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push28=, $pop15, $pop16
	tee_local	$push27=, $4=, $pop28
	i32.store	__stack_pointer($pop17), $pop27
	i32.const	$push26=, 0
	f32.load	$push0=, f($pop26)
	call    	__fixsfti@FUNCTION, $4, $pop0
	block   	
	i64.load	$push25=, 0($4)
	tee_local	$push24=, $2=, $pop25
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $pop24, $pop4
	i32.const	$push1=, 8
	i32.add 	$push2=, $4, $pop1
	i64.load	$push23=, 0($pop2)
	tee_local	$push22=, $3=, $pop23
	i64.const	$push21=, 0
	i64.gt_s	$push3=, $pop22, $pop21
	i64.eqz 	$push6=, $3
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do.body.preheader
.LBB0_2:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push36=, 1
	i64.add 	$push35=, $2, $pop36
	tee_local	$push34=, $0=, $pop35
	i64.lt_u	$1=, $pop34, $2
	#APP
	#NO_APP
	copy_local	$2=, $0
	i64.const	$push33=, 11
	i64.xor 	$push11=, $0, $pop33
	i64.const	$push32=, 1
	i64.extend_u/i32	$push9=, $1
	i64.eqz 	$push8=, $0
	i64.select	$push10=, $pop32, $pop9, $pop8
	i64.add 	$push31=, $3, $pop10
	tee_local	$push30=, $3=, $pop31
	i64.or  	$push12=, $pop11, $pop30
	i64.const	$push29=, 0
	i64.ne  	$push13=, $pop12, $pop29
	br_if   	0, $pop13       # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop
	end_block                       # label0:
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $4, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	i32.const	$push37=, 0
                                        # fallthrough-return: $pop37
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # float 0
	.size	f, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
