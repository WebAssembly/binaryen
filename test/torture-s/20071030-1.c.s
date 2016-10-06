	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20071030-1.c"
	.section	.text.CalcPing,"ax",@progbits
	.hidden	CalcPing
	.globl	CalcPing
	.type	CalcPing,@function
CalcPing:                               # @CalcPing
	.param  	i32
	.result 	i32
	.local  	f32, i32, i32, i32, f32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.then
	i32.load	$push10=, 4($0)
	return  	$pop10
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$4=, 0
	i32.const	$3=, 16
	f32.const	$5=, 0x0p0
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.add 	$push3=, $0, $3
	f32.load	$push19=, 0($pop3)
	tee_local	$push18=, $1=, $pop19
	f32.add 	$push4=, $5, $pop18
	f32.const	$push17=, 0x0p0
	f32.gt  	$push16=, $1, $pop17
	tee_local	$push15=, $2=, $pop16
	f32.select	$5=, $pop4, $5, $pop15
	i32.add 	$4=, $2, $4
	i32.const	$push14=, 24
	i32.add 	$push13=, $3, $pop14
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, 1552
	i32.ne  	$push5=, $pop12, $pop11
	br_if   	0, $pop5        # 0: up to label1
# BB#4:                                 # %for.end
	end_loop                        # label2:
	i32.const	$3=, 9999
	block
	i32.eqz 	$push20=, $4
	br_if   	0, $pop20       # 0: down to label3
# BB#5:                                 # %if.end9
	f32.convert_s/i32	$push6=, $4
	f32.div 	$push7=, $5, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$3=, $pop9
.LBB0_6:                                # %cleanup
	end_block                       # label3:
	copy_local	$push21=, $3
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end0:
	.size	CalcPing, .Lfunc_end0-CalcPing

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, i32, i32, i32, f32, i32
# BB#0:                                 # %if.end.i
	i32.const	$push17=, 0
	i32.const	$push14=, 0
	i32.load	$push15=, __stack_pointer($pop14)
	i32.const	$push16=, 1552
	i32.sub 	$push30=, $pop15, $pop16
	tee_local	$push29=, $5=, $pop30
	i32.store	__stack_pointer($pop17), $pop29
	i32.const	$3=, 0
	i32.const	$push21=, 8
	i32.add 	$push22=, $5, $pop21
	i32.const	$push28=, 0
	i32.const	$push0=, 1544
	i32.call	$drop=, memset@FUNCTION, $pop22, $pop28, $pop0
	i32.const	$2=, 16
	i32.const	$push23=, 8
	i32.add 	$push24=, $5, $pop23
	i32.const	$push27=, 16
	i32.add 	$push1=, $pop24, $pop27
	i32.const	$push2=, 1065353216
	i32.store	0($pop1), $pop2
	f32.const	$4=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push25=, 8
	i32.add 	$push26=, $5, $pop25
	i32.add 	$push3=, $pop26, $2
	f32.load	$push39=, 0($pop3)
	tee_local	$push38=, $0=, $pop39
	f32.add 	$push4=, $4, $pop38
	f32.const	$push37=, 0x0p0
	f32.gt  	$push36=, $0, $pop37
	tee_local	$push35=, $1=, $pop36
	f32.select	$4=, $pop4, $4, $pop35
	i32.add 	$3=, $1, $3
	i32.const	$push34=, 24
	i32.add 	$push33=, $2, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.const	$push31=, 1552
	i32.ne  	$push5=, $pop32, $pop31
	br_if   	0, $pop5        # 0: up to label4
# BB#2:                                 # %for.end.i
	end_loop                        # label5:
	block
	i32.eqz 	$push40=, $3
	br_if   	0, $pop40       # 0: down to label6
# BB#3:                                 # %CalcPing.exit
	f32.convert_s/i32	$push6=, $3
	f32.div 	$push7=, $4, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$push9=, $pop7, $pop8
	i32.trunc_s/f32	$push10=, $pop9
	i32.const	$push11=, 1000
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push20=, 0
	i32.const	$push18=, 1552
	i32.add 	$push19=, $5, $pop18
	i32.store	__stack_pointer($pop20), $pop19
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_5:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283501)"
	.functype	abort, void
