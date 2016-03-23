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
	block
	i64.load	$push13=, 0($0)
	tee_local	$push12=, $4=, $pop13
	i32.wrap/i64	$push0=, $pop12
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push10=, 32
	i64.shr_u	$push11=, $4, $pop10
	i32.wrap/i64	$1=, $pop11
	return  	$1
.LBB0_2:
	end_block                       # label0:
	f32.const	$3=, 0x0p0
	i32.const	$2=, 0
	i32.const	$1=, 16
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push3=, $0, $1
	f32.load	$push20=, 0($pop3):p2align=3
	tee_local	$push19=, $6=, $pop20
	f32.add 	$push4=, $3, $pop19
	f32.const	$push18=, 0x0p0
	f32.gt  	$push17=, $6, $pop18
	tee_local	$push16=, $5=, $pop17
	f32.select	$3=, $pop4, $3, $pop16
	i32.add 	$2=, $5, $2
	i32.const	$push15=, 24
	i32.add 	$1=, $1, $pop15
	i32.const	$push14=, 1552
	i32.ne  	$push5=, $1, $pop14
	br_if   	0, $pop5        # 0: up to label1
# BB#4:                                 # %for.end
	end_loop                        # label2:
	i32.const	$1=, 9999
	block
	i32.const	$push21=, 0
	i32.eq  	$push22=, $2, $pop21
	br_if   	0, $pop22       # 0: down to label3
# BB#5:                                 # %if.end9
	f32.convert_s/i32	$push6=, $2
	f32.div 	$push7=, $3, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$1=, $pop9
.LBB0_6:                                # %cleanup
	end_block                       # label3:
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
	.local  	i32, i32, f32, i32, f32, i32
# BB#0:                                 # %if.end.i
	i32.const	$push23=, __stack_pointer
	i32.load	$push24=, 0($pop23)
	i32.const	$push25=, 1552
	i32.sub 	$5=, $pop24, $pop25
	i32.const	$push26=, __stack_pointer
	i32.store	$discard=, 0($pop26), $5
	i32.const	$1=, 0
	i32.const	$push30=, 8
	i32.add 	$push31=, $5, $pop30
	i32.const	$push15=, 0
	i32.const	$push0=, 1544
	i32.call	$discard=, memset@FUNCTION, $pop31, $pop15, $pop0
	i32.const	$0=, 16
	i32.const	$push32=, 8
	i32.add 	$push33=, $5, $pop32
	i32.const	$push14=, 16
	i32.add 	$push1=, $pop33, $pop14
	i32.const	$push2=, 1065353216
	i32.store	$discard=, 0($pop1):p2align=3, $pop2
	f32.const	$2=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push34=, 8
	i32.add 	$push35=, $5, $pop34
	i32.add 	$push3=, $pop35, $0
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
	i32.const	$push36=, 0
	i32.eq  	$push37=, $1, $pop36
	br_if   	0, $pop37       # 0: down to label6
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
	i32.const	$push29=, __stack_pointer
	i32.const	$push27=, 1552
	i32.add 	$push28=, $5, $pop27
	i32.store	$discard=, 0($pop29), $pop28
	return  	$pop13
.LBB1_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
