	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49218.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i64, i32, i64, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 16
	i32.sub 	$9=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$9=, 0($7), $9
	i32.const	$push18=, 0
	f32.load	$push0=, f($pop18)
	call    	__fixsfti@FUNCTION, $9, $pop0
	i64.const	$1=, 0
	block
	i64.load	$push17=, 0($9)
	tee_local	$push16=, $5=, $pop17
	i64.const	$push5=, 10
	i64.gt_u	$push6=, $pop16, $pop5
	i32.const	$push1=, 8
	i32.add 	$push2=, $9, $pop1
	i64.load	$push15=, 0($pop2)
	tee_local	$push14=, $4=, $pop15
	i64.const	$push13=, 0
	i64.gt_s	$push4=, $pop14, $pop13
	i64.const	$push12=, 0
	i64.eq  	$push3=, $4, $pop12
	i32.select	$push7=, $pop6, $pop4, $pop3
	br_if   	0, $pop7        # 0: down to label0
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i64.const	$2=, 1
	i64.add 	$0=, $5, $2
	i64.lt_u	$3=, $0, $5
	i64.extend_u/i32	$5=, $3
	i64.eq  	$3=, $0, $1
	i64.select	$5=, $2, $5, $3
	i64.add 	$4=, $4, $5
	#APP
	#NO_APP
	copy_local	$5=, $0
	i64.const	$push8=, 11
	i64.xor 	$push9=, $0, $pop8
	i64.or  	$push10=, $4, $pop9
	i64.const	$push19=, 0
	i64.ne  	$push11=, $pop10, $pop19
	br_if   	0, $pop11       # 0: up to label1
.LBB0_2:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push20=, 0
	i32.const	$8=, 16
	i32.add 	$9=, $9, $8
	i32.const	$8=, __stack_pointer
	i32.store	$9=, 0($8), $9
	return  	$pop20
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
