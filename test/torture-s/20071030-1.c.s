	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071030-1.c"
	.section	.text.CalcPing,"ax",@progbits
	.hidden	CalcPing
	.globl	CalcPing
	.type	CalcPing,@function
CalcPing:                               # @CalcPing
	.param  	i32
	.result 	i32
	.local  	i64, f32, f32, i32, i32, i32, f32
# BB#0:                                 # %entry
	i64.load	$1=, 0($0)
	f32.const	$2=, 0x0p0
	i32.const	$6=, 0
	i32.const	$5=, 16
	copy_local	$7=, $2
	block
	block
	i32.wrap/i64	$push0=, $1
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, 0        # 0: down to label1
# BB#1:                                 # %if.then
	i64.const	$push12=, 32
	i64.shr_u	$push13=, $1, $pop12
	i32.wrap/i64	$5=, $pop13
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop                            # label2:
	i32.add 	$push3=, $0, $5
	f32.load	$3=, 0($pop3)
	f32.gt  	$4=, $3, $2
	f32.add 	$push4=, $7, $3
	f32.select	$7=, $4, $pop4, $7
	i32.add 	$6=, $4, $6
	i32.const	$push5=, 24
	i32.add 	$5=, $5, $pop5
	i32.const	$push6=, 1552
	i32.ne  	$push7=, $5, $pop6
	br_if   	$pop7, 0        # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.const	$5=, 9999
	i32.const	$push14=, 0
	i32.eq  	$push15=, $6, $pop14
	br_if   	$pop15, 0       # 0: down to label0
# BB#4:                                 # %if.end9
	f32.convert_s/i32	$push8=, $6
	f32.div 	$push9=, $7, $pop8
	f32.const	$push10=, 0x1.f4p9
	f32.mul 	$push11=, $pop9, $pop10
	i32.trunc_s/f32	$5=, $pop11
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	return  	$5
	.endfunc
.Lfunc_end0:
	.size	CalcPing, .Lfunc_end0-CalcPing

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f32, i32, i32, i32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.end.i
	i32.const	$6=, __stack_pointer
	i32.load	$6=, 0($6)
	i32.const	$7=, 1552
	i32.sub 	$12=, $6, $7
	i32.const	$7=, __stack_pointer
	i32.store	$12=, 0($7), $12
	i32.const	$4=, 0
	i32.const	$push0=, 1544
	i32.const	$9=, 8
	i32.add 	$9=, $12, $9
	call    	memset@FUNCTION, $9, $4, $pop0
	f32.const	$0=, 0x0p0
	i32.const	$3=, 16
	i32.const	$10=, 8
	i32.add 	$10=, $12, $10
	i32.add 	$push1=, $10, $3
	i32.const	$push2=, 1065353216
	i32.store	$discard=, 0($pop1), $pop2
	copy_local	$5=, $0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$11=, 8
	i32.add 	$11=, $12, $11
	i32.add 	$push3=, $11, $3
	f32.load	$1=, 0($pop3)
	f32.gt  	$2=, $1, $0
	f32.add 	$push4=, $5, $1
	f32.select	$5=, $2, $pop4, $5
	i32.add 	$4=, $2, $4
	i32.const	$push5=, 24
	i32.add 	$3=, $3, $pop5
	i32.const	$push6=, 1552
	i32.ne  	$push7=, $3, $pop6
	br_if   	$pop7, 0        # 0: up to label4
# BB#2:                                 # %for.end.i
	end_loop                        # label5:
	block
	i32.const	$push16=, 0
	i32.eq  	$push17=, $4, $pop16
	br_if   	$pop17, 0       # 0: down to label6
# BB#3:                                 # %CalcPing.exit
	f32.convert_s/i32	$push8=, $4
	f32.div 	$push9=, $5, $pop8
	f32.const	$push10=, 0x1.f4p9
	f32.mul 	$push11=, $pop9, $pop10
	i32.trunc_s/f32	$push12=, $pop11
	i32.const	$push13=, 1000
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, 0       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push15=, 0
	i32.const	$8=, 1552
	i32.add 	$12=, $12, $8
	i32.const	$8=, __stack_pointer
	i32.store	$12=, 0($8), $12
	return  	$pop15
.LBB1_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
