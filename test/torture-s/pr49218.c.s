	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 16
	i32.sub 	$3=, $pop31, $pop32
	i32.const	$push33=, __stack_pointer
	i32.store	$discard=, 0($pop33), $3
	i32.const	$push21=, 0
	f32.load	$push0=, f($pop21)
	call    	__fixsfti@FUNCTION, $3, $pop0
	block
	i64.load	$push20=, 0($3)
	tee_local	$push19=, $1=, $pop20
	i64.const	$push5=, 10
	i64.gt_u	$push6=, $pop19, $pop5
	i32.const	$push1=, 8
	i32.add 	$push2=, $3, $pop1
	i64.load	$push18=, 0($pop2)
	tee_local	$push17=, $0=, $pop18
	i64.const	$push16=, 0
	i64.gt_s	$push4=, $pop17, $pop16
	i64.const	$push15=, 0
	i64.eq  	$push3=, $0, $pop15
	i32.select	$push7=, $pop6, $pop4, $pop3
	br_if   	0, $pop7        # 0: down to label0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$push28=, 1
	i64.const	$push27=, 1
	i64.add 	$push26=, $1, $pop27
	tee_local	$push25=, $2=, $pop26
	i64.lt_u	$push9=, $pop25, $1
	i64.extend_u/i32	$push10=, $pop9
	i64.const	$push24=, 0
	i64.eq  	$push8=, $2, $pop24
	i64.select	$push11=, $pop28, $pop10, $pop8
	i64.add 	$0=, $0, $pop11
	#APP
	#NO_APP
	copy_local	$1=, $2
	i64.const	$push23=, 11
	i64.xor 	$push12=, $2, $pop23
	i64.or  	$push13=, $0, $pop12
	i64.const	$push22=, 0
	i64.ne  	$push14=, $pop13, $pop22
	br_if   	0, $pop14       # 0: up to label1
.LBB0_2:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push29=, 0
	i32.const	$push34=, 16
	i32.add 	$3=, $3, $pop34
	i32.const	$push35=, __stack_pointer
	i32.store	$discard=, 0($pop35), $3
	return  	$pop29
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
