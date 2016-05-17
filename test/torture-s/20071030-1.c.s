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
	i64.load	$push14=, 0($0)
	tee_local	$push13=, $4=, $pop14
	i32.wrap/i64	$push0=, $pop13
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push10=, 32
	i64.shr_u	$push11=, $4, $pop10
	i32.wrap/i64	$push12=, $pop11
	return  	$pop12
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$2=, 0
	i32.const	$1=, 16
	f32.const	$3=, 0x0p0
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push3=, $0, $1
	f32.load	$push21=, 0($pop3)
	tee_local	$push20=, $6=, $pop21
	f32.add 	$push4=, $3, $pop20
	f32.const	$push19=, 0x0p0
	f32.gt  	$push18=, $6, $pop19
	tee_local	$push17=, $5=, $pop18
	f32.select	$3=, $pop4, $3, $pop17
	i32.add 	$2=, $5, $2
	i32.const	$push16=, 24
	i32.add 	$1=, $1, $pop16
	i32.const	$push15=, 1552
	i32.ne  	$push5=, $1, $pop15
	br_if   	0, $pop5        # 0: up to label1
# BB#4:                                 # %for.end
	end_loop                        # label2:
	i32.const	$1=, 9999
	block
	i32.eqz 	$push22=, $2
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
	.local  	i32, i32, f32, i32, i32, f32
# BB#0:                                 # %if.end.i
	i32.const	$1=, 0
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 1552
	i32.sub 	$push27=, $pop15, $pop16
	i32.store	$push31=, 0($pop17), $pop27
	tee_local	$push30=, $3=, $pop31
	i32.const	$push21=, 8
	i32.add 	$push22=, $pop30, $pop21
	i32.const	$push29=, 0
	i32.const	$push0=, 1544
	i32.call	$drop=, memset@FUNCTION, $pop22, $pop29, $pop0
	i32.const	$0=, 16
	i32.const	$push23=, 8
	i32.add 	$push24=, $3, $pop23
	i32.const	$push28=, 16
	i32.add 	$push1=, $pop24, $pop28
	i32.const	$push2=, 1065353216
	i32.store	$drop=, 0($pop1), $pop2
	f32.const	$2=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push25=, 8
	i32.add 	$push26=, $3, $pop25
	i32.add 	$push3=, $pop26, $0
	f32.load	$push38=, 0($pop3)
	tee_local	$push37=, $5=, $pop38
	f32.add 	$push4=, $2, $pop37
	f32.const	$push36=, 0x0p0
	f32.gt  	$push35=, $5, $pop36
	tee_local	$push34=, $4=, $pop35
	f32.select	$2=, $pop4, $2, $pop34
	i32.add 	$1=, $4, $1
	i32.const	$push33=, 24
	i32.add 	$0=, $0, $pop33
	i32.const	$push32=, 1552
	i32.ne  	$push5=, $0, $pop32
	br_if   	0, $pop5        # 0: up to label4
# BB#2:                                 # %for.end.i
	end_loop                        # label5:
	block
	i32.eqz 	$push39=, $1
	br_if   	0, $pop39       # 0: down to label6
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
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 1552
	i32.add 	$push19=, $3, $pop18
	i32.store	$drop=, 0($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
