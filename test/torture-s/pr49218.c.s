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
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 16
	i32.sub 	$3=, $pop29, $pop30
	i32.const	$push31=, __stack_pointer
	i32.store	$discard=, 0($pop31), $3
	i32.const	$push20=, 0
	f32.load	$push0=, f($pop20)
	call    	__fixsfti@FUNCTION, $3, $pop0
	block
	i64.load	$push19=, 0($3)
	tee_local	$push18=, $1=, $pop19
	i64.const	$push4=, 10
	i64.gt_u	$push5=, $pop18, $pop4
	i32.const	$push1=, 8
	i32.add 	$push2=, $3, $pop1
	i64.load	$push17=, 0($pop2)
	tee_local	$push16=, $0=, $pop17
	i64.const	$push15=, 0
	i64.gt_s	$push3=, $pop16, $pop15
	i64.eqz 	$push6=, $0
	i32.select	$push7=, $pop5, $pop3, $pop6
	br_if   	0, $pop7        # 0: down to label0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$push26=, 1
	i64.const	$push25=, 1
	i64.add 	$push24=, $1, $pop25
	tee_local	$push23=, $2=, $pop24
	i64.lt_u	$push9=, $pop23, $1
	i64.extend_u/i32	$push10=, $pop9
	i64.eqz 	$push8=, $2
	i64.select	$push11=, $pop26, $pop10, $pop8
	i64.add 	$0=, $0, $pop11
	#APP
	#NO_APP
	copy_local	$1=, $2
	i64.const	$push22=, 11
	i64.xor 	$push12=, $2, $pop22
	i64.or  	$push13=, $0, $pop12
	i64.const	$push21=, 0
	i64.ne  	$push14=, $pop13, $pop21
	br_if   	0, $pop14       # 0: up to label1
.LBB0_2:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push27=, 0
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 16
	i32.add 	$push33=, $3, $pop32
	i32.store	$discard=, 0($pop34), $pop33
	return  	$pop27
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
