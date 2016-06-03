	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071030-1.c"
	.section	.text.CalcPing,"ax",@progbits
	.hidden	CalcPing
	.globl	CalcPing
	.type	CalcPing,@function
CalcPing:                               # @CalcPing
	.param  	i32
	.result 	i32
	.local  	i64, f32, i32, i32, i32, f32
# BB#0:                                 # %entry
	block
	i64.load	$push14=, 0($0)
	tee_local	$push13=, $1=, $pop14
	i32.wrap/i64	$push0=, $pop13
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push10=, 32
	i64.shr_u	$push11=, $1, $pop10
	i32.wrap/i64	$push12=, $pop11
	return  	$pop12
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$5=, 0
	i32.const	$4=, 16
	f32.const	$6=, 0x0p0
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push3=, $0, $4
	f32.load	$push23=, 0($pop3)
	tee_local	$push22=, $2=, $pop23
	f32.add 	$push4=, $6, $pop22
	f32.const	$push21=, 0x0p0
	f32.gt  	$push20=, $2, $pop21
	tee_local	$push19=, $3=, $pop20
	f32.select	$6=, $pop4, $6, $pop19
	i32.add 	$5=, $3, $5
	i32.const	$push18=, 24
	i32.add 	$push17=, $4, $pop18
	tee_local	$push16=, $4=, $pop17
	i32.const	$push15=, 1552
	i32.ne  	$push5=, $pop16, $pop15
	br_if   	0, $pop5        # 0: up to label1
# BB#4:                                 # %for.end
	end_loop                        # label2:
	i32.const	$4=, 9999
	block
	i32.eqz 	$push24=, $5
	br_if   	0, $pop24       # 0: down to label3
# BB#5:                                 # %if.end9
	f32.convert_s/i32	$push6=, $5
	f32.div 	$push7=, $6, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$4=, $pop9
.LBB0_6:                                # %cleanup
	end_block                       # label3:
	copy_local	$push25=, $4
                                        # fallthrough-return: $pop25
	.endfunc
.Lfunc_end0:
	.size	CalcPing, .Lfunc_end0-CalcPing

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f32, i32, i32, i32, f32
# BB#0:                                 # %if.end.i
	i32.const	$4=, 0
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 1552
	i32.sub 	$push27=, $pop15, $pop16
	i32.store	$push31=, __stack_pointer($pop17), $pop27
	tee_local	$push30=, $0=, $pop31
	i32.const	$push21=, 8
	i32.add 	$push22=, $pop30, $pop21
	i32.const	$push29=, 0
	i32.const	$push0=, 1544
	i32.call	$drop=, memset@FUNCTION, $pop22, $pop29, $pop0
	i32.const	$3=, 16
	i32.const	$push23=, 8
	i32.add 	$push24=, $0, $pop23
	i32.const	$push28=, 16
	i32.add 	$push1=, $pop24, $pop28
	i32.const	$push2=, 1065353216
	i32.store	$drop=, 0($pop1), $pop2
	f32.const	$5=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push25=, 8
	i32.add 	$push26=, $0, $pop25
	i32.add 	$push3=, $pop26, $3
	f32.load	$push40=, 0($pop3)
	tee_local	$push39=, $1=, $pop40
	f32.add 	$push4=, $5, $pop39
	f32.const	$push38=, 0x0p0
	f32.gt  	$push37=, $1, $pop38
	tee_local	$push36=, $2=, $pop37
	f32.select	$5=, $pop4, $5, $pop36
	i32.add 	$4=, $2, $4
	i32.const	$push35=, 24
	i32.add 	$push34=, $3, $pop35
	tee_local	$push33=, $3=, $pop34
	i32.const	$push32=, 1552
	i32.ne  	$push5=, $pop33, $pop32
	br_if   	0, $pop5        # 0: up to label4
# BB#2:                                 # %for.end.i
	end_loop                        # label5:
	block
	i32.eqz 	$push41=, $4
	br_if   	0, $pop41       # 0: down to label6
# BB#3:                                 # %CalcPing.exit
	f32.convert_s/i32	$push6=, $4
	f32.div 	$push7=, $5, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$push10=, $pop9
	i32.const	$push11=, 1000
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push20=, 0
	i32.const	$push18=, 1552
	i32.add 	$push19=, $0, $pop18
	i32.store	$drop=, __stack_pointer($pop20), $pop19
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
	.functype	abort, void
