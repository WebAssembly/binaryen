	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071030-1.c"
	.section	.text.CalcPing,"ax",@progbits
	.hidden	CalcPing
	.globl	CalcPing
	.type	CalcPing,@function
CalcPing:                               # @CalcPing
	.param  	i32
	.result 	i32
	.local  	i32, i32, f32, i64, i32, f32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$1=, 16
	f32.const	$3=, 0x0p0
	block
	block
	i64.load	$push15=, 0($0)
	tee_local	$push14=, $4=, $pop15
	i32.wrap/i64	$push0=, $pop14
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %if.then
	i64.const	$push12=, 32
	i64.shr_u	$push13=, $4, $pop12
	i32.wrap/i64	$1=, $pop13
	br      	1               # 1: down to label0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label1:
	loop                            # label2:
	i32.add 	$push3=, $0, $1
	f32.load	$push20=, 0($pop3):p2align=3
	tee_local	$push19=, $6=, $pop20
	f32.add 	$push4=, $3, $pop19
	f32.const	$push18=, 0x0p0
	f32.gt  	$push17=, $6, $pop18
	tee_local	$push16=, $5=, $pop17
	f32.select	$3=, $pop4, $3, $pop16
	i32.add 	$2=, $5, $2
	i32.const	$push5=, 24
	i32.add 	$1=, $1, $pop5
	i32.const	$push6=, 1552
	i32.ne  	$push7=, $1, $pop6
	br_if   	0, $pop7        # 0: up to label2
# BB#3:                                 # %for.end
	end_loop                        # label3:
	i32.const	$1=, 9999
	i32.const	$push21=, 0
	i32.eq  	$push22=, $2, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#4:                                 # %if.end9
	f32.convert_s/i32	$push8=, $2
	f32.div 	$push9=, $3, $pop8
	f32.const	$push10=, 0x1.f4p9
	f32.mul 	$push11=, $pop9, $pop10
	i32.trunc_s/f32	$1=, $pop11
.LBB0_5:                                # %cleanup
	end_block                       # label0:
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	CalcPing, .Lfunc_end0-CalcPing

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, f32, i32, f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.end.i
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 1552
	i32.sub 	$11=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$11=, 0($6), $11
	i32.const	$1=, 0
	i32.const	$push15=, 0
	i32.const	$push0=, 1544
	i32.const	$8=, 8
	i32.add 	$8=, $11, $8
	i32.call	$discard=, memset@FUNCTION, $8, $pop15, $pop0
	i32.const	$0=, 16
	i32.const	$push14=, 16
	i32.const	$9=, 8
	i32.add 	$9=, $11, $9
	i32.add 	$push1=, $9, $pop14
	i32.const	$push2=, 1065353216
	i32.store	$discard=, 0($pop1):p2align=3, $pop2
	f32.const	$2=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$10=, 8
	i32.add 	$10=, $11, $10
	i32.add 	$push3=, $10, $0
	f32.load	$push22=, 0($pop3):p2align=3
	tee_local	$push21=, $4=, $pop22
	f32.add 	$push4=, $2, $pop21
	f32.const	$push20=, 0x0p0
	f32.gt  	$push19=, $4, $pop20
	tee_local	$push18=, $3=, $pop19
	f32.select	$2=, $pop4, $2, $pop18
	i32.add 	$1=, $3, $1
	i32.const	$push17=, 24
	i32.add 	$0=, $0, $pop17
	i32.const	$push16=, 1552
	i32.ne  	$push5=, $0, $pop16
	br_if   	0, $pop5        # 0: up to label4
# BB#2:                                 # %for.end.i
	end_loop                        # label5:
	block
	i32.const	$push23=, 0
	i32.eq  	$push24=, $1, $pop23
	br_if   	0, $pop24       # 0: down to label6
# BB#3:                                 # %CalcPing.exit
	f32.convert_s/i32	$push6=, $1
	f32.div 	$push7=, $2, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$push10=, $pop9
	i32.const	$push11=, 1000
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push13=, 0
	i32.const	$7=, 1552
	i32.add 	$11=, $11, $7
	i32.const	$7=, __stack_pointer
	i32.store	$11=, 0($7), $11
	return  	$pop13
.LBB1_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
