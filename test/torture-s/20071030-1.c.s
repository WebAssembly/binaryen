	.text
	.file	"20071030-1.c"
	.section	.text.CalcPing,"ax",@progbits
	.hidden	CalcPing                # -- Begin function CalcPing
	.globl	CalcPing
	.type	CalcPing,@function
CalcPing:                               # @CalcPing
	.param  	i32
	.result 	i32
	.local  	f32, i32, i32, i32, f32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.then
	i32.load	$push15=, 4($0)
	return  	$pop15
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$4=, 0
	i32.const	$3=, 16
	f32.const	$5=, 0x0p0
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.add 	$push3=, $0, $3
	f32.load	$1=, 0($pop3)
	f32.const	$push18=, 0x0p0
	f32.gt  	$2=, $1, $pop18
	f32.add 	$push4=, $5, $1
	f32.select	$5=, $pop4, $5, $2
	i32.add 	$4=, $4, $2
	i32.const	$push17=, 24
	i32.add 	$3=, $3, $pop17
	i32.const	$push16=, 1552
	i32.ne  	$push5=, $3, $pop16
	br_if   	0, $pop5        # 0: up to label1
# %bb.4:                                # %for.end
	end_loop
	block   	
	block   	
	i32.eqz 	$push19=, $4
	br_if   	0, $pop19       # 0: down to label3
# %bb.5:                                # %if.end9
	f32.convert_s/i32	$push6=, $4
	f32.div 	$push7=, $5, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$5=, $pop7, $pop8
	f32.abs 	$push9=, $5
	f32.const	$push10=, 0x1p31
	f32.lt  	$push11=, $pop9, $pop10
	br_if   	1, $pop11       # 1: down to label2
# %bb.6:                                # %if.end9
	i32.const	$push12=, -2147483648
	return  	$pop12
.LBB0_7:
	end_block                       # label3:
	i32.const	$push14=, 9999
	return  	$pop14
.LBB0_8:                                # %if.end9
	end_block                       # label2:
	i32.trunc_s/f32	$push13=, $5
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end0:
	.size	CalcPing, .Lfunc_end0-CalcPing
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, i32, i32, i32, f32, i32
# %bb.0:                                # %if.end.i
	i32.const	$push16=, 0
	i32.load	$push15=, __stack_pointer($pop16)
	i32.const	$push17=, 1552
	i32.sub 	$5=, $pop15, $pop17
	i32.const	$push18=, 0
	i32.store	__stack_pointer($pop18), $5
	i32.const	$3=, 0
	i32.const	$push22=, 8
	i32.add 	$push23=, $5, $pop22
	i32.const	$push29=, 0
	i32.const	$push0=, 1544
	i32.call	$drop=, memset@FUNCTION, $pop23, $pop29, $pop0
	i32.const	$2=, 16
	i32.const	$push24=, 8
	i32.add 	$push25=, $5, $pop24
	i32.const	$push28=, 16
	i32.add 	$push1=, $pop25, $pop28
	i32.const	$push2=, 1065353216
	i32.store	0($pop1), $pop2
	f32.const	$4=, 0x0p0
.LBB1_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push26=, 8
	i32.add 	$push27=, $5, $pop26
	i32.add 	$push3=, $pop27, $2
	f32.load	$0=, 0($pop3)
	f32.const	$push32=, 0x0p0
	f32.gt  	$1=, $0, $pop32
	f32.add 	$push4=, $4, $0
	f32.select	$4=, $pop4, $4, $1
	i32.add 	$3=, $3, $1
	i32.const	$push31=, 24
	i32.add 	$2=, $2, $pop31
	i32.const	$push30=, 1552
	i32.ne  	$push5=, $2, $pop30
	br_if   	0, $pop5        # 0: up to label4
# %bb.2:                                # %for.end.i
	end_loop
	block   	
	i32.eqz 	$push33=, $3
	br_if   	0, $pop33       # 0: down to label5
# %bb.3:                                # %CalcPing.exit
	f32.convert_s/i32	$push6=, $3
	f32.div 	$push7=, $4, $pop6
	f32.const	$push8=, 0x1.f4p9
	f32.mul 	$4=, $pop7, $pop8
	block   	
	block   	
	f32.abs 	$push12=, $4
	f32.const	$push13=, 0x1p31
	f32.lt  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label7
# %bb.4:                                # %CalcPing.exit
	i32.const	$2=, -2147483648
	br      	1               # 1: down to label6
.LBB1_5:                                # %CalcPing.exit
	end_block                       # label7:
	i32.trunc_s/f32	$2=, $4
.LBB1_6:                                # %CalcPing.exit
	end_block                       # label6:
	i32.const	$push9=, 1000
	i32.ne  	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label5
# %bb.7:                                # %if.end
	i32.const	$push21=, 0
	i32.const	$push19=, 1552
	i32.add 	$push20=, $5, $pop19
	i32.store	__stack_pointer($pop21), $pop20
	i32.const	$push11=, 0
	return  	$pop11
.LBB1_8:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
