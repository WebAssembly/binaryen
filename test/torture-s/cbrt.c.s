	.text
	.file	"cbrt.c"
	.section	.text.cbrtl,"ax",@progbits
	.hidden	cbrtl                   # -- Begin function cbrtl
	.globl	cbrtl
	.type	cbrtl,@function
cbrtl:                                  # @cbrtl
	.param  	f64
	.result 	f64
	.local  	i64, i32, i32, f64, f64, f64, i32
# %bb.0:                                # %entry
	i32.const	$push61=, 0
	i32.load	$push60=, __stack_pointer($pop61)
	i32.const	$push62=, 16
	i32.sub 	$7=, $pop60, $pop62
	f64.store	0($7), $0
	i64.const	$push0=, 0
	i64.store	8($7), $pop0
	i64.reinterpret/f64	$1=, $0
	i64.const	$push1=, 32
	i64.shr_u	$push2=, $1, $pop1
	i32.wrap/i64	$3=, $pop2
	i32.const	$push4=, 2147483647
	i32.and 	$2=, $3, $pop4
	block   	
	i32.const	$push5=, 2146435072
	i32.lt_u	$push6=, $2, $pop5
	br_if   	0, $pop6        # 0: down to label0
# %bb.1:                                # %if.then
	f64.add 	$push63=, $0, $0
	return  	$pop63
.LBB0_2:                                # %if.end
	end_block                       # label0:
	block   	
	i32.wrap/i64	$push7=, $1
	i32.or  	$push8=, $2, $pop7
	i32.eqz 	$push65=, $pop8
	br_if   	0, $pop65       # 0: down to label1
# %bb.3:                                # %if.end13
	i32.const	$push3=, -2147483648
	i32.and 	$3=, $3, $pop3
	i32.store	4($7), $2
	block   	
	block   	
	i32.const	$push9=, 1048575
	i32.gt_u	$push10=, $2, $pop9
	br_if   	0, $pop10       # 0: down to label3
# %bb.4:                                # %if.then18
	i32.const	$push15=, 1129316352
	i32.store	12($7), $pop15
	f64.load	$push16=, 8($7)
	f64.mul 	$6=, $pop16, $0
	f64.store	8($7), $6
	i64.reinterpret/f64	$push17=, $6
	i64.const	$push18=, 32
	i64.shr_u	$push19=, $pop17, $pop18
	i32.wrap/i64	$push20=, $pop19
	i32.const	$push21=, 3
	i32.div_u	$push22=, $pop20, $pop21
	i32.const	$push23=, 696219795
	i32.add 	$push24=, $pop22, $pop23
	i32.store	12($7), $pop24
	br      	1               # 1: down to label2
.LBB0_5:                                # %if.else
	end_block                       # label3:
	i32.const	$push11=, 3
	i32.div_u	$push12=, $2, $pop11
	i32.const	$push13=, 715094163
	i32.add 	$push14=, $pop12, $pop13
	i32.store	12($7), $pop14
.LBB0_6:                                # %if.end31
	end_block                       # label2:
	f64.load	$6=, 8($7)
	f64.load	$4=, 0($7)
	f64.mul 	$push25=, $6, $6
	f64.div 	$push26=, $pop25, $4
	f64.mul 	$push27=, $6, $pop26
	f64.const	$push28=, 0x1.15f15f15f15f1p-1
	f64.add 	$5=, $pop27, $pop28
	f64.const	$push34=, 0x1.9b6db6db6db6ep0
	f64.const	$push31=, 0x1.6a0ea0ea0ea0fp0
	f64.add 	$push32=, $5, $pop31
	f64.const	$push29=, -0x1.691de2532c834p-1
	f64.div 	$push30=, $pop29, $5
	f64.add 	$push33=, $pop32, $pop30
	f64.div 	$push35=, $pop34, $pop33
	f64.const	$push36=, 0x1.6db6db6db6db7p-2
	f64.add 	$push37=, $pop35, $pop36
	f64.mul 	$6=, $6, $pop37
	f64.store	8($7), $6
	i32.const	$push38=, 0
	i32.store	8($7), $pop38
	i64.reinterpret/f64	$push39=, $6
	i64.const	$push40=, 32
	i64.shr_u	$push41=, $pop39, $pop40
	i32.wrap/i64	$push42=, $pop41
	i32.const	$push43=, 1
	i32.add 	$push44=, $pop42, $pop43
	i32.store	12($7), $pop44
	f64.load	$6=, 8($7)
	f64.mul 	$push45=, $6, $6
	f64.div 	$4=, $4, $pop45
	f64.sub 	$push48=, $4, $6
	f64.add 	$push46=, $6, $6
	f64.add 	$push47=, $pop46, $4
	f64.div 	$push49=, $pop48, $pop47
	f64.mul 	$push50=, $6, $pop49
	f64.add 	$6=, $6, $pop50
	f64.store	8($7), $6
	i64.reinterpret/f64	$push51=, $6
	i64.const	$push64=, 32
	i64.shr_u	$push52=, $pop51, $pop64
	i32.wrap/i64	$push53=, $pop52
	i32.or  	$push54=, $3, $pop53
	i32.store	12($7), $pop54
	f64.load	$6=, 8($7)
	f64.mul 	$push55=, $6, $6
	f64.div 	$push56=, $0, $pop55
	f64.sub 	$push57=, $6, $pop56
	f64.const	$push58=, -0x1.5555555555555p-2
	f64.mul 	$push59=, $pop57, $pop58
	f64.add 	$0=, $6, $pop59
.LBB0_7:                                # %cleanup
	end_block                       # label1:
	copy_local	$push66=, $0
                                        # fallthrough-return: $pop66
	.endfunc
.Lfunc_end0:
	.size	cbrtl, .Lfunc_end0-cbrtl
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
