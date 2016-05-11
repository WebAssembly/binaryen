	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$push18=, __stack_pointer
	i32.const	$push15=, __stack_pointer
	i32.load	$push16=, 0($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push22=, $pop16, $pop17
	i32.store	$push30=, 0($pop18), $pop22
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 0
	f32.load	$push0=, f($pop28)
	call    	__fixsfti@FUNCTION, $pop29, $pop0
	block
	i64.load	$push27=, 0($2)
	tee_local	$push26=, $1=, $pop27
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $pop26, $pop4
	i32.const	$push1=, 8
	i32.add 	$push2=, $2, $pop1
	i64.load	$push25=, 0($pop2)
	tee_local	$push24=, $0=, $pop25
	i64.const	$push23=, 0
	i64.gt_s	$push3=, $pop24, $pop23
	i64.eqz 	$push6=, $0
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %do.body.preheader
.LBB0_2:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$push36=, 1
	i64.const	$push35=, 1
	i64.add 	$push34=, $1, $pop35
	tee_local	$push33=, $3=, $pop34
	i64.lt_u	$push9=, $pop33, $1
	i64.extend_u/i32	$push10=, $pop9
	i64.eqz 	$push8=, $3
	i64.select	$push11=, $pop36, $pop10, $pop8
	i64.add 	$0=, $0, $pop11
	#APP
	#NO_APP
	copy_local	$1=, $3
	i64.const	$push32=, 11
	i64.xor 	$push12=, $3, $pop32
	i64.or  	$push13=, $0, $pop12
	i64.const	$push31=, 0
	i64.ne  	$push14=, $pop13, $pop31
	br_if   	0, $pop14       # 0: up to label1
.LBB0_3:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push21=, __stack_pointer
	i32.const	$push19=, 16
	i32.add 	$push20=, $2, $pop19
	i32.store	$discard=, 0($pop21), $pop20
	i32.const	$push37=, 0
	return  	$pop37
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
