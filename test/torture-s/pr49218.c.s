	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 16
	i32.sub 	$push21=, $pop15, $pop16
	i32.store	$push29=, __stack_pointer($pop17), $pop21
	tee_local	$push28=, $0=, $pop29
	i32.const	$push27=, 0
	f32.load	$push0=, f($pop27)
	call    	__fixsfti@FUNCTION, $pop28, $pop0
	block
	i64.load	$push26=, 0($0)
	tee_local	$push25=, $3=, $pop26
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $pop25, $pop4
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i64.load	$push24=, 0($pop2)
	tee_local	$push23=, $4=, $pop24
	i64.const	$push22=, 0
	i64.gt_s	$push3=, $pop23, $pop22
	i64.eqz 	$push6=, $4
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do.body.preheader
.LBB0_2:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$push37=, 1
	i64.add 	$push36=, $3, $pop37
	tee_local	$push35=, $1=, $pop36
	i64.lt_u	$2=, $pop35, $3
	#APP
	#NO_APP
	copy_local	$3=, $1
	i64.const	$push34=, 11
	i64.xor 	$push11=, $1, $pop34
	i64.const	$push33=, 1
	i64.extend_u/i32	$push9=, $2
	i64.eqz 	$push8=, $1
	i64.select	$push10=, $pop33, $pop9, $pop8
	i64.add 	$push32=, $4, $pop10
	tee_local	$push31=, $4=, $pop32
	i64.or  	$push12=, $pop11, $pop31
	i64.const	$push30=, 0
	i64.ne  	$push13=, $pop12, $pop30
	br_if   	0, $pop13       # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $0, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
	i32.const	$push38=, 0
                                        # fallthrough-return: $pop38
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


	.ident	"clang version 3.9.0 "
